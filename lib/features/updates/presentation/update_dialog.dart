import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pfm_budget_app/app/theme.dart';
import 'package:pfm_budget_app/core/providers/app_providers.dart';
import 'package:pfm_budget_app/features/updates/domain/app_update_models.dart';

class UpdateAvailableDialog extends ConsumerStatefulWidget {
  const UpdateAvailableDialog({
    super.key,
    required this.info,
  });

  final AppUpdateInfo info;

  @override
  ConsumerState<UpdateAvailableDialog> createState() =>
      _UpdateAvailableDialogState();
}

class _UpdateAvailableDialogState extends ConsumerState<UpdateAvailableDialog> {
  bool _downloading = false;
  double _progress = 0.0;
  String? _error;

  Future<void> _startDownloadAndInstall() async {
    setState(() {
      _downloading = true;
      _progress = 0.0;
      _error = null;
    });
    try {
      await ref.read(appUpdateServiceProvider).downloadAndInstall(
            info: widget.info,
            onProgress: (p) {
              if (mounted) setState(() => _progress = p);
            },
          );
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _downloading = false;
          _error = 'Download or install failed: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final pct = (_progress * 100).round();

    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.system_update_rounded,
            color: AppColors.brandDeepGreen,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Update ${info.latestVersion.displayLabel}',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installed: ${info.currentVersion.displayLabel}  →  New: ${info.latestVersion.displayLabel}'
              '${info.formattedSize.isNotEmpty ? ' (${info.formattedSize})' : ''}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.brandTeal,
                  ),
            ),
            const SizedBox(height: 12),
            if (info.releaseNotes.isNotEmpty) ...[
              Text(
                "What's New",
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  info.releaseNotes,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 12),
            ],
            if (_downloading) ...[
              LinearProgressIndicator(value: _progress > 0 ? _progress : null),
              const SizedBox(height: 6),
              Text(
                _progress > 0
                    ? 'Downloading update ($pct%)...'
                    : 'Connecting to GitHub Releases...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(
                _error!,
                style: const TextStyle(
                  color: AppColors.negativeRed,
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _downloading ? null : () => Navigator.of(context).pop(),
          child: const Text('Later'),
        ),
        FilledButton.icon(
          onPressed: _downloading ? null : _startDownloadAndInstall,
          icon: const Icon(Icons.download_rounded, size: 18),
          label: Text(_downloading ? 'Downloading...' : 'Download & Install'),
        ),
      ],
    );
  }
}
