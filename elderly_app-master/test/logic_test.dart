import 'package:elderly_app/data/app_store.dart';
import 'package:elderly_app/data/models.dart';
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
      var store = await AppStore.load();
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

      store = await AppStore.load();
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
      final store = await AppStore.load();
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
      final store = await AppStore.load();
      await store.saveProfile(UserProfile(name: 'X'));
      await store.saveRelative(Relative(id: 1, name: 'A', phone: '1'));
      await store.resetEverything();
      expect(store.profile, isNull);
      expect(store.relatives, isEmpty);
    });
  });
}
