import 'package:equatable/equatable.dart';

enum BudgetCategoryType {
  savings('savings', 'Savings and Investments'),
  wants('wants', 'Wants'),
  needs('needs', 'Needs');

  const BudgetCategoryType(this.storageKey, this.defaultTitle);

  final String storageKey;
  final String defaultTitle;

  static BudgetCategoryType fromKey(String key) {
    return BudgetCategoryType.values.firstWhere(
      (e) => e.storageKey == key,
      orElse: () => BudgetCategoryType.needs,
    );
  }
}

enum VarianceStatus {
  onOrUnderBudget,
  overspent,
}

enum BudgetThresholdAlert {
  none,
  warning80,
  exceeded100,
}

class VarianceMetrics extends Equatable {
  const VarianceMetrics({
    required this.allocated,
    required this.actual,
    required this.difference,
    required this.status,
    required this.utilizationRatio,
    required this.thresholdAlert,
  });

  final double allocated;
  final double actual;
  final double difference;
  final VarianceStatus status;
  final double utilizationRatio;
  final BudgetThresholdAlert thresholdAlert;

  bool get isOverspent => status == VarianceStatus.overspent;

  @override
  List<Object?> get props => [
        allocated,
        actual,
        difference,
        status,
        utilizationRatio,
        thresholdAlert,
      ];
}

class SubsectionNode extends Equatable {
  const SubsectionNode({
    required this.id,
    required this.categoryId,
    required this.parentId,
    required this.name,
    required this.rawAllocated,
    required this.rawActual,
    required this.isFoodLinked,
    required this.sortOrder,
    this.children = const [],
    this.entryCount = 0,
  });

  final int id;
  final int categoryId;
  final int? parentId;
  final String name;
  final double rawAllocated;
  final double rawActual;
  final bool isFoodLinked;
  final int sortOrder;
  final List<SubsectionNode> children;
  final int entryCount;

  bool get isParent => children.isNotEmpty;

  /// Nested parent items automatically aggregate their children's allocated totals.
  double get effectiveAllocated => isParent
      ? children.fold<double>(0.0, (sum, c) => sum + c.effectiveAllocated)
      : rawAllocated;

  /// Nested parent items automatically aggregate their children's actual amounts.
  double get effectiveActual => isParent
      ? children.fold<double>(0.0, (sum, c) => sum + c.effectiveActual)
      : rawActual;

  VarianceMetrics get variance =>
      VarianceCalculator.compute(effectiveAllocated, effectiveActual);

  @override
  List<Object?> get props => [
        id,
        categoryId,
        parentId,
        name,
        rawAllocated,
        rawActual,
        isFoodLinked,
        sortOrder,
        children,
        entryCount,
      ];
}

class CategoryBudgetSummary extends Equatable {
  const CategoryBudgetSummary({
    required this.id,
    required this.cycleId,
    required this.name,
    required this.type,
    required this.allocatedAmount,
    required this.sortOrder,
    required this.subsections,
    required this.totalIncome,
  });

  final int id;
  final int cycleId;
  final String name;
  final BudgetCategoryType type;
  final double allocatedAmount;
  final int sortOrder;
  final List<SubsectionNode> subsections;
  final double totalIncome;

  double get subsectionAllocatedTotal =>
      subsections.fold<double>(0.0, (sum, s) => sum + s.effectiveAllocated);

  double get actualTotal =>
      subsections.fold<double>(0.0, (sum, s) => sum + s.effectiveActual);

  /// Difference compares the category's allocated budget against total actuals.
  VarianceMetrics get variance =>
      VarianceCalculator.compute(allocatedAmount, actualTotal);

  double get shareOfIncome =>
      totalIncome > 0 ? (allocatedAmount / totalIncome) : 0.0;

  /// Positive means room left to assign to subsections; negative means subsections exceed category allocation.
  double get subsectionAllocationDelta =>
      allocatedAmount - subsectionAllocatedTotal;

  @override
  List<Object?> get props => [
        id,
        cycleId,
        name,
        type,
        allocatedAmount,
        sortOrder,
        subsections,
        totalIncome,
      ];
}

class AllocationGuardrail extends Equatable {
  const AllocationGuardrail({
    required this.baseSalary,
    required this.supplementaryIncome,
    required this.totalCategoryAllocated,
  });

  final double baseSalary;
  final double supplementaryIncome;
  final double totalCategoryAllocated;

  double get totalIncome => baseSalary + supplementaryIncome;
  double get unallocatedBalance => totalIncome - totalCategoryAllocated;
  bool get isOverAllocated => unallocatedBalance < -0.005;
  bool get hasUnallocatedBalance => unallocatedBalance > 0.005;

  @override
  List<Object?> get props => [
        baseSalary,
        supplementaryIncome,
        totalCategoryAllocated,
      ];
}

class VarianceCalculator {
  static const double _epsilon = 1e-6;

  /// Validates that an allocated or actual monetary amount is non-negative.
  static double validateNonNegative(double value, {String fieldName = 'amount'}) {
    if (value.isNaN || value.isInfinite) {
      throw ArgumentError('$fieldName must be a finite number');
    }
    if (value < 0) {
      throw ArgumentError('$fieldName cannot be negative (received $value)');
    }
    return value;
  }

  /// Computes `difference = allocated - actual`, status, utilization, and threshold level.
  /// Rejects negative [allocated] or [actual], while allowing negative [difference].
  static VarianceMetrics compute(double allocated, double actual) {
    validateNonNegative(allocated, fieldName: 'allocated');
    validateNonNegative(actual, fieldName: 'actual');

    final rawDiff = allocated - actual;
    final diff = rawDiff.abs() < _epsilon ? 0.0 : rawDiff;
    final status =
        diff >= 0 ? VarianceStatus.onOrUnderBudget : VarianceStatus.overspent;

    final ratio = allocated > 0 ? (actual / allocated) : (actual > 0 ? 1.0 : 0.0);
    final BudgetThresholdAlert threshold;
    if (allocated > 0 && ratio >= 1.0 - _epsilon) {
      threshold = BudgetThresholdAlert.exceeded100;
    } else if (allocated > 0 && ratio >= 0.8 - _epsilon) {
      threshold = BudgetThresholdAlert.warning80;
    } else {
      threshold = BudgetThresholdAlert.none;
    }

    return VarianceMetrics(
      allocated: allocated,
      actual: actual,
      difference: diff,
      status: status,
      utilizationRatio: ratio,
      thresholdAlert: threshold,
    );
  }

  /// Builds a parent–child hierarchy from a flat list of subsection records.
  static List<SubsectionNode> buildHierarchy(List<SubsectionNode> flatItems) {
    final byParent = <int?, List<SubsectionNode>>{};
    for (final item in flatItems) {
      byParent.putIfAbsent(item.parentId, () => []).add(item);
    }

    List<SubsectionNode> attachChildren(int? parentId) {
      final list = List<SubsectionNode>.from(byParent[parentId] ?? const []);
      list.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return list
          .map(
            (node) => SubsectionNode(
              id: node.id,
              categoryId: node.categoryId,
              parentId: node.parentId,
              name: node.name,
              rawAllocated: node.rawAllocated,
              rawActual: node.rawActual,
              isFoodLinked: node.isFoodLinked,
              sortOrder: node.sortOrder,
              entryCount: node.entryCount,
              children: attachChildren(node.id),
            ),
          )
          .toList(growable: false);
    }

    return attachChildren(null);
  }
}
