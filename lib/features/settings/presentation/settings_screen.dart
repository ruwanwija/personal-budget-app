import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/formatting/currency_formatter.dart';
import 'package:pfm_budget_app/core/preferences/app_preferences.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/updates/presentation/update_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(preferencesProvider);
    final activeCycle = ref.watch(activeCycleProvider).valueOrNull;
    final versionAsync = ref.watch(installedVersionProvider);
    final updateState = ref.watch(updateCheckProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          _SectionHeader('Budget Cycle Configuration'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Custom Month Start Day'),
                  subtitle: Text(
                    prefs.pendingNextCycleStartDay != null
                        ? 'Current: Day ${prefs.cycleStartDay} (Next cycle: Day ${prefs.pendingNextCycleStartDay})'
                        : 'Starts on day ${prefs.cycleStartDay} of each month (auto-clamped on short months)',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickStartDay(context, ref, prefs, activeCycle?.id),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.payments_outlined),
                  title: const Text('Default Monthly Salary'),
                  subtitle: Text(
                    CurrencyFormatter.format(
                      prefs.defaultSalary,
                      style: prefs.currencyFormat,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editDefaultSalary(context, ref, prefs),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync_alt),
                  title: const Text('Meal Planner Sync Target'),
                  subtitle: Text(prefs.mealSyncTarget.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () =>
                      _selectMealSyncTarget(context, ref, prefs, activeCycle?.id),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.view_list_outlined),
                  title: const Text('Default Budget Templates'),
                  subtitle: const Text(
                    'Edit default category allocations used for new cycles',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showTemplatesSheet(context, ref, prefs),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader('Display & Formatting'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Currency Format'),
                  subtitle: Text(prefs.currencyFormat.exampleLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectCurrencyFormat(context, ref, prefs),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.brightness_6_outlined),
                  title: const Text('App Theme'),
                  subtitle: Text(prefs.themeMode.name.toUpperCase()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _selectThemeMode(context, ref, prefs),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader('Security & Privacy'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.pin_outlined),
                  title: Text(prefs.hasPin ? 'Change App PIN' : 'Set App PIN'),
                  subtitle: Text(
                    prefs.hasPin
                        ? 'PIN is configured securely on device'
                        : 'Set a 4–6 digit PIN to protect your finances',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPinDialog(context, ref),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.lock_outline),
                  title: const Text('Require App Lock'),
                  subtitle: const Text('Lock app with PIN or biometrics on launch'),
                  value: prefs.appLockEnabled,
                  onChanged: (enabled) async {
                    if (enabled && !prefs.hasPin && !prefs.biometricsEnabled) {
                      await _showPinDialog(context, ref);
                      if (!ref.read(preferencesProvider).hasPin) return;
                    }
                    await ref
                        .read(preferencesProvider.notifier)
                        .setAppLockEnabled(enabled);
                  },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.fingerprint),
                  title: const Text('Biometric Unlock'),
                  subtitle: const Text('Use fingerprint or Face ID via local_auth'),
                  value: prefs.biometricsEnabled,
                  onChanged: (enabled) async {
                    if (enabled) {
                      final available = await ref
                          .read(appLockServiceProvider)
                          .isBiometricsAvailable();
                      if (!available) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Biometrics are not available or enrolled on this device.',
                              ),
                            ),
                          );
                        }
                        return;
                      }
                    }
                    await ref
                        .read(preferencesProvider.notifier)
                        .setBiometricsEnabled(enabled);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader('Alerts & Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  secondary: const Icon(Icons.notifications_active_outlined),
                  title: const Text('New Cycle Start Reminder'),
                  value: prefs.notifyCycleStart,
                  onChanged: (v) => ref
                      .read(preferencesProvider.notifier)
                      .setNotifyCycleStart(v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.trending_up),
                  title: const Text('80% Budget Threshold Alert'),
                  value: prefs.notifyThreshold80,
                  onChanged: (v) => ref
                      .read(preferencesProvider.notifier)
                      .setNotifyThreshold80(v),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.warning_amber_outlined),
                  title: const Text('100% Budget Limit Alert'),
                  value: prefs.notifyThreshold100,
                  onChanged: (v) => ref
                      .read(preferencesProvider.notifier)
                      .setNotifyThreshold100(v),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader('Backup & Restore'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.cloud_download_outlined),
                  title: const Text('Export JSON Backup'),
                  subtitle: const Text(
                    'Save a full portable snapshot of cycles, notes, and meal modes',
                  ),
                  onTap: () async {
                    try {
                      await ref
                          .read(backupServiceProvider)
                          .exportAndShareJsonBackup();
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Backup failed: $e')),
                        );
                      }
                    }
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.restore_outlined),
                  title: const Text('Restore from JSON Backup'),
                  subtitle: const Text(
                    'Replaces local data with a previously exported backup file',
                  ),
                  onTap: () => _restoreJsonBackup(context, ref),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _SectionHeader('App Updates (Over-the-Air)'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.system_update_outlined),
                  title: const Text('Check for Updates'),
                  subtitle: Text(
                    updateState.isLoading
                        ? 'Checking GitHub Releases...'
                        : (updateState.valueOrNull?.hasUpdate == true
                            ? 'Update ${updateState.valueOrNull!.updateInfo!.latestVersion.displayLabel} ready to install!'
                            : 'Installed: ${versionAsync.valueOrNull?.displayLabel ?? 'v1.0.0+1'}'),
                  ),
                  trailing: updateState.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.refresh),
                  onTap: updateState.isLoading
                      ? null
                      : () async {
                          final res = await ref
                              .read(updateCheckProvider.notifier)
                              .checkNow();
                          if (!context.mounted) return;
                          if (res.hasUpdate) {
                            await showDialog<void>(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => UpdateAvailableDialog(
                                info: res.updateInfo!,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  res.message ??
                                      'You are on the latest version.',
                                ),
                              ),
                            );
                          }
                        },
                ),
                const Divider(height: 1),
                SwitchListTile(
                  secondary: const Icon(Icons.autorenew),
                  title: const Text('Auto-Check on Launch'),
                  subtitle: const Text(
                    'Silently checks GitHub Releases when online',
                  ),
                  value: prefs.autoCheckUpdates,
                  onChanged: (v) => ref
                      .read(preferencesProvider.notifier)
                      .setAutoCheckUpdates(v),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('Update Source (GitHub Repo)'),
                  subtitle: Text(
                    prefs.githubUpdateRepo.isEmpty
                        ? 'Not configured (tap to set owner/repo)'
                        : prefs.githubUpdateRepo,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _editGithubRepo(context, ref, prefs),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickStartDay(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
    int? activeCycleId,
  ) async {
    final chosenDay = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Custom Month Start Day (1–31)',
                style: Theme.of(ctx)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              const Text(
                'Short months (e.g., Feb, Apr) automatically clamp to their last calendar day.',
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                itemCount: 31,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (_, index) {
                  final day = index + 1;
                  final isSelected = day == prefs.cycleStartDay;
                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => Navigator.pop(ctx, day),
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.brandDeepGreen
                            : Colors.grey.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (chosenDay == null || chosenDay == prefs.cycleStartDay) return;
    if (!context.mounted) return;

    // Change Application Policy: Prompt Current Active Cycle vs Next Cycle
    final policy = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Apply Start Day $chosenDay?'),
        content: const Text(
          'Would you like to apply this custom start day to your current active budget cycle immediately, or starting from the next cycle?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, 'next'),
            child: const Text('Next Cycle'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, 'current'),
            child: const Text('Current Cycle'),
          ),
        ],
      ),
    );

    if (policy == 'current') {
      await ref
          .read(preferencesProvider.notifier)
          .setCycleStartDay(chosenDay, clearPending: true);
      if (activeCycleId != null) {
        await ref.read(cycleRepositoryProvider).applyStartDayToCurrentCycle(
              cycleId: activeCycleId,
              newStartDay: chosenDay,
              mealSyncTarget: prefs.mealSyncTarget,
            );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Active cycle updated to start on day $chosenDay.')),
        );
      }
    } else if (policy == 'next') {
      await ref
          .read(preferencesProvider.notifier)
          .setPendingNextCycleStartDay(chosenDay);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Start day $chosenDay will take effect on your next budget cycle.',
            ),
          ),
        );
      }
    }
  }

  Future<void> _editDefaultSalary(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
  ) async {
    final ctrl = TextEditingController(
      text: CurrencyFormatter.formatCompactInput(prefs.defaultSalary),
    );
    final value = await showDialog<double>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Default Monthly Salary'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [NonNegativeDecimalInputFormatter()],
          decoration: const InputDecoration(labelText: 'Salary Amount'),
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
    if (value != null) {
      await ref.read(preferencesProvider.notifier).setDefaultSalary(value);
    }
  }

  Future<void> _selectMealSyncTarget(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
    int? activeCycleId,
  ) async {
    final chosen = await showDialog<MealSyncTarget>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Sync Weekly Meals To'),
        children: [
          for (final t in MealSyncTarget.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, t),
              child: Row(
                children: [
                  Icon(
                    t == prefs.mealSyncTarget
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(t.label),
                ],
              ),
            ),
        ],
      ),
    );
    if (chosen != null && chosen != prefs.mealSyncTarget) {
      await ref.read(preferencesProvider.notifier).setMealSyncTarget(chosen);
      if (activeCycleId != null) {
        await ref
            .read(mealRepositoryProvider)
            .syncFoodSubsectionForCycle(activeCycleId, chosen);
      }
    }
  }

  Future<void> _selectCurrencyFormat(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
  ) async {
    final chosen = await showDialog<CurrencyFormatStyle>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Currency Format'),
        children: [
          for (final s in CurrencyFormatStyle.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, s),
              child: Row(
                children: [
                  Icon(
                    s == prefs.currencyFormat
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(s.exampleLabel),
                ],
              ),
            ),
        ],
      ),
    );
    if (chosen != null) {
      await ref.read(preferencesProvider.notifier).setCurrencyFormat(chosen);
    }
  }

  Future<void> _selectThemeMode(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
  ) async {
    final chosen = await showDialog<ThemeMode>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Theme Mode'),
        children: [
          for (final mode in ThemeMode.values)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, mode),
              child: Row(
                children: [
                  Icon(
                    mode == prefs.themeMode
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(mode.name.toUpperCase()),
                ],
              ),
            ),
        ],
      ),
    );
    if (chosen != null) {
      await ref.read(preferencesProvider.notifier).setThemeMode(chosen);
    }
  }

  Future<void> _showPinDialog(BuildContext context, WidgetRef ref) async {
    final pinCtrl = TextEditingController();
    final pin = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set App PIN (4–6 digits)'),
        content: TextField(
          controller: pinCtrl,
          autofocus: true,
          obscureText: true,
          maxLength: 6,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'New PIN'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final text = pinCtrl.text.trim();
              if (text.length < 4) return;
              Navigator.pop(ctx, text);
            },
            child: const Text('Save PIN'),
          ),
        ],
      ),
    );
    pinCtrl.dispose();
    if (pin != null && pin.length >= 4) {
      await ref.read(preferencesProvider.notifier).setPin(pin);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('App PIN saved securely.')),
        );
      }
    }
  }

  Future<void> _showTemplatesSheet(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
  ) async {
    final repo = ref.read(cycleRepositoryProvider);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: StreamBuilder(
            stream: repo.watchCategoryTemplates(),
            builder: (ctx, snapshot) {
              final items = snapshot.data ?? const [];
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Default Category Templates',
                    style: Theme.of(ctx)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  for (final tpl in items)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(tpl.name),
                      trailing: Text(
                        CurrencyFormatter.format(
                          tpl.defaultAllocated,
                          style: prefs.currencyFormat,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      onTap: () async {
                        final ctrl = TextEditingController(
                          text: CurrencyFormatter.formatCompactInput(
                            tpl.defaultAllocated,
                          ),
                        );
                        final updated = await showDialog<double>(
                          context: ctx,
                          builder: (dCtx) => AlertDialog(
                            title: Text('Default ${tpl.name}'),
                            content: TextField(
                              controller: ctrl,
                              autofocus: true,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                NonNegativeDecimalInputFormatter(),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(dCtx),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(
                                  dCtx,
                                  double.tryParse(ctrl.text.trim()) ?? 0.0,
                                ),
                                child: const Text('Save'),
                              ),
                            ],
                          ),
                        );
                        ctrl.dispose();
                        if (updated != null) {
                          await repo.updateCategoryTemplateAllocation(
                            tpl.id,
                            updated,
                          );
                        }
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _editGithubRepo(
    BuildContext context,
    WidgetRef ref,
    AppPreferencesState prefs,
  ) async {
    final ctrl = TextEditingController(text: prefs.githubUpdateRepo);
    final repo = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('GitHub Update Repository'),
        content: TextField(
          controller: ctrl,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Repository (owner/repo)',
            hintText: 'ruwanwija/personal-budget-app',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, ctrl.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    ctrl.dispose();
    if (repo != null) {
      await ref.read(preferencesProvider.notifier).setGithubUpdateRepo(repo);
    }
  }

  Future<void> _restoreJsonBackup(BuildContext context, WidgetRef ref) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      final bytes = result?.files.single.bytes;
      if (bytes == null) return;
      final content = utf8.decode(bytes);
      await ref.read(backupServiceProvider).restoreFromJsonString(content);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup restored successfully.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Restore failed: $e')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              letterSpacing: 0.7,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
