import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// Sends text and files out of the app, and picks files to bring in.
class ShareService {
  const ShareService();

  /// Opens the phone's share sheet (email, WhatsApp, …) with [text].
  Future<bool> shareText(String text, {String? subject}) async {
    try {
      final r = await SharePlus.instance.share(
        ShareParams(text: text, subject: subject, title: subject),
      );
      // Browsers without a share sheet download or email instead and report
      // "unavailable"; only a closed share sheet means nothing happened.
      return r.status != ShareResultStatus.dismissed;
    } catch (e) {
      debugPrint('Share failed (${e.runtimeType})');
      return false;
    }
  }

  /// Shares a text file; in a browser without sharing it is downloaded.
  Future<bool> shareFile(String name, String contents, {String? subject}) =>
      shareBytes(
        name,
        utf8.encode(contents),
        mimeType: 'application/json',
        subject: subject,
      );

  /// Shares any file; in a browser without sharing it is downloaded.
  Future<bool> shareBytes(
    String name,
    Uint8List bytes, {
    required String mimeType,
    String? subject,
  }) async {
    try {
      final r = await SharePlus.instance.share(
        ShareParams(
          files: [XFile.fromData(bytes, name: name, mimeType: mimeType)],
          fileNameOverrides: [name],
          subject: subject,
          title: subject,
          downloadFallbackEnabled: true,
        ),
      );
      // Browsers without a share sheet download or email instead and report
      // "unavailable"; only a closed share sheet means nothing happened.
      return r.status != ShareResultStatus.dismissed;
    } catch (e) {
      debugPrint('Share failed (${e.runtimeType})');
      return false;
    }
  }

  /// Lets the user choose a backup file; null if they cancel.
  Future<String?> pickBackupFile() async {
    final file = await FilePicker.pickFile(
      dialogTitle: 'Choose your Elderly Care backup',
      type: FileType.custom,
      allowedExtensions: const ['json'],
    );
    return file?.xFile.readAsString();
  }
}
