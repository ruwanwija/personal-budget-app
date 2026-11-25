import 'package:equatable/equatable.dart';

class SemanticVersion extends Equatable implements Comparable<SemanticVersion> {
  const SemanticVersion({
    required this.major,
    required this.minor,
    required this.patch,
    this.buildNumber = 0,
  });

  final int major;
  final int minor;
  final int patch;
  final int buildNumber;

  /// Parses tags like "v1.2.3", "1.2.3+4", or "v1.2.3-beta+5".
  static SemanticVersion? tryParse(String raw) {
    final cleaned = raw.trim().replaceFirst(RegExp(r'^[vV]'), '');
    if (cleaned.isEmpty) return null;

    final plusParts = cleaned.split('+');
    final buildNumber =
        plusParts.length > 1 ? (int.tryParse(plusParts[1].trim()) ?? 0) : 0;

    final core = plusParts.first.split('-').first.trim();
    final nums = core.split('.');
    if (nums.isEmpty) return null;

    final major = int.tryParse(nums[0]);
    final minor = nums.length > 1 ? int.tryParse(nums[1]) : 0;
    final patch = nums.length > 2 ? int.tryParse(nums[2]) : 0;
    if (major == null || minor == null || patch == null) return null;

    return SemanticVersion(
      major: major,
      minor: minor,
      patch: patch,
      buildNumber: buildNumber,
    );
  }

  bool isNewerThan(SemanticVersion other) => compareTo(other) > 0;

  @override
  int compareTo(SemanticVersion other) {
    if (major != other.major) return major.compareTo(other.major);
    if (minor != other.minor) return minor.compareTo(other.minor);
    if (patch != other.patch) return patch.compareTo(other.patch);
    return buildNumber.compareTo(other.buildNumber);
  }

  String get displayLabel =>
      buildNumber > 0 ? 'v$major.$minor.$patch+$buildNumber' : 'v$major.$minor.$patch';

  @override
  List<Object?> get props => [major, minor, patch, buildNumber];
}

class AppUpdateInfo extends Equatable {
  const AppUpdateInfo({
    required this.currentVersion,
    required this.latestVersion,
    required this.releaseTitle,
    required this.releaseNotes,
    required this.apkDownloadUrl,
    required this.apkFileName,
    required this.apkSizeBytes,
    required this.releasePageUrl,
    this.publishedAt,
  });

  final SemanticVersion currentVersion;
  final SemanticVersion latestVersion;
  final String releaseTitle;
  final String releaseNotes;
  final String apkDownloadUrl;
  final String apkFileName;
  final int apkSizeBytes;
  final String releasePageUrl;
  final DateTime? publishedAt;

  String get formattedSize {
    if (apkSizeBytes <= 0) return '';
    final mb = apkSizeBytes / (1024 * 1024);
    return '${mb.toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [
        currentVersion,
        latestVersion,
        releaseTitle,
        releaseNotes,
        apkDownloadUrl,
        apkFileName,
        apkSizeBytes,
        releasePageUrl,
        publishedAt,
      ];
}

enum UpdateCheckStatus {
  upToDate,
  updateAvailable,
  notConfigured,
  unsupportedPlatform,
  error,
}

class UpdateCheckResult extends Equatable {
  const UpdateCheckResult({
    required this.status,
    required this.currentVersionLabel,
    this.updateInfo,
    this.message,
  });

  final UpdateCheckStatus status;
  final String currentVersionLabel;
  final AppUpdateInfo? updateInfo;
  final String? message;

  bool get hasUpdate =>
      status == UpdateCheckStatus.updateAvailable && updateInfo != null;

  @override
  List<Object?> get props => [status, currentVersionLabel, updateInfo, message];
}
