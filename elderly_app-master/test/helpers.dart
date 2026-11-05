// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:elderly_app/app_scope.dart';
import 'package:elderly_app/data/app_store.dart';
import 'dart:async';
import 'dart:typed_data';

import 'package:elderly_app/data/models.dart';
import 'package:elderly_app/legal/legal.dart';
import 'package:elderly_app/main.dart';
import 'package:elderly_app/security/app_lock.dart';
import 'package:elderly_app/security/crypto.dart';
import 'package:elderly_app/services/contact_service.dart';
import 'package:elderly_app/services/location_service.dart';
import 'package:elderly_app/services/notification_service.dart';
import 'package:elderly_app/services/reminder_plan.dart';
import 'package:elderly_app/services/share_service.dart';
import 'package:elderly_app/services/speech_service.dart';
import 'package:elderly_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Records what the app asked the phone to do instead of doing it.
class FakeContacts extends ContactService {
  final calls = <String>[];
  final texts = <({List<String> to, String body})>[];
  final urls = <String>[];

  @override
  Future<bool> call(String number) async {
    calls.add(number);
    return true;
  }

  @override
  Future<bool> sms(List<String> numbers, String body) async {
    texts.add((to: numbers, body: body));
    return true;
  }

  @override
  Future<bool> openUrl(String url) async {
    urls.add(url);
    return true;
  }
}

/// Stands in for phone notifications: records what the app schedules and
/// lets tests deliver notification taps.
class FakeNotifications extends NotificationService {
  final _taps = StreamController<DoseResponse>.broadcast();
  final snoozed = <String>[];
  DoseResponse? launch;
  int syncs = 0;
  List<Medicine> lastMedicines = const [];

  void tap(DoseResponse r) => _taps.add(r);

  @override
  Stream<DoseResponse> get responses => _taps.stream;

  @override
  DoseResponse? takeLaunchResponse() {
    final r = launch;
    launch = null;
    return r;
  }

  @override
  Future<void> sync({
    required List<Medicine> medicines,
    required List<Appointment> appointments,
    AppLocalizations? l10n,
  }) async {
    syncs++;
    lastMedicines = [...medicines];
  }

  @override
  Future<void> snooze(
    Medicine m,
    DosePayload dose, {
    Duration after = const Duration(minutes: 10),
  }) async => snoozed.add('${m.name} $dose');
}

class FakeSpeech extends SpeechService {
  final spoken = <String>[];

  @override
  Future<void> speak(String text) async {
    spoken.add(text);
    speaking.value = text;
  }

  @override
  Future<void> stop() async => speaking.value = null;
}

class FakeBiometrics extends Biometrics {
  FakeBiometrics({this.isAvailable = true, this.succeeds = true});
  bool isAvailable;
  bool succeeds;
  int prompts = 0;

  @override
  Future<bool> available() async => isAvailable;

  @override
  Future<bool> authenticate(String reason) async {
    prompts++;
    return succeeds;
  }
}

class FakeShare extends ShareService {
  final sharedTexts = <String>[];
  final files = <({String name, String contents})>[];
  final binaries = <({String name, List<int> bytes, String mimeType})>[];

  /// What [pickBackupFile] returns, as if the user chose that file.
  String? fileToPick;

  @override
  Future<bool> shareText(String text, {String? subject}) async {
    sharedTexts.add(text);
    return true;
  }

  @override
  Future<bool> shareFile(
    String name,
    String contents, {
    String? subject,
  }) async {
    files.add((name: name, contents: contents));
    return true;
  }

  @override
  Future<bool> shareBytes(
    String name,
    Uint8List bytes, {
    required String mimeType,
    String? subject,
  }) async {
    binaries.add((name: name, bytes: bytes, mimeType: mimeType));
    return true;
  }

  @override
  Future<String?> pickBackupFile({String? title}) async => fileToPick;
}

