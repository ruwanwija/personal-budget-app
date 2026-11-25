import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';

class SeedSubsectionDef {
  const SeedSubsectionDef({
    required this.name,
    this.allocated = 0,
    this.isFoodLinked = false,
    this.children = const [],
  });

  final String name;
  final double allocated;
  final bool isFoodLinked;
  final List<SeedSubsectionDef> children;
}

class SeedCategoryDef {
  const SeedCategoryDef({
    required this.type,
    required this.name,
    required this.allocated,
    required this.sortOrder,
    required this.subsections,
  });

  final BudgetCategoryType type;
  final String name;
  final double allocated;
  final int sortOrder;
  final List<SeedSubsectionDef> subsections;
}

/// Default budget structure matching Monthly Budget.pdf & the SRS specification.
class DefaultSeedData {
  static const double defaultMonthlySalary = 72000.0;

  static const List<SeedCategoryDef> categories = [
    SeedCategoryDef(
      type: BudgetCategoryType.savings,
      name: 'Savings and Investments',
      allocated: 15000.0,
      sortOrder: 0,
      subsections: [
        SeedSubsectionDef(name: 'Monthly Savings', allocated: 10000.0),
        SeedSubsectionDef(name: 'Investments', allocated: 5000.0),
      ],
    ),
    SeedCategoryDef(
      type: BudgetCategoryType.wants,
      name: 'Wants',
      allocated: 36000.0,
      sortOrder: 1,
      subsections: [
        SeedSubsectionDef(name: 'Accommodation', allocated: 10500.0),
        SeedSubsectionDef(
          name: 'Food',
          allocated: 16600.0,
          isFoodLinked: true,
        ),
        SeedSubsectionDef(name: 'Transport', allocated: 8000.0),
        SeedSubsectionDef(name: 'Amma', allocated: 3000.0),
      ],
    ),
    SeedCategoryDef(
      type: BudgetCategoryType.needs,
      name: 'Needs',
      allocated: 21000.0,
      sortOrder: 2,
      subsections: [
        SeedSubsectionDef(name: 'PTE Exam Prep.', allocated: 4300.0),
        SeedSubsectionDef(name: 'Loan', allocated: 5000.0),
        SeedSubsectionDef(
          name: 'Fashion',
          children: [
            SeedSubsectionDef(name: 'Grooming', allocated: 1500.0),
            SeedSubsectionDef(name: 'Shopping', allocated: 3500.0),
          ],
        ),
        SeedSubsectionDef(name: 'Date', allocated: 5000.0),
        SeedSubsectionDef(
          name: 'Utilities',
          children: [
            SeedSubsectionDef(name: 'Soap', allocated: 340.0),
            SeedSubsectionDef(name: 'Toothpaste', allocated: 300.0),
            SeedSubsectionDef(name: 'Sticks', allocated: 100.0),
          ],
        ),
      ],
    ),
  ];

  /// "Not Go Home" template from Monthly Budget.pdf (Weekly Total = 5,200/=)
  static Map<MealCellKey, double?> notGoHomeMatrix() {
    final map = <MealCellKey, double?>{};
    for (var day = 1; day <= 7; day++) {
      map[MealCellKey(day, MealSlot.breakfast)] = 200.0;
      map[MealCellKey(day, MealSlot.lunch)] = 250.0;
      map[MealCellKey(day, MealSlot.dinner)] = switch (day) {
        2 => 250.0, // Tuesday dinner
        6 || 7 => 500.0, // Saturday & Sunday dinners
        _ => 200.0,
      };
    }
    return map;
  }

  /// "Go Home" template from Monthly Budget.pdf (Weekly Total = 3,100/=)
  static Map<MealCellKey, double?> goHomeMatrix() {
    final map = <MealCellKey, double?>{};
    for (var day = 1; day <= 7; day++) {
      map[MealCellKey(day, MealSlot.breakfast)] = day <= 5 ? 200.0 : null;
      map[MealCellKey(day, MealSlot.lunch)] = day <= 5 ? 250.0 : null;
      map[MealCellKey(day, MealSlot.dinner)] = switch (day) {
        1 || 3 || 4 => 200.0,
        2 => 250.0,
        _ => null, // Fri, Sat, Sun dinners skipped
      };
    }
    return map;
  }
}
