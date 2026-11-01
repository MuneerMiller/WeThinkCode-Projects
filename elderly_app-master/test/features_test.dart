import 'package:elderly_app/data/models.dart';
import 'package:elderly_app/legal/legal.dart';
import 'package:elderly_app/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets('first run: intro, setup, then home', (tester) async {
    final app = await pumpApp(tester);

    expect(find.text('Never miss a medicine'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await tester.tapText('Next');
    }
    expect(find.text('Family is one tap away'), findsOneWidget);
    await tester.tapText('Get started');

    expect(find.text('Welcome to Elderly Care'), findsOneWidget);
    await tester.tapText('Continue');
    expect(find.text('Please enter your name'), findsOneWidget);

    await tester.enter('Your name', 'Margaret Smith');
    await tester.enter('Their name', 'Anna');
    await tester.tapText('Continue');
    expect(find.text('Please enter their phone number'), findsOneWidget);
    await tester.enter('Their phone number', '082 555 0101');
    await tester.tapText('Continue');
    expect(find.text('Please tick the box to continue.'), findsOneWidget);
    expect(app.store.profile, isNull);
    await tester.tapText(
      'I agree to the Terms of Use, and I have read the Medical disclaimer '
      'and the Privacy policy',
    );
    await tester.tapText('Continue');
    expect(app.store.legalAcceptedVersion, LegalInfo.version);

    expect(find.textContaining(', Margaret'), findsOneWidget);
    expect(find.text('I need help'), findsOneWidget);
    expect(app.store.relatives.single.name, 'Anna');
    for (final label in [
      'Medicines',
      'Appointments',
      'Health tracker',
      'My family',
      'Hospitals nearby',
      'Video call',
      'Documents',
      'Notes',
    ]) {
      expect(find.text(label), findsOneWidget, reason: label);
    }
  });

  testWidgets('medicines: add, see on schedule, confirm a dose, edit, delete', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Medicines');
    expect(find.text('No medicines yet'), findsOneWidget);

    await tester.tapText('Add medicine');
    await tester.enter('Medicine name', 'Metformin');
    await tester.enter('How much (optional)', '500 mg');
    await tester.tapText('Capsule');
    await tester.tapText('3 times');
    expect(find.text('Dose 3'), findsOneWidget);
    await tester.tapText('Twice');
    expect(find.text('Dose 3'), findsNothing);
    await tester.tapText('Save reminder');

    final m = app.store.medicines.single;
    expect(m.name, 'Metformin');
    expect(m.type, MedicineType.capsule);
    expect(m.times, const [ClockTime(8, 0), ClockTime(14, 0)]);
    expect(find.text("Today's schedule"), findsOneWidget);
    expect(find.textContaining('500 mg · 2× a day'), findsOneWidget);

    // Open the 08:00 dose and say it was taken.
    await tester.tap(find.text('Metformin').first);
    await tester.pumpAndSettle();
    expect(find.text('Did you take your Metformin?'), findsOneWidget);
    await tester.tapText('Yes, I took it');
    expect(m.recordFor(DateTime.now(), const ClockTime(8, 0))?.taken, isTrue);
    expect(find.textContaining('Taken'), findsWidgets);

    // Edit then delete.
    await tester.tap(find.byIcon(Icons.edit_rounded));
    await tester.pumpAndSettle();
    await tester.enter('Medicine name', 'Metformin XR');
    await tester.tapText('Save changes');
    expect(app.store.medicines.single.name, 'Metformin XR');

    await tester.tap(find.byIcon(Icons.edit_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Delete medicine'));
    await tester.pumpAndSettle();
    await tester.tapText('Delete');
    expect(app.store.medicines, isEmpty);
    expect(find.text('No medicines yet'), findsOneWidget);
  });

  testWidgets('missed dose offers to text the family', (tester) async {
    final app = await pumpApp(tester, prefs: signedUp);
    // A dose that is due right now.
    final now = DateTime.now();
    await app.store.saveMedicine(
      Medicine(
        id: 50,
        name: 'Aspirin',
        type: MedicineType.tablet,
        times: [ClockTime(now.hour, now.minute)],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Time for Aspirin'), findsOneWidget);
    await tester.tapText('Check');
    await tester.tapText('No, not yet');
    expect(find.text('Let your family know?'), findsOneWidget);
    await tester.tapText('Send text');

    final text = app.contacts.texts.single;
    expect(text.to, ['082 555 0101', '083 555 0202']);
    expect(text.body, contains('Margaret did not take Aspirin'));
    expect(
      app.store.medicines.single.dosesOn(now).single.status,
      DoseStatus.skipped,
    );
  });

  testWidgets('appointments: add, mark attended, delete', (tester) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Appointments');
    expect(find.text('No upcoming appointments'), findsOneWidget);

    await tester.tapText('Add appointment');
    await tester.tapText('Save appointment');
    expect(find.text("Please enter the doctor's name"), findsOneWidget);
    await tester.enter("Doctor's name", 'Dr. Naidoo');
    await tester.enter('Type of doctor (optional)', 'Cardiologist');
    await tester.enter('Where (optional)', 'Groote Schuur');
    await tester.tapText('Save appointment');

    expect(find.text('Dr. Naidoo'), findsOneWidget);
    expect(find.text('Upcoming (1)'), findsOneWidget);
    final a = app.store.appointments.single;
    expect(a.dateTime.isAfter(DateTime.now()), isTrue);

    // Shows on the home screen too.
    await tester.back();
    expect(find.text('Dr. Naidoo'), findsOneWidget);
    await tester.tapText('Appointments');

    await tester.tapText('Dr. Naidoo');
    await tester.tapText('I went to this appointment');
    await tester.tapText('Save changes');
    expect(find.text('Past (1)'), findsOneWidget);
    await tester.tapText('Past (1)');
    expect(find.text('Attended'), findsOneWidget);

    await tester.tapText('Dr. Naidoo');
    await tester.tap(find.byTooltip('Delete appointment'));
    await tester.pumpAndSettle();
    await tester.tapText('Delete');
    expect(app.store.appointments, isEmpty);
  });

  testWidgets('health tracker: validate, record readings, chart, delete', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Health tracker');
    expect(find.text('No readings yet'), findsNWidgets(4));

    await tester.tapText('Blood pressure');
    expect(
      find.text('Add your first reading to start tracking.'),
      findsOneWidget,
    );

    await tester.tapText('Add reading');
    await tester.enter('Systolic (top number)', '400');
    await tester.tapText('Save reading');
    expect(find.text('Should be between 60 and 250'), findsOneWidget);
    expect(find.text('Please enter diastolic (bottom number)'), findsOneWidget);

    await tester.enter('Systolic (top number)', '128');
    await tester.enter('Diastolic (bottom number)', '82');
    await tester.enter('Pulse', '71');
    await tester.tapText('Save reading');
    expect(find.text('128/82 mmHg · 71 bpm'), findsOneWidget);
    expect(find.text('Add one more reading to see a chart.'), findsOneWidget);

    await tester.tapText('Add reading');
    await tester.enter('Systolic (top number)', '121');
    await tester.enter('Diastolic (bottom number)', '79');
    await tester.enter('Pulse', '68');
    await tester.tapText('Save reading');
    expect(
      find.bySemanticsLabel(
        RegExp('Blood pressure chart of the last 2 readings'),
      ),
      findsOneWidget,
    );
    expect(app.store.entriesFor(TrackerType.bloodPressure), hasLength(2));

    await tester.tap(find.byTooltip('Delete reading').first);
    await tester.pumpAndSettle();
    await tester.tapText('Delete');
    expect(app.store.entriesFor(TrackerType.bloodPressure), hasLength(1));

    // Each tracker type has its own form.
    await tester.back();
    expect(find.textContaining('128/82 mmHg · 71 bpm'), findsOneWidget);
    await tester.tapText('Sleep');
    await tester.tapText('Add reading');
    await tester.enter('Hours slept', '7');
    await tester.tapText('Save reading');
    expect(find.text('7 h 0 min'), findsOneWidget);
  });

  testWidgets('family: add, call, text, edit, remove', (tester) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('My family');
    expect(find.text('Anna'), findsOneWidget);

    await tester.tapText('Add person');
    await tester.enter('Name', 'Carol');
    await tester.enter('Phone number', '12');
    await tester.tapText('Save');
    expect(find.text('That number looks too short'), findsOneWidget);
    await tester.enter('Phone number', '084 555 0303');
    await tester.enter('Relationship (optional)', 'Neighbour');
    await tester.tapText('Save');
    expect(find.text('Neighbour · 084 555 0303'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Call').at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Text').first);
    await tester.pumpAndSettle();
    expect(app.contacts.calls, ['084 555 0303']);
    expect(app.contacts.texts.single.to, ['082 555 0101']);

    await tester.tap(find.byTooltip('Edit Carol'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Remove family member'));
    await tester.pumpAndSettle();
    await tester.tapText('Remove');
    expect(app.store.relatives.map((r) => r.name), ['Anna', 'Ben']);
  });

  testWidgets('SOS: call emergency services or alert family with location', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);

    await tester.tapText('I need help');
    expect(find.text('How can we help?'), findsOneWidget);
    expect(find.text('Call Anna'), findsOneWidget);
    await tester.tapText('Call emergency services');
    expect(app.contacts.calls, ['112']);

    await tester.tapText('I need help');
    await tester.tapText('Alert my family');
    final text = app.contacts.texts.single;
    expect(text.to, ['082 555 0101', '083 555 0202']);
    expect(text.body, contains('Margaret needs help'));
    expect(
      text.body,
      contains(
        'https://www.google.com/maps/search/?api=1&query=-33.924900,18.424100',
      ),
    );
  });

  testWidgets('SOS still alerts family when location is unavailable', (
    tester,
  ) async {
    final app = await pumpApp(
      tester,
      prefs: signedUp,
      location: FakeLocation(
        error: const LocationException(LocationProblem.switchedOff),
      ),
    );
    await tester.tapText('I need help');
    await tester.tapText('Alert my family');
    expect(app.contacts.texts.single.body, isNot(contains('maps')));
    expect(find.textContaining('Sending without location'), findsOneWidget);
  });

  testWidgets('hospitals: lists nearby places with directions and call', (
    tester,
  ) async {
    final app = await pumpApp(
      tester,
      prefs: signedUp,
      hospitals: const [
        Hospital(
          name: 'Groote Schuur Hospital',
          location: GeoPoint(-33.9411, 18.4654),
          distanceKm: 4.2,
          phone: '021 404 9111',
          address: 'Main Road, Observatory',
        ),
        Hospital(
          name: 'City Clinic',
          location: GeoPoint(-33.92, 18.42),
          distanceKm: 0.35,
        ),
      ],
    );
    await tester.tapText('Hospitals nearby');

    expect(app.hospitals.askedAbout?.lat, -33.9249);
    expect(find.text('2 places within 10 km'), findsOneWidget);
    expect(find.text('4.2 km away'), findsOneWidget);
    expect(find.text('350 m away'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Directions').first);
    await tester.tap(find.widgetWithText(OutlinedButton, 'Call').first);
    await tester.tapText('Emergency? Call 112');
    expect(
      app.contacts.urls.single,
      'https://www.google.com/maps/dir/?api=1&destination=-33.941100,18.465400',
    );
    expect(app.contacts.calls, ['021 404 9111', '112']);
  });

  testWidgets('hospitals: explains location problems and can retry', (
    tester,
  ) async {
    await pumpApp(
      tester,
      prefs: signedUp,
      location: FakeLocation(
        error: const LocationException(LocationProblem.noPermission),
      ),
    );
    await tester.tapText('Hospitals nearby');
    expect(find.text('Could not search'), findsOneWidget);
    expect(
      find.text('Elderly Care needs permission to see your location.'),
      findsOneWidget,
    );
    await tester.tapText('Try again');
    expect(find.text('Could not search'), findsOneWidget);
  });

  testWidgets('video call: texts the family the link and opens the call', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Video call');
    await tester.tapText('Voice only (no camera)');
    await tester.tapText('Start video call');

    final url = app.contacts.urls.single;
    // Named only by random characters: nothing personal in the address.
    expect(
      url,
      matches(RegExp(r'^https://meet\.jit\.si/ElderlyCare-[a-z0-9]{16}#')),
    );
    expect(url.split('#').first, isNot(contains('margaret')));
    expect(url, contains('config.startAudioOnly=true'));
    final room = url.split('#').first;
    expect(app.contacts.texts.single.body, contains(room));

    // The same room is used next time so family can bookmark it.
    await tester.tapText('Start video call');
    expect(app.contacts.urls.last.split('#').first, room);
  });

  testWidgets('notes: add with priority, sorted, edit, delete', (tester) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Notes');
    expect(find.text('No notes yet'), findsOneWidget);

    await tester.tapText('New note');
    await tester.enter('Title', 'Buy milk');
    await tester.tapText('Save note');
    await tester.tapText('New note');
    await tester.enter('Title', 'Ask doctor about knee');
    await tester.enter('Note', 'Pain when climbing stairs');
    await tester.tapText('Important');
    await tester.tapText('Save note');

    expect(app.store.sortedNotes.map((n) => n.title), [
      'Ask doctor about knee',
      'Buy milk',
    ]);
    final firstY = tester.getTopLeft(find.text('Ask doctor about knee')).dy;
    expect(firstY, lessThan(tester.getTopLeft(find.text('Buy milk')).dy));

    await tester.tapText('Buy milk');
    await tester.enter('Title', 'Buy milk and bread');
    await tester.tapText('Save note');
    expect(find.text('Buy milk and bread'), findsOneWidget);

    await tester.tapText('Buy milk and bread');
    await tester.tap(find.byTooltip('Delete note'));
    await tester.pumpAndSettle();
    await tester.tapText('Delete');
    expect(app.store.notes.single.title, 'Ask doctor about knee');
  });

  testWidgets('documents: saved photos can be searched, viewed and deleted', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    // A 1×1 PNG, as the image picker would return.
    const png =
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==';
    for (final (id, name) in [
      (10, 'Blood test March'),
      (11, 'Medical aid card'),
    ]) {
      await app.store.saveDocument(
        HealthDocument(
          id: id,
          name: name,
          imageBase64: png,
          addedAt: DateTime.now(),
        ),
      );
    }
    await tester.tapText('Documents');
    expect(find.text('Blood test March'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'aid');
    await tester.pumpAndSettle();
    expect(find.text('Blood test March'), findsNothing);
    expect(find.text('Medical aid card'), findsOneWidget);

    await tester.tapText('Medical aid card');
    expect(find.byType(InteractiveViewer), findsOneWidget);
    await tester.tap(find.byTooltip('Delete document'));
    await tester.pumpAndSettle();
    await tester.tapText('Delete');
    expect(app.store.documents.map((d) => d.name), ['Blood test March']);
  });

  testWidgets('documents: naming screen requires a name', (tester) async {
    await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Documents');
    await tester.tapText('Add document');
    expect(find.text('Take a photo'), findsOneWidget);
    expect(find.text('Choose from gallery'), findsOneWidget);
  });

  testWidgets('profile: edit details, change emergency number, erase data', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    expect(find.text('Margaret Smith'), findsOneWidget);

    await tester.tapText('Edit');
    await tester.enter('Blood group', 'O+');
    await tester.enter('Allergies', 'Penicillin');
    await tester.enter('Emergency number', '10177');
    await tester.tapText('Save profile');
    expect(find.text('O+'), findsOneWidget);
    expect(find.text('Penicillin'), findsOneWidget);
    expect(app.store.profile!.emergencyNumber, '10177');

    await tester.tapText('Erase all my data');
    await tester.tapText('Erase');
    expect(app.store.profile, isNull);
    expect(find.text('Never miss a medicine'), findsOneWidget);
  });

  testWidgets('home adapts to large system text without overflowing', (
    tester,
  ) async {
    await pumpApp(tester, prefs: signedUp);
    tester.platformDispatcher.textScaleFactorTestValue = 1.6;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView).first, const Offset(0, -1500));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('medical ID: reachable from SOS, shows key facts, calls family', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await app.store.saveProfile(
      app.store.profile!
        ..bloodGroup = 'O+'
        ..allergies = 'Penicillin'
        ..conditions = 'Type 2 diabetes',
    );
    await app.store.saveMedicine(
      Medicine(
        id: 60,
        name: 'Metformin',
        dosage: '500 mg',
        type: MedicineType.tablet,
        times: const [ClockTime(8, 0)],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapText('I need help');
    await tester.tapText('Show my medical ID');
    expect(find.text('Medical ID'), findsOneWidget);
    for (final t in [
      'O+',
      'Penicillin',
      'Type 2 diabetes',
      'Metformin 500 mg',
      'Anna',
    ]) {
      expect(find.text(t), findsOneWidget, reason: t);
    }
    await tester.tap(find.bySemanticsLabel('Call Anna'));
    expect(app.contacts.calls, ['082 555 0101']);
  });

  testWidgets('text size setting enlarges the whole app and is remembered', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    double greetingSize() =>
        tester.getSize(find.textContaining('Margaret').first).height;
    final before = greetingSize();

    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    await tester.tapText('Extra large');
    expect(app.store.textScale, 1.3);
    await tester.back();
    expect(greetingSize(), greaterThan(before * 1.2));
    expect(tester.takeException(), isNull);
  });

  testWidgets('backup: export to a file, then restore it on a fresh install', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    await tester.tapText('Back up my data');
    expect(find.text('Protect your backup?'), findsOneWidget);
    await tester.tapText('No password');
    final file = app.share.files.single;
    expect(
      file.name,
      matches(RegExp(r'^elderly-care-backup-\d{4}-\d\d-\d\d\.json$')),
    );
    expect(file.contents, contains('Margaret Smith'));

    // Start over, then restore.
    await tester.tapText('Erase all my data');
    await tester.tapText('Erase');
    expect(app.store.profile, isNull);
    await app.store.markOnboardingSeen();
    await app.store.saveProfile(UserProfile(name: 'Temporary'));
    // Erasing also cleared the accepted terms, so the app asks again.
    await tester.pumpAndSettle();
    expect(find.text('Please review our terms'), findsOneWidget);
    await app.store.acceptLegal(LegalInfo.version);
    await tester.pumpAndSettle();

    app.share.fileToPick = 'this is not a backup';
    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    await tester.tapText('Restore from a backup');
    await tester.tapText('Choose file');
    expect(
      find.text('This file is not an Elderly Care backup.'),
      findsOneWidget,
    );
    expect(app.store.profile!.name, 'Temporary');

    app.share.fileToPick = file.contents;
    await tester.tapText('Restore from a backup');
    await tester.tapText('Choose file');
    expect(app.store.profile!.name, 'Margaret Smith');
    expect(app.store.relatives, hasLength(2));
    expect(find.textContaining(', Margaret'), findsOneWidget); // back on home
  });

  testWidgets('medicine supply: counts down when taken and warns on home', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Medicines');
    await tester.tapText('Add medicine');
    await tester.enter('Medicine name', 'Amlodipine');
    await tester.enter('Doses left in the pack (optional)', 'lots');
    await tester.tapText('Save reminder');
    expect(find.text('Please enter a whole number'), findsOneWidget);
    await tester.enter('Doses left in the pack (optional)', '4');
    await tester.tapText('Save reminder');
    expect(find.text('4 doses left (about 4 days)'), findsOneWidget);

    // Take today's 8:00 dose.
    await tester.tap(find.text('Amlodipine').first);
    await tester.pumpAndSettle();
    await tester.tapText('Yes, I took it');
    final m = app.store.medicines.single;
    expect(m.supply, 3);
    expect(find.text('Only 3 doses left – time to refill'), findsOneWidget);
    expect(find.text('Last 7 days: 1 of 1 doses taken'), findsOneWidget);

    await tester.back();
    expect(find.text('Refill Amlodipine soon'), findsOneWidget);
  });

  testWidgets('health tracker: share a summary with the doctor', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await app.store.saveTrackerEntry(
      TrackerEntry(
        id: 70,
        type: TrackerType.bloodSugar,
        at: DateTime.now().subtract(const Duration(days: 1)),
        values: {'glucose': 105},
      ),
    );
    await tester.tapText('Health tracker');
    await tester.tapText('Share');
    await tester.tapText('As a message');
    final text = app.share.sharedTexts.single;
    expect(text, contains('Health summary for Margaret Smith'));
    expect(text, contains('105 mg/dL'));
  });

  testWidgets('read aloud: today, a dose check and the Medical ID', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    final now = DateTime.now();
    await app.store.saveProfile(app.store.profile!..allergies = 'Penicillin');
    await app.store.saveMedicine(
      Medicine(
        id: 80,
        name: 'Aspirin',
        dosage: '1 tablet',
        type: MedicineType.tablet,
        times: [ClockTime(now.hour, now.minute)],
      ),
    );
    await tester.pumpAndSettle();

    await tester.tapText('Read aloud');
    expect(app.speech.spoken.last, contains(', Margaret.'));
    expect(
      app.speech.spoken.last,
      contains('It is time for Aspirin, 1 tablet,'),
    );
    expect(find.text('Stop reading'), findsOneWidget);
    await tester.tapText('Stop reading');
    expect(find.text('Stop reading'), findsNothing);

    await tester.tapText('Check');
    await tester.tapText('Read aloud');
    expect(
      app.speech.spoken.last,
      startsWith('Did you take your Aspirin? 1 tablet. Today at'),
    );
    await tester.back();

    await tester.tapText('I need help');
    await tester.tapText('Show my medical ID');
    await tester.tapText('Read aloud');
    final id = app.speech.spoken.last;
    expect(id, contains('Medical ID for Margaret Smith.'));
    expect(id, contains('Allergies: Penicillin.'));
    expect(id, contains('Medicines: Aspirin 1 tablet.'));
    expect(
      id,
      contains('Emergency contact: Anna, Daughter, 0 8 2 5 5 5 0 1 0 1.'),
    );
  });

  testWidgets('health tracker: share a PDF summary with the doctor', (
    tester,
  ) async {
    final app = await pumpApp(tester, prefs: signedUp);
    await app.store.saveTrackerEntry(
      TrackerEntry(
        id: 71,
        type: TrackerType.bloodPressure,
        at: DateTime.now().subtract(const Duration(hours: 3)),
        values: {'systolic': 131, 'diastolic': 84, 'pulse': 72},
      ),
    );
    await tester.tapText('Health tracker');
    await tester.tapText('Share');
    await tester.tapText('As a PDF document');
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(seconds: 2)),
    );
    await tester.pumpAndSettle();
    final pdf = app.share.binaries.single;
    expect(pdf.mimeType, 'application/pdf');
    expect(pdf.name, matches(RegExp(r'^health-summary-\d{4}-\d\d-\d\d\.pdf$')));
    expect(String.fromCharCodes(pdf.bytes.take(5)), '%PDF-');
  });

  testWidgets('privacy policy opens from setup and from Privacy & security', (
    tester,
  ) async {
    await pumpApp(tester, prefs: {'onboardingSeen': true});
    await tester.tapText('Read the privacy policy');
    expect(find.text('Privacy policy'), findsWidgets);
    expect(find.text('The short version'), findsOneWidget);
    await tester.back();

    await tester.enter('Your name', 'Margaret Smith');
    await tester.tapText(
      'I agree to the Terms of Use, and I have read the Medical disclaimer '
      'and the Privacy policy',
    );
    await tester.tapText('Continue');
    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    await tester.tapText('Privacy & security');
    await tester.tapText('Read the full privacy policy');
    await tester.drag(find.byType(ListView).last, const Offset(0, -20000));
    await tester.pumpAndSettle();
    expect(find.text('15. Changes to this policy'), findsOneWidget);
  });
}
