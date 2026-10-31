import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart'
    show SecretBoxAuthenticationError;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../security/app_lock.dart';
import '../security/crypto.dart';
import 'models.dart';

/// Thrown by [AppStore.importBackup] when a backup is password-protected and
/// the password is missing or wrong.
class BackupPasswordException implements Exception {
  const BackupPasswordException({required this.wrongPassword});
  final bool wrongPassword;
  @override
  String toString() => wrongPassword
      ? 'That password is not right.'
      : 'This backup is protected with a password.';
}

/// Parsed contents of the encrypted data sections.
class _Data {
  UserProfile? profile;
  final relatives = <Relative>[];
  final medicines = <Medicine>[];
  final appointments = <Appointment>[];
  final notes = <Note>[];
  final documents = <HealthDocument>[];
  final trackerEntries = <TrackerEntry>[];

  int get maxId => [
    for (final l in <List<dynamic>>[
      relatives,
      medicines,
      appointments,
      notes,
      documents,
      trackerEntries,
    ])
      for (final e in l) e.id as int,
  ].fold(0, max);
}

/// All of the user's data, kept on the device.
///
/// Health data is encrypted with a key held in the platform's secure key
/// storage (see [Vault]). Every mutation saves the affected section and
/// notifies listeners, so screens simply rebuild from the store.
class AppStore extends ChangeNotifier {
  AppStore._(this._prefs, this._vault, this.lock) {
    lock.addListener(notifyListeners);
  }

