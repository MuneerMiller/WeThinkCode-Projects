import 'package:elderly_app/data/app_store.dart';
import 'package:elderly_app/data/models.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:elderly_app/data/summary.dart';
import 'package:elderly_app/data/summary_pdf.dart';
import 'package:elderly_app/security/crypto.dart';
import 'package:elderly_app/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Medicine doses', () {
    Medicine pill() => Medicine(
      id: 1,
      name: 'Metformin',
      type: MedicineType.tablet,
      times: const [ClockTime(20, 0), ClockTime(8, 0)],
    );

    test('are listed in time order with the right status', () {
      final m = pill();
      final now = DateTime(2026, 3, 10, 9, 0);
      final doses = m.dosesOn(now);
      expect(doses.map((d) => d.time.hour), [8, 20]);
      expect(doses[0].status, DoseStatus.due); // 8:00 has passed, unanswered
      expect(doses[1].status, DoseStatus.upcoming);
    });

    test('become due 30 minutes early', () {
      final doses = pill().dosesOn(DateTime(2026, 3, 10, 19, 31));
      expect(doses[1].status, DoseStatus.due);
    });

    test('remember answers per day', () {
      final m = pill();
      final day = DateTime(2026, 3, 10, 9);
      m.record(day, const ClockTime(8, 0), true);
      expect(m.dosesOn(day)[0].status, DoseStatus.taken);
      m.record(day, const ClockTime(8, 0), false); // changed their mind
      expect(m.dosesOn(day)[0].status, DoseStatus.skipped);
      expect(m.history, hasLength(1));
      // The next day starts fresh.
      expect(m.dosesOn(DateTime(2026, 3, 11, 9))[0].status, DoseStatus.due);
    });

    test('survive a JSON round trip', () {
      final m = pill()
        ..record(DateTime(2026, 3, 10), const ClockTime(8, 0), true);
      final copy = Medicine.fromJson(m.toJson());
      expect(copy.name, 'Metformin');
      expect(copy.times, m.times);
      expect(
        copy.recordFor(DateTime(2026, 3, 10), const ClockTime(8, 0))?.taken,
        isTrue,
      );
    });
  });

  group('Tracker entries', () {
    test('format readings for display', () {
      TrackerEntry e(TrackerType t, Map<String, num> v) =>
          TrackerEntry(id: 1, type: t, at: DateTime(2026), values: v);
      expect(
        e(TrackerType.bloodPressure, {
          'systolic': 128,
          'diastolic': 82,
          'pulse': 70,
        }).display,
        '128/82 mmHg · 70 bpm',
      );
      expect(e(TrackerType.weight, {'weight': 72.5}).display, '72.5 kg');
      expect(e(TrackerType.weight, {'weight': 72}).display, '72 kg');
      expect(e(TrackerType.sleep, {'hours': 7, 'minutes': 30}).chartValue, 7.5);
    });
  });

  group('Hospital search', () {
    test('parses OpenStreetMap results and sorts by distance', () {
      const here = GeoPoint(-33.9249, 18.4241);
      final list = HospitalService.parse({
        'elements': [
          {
            'type': 'way',
            'center': {'lat': -33.94, 'lon': 18.46},
            'tags': {'name': 'Far Clinic', 'amenity': 'clinic'},
          },
          {
            'type': 'node',
            'lat': -33.926,
            'lon': 18.425,
            'tags': {
              'name': 'Near Hospital',
              'phone': '+27 21 000 0000',
              'addr:street': 'Main Road',
              'addr:housenumber': '1',
            },
          },
          {'type': 'node', 'lat': 1, 'lon': 1, 'tags': {}}, // unnamed: skipped
        ],
      }, here);
      expect(list.map((h) => h.name), ['Near Hospital', 'Far Clinic']);
      expect(list.first.phone, '+27 21 000 0000');
      expect(list.first.address, '1 Main Road');
      expect(list.first.distanceKm, lessThan(0.5));
      expect(list.last.distanceKm, closeTo(3.9, 0.3));
    });
  });

  group('AppStore', () {
    test('persists everything across restarts', () async {
      SharedPreferences.setMockInitialValues({});
      final keys = MemoryKeyStore();
      var store = await AppStore.load(keys: keys);
      await store.saveProfile(UserProfile(name: 'Margaret Smith'));
      await store.saveNote(
        Note(
          id: store.newId(),
          title: 'Ask about knee',
          body: '',
          priority: NotePriority.high,
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        ),
      );
      await store.saveAppointment(
        Appointment(
          id: store.newId(),
          doctor: 'Dr. Naidoo',
          dateTime: DateTime(2030, 1, 1, 10),
        ),
      );

      store = await AppStore.load(keys: keys);
      expect(store.profile?.firstName, 'Margaret');
      expect(store.notes.single.title, 'Ask about knee');
      expect(
        store.upcomingAppointments(DateTime(2029)).single.doctor,
        'Dr. Naidoo',
      );
      expect(store.newId(), 3);
    });

    test('splits appointments into upcoming and past', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: MemoryKeyStore());
      final now = DateTime(2026, 6, 1, 12);
      for (final (d, done) in [
        (DateTime(2026, 6, 3), false),
        (DateTime(2026, 6, 2), false),
        (DateTime(2026, 5, 1), false),
        (DateTime(2026, 6, 4), true),
      ]) {
        await store.saveAppointment(
          Appointment(id: store.newId(), doctor: '$d', dateTime: d, done: done),
        );
      }
      expect(store.upcomingAppointments(now).map((a) => a.dateTime.day), [
        2,
        3,
      ]);
      expect(store.pastAppointments(now).map((a) => a.dateTime.day), [4, 1]);
    });

    test('reset wipes all data', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: MemoryKeyStore());
      await store.saveProfile(UserProfile(name: 'X'));
      await store.saveRelative(Relative(id: 1, name: 'A', phone: '1'));
      await store.resetEverything();
      expect(store.profile, isNull);
      expect(store.relatives, isEmpty);
    });
  });

  group('Medicine supply and history', () {
    test('taking a dose uses one from the pack, and undoing gives it back', () {
      final m = Medicine(
        id: 1,
        name: 'Aspirin',
        type: MedicineType.tablet,
        times: const [ClockTime(8, 0), ClockTime(20, 0)],
        supply: 7,
      );
      final day = DateTime(2026, 3, 10, 9);
      m.record(day, const ClockTime(8, 0), true);
      expect(m.supply, 6);
      m.record(day, const ClockTime(8, 0), true); // same answer again
      expect(m.supply, 6);
      m.record(day, const ClockTime(8, 0), false); // changed their mind
      expect(m.supply, 7);
      expect(m.daysLeft, 3);
      expect(m.isLow, isTrue);
    });

    test('untracked supply never warns', () {
      final m = Medicine(
        id: 1,
        name: 'A',
        type: MedicineType.tablet,
        times: const [ClockTime(8, 0)],
      );
      m.record(DateTime(2026), const ClockTime(8, 0), true);
      expect(m.supply, isNull);
      expect(m.isLow, isFalse);
    });

    test('adherence counts only past doses since the medicine was added', () {
      final m = Medicine(
        id: 1,
        name: 'A',
        type: MedicineType.tablet,
        times: const [ClockTime(8, 0), ClockTime(20, 0)],
        addedOn: DateTime(2026, 3, 8, 7),
      );
      final now = DateTime(2026, 3, 10, 12);
      m.record(DateTime(2026, 3, 8), const ClockTime(8, 0), true);
      m.record(DateTime(2026, 3, 9), const ClockTime(20, 0), true);
      m.record(DateTime(2026, 3, 10), const ClockTime(8, 0), false);
      // 8th: 8:00 + 20:00, 9th: both, 10th: 8:00 only (20:00 hasn't come).
      final a = m.adherence(now);
      expect(a.due, 5);
      expect(a.taken, 2);
    });
  });

  group('Backup', () {
    test('restores everything exactly', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: MemoryKeyStore());
      await store.saveProfile(
        UserProfile(name: 'Margaret Smith', allergies: 'Penicillin'),
      );
      await store.saveRelative(
        Relative(id: store.newId(), name: 'Anna', phone: '082'),
      );
      await store.saveMedicine(
        Medicine(
          id: store.newId(),
          name: 'Metformin',
          type: MedicineType.tablet,
          times: const [ClockTime(8, 0)],
          supply: 20,
        ),
      );
      await store.setTextScale(1.3);
      final backup = await store.exportBackup();

      await store.resetEverything();
      expect(store.profile, isNull);

      await store.importBackup(backup);
      expect(store.profile!.allergies, 'Penicillin');
      expect(store.relatives.single.name, 'Anna');
      expect(store.medicines.single.supply, 20);
      expect(store.textScale, 1.3);
      expect(store.newId(), 3);
    });

    test('rejects files that are not backups and keeps current data', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: MemoryKeyStore());
      await store.saveProfile(UserProfile(name: 'Keep me'));
      for (final bad in [
        'not json',
        '{"hello": 1}',
        '{"format": "elderly-care-backup", "data": {}}',
      ]) {
        await expectLater(
          store.importBackup(bad),
          throwsFormatException,
          reason: bad,
        );
      }
      expect(store.profile!.name, 'Keep me');
    });
  });

  test('health summary lists details, medicines and recent readings', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await AppStore.load(keys: MemoryKeyStore());
    final now = DateTime(2026, 3, 10, 12);
    await store.saveProfile(
      UserProfile(
        name: 'Margaret Smith',
        age: '78',
        bloodGroup: 'O+',
        conditions: 'Type 2 diabetes',
        allergies: 'Penicillin',
      ),
    );
    await store.saveMedicine(
      Medicine(
        id: 1,
        name: 'Metformin',
        dosage: '500 mg',
        type: MedicineType.tablet,
        times: const [ClockTime(20, 0), ClockTime(8, 0)],
      ),
    );
    await store.saveTrackerEntry(
      TrackerEntry(
        id: 2,
        type: TrackerType.bloodPressure,
        at: DateTime(2026, 3, 9, 8, 30),
        values: {'systolic': 128, 'diastolic': 82, 'pulse': 70},
        notes: 'after breakfast',
      ),
    );
    await store.saveTrackerEntry(
      TrackerEntry(
        id: 3,
        type: TrackerType.weight,
        at: DateTime(2025, 1, 1), // too old: left out
        values: {'weight': 70},
      ),
    );
    final text = healthSummary(store, now);
    expect(text, contains('Health summary for Margaret Smith'));
    expect(text, contains('Age 78 · Blood group O+'));
    expect(text, contains('Conditions: Type 2 diabetes'));
    expect(text, contains('Allergies: Penicillin'));
    expect(text, contains('- Metformin 500 mg at 08:00, 20:00'));
    expect(text, contains('BLOOD PRESSURE (1 reading)'));
    expect(
      text,
      contains('9 Mar, 08:30: 128/82 mmHg · 70 bpm – after breakfast'),
    );
    expect(text, isNot(contains('WEIGHT')));
  });

  test('PDF summary contains the details, medicines and readings', () async {
    SharedPreferences.setMockInitialValues({});
    final store = await AppStore.load(keys: MemoryKeyStore());
    final now = DateTime(2026, 3, 10, 12);
    await store.saveProfile(
      UserProfile(
        name: 'Margaret Smith',
        bloodGroup: 'O+',
        allergies: 'Penicillin',
        conditions: 'Type 2 diabetes',
      ),
    );
    await store.saveMedicine(
      Medicine(
        id: 1,
        name: 'Metformin',
        dosage: '500 mg',
        type: MedicineType.tablet,
        times: const [ClockTime(8, 0)],
        addedOn: DateTime(2026, 3, 1),
      )..record(DateTime(2026, 3, 9), const ClockTime(8, 0), true),
    );
    for (var i = 0; i < 40; i++) {
      await store.saveTrackerEntry(
        TrackerEntry(
          id: 100 + i,
          type: TrackerType.bloodSugar,
          at: now.subtract(Duration(hours: 18 * i)),
          values: {'glucose': 90 + i},
        ),
      );
    }
    ByteData font(int w) => ByteData.sublistView(
      File('assets/fonts/Lexend-$w.ttf').readAsBytesSync(),
    );
    final bytes = await healthSummaryPdf(
      store,
      now,
      regular: font(400),
      bold: font(700),
    );
    final dir = await Directory.systemTemp.createTemp('pdf');
    final file = File('${dir.path}/summary.pdf')..writeAsBytesSync(bytes);
    // Reads the text back with poppler's pdftotext. CI installs it; locally
    // the test is skipped if it is missing, but never silently on CI.
    final ProcessResult text;
    try {
      text = Process.runSync('pdftotext', ['-layout', file.path, '-']);
    } on ProcessException {
      if (Platform.environment['CI'] == 'true') {
        fail('pdftotext is required on CI (install poppler-utils)');
      }
      markTestSkipped('pdftotext is not installed (poppler-utils)');
      return;
    }
    expect(text.exitCode, 0, reason: '${text.stderr}');
    final out = text.stdout as String;
    for (final expected in [
      'Health summary',
      'Margaret Smith',
      'Penicillin',
      'Type 2 diabetes',
      'Metformin',
      '500 mg',
      '1 of 7', // taken 1 of the 7 doses due 4–10 March
      'Blood sugar (40 readings)',
      '129 mg/dL',
      'Page 2 of 2',
    ]) {
      expect(out, contains(expected), reason: expected);
    }
    expect(out, isNot(contains('Blood pressure'))); // no readings: no section
  });

  group('Personal setup', () {
    test('suggested medicine times fit the user\'s day', () {
      final p = UserProfile(name: 'Margaret Smith');
      expect(p.suggestedDoseTimes, const [
        ClockTime(8, 0),
        ClockTime(14, 0),
        ClockTime(20, 0),
      ]);
      p
        ..wakeTime = const ClockTime(6, 0)
        ..bedTime = const ClockTime(22, 0);
      expect(p.suggestedDoseTimes, const [
        ClockTime(6, 30),
        ClockTime(13, 0),
        ClockTime(21, 0),
      ]);
      // An unusual day (night shifts) falls back to the usual times.
      p
        ..wakeTime = const ClockTime(14, 0)
        ..bedTime = const ClockTime(6, 0);
      expect(p.suggestedDoseTimes.first, const ClockTime(8, 0));
    });

    test('profile choices survive saving, and old profiles still load', () {
      final p = UserProfile(
        name: 'Margaret Smith',
        nickname: 'Gogo',
        interests: ['medicines', 'family'],
        wakeTime: const ClockTime(6, 15),
        bedTime: const ClockTime(21, 45),
      );
      final back = UserProfile.fromJson(p.toJson());
      expect(back.callName, 'Gogo');
      expect(back.interests, ['medicines', 'family']);
      expect(back.wakeTime, const ClockTime(6, 15));
      expect(back.bedTime, const ClockTime(21, 45));

      final old = UserProfile.fromJson({'name': 'Margaret Smith'});
      expect(old.callName, 'Margaret');
      expect(old.interests, isNull);
      expect(old.wakeTime, isNull);
      expect(
        UserProfile.fromJson({'name': 'A', 'wakeTime': '25:99'}).wakeTime,
        isNull,
      );
    });
  });
}
