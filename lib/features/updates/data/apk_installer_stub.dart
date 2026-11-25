import 'package:flutter/foundation.dart';

Future<void> downloadAndInstallApk({
  required String downloadUrl,
  required String fileName,
  required ValueChanged<double> onProgress,
}) async {
  throw UnsupportedError(
    'Direct APK installation is only supported on Android devices.',
  );
}
