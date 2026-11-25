import 'package:drift/drift.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/features/budget/domain/shortfall_validator.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:rxdart/rxdart.dart';

class CycleBudgetSnapshot {
  const CycleBudgetSnapshot({
    required this.cycle,
    required this.supplementaryIncomes,
    required this.categories,
    required this.guardrail,
    required this.shortfall,
    required this.shortfallLog,
  });

  final BudgetCycle cycle;
  final List<SupplementaryIncome> supplementaryIncomes;
  final List<CategoryBudgetSummary> categories;
  final AllocationGuardrail guardrail;
  final ShortfallEvaluation shortfall;
  final SavingsShortfallLog? shortfallLog;

  double get totalIncome => guardrail.totalIncome;
  double get totalCategoryAllocated => guardrail.totalCategoryAllocated;
  double get totalActualSpend =>
      categories.fold<double>(0.0, (sum, c) => sum + c.actualTotal);
  double get totalDifference => totalCategoryAllocated - totalActualSpend;

  CategoryBudgetSummary? categoryByType(BudgetCategoryType type) {
    for (final c in categories) {
      if (c.type == type) return c;
    }
    return null;
  }
}

class SubsectionUpdateResult {
  const SubsectionUpdateResult({
    required this.subsectionName,
    required this.variance,
  });

  final String subsectionName;
  final VarianceMetrics variance;
}

class BudgetRepository {
  BudgetRepository(this._db);

  final AppDatabase _db;

