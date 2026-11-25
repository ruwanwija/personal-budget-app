import 'package:drift/drift.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';
import 'package:rxdart/rxdart.dart';

class CycleMealPlanSnapshot {
  const CycleMealPlanSnapshot({
    required this.cycleId,
    required this.modes,
    required this.templateByMode,
    required this.weeks,
    required this.monthlyTotal,
    required this.foodSubsectionId,
  });

  final int cycleId;
  final List<MealMode> modes;
  final Map<int, Map<MealCellKey, double?>> templateByMode;
  final List<WeeklyMealPlanSummary> weeks;
  final double monthlyTotal;
  final int? foodSubsectionId;
}

class MealRepository {
  MealRepository(this._db);

  final AppDatabase _db;

  Stream<List<MealMode>> watchMealModes() {
    return (_db.select(_db.mealModes)..orderBy([(m) => OrderingTerm.asc(m.id)]))
        .watch();
  }

  Stream<CycleMealPlanSnapshot> watchCycleMealPlan(int cycleId) {
    final modesStream = watchMealModes();
    final scheduleStream = _db.select(_db.mealScheduleEntries).watch();
    final assignmentsStream = (_db.select(_db.weeklyModeAssignments)
          ..where((w) => w.cycleId.equals(cycleId))
          ..orderBy([(w) => OrderingTerm.asc(w.weekIndex)]))
        .watch();
    final overridesStream = _db.select(_db.weeklyMealOverrides).watch();
    final catsStream = (_db.select(_db.categories)
          ..where((c) => c.cycleId.equals(cycleId)))
        .watch();
    final subsStream = _db.select(_db.subsections).watch();

    return Rx.combineLatest6(
      modesStream,
      scheduleStream,
      assignmentsStream,
      overridesStream,
      catsStream,
      subsStream,
      (
        List<MealMode> modes,
        List<MealScheduleEntry> entries,
        List<WeeklyModeAssignment> assignments,
        List<WeeklyMealOverride> overrides,
        List<Category> cats,
        List<Subsection> subs,
      ) {
        final modeById = {for (final m in modes) m.id: m};
        final templateByMode = <int, Map<MealCellKey, double?>>{};
        for (final m in modes) {
          templateByMode[m.id] = {};
        }
        for (final e in entries) {
          templateByMode
              .putIfAbsent(e.modeId, () => {})[
                  MealCellKey(e.dayOfWeek, MealSlot.fromKey(e.mealSlot))] =
              e.amount;
        }

        final overridesByAssignment =
            <int, Map<MealCellKey, WeeklyMealOverrideData>>{};
        for (final ov in overrides) {
          final key = MealCellKey(ov.dayOfWeek, MealSlot.fromKey(ov.mealSlot));
          overridesByAssignment.putIfAbsent(ov.assignmentId, () => {})[key] =
              WeeklyMealOverrideData(
            dayOfWeek: ov.dayOfWeek,
            slot: MealSlot.fromKey(ov.mealSlot),
            amount: ov.amount,
            isSkipped: ov.isSkipped,
          );
        }

        final weeks = assignments.map((a) {
          final tpl = templateByMode[a.modeId] ?? const {};
          final weekOverrides = overridesByAssignment[a.id] ?? const {};
          final computed = MealCalculator.computeWeekWithOverrides(
            templateCells: tpl,
            overrides: weekOverrides,
            overrideTotal: a.overrideTotal,
          );
          return WeeklyMealPlanSummary(
            assignmentId: a.id,
            weekIndex: a.weekIndex,
            modeId: a.modeId,
            modeName: modeById[a.modeId]?.name ?? 'Mode',
            computedTotal: computed.total,
            overrideTotal: a.overrideTotal,
            effectiveCells: computed.effectiveCells,
            overrideKeys: weekOverrides.keys.toSet(),
          );
        }).toList();

        final monthlyTotal = MealCalculator.computeCycleFoodTotal(
          weeks.map((w) => w.effectiveTotal).toList(),
        );

        final catIds = cats.map((c) => c.id).toSet();
        int? foodSubId;
        for (final s in subs) {
          if (catIds.contains(s.categoryId) && s.isFoodLinked) {
            foodSubId = s.id;
            break;
          }
        }

        return CycleMealPlanSnapshot(
          cycleId: cycleId,
          modes: modes,
          templateByMode: templateByMode,
          weeks: weeks,
          monthlyTotal: monthlyTotal,
          foodSubsectionId: foodSubId,
        );
      },
    );
  }

