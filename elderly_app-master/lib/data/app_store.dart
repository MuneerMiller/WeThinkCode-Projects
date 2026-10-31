import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

/// All of the user's data, kept on the device.
///
/// Every mutation saves the affected collection and notifies listeners, so
/// screens simply rebuild from the store.
class AppStore extends ChangeNotifier {
  AppStore._(this._prefs);

  static Future<AppStore> load() async {
    final store = AppStore._(await SharedPreferences.getInstance());
    store._read();
    return store;
  }

  final SharedPreferences _prefs;

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

  /// Random suffix that keeps this user's video-call room private.
  String get callRoomSalt {
    var salt = _prefs.getString('callRoomSalt');
    if (salt == null) {
      final rnd = Random.secure();
      const chars = 'abcdefghijkmnpqrstuvwxyz23456789';
      salt = List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join();
      _prefs.setString('callRoomSalt', salt);
    }
    return salt;
  }

  void _read() {
    onboardingSeen = _prefs.getBool('onboardingSeen') ?? false;
    textScale = _prefs.getDouble('textScale') ?? 1.0;
    _nextId = _prefs.getInt('nextId') ?? 1;
    final p = _prefs.getString('profile');
    profile = p == null ? null : UserProfile.fromJson(jsonDecode(p));
    _readList('relatives', relatives, Relative.fromJson);
    _readList('medicines', medicines, Medicine.fromJson);
    _readList('appointments', appointments, Appointment.fromJson);
    _readList('notes', notes, Note.fromJson);
    _readList('documents', documents, HealthDocument.fromJson);
    _readList('trackerEntries', trackerEntries, TrackerEntry.fromJson);
  }

  void _readList<T>(
    String key,
    List<T> into,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    into.clear();
    final raw = _prefs.getString(key);
    if (raw == null) return;
    try {
      for (final item in jsonDecode(raw) as List) {
        into.add(fromJson(item as Map<String, dynamic>));
      }
    } catch (e) {
      debugPrint('Could not read $key: $e');
    }
  }

  Future<void> _save(String key, List<dynamic> list) async {
    notifyListeners();
    await _prefs.setString(
      key,
      jsonEncode([for (final item in list) item.toJson()]),
    );
  }

  // Profile & onboarding

  Future<void> markOnboardingSeen() async {
    onboardingSeen = true;
    notifyListeners();
    await _prefs.setBool('onboardingSeen', true);
  }

  Future<void> saveProfile(UserProfile value) async {
    profile = value;
    notifyListeners();
    await _prefs.setString('profile', jsonEncode(value.toJson()));
  }

  Future<void> setTextScale(double value) async {
    textScale = value;
    notifyListeners();
    await _prefs.setDouble('textScale', value);
  }

  // Backup & restore

  static const _backupFormat = 'elderly-care-backup';

  /// Everything the app has stored, as one JSON document.
  String exportBackup() {
    final data = <String, Object?>{
      for (final key in _prefs.getKeys()) key: _prefs.get(key),
    };
    return const JsonEncoder.withIndent(' ').convert({
      'format': _backupFormat,
      'version': 1,
      'exportedAt': DateTime.now().toIso8601String(),
      'data': data,
    });
  }

  /// Replaces all data with a backup made by [exportBackup].
  ///
  /// Throws a [FormatException] if [json] isn't such a backup; existing data
  /// is left untouched in that case.
  Future<void> importBackup(String json) async {
    final Object? decoded;
    try {
      decoded = jsonDecode(json);
    } on FormatException {
      throw const FormatException('This file is not an Elderly Care backup.');
    }
    if (decoded is! Map ||
        decoded['format'] != _backupFormat ||
        decoded['data'] is! Map) {
      throw const FormatException('This file is not an Elderly Care backup.');
    }
    final data = (decoded['data'] as Map).cast<String, Object?>();
    if (data['profile'] is! String) {
      throw const FormatException('This backup has no profile in it.');
    }
    await _prefs.clear();
    for (final MapEntry(:key, :value) in data.entries) {
      switch (value) {
        case final bool v:
          await _prefs.setBool(key, v);
        case final int v:
          await _prefs.setInt(key, v);
        case final double v:
          await _prefs.setDouble(key, v);
        case final String v:
          await _prefs.setString(key, v);
        case final List v:
          await _prefs.setStringList(key, v.cast<String>());
      }
    }
    _read();
    notifyListeners();
  }

  Future<void> resetEverything() async {
    await _prefs.clear();
    _read();
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
