import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/features/updates/data/app_update_service.dart';

enum MealSyncTarget {
  actual('actual', 'Food Actual Amount'),
  allocated('allocated', 'Food Allocated Budget');

  const MealSyncTarget(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static MealSyncTarget fromKey(String? key) {
    return MealSyncTarget.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => MealSyncTarget.actual,
    );
  }
}

class AppPreferencesState {
  const AppPreferencesState({
    this.cycleStartDay = 25,
    this.pendingNextCycleStartDay,
    this.currencyFormat = CurrencyFormatStyle.slashEquals,
    this.mealSyncTarget = MealSyncTarget.actual,
    this.appLockEnabled = false,
    this.biometricsEnabled = false,
    this.hasPin = false,
    this.notifyCycleStart = true,
    this.notifyThreshold80 = true,
    this.notifyThreshold100 = true,
    this.themeMode = ThemeMode.system,
    this.defaultSalary = 72000.0,
    this.githubUpdateRepo = AppUpdateService.compileTimeDefaultRepo,
    this.autoCheckUpdates = true,
  });

  final int cycleStartDay;
  final int? pendingNextCycleStartDay;
  final CurrencyFormatStyle currencyFormat;
  final MealSyncTarget mealSyncTarget;
  final bool appLockEnabled;
  final bool biometricsEnabled;
  final bool hasPin;
  final bool notifyCycleStart;
  final bool notifyThreshold80;
  final bool notifyThreshold100;
  final ThemeMode themeMode;
  final double defaultSalary;
  final String githubUpdateRepo;
  final bool autoCheckUpdates;

  AppPreferencesState copyWith({
    int? cycleStartDay,
    int? pendingNextCycleStartDay,
    bool clearPendingStartDay = false,
    CurrencyFormatStyle? currencyFormat,
    MealSyncTarget? mealSyncTarget,
    bool? appLockEnabled,
    bool? biometricsEnabled,
    bool? hasPin,
    bool? notifyCycleStart,
    bool? notifyThreshold80,
    bool? notifyThreshold100,
    ThemeMode? themeMode,
    double? defaultSalary,
    String? githubUpdateRepo,
    bool? autoCheckUpdates,
  }) {
    return AppPreferencesState(
      cycleStartDay: cycleStartDay ?? this.cycleStartDay,
      pendingNextCycleStartDay: clearPendingStartDay
          ? null
          : (pendingNextCycleStartDay ?? this.pendingNextCycleStartDay),
      currencyFormat: currencyFormat ?? this.currencyFormat,
      mealSyncTarget: mealSyncTarget ?? this.mealSyncTarget,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      biometricsEnabled: biometricsEnabled ?? this.biometricsEnabled,
      hasPin: hasPin ?? this.hasPin,
      notifyCycleStart: notifyCycleStart ?? this.notifyCycleStart,
      notifyThreshold80: notifyThreshold80 ?? this.notifyThreshold80,
      notifyThreshold100: notifyThreshold100 ?? this.notifyThreshold100,
      themeMode: themeMode ?? this.themeMode,
      defaultSalary: defaultSalary ?? this.defaultSalary,
      githubUpdateRepo: githubUpdateRepo ?? this.githubUpdateRepo,
      autoCheckUpdates: autoCheckUpdates ?? this.autoCheckUpdates,
    );
  }
}

abstract class KeyValueStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

class SecureKeyValueStore implements KeyValueStore {
  SecureKeyValueStore([FlutterSecureStorage? storage])
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

class InMemoryKeyValueStore implements KeyValueStore {
  final Map<String, String> _data = {};

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<void> delete(String key) async => _data.remove(key);
}

class AppPreferencesRepository {
  AppPreferencesRepository(this._store);

  final KeyValueStore _store;

  static const _kStartDay = 'cycle_start_day';
  static const _kPendingStartDay = 'pending_next_cycle_start_day';
  static const _kCurrencyFormat = 'currency_format';
  static const _kMealSyncTarget = 'meal_sync_target';
  static const _kAppLockEnabled = 'app_lock_enabled';
  static const _kBiometricsEnabled = 'biometrics_enabled';
  static const _kPinHash = 'app_pin_hash';
  static const _kNotifyCycleStart = 'notify_cycle_start';
  static const _kNotify80 = 'notify_threshold_80';
  static const _kNotify100 = 'notify_threshold_100';
  static const _kThemeMode = 'theme_mode';
  static const _kDefaultSalary = 'default_salary';
  static const _kGithubUpdateRepo = 'github_update_repo';
  static const _kAutoCheckUpdates = 'auto_check_updates';