  Future<int> createMealMode({
    required String name,
    int? copyFromModeId,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Mode name cannot be empty');
    }

    return _db.transaction(() async {
      final modeId = await _db.into(_db.mealModes).insert(
            MealModesCompanion.insert(
              name: trimmed,
              isDefault: const Value(false),
            ),
          );

      if (copyFromModeId != null) {
        final source = await (_db.select(_db.mealScheduleEntries)
              ..where((e) => e.modeId.equals(copyFromModeId)))
            .get();
        await _db.batch((b) {
          b.insertAll(
            _db.mealScheduleEntries,
            source
                .map(
                  (e) => MealScheduleEntriesCompanion.insert(
                    modeId: modeId,
                    dayOfWeek: e.dayOfWeek,
                    mealSlot: e.mealSlot,
                    amount: Value(e.amount),
                  ),
                )
                .toList(),
          );
        });
      } else {
        final companions = <MealScheduleEntriesCompanion>[];
        for (var day = 1; day <= 7; day++) {
          for (final slot in MealSlot.values) {
            companions.add(
              MealScheduleEntriesCompanion.insert(
                modeId: modeId,
                dayOfWeek: day,
                mealSlot: slot.storageKey,
                amount: const Value(null),
              ),
            );
          }
        }
        await _db.batch((b) => b.insertAll(_db.mealScheduleEntries, companions));
      }

      return modeId;
    });
  }

  Future<void> deleteMealMode({
    required int modeId,
    required int activeCycleId,
    required MealSyncTarget syncTarget,
  }) async {
    final allModes = await _db.select(_db.mealModes).get();
    if (allModes.length <= 1) {
      throw StateError('At least one meal mode must remain.');
    }
    final fallback = allModes.firstWhere((m) => m.id != modeId);

    await _db.transaction(() async {
      await (_db.update(_db.weeklyModeAssignments)
            ..where((w) => w.modeId.equals(modeId)))
          .write(WeeklyModeAssignmentsCompanion(modeId: Value(fallback.id)));
      await (_db.delete(_db.mealModes)..where((m) => m.id.equals(modeId))).go();
    });

    await syncFoodSubsectionForCycle(activeCycleId, syncTarget);
  }

  Future<void> updateTemplateCell({
    required int modeId,
    required int dayOfWeek,
    required MealSlot slot,
    required double? amount,
    required int activeCycleId,
    required MealSyncTarget syncTarget,
  }) async {
    if (amount != null) {
      MealCalculator.slotAmountOrZero(amount);
    }

    await _db.into(_db.mealScheduleEntries).insert(
          MealScheduleEntriesCompanion.insert(
            modeId: modeId,
            dayOfWeek: dayOfWeek,
            mealSlot: slot.storageKey,
            amount: Value(amount),
          ),
          onConflict: DoUpdate(
            (old) => MealScheduleEntriesCompanion(amount: Value(amount)),
            target: [
              _db.mealScheduleEntries.modeId,
              _db.mealScheduleEntries.dayOfWeek,
              _db.mealScheduleEntries.mealSlot,
            ],
          ),
        );

    await syncFoodSubsectionForCycle(activeCycleId, syncTarget);
  }

  Future<void> assignWeekMode({
    required int assignmentId,
    required int modeId,
    required int cycleId,
    required MealSyncTarget syncTarget,
  }) async {
    final cycle = await (_db.select(_db.budgetCycles)
          ..where((c) => c.id.equals(cycleId)))
        .getSingle();
    if (cycle.isClosed) {
      throw StateError('Archived cycles are read-only.');
    }

    await _db.transaction(() async {
      await (_db.update(_db.weeklyModeAssignments)
            ..where((w) => w.id.equals(assignmentId)))
          .write(
        WeeklyModeAssignmentsCompanion(
          modeId: Value(modeId),
          overrideTotal: const Value(null),
        ),
      );
      await (_db.delete(_db.weeklyMealOverrides)
            ..where((o) => o.assignmentId.equals(assignmentId)))
          .go();
    });

    await syncFoodSubsectionForCycle(cycleId, syncTarget);
  }

