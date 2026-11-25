import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

Future<void> downloadAndInstallApk({
  required String downloadUrl,
  required String fileName,
  required ValueChanged<double> onProgress,
}) async {
  final client = http.Client();
  try {
    final request = http.Request('GET', Uri.parse(downloadUrl));
    request.headers['Accept'] = 'application/octet-stream';
    final response = await client.send(request);
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpException(
        'Failed to download update (HTTP ${response.statusCode})',
      );
    }

    final totalBytes = response.contentLength ?? 0;
    final tempDir = await getTemporaryDirectory();
    final safeName = fileName.endsWith('.apk') ? fileName : '$fileName.apk';
    final file = File(p.join(tempDir.path, safeName));
    final sink = file.openWrite();

    var received = 0;
    try {
      await for (final chunk in response.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (totalBytes > 0) {
          onProgress((received / totalBytes).clamp(0.0, 1.0));
        }
      }
      await sink.flush();
    } finally {
      await sink.close();
    }

    onProgress(1.0);
    final result = await OpenFilex.open(
      file.path,
      type: 'application/vnd.android.package-archive',
    );
    if (result.type != ResultType.done) {
      throw StateError(
        result.message.isNotEmpty
            ? result.message
            : 'Could not launch Android package installer.',
      );
    }
  } finally {
    client.close();
  }
}