  static Future<AppStore> load({
    KeyStore keys = const SecureKeyStore(),
    Biometrics biometrics = const DeviceBiometrics(),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final vault = await Vault.open(keys);
    final lock = await AppLock.load(prefs, keys, biometrics);
    final store = AppStore._(prefs, vault, lock);
    await store._read();
    return store;
  }

  final SharedPreferences _prefs;
  final Vault _vault;
  final AppLock lock;

  /// Whether health data is encrypted on this device.
  bool get isEncrypted => _vault.isEncrypted;

  /// Sections holding personal or health data; always stored encrypted.
  static const _sealed = [
    'profile',
    'relatives',
    'medicines',
    'appointments',
    'notes',
    'documents',
    'trackerEntries',
  ];

  UserProfile? profile;
  bool onboardingSeen = false;

  /// Extra text enlargement on top of the phone's own setting.
  double textScale = 1.0;
  final List<Relative> relatives = [];
  final List<Medicine> medicines = [];
  final List<Appointment> appointments = [];
  final List<Note> notes = [];
  final List<HealthDocument> documents = [];
  final List<TrackerEntry> trackerEntries = [];
  int _nextId = 1;

  int newId() {
    final id = _nextId++;
    _prefs.setInt('nextId', _nextId);
    return id;
  }

  static final _saltPattern = RegExp(r'^[a-z0-9]{16,64}$');

  /// Random name for this user's video-call room. 16 characters from a
  /// 32-letter alphabet (80 bits) so the room can't be guessed.
  String get callRoomSalt {
    var salt = _prefs.getString('callRoomSalt');
    if (salt == null || !_saltPattern.hasMatch(salt)) {
      final rnd = Random.secure();
      const chars = 'abcdefghijkmnpqrstuvwxyz23456789';
      salt = List.generate(16, (_) => chars[rnd.nextInt(chars.length)]).join();
      _prefs.setString('callRoomSalt', salt);
    }
    return salt;
  }

  Future<void> _read() async {
    onboardingSeen = _prefs.getBool('onboardingSeen') ?? false;
    textScale = (_prefs.getDouble('textScale') ?? 1.0).clamp(1.0, 1.3);
    _nextId = _prefs.getInt('nextId') ?? 1;

    final sections = <String, String>{};
    for (final key in _sealed) {
      final raw = _prefs.getString(key);
      if (raw == null) continue;
      try {
        sections[key] = await _vault.unseal(raw);
      } catch (e) {
        debugPrint('Could not decrypt $key (${e.runtimeType})');
      }
    }
    // A damaged section is skipped rather than stopping the app from opening.
    _adopt(_parse(sections, strict: false));

    // Encrypt anything saved before encryption was added.
    if (_vault.isEncrypted) {
      for (final MapEntry(:key, :value) in sections.entries) {
        if (!Vault.isSealed(_prefs.getString(key)!)) _write(key, value);
      }
    }
  }

  /// Turns decrypted JSON sections into data. With [strict], any problem
  /// throws a [FormatException]; otherwise bad sections are left empty.
  static _Data _parse(Map<String, String> sections, {required bool strict}) {
    final data = _Data();
    void section(String key, void Function(Object? json) apply) {
      final raw = sections[key];
      if (raw == null) return;
      try {
        apply(jsonDecode(raw));
      } catch (e) {
        if (strict) {
          throw const FormatException(
            'This backup is damaged and could not be read.',
          );
        }
        debugPrint('Could not read $key (${e.runtimeType})');
      }
    }

    void list<T>(
      String key,
      List<T> into,
      T Function(Map<String, dynamic>) f,
    ) => section(key, (json) {
      final items = [
        for (final item in json as List) f(item as Map<String, dynamic>),
      ];
      into.addAll(items);
    });

    section('profile', (json) {
      data.profile = UserProfile.fromJson(json as Map<String, dynamic>);
    });
    list('relatives', data.relatives, Relative.fromJson);
    list('medicines', data.medicines, Medicine.fromJson);
    list('appointments', data.appointments, Appointment.fromJson);
    list('notes', data.notes, Note.fromJson);
    list('documents', data.documents, HealthDocument.fromJson);
    list('trackerEntries', data.trackerEntries, TrackerEntry.fromJson);
    return data;
  }

  void _adopt(_Data d) {
    profile = d.profile;
    relatives
      ..clear()
      ..addAll(d.relatives);
    medicines
      ..clear()
      ..addAll(d.medicines);
    appointments
      ..clear()
      ..addAll(d.appointments);
    notes
      ..clear()
      ..addAll(d.notes);
    documents
      ..clear()
      ..addAll(d.documents);
    trackerEntries
      ..clear()
      ..addAll(d.trackerEntries);
    _nextId = max(_nextId, d.maxId + 1);
  }

  final _pending = <String, Future<void>>{};

  /// Encrypts and stores [plain] under [key]. Writes to the same key run in
  /// order, so the latest state always wins.
  Future<void> _write(String key, String plain) {
    final previous = _pending[key] ?? Future<void>.value();
    final next = previous.then((_) async {
      await _prefs.setString(key, await _vault.seal(plain));
    });
    _pending[key] = next;
    return next;
  }

  Future<void> _save(String key, List<dynamic> list) {
    notifyListeners();
    return _write(key, jsonEncode([for (final item in list) item.toJson()]));
  }

  /// Waits until every pending save has reached storage.
  Future<void> flush() => Future.wait(_pending.values);

  // Profile & onboarding

  Future<void> markOnboardingSeen() async {
    onboardingSeen = true;
    notifyListeners();
    await _prefs.setBool('onboardingSeen', true);
  }

  Future<void> saveProfile(UserProfile value) {
    profile = value;
    notifyListeners();
    return _write('profile', jsonEncode(value.toJson()));
  }

  Future<void> setTextScale(double value) async {
    textScale = value;
    notifyListeners();
    await _prefs.setDouble('textScale', value);
  }

  // Backup & restore

  static const _backupFormat = 'elderly-care-backup';
  static const maxBackupLength = 60 * 1024 * 1024;

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
      'format': _backupFormat,
      'version': 2,
      'exportedAt': DateTime.now().toIso8601String(),
      'data': _backupData(),
    });
    if (password == null || password.isEmpty) return plain;
    return jsonEncode({
      'format': _backupFormat,
      'version': 2,
      'encrypted': await PasswordCrypto.encrypt(plain, password),
    });
  }

  /// Replaces all data with a backup made by [exportBackup].
  ///
  /// The whole file is checked before anything is changed, so a wrong or
  /// damaged file leaves current data untouched. Throws [FormatException]
  /// for bad files and [BackupPasswordException] for protected ones.
  Future<void> importBackup(String json, {String? password}) async {
    const notBackup = FormatException(
      'This file is not an Elderly Care backup.',
    );
    if (json.length > maxBackupLength) {
      throw const FormatException('This file is too large to be a backup.');
    }
    Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw notBackup;
    }
    if (decoded is! Map || decoded['format'] != _backupFormat) throw notBackup;

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
      } on FormatException {
        rethrow;
      } catch (_) {
        throw const FormatException(
          'This backup is damaged and could not be read.',
        );
      }
      return importBackup(inner);
    }

    final rawData = decoded['data'];
    if (rawData is! Map) throw notBackup;
    final data = rawData.cast<String, Object?>();
    if (data['profile'] is! String) {
      throw const FormatException('This backup has no profile in it.');
    }
    final sections = <String, String>{};
    for (final key in _sealed) {
      final v = data[key];
      if (v == null) continue;
      if (v is! String) {
        throw const FormatException(
          'This backup is damaged and could not be read.',
        );
      }
      sections[key] = v;
    }
    // Throws before anything is touched if any part is unreadable.
    final parsed = _parse(sections, strict: true);
    if (parsed.profile == null) {
      throw const FormatException('This backup has no profile in it.');
    }

    final scale = data['textScale'];
    final salt = data['callRoomSalt'];
    await _prefs.clear();
    await _prefs.setBool('onboardingSeen', true);
    if (scale is num) {
      await _prefs.setDouble('textScale', scale.toDouble().clamp(1.0, 1.3));
    }
    if (salt is String && _saltPattern.hasMatch(salt)) {
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
    notifyListeners();
  }

  /// Deletes all data and the app lock, as if freshly installed.
  Future<void> resetEverything() async {
    await flush();
    await _prefs.clear();
    await lock.clear();
    await _read();
    notifyListeners();
  }

  // Generic helpers for the id-keyed collections.

  Future<void> _upsert<T>(
    String key,
    List<T> list,
    T item,
    int Function(T) id,
  ) {
    final i = list.indexWhere((e) => id(e) == id(item));
    if (i == -1) {
      list.add(item);
    } else {
      list[i] = item;
    }
    return _save(key, list);
  }

  Future<void> _remove<T>(
    String key,
    List<T> list,
    int itemId,
    int Function(T) id,
  ) {
    list.removeWhere((e) => id(e) == itemId);
    return _save(key, list);
  }

  Future<void> saveRelative(Relative r) =>
      _upsert('relatives', relatives, r, (e) => e.id);
  Future<void> deleteRelative(int id) =>
      _remove('relatives', relatives, id, (Relative e) => e.id);

  Future<void> saveMedicine(Medicine m) =>
      _upsert('medicines', medicines, m, (e) => e.id);
  Future<void> deleteMedicine(int id) =>
      _remove('medicines', medicines, id, (Medicine e) => e.id);

  Future<void> recordDose(
    Medicine m,
    DateTime day,
    ClockTime slot,
    bool taken,
  ) {
    m.record(day, slot, taken);
    return saveMedicine(m);
  }

  Future<void> saveAppointment(Appointment a) =>
      _upsert('appointments', appointments, a, (e) => e.id);
  Future<void> deleteAppointment(int id) =>
      _remove('appointments', appointments, id, (Appointment e) => e.id);

  Future<void> saveNote(Note n) => _upsert('notes', notes, n, (e) => e.id);
  Future<void> deleteNote(int id) =>
      _remove('notes', notes, id, (Note e) => e.id);

  Future<void> saveDocument(HealthDocument d) =>
      _upsert('documents', documents, d, (e) => e.id);
  Future<void> deleteDocument(int id) =>
      _remove('documents', documents, id, (HealthDocument e) => e.id);

  Future<void> saveTrackerEntry(TrackerEntry e) =>
      _upsert('trackerEntries', trackerEntries, e, (x) => x.id);
  Future<void> deleteTrackerEntry(int id) =>
      _remove('trackerEntries', trackerEntries, id, (TrackerEntry e) => e.id);

  // Derived views

  /// Every dose scheduled for today, in time order.
  List<Dose> dosesToday(DateTime now) =>
      [for (final m in medicines) ...m.dosesOn(now)]
        ..sort((a, b) => a.time.compareTo(b.time));

  List<Appointment> upcomingAppointments(DateTime now) =>
      appointments.where((a) => !a.isPast(now)).toList()
        ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

  List<Appointment> pastAppointments(DateTime now) =>
      appointments.where((a) => a.isPast(now)).toList()
        ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

  /// Entries for one tracker, oldest first.
  List<TrackerEntry> entriesFor(TrackerType type) =>
      trackerEntries.where((e) => e.type == type).toList()
        ..sort((a, b) => a.at.compareTo(b.at));

  List<Note> get sortedNotes => [...notes]
    ..sort((a, b) {
      final p = a.priority.index.compareTo(b.priority.index);
      return p != 0 ? p : b.updatedAt.compareTo(a.updatedAt);
    });
}
