import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';
import 'package:pfm_budget_app/features/cycles/data/cycle_repository.dart';
import 'package:pfm_budget_app/features/history/data/backup_service.dart';
import 'package:pfm_budget_app/features/history/data/report_export_service.dart';
import 'package:pfm_budget_app/features/meals/data/meal_repository.dart';
import 'package:pfm_budget_app/features/notifications/data/budget_notification_service.dart';
import 'package:pfm_budget_app/features/security/data/app_lock_service.dart';
import 'package:pfm_budget_app/features/updates/data/app_update_service.dart';
import 'package:pfm_budget_app/features/updates/domain/app_update_models.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final keyValueStoreProvider = Provider<KeyValueStore>((ref) {
  return SecureKeyValueStore();
});

final preferencesRepositoryProvider = Provider<AppPreferencesRepository>((ref) {
  return AppPreferencesRepository(ref.watch(keyValueStoreProvider));
});

class PreferencesNotifier extends StateNotifier<AppPreferencesState> {
  PreferencesNotifier(this._repo) : super(const AppPreferencesState());

  final AppPreferencesRepository _repo;
  bool _loaded = false;
  bool get isLoaded => _loaded;

  Future<void> load() async {
    state = await _repo.load();
    _loaded = true;
  }

  Future<void> setCycleStartDay(int day, {bool clearPending = true}) async {
    await _repo.setCycleStartDay(day);
    if (clearPending) {
      await _repo.setPendingNextCycleStartDay(null);
    }
    state = state.copyWith(
      cycleStartDay: day,
      clearPendingStartDay: clearPending,
    );
  }

  Future<void> setPendingNextCycleStartDay(int? day) async {
    await _repo.setPendingNextCycleStartDay(day);
    state = state.copyWith(
      pendingNextCycleStartDay: day,
      clearPendingStartDay: day == null,
    );
  }

  Future<void> setCurrencyFormat(CurrencyFormatStyle style) async {
    await _repo.setCurrencyFormat(style);
    state = state.copyWith(currencyFormat: style);
  }

  Future<void> setMealSyncTarget(MealSyncTarget target) async {
    await _repo.setMealSyncTarget(target);
    state = state.copyWith(mealSyncTarget: target);
  }

  Future<void> setAppLockEnabled(bool enabled) async {
    await _repo.setAppLockEnabled(enabled);
    state = state.copyWith(appLockEnabled: enabled);
  }

  Future<void> setBiometricsEnabled(bool enabled) async {
    await _repo.setBiometricsEnabled(enabled);
    state = state.copyWith(biometricsEnabled: enabled);
  }

  Future<void> setPin(String pin) async {
    await _repo.setPin(pin);
    state = state.copyWith(hasPin: true);
  }

  Future<void> clearPin() async {
    await _repo.clearPin();
    state = state.copyWith(hasPin: false, appLockEnabled: false);
    await _repo.setAppLockEnabled(false);
  }

  Future<void> setNotifyCycleStart(bool enabled) async {
    await _repo.setNotifyCycleStart(enabled);
    state = state.copyWith(notifyCycleStart: enabled);
  }

  Future<void> setNotifyThreshold80(bool enabled) async {
    await _repo.setNotifyThreshold80(enabled);
    state = state.copyWith(notifyThreshold80: enabled);
  }

  Future<void> setNotifyThreshold100(bool enabled) async {
    await _repo.setNotifyThreshold100(enabled);
    state = state.copyWith(notifyThreshold100: enabled);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    await _repo.setThemeMode(mode);
    state = state.copyWith(themeMode: mode);
  }

  Future<void> setDefaultSalary(double salary) async {
    await _repo.setDefaultSalary(salary);
    state = state.copyWith(defaultSalary: salary);
  }

  Future<void> setGithubUpdateRepo(String repo) async {
    final trimmed = repo.trim();
    await _repo.setGithubUpdateRepo(trimmed);
    state = state.copyWith(githubUpdateRepo: trimmed);
  }

  Future<void> setAutoCheckUpdates(bool enabled) async {
    await _repo.setAutoCheckUpdates(enabled);
    state = state.copyWith(autoCheckUpdates: enabled);
  }
}

final preferencesProvider =
    StateNotifierProvider<PreferencesNotifier, AppPreferencesState>((ref) {
  return PreferencesNotifier(ref.watch(preferencesRepositoryProvider));
});

final cycleRepositoryProvider = Provider<CycleRepository>((ref) {
  return CycleRepository(ref.watch(appDatabaseProvider));
});

