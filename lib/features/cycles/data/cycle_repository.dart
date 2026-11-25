import 'package:drift/drift.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/cycles/domain/cycle_date_calculator.dart';
import 'package:pfm_budget_app/features/meals/data/meal_repository.dart';

class CycleRepository {
  CycleRepository(this._db);

  final AppDatabase _db;

  Stream<BudgetCycle?> watchActiveCycle() {
    return (_db.select(_db.budgetCycles)
          ..where((c) => c.isClosed.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.startDate)])
          ..limit(1))
        .watchSingleOrNull();
  }

  Future<BudgetCycle?> getActiveCycle() {
    return (_db.select(_db.budgetCycles)
          ..where((c) => c.isClosed.equals(false))
          ..orderBy([(c) => OrderingTerm.desc(c.startDate)])
          ..limit(1))
        .getSingleOrNull();
  }

  Stream<List<BudgetCycle>> watchArchivedCycles() {
    return (_db.select(_db.budgetCycles)
          ..where((c) => c.isClosed.equals(true))
          ..orderBy([(c) => OrderingTerm.desc(c.startDate)]))
        .watch();
  }

  Future<BudgetCycle?> getCycleById(int cycleId) {
    return (_db.select(_db.budgetCycles)..where((c) => c.id.equals(cycleId)))
        .getSingleOrNull();
  }

  Stream<List<SupplementaryIncome>> watchSupplementaryIncomes(int cycleId) {
    return (_db.select(_db.supplementaryIncomes)
          ..where((i) => i.cycleId.equals(cycleId))
          ..orderBy([(i) => OrderingTerm.desc(i.createdAt)]))
        .watch();
  }

  Future<void> _assertCycleOpen(int cycleId) async {
    final cycle = await getCycleById(cycleId);
    if (cycle == null) {
      throw StateError('Budget cycle not found.');
    }
    if (cycle.isClosed) {
      throw StateError('Archived cycles are read-only and cannot be modified.');
    }
  }

  Future<void> updateSalary(int cycleId, double newSalary) async {
    VarianceCalculator.validateNonNegative(newSalary, fieldName: 'salary');
    await _assertCycleOpen(cycleId);
    await (_db.update(_db.budgetCycles)..where((c) => c.id.equals(cycleId)))
        .write(BudgetCyclesCompanion(salaryAmount: Value(newSalary)));
  }

  Future<int> addSupplementaryIncome({
    required int cycleId,
    required String label,
    required double amount,
  }) async {
    VarianceCalculator.validateNonNegative(amount, fieldName: 'income');
    await _assertCycleOpen(cycleId);
    final trimmed = label.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Income label cannot be empty');
    }
    return _db.into(_db.supplementaryIncomes).insert(
          SupplementaryIncomesCompanion.insert(
            cycleId: cycleId,
            label: trimmed,
            amount: amount,
          ),
        );
  }

  Future<void> deleteSupplementaryIncome(int incomeId, int cycleId) async {
    await _assertCycleOpen(cycleId);
    await (_db.delete(_db.supplementaryIncomes)
          ..where((i) => i.id.equals(incomeId)))
        .go();
  }

  /// Applies a new custom start day immediately to the currently active cycle,
  /// recalculating its start/end dates and reconciling weekly meal assignments.
  Future<void> applyStartDayToCurrentCycle({
    required int cycleId,
    required int newStartDay,
    required MealSyncTarget mealSyncTarget,
    DateTime? referenceDate,
  }) async {
    CycleDateCalculator.validateStartDay(newStartDay);
    await _assertCycleOpen(cycleId);

    final window = CycleDateCalculator.activeCycleForDate(
      referenceDate ?? DateTime.now(),
      newStartDay,
    );

    await _db.transaction(() async {
      await (_db.update(_db.budgetCycles)..where((c) => c.id.equals(cycleId)))
          .write(
        BudgetCyclesCompanion(
          startDate: Value(window.startDate),
          endDate: Value(window.endDate),
          configuredStartDay: Value(newStartDay),
        ),
      );

      final targetWeeks = CycleDateCalculator.splitIntoWeeks(window);
      final existingAssignments = await (_db.select(_db.weeklyModeAssignments)
            ..where((w) => w.cycleId.equals(cycleId))
            ..orderBy([(w) => OrderingTerm.asc(w.weekIndex)]))
          .get();

      final modes = await _db.select(_db.mealModes).get();
      final defaultModeId = modes
          .firstWhere(
            (m) => m.isDefault,
            orElse: () => modes.first,
          )
          .id;

      // Remove excess week assignments if the new cycle has fewer weeks.
      if (existingAssignments.length > targetWeeks.length) {
        final maxWeekIndex = targetWeeks.length;
        await (_db.delete(_db.weeklyModeAssignments)
              ..where(
                (w) =>
                    w.cycleId.equals(cycleId) &
                    w.weekIndex.isBiggerThanValue(maxWeekIndex),
              ))
            .go();
      }

      // Add missing week assignments if the new cycle has more weeks.
      for (var i = existingAssignments.length + 1; i <= targetWeeks.length; i++) {
        await _db.into(_db.weeklyModeAssignments).insert(
              WeeklyModeAssignmentsCompanion.insert(
                cycleId: cycleId,
                weekIndex: i,
                modeId: defaultModeId,
              ),
            );
      }
    });

    await MealRepository(_db).syncFoodSubsectionForCycle(
      cycleId,
      mealSyncTarget,
    );
  }

  /// Validates savings shortfall rules, archives the active cycle as read-only,
  /// and spawns the next consecutive cycle from default templates.
  Future<int> closeActiveCycleAndStartNext({
    required int cycleId,
    required int nextStartDay,
    required double nextSalary,
    required MealSyncTarget mealSyncTarget,
  }) async {
    await _assertCycleOpen(cycleId);

    final budgetRepo = BudgetRepository(_db);
    final snapshot = await budgetRepo.getCycleBudgetSnapshot(cycleId);
    if (snapshot == null) {
      throw StateError('Active budget cycle not found.');
    }

    if (!snapshot.shortfall.canCloseCycle) {
      throw StateError(
        snapshot.shortfall.validationError ??
            'Please provide a reason for the savings shortfall before closing.',
      );
    }

    final currentWindow = CycleWindow(
      startDate: snapshot.cycle.startDate,
      endDate: snapshot.cycle.endDate,
      configuredStartDay: snapshot.cycle.configuredStartDay,
    );
    final nextWindow = CycleDateCalculator.nextCycleAfter(
      currentWindow,
      nextStartDay: nextStartDay,
    );

    final newCycleId = await _db.transaction(() async {
      // Persist final shortfall amount if active
      if (snapshot.shortfall.isShortfallActive) {
        final trimmedReason = snapshot.shortfall.reasonText.trim();
        await _db.into(_db.savingsShortfallLogs).insert(
              SavingsShortfallLogsCompanion.insert(
                cycleId: cycleId,
                shortfallAmount: Value(snapshot.shortfall.shortfallAmount),
                reasonText: Value(trimmedReason),
                updatedAt: Value(DateTime.now()),
              ),
              onConflict: DoUpdate(
                (_) => SavingsShortfallLogsCompanion(
                  shortfallAmount: Value(snapshot.shortfall.shortfallAmount),
                  reasonText: Value(trimmedReason),
                  updatedAt: Value(DateTime.now()),
                ),
                target: [_db.savingsShortfallLogs.cycleId],
              ),
            );
      }

      await (_db.update(_db.budgetCycles)..where((c) => c.id.equals(cycleId)))
          .write(
        BudgetCyclesCompanion(
          isClosed: const Value(true),
          closedAt: Value(DateTime.now()),
        ),
      );

      final modes = await _db.select(_db.mealModes).get();
      final defaultModeId = modes
          .firstWhere(
            (m) => m.isDefault,
            orElse: () => modes.first,
          )
          .id;
      final altModeId = modes.length > 1 ? modes[1].id : null;

      return _db.createCycleFromTemplates(
        window: nextWindow,
        salaryAmount: nextSalary,
        defaultModeId: defaultModeId,
        alternateModeId: altModeId,
      );
    });

    await MealRepository(_db).syncFoodSubsectionForCycle(
      newCycleId,
      mealSyncTarget,
    );
    return newCycleId;
  }

  // --- Default Templates Management (Settings) ---

  Stream<List<DefaultCategoryTemplate>> watchCategoryTemplates() {
    return (_db.select(_db.defaultCategoryTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<void> updateCategoryTemplateAllocation(
    int templateId,
    double amount,
  ) async {
    VarianceCalculator.validateNonNegative(amount, fieldName: 'allocated');
    await (_db.update(_db.defaultCategoryTemplates)
          ..where((t) => t.id.equals(templateId)))
        .write(DefaultCategoryTemplatesCompanion(defaultAllocated: Value(amount)));
  }

  Stream<List<DefaultSubsectionTemplate>> watchSubsectionTemplates() {
    return (_db.select(_db.defaultSubsectionTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .watch();
  }

  Future<void> updateSubsectionTemplateAllocation(
    int templateId,
    double amount,
  ) async {
    VarianceCalculator.validateNonNegative(amount, fieldName: 'allocated');
    await (_db.update(_db.defaultSubsectionTemplates)
          ..where((t) => t.id.equals(templateId)))
        .write(
      DefaultSubsectionTemplatesCompanion(defaultAllocated: Value(amount)),
    );
  }
}
