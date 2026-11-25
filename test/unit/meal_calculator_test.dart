import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';

void main() {
  Map<MealCellKey, double?> buildNotGoHomeTemplate() {
    final map = <MealCellKey, double?>{};
    for (var day = 1; day <= 7; day++) {
      map[MealCellKey(day, MealSlot.breakfast)] = 200;
      map[MealCellKey(day, MealSlot.lunch)] = 250;
      map[MealCellKey(day, MealSlot.dinner)] = switch (day) {
        2 => 250,
        6 || 7 => 500,
        _ => 200,
      };
    }
    return map;
  }

  Map<MealCellKey, double?> buildGoHomeTemplate() {
    final map = <MealCellKey, double?>{};
    for (var day = 1; day <= 7; day++) {
      map[MealCellKey(day, MealSlot.breakfast)] = day <= 5 ? 200 : null;
      map[MealCellKey(day, MealSlot.lunch)] = day <= 5 ? 250 : null;
      map[MealCellKey(day, MealSlot.dinner)] = switch (day) {
        1 || 3 || 4 => 200,
        2 => 250,
        _ => null,
      };
    }
    return map;
  }

  group('MealCalculator', () {
    test('computes Not Go Home weekly total accurately (5,200/=)', () {
      final template = buildNotGoHomeTemplate();
      expect(MealCalculator.computeTemplateWeeklyTotal(template), 5200);
      expect(MealCalculator.computeSlotWeeklyTotal(template, MealSlot.breakfast), 1400);
      expect(MealCalculator.computeSlotWeeklyTotal(template, MealSlot.lunch), 1750);
      expect(MealCalculator.computeSlotWeeklyTotal(template, MealSlot.dinner), 2050);
    });

    test('treats blank/skipped null slots as 0 without null errors (Go Home = 3,100/=)', () {
      final template = buildGoHomeTemplate();
      expect(MealCalculator.computeTemplateWeeklyTotal(template), 3100);
      expect(MealCalculator.computeDayTotal(template, 6), 0);
      expect(MealCalculator.computeDayTotal(template, 7), 0);
      expect(MealCalculator.slotAmountOrZero(null), 0);
    });

    test('applies per-week daily overrides without mutating base template', () {
      final template = buildNotGoHomeTemplate();
      final overrides = {
        const MealCellKey(6, MealSlot.dinner): const WeeklyMealOverrideData(
          dayOfWeek: 6,
          slot: MealSlot.dinner,
          amount: null,
          isSkipped: true,
        ),
        const MealCellKey(1, MealSlot.lunch): const WeeklyMealOverrideData(
          dayOfWeek: 1,
          slot: MealSlot.lunch,
          amount: 400,
          isSkipped: false,
        ),
      };

      final result = MealCalculator.computeWeekWithOverrides(
        templateCells: template,
        overrides: overrides,
      );

      // 5200 - 500 (Sat dinner skipped) + 150 (Mon lunch 250 -> 400) = 4850
      expect(result.total, 4850);
      expect(result.effectiveCells[const MealCellKey(6, MealSlot.dinner)], isNull);
      // Base template remains unchanged
      expect(template[const MealCellKey(6, MealSlot.dinner)], 500);
    });

    test('rolls up monthly cycle food total across mixed weekly modes', () {
      // 2 weeks Not Go Home (5200) + 2 weeks Go Home (3100) = 16,600/=
      final monthlyTotal = MealCalculator.computeCycleFoodTotal([
        5200,
        3100,
        5200,
        3100,
      ]);
      expect(monthlyTotal, 16600);
    });
  });
}
