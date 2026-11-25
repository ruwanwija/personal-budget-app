import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/features/budget/domain/shortfall_validator.dart';

void main() {
  group('ShortfallValidator', () {
    test('disables shortfall when actual_savings >= allocated_savings', () {
      final met = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 15000,
        reasonText: '',
      );
      expect(met.isShortfallActive, isFalse);
      expect(met.shortfallAmount, 0);
      expect(met.canCloseCycle, isTrue);
      expect(met.validationError, isNull);

      final exceeded = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 18500,
        reasonText: '',
      );
      expect(exceeded.isShortfallActive, isFalse);
      expect(exceeded.canCloseCycle, isTrue);
    });

    test('activates shortfall and blocks cycle close when reason is empty', () {
      final shortfall = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 12000,
        reasonText: '   ',
      );
      expect(shortfall.isShortfallActive, isTrue);
      expect(shortfall.shortfallAmount, 3000);
      expect(shortfall.canCloseCycle, isFalse);
      expect(shortfall.validationError, isNotNull);
    });

    test('allows cycle close when shortfall reason is provided', () {
      final justified = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 12000,
        reasonText: 'Emergency medical expense this month.',
      );
      expect(justified.isShortfallActive, isTrue);
      expect(justified.shortfallAmount, 3000);
      expect(justified.canCloseCycle, isTrue);
      expect(justified.validationError, isNull);
    });

    test('resets validation warning when actual is updated back to target', () {
      final reset = ShortfallValidator.evaluate(
        allocatedSavings: 15000,
        actualSavings: 15000,
        reasonText: '',
      );
      expect(reset.isShortfallActive, isFalse);
      expect(reset.canCloseCycle, isTrue);
      expect(reset.validationError, isNull);
    });
  });
}
