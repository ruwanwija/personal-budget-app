import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/cycles/data/cycle_repository.dart';
import 'package:pfm_budget_app/features/history/data/backup_service.dart';
import 'package:pfm_budget_app/features/history/data/report_export_service.dart';
import 'package:pfm_budget_app/features/meals/data/meal_repository.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';

void main() {
  late AppDatabase db;
  late CycleRepository cycleRepo;
  late BudgetRepository budgetRepo;
  late MealRepository mealRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    cycleRepo = CycleRepository(db);
    budgetRepo = BudgetRepository(db);
    mealRepo = MealRepository(db);
    await db.seedIfEmpty(
      startDay: 25,
      salary: 72000,
      referenceDate: DateTime(2026, 3, 27),
    );
  });

  tearDown(() async {
    await db.close();
  });

  test('seeds starter categories, nested subsections, and meal modes accurately',
      () async {
    final active = await cycleRepo.getActiveCycle();
    expect(active, isNotNull);
    expect(active!.salaryAmount, 72000);
    expect(active.startDate, DateTime(2026, 3, 25));
    expect(active.endDate, DateTime(2026, 4, 24));

    final snap = await budgetRepo.getCycleBudgetSnapshot(active.id);
    expect(snap, isNotNull);
    expect(snap!.categories.length, 3);
    expect(snap.totalCategoryAllocated, 72000);

    final needs = snap.categoryByType(BudgetCategoryType.needs)!;
    final fashion = needs.subsections.firstWhere((s) => s.name == 'Fashion');
    expect(fashion.isParent, isTrue);
    expect(fashion.effectiveAllocated, 5000); // Grooming 1500 + Shopping 3500

    final utilities = needs.subsections.firstWhere((s) => s.name == 'Utilities');
    expect(utilities.isParent, isTrue);
    expect(utilities.effectiveAllocated, 740); // Soap 340 + Toothpaste 300 + Sticks 100
  });

  test('syncs weekly meal mode changes & daily overrides into Food without altering template',
      () async {
    final active = (await cycleRepo.getActiveCycle())!;
    final initialMeals = await mealRepo.watchCycleMealPlan(active.id).first;
    expect(initialMeals.modes.length, 2);

    final notGoHome = initialMeals.modes.firstWhere((m) => m.name == 'Not Go Home');
    final goHome = initialMeals.modes.firstWhere((m) => m.name == 'Go Home');

    // Switch Week 1 to Go Home
    await mealRepo.assignWeekMode(
      assignmentId: initialMeals.weeks.first.assignmentId,
      modeId: goHome.id,
      cycleId: active.id,
      syncTarget: MealSyncTarget.actual,
    );

    // Override Week 1 Monday dinner to 500 (template stays 200)
    await mealRepo.setWeekMealOverride(
      assignmentId: initialMeals.weeks.first.assignmentId,
      dayOfWeek: 1,
      slot: MealSlot.dinner,
      amount: 500,
      isSkipped: false,
      cycleId: active.id,
      syncTarget: MealSyncTarget.actual,
    );

    final updatedMeals = await mealRepo.watchCycleMealPlan(active.id).first;
    expect(updatedMeals.weeks.first.effectiveTotal, 3400); // 3100 + 300
    expect(
      updatedMeals.templateByMode[goHome.id]![const MealCellKey(1, MealSlot.dinner)],
      200,
    );
    expect(
      MealCalculator.computeTemplateWeeklyTotal(
        updatedMeals.templateByMode[notGoHome.id]!,
      ),
      5200,
    );

    // Food subsection actualAmount must equal monthlyTotal
    final budgetSnap = (await budgetRepo.getCycleBudgetSnapshot(active.id))!;
    final wants = budgetSnap.categoryByType(BudgetCategoryType.wants)!;
    final food = wants.subsections.firstWhere((s) => s.isFoodLinked);
    expect(food.effectiveActual, updatedMeals.monthlyTotal);
  });

  test('enforces shortfall reason before closing cycle and archives read-only',
      () async {
    final active = (await cycleRepo.getActiveCycle())!;
    final snap = (await budgetRepo.getCycleBudgetSnapshot(active.id))!;
    // Initially actual savings = 0 < allocated 15,000 -> shortfall active, empty reason
    expect(snap.shortfall.isShortfallActive, isTrue);
    expect(snap.shortfall.canCloseCycle, isFalse);

    // Attempting to close without reason must fail
    await expectLater(
      () => cycleRepo.closeActiveCycleAndStartNext(
        cycleId: active.id,
        nextStartDay: 25,
        nextSalary: 72000,
        mealSyncTarget: MealSyncTarget.actual,
      ),
      throwsStateError,
    );

    // Record shortfall reason -> now close succeeds
    await budgetRepo.saveShortfallReason(
      cycleId: active.id,
      shortfallAmount: snap.shortfall.shortfallAmount,
      reasonText: 'Paid unexpected vehicle repair.',
    );

    final nextId = await cycleRepo.closeActiveCycleAndStartNext(
      cycleId: active.id,
      nextStartDay: 25,
      nextSalary: 72000,
      mealSyncTarget: MealSyncTarget.actual,
    );
    expect(nextId, isNot(active.id));

    // Old cycle is archived & read-only
    final archived = await cycleRepo.getCycleById(active.id);
    expect(archived!.isClosed, isTrue);
    await expectLater(
      () => cycleRepo.updateSalary(active.id, 80000),
      throwsStateError,
    );

    // New cycle starts consecutively on Apr 25
    final nextCycle = await cycleRepo.getCycleById(nextId);
    expect(nextCycle!.startDate, DateTime(2026, 4, 25));
    expect(nextCycle.endDate, DateTime(2026, 5, 24));
  });

  test('exports PDF/CSV reports and restores lossless JSON backup', () async {
    final active = (await cycleRepo.getActiveCycle())!;
    await budgetRepo.saveShortfallReason(
      cycleId: active.id,
      shortfallAmount: 15000,
      reasonText: 'Backup test note',
    );

    final budgetSnap = (await budgetRepo.getCycleBudgetSnapshot(active.id))!;
    final mealSnap = await mealRepo.watchCycleMealPlan(active.id).first;

    final exporter = ReportExportService();
    final csv = exporter.buildCsvContent(
      budget: budgetSnap,
      meals: mealSnap,
      currencyFormat: CurrencyFormatStyle.slashEquals,
    );
    expect(csv, contains('Backup test note'));
    expect(csv, contains('Accommodation'));

    final pdfBytes = await exporter.buildPdfBytes(
      budget: budgetSnap,
      meals: mealSnap,
      currencyFormat: CurrencyFormatStyle.slashEquals,
    );
    expect(pdfBytes.length, greaterThan(500));

    // JSON Backup & Restore round-trip
    final backupService = BackupService(db);
    final jsonBackup = await backupService.exportToJsonString();

    // Mutate salary then restore
    await cycleRepo.updateSalary(active.id, 99999);
    expect((await cycleRepo.getCycleById(active.id))!.salaryAmount, 99999);

    await backupService.restoreFromJsonString(jsonBackup);
    final restored = await cycleRepo.getCycleById(active.id);
    expect(restored!.salaryAmount, 72000);
    final restoredSnap = (await budgetRepo.getCycleBudgetSnapshot(active.id))!;
    expect(restoredSnap.shortfall.reasonText, 'Backup test note');
  });
}
