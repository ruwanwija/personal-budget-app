import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/budget/data/budget_repository.dart';

enum _HistoryFilter {
  all('All'),
  shortfall('With Shortfall'),
  overspent('Overspent');

  const _HistoryFilter(this.label);
  final String label;
}

class HistoryReportsScreen extends ConsumerStatefulWidget {
  const HistoryReportsScreen({super.key});

  @override
  ConsumerState<HistoryReportsScreen> createState() =>
      _HistoryReportsScreenState();
}

class _HistoryReportsScreenState extends ConsumerState<HistoryReportsScreen> {
  _HistoryFilter _filter = _HistoryFilter.all;
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);
    final activeCycle = ref.watch(activeCycleProvider).valueOrNull;
    final archivedAsync = ref.watch(archivedCyclesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History & Reports'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
        children: [
          if (activeCycle != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Active Cycle Report',
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Includes monthly summary, full category/subsection variance table, shortfall justification, and mode-wise meal schedule.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _exporting
                                ? null
                                : () => _exportCycle(
                                      cycleId: activeCycle.id,
                                      asPdf: true,
                                    ),
                            icon: const Icon(Icons.picture_as_pdf_outlined),
                            label: const Text('Export PDF'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _exporting
                                ? null
                                : () => _exportCycle(
                                      cycleId: activeCycle.id,
                                      asPdf: false,
                                    ),
                            icon: const Icon(Icons.table_chart_outlined),
                            label: const Text('Export CSV'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Archived Cycles',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              for (final f in _HistoryFilter.values)
                FilterChip(
                  label: Text(f.label),
                  selected: _filter == f,
                  onSelected: (_) => setState(() => _filter = f),
                ),
            ],
          ),
          const SizedBox(height: 10),
          archivedAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text('Error loading history: $e'),
            data: (cycles) {
              if (cycles.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.history_toggle_off,
                          size: 42,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'No archived cycles yet',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'When you finalize a cycle from the Dashboard, it is archived here as a read-only record.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cycles.length,
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (ctx, i) => _ArchivedCycleTile(
                  cycle: cycles[i],
                  filter: _filter,
                  currencyFormat: prefs.currencyFormat,
                  onExportPdf: () =>
                      _exportCycle(cycleId: cycles[i].id, asPdf: true),
                  onExportCsv: () =>
                      _exportCycle(cycleId: cycles[i].id, asPdf: false),
                  onTap: () => context.push('/history/${cycles[i].id}'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportCycle({
    required int cycleId,
    required bool asPdf,
  }) async {
    setState(() => _exporting = true);
    try {
      final budget = await ref
          .read(budgetRepositoryProvider)
          .getCycleBudgetSnapshot(cycleId);
      final meals = await ref
          .read(mealRepositoryProvider)
          .watchCycleMealPlan(cycleId)
          .first;
      if (budget == null) return;

      final prefs = ref.read(preferencesProvider);
      final exporter = ref.read(reportExportServiceProvider);
      if (asPdf) {
        await exporter.exportAndSharePdf(
          budget: budget,
          meals: meals,
          currencyFormat: prefs.currencyFormat,
        );
      } else {
        await exporter.exportAndShareCsv(
          budget: budget,
          meals: meals,
          currencyFormat: prefs.currencyFormat,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Export failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _ArchivedCycleTile extends ConsumerWidget {
  const _ArchivedCycleTile({
    required this.cycle,
    required this.filter,
    required this.currencyFormat,
    required this.onExportPdf,
    required this.onExportCsv,
    required this.onTap,
  });

  final BudgetCycle cycle;
  final _HistoryFilter filter;
  final CurrencyFormatStyle currencyFormat;
  final VoidCallback onExportPdf;
  final VoidCallback onExportCsv;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapAsync = ref.watch(cycleBudgetSnapshotProvider(cycle.id));
    final dateFmt = DateFormat('MMM d, yyyy');

    return snapAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (CycleBudgetSnapshot? snap) {
        if (snap == null) return const SizedBox.shrink();
        if (filter == _HistoryFilter.shortfall &&
            !snap.shortfall.isShortfallActive) {
          return const SizedBox.shrink();
        }
        if (filter == _HistoryFilter.overspent && snap.totalDifference >= 0) {
          return const SizedBox.shrink();
        }

        final diffColor = AppTheme.varianceColor(context, snap.totalDifference);
        final diffBg =
            AppTheme.varianceBackground(context, snap.totalDifference);

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
                    children: [
                      Expanded(
                        child: Text(
                          '${dateFmt.format(cycle.startDate)} – ${dateFmt.format(cycle.endDate)}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: diffBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          CurrencyFormatter.format(
                            snap.totalDifference,
                            style: currencyFormat,
                            showPlusSign: true,
                          ),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: diffColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Income: ${CurrencyFormatter.format(snap.totalIncome, style: currencyFormat)}  •  Actual: ${CurrencyFormatter.format(snap.totalActualSpend, style: currencyFormat)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (snap.shortfall.isShortfallActive) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.varianceBackground(context, -1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.note_alt_outlined,
                            size: 16,
                            color: AppColors.negativeRed,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Shortfall (${CurrencyFormatter.format(snap.shortfall.shortfallAmount, style: currencyFormat)}): ${snap.shortfall.reasonText}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.negativeRed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: onExportCsv,
                        icon: const Icon(Icons.table_chart_outlined, size: 16),
                        label: const Text('CSV'),
                      ),
                      TextButton.icon(
                        onPressed: onExportPdf,
                        icon: const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 16,
                        ),
                        label: const Text('PDF'),
                      ),
                      TextButton.icon(
                        onPressed: onTap,
                        icon: const Icon(Icons.visibility_outlined, size: 16),
                        label: const Text('Inspect'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
