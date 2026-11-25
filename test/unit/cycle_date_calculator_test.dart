import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/features/cycles/domain/cycle_date_calculator.dart';

void main() {
  group('CycleDateCalculator', () {
    test('calculates standard custom start day window (25th -> 24th)', () {
      final window = CycleDateCalculator.activeCycleForDate(
        DateTime(2026, 3, 27),
        25,
      );
      expect(window.startDate, DateTime(2026, 3, 25));
      expect(window.endDate, DateTime(2026, 4, 24));
      expect(window.configuredStartDay, 25);
    });

    test('falls back to previous month when reference date is before start day',
        () {
      final window = CycleDateCalculator.activeCycleForDate(
        DateTime(2026, 3, 24),
        25,
      );
      expect(window.startDate, DateTime(2026, 2, 25));
      expect(window.endDate, DateTime(2026, 3, 24));
    });

    test('handles calendar month start day = 1 across short months', () {
      final feb = CycleDateCalculator.activeCycleForDate(
        DateTime(2026, 2, 15),
        1,
      );
      expect(feb.startDate, DateTime(2026, 2, 1));
      expect(feb.endDate, DateTime(2026, 2, 28));

      final leapFeb = CycleDateCalculator.activeCycleForDate(
        DateTime(2024, 2, 15),
        1,
      );
      expect(leapFeb.startDate, DateTime(2024, 2, 1));
      expect(leapFeb.endDate, DateTime(2024, 2, 29));
    });

    test('clamps start day 31 in non-leap February and April without gaps', () {
      final janCycle = CycleDateCalculator.cycleForStartMonth(2026, 1, 31);
      expect(janCycle.startDate, DateTime(2026, 1, 31));
      expect(janCycle.endDate, DateTime(2026, 2, 27));

      final febCycle = CycleDateCalculator.nextCycleAfter(janCycle);
      expect(febCycle.startDate, DateTime(2026, 2, 28));
      expect(febCycle.endDate, DateTime(2026, 3, 30));

      final marCycle = CycleDateCalculator.nextCycleAfter(febCycle);
      expect(marCycle.startDate, DateTime(2026, 3, 31));
      expect(marCycle.endDate, DateTime(2026, 4, 29));

      final aprCycle = CycleDateCalculator.nextCycleAfter(marCycle);
      expect(aprCycle.startDate, DateTime(2026, 4, 30));
      expect(aprCycle.endDate, DateTime(2026, 5, 30));
    });

    test('clamps start day 31 in leap year February (2024)', () {
      final activeOn28 = CycleDateCalculator.activeCycleForDate(
        DateTime(2024, 2, 28),
        31,
      );
      expect(activeOn28.startDate, DateTime(2024, 1, 31));
      expect(activeOn28.endDate, DateTime(2024, 2, 28));

      final activeOn29 = CycleDateCalculator.activeCycleForDate(
        DateTime(2024, 2, 29),
        31,
      );
      expect(activeOn29.startDate, DateTime(2024, 2, 29));
      expect(activeOn29.endDate, DateTime(2024, 3, 30));
    });

    test('handles year rollover cleanly (Dec -> Jan)', () {
      final dec = CycleDateCalculator.activeCycleForDate(
        DateTime(2026, 12, 28),
        25,
      );
      expect(dec.startDate, DateTime(2026, 12, 25));
      expect(dec.endDate, DateTime(2027, 1, 24));

      final janBefore = CycleDateCalculator.activeCycleForDate(
        DateTime(2027, 1, 10),
        25,
      );
      expect(janBefore.startDate, DateTime(2026, 12, 25));
      expect(janBefore.endDate, DateTime(2027, 1, 24));
    });

    test('applies changed start day to next cycle without overlap or gap', () {
      final current = CycleDateCalculator.cycleForStartMonth(2026, 3, 25);
      // Ends April 24 -> next cycle starts April 25, aligns to new start day 1 -> ends April 30
      final next = CycleDateCalculator.nextCycleAfter(current, nextStartDay: 1);
      expect(next.startDate, DateTime(2026, 4, 25));
      expect(next.endDate, DateTime(2026, 4, 30));
      expect(next.configuredStartDay, 1);

      final following = CycleDateCalculator.nextCycleAfter(next);
      expect(following.startDate, DateTime(2026, 5, 1));
      expect(following.endDate, DateTime(2026, 5, 31));
    });

    test('rejects invalid start day values outside 1..31', () {
      expect(
        () => CycleDateCalculator.validateStartDay(0),
        throwsArgumentError,
      );
      expect(
        () => CycleDateCalculator.validateStartDay(32),
        throwsArgumentError,
      );
    });

    test('computes days remaining and weekly spans accurately', () {
      final window = CycleDateCalculator.cycleForStartMonth(2026, 3, 25);
      // Mar 25 .. Apr 24 = 31 days -> 5 spans (7, 7, 7, 7, 3)
      expect(window.totalDays, 31);
      expect(
        CycleDateCalculator.daysRemaining(window, DateTime(2026, 4, 24)),
        1,
      );
      expect(
        CycleDateCalculator.daysRemaining(window, DateTime(2026, 4, 25)),
        0,
      );
      final weeks = CycleDateCalculator.splitIntoWeeks(window);
      expect(weeks.length, 5);
      expect(weeks.first.dayCount, 7);
      expect(weeks.last.dayCount, 3);
      expect(weeks.last.endDate, DateTime(2026, 4, 24));
    });
  });
}
