import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pfm_budget_app/features/updates/data/apk_installer.dart';
import 'package:pfm_budget_app/features/updates/domain/app_update_models.dart';

class AppUpdateService {
  AppUpdateService({this.client});

  final http.Client? client;

  /// Automatically injected by GitHub Actions (`--dart-define=GITHUB_REPO=owner/repo`)
  /// and overridable in Settings at runtime.
  static const String compileTimeDefaultRepo = String.fromEnvironment(
    'GITHUB_REPO',
    defaultValue: 'ruwanwija/personal-budget-app',
  );

  Future<SemanticVersion> getInstalledVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final combined = info.buildNumber.isNotEmpty
          ? '${info.version}+${info.buildNumber}'
          : info.version;
      return SemanticVersion.tryParse(combined) ??
          const SemanticVersion(major: 1, minor: 0, patch: 0, buildNumber: 1);
    } catch (_) {
      return const SemanticVersion(major: 1, minor: 0, patch: 0, buildNumber: 1);
    }
  }

  /// Queries GitHub Releases (`GET /repos/{owner}/{repo}/releases/latest`)
  /// and compares the published version against the installed app version.
  Future<UpdateCheckResult> checkForUpdate({
    required String githubRepo,
  }) async {
    final current = await getInstalledVersion();

    if (kIsWeb) {
      return UpdateCheckResult(
        status: UpdateCheckStatus.unsupportedPlatform,
        currentVersionLabel: current.displayLabel,
        message: 'Web builds update automatically on browser refresh.',
      );
    }

    final normalizedRepo = githubRepo.trim().replaceAll(RegExp(r'^/|/$'), '');
    if (normalizedRepo.isEmpty || !normalizedRepo.contains('/')) {
      return UpdateCheckResult(
        status: UpdateCheckStatus.notConfigured,
        currentVersionLabel: current.displayLabel,
        message: 'Set your GitHub repository (owner/repo) in Settings.',
      );
    }

    final httpClient = client ?? http.Client();
    final shouldClose = client == null;
    try {
      final uri = Uri.parse(
        'https://api.github.com/repos/$normalizedRepo/releases/latest',
      );
      final response = await httpClient.get(
        uri,
        headers: const {
          'Accept': 'application/vnd.github+json',
          'User-Agent': 'PersonalBudgetApp',
        },
      ).timeout(const Duration(seconds: 12));

      if (response.statusCode == 404) {
        return UpdateCheckResult(
          status: UpdateCheckStatus.upToDate,
          currentVersionLabel: current.displayLabel,
          message: 'No releases published yet for $normalizedRepo.',
        );
      }

      if (response.statusCode != 200) {
        return UpdateCheckResult(
          status: UpdateCheckStatus.error,
          currentVersionLabel: current.displayLabel,
          message: 'Update check failed (HTTP ${response.statusCode}).',
        );
      }

      final json = jsonDecode(response.body);
      if (json is! Map<String, dynamic>) {
        return UpdateCheckResult(
          status: UpdateCheckStatus.error,
          currentVersionLabel: current.displayLabel,
          message: 'Unexpected response from GitHub Releases.',
        );
      }

      final tagName = (json['tag_name'] as String? ?? '').trim();
      final latest = SemanticVersion.tryParse(tagName);
      if (latest == null) {
        return UpdateCheckResult(
          status: UpdateCheckStatus.error,
          currentVersionLabel: current.displayLabel,
          message: 'Latest release tag "$tagName" is not a valid version.',
        );
      }

      if (!latest.isNewerThan(current)) {
        return UpdateCheckResult(
          status: UpdateCheckStatus.upToDate,
          currentVersionLabel: current.displayLabel,
          message: 'You are on the latest version (${current.displayLabel}).',
        );
      }

      final assets = (json['assets'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .toList();
      Map<String, dynamic>? apkAsset;
      for (final asset in assets) {
        final name = (asset['name'] as String? ?? '').toLowerCase();
        if (name.endsWith('.apk')) {
          apkAsset = asset;
          break;
        }
      }

      if (apkAsset == null) {
        return UpdateCheckResult(
          status: UpdateCheckStatus.error,
          currentVersionLabel: current.displayLabel,
          message:
              'Release ${latest.displayLabel} does not include an APK asset yet.',
        );
      }

      final downloadUrl = apkAsset['browser_download_url'] as String? ?? '';
      final fileName = apkAsset['name'] as String? ?? 'Personal-Budget.apk';
      final size = (apkAsset['size'] as num?)?.toInt() ?? 0;

      return UpdateCheckResult(
        status: UpdateCheckStatus.updateAvailable,
        currentVersionLabel: current.displayLabel,
        updateInfo: AppUpdateInfo(
          currentVersion: current,
          latestVersion: latest,
          releaseTitle: (json['name'] as String? ?? tagName).trim(),
          releaseNotes: (json['body'] as String? ?? '').trim(),
          apkDownloadUrl: downloadUrl,
          apkFileName: fileName,
          apkSizeBytes: size,
          releasePageUrl: (json['html_url'] as String? ?? '').trim(),
          publishedAt: DateTime.tryParse(json['published_at'] as String? ?? ''),
        ),
      );
    } catch (e) {
      return UpdateCheckResult(
        status: UpdateCheckStatus.error,
        currentVersionLabel: current.displayLabel,
        message: 'Unable to check for updates (offline or network error).',
      );
    } finally {
      if (shouldClose) httpClient.close();
    }
  }

  Future<void> downloadAndInstall({
    required AppUpdateInfo info,
    required ValueChanged<double> onProgress,
  }) {
    return downloadAndInstallApk(
      downloadUrl: info.apkDownloadUrl,
      fileName: info.apkFileName,
      onProgress: onProgress,
    );
  }
}
