import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum CurrencyFormatStyle {
  slashEquals('slash_equals', '72,000/='),
  lkrDecimal('lkr_decimal', 'LKR 72,000.00'),
  usdDecimal('usd_decimal', r'$72,000.00');

  const CurrencyFormatStyle(this.storageKey, this.exampleLabel);

  final String storageKey;
  final String exampleLabel;

  static CurrencyFormatStyle fromKey(String? key) {
    return CurrencyFormatStyle.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => CurrencyFormatStyle.slashEquals,
    );
  }
}

class CurrencyFormatter {
  static final NumberFormat _intFormat = NumberFormat('#,##0', 'en_US');
  static final NumberFormat _decFormat = NumberFormat('#,##0.00', 'en_US');

  static String format(
    double amount, {
    CurrencyFormatStyle style = CurrencyFormatStyle.slashEquals,
    bool showPlusSign = false,
  }) {
    final normalized = amount.abs() < 0.005 ? 0.0 : amount;
    final isNegative = normalized < 0;
    final absVal = normalized.abs();
    final sign = isNegative ? '-' : (showPlusSign && normalized > 0 ? '+' : '');

    switch (style) {
      case CurrencyFormatStyle.slashEquals:
        final isWhole = (absVal - absVal.roundToDouble()).abs() < 0.005;
        final formatted = isWhole
            ? _intFormat.format(absVal.round())
            : _decFormat.format(absVal);
        return '$sign$formatted/=';
      case CurrencyFormatStyle.lkrDecimal:
        return '${sign}LKR ${_decFormat.format(absVal)}';
      case CurrencyFormatStyle.usdDecimal:
        return '$sign\$${_decFormat.format(absVal)}';
    }
  }

  static String formatCompactInput(double amount) {
    final normalized = amount.abs() < 0.005 ? 0.0 : amount;
    final isWhole = (normalized - normalized.roundToDouble()).abs() < 0.005;
    if (isWhole) {
      return normalized.round().toString();
    }
    return normalized.toStringAsFixed(2);
  }

  static String formatPercent(double ratio) {
    if (ratio.isNaN || ratio.isInfinite) return '0.0%';
    return '${(ratio * 100).toStringAsFixed(1)}%';
  }
}

/// Rejects negative values and non-numeric input for Allocated / Actual fields.
class NonNegativeDecimalInputFormatter extends TextInputFormatter {
  NonNegativeDecimalInputFormatter({this.maxDecimalPlaces = 2});

  final int maxDecimalPlaces;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }
    // Reject negative signs or invalid symbols immediately.
    final regex = RegExp('^\\d*(?:\\.\\d{0,$maxDecimalPlaces})?\$');
    if (regex.hasMatch(text)) {
      return newValue;
    }
    return oldValue;
  }
}
