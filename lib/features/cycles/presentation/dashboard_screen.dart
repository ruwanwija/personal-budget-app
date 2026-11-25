import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';
import 'package:pfm_budget_app/features/budget/domain/variance_calculator.dart';
import 'package:pfm_budget_app/features/cycles/domain/cycle_date_calculator.dart';
import 'package:pfm_budget_app/features/updates/presentation/update_dialog.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  bool _checkedUpdateOnLaunch = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_checkedUpdateOnLaunch || kIsWeb) return;
      _checkedUpdateOnLaunch = true;
      final prefs = ref.read(preferencesProvider);
      if (prefs.autoCheckUpdates && prefs.githubUpdateRepo.contains('/')) {
        ref.read(updateCheckProvider.notifier).checkNow();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);
    final snapshotAsync = ref.watch(activeBudgetSnapshotProvider);
    final updateResult = ref.watch(updateCheckProvider).valueOrNull;

    return Scaffold(
      body: snapshotAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Failed to load dashboard: $err')),
        data: (snapshot) {
          if (snapshot == null) {
            return const Center(child: Text('Initializing your budget cycle...'));
          }

          final window = CycleWindow(
            startDate: snapshot.cycle.startDate,
            endDate: snapshot.cycle.endDate,
            configuredStartDay: snapshot.cycle.configuredStartDay,
          );
          final remainingDays =
              CycleDateCalculator.daysRemaining(window, DateTime.now());
          final elapsedFraction =
              ((window.totalDays - remainingDays) / window.totalDays)
                  .clamp(0.0, 1.0);
          final dateFmt = DateFormat('MMM d, yyyy');

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 165,
                pinned: true,
                title: const Text('Personal Budget'),
                actions: [
                  IconButton(
                    tooltip: 'Close & archive cycle',
                    icon: const Icon(Icons.task_alt_outlined),
                    onPressed: () =>
                        _handleCloseCycle(context, ref, snapshot),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.brandDeepGreen,
                          AppColors.brandTeal,
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 86, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${dateFmt.format(window.startDate)} – ${dateFmt.format(window.endDate)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$remainingDays days left',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: elapsedFraction,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.brandMint,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                sliver: SliverList.list(
                  children: [
                    if (updateResult != null && updateResult.hasUpdate) ...[
                      Card(
                        color: AppColors.brandMint,
                        child: ListTile(
                          leading: const Icon(
                            Icons.system_update_rounded,
                            color: AppColors.brandDeepGreen,
                          ),
                          title: Text(
                            'Update ${updateResult.updateInfo!.latestVersion.displayLabel} Available',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandDeepGreen,
                            ),
                          ),
                          subtitle: const Text(
                            'Tap to download and install the latest version.',
                          ),
                          trailing: FilledButton(
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => UpdateAvailableDialog(
                                  info: updateResult.updateInfo!,
                                ),
                              );
                            },
                            child: const Text('Update'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    _SalarySummaryCard(
                      snapshot: snapshot,
                      currencyFormat: prefs.currencyFormat,
                      onEditSalary: () =>
                          _showEditSalaryDialog(context, ref, snapshot),
                      onAddIncome: () =>
                          _showSupplementaryIncomeSheet(context, ref, snapshot),
                    ),
                    if (snapshot.guardrail.isOverAllocated ||
                        snapshot.guardrail.hasUnallocatedBalance) ...[
                      const SizedBox(height: 12),
                      _GuardrailCard(
                        guardrail: snapshot.guardrail,
                        currencyFormat: prefs.currencyFormat,
                      ),
                    ],
                    if (snapshot.shortfall.isShortfallActive) ...[
                      const SizedBox(height: 12),
                      Card(
                        color: AppTheme.varianceBackground(context, -1),
                        child: ListTile(
                          leading: const Icon(
                            Icons.warning_amber_rounded,
                            color: AppColors.negativeRed,
                          ),
                          title: Text(
                            'Savings Shortfall: ${CurrencyFormatter.format(snapshot.shortfall.shortfallAmount, style: prefs.currencyFormat)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.negativeRed,
                            ),
                          ),
                          subtitle: Text(
                            snapshot.shortfall.reasonText.trim().isEmpty
                                ? 'Tap to record shortfall reason (required before closing cycle).'
                                : snapshot.shortfall.reasonText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => context.go('/budget'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Category Progress',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        TextButton(
                          onPressed: () => context.go('/budget'),
                          child: const Text('Full Breakdown'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    for (final cat in snapshot.categories) ...[
                      _CategoryProgressCard(
                        category: cat,
                        currencyFormat: prefs.currencyFormat,
                        onTap: () => context.go('/budget'),
                      ),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => _handleCloseCycle(context, ref, snapshot),
                      icon: const Icon(Icons.archive_outlined),
                      label: const Text('Finalize Cycle & Start Next Period'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: snapshotAsync.valueOrNull == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _showQuickEntrySheet(
                context,
                ref,
                snapshotAsync.valueOrNull!,
              ),
              icon: const Icon(Icons.add),
              label: const Text('Quick Entry'),
            ),
    );
  }

  Future<void> _showEditSalaryDialog(
    BuildContext context,
    WidgetRef ref,
    CycleBudgetSnapshot snapshot,
  ) async {
    final ctrl = TextEditingController(
      text: CurrencyFormatter.formatCompactInput(snapshot.cycle.salaryAmount),
    );
    final newSalary = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Monthly Salary'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [NonNegativeDecimalInputFormatter()],
          decoration: const InputDecoration(
            labelText: 'Salary Amount for Active Cycle',
          ),
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
    if (newSalary != null) {
      await ref
          .read(cycleRepositoryProvider)
          .updateSalary(snapshot.cycle.id, newSalary);
    }
  }

  Future<void> _showSupplementaryIncomeSheet(
    BuildContext context,
    WidgetRef ref,
    CycleBudgetSnapshot snapshot,
  ) async {
    final labelCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final prefs = ref.read(preferencesProvider);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Supplementary Income',
              style: Theme.of(ctx)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: labelCtrl,
                    decoration: const InputDecoration(labelText: 'Source'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: amountCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [NonNegativeDecimalInputFormatter()],
                    decoration: const InputDecoration(labelText: 'Amount'),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () async {
                    final label = labelCtrl.text.trim();
                    final amt = double.tryParse(amountCtrl.text.trim());
                    if (label.isEmpty || amt == null || amt <= 0) return;
                    await ref
                        .read(cycleRepositoryProvider)
                        .addSupplementaryIncome(
                          cycleId: snapshot.cycle.id,
                          label: label,
                          amount: amt,
                        );
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            if (snapshot.supplementaryIncomes.isNotEmpty) ...[
              const SizedBox(height: 12),
              for (final inc in snapshot.supplementaryIncomes)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(inc.label),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        CurrencyFormatter.format(
                          inc.amount,
                          style: prefs.currencyFormat,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.negativeRed,
                        ),
                        onPressed: () async {
                          await ref
                              .read(cycleRepositoryProvider)
                              .deleteSupplementaryIncome(
                                inc.id,
                                snapshot.cycle.id,
                              );
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
    labelCtrl.dispose();
    amountCtrl.dispose();
  }

  Future<void> _showQuickEntrySheet(
    BuildContext context,
    WidgetRef ref,
    CycleBudgetSnapshot snapshot,
  ) async {
    final leaves = <(String, SubsectionNode)>[];
    for (final cat in snapshot.categories) {
      for (final node in cat.subsections) {
        if (node.isParent) {
          for (final child in node.children) {
            leaves.add(('${cat.name} › ${node.name} › ${child.name}', child));
          }
        } else {
          leaves.add(('${cat.name} › ${node.name}', node));
        }
      }
    }
    if (leaves.isEmpty) return;

    var selected = leaves.first.$2;
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController();

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Quick Expense / Savings Entry',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selected.id,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Subsection'),
                items: leaves
                    .map(
                      (pair) => DropdownMenuItem<int>(
                        value: pair.$2.id,
                        child: Text(
                          pair.$1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (id) {
                  if (id == null) return;
                  setState(() {
                    selected = leaves.firstWhere((p) => p.$2.id == id).$2;
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: amountCtrl,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [NonNegativeDecimalInputFormatter()],
                decoration: const InputDecoration(labelText: 'Amount'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: noteCtrl,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: () async {
                  final amt = double.tryParse(amountCtrl.text.trim());
                  if (amt == null || amt <= 0) return;
                  final res = await ref
                      .read(budgetRepositoryProvider)
                      .addSubsectionEntry(
                        subsectionId: selected.id,
                        amount: amt,
                        note: noteCtrl.text.trim(),
                      );
                  await ref
                      .read(notificationServiceProvider)
                      .checkAndNotifyThreshold(
                        cycleId: snapshot.cycle.id,
                        subsectionId: selected.id,
                        subsectionName: res.subsectionName,
                        variance: res.variance,
                        prefs: ref.read(preferencesProvider),
                      );
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                icon: const Icon(Icons.check),
                label: const Text('Log Entry'),
              ),
            ],
          ),
        ),
      ),
    );
    amountCtrl.dispose();
    noteCtrl.dispose();
  }

  Future<void> _handleCloseCycle(
    BuildContext context,
    WidgetRef ref,
    CycleBudgetSnapshot snapshot,
  ) async {
    if (!snapshot.shortfall.canCloseCycle) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Shortfall Reason Required'),
          content: Text(
            snapshot.shortfall.validationError ??
                'Please record your reason for the savings shortfall before closing this cycle.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                context.go('/budget');
              },
              child: const Text('Go to Savings'),
            ),
          ],
        ),
      );
      return;
    }

    final prefs = ref.read(preferencesProvider);
    final nextStartDay =
        prefs.pendingNextCycleStartDay ?? prefs.cycleStartDay;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Close & Archive Cycle?'),
        content: Text(
          'This cycle will be archived as a read-only record (preserving all budgets, actuals, meal modes, and shortfall notes), and a new cycle will begin with start day $nextStartDay.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Close & Start Next'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await ref.read(cycleRepositoryProvider).closeActiveCycleAndStartNext(
            cycleId: snapshot.cycle.id,
            nextStartDay: nextStartDay,
            nextSalary: snapshot.cycle.salaryAmount,
            mealSyncTarget: prefs.mealSyncTarget,
          );
      if (prefs.pendingNextCycleStartDay != null) {
        await ref
            .read(preferencesProvider.notifier)
            .setCycleStartDay(nextStartDay, clearPending: true);
      }

      final newCycle =
          await ref.read(cycleRepositoryProvider).getActiveCycle();
      if (newCycle != null) {
        final fmt = DateFormat('MMM d');
        await ref.read(notificationServiceProvider).showCycleStartedNotification(
              cycleRangeLabel:
                  '${fmt.format(newCycle.startDate)} – ${fmt.format(newCycle.endDate)}',
              prefs: ref.read(preferencesProvider),
            );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cycle archived and next cycle started.'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }
}

class _SalarySummaryCard extends StatelessWidget {
  const _SalarySummaryCard({
    required this.snapshot,
    required this.currencyFormat,
    required this.onEditSalary,
    required this.onAddIncome,
  });

  final CycleBudgetSnapshot snapshot;
  final CurrencyFormatStyle currencyFormat;
  final VoidCallback onEditSalary;
  final VoidCallback onAddIncome;

  @override
  Widget build(BuildContext context) {
    final diffColor = AppTheme.varianceColor(context, snapshot.totalDifference);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                        'TOTAL MONTHLY INCOME',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              letterSpacing: 0.7,
                              color: Colors.grey.shade600,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.format(
                          snapshot.totalIncome,
                          style: currencyFormat,
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.brandDeepGreen,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'Edit base salary',
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEditSalary,
                ),
                IconButton(
                  tooltip: 'Supplementary income',
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: onAddIncome,
                ),
              ],
            ),
            if (snapshot.guardrail.supplementaryIncome > 0)
              Text(
                'Salary ${CurrencyFormatter.format(snapshot.cycle.salaryAmount, style: currencyFormat)} + Extra ${CurrencyFormatter.format(snapshot.guardrail.supplementaryIncome, style: currencyFormat)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const Divider(height: 22),
            Row(
              children: [
                _MetricColumn(
                  label: 'Allocated',
                  value: CurrencyFormatter.format(
                    snapshot.totalCategoryAllocated,
                    style: currencyFormat,
                  ),
                ),
                _MetricColumn(
                  label: 'Actual Spend',
                  value: CurrencyFormatter.format(
                    snapshot.totalActualSpend,
                    style: currencyFormat,
                  ),
                ),
                _MetricColumn(
                  label: 'Difference',
                  value: CurrencyFormatter.format(
                    snapshot.totalDifference,
                    style: currencyFormat,
                    showPlusSign: true,
                  ),
                  valueColor: diffColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

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
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: valueColor,
                ),
          ),
        ],
      ),
    );
  }
}

class _GuardrailCard extends StatelessWidget {
  const _GuardrailCard({
    required this.guardrail,
    required this.currencyFormat,
  });

  final AllocationGuardrail guardrail;
  final CurrencyFormatStyle currencyFormat;

  @override
  Widget build(BuildContext context) {
    final isOver = guardrail.isOverAllocated;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isOver
            ? AppTheme.varianceBackground(context, -1)
            : AppColors.warningBgLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            isOver ? Icons.error_outline : Icons.account_balance_wallet_outlined,
            color: isOver ? AppColors.negativeRed : AppColors.warningAmber,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isOver
                  ? 'Over-allocated by ${CurrencyFormatter.format(guardrail.unallocatedBalance.abs(), style: currencyFormat)} above monthly income.'
                  : 'Unallocated balance: ${CurrencyFormatter.format(guardrail.unallocatedBalance, style: currencyFormat)} available to assign.',
              style: TextStyle(
                color: isOver ? AppColors.negativeRed : AppColors.warningAmber,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryProgressCard extends StatelessWidget {
  const _CategoryProgressCard({
    required this.category,
    required this.currencyFormat,
    required this.onTap,
  });

  final CategoryBudgetSummary category;
  final CurrencyFormatStyle currencyFormat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final v = category.variance;
    final progress = v.utilizationRatio.clamp(0.0, 1.0);
    final diffColor = AppTheme.varianceColor(context, v.difference);
    final barColor = v.isOverspent
        ? AppColors.negativeRed
        : (category.type == BudgetCategoryType.savings
            ? AppColors.positiveGreen
            : AppColors.brandTeal);

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      category.name,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatPercent(category.shareOfIncome),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey.withValues(alpha: 0.18),
                  valueColor: AlwaysStoppedAnimation<Color>(barColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Actual ${CurrencyFormatter.format(category.actualTotal, style: currencyFormat)} / ${CurrencyFormatter.format(category.allocatedAmount, style: currencyFormat)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    CurrencyFormatter.format(
                      v.difference,
                      style: currencyFormat,
                      showPlusSign: true,
                    ),
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: diffColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
