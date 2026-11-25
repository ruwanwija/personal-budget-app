import 'package:equatable/equatable.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';

class ShortfallEvaluation extends Equatable {
  const ShortfallEvaluation({
    required this.allocatedSavings,
    required this.actualSavings,
    required this.shortfallAmount,
    required this.isShortfallActive,
    required this.reasonText,
    required this.canCloseCycle,
    this.validationError,
  });

  final double allocatedSavings;
  final double actualSavings;
  final double shortfallAmount;
  final bool isShortfallActive;
  final String reasonText;
  final bool canCloseCycle;
  final String? validationError;

  @override
  List<Object?> get props => [
        allocatedSavings,
        actualSavings,
        shortfallAmount,
        isShortfallActive,
        reasonText,
        canCloseCycle,
        validationError,
      ];
}

class ShortfallValidator {
  static const double _epsilon = 1e-6;
  static const String requiredReasonMessage =
      'Savings are below your allocated target. Please enter a reason for the shortfall before closing this cycle.';

  /// Evaluates whether the Savings & Investments shortfall box must be enabled
  /// and whether the active cycle is allowed to close.
  static ShortfallEvaluation evaluate({
    required double allocatedSavings,
    required double actualSavings,
    required String reasonText,
  }) {
    VarianceCalculator.validateNonNegative(
      allocatedSavings,
      fieldName: 'allocatedSavings',
    );
    VarianceCalculator.validateNonNegative(
      actualSavings,
      fieldName: 'actualSavings',
    );

    final rawShortfall = allocatedSavings - actualSavings;
    final isShortfallActive = rawShortfall > _epsilon;
    final shortfallAmount = isShortfallActive ? rawShortfall : 0.0;

    if (!isShortfallActive) {
      return ShortfallEvaluation(
        allocatedSavings: allocatedSavings,
        actualSavings: actualSavings,
        shortfallAmount: 0.0,
        isShortfallActive: false,
        reasonText: reasonText,
        canCloseCycle: true,
        validationError: null,
      );
    }

    final hasReason = reasonText.trim().isNotEmpty;
    return ShortfallEvaluation(
      allocatedSavings: allocatedSavings,
      actualSavings: actualSavings,
      shortfallAmount: shortfallAmount,
      isShortfallActive: true,
      reasonText: reasonText,
      canCloseCycle: hasReason,
      validationError: hasReason ? null : requiredReasonMessage,
    );
  }
}
