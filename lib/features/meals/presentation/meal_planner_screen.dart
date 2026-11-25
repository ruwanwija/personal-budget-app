import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/database/app_database.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/cycles/domain/cycle_date_calculator.dart';
import 'package:pfm_budget_app/features/meals/data/meal_repository.dart';
import 'package:pfm_budget_app/features/meals/domain/meal_calculator.dart';

class MealPlannerScreen extends ConsumerStatefulWidget {
  const MealPlannerScreen({super.key});

  @override
  ConsumerState<MealPlannerScreen> createState() => _MealPlannerScreenState();
}

class _MealPlannerScreenState extends ConsumerState<MealPlannerScreen> {
  int? _selectedModeId;

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(preferencesProvider);
    final cycleAsync = ref.watch(activeCycleProvider);
    final mealPlanAsync = ref.watch(activeMealPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Planner'),
        actions: [
          if (mealPlanAsync.valueOrNull != null)
            IconButton(
              tooltip: 'Create custom meal mode',
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () =>
                  _showCreateModeDialog(context, mealPlanAsync.valueOrNull!),
            ),
        ],
      ),
      body: mealPlanAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error loading meals: $err')),
        data: (snapshot) {
          final activeCycle = cycleAsync.valueOrNull;
          if (snapshot == null || activeCycle == null || snapshot.modes.isEmpty) {
            return const Center(child: Text('No active meal schedule found.'));
          }

          final selectedMode = snapshot.modes.firstWhere(
            (m) => m.id == _selectedModeId,
            orElse: () => snapshot.modes.first,
          );
          final selectedMatrix =
              snapshot.templateByMode[selectedMode.id] ?? const {};
          final templateWeeklyTotal =
              MealCalculator.computeTemplateWeeklyTotal(selectedMatrix);

          final window = CycleWindow(
            startDate: activeCycle.startDate,
            endDate: activeCycle.endDate,
            configuredStartDay: activeCycle.configuredStartDay,
          );
          final weekSpans = CycleDateCalculator.splitIntoWeeks(window);
          final spanFmt = DateFormat('MMM d');

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 96),
            children: [
              // Monthly Food Rollup Card
              Card(
                color: AppColors.brandDeepGreen,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.restaurant_menu, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'MONTHLY FOOD ROLLUP',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                                letterSpacing: 0.6,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(
                                snapshot.monthlyTotal,
                                style: prefs.currencyFormat,
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Auto-synced to ${prefs.mealSyncTarget.label} (${snapshot.weeks.length} weeks)',
                              style: const TextStyle(
                                color: AppColors.brandMint,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mode Template Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mode Templates',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Weekly: ${CurrencyFormatter.format(templateWeeklyTotal, style: prefs.currencyFormat)}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: AppColors.brandDeepGreen,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (snapshot.modes.length <= 3)
                SegmentedButton<int>(
                  segments: snapshot.modes
                      .map(
                        (m) => ButtonSegment<int>(
                          value: m.id,
                          label: Text(
                            m.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  selected: {selectedMode.id},
                  onSelectionChanged: (set) {
                    if (set.isNotEmpty) {
                      setState(() => _selectedModeId = set.first);
                    }
                  },
                )
              else
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final mode in snapshot.modes)
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(mode.name),
                            selected: mode.id == selectedMode.id,
                            onSelected: (_) =>
                                setState(() => _selectedModeId = mode.id),
                          ),
                        ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),

              // Mon-Sun Horizontally Scrollable Meal Matrix DataTable
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${selectedMode.name} — Tap any cell to edit or skip (—)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          if (!selectedMode.isDefault &&
                              snapshot.modes.length > 2)
                            IconButton(
                              tooltip: 'Delete custom mode',
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 19,
                                color: AppColors.negativeRed,
                              ),
                              onPressed: () => _confirmDeleteMode(
                                context,
                                selectedMode,
                                snapshot.cycleId,
                                prefs.mealSyncTarget,
                              ),
                            ),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(
                          AppColors.brandDeepGreen.withValues(alpha: 0.08),
                        ),
                        columnSpacing: 18,
                        columns: [
                          const DataColumn(
                            label: Text(
                              'Meal',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          for (final day in MealCalculator.shortDayNames)
                            DataColumn(
                              numeric: true,
                              label: Text(
                                day,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          const DataColumn(
                            numeric: true,
                            label: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                        rows: [
                          for (final slot in MealSlot.values)
                            DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    slot.label,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                for (var day = 1; day <= 7; day++)
                                  DataCell(
                                    _MealCellChip(
                                      amount: selectedMatrix[
                                          MealCellKey(day, slot)],
                                      currencyFormat: prefs.currencyFormat,
                                    ),
                                    onTap: () => _editTemplateCell(
                                      context: context,
                                      mode: selectedMode,
                                      dayOfWeek: day,
                                      slot: slot,
                                      currentAmount: selectedMatrix[
                                          MealCellKey(day, slot)],
                                      cycleId: snapshot.cycleId,
                                      syncTarget: prefs.mealSyncTarget,
                                    ),
                                  ),
                                DataCell(
                                  Text(
                                    CurrencyFormatter.format(
                                      MealCalculator.computeSlotWeeklyTotal(
                                        selectedMatrix,
                                        slot,
                                      ),
                                      style: prefs.currencyFormat,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          DataRow(
                            color: WidgetStateProperty.all(
                              AppColors.brandMint.withValues(alpha: 0.35),
                            ),
                            cells: [
                              const DataCell(
                                Text(
                                  'Daily',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                              ),
                              for (var day = 1; day <= 7; day++)
                                DataCell(
                                  Text(
                                    CurrencyFormatter.format(
                                      MealCalculator.computeDayTotal(
                                        selectedMatrix,
                                        day,
                                      ),
                                      style: prefs.currencyFormat,
                                    ),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              DataCell(
                                Text(
                                  CurrencyFormatter.format(
                                    templateWeeklyTotal,
                                    style: prefs.currencyFormat,
                                  ),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.brandDeepGreen,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Weekly Cycle Mode Assignments
              Text(
                'Cycle Weekly Assignments',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                'Assign a mode to each week. You can also override individual meals for a specific week without changing the base template.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              for (var i = 0; i < snapshot.weeks.length; i++) ...[
                _WeekAssignmentCard(
                  week: snapshot.weeks[i],
                  spanLabel: i < weekSpans.length
                      ? '${spanFmt.format(weekSpans[i].startDate)} – ${spanFmt.format(weekSpans[i].endDate)}'
                      : 'Week ${snapshot.weeks[i].weekIndex}',
                  modes: snapshot.modes,
                  currencyFormat: prefs.currencyFormat,
                  onModeChanged: (newModeId) {
                    ref.read(mealRepositoryProvider).assignWeekMode(
                          assignmentId: snapshot.weeks[i].assignmentId,
                          modeId: newModeId,
                          cycleId: snapshot.cycleId,
                          syncTarget: prefs.mealSyncTarget,
                        );
                  },
                  onEditWeekOverrides: () => _showWeekOverrideSheet(
                    context: context,
                    week: snapshot.weeks[i],
                    cycleId: snapshot.cycleId,
                    syncTarget: prefs.mealSyncTarget,
                    currencyFormat: prefs.currencyFormat,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _editTemplateCell({
    required BuildContext context,
    required MealMode mode,
    required int dayOfWeek,
    required MealSlot slot,
    required double? currentAmount,
    required int cycleId,
    required MealSyncTarget syncTarget,
  }) async {
    final result = await _showMealCellModal(
      context: context,
      title:
          '${mode.name} • ${MealCalculator.fullDayNames[dayOfWeek - 1]} ${slot.label}',
      subtitle: 'Updates the base template and recalculates monthly Food total.',
      initialAmount: currentAmount,
    );
    if (result == null) return;

    await ref.read(mealRepositoryProvider).updateTemplateCell(
          modeId: mode.id,
          dayOfWeek: dayOfWeek,
          slot: slot,
          amount: result.isSkipped ? null : result.amount,
          activeCycleId: cycleId,
          syncTarget: syncTarget,
        );
  }

  Future<void> _showWeekOverrideSheet({
    required BuildContext context,
    required WeeklyMealPlanSummary week,
    required int cycleId,
    required MealSyncTarget syncTarget,
    required CurrencyFormatStyle currencyFormat,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Consumer(
        builder: (ctx, modalRef, _) {
          final liveSnap =
              modalRef.watch(cycleMealPlanProvider(cycleId)).valueOrNull;
          final liveWeek = liveSnap?.weeks.firstWhere(
                (w) => w.assignmentId == week.assignmentId,
                orElse: () => week,
              ) ??
              week;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Week ${liveWeek.weekIndex} Overrides (${liveWeek.modeName})',
                              style: Theme.of(ctx)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Tap a meal to override for Week ${liveWeek.weekIndex} only. Base template stays untouched.',
                              style: Theme.of(ctx).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(
                          liveWeek.effectiveTotal,
                          style: currencyFormat,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.brandDeepGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 16,
                      columns: [
                        const DataColumn(label: Text('Meal')),
                        for (final d in MealCalculator.shortDayNames)
                          DataColumn(numeric: true, label: Text(d)),
                      ],
                      rows: [
                        for (final slot in MealSlot.values)
                          DataRow(
                            cells: [
                              DataCell(Text(slot.label)),
                              for (var day = 1; day <= 7; day++)
                                DataCell(
                                  _MealCellChip(
                                    amount: liveWeek
                                        .effectiveCells[MealCellKey(day, slot)],
                                    currencyFormat: currencyFormat,
                                    highlighted: liveWeek.overrideKeys
                                        .contains(MealCellKey(day, slot)),
                                  ),
                                  onTap: () async {
                                    final key = MealCellKey(day, slot);
                                    final isOverridden =
                                        liveWeek.overrideKeys.contains(key);
                                    final res = await _showMealCellModal(
                                      context: ctx,
                                      title:
                                          'Week ${liveWeek.weekIndex} • ${MealCalculator.fullDayNames[day - 1]} ${slot.label}',
                                      subtitle:
                                          'Overrides this week only without changing ${liveWeek.modeName}.',
                                      initialAmount:
                                          liveWeek.effectiveCells[key],
                                      allowResetToTemplate: isOverridden,
                                    );
                                    if (res == null) return;
                                    if (res.resetToTemplate) {
                                      await modalRef
                                          .read(mealRepositoryProvider)
                                          .clearWeekMealOverride(
                                            assignmentId: liveWeek.assignmentId,
                                            dayOfWeek: day,
                                            slot: slot,
                                            cycleId: cycleId,
                                            syncTarget: syncTarget,
                                          );
                                    } else {
                                      await modalRef
                                          .read(mealRepositoryProvider)
                                          .setWeekMealOverride(
                                            assignmentId: liveWeek.assignmentId,
                                            dayOfWeek: day,
                                            slot: slot,
                                            amount: res.amount,
                                            isSkipped: res.isSkipped,
                                            cycleId: cycleId,
                                            syncTarget: syncTarget,
                                          );
                                    }
                                  },
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<_MealCellEditResult?> _showMealCellModal({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double? initialAmount,
    bool allowResetToTemplate = false,
  }) async {
    final ctrl = TextEditingController(
      text: initialAmount == null
          ? ''
          : CurrencyFormatter.formatCompactInput(initialAmount),
    );

    final result = await showModalBottomSheet<_MealCellEditResult>(
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
              title,
              style: Theme.of(ctx)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(ctx).textTheme.bodySmall),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [NonNegativeDecimalInputFormatter()],
              decoration: const InputDecoration(
                labelText: 'Meal Cost (leave blank or tap Skip for —)',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.pop(
                    ctx,
                    const _MealCellEditResult(isSkipped: true),
                  ),
                  child: const Text('Skip (—)'),
                ),
                if (allowResetToTemplate) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => Navigator.pop(
                      ctx,
                      const _MealCellEditResult(resetToTemplate: true),
                    ),
                    child: const Text('Reset'),
                  ),
                ],
                const Spacer(),
                FilledButton(
                  onPressed: () {
                    final raw = ctrl.text.trim();
                    if (raw.isEmpty) {
                      Navigator.pop(
                        ctx,
                        const _MealCellEditResult(isSkipped: true),
                      );
                      return;
                    }
                    final val = double.tryParse(raw) ?? 0.0;
                    Navigator.pop(
                      ctx,
                      _MealCellEditResult(amount: val, isSkipped: false),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
    ctrl.dispose();
    return result;
  }

  Future<void> _showCreateModeDialog(
    BuildContext context,
    CycleMealPlanSnapshot snapshot,
  ) async {
    final nameCtrl = TextEditingController();
    int? copyFromId = snapshot.modes.first.id;

    final created = await showDialog<(String, int?)>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => AlertDialog(
          title: const Text('New Lifestyle Meal Mode'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Mode Name (e.g., Office Week, Travel)',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int?>(
                initialValue: copyFromId,
                decoration: const InputDecoration(
                  labelText: 'Start From Template',
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Blank (all skipped)'),
                  ),
                  for (final m in snapshot.modes)
                    DropdownMenuItem<int?>(
                      value: m.id,
                      child: Text('Copy from ${m.name}'),
                    ),
                ],
                onChanged: (v) => setModalState(() => copyFromId = v),
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
                Navigator.pop(ctx, (name, copyFromId));
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
    nameCtrl.dispose();

    if (created != null) {
      final newId = await ref.read(mealRepositoryProvider).createMealMode(
            name: created.$1,
            copyFromModeId: created.$2,
          );
      setState(() => _selectedModeId = newId);
    }
  }

  Future<void> _confirmDeleteMode(
    BuildContext context,
    MealMode mode,
    int activeCycleId,
    MealSyncTarget syncTarget,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete "${mode.name}"?'),
        content: const Text(
          'Any weeks assigned to this mode will revert to the default mode.',
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
      await ref.read(mealRepositoryProvider).deleteMealMode(
            modeId: mode.id,
            activeCycleId: activeCycleId,
            syncTarget: syncTarget,
          );
      setState(() => _selectedModeId = null);
    }
  }
}

class _MealCellEditResult {
  const _MealCellEditResult({
    this.amount,
    this.isSkipped = false,
    this.resetToTemplate = false,
  });

  final double? amount;
  final bool isSkipped;
  final bool resetToTemplate;
}

class _MealCellChip extends StatelessWidget {
  const _MealCellChip({
    required this.amount,
    required this.currencyFormat,
    this.highlighted = false,
  });

  final double? amount;
  final CurrencyFormatStyle currencyFormat;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final text = amount == null
        ? '—'
        : CurrencyFormatter.format(amount!, style: currencyFormat);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: highlighted
            ? AppColors.warningBgLight
            : (amount == null
                ? Colors.grey.withValues(alpha: 0.1)
                : AppColors.brandMint.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: amount == null ? FontWeight.w400 : FontWeight.w600,
          color: amount == null
              ? Colors.grey.shade600
              : (highlighted
                  ? AppColors.warningAmber
                  : AppColors.brandDeepGreen),
        ),
      ),
    );
  }
}

class _WeekAssignmentCard extends StatelessWidget {
  const _WeekAssignmentCard({
    required this.week,
    required this.spanLabel,
    required this.modes,
    required this.currencyFormat,
    required this.onModeChanged,
    required this.onEditWeekOverrides,
  });

  final WeeklyMealPlanSummary week;
  final String spanLabel;
  final List<MealMode> modes;
  final CurrencyFormatStyle currencyFormat;
  final ValueChanged<int> onModeChanged;
  final VoidCallback onEditWeekOverrides;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
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
                        'Week ${week.weekIndex}',
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        spanLabel,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  CurrencyFormatter.format(
                    week.effectiveTotal,
                    style: currencyFormat,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.brandDeepGreen,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: week.modeId,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Assigned Mode',
                    ),
                    items: modes
                        .map(
                          (m) => DropdownMenuItem<int>(
                            value: m.id,
                            child: Text(m.name),
                          ),
                        )
                        .toList(),
                    onChanged: (id) {
                      if (id != null && id != week.modeId) {
                        onModeChanged(id);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: onEditWeekOverrides,
                  icon: Icon(
                    week.overrideKeys.isEmpty
                        ? Icons.tune
                        : Icons.edit_calendar,
                    size: 16,
                  ),
                  label: Text(
                    week.overrideKeys.isEmpty
                        ? 'Override'
                        : '${week.overrideKeys.length} edited',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