final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepository(ref.watch(appDatabaseProvider));
});

final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(ref.watch(appDatabaseProvider));
});

final notificationServiceProvider = Provider<BudgetNotificationService>((ref) {
  return BudgetNotificationService();
});

final reportExportServiceProvider = Provider<ReportExportService>((ref) {
  return ReportExportService();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(ref.watch(appDatabaseProvider));
});

final appLockServiceProvider = Provider<AppLockService>((ref) {
  return AppLockService(preferences: ref.watch(preferencesRepositoryProvider));
});

final appUpdateServiceProvider = Provider<AppUpdateService>((ref) {
  return AppUpdateService();
});

final installedVersionProvider = FutureProvider<SemanticVersion>((ref) {
  return ref.watch(appUpdateServiceProvider).getInstalledVersion();
});

class UpdateCheckNotifier extends StateNotifier<AsyncValue<UpdateCheckResult?>> {
  UpdateCheckNotifier(this._ref) : super(const AsyncData(null));

  final Ref _ref;

  Future<UpdateCheckResult> checkNow() async {
    state = const AsyncLoading();
    final repo = _ref.read(preferencesProvider).githubUpdateRepo;
    final result = await _ref
        .read(appUpdateServiceProvider)
        .checkForUpdate(githubRepo: repo);
    if (mounted) {
      state = AsyncData(result);
    }
    return result;
  }

  void dismissUpdateBanner() {
    state = const AsyncData(null);
  }
}

final updateCheckProvider = StateNotifierProvider<UpdateCheckNotifier,
    AsyncValue<UpdateCheckResult?>>((ref) {
  return UpdateCheckNotifier(ref);
});

/// Tracks whether the user has unlocked the app in the current session.
final isUnlockedProvider = StateProvider<bool>((ref) => true);

/// Bootstrap provider: loads preferences, seeds initial DB, syncs Food, initializes alerts.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  final prefsNotifier = ref.read(preferencesProvider.notifier);
  await prefsNotifier.load();
  final prefs = ref.read(preferencesProvider);

  final db = ref.read(appDatabaseProvider);
  await db.seedIfEmpty(
    startDay: prefs.cycleStartDay,
    salary: prefs.defaultSalary,
  );

  final activeCycle = await ref.read(cycleRepositoryProvider).getActiveCycle();
  if (activeCycle != null) {
    await ref.read(mealRepositoryProvider).syncFoodSubsectionForCycle(
          activeCycle.id,
          prefs.mealSyncTarget,
        );
  }

  if (prefs.appLockEnabled && (prefs.hasPin || prefs.biometricsEnabled)) {
    ref.read(isUnlockedProvider.notifier).state = false;
  }

  await ref.read(notificationServiceProvider).initialize();
});

final activeCycleProvider = StreamProvider<BudgetCycle?>((ref) {
  return ref.watch(cycleRepositoryProvider).watchActiveCycle();
});

final archivedCyclesProvider = StreamProvider<List<BudgetCycle>>((ref) {
  return ref.watch(cycleRepositoryProvider).watchArchivedCycles();
});

final cycleBudgetSnapshotProvider =
    StreamProvider.family<CycleBudgetSnapshot?, int>((ref, cycleId) {
  return ref.watch(budgetRepositoryProvider).watchCycleBudgetSnapshot(cycleId);
});

final activeBudgetSnapshotProvider = StreamProvider<CycleBudgetSnapshot?>((ref) {
  final activeCycle = ref.watch(activeCycleProvider).valueOrNull;
  if (activeCycle == null) return Stream.value(null);
  return ref
      .watch(budgetRepositoryProvider)
      .watchCycleBudgetSnapshot(activeCycle.id);
});

final cycleMealPlanProvider =
    StreamProvider.family<CycleMealPlanSnapshot, int>((ref, cycleId) {
  return ref.watch(mealRepositoryProvider).watchCycleMealPlan(cycleId);
});

final activeMealPlanProvider = StreamProvider<CycleMealPlanSnapshot?>((ref) {
  final activeCycle = ref.watch(activeCycleProvider).valueOrNull;
  if (activeCycle == null) return Stream.value(null);
  return ref.watch(mealRepositoryProvider).watchCycleMealPlan(activeCycle.id);
});

final subsectionEntriesProvider =
    StreamProvider.family<List<SubsectionEntry>, int>((ref, subsectionId) {
  return ref
      .watch(budgetRepositoryProvider)
      .watchEntriesForSubsection(subsectionId);
});
