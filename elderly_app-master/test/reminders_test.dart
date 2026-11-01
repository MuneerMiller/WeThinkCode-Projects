import 'dart:ui' show Locale;

import 'package:elderly_app/l10n/l10n.dart';
import 'package:elderly_app/data/models.dart';
import 'package:elderly_app/services/notification_service.dart';
import 'package:elderly_app/services/reminder_plan.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

Medicine metformin({DateTime? addedOn}) => Medicine(
  id: 7,
  name: 'Metformin',
  dosage: '500 mg',
  type: MedicineType.tablet,
  times: const [ClockTime(20, 0), ClockTime(8, 0)],
  addedOn: addedOn ?? DateTime(2026, 3, 1),
);

final en = lookupAppLocalizations(const Locale('en'));

void main() {
  group('Reminder plan', () {
    final now = DateTime(2026, 3, 10, 9, 30);

    test('each dose time repeats daily from its next occurrence', () {
      final plan = ReminderPlan.build(
        l10n: en,
        medicines: [metformin()],
        appointments: const [],
        now: now,
      );
      final daily = plan.where((r) => r.daily).toList();
      expect(daily.map((r) => r.at), [
        DateTime(2026, 3, 11, 8), // 8:00 has passed today
        DateTime(2026, 3, 10, 20),
      ]);
      expect(daily.first.title, 'Time for Metformin');
      expect(daily.first.body, contains('500 mg'));
      expect(daily.first.payload, 'dose:7:08:00');
      expect(daily.map((r) => r.id).toSet(), hasLength(2));
    });

    test('unanswered doses get a follow-up an hour later, for a week', () {
      final m = metformin();
      var plan = ReminderPlan.build(
        l10n: en,
        medicines: [m],
        appointments: const [],
        now: now,
      );
      var followUps = plan
          .where((r) => r.kind == ReminderKind.followUp)
          .toList();
      // Today 8:00's follow-up (9:00) has passed; today 20:00 + 6 more days × 2.
      expect(followUps, hasLength(13));
      expect(followUps.map((r) => r.at), contains(DateTime(2026, 3, 10, 21)));
      expect(followUps.first.title, 'Did you take your Metformin?');

      // Answering tonight's dose removes its follow-up.
      m.record(DateTime(2026, 3, 10), const ClockTime(20, 0), true);
      plan = ReminderPlan.build(
        l10n: en,
        medicines: [m],
        appointments: const [],
        now: now,
      );
      followUps = plan.where((r) => r.kind == ReminderKind.followUp).toList();
      expect(followUps, hasLength(12));
      expect(
        followUps.map((r) => r.at),
        isNot(contains(DateTime(2026, 3, 10, 21))),
      );
    });

    test('no follow-ups for doses before the medicine was added', () {
      final plan = ReminderPlan.build(
        l10n: en,
        medicines: [metformin(addedOn: DateTime(2026, 3, 10, 21))],
        appointments: const [],
        now: now,
      );
      expect(
        plan
            .where((r) => r.kind == ReminderKind.followUp)
            .map((r) => r.at)
            .where((t) => t.day == 10),
        isEmpty,
      );
    });

    test('appointments are reminded an hour before, unless past or done', () {
      final plan = ReminderPlan.build(
        l10n: en,
        medicines: const [],
        appointments: [
          Appointment(
            id: 1,
            doctor: 'Dr. Naidoo',
            place: 'Groote Schuur',
            dateTime: DateTime(2026, 3, 11, 10),
          ),
          Appointment(
            id: 2,
            doctor: 'Past',
            dateTime: DateTime(2026, 3, 10, 10),
          ),
          Appointment(
            id: 3,
            doctor: 'Done',
            dateTime: DateTime(2026, 3, 12, 10),
            done: true,
          ),
        ],
        now: now,
      );
      expect(plan.single.at, DateTime(2026, 3, 11, 9));
      expect(plan.single.body, 'Dr. Naidoo · Groote Schuur');
    });

    test('ids never collide across many medicines and kinds', () {
      final medicines = [
        for (var i = 1; i <= 50; i++)
          Medicine(
            id: i,
            name: 'M$i',
            type: MedicineType.tablet,
            times: const [ClockTime(7, 0), ClockTime(13, 0), ClockTime(22, 0)],
            addedOn: DateTime(2026),
          ),
      ];
      final plan = ReminderPlan.build(
        l10n: en,
        medicines: medicines,
        appointments: [
          for (var i = 1; i <= 50; i++)
            Appointment(
              id: i,
              doctor: 'D',
              dateTime: DateTime(2026, 4, i % 28 + 1),
            ),
        ],
        now: now,
      );
      final ids = plan.map((r) => r.id).toList();
      expect(ids.toSet().length, ids.length);
      expect(ids.every((id) => id > 0 && id < 0x7fffffff), isTrue);
      expect(ids.any(ReminderPlan.isSnooze), isFalse);
    });

    test('dose payloads round-trip and reject junk', () {
      final p = DosePayload.parse('dose:7:20:00')!;
      expect(p.medicineId, 7);
      expect(p.slot, const ClockTime(20, 0));
      for (final bad in [
        null,
        '',
        'dose:x:20:00',
        'dose:7:25:00',
        'other:7:20:00',
      ]) {
        expect(DosePayload.parse(bad), isNull, reason: bad);
      }
      // A 22:00 dose answered at 00:30 belongs to the day before.
      expect(
        const DosePayload(
          1,
          ClockTime(22, 0),
        ).dayFor(DateTime(2026, 3, 11, 0, 30)),
        DateTime(2026, 3, 10, 22),
      );
      expect(
        const DosePayload(1, ClockTime(8, 0)).dayFor(DateTime(2026, 3, 11, 9)),
        DateTime(2026, 3, 11, 8),
      );
    });
  });

  group('Notification buttons', () {
    Future<(TestApp, FakeNotifications)> start(
      WidgetTester tester, {
      DoseResponse? launchedFrom,
    }) async {
      final notifications = FakeNotifications()..launch = launchedFrom;
      final app = await pumpApp(
        tester,
        prefs: signedUp,
        notifications: notifications,
        medicines: [metformin()],
      );
      return (app, notifications);
    }

    DoseResponse tap(DoseAction action) =>
        DoseResponse(action, DosePayload.parse('dose:7:08:00')!);

    Medicine stored(TestApp app) => app.store.medicines.single;

    testWidgets('"Taken" records the dose and confirms', (tester) async {
      final (app, notifications) = await start(tester);
      notifications.tap(tap(DoseAction.taken));
      await tester.pumpAndSettle();
      expect(
        stored(app).recordFor(DateTime.now(), const ClockTime(8, 0))?.taken,
        isTrue,
      );
      expect(
        find.text('Metformin recorded as taken. Well done!'),
        findsOneWidget,
      );
    });

    testWidgets('"In 10 min" asks for another reminder only', (tester) async {
      final (app, notifications) = await start(tester);
      notifications.tap(tap(DoseAction.snooze));
      await tester.pumpAndSettle();
      expect(notifications.snoozed, ['Metformin dose:7:08:00']);
      expect(
        stored(app).recordFor(DateTime.now(), const ClockTime(8, 0)),
        isNull,
      );
      expect(find.textContaining('again in 10 minutes'), findsOneWidget);
    });

    testWidgets('"Not yet" and tapping the reminder open the dose check', (
      tester,
    ) async {
      final (_, notifications) = await start(tester);
      notifications.tap(tap(DoseAction.notYet));
      await tester.pumpAndSettle();
      expect(find.text('Did you take your Metformin?'), findsOneWidget);
    });

    testWidgets('opening the app from a reminder goes to that dose', (
      tester,
    ) async {
      await start(tester, launchedFrom: tap(DoseAction.open));
      expect(find.text('Did you take your Metformin?'), findsOneWidget);
    });

    testWidgets('reminders are re-synced when data changes', (tester) async {
      final (app, notifications) = await start(tester);
      final before = notifications.syncs;
      await app.store.recordDose(
        stored(app),
        DateTime.now(),
        const ClockTime(8, 0),
        true,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(notifications.syncs, greaterThan(before));
      expect(notifications.lastMedicines.single.name, 'Metformin');
    });
  });
}