class FakeLocation extends LocationService {
  FakeLocation({this.point = const GeoPoint(-33.9249, 18.4241), this.error});
  final GeoPoint point;
  final LocationException? error;

  @override
  Future<GeoPoint> current() async {
    if (error != null) throw error!;
    return point;
  }
}

class FakeHospitals extends HospitalService {
  FakeHospitals(this.result);
  final List<Hospital> result;
  GeoPoint? askedAbout;

  @override
  Future<List<Hospital>> near(GeoPoint here, {int radiusMeters = 10000}) async {
    askedAbout = here;
    return result;
  }
}

class TestApp {
  TestApp(
    this.store,
    this.contacts,
    this.location,
    this.hospitals,
    this.share,
    this.keys,
    this.biometrics,
    this.speech,
  );
  final FakeSpeech speech;
  final AppStore store;
  final MemoryKeyStore keys;
  final FakeBiometrics biometrics;
  final FakeShare share;
  final FakeContacts contacts;
  final FakeLocation location;
  final FakeHospitals hospitals;
}

/// Starts the real app with fake phone services and in-memory storage.
Future<TestApp> pumpApp(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  FakeLocation? location,
  List<Hospital> hospitals = const [],
  MemoryKeyStore? keys,
  FakeBiometrics? biometrics,
  FakeNotifications? notifications,
  List<Medicine> medicines = const [],
}) async {
  // A phone-sized portrait screen.
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 2.75;
  addTearDown(tester.view.reset);

  SharedPreferences.setMockInitialValues(prefs);
  keys ??= MemoryKeyStore();
  biometrics ??= FakeBiometrics();
  final store = await AppStore.load(keys: keys, biometrics: biometrics);
  for (final m in medicines) {
    await store.saveMedicine(m);
  }
  final app = TestApp(
    store,
    FakeContacts(),
    location ?? FakeLocation(),
    FakeHospitals(hospitals),
    FakeShare(),
    keys,
    biometrics,
    FakeSpeech(),
  );
  await tester.pumpWidget(
    ElderlyApp(
      store: store,
      services: AppServices(
        contacts: app.contacts,
        location: app.location,
        hospitals: app.hospitals,
        sharing: app.share,
        notifications: notifications ?? FakeNotifications(),
        speech: app.speech,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return app;
}

/// Prefs for a user who has already finished setup.
const signedUp = <String, Object>{
  'onboardingSeen': true,
  'profile':
      '{"name":"Margaret Smith","phone":"0821234567","emergencyNumber":"112"}',
  'relatives':
      '[{"id":1,"name":"Anna","phone":"082 555 0101","relationship":"Daughter"},'
      '{"id":2,"name":"Ben","phone":"083 555 0202","relationship":"Son"}]',
  'nextId': 3,
  'legal.version': LegalInfo.version,
  'legal.acceptedAt': '2026-11-01T09:00:00.000',
};

extension Driver on WidgetTester {
  Future<void> tapText(String text) async {
    // Prefer an on-screen match (e.g. a dialog button over the page behind it),
    // otherwise scroll the first match into view.
    var finder = find.text(text).hitTestable();
    if (finder.evaluate().isEmpty) {
      finder = find.text(text);
      await centre(finder.first);
      if (finder.hitTestable().evaluate().isEmpty) {
        // Covered by a message: wait for it to go, as a person would.
        await pump(const Duration(seconds: 5));
        await pumpAndSettle();
      }
    }
    await tap(finder.first);
    await pumpAndSettle();
  }

  /// Scrolls [finder] to the middle of the screen, clear of snack bars and
  /// floating buttons.
  Future<void> centre(Finder finder) async {
    await Scrollable.ensureVisible(element(finder), alignment: 0.5);
    await pumpAndSettle();
  }

  Future<void> enter(String label, String value) async {
    final field = find.widgetWithText(TextFormField, label);
    await centre(field.first);
    await enterText(field.first, value);
    await pump();
  }

  Future<void> back() async {
    await pageBack();
    await pumpAndSettle();
  }
}
