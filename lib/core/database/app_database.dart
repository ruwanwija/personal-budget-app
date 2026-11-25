import 'package:drift/drift.dart';
import 'package:pfm_budget_app/core/database/connection/connection.dart';
import 'package:pfm_budget_app/core/database/seed_data.dart';
import 'package:pfm_budget_app/core/database/tables.dart';
import 'package:pfm_budget_app/features/cycles/domain/cycle_date_calculator.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    BudgetCycles,
    SupplementaryIncomes,
    Categories,
    Subsections,
    SubsectionEntries,
    SavingsShortfallLogs,
    MealModes,
    MealScheduleEntries,
    WeeklyModeAssignments,
    WeeklyMealOverrides,
    DefaultCategoryTemplates,
    DefaultSubsectionTemplates,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? openDatabaseConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Seeds default meal modes, default budget templates, and an initial active
  /// budget cycle if the database is empty.
  Future<void> seedIfEmpty({
    int startDay = 25,
    double salary = DefaultSeedData.defaultMonthlySalary,
    DateTime? referenceDate,
  }) async {
    await transaction(() async {
      final existingModes = await select(mealModes).get();
      int notGoHomeId;
      int goHomeId;

      if (existingModes.isEmpty) {
        notGoHomeId = await into(mealModes).insert(
          MealModesCompanion.insert(
            name: 'Not Go Home',
            isDefault: const Value(true),
          ),
        );
        goHomeId = await into(mealModes).insert(
          MealModesCompanion.insert(
            name: 'Go Home',
            isDefault: const Value(false),
          ),
        );

        await _insertMealTemplate(notGoHomeId, DefaultSeedData.notGoHomeMatrix());
        await _insertMealTemplate(goHomeId, DefaultSeedData.goHomeMatrix());
      } else {
        notGoHomeId = existingModes
            .firstWhere(
              (m) => m.isDefault,
              orElse: () => existingModes.first,
            )
            .id;
        goHomeId = existingModes.length > 1 ? existingModes[1].id : notGoHomeId;
      }

      final existingCatTemplates = await select(defaultCategoryTemplates).get();
      if (existingCatTemplates.isEmpty) {
        for (final cat in DefaultSeedData.categories) {
          await into(defaultCategoryTemplates).insert(
            DefaultCategoryTemplatesCompanion.insert(
              categoryType: cat.type.storageKey,
              name: cat.name,
              defaultAllocated: cat.allocated,
              sortOrder: cat.sortOrder,
            ),
          );
          for (var i = 0; i < cat.subsections.length; i++) {
            final sub = cat.subsections[i];
            final parentTplId = await into(defaultSubsectionTemplates).insert(
              DefaultSubsectionTemplatesCompanion.insert(
                categoryType: cat.type.storageKey,
                name: sub.name,
                defaultAllocated: Value(sub.allocated),
                isFoodLinked: Value(sub.isFoodLinked),
                sortOrder: Value(i),
              ),
            );
            for (var j = 0; j < sub.children.length; j++) {
              final child = sub.children[j];
              await into(defaultSubsectionTemplates).insert(
                DefaultSubsectionTemplatesCompanion.insert(
                  categoryType: cat.type.storageKey,
                  parentTemplateId: Value(parentTplId),
                  name: child.name,
                  defaultAllocated: Value(child.allocated),
                  isFoodLinked: Value(child.isFoodLinked),
                  sortOrder: Value(j),
                ),
              );
            }
          }
        }
      }

      final existingCycles = await select(budgetCycles).get();
      if (existingCycles.isEmpty) {
        final window = CycleDateCalculator.activeCycleForDate(
          referenceDate ?? DateTime.now(),
          startDay,
        );
        await createCycleFromTemplates(
          window: window,
          salaryAmount: salary,
          defaultModeId: notGoHomeId,
          alternateModeId: goHomeId,
        );
      }
    });
  }

  Future<void> _insertMealTemplate(
    int modeId,
    Map<MealCellKey, double?> matrix,
  ) async {
    await batch((b) {
      b.insertAll(
        mealScheduleEntries,
        matrix.entries
            .map(
              (entry) => MealScheduleEntriesCompanion.insert(
                modeId: modeId,
                dayOfWeek: entry.key.dayOfWeek,
                mealSlot: entry.key.slot.storageKey,
                amount: Value(entry.value),
              ),
            )
            .toList(),
      );
    });
  }

  /// Creates a new active cycle populated from saved default templates and
  /// initializes weekly mode assignments for each week in [window].
  Future<int> createCycleFromTemplates({
    required CycleWindow window,
    required double salaryAmount,
    required int defaultModeId,
    int? alternateModeId,
  }) async {
    final cycleId = await into(budgetCycles).insert(
      BudgetCyclesCompanion.insert(
        startDate: window.startDate,
        endDate: window.endDate,
        configuredStartDay: Value(window.configuredStartDay),
        salaryAmount: Value(salaryAmount),
        isClosed: const Value(false),
      ),
    );

    final catTemplates = await (select(defaultCategoryTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final subTemplates = await (select(defaultSubsectionTemplates)
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();

    for (final catTpl in catTemplates) {
      final catId = await into(categories).insert(
        CategoriesCompanion.insert(
          cycleId: cycleId,
          name: catTpl.name,
          categoryType: catTpl.categoryType,
          allocatedAmount: Value(catTpl.defaultAllocated),
          sortOrder: Value(catTpl.sortOrder),
        ),
      );

      final topLevelSubs = subTemplates
          .where(
            (s) =>
                s.categoryType == catTpl.categoryType &&
                s.parentTemplateId == null,
          )
          .toList();

      for (final subTpl in topLevelSubs) {
        final subId = await into(subsections).insert(
          SubsectionsCompanion.insert(
            categoryId: catId,
            name: subTpl.name,
            allocatedAmount: Value(subTpl.defaultAllocated),
            actualAmount: const Value(0.0),
            isFoodLinked: Value(subTpl.isFoodLinked),
            sortOrder: Value(subTpl.sortOrder),
          ),
        );

        final childTpls = subTemplates
            .where((c) => c.parentTemplateId == subTpl.id)
            .toList();
        for (final childTpl in childTpls) {
          await into(subsections).insert(
            SubsectionsCompanion.insert(
              categoryId: catId,
              parentId: Value(subId),
              name: childTpl.name,
              allocatedAmount: Value(childTpl.defaultAllocated),
              actualAmount: const Value(0.0),
              isFoodLinked: Value(childTpl.isFoodLinked),
              sortOrder: Value(childTpl.sortOrder),
            ),
          );
        }
      }
    }

    // Create weekly meal mode assignments for the cycle weeks
    final weeks = CycleDateCalculator.splitIntoWeeks(window);
    for (var i = 0; i < weeks.length; i++) {
      final chosenMode = (alternateModeId != null && i.isOdd)
          ? alternateModeId
          : defaultModeId;
      await into(weeklyModeAssignments).insert(
        WeeklyModeAssignmentsCompanion.insert(
          cycleId: cycleId,
          weekIndex: weeks[i].weekIndex,
          modeId: chosenMode,
        ),
      );
    }

    return cycleId;
  }
}
