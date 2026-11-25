import 'package:equatable/equatable.dart';

class CycleWindow extends Equatable {
  const CycleWindow({
    required this.startDate,
    required this.endDate,
    required this.configuredStartDay,
  });

  final DateTime startDate;
  final DateTime endDate;
  final int configuredStartDay;

  int get totalDays => endDate.difference(startDate).inDays + 1;

  bool contains(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return !d.isBefore(startDate) && !d.isAfter(endDate);
  }

  @override
  List<Object?> get props => [startDate, endDate, configuredStartDay];
}

class CycleWeekSpan extends Equatable {
  const CycleWeekSpan({
    required this.weekIndex,
    required this.startDate,
    required this.endDate,
  });

  final int weekIndex;
  final DateTime startDate;
  final DateTime endDate;

  int get dayCount => endDate.difference(startDate).inDays + 1;

  @override
  List<Object?> get props => [weekIndex, startDate, endDate];
}

class CycleDateCalculator {
  static const int minStartDay = 1;
  static const int maxStartDay = 31;

  /// Validates that [startDay] is within [1, 31].
  static int validateStartDay(int startDay) {
    if (startDay < minStartDay || startDay > maxStartDay) {
      throw RangeError.range(startDay, minStartDay, maxStartDay, 'startDay');
    }
    return startDay;
  }

  /// Returns the number of days in the specified [year] and [month] (1..12).
  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  /// Clamps [day] to the last valid calendar day of ([year], [month]).
  /// For example, day=31 in February 2026 -> Feb 28; February 2024 -> Feb 29.
  static DateTime clampDate(int year, int month, int day) {
    final maxDay = daysInMonth(year, month);
    final clampedDay = day.clamp(1, maxDay);
    return DateTime(year, month, clampedDay);
  }

  /// Builds the cycle starting in ([year], [month]) with [startDay] clamped to
  /// valid month lengths and ending the day before the next month's clamped start.
  static CycleWindow cycleForStartMonth(int year, int month, int startDay) {
    validateStartDay(startDay);
    final start = clampDate(year, month, startDay);
    final nextMonthYear = month == 12 ? year + 1 : year;
    final nextMonth = month == 12 ? 1 : month + 1;
    final nextStart = clampDate(nextMonthYear, nextMonth, startDay);
    final end = nextStart.subtract(const Duration(days: 1));
    return CycleWindow(
      startDate: start,
      endDate: end,
      configuredStartDay: startDay,
    );
  }

  /// Calculates the active [CycleWindow] containing [referenceDate] for [startDay].
  static CycleWindow activeCycleForDate(DateTime referenceDate, int startDay) {
    validateStartDay(startDay);
    final ref = DateTime(
      referenceDate.year,
      referenceDate.month,
      referenceDate.day,
    );
    final thisMonthStart = clampDate(ref.year, ref.month, startDay);
    if (!ref.isBefore(thisMonthStart)) {
      return cycleForStartMonth(ref.year, ref.month, startDay);
    }
    final prevYear = ref.month == 1 ? ref.year - 1 : ref.year;
    final prevMonth = ref.month == 1 ? 12 : ref.month - 1;
    return cycleForStartMonth(prevYear, prevMonth, startDay);
  }

  /// Calculates the next cycle starting immediately after [previousCycle].
  /// If [nextStartDay] differs from [previousCycle.configuredStartDay], the next
  /// cycle begins the day after [previousCycle.endDate] and ends on the day before
  /// the next occurrence of [nextStartDay] (at least 1 day long) so there are zero
  /// gaps or overlaps between archived and active cycles.
  static CycleWindow nextCycleAfter(
    CycleWindow previousCycle, {
    int? nextStartDay,
  }) {
    final effectiveStartDay = validateStartDay(
      nextStartDay ?? previousCycle.configuredStartDay,
    );
    final nextStart = previousCycle.endDate.add(const Duration(days: 1));

    if (nextStartDay == null ||
        nextStartDay == previousCycle.configuredStartDay) {
      return cycleForStartMonth(
        nextStart.year,
        nextStart.month,
        effectiveStartDay,
      );
    }

    // Align the new cycle's end date to the new start day in the next month.
    var candidateYear = nextStart.year;
    var candidateMonth = nextStart.month;
    var followingStart = clampDate(
      candidateYear,
      candidateMonth,
      effectiveStartDay,
    );
    if (!followingStart.isAfter(nextStart)) {
      candidateYear = candidateMonth == 12 ? candidateYear + 1 : candidateYear;
      candidateMonth = candidateMonth == 12 ? 1 : candidateMonth + 1;
      followingStart = clampDate(
        candidateYear,
        candidateMonth,
        effectiveStartDay,
      );
    }

    return CycleWindow(
      startDate: nextStart,
      endDate: followingStart.subtract(const Duration(days: 1)),
      configuredStartDay: effectiveStartDay,
    );
  }

  /// Returns days remaining in [window] from [today] (inclusive of today).
  /// Returns 0 if [today] is past [window.endDate].
  static int daysRemaining(CycleWindow window, DateTime today) {
    final d = DateTime(today.year, today.month, today.day);
    if (d.isAfter(window.endDate)) return 0;
    if (d.isBefore(window.startDate)) return window.totalDays;
    return window.endDate.difference(d).inDays + 1;
  }

  /// Splits [window] into sequential weekly spans (up to 7 days each) for
  /// mode-wise weekly meal assignments.
  static List<CycleWeekSpan> splitIntoWeeks(CycleWindow window) {
    final spans = <CycleWeekSpan>[];
    var cursor = window.startDate;
    var index = 1;
    while (!cursor.isAfter(window.endDate)) {
      final tentativeEnd = cursor.add(const Duration(days: 6));
      final spanEnd =
          tentativeEnd.isAfter(window.endDate) ? window.endDate : tentativeEnd;
      spans.add(
        CycleWeekSpan(
          weekIndex: index,
          startDate: cursor,
          endDate: spanEnd,
        ),
      );
      cursor = spanEnd.add(const Duration(days: 1));
      index++;
    }
    return spans;
  }
}
