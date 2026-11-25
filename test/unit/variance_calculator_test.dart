import 'package:flutter_test/flutter_test.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';

void main() {
  group('VarianceCalculator', () {
    test('computes positive and zero variance as onOrUnderBudget', () {
      final under = VarianceCalculator.compute(10500, 9000);
      expect(under.difference, 1500);
      expect(under.status, VarianceStatus.onOrUnderBudget);
      expect(under.isOverspent, isFalse);
      expect(under.thresholdAlert, BudgetThresholdAlert.warning80);

      final exact = VarianceCalculator.compute(5000, 5000);
      expect(exact.difference, 0);
      expect(exact.status, VarianceStatus.onOrUnderBudget);
      expect(exact.thresholdAlert, BudgetThresholdAlert.exceeded100);
    });

    test('computes negative variance as overspent', () {
      final over = VarianceCalculator.compute(8000, 9250);
      expect(over.difference, -1250);
      expect(over.status, VarianceStatus.overspent);
      expect(over.isOverspent, isTrue);
      expect(over.thresholdAlert, BudgetThresholdAlert.exceeded100);
    });

    test('rejects negative allocated or actual input', () {
      expect(() => VarianceCalculator.compute(-100, 0), throwsArgumentError);
      expect(() => VarianceCalculator.compute(100, -1), throwsArgumentError);
    });

    test('auto-rolls up nested parent-child subsections', () {
      final flat = [
        const SubsectionNode(
          id: 10,
          categoryId: 3,
          parentId: null,
          name: 'Fashion',
          rawAllocated: 0,
          rawActual: 0,
          isFoodLinked: false,
          sortOrder: 0,
        ),
        const SubsectionNode(
          id: 11,
          categoryId: 3,
          parentId: 10,
          name: 'Grooming',
          rawAllocated: 1500,
          rawActual: 1200,
          isFoodLinked: false,
          sortOrder: 0,
        ),
        const SubsectionNode(
          id: 12,
          categoryId: 3,
          parentId: 10,
          name: 'Shopping',
          rawAllocated: 3500,
          rawActual: 4000,
          isFoodLinked: false,
          sortOrder: 1,
        ),
      ];

      final tree = VarianceCalculator.buildHierarchy(flat);
      expect(tree.length, 1);
      final fashion = tree.first;
      expect(fashion.isParent, isTrue);
      expect(fashion.effectiveAllocated, 5000);
      expect(fashion.effectiveActual, 5200);
      expect(fashion.variance.difference, -200);
      expect(fashion.variance.isOverspent, isTrue);
    });

    test('computes allocation guardrail warnings accurately', () {
      const balanced = AllocationGuardrail(
        baseSalary: 72000,
        supplementaryIncome: 0,
        totalCategoryAllocated: 72000,
      );
      expect(balanced.unallocatedBalance, 0);
      expect(balanced.isOverAllocated, isFalse);
      expect(balanced.hasUnallocatedBalance, isFalse);

      const over = AllocationGuardrail(
        baseSalary: 72000,
        supplementaryIncome: 3000,
        totalCategoryAllocated: 80000,
      );
      expect(over.totalIncome, 75000);
      expect(over.unallocatedBalance, -5000);
      expect(over.isOverAllocated, isTrue);
    });
  });
}
