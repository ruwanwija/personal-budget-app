import 'package:drift/drift.dart';

class BudgetCycles extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime()();
  IntColumn get configuredStartDay => integer().withDefault(const Constant(25))();
  RealColumn get salaryAmount => real().withDefault(const Constant(72000.0))();
  BoolColumn get isClosed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closedAt => dateTime().nullable()();
}

class SupplementaryIncomes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId =>
      integer().references(BudgetCycles, #id, onDelete: KeyAction.cascade)();
  TextColumn get label => text()();
  RealColumn get amount => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId =>
      integer().references(BudgetCycles, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  /// 'savings', 'wants', or 'needs'
  TextColumn get categoryType => text()();
  RealColumn get allocatedAmount => real().withDefault(const Constant(0.0))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class Subsections extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId =>
      integer().references(Categories, #id, onDelete: KeyAction.cascade)();
  IntColumn get parentId => integer()
      .nullable()
      .references(Subsections, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  RealColumn get allocatedAmount => real().withDefault(const Constant(0.0))();
  RealColumn get actualAmount => real().withDefault(const Constant(0.0))();
  BoolColumn get isFoodLinked => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class SubsectionEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get subsectionId =>
      integer().references(Subsections, #id, onDelete: KeyAction.cascade)();
  RealColumn get amount => real()();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get entryDate => dateTime().withDefault(currentDateAndTime)();
}

class SavingsShortfallLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId => integer()
      .unique()
      .references(BudgetCycles, #id, onDelete: KeyAction.cascade)();
  RealColumn get shortfallAmount => real().withDefault(const Constant(0.0))();
  TextColumn get reasonText => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class MealModes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
}

class MealScheduleEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get modeId =>
      integer().references(MealModes, #id, onDelete: KeyAction.cascade)();
  /// 1 = Monday .. 7 = Sunday
  IntColumn get dayOfWeek => integer()();
  /// 'breakfast', 'lunch', 'dinner'
  TextColumn get mealSlot => text()();
  /// Nullable: null indicates skipped ('—') slot evaluating to 0
  RealColumn get amount => real().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {modeId, dayOfWeek, mealSlot},
      ];
}

class WeeklyModeAssignments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cycleId =>
      integer().references(BudgetCycles, #id, onDelete: KeyAction.cascade)();
  IntColumn get weekIndex => integer()();
  IntColumn get modeId =>
      integer().references(MealModes, #id, onDelete: KeyAction.restrict)();
  RealColumn get overrideTotal => real().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {cycleId, weekIndex},
      ];
}

class WeeklyMealOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get assignmentId => integer().references(
        WeeklyModeAssignments,
        #id,
        onDelete: KeyAction.cascade,
      )();
  IntColumn get dayOfWeek => integer()();
  TextColumn get mealSlot => text()();
  RealColumn get amount => real().nullable()();
  BoolColumn get isSkipped => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {assignmentId, dayOfWeek, mealSlot},
      ];
}

/// Customizable default budget templates used when starting a new budget cycle.
class DefaultCategoryTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryType => text().unique()();
  TextColumn get name => text()();
  RealColumn get defaultAllocated => real()();
  IntColumn get sortOrder => integer()();
}

class DefaultSubsectionTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryType => text()();
  IntColumn get parentTemplateId => integer().nullable().references(
        DefaultSubsectionTemplates,
        #id,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get name => text()();
  RealColumn get defaultAllocated => real().withDefault(const Constant(0.0))();
  BoolColumn get isFoodLinked => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
