import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/budget/presentation/budget_breakdown_screen.dart';

class CycleDetailScreen extends ConsumerWidget {
  const CycleDetailScreen({
    super.key,
    required this.cycleId,
  });

  final int cycleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);
    final budgetAsync = ref.watch(cycleBudgetSnapshotProvider(cycleId));
    final mealsAsync = ref.watch(cycleMealPlanProvider(cycleId));
    final dateFmt = DateFormat('MMM d, yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Archived Cycle Detail'),
        actions: [
          IconButton(
            tooltip: 'Export PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () async {
              final b = budgetAsync.valueOrNull;
              final m = mealsAsync.valueOrNull;
              if (b == null || m == null) return;
              await ref.read(reportExportServiceProvider).exportAndSharePdf(
                    budget: b,
                    meals: m,
                    currencyFormat: prefs.currencyFormat,
                  );
            },
          ),
          IconButton(
            tooltip: 'Export CSV',
            icon: const Icon(Icons.table_chart_outlined),
            onPressed: () async {
              final b = budgetAsync.valueOrNull;
              final m = mealsAsync.valueOrNull;
              if (b == null || m == null) return;
              await ref.read(reportExportServiceProvider).exportAndShareCsv(
                    budget: b,
                    meals: m,
                    currencyFormat: prefs.currencyFormat,
                  );
            },
          ),
        ],
      ),
      body: budgetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (budget) {
          if (budget == null) {
            return const Center(child: Text('Cycle not found.'));
          }
          final meals = mealsAsync.valueOrNull;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: AppColors.brandDeepGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Chip(
                        label: Text('Read-Only Archive'),
                        visualDensity: VisualDensity.compact,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${dateFmt.format(budget.cycle.startDate)} – ${dateFmt.format(budget.cycle.endDate)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total Income: ${CurrencyFormatter.format(budget.totalIncome, style: prefs.currencyFormat)}  •  Actual Spend: ${CurrencyFormatter.format(budget.totalActualSpend, style: prefs.currencyFormat)}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              if (meals != null) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weekly Meal Modes Used',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        for (final w in meals.weeks)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Week ${w.weekIndex} • ${w.modeName}'),
                                Text(
                                  CurrencyFormatter.format(
                                    w.effectiveTotal,
                                    style: prefs.currencyFormat,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Meal Rollup',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              CurrencyFormatter.format(
                                meals.monthlyTotal,
                                style: prefs.currencyFormat,
                              ),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                color: AppColors.brandDeepGreen,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          BudgetBreakdownScreen(cycleIdOverride: cycleId),
                    ),
                  );
                },
                icon: const Icon(Icons.list_alt),
                label: const Text('Inspect Full Read-Only Breakdown'),
              ),
            ],
          );
        },
      ),
    );
  }
}
