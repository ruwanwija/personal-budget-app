import 'package:equatable/equatable.dart';

enum MealSlot {
  breakfast('breakfast', 'Breakfast'),
  lunch('lunch', 'Lunch'),
  dinner('dinner', 'Dinner');

  const MealSlot(this.storageKey, this.label);

  final String storageKey;
  final String label;

  static MealSlot fromKey(String key) {
    return MealSlot.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => MealSlot.breakfast,
    );
  }
}

class MealCellKey extends Equatable {
  const MealCellKey(this.dayOfWeek, this.slot);

  /// 1 = Monday .. 7 = Sunday
  final int dayOfWeek;
  final MealSlot slot;

  @override
  List<Object?> get props => [dayOfWeek, slot];
}

class WeeklyMealOverrideData extends Equatable {
  const WeeklyMealOverrideData({
    required this.dayOfWeek,
    required this.slot,
    required this.amount,
    required this.isSkipped,
  });

  final int dayOfWeek;
  final MealSlot slot;
  final double? amount;
  final bool isSkipped;

  @override
  List<Object?> get props => [dayOfWeek, slot, amount, isSkipped];
}

class WeeklyMealPlanSummary extends Equatable {
  const WeeklyMealPlanSummary({
    required this.assignmentId,
    required this.weekIndex,
    required this.modeId,
    required this.modeName,
    required this.computedTotal,
    required this.overrideTotal,
    required this.effectiveCells,
    required this.overrideKeys,
  });

  final int assignmentId;
  final int weekIndex;
  final int modeId;
  final String modeName;
  final double computedTotal;
  final double? overrideTotal;
  final Map<MealCellKey, double?> effectiveCells;
  final Set<MealCellKey> overrideKeys;

  double get effectiveTotal => overrideTotal ?? computedTotal;

  @override
  List<Object?> get props => [
        assignmentId,
        weekIndex,
        modeId,
        modeName,
        computedTotal,
        overrideTotal,
        effectiveCells,
        overrideKeys,
      ];
}

class MealCalculator {
  static const List<String> shortDayNames = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> fullDayNames = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  /// Safely evaluates blank/skipped (`null`) slots to 0 without null errors.
  static double slotAmountOrZero(double? amount) {
    if (amount == null || amount.isNaN || amount.isInfinite) {
      return 0.0;
    }
    if (amount < 0) {
      throw ArgumentError('Meal amount cannot be negative (received $amount)');
    }
    return amount;
  }

  /// Resolves the effective cell amount (null indicates a skipped `—` slot).
  static double? effectiveCellAmount({
    required double? templateAmount,
    WeeklyMealOverrideData? override,
  }) {
    if (override != null) {
      if (override.isSkipped) return null;
      return override.amount;
    }
    return templateAmount;
  }

  /// Computes total for a 7-day mode template matrix.
  static double computeTemplateWeeklyTotal(
    Map<MealCellKey, double?> templateCells,
  ) {
    var total = 0.0;
    for (var day = 1; day <= 7; day++) {
      for (final slot in MealSlot.values) {
        total += slotAmountOrZero(templateCells[MealCellKey(day, slot)]);
      }
    }
    return total;
  }

  /// Computes effective 21-slot matrix and total for a single week in a cycle,
  /// applying per-day overrides without mutating the base mode template.
  static ({
    Map<MealCellKey, double?> effectiveCells,
    double total,
  }) computeWeekWithOverrides({
    required Map<MealCellKey, double?> templateCells,
    required Map<MealCellKey, WeeklyMealOverrideData> overrides,
    double? overrideTotal,
  }) {
    final effective = <MealCellKey, double?>{};
    var sum = 0.0;

    for (var day = 1; day <= 7; day++) {
      for (final slot in MealSlot.values) {
        final key = MealCellKey(day, slot);
        final amount = effectiveCellAmount(
          templateAmount: templateCells[key],
          override: overrides[key],
        );
        effective[key] = amount;
        sum += slotAmountOrZero(amount);
      }
    }

    if (overrideTotal != null) {
      slotAmountOrZero(overrideTotal);
    }

    return (
      effectiveCells: effective,
      total: overrideTotal ?? sum,
    );
  }

  /// Computes total for a single day (1..7) within a cell map.
  static double computeDayTotal(
    Map<MealCellKey, double?> cells,
    int dayOfWeek,
  ) {
    var total = 0.0;
    for (final slot in MealSlot.values) {
      total += slotAmountOrZero(cells[MealCellKey(dayOfWeek, slot)]);
    }
    return total;
  }

  /// Computes total for a single meal slot (Breakfast, Lunch, or Dinner) across Mon–Sun.
  static double computeSlotWeeklyTotal(
    Map<MealCellKey, double?> cells,
    MealSlot slot,
  ) {
    var total = 0.0;
    for (var day = 1; day <= 7; day++) {
      total += slotAmountOrZero(cells[MealCellKey(day, slot)]);
    }
    return total;
  }

  /// Sums all weekly meal totals in a budget cycle to synchronize with the Food subsection.
  static double computeCycleFoodTotal(List<double> weeklyTotals) {
    return weeklyTotals.fold<double>(
      0.0,
      (sum, week) => sum + slotAmountOrZero(week),
    );
  }
}
