// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of 'app_store.dart';

/// Backup and restore: the whole data set to and from one JSON document,
/// optionally password-protected. Split out of app_store.dart to keep the
/// store itself focused on holding and persisting the data.
extension AppStoreBackup on AppStore {
  Map<String, Object?> _backupData() => {
    'onboardingSeen': onboardingSeen,
    'textScale': textScale,
    'nextId': _nextId,
    'callRoomSalt': callRoomSalt,
    if (profile != null) 'profile': jsonEncode(profile!.toJson()),
    for (final (key, list) in <(String, List<dynamic>)>[
      ('relatives', relatives),
      ('medicines', medicines),
      ('appointments', appointments),
      ('notes', notes),
      ('documents', documents),
      ('trackerEntries', trackerEntries),
    ])
      key: jsonEncode([for (final item in list) item.toJson()]),
  };

  /// Everything the app holds, as one JSON document. With a [password] the
  /// contents are encrypted (PBKDF2 + AES-256-GCM).
  Future<String> exportBackup({String? password}) async {
    final plain = jsonEncode({
      'format': AppStore._backupFormat,
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'data': _backupData(),
    });
    if (password == null || password.isEmpty) return plain;
    return jsonEncode({
      'format': AppStore._backupFormat,
      'version': 2,
      'encrypted': await PasswordCrypto.encrypt(plain, password),
    });
  }

  /// Replaces all data with a backup made by [exportBackup].
  ///
  /// The whole file is checked before anything is changed, so a wrong or
  /// damaged file leaves current data untouched. Throws [BackupException]
  /// for bad files and [BackupPasswordException] for protected ones.
  Future<void> importBackup(String json, {String? password}) async {
    const notBackup = BackupException(BackupError.notBackup);
    if (json.length > AppStore.maxBackupLength) {
      throw const BackupException(BackupError.tooLarge);
    }
    Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw notBackup;
    }
    if (decoded is! Map || decoded['format'] != AppStore._backupFormat) {
      throw notBackup;
    }

    final sealed = decoded['encrypted'];
    if (sealed is Map) {
      if (password == null || password.isEmpty) {
        throw const BackupPasswordException(wrongPassword: false);
      }
      final String inner;
      try {
        inner = await PasswordCrypto.decrypt(
          sealed.cast<String, Object?>(),
          password,
        );
      } on SecretBoxAuthenticationError {
        throw const BackupPasswordException(wrongPassword: true);
      } on UnknownProtectionException {
        throw const BackupException(BackupError.unknownProtection);
      } catch (_) {
        // Anything else (bad base64 and so on) means a damaged file.
        throw const BackupException(BackupError.damaged);
      }
      return importBackup(inner);
    }

    final rawData = decoded['data'];
    if (rawData is! Map) throw notBackup;
    final data = rawData.cast<String, Object?>();
    if (data['profile'] is! String) {
      throw const BackupException(BackupError.noProfile);
    }
    final sections = <String, String>{};
    for (final key in AppStore._sealed) {
      final v = data[key];
      if (v == null) continue;
      if (v is! String) {
        throw const BackupException(BackupError.damaged);
      }
      sections[key] = v;
    }
    // Throws before anything is touched if any part is unreadable.
    final parsed = AppStore._parse(sections, strict: true);
    if (parsed.profile == null) {
      throw const BackupException(BackupError.noProfile);
    }

    final scale = data['textScale'];
    final salt = data['callRoomSalt'];
    // Acceptance of the legal documents belongs to this device's user.
    final legalVersion = _prefs.getInt('legal.version');
    final legalAt = _prefs.getString('legal.acceptedAt');
    await _prefs.clear();
    if (legalVersion != null && legalAt != null) {
      await _prefs.setInt('legal.version', legalVersion);
      await _prefs.setString('legal.acceptedAt', legalAt);
    }
    await _prefs.setBool('onboardingSeen', true);
    if (scale is num) {
      await _prefs.setDouble('textScale', scale.toDouble().clamp(1.0, 1.3));
    }
    if (salt is String && AppStore._saltPattern.hasMatch(salt)) {
      await _prefs.setString('callRoomSalt', salt);
    }
    final nextId = data['nextId'];
    _nextId = max(nextId is int ? nextId : 1, parsed.maxId + 1);
    await _prefs.setInt('nextId', _nextId);
    for (final MapEntry(:key, :value) in sections.entries) {
      await _write(key, value);
    }
    onboardingSeen = true;
    textScale = _prefs.getDouble('textScale') ?? 1.0;
    _adopt(parsed);
    _notify();
  }
}