  Stream<CycleBudgetSnapshot?> watchCycleBudgetSnapshot(int cycleId) {
    final cycleStream = (_db.select(_db.budgetCycles)
          ..where((c) => c.id.equals(cycleId)))
        .watchSingleOrNull();

    final incomesStream = (_db.select(_db.supplementaryIncomes)
          ..where((i) => i.cycleId.equals(cycleId)))
        .watch();

    final categoriesStream = (_db.select(_db.categories)
          ..where((c) => c.cycleId.equals(cycleId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch();

    final subsectionsStream = _db.select(_db.subsections).watch();
    final entriesStream = _db.select(_db.subsectionEntries).watch();
    final shortfallStream = (_db.select(_db.savingsShortfallLogs)
          ..where((s) => s.cycleId.equals(cycleId)))
        .watchSingleOrNull();

    return Rx.combineLatest6(
      cycleStream,
      incomesStream,
      categoriesStream,
      subsectionsStream,
      entriesStream,
      shortfallStream,
      (
        BudgetCycle? cycle,
        List<SupplementaryIncome> incomes,
        List<Category> cats,
        List<Subsection> allSubs,
        List<SubsectionEntry> allEntries,
        SavingsShortfallLog? shortfallLog,
      ) {
        if (cycle == null) return null;
        return _assembleSnapshot(
          cycle: cycle,
          incomes: incomes,
          cats: cats,
          allSubs: allSubs,
          allEntries: allEntries,
          shortfallLog: shortfallLog,
        );
      },
    );
  }

  Future<CycleBudgetSnapshot?> getCycleBudgetSnapshot(int cycleId) async {
    final cycle = await (_db.select(_db.budgetCycles)
          ..where((c) => c.id.equals(cycleId)))
        .getSingleOrNull();
    if (cycle == null) return null;

    final incomes = await (_db.select(_db.supplementaryIncomes)
          ..where((i) => i.cycleId.equals(cycleId)))
        .get();
    final cats = await (_db.select(_db.categories)
          ..where((c) => c.cycleId.equals(cycleId))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
    final catIds = cats.map((c) => c.id).toList();
    final subs = catIds.isEmpty
        ? <Subsection>[]
        : await (_db.select(_db.subsections)
              ..where((s) => s.categoryId.isIn(catIds)))
            .get();
    final subIds = subs.map((s) => s.id).toList();
    final entries = subIds.isEmpty
        ? <SubsectionEntry>[]
        : await (_db.select(_db.subsectionEntries)
              ..where((e) => e.subsectionId.isIn(subIds)))
            .get();
    final shortfallLog = await (_db.select(_db.savingsShortfallLogs)
          ..where((s) => s.cycleId.equals(cycleId)))
        .getSingleOrNull();

    return _assembleSnapshot(
      cycle: cycle,
      incomes: incomes,
      cats: cats,
      allSubs: subs,
      allEntries: entries,
      shortfallLog: shortfallLog,
    );
  }

  CycleBudgetSnapshot _assembleSnapshot({
    required BudgetCycle cycle,
    required List<SupplementaryIncome> incomes,
    required List<Category> cats,
    required List<Subsection> allSubs,
    required List<SubsectionEntry> allEntries,
    required SavingsShortfallLog? shortfallLog,
  }) {
    final supplementaryTotal =
        incomes.fold<double>(0.0, (sum, i) => sum + i.amount);
    final totalIncome = cycle.salaryAmount + supplementaryTotal;

    final entryCounts = <int, int>{};
    for (final e in allEntries) {
      entryCounts[e.subsectionId] = (entryCounts[e.subsectionId] ?? 0) + 1;
    }

    final catSummaries = cats.map((cat) {
      final flatNodes = allSubs
          .where((s) => s.categoryId == cat.id)
          .map(
            (s) => SubsectionNode(
              id: s.id,
              categoryId: s.categoryId,
              parentId: s.parentId,
              name: s.name,
              rawAllocated: s.allocatedAmount,
              rawActual: s.actualAmount,
              isFoodLinked: s.isFoodLinked,
              sortOrder: s.sortOrder,
              entryCount: entryCounts[s.id] ?? 0,
            ),
          )
          .toList();

      final tree = VarianceCalculator.buildHierarchy(flatNodes);

      return CategoryBudgetSummary(
        id: cat.id,
        cycleId: cat.cycleId,
        name: cat.name,
        type: BudgetCategoryType.fromKey(cat.categoryType),
        allocatedAmount: cat.allocatedAmount,
        sortOrder: cat.sortOrder,
        subsections: tree,
        totalIncome: totalIncome,
      );
    }).toList();

    final totalCategoryAllocated =
        catSummaries.fold<double>(0.0, (sum, c) => sum + c.allocatedAmount);

    final guardrail = AllocationGuardrail(
      baseSalary: cycle.salaryAmount,
      supplementaryIncome: supplementaryTotal,
      totalCategoryAllocated: totalCategoryAllocated,
    );

    final savingsCat = catSummaries.where(
      (c) => c.type == BudgetCategoryType.savings,
    );
    final allocatedSavings =
        savingsCat.isEmpty ? 0.0 : savingsCat.first.allocatedAmount;
    final actualSavings =
        savingsCat.isEmpty ? 0.0 : savingsCat.first.actualTotal;

    final shortfall = ShortfallValidator.evaluate(
      allocatedSavings: allocatedSavings,
      actualSavings: actualSavings,
      reasonText: shortfallLog?.reasonText ?? '',
    );

    return CycleBudgetSnapshot(
      cycle: cycle,
      supplementaryIncomes: incomes,
      categories: catSummaries,
      guardrail: guardrail,
      shortfall: shortfall,
      shortfallLog: shortfallLog,
    );
  }

  Future<void> _assertCategoryCycleOpen(int categoryId) async {
    final cat = await (_db.select(_db.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
    if (cat == null) throw StateError('Category not found');
    final cycle = await (_db.select(_db.budgetCycles)
          ..where((c) => c.id.equals(cat.cycleId)))
        .getSingleOrNull();
    if (cycle == null || cycle.isClosed) {
      throw StateError('Archived cycles are read-only.');
    }
  }

  Future<void> updateCategoryAllocation({
    required int categoryId,
    required double allocatedAmount,
  }) async {
    VarianceCalculator.validateNonNegative(
      allocatedAmount,
      fieldName: 'allocatedAmount',
    );
    await _assertCategoryCycleOpen(categoryId);
    await (_db.update(_db.categories)..where((c) => c.id.equals(categoryId)))
        .write(CategoriesCompanion(allocatedAmount: Value(allocatedAmount)));
  }

  Future<SubsectionUpdateResult> updateSubsectionValues({
    required int subsectionId,
    double? allocatedAmount,
    double? actualAmount,
  }) async {
    if (allocatedAmount != null) {
      VarianceCalculator.validateNonNegative(
        allocatedAmount,
        fieldName: 'allocatedAmount',
      );
    }
    if (actualAmount != null) {
      VarianceCalculator.validateNonNegative(
        actualAmount,
        fieldName: 'actualAmount',
      );
    }

    final existing = await (_db.select(_db.subsections)
          ..where((s) => s.id.equals(subsectionId)))
        .getSingle();
    await _assertCategoryCycleOpen(existing.categoryId);

    final nextAllocated = allocatedAmount ?? existing.allocatedAmount;
    final nextActual = actualAmount ?? existing.actualAmount;

    await (_db.update(_db.subsections)..where((s) => s.id.equals(subsectionId)))
        .write(
      SubsectionsCompanion(
        allocatedAmount: Value(nextAllocated),
        actualAmount: Value(nextActual),
      ),
    );

    return SubsectionUpdateResult(
      subsectionName: existing.name,
      variance: VarianceCalculator.compute(nextAllocated, nextActual),
    );
  }

  Future<int> addSubsection({
    required int categoryId,
    int? parentId,
    required String name,
    required double allocatedAmount,
    double actualAmount = 0.0,
    bool isFoodLinked = false,
  }) async {
    VarianceCalculator.validateNonNegative(
      allocatedAmount,
      fieldName: 'allocatedAmount',
    );
    VarianceCalculator.validateNonNegative(
      actualAmount,
      fieldName: 'actualAmount',
    );
    await _assertCategoryCycleOpen(categoryId);

    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Subsection name cannot be empty');
    }

    final siblings = await (_db.select(_db.subsections)
          ..where(
            (s) =>
                s.categoryId.equals(categoryId) &
                (parentId == null
                    ? s.parentId.isNull()
                    : s.parentId.equals(parentId)),
          ))
        .get();

    return _db.into(_db.subsections).insert(
          SubsectionsCompanion.insert(
            categoryId: categoryId,
            parentId: Value(parentId),
            name: trimmed,
            allocatedAmount: Value(allocatedAmount),
            actualAmount: Value(actualAmount),
            isFoodLinked: Value(isFoodLinked),
            sortOrder: Value(siblings.length),
          ),
        );
  }

  Future<void> renameSubsection(int subsectionId, String newName) async {
    final trimmed = newName.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    final existing = await (_db.select(_db.subsections)
          ..where((s) => s.id.equals(subsectionId)))
        .getSingle();
    await _assertCategoryCycleOpen(existing.categoryId);

    await (_db.update(_db.subsections)..where((s) => s.id.equals(subsectionId)))
        .write(SubsectionsCompanion(name: Value(trimmed)));
  }

  Future<void> deleteSubsection(int subsectionId) async {
    final existing = await (_db.select(_db.subsections)
          ..where((s) => s.id.equals(subsectionId)))
        .getSingle();
    await _assertCategoryCycleOpen(existing.categoryId);

    await (_db.delete(_db.subsections)..where((s) => s.id.equals(subsectionId)))
        .go();
  }

  // --- Itemized Subsection Entries (Optional Log -> Auto-Sum into Actual) ---

  Stream<List<SubsectionEntry>> watchEntriesForSubsection(int subsectionId) {
    return (_db.select(_db.subsectionEntries)
          ..where((e) => e.subsectionId.equals(subsectionId))
          ..orderBy([(e) => OrderingTerm.desc(e.entryDate)]))
        .watch();
  }

  Future<SubsectionUpdateResult> addSubsectionEntry({
    required int subsectionId,
    required double amount,
    required String note,
    DateTime? entryDate,
  }) async {
    VarianceCalculator.validateNonNegative(amount, fieldName: 'entryAmount');
    final sub = await (_db.select(_db.subsections)
          ..where((s) => s.id.equals(subsectionId)))
        .getSingle();
    await _assertCategoryCycleOpen(sub.categoryId);

    await _db.transaction(() async {
      await _db.into(_db.subsectionEntries).insert(
            SubsectionEntriesCompanion.insert(
              subsectionId: subsectionId,
              amount: amount,
              note: Value(note.trim()),
              entryDate: Value(entryDate ?? DateTime.now()),
            ),
          );
      await _recalculateActualFromEntries(subsectionId);
    });

    final updated = await (_db.select(_db.subsections)
          ..where((s) => s.id.equals(subsectionId)))
        .getSingle();
    return SubsectionUpdateResult(
      subsectionName: updated.name,
      variance: VarianceCalculator.compute(
        updated.allocatedAmount,
        updated.actualAmount,
      ),
    );
  }

  Future<void> deleteSubsectionEntry({
    required int entryId,
    required int subsectionId,
  }) async {
    final sub = await (_db.select(_db.subsections)
          ..where((s) => s.id.equals(subsectionId)))
        .getSingle();
    await _assertCategoryCycleOpen(sub.categoryId);

    await _db.transaction(() async {
      await (_db.delete(_db.subsectionEntries)
            ..where((e) => e.id.equals(entryId)))
          .go();
      await _recalculateActualFromEntries(subsectionId);
    });
  }

  Future<void> _recalculateActualFromEntries(int subsectionId) async {
    final entries = await (_db.select(_db.subsectionEntries)
          ..where((e) => e.subsectionId.equals(subsectionId)))
        .get();
    final sum = entries.fold<double>(0.0, (acc, e) => acc + e.amount);
    await (_db.update(_db.subsections)..where((s) => s.id.equals(subsectionId)))
        .write(SubsectionsCompanion(actualAmount: Value(sum)));
  }

  // --- Savings Shortfall Accountability ---

  Future<void> saveShortfallReason({
    required int cycleId,
    required double shortfallAmount,
    required String reasonText,
  }) async {
    final cycle = await (_db.select(_db.budgetCycles)
          ..where((c) => c.id.equals(cycleId)))
        .getSingle();
    if (cycle.isClosed) {
      throw StateError('Archived cycles are read-only.');
    }

    final safeShortfall = shortfallAmount < 0 ? 0.0 : shortfallAmount;
    await _db.into(_db.savingsShortfallLogs).insert(
          SavingsShortfallLogsCompanion.insert(
            cycleId: cycleId,
            shortfallAmount: Value(safeShortfall),
            reasonText: Value(reasonText),
            updatedAt: Value(DateTime.now()),
          ),
          onConflict: DoUpdate(
            (_) => SavingsShortfallLogsCompanion(
              shortfallAmount: Value(safeShortfall),
              reasonText: Value(reasonText),
              updatedAt: Value(DateTime.now()),
            ),
            target: [_db.savingsShortfallLogs.cycleId],
          ),
        );
  }
}