  Future<void> setWeekMealOverride({
    required int assignmentId,
    required int dayOfWeek,
    required MealSlot slot,
    required double? amount,
    required bool isSkipped,
    required int cycleId,
    required MealSyncTarget syncTarget,
  }) async {
    if (!isSkipped && amount != null) {
      MealCalculator.slotAmountOrZero(amount);
    }

    await _db.into(_db.weeklyMealOverrides).insert(
          WeeklyMealOverridesCompanion.insert(
            assignmentId: assignmentId,
            dayOfWeek: dayOfWeek,
            mealSlot: slot.storageKey,
            amount: Value(isSkipped ? null : amount),
            isSkipped: Value(isSkipped),
          ),
          onConflict: DoUpdate(
            (old) => WeeklyMealOverridesCompanion(
              amount: Value(isSkipped ? null : amount),
              isSkipped: Value(isSkipped),
            ),
            target: [
              _db.weeklyMealOverrides.assignmentId,
              _db.weeklyMealOverrides.dayOfWeek,
              _db.weeklyMealOverrides.mealSlot,
            ],
          ),
        );

    await syncFoodSubsectionForCycle(cycleId, syncTarget);
  }

  Future<void> clearWeekMealOverride({
    required int assignmentId,
    required int dayOfWeek,
    required MealSlot slot,
    required int cycleId,
    required MealSyncTarget syncTarget,
  }) async {
    await (_db.delete(_db.weeklyMealOverrides)
          ..where(
            (o) =>
                o.assignmentId.equals(assignmentId) &
                o.dayOfWeek.equals(dayOfWeek) &
                o.mealSlot.equals(slot.storageKey),
          ))
        .go();

    await syncFoodSubsectionForCycle(cycleId, syncTarget);
  }

  /// Calculates the total monthly food cost across all weeks in [cycleId] and
  /// synchronizes it with the Food subsection (`isFoodLinked = true`).
  Future<double> syncFoodSubsectionForCycle(
    int cycleId,
    MealSyncTarget syncTarget,
  ) async {
    final cycle = await (_db.select(_db.budgetCycles)
          ..where((c) => c.id.equals(cycleId)))
        .getSingleOrNull();
    if (cycle == null || cycle.isClosed) return 0.0;

    final assignments = await (_db.select(_db.weeklyModeAssignments)
          ..where((w) => w.cycleId.equals(cycleId)))
        .get();
    final entries = await _db.select(_db.mealScheduleEntries).get();
    final templateByMode = <int, Map<MealCellKey, double?>>{};
    for (final e in entries) {
      templateByMode.putIfAbsent(e.modeId, () => {})[
          MealCellKey(e.dayOfWeek, MealSlot.fromKey(e.mealSlot))] = e.amount;
    }

    final assignmentIds = assignments.map((a) => a.id).toList();
    final overrides = assignmentIds.isEmpty
        ? <WeeklyMealOverride>[]
        : await (_db.select(_db.weeklyMealOverrides)
              ..where((o) => o.assignmentId.isIn(assignmentIds)))
            .get();

    final overridesByAssignment =
        <int, Map<MealCellKey, WeeklyMealOverrideData>>{};
    for (final ov in overrides) {
      final key = MealCellKey(ov.dayOfWeek, MealSlot.fromKey(ov.mealSlot));
      overridesByAssignment.putIfAbsent(ov.assignmentId, () => {})[key] =
          WeeklyMealOverrideData(
        dayOfWeek: ov.dayOfWeek,
        slot: MealSlot.fromKey(ov.mealSlot),
        amount: ov.amount,
        isSkipped: ov.isSkipped,
      );
    }

    final weeklyTotals = assignments.map((a) {
      final computed = MealCalculator.computeWeekWithOverrides(
        templateCells: templateByMode[a.modeId] ?? const {},
        overrides: overridesByAssignment[a.id] ?? const {},
        overrideTotal: a.overrideTotal,
      );
      return computed.total;
    }).toList();

    final monthlyTotal = MealCalculator.computeCycleFoodTotal(weeklyTotals);

    final cats = await (_db.select(_db.categories)
          ..where((c) => c.cycleId.equals(cycleId)))
        .get();
    final catIds = cats.map((c) => c.id).toList();
    if (catIds.isNotEmpty) {
      final foodSubs = await (_db.select(_db.subsections)
            ..where(
              (s) => s.categoryId.isIn(catIds) & s.isFoodLinked.equals(true),
            ))
          .get();

      for (final foodSub in foodSubs) {
        final companion = syncTarget == MealSyncTarget.actual
            ? SubsectionsCompanion(actualAmount: Value(monthlyTotal))
            : SubsectionsCompanion(allocatedAmount: Value(monthlyTotal));
        await (_db.update(_db.subsections)
              ..where((s) => s.id.equals(foodSub.id)))
            .write(companion);
      }
    }

    return monthlyTotal;
  }
}
