import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/budget/presentation/widgets/shortfall_reason_box.dart';
import 'package:pfm_budget_app/features/budget/presentation/widgets/subsection_row.dart';

class BudgetBreakdownScreen extends ConsumerWidget {
  const BudgetBreakdownScreen({
    super.key,
    this.cycleIdOverride,
  });

  final int? cycleIdOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);
    final snapshotAsync = cycleIdOverride != null
        ? ref.watch(cycleBudgetSnapshotProvider(cycleIdOverride!))
        : ref.watch(activeBudgetSnapshotProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          cycleIdOverride != null ? 'Archived Breakdown' : 'Budget Breakdown',
        ),
      ),
      body: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading budget: $err')),
        data: (snapshot) {
          if (snapshot == null) {
            return const Center(child: Text('No active budget cycle found.'));
          }

          final readOnly = snapshot.cycle.isClosed;

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
            children: [
              _AllocationSummaryBanner(
                snapshot: snapshot,
                currencyFormat: prefs.currencyFormat,
              ),
              const SizedBox(height: 12),
              for (final cat in snapshot.categories) ...[
                _CategoryCard(
                  category: cat,
                  snapshot: snapshot,
                  currencyFormat: prefs.currencyFormat,
                  readOnly: readOnly,
                ),
                const SizedBox(height: 14),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _AllocationSummaryBanner extends StatelessWidget {
  const _AllocationSummaryBanner({
    required this.snapshot,
    required this.currencyFormat,
  });

  final CycleBudgetSnapshot snapshot;
  final CurrencyFormatStyle currencyFormat;

  @override
  Widget build(BuildContext context) {
    final g = snapshot.guardrail;
    final Color bg;
    final Color fg;
    final IconData icon;
    final String message;

    if (g.isOverAllocated) {
      bg = AppTheme.varianceBackground(context, -1);
      fg = AppColors.negativeRed;
      icon = Icons.error_outline;
      message =
          'Category allocations exceed income by ${CurrencyFormatter.format(g.unallocatedBalance.abs(), style: currencyFormat)}';
    } else if (g.hasUnallocatedBalance) {
      bg = AppColors.warningBgLight;
      fg = AppColors.warningAmber;
      icon = Icons.info_outline;
      message =
          'Unallocated balance remaining: ${CurrencyFormatter.format(g.unallocatedBalance, style: currencyFormat)}';
    } else {
      bg = AppTheme.varianceBackground(context, 1);
      fg = AppColors.positiveGreen;
      icon = Icons.check_circle_outline;
      message =
          '100% of ${CurrencyFormatter.format(g.totalIncome, style: currencyFormat)} income allocated';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: fg,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends ConsumerWidget {
  const _CategoryCard({
    required this.category,
    required this.snapshot,
    required this.currencyFormat,
    required this.readOnly,
  });

  final CategoryBudgetSummary category;
  final CycleBudgetSnapshot snapshot;
  final CurrencyFormatStyle currencyFormat;
  final bool readOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final v = category.variance;
    final diffColor = AppTheme.varianceColor(context, v.difference);
    final diffBg = AppTheme.varianceBackground(context, v.difference);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            color: AppColors.brandDeepGreen.withValues(alpha: 0.06),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${CurrencyFormatter.formatPercent(category.shareOfIncome)} of monthly income',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    if (!readOnly)
                      IconButton(
                        tooltip: 'Edit category budget',
                        icon: const Icon(Icons.edit_outlined, size: 19),
                        onPressed: () => _showEditCategoryAllocationDialog(
                          context,
                          ref,
                          category,
                        ),
                      ),
                    if (!readOnly)
                      FilledButton.tonalIcon(
                        onPressed: () => _showAddSubsectionDialog(
                          context,
                          ref,
                          categoryId: category.id,
                          title: 'Add Item to ${category.name}',
                        ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Add'),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MiniStat(
                      label: 'Allocated',
                      value: CurrencyFormatter.format(
                        category.allocatedAmount,
                        style: currencyFormat,
                      ),
                    ),
                    _MiniStat(
                      label: 'Actual',
                      value: CurrencyFormatter.format(
                        category.actualTotal,
                        style: currencyFormat,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: diffBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Difference',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: diffColor.withValues(alpha: 0.85),
                                ),
                              ),
                              Text(
                                CurrencyFormatter.format(
                                  v.difference,
                                  style: currencyFormat,
                                  showPlusSign: true,
                                ),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: diffColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (category.subsectionAllocationDelta.abs() > 0.01) ...[
                  const SizedBox(height: 8),
                  Text(
                    category.subsectionAllocationDelta < 0
                        ? 'Note: Subsections total ${CurrencyFormatter.format(category.subsectionAllocatedTotal, style: currencyFormat)} (${CurrencyFormatter.format(category.subsectionAllocationDelta.abs(), style: currencyFormat)} over category allocation).'
                        : 'Unassigned within category: ${CurrencyFormatter.format(category.subsectionAllocationDelta, style: currencyFormat)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: category.subsectionAllocationDelta < 0
                              ? AppColors.warningAmber
                              : Colors.grey.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
                if (category.type == BudgetCategoryType.savings)
                  ShortfallReasonBox(
                    shortfall: snapshot.shortfall,
                    currencyFormat: currencyFormat,
                    readOnly: readOnly,
                    onReasonChanged: (text) {
                      ref.read(budgetRepositoryProvider).saveShortfallReason(
                            cycleId: snapshot.cycle.id,
                            shortfallAmount: snapshot.shortfall.shortfallAmount,
                            reasonText: text,
                          );
                    },
                  ),
              ],
            ),
          ),
          if (category.subsections.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No subsections yet. Tap "Add" to create one.'),
            )
          else
            for (final node in category.subsections)
              if (node.isParent)
                NestedSubsectionTile(
                  parentNode: node,
                  currencyFormat: currencyFormat,
                  readOnly: readOnly,
                  onAddChild: () => _showAddSubsectionDialog(
                    context,
                    ref,
                    categoryId: category.id,
                    parentId: node.id,
                    title: 'Add Sub-item under ${node.name}',
                  ),
                  onRenameParent: () => _showRenameDialog(context, ref, node),
                  onDeleteParent: () => _confirmDelete(context, ref, node),
                  childBuilder: (child) => _buildLeafRow(
                    context,
                    ref,
                    child,
                    indent: true,
                  ),
                )
              else
                _buildLeafRow(context, ref, node, indent: false),
        ],
      ),
    );
  }

  Widget _buildLeafRow(
    BuildContext context,
    WidgetRef ref,
    SubsectionNode node, {
    required bool indent,
  }) {
    return SubsectionRow(
      key: ValueKey('sub_${node.id}'),
      node: node,
      currencyFormat: currencyFormat,
      readOnly: readOnly,
      indent: indent,
      onOpenMeals: () => context.go('/meals'),
      onOpenEntries: () => _showEntriesSheet(context, ref, node),
      onAddChild: indent
          ? null
          : () => _showAddSubsectionDialog(
                context,
                ref,
                categoryId: node.categoryId,
                parentId: node.id,
                title: 'Add Sub-item under ${node.name}',
              ),
      onRename: () => _showRenameDialog(context, ref, node),
      onDelete: () => _confirmDelete(context, ref, node),
      onValuesChanged: (alloc, actual) async {
        final result = await ref
            .read(budgetRepositoryProvider)
            .updateSubsectionValues(
              subsectionId: node.id,
              allocatedAmount: alloc,
              actualAmount: actual,
            );
        await ref.read(notificationServiceProvider).checkAndNotifyThreshold(
              cycleId: snapshot.cycle.id,
              subsectionId: node.id,
              subsectionName: result.subsectionName,
              variance: result.variance,
              prefs: ref.read(preferencesProvider),
            );
      },
    );
  }

  Future<void> _showEditCategoryAllocationDialog(
    BuildContext context,
    WidgetRef ref,
    CategoryBudgetSummary cat,
  ) async {
    final ctrl = TextEditingController(
      text: CurrencyFormatter.formatCompactInput(cat.allocatedAmount),
    );
    final confirmed = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Allocate ${cat.name}'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [NonNegativeDecimalInputFormatter()],
          decoration: const InputDecoration(labelText: 'Allocated Budget'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(ctx, double.tryParse(ctrl.text.trim()) ?? 0.0),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (confirmed != null) {
      await ref.read(budgetRepositoryProvider).updateCategoryAllocation(
            categoryId: cat.id,
            allocatedAmount: confirmed,
          );
    }
  }

  Future<void> _showAddSubsectionDialog(
    BuildContext context,
    WidgetRef ref, {
    required int categoryId,
    int? parentId,
    required String title,
  }) async {
    final nameCtrl = TextEditingController();
    final allocCtrl = TextEditingController(text: '0');

    final result = await showDialog<(String, double)>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Item Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: allocCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [NonNegativeDecimalInputFormatter()],
              decoration: const InputDecoration(labelText: 'Allocated Budget'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;
              final alloc = double.tryParse(allocCtrl.text.trim()) ?? 0.0;
              Navigator.pop(ctx, (name, alloc));
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
    nameCtrl.dispose();
    allocCtrl.dispose();

    if (result != null) {
      await ref.read(budgetRepositoryProvider).addSubsection(
            categoryId: categoryId,
            parentId: parentId,
            name: result.$1,
            allocatedAmount: result.$2,
          );
    }
  }

  Future<void> _showRenameDialog(
    BuildContext context,
    WidgetRef ref,
    SubsectionNode node,
  ) async {
    final ctrl = TextEditingController(text: node.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Item'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (newName != null && newName.isNotEmpty) {
      await ref
          .read(budgetRepositoryProvider)
          .renameSubsection(node.id, newName);
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    SubsectionNode node,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete "${node.name}"?'),
        content: Text(
          node.isParent
              ? 'This will remove the group and all ${node.children.length} nested sub-items.'
              : 'This item will be removed from the active cycle.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.negativeRed,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(budgetRepositoryProvider).deleteSubsection(node.id);
    }
  }

  void _showEntriesSheet(
    BuildContext context,
    WidgetRef ref,
    SubsectionNode node,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _SubsectionEntriesSheet(
        node: node,
        cycleId: snapshot.cycle.id,
        currencyFormat: currencyFormat,
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _SubsectionEntriesSheet extends ConsumerStatefulWidget {
  const _SubsectionEntriesSheet({
    required this.node,
    required this.cycleId,
    required this.currencyFormat,
  });

  final SubsectionNode node;
  final int cycleId;
  final CurrencyFormatStyle currencyFormat;

  @override
  ConsumerState<_SubsectionEntriesSheet> createState() =>
      _SubsectionEntriesSheetState();
}

class _SubsectionEntriesSheetState
    extends ConsumerState<_SubsectionEntriesSheet> {
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _addEntry() async {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount <= 0) return;
    final res = await ref.read(budgetRepositoryProvider).addSubsectionEntry(
          subsectionId: widget.node.id,
          amount: amount,
          note: _noteCtrl.text.trim(),
        );
    await ref.read(notificationServiceProvider).checkAndNotifyThreshold(
          cycleId: widget.cycleId,
          subsectionId: widget.node.id,
          subsectionName: res.subsectionName,
          variance: res.variance,
          prefs: ref.read(preferencesProvider),
        );
    _amountCtrl.clear();
    _noteCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    final entriesAsync = ref.watch(subsectionEntriesProvider(widget.node.id));
    final dateFmt = DateFormat('MMM d, h:mm a');

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${widget.node.name} — Expense Entries',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            'Logged entries automatically sum into the Actual Amount.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _amountCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [NonNegativeDecimalInputFormatter()],
                  decoration: const InputDecoration(labelText: 'Amount'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(labelText: 'Note (optional)'),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _addEntry,
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 260),
            child: entriesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text('Error: $e'),
              data: (entries) {
                if (entries.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text('No itemized entries logged yet.'),
                    ),
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  itemCount: entries.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final e = entries[i];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        CurrencyFormatter.format(
                          e.amount,
                          style: widget.currencyFormat,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        '${e.note.isEmpty ? 'Expense' : e.note} • ${dateFmt.format(e.entryDate)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.negativeRed,
                        ),
                        onPressed: () {
                          ref
                              .read(budgetRepositoryProvider)
                              .deleteSubsectionEntry(
                                entryId: e.id,
                                subsectionId: widget.node.id,
                              );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