  static const _pinSalt = 'pfm_budget_app_v1_salt';

  Future<AppPreferencesState> load() async {
    final startDay = int.tryParse(await _store.read(_kStartDay) ?? '') ?? 25;
    final pendingRaw = await _store.read(_kPendingStartDay);
    final pendingDay = pendingRaw == null ? null : int.tryParse(pendingRaw);
    final currency = CurrencyFormatStyle.fromKey(
      await _store.read(_kCurrencyFormat),
    );
    final mealSync = MealSyncTarget.fromKey(await _store.read(_kMealSyncTarget));
    final lockEnabled = (await _store.read(_kAppLockEnabled)) == 'true';
    final bioEnabled = (await _store.read(_kBiometricsEnabled)) == 'true';
    final pinHash = await _store.read(_kPinHash);
    final notifyStart = (await _store.read(_kNotifyCycleStart)) != 'false';
    final notify80 = (await _store.read(_kNotify80)) != 'false';
    final notify100 = (await _store.read(_kNotify100)) != 'false';
    final themeRaw = await _store.read(_kThemeMode);
    final themeMode = switch (themeRaw) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
    final defaultSalary =
        double.tryParse(await _store.read(_kDefaultSalary) ?? '') ?? 72000.0;
    final githubRepo = (await _store.read(_kGithubUpdateRepo)) ??
        AppUpdateService.compileTimeDefaultRepo;
    final autoCheck = (await _store.read(_kAutoCheckUpdates)) != 'false';

    return AppPreferencesState(
      cycleStartDay: startDay.clamp(1, 31),
      pendingNextCycleStartDay: pendingDay?.clamp(1, 31),
      currencyFormat: currency,
      mealSyncTarget: mealSync,
      appLockEnabled: lockEnabled,
      biometricsEnabled: bioEnabled,
      hasPin: pinHash != null && pinHash.isNotEmpty,
      notifyCycleStart: notifyStart,
      notifyThreshold80: notify80,
      notifyThreshold100: notify100,
      themeMode: themeMode,
      defaultSalary: defaultSalary,
      githubUpdateRepo: githubRepo,
      autoCheckUpdates: autoCheck,
    );
  }

  Future<void> setCycleStartDay(int day) =>
      _store.write(_kStartDay, day.clamp(1, 31).toString());

  Future<void> setPendingNextCycleStartDay(int? day) async {
    if (day == null) {
      await _store.delete(_kPendingStartDay);
    } else {
      await _store.write(_kPendingStartDay, day.clamp(1, 31).toString());
    }
  }

  Future<void> setCurrencyFormat(CurrencyFormatStyle style) =>
      _store.write(_kCurrencyFormat, style.storageKey);

  Future<void> setMealSyncTarget(MealSyncTarget target) =>
      _store.write(_kMealSyncTarget, target.storageKey);

  Future<void> setAppLockEnabled(bool enabled) =>
      _store.write(_kAppLockEnabled, enabled.toString());

  Future<void> setBiometricsEnabled(bool enabled) =>
      _store.write(_kBiometricsEnabled, enabled.toString());

  Future<void> setPin(String pin) async {
    final hash = _hashPin(pin);
    await _store.write(_kPinHash, hash);
  }

  Future<void> clearPin() => _store.delete(_kPinHash);

  Future<bool> verifyPin(String pin) async {
    final stored = await _store.read(_kPinHash);
    if (stored == null || stored.isEmpty) return false;
    return stored == _hashPin(pin);
  }

  Future<void> setNotifyCycleStart(bool enabled) =>
      _store.write(_kNotifyCycleStart, enabled.toString());

  Future<void> setNotifyThreshold80(bool enabled) =>
      _store.write(_kNotify80, enabled.toString());

  Future<void> setNotifyThreshold100(bool enabled) =>
      _store.write(_kNotify100, enabled.toString());

  Future<void> setThemeMode(ThemeMode mode) {
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    return _store.write(_kThemeMode, value);
  }

  Future<void> setDefaultSalary(double salary) =>
      _store.write(_kDefaultSalary, salary.toString());

  Future<void> setGithubUpdateRepo(String repo) =>
      _store.write(_kGithubUpdateRepo, repo.trim());

  Future<void> setAutoCheckUpdates(bool enabled) =>
      _store.write(_kAutoCheckUpdates, enabled.toString());

  String _hashPin(String pin) {
    final bytes = utf8.encode('$_pinSalt:$pin');
    return sha256.convert(bytes).toString();
  }
}
