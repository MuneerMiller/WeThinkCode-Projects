// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:convert';

import 'package:elderly_app/data/app_store.dart';
import 'package:elderly_app/data/models.dart';
import 'package:elderly_app/security/app_lock.dart';
import 'package:elderly_app/security/crypto.dart';
import 'package:elderly_app/security/lock_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers.dart';

/// A key store that fails, like a browser page without secure storage.
class BrokenKeyStore implements KeyStore {
  @override
  Future<String?> read(String key) => throw StateError('no secure storage');
  @override
  Future<void> write(String key, String value) =>
      throw StateError('no secure storage');
  @override
  Future<void> delete(String key) => throw StateError('no secure storage');
}

Future<Map<String, Object>> rawPrefs() async {
  final p = await SharedPreferences.getInstance();
  return {for (final k in p.getKeys()) k: p.get(k)!};
}

Future<AppStore> storeWithData(MemoryKeyStore keys) async {
  SharedPreferences.setMockInitialValues({});
  final store = await AppStore.load(keys: keys);
  await store.saveProfile(
    UserProfile(name: 'Margaret Smith', allergies: 'Penicillin'),
  );
  await store.saveMedicine(
    Medicine(
      id: store.newId(),
      name: 'Metformin',
      type: MedicineType.tablet,
      times: const [ClockTime(8, 0)],
    ),
  );
  return store;
}

void main() {
  group('Data at rest', () {
    test('health data is stored encrypted and reads back', () async {
      final keys = MemoryKeyStore();
      await storeWithData(keys);
      final raw = await rawPrefs();
      expect(raw['profile'], startsWith('enc1:'));
      expect(raw['medicines'], startsWith('enc1:'));
      final everything = jsonEncode(raw);
      expect(everything, isNot(contains('Penicillin')));
      expect(everything, isNot(contains('Metformin')));

      final again = await AppStore.load(keys: keys);
      expect(again.isEncrypted, isTrue);
      expect(again.profile!.allergies, 'Penicillin');
      expect(again.medicines.single.name, 'Metformin');
    });

    test('data saved before encryption is migrated', () async {
      SharedPreferences.setMockInitialValues({
        'profile': '{"name":"Old Data","allergies":"Latex"}',
        'notes':
            '[{"id":1,"title":"Hi","body":"","priority":"normal",'
            '"createdAt":"2025-01-01T00:00:00.000","updatedAt":"2025-01-01T00:00:00.000"}]',
      });
      final keys = MemoryKeyStore();
      final store = await AppStore.load(keys: keys);
      await store.flush();
      expect(store.profile!.allergies, 'Latex');
      expect(store.notes.single.title, 'Hi');
      final raw = await rawPrefs();
      expect(raw['profile'], startsWith('enc1:'));
      expect(raw['notes'], startsWith('enc1:'));
      expect((await AppStore.load(keys: keys)).profile!.name, 'Old Data');
    });

    test('a corrupted section does not stop the app from opening', () async {
      SharedPreferences.setMockInitialValues({
        'profile': '{"name":"Still Here"}',
        'medicines': 'this is not json',
        'relatives': 'enc1:not-really-encrypted',
      });
      final store = await AppStore.load(keys: MemoryKeyStore());
      expect(store.profile!.name, 'Still Here');
      expect(store.medicines, isEmpty);
      expect(store.relatives, isEmpty);
    });

    test('without secure storage the app still works, unencrypted', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: BrokenKeyStore());
      expect(store.isEncrypted, isFalse);
      expect(store.lock.hasPin, isFalse);
      await store.saveProfile(UserProfile(name: 'Plain'));
      expect(
        (await AppStore.load(keys: BrokenKeyStore())).profile!.name,
        'Plain',
      );
    });

    test('PIN cannot be set without secure storage, and says so', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: BrokenKeyStore());
      await expectLater(store.lock.setPin('2580'), throwsA(anything));
      expect(store.lock.hasPin, isFalse);
      expect(store.lock.locked, isFalse);
    });

    test(
      'video room name is random, long, and replaces old short ones',
      () async {
        SharedPreferences.setMockInitialValues({'callRoomSalt': 'abcd2345'});
        final store = await AppStore.load(keys: MemoryKeyStore());
        final salt = store.callRoomSalt;
        expect(salt, matches(RegExp(r'^[a-z0-9]{16}$')));
        expect(store.callRoomSalt, salt);
      },
    );
  });

  group('Backups', () {
    test('a damaged backup changes nothing and the app still opens', () async {
      final keys = MemoryKeyStore();
      final store = await storeWithData(keys);
      for (final bad in [
        '{"format":"elderly-care-backup","data":{"profile":"not json"}}',
        '{"format":"elderly-care-backup","data":{"profile":"{\\"name\\":\\"X\\"}",'
            '"medicines":"[{\\"id\\":1}]"}}',
        '{"format":"elderly-care-backup","data":{"profile":"{\\"name\\":\\"X\\"}",'
            '"notes":42}}',
      ]) {
        await expectLater(store.importBackup(bad), throwsFormatException);
      }
      expect(store.profile!.name, 'Margaret Smith');
      final reopened = await AppStore.load(keys: keys);
      expect(reopened.profile!.name, 'Margaret Smith');
      expect(reopened.medicines.single.name, 'Metformin');
    });

    test('oversized files are rejected before reading', () async {
      final store = await storeWithData(MemoryKeyStore());
      final huge = 'x' * (AppStore.maxBackupLength + 1);
      await expectLater(store.importBackup(huge), throwsFormatException);
    });

    test(
      'password-protected backup hides contents and needs the password',
      () async {
        final store = await storeWithData(MemoryKeyStore());
        final backup = await store.exportBackup(password: 'correct horse');
        expect(backup, isNot(contains('Penicillin')));
        expect(backup, isNot(contains('Margaret')));

        // Restoring on another phone (different device key).
        SharedPreferences.setMockInitialValues({});
        final other = await AppStore.load(keys: MemoryKeyStore());
        await expectLater(
          other.importBackup(backup),
          throwsA(
            isA<BackupPasswordException>().having(
              (e) => e.wrongPassword,
              'wrong',
              isFalse,
            ),
          ),
        );
        await expectLater(
          other.importBackup(backup, password: 'wrong horse'),
          throwsA(
            isA<BackupPasswordException>().having(
              (e) => e.wrongPassword,
              'wrong',
              isTrue,
            ),
          ),
        );
        expect(other.profile, isNull);
        await other.importBackup(backup, password: 'correct horse');
        expect(other.profile!.allergies, 'Penicillin');
        expect(other.medicines.single.name, 'Metformin');
      },
    );

    test('backups from version 1 still restore', () async {
      SharedPreferences.setMockInitialValues({});
      final store = await AppStore.load(keys: MemoryKeyStore());
      await store.importBackup(
        jsonEncode({
          'format': 'elderly-care-backup',
          'version': 1,
          'data': {
            'onboardingSeen': true,
            'nextId': 5,
            'profile': '{"name":"Version One"}',
          },
        }),
      );
      expect(store.profile!.name, 'Version One');
      expect(store.newId(), 5);
    });
  });

  group('App lock', () {
    late SharedPreferences prefs;
    late MemoryKeyStore keys;
    late AppLock lock;
    var now = DateTime(2026, 1, 1, 12);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      keys = MemoryKeyStore();
      lock = await AppLock.load(prefs, keys, FakeBiometrics());
      now = DateTime(2026, 1, 1, 12);
      lock.now = () => now;
    });

    test('the PIN itself is never stored', () async {
      await lock.setPin('482916');
      final stored = jsonEncode(keys.values) + jsonEncode(await rawPrefs());
      expect(stored, isNot(contains('482916')));
      expect(lock.hasPin, isTrue);
      expect(() => lock.setPin('12'), throwsArgumentError);
      expect(() => lock.setPin('12ab'), throwsArgumentError);
    });

    test('the app starts locked once a PIN is set', () async {
      await lock.setPin('482916');
      final reopened = await AppLock.load(prefs, keys, FakeBiometrics());
      expect(reopened.locked, isTrue);
      expect(await reopened.unlock('482916'), PinResult.ok);
      expect(reopened.locked, isFalse);
    });

    test('wrong guesses are slowed down, even for the right PIN', () async {
      await lock.setPin('482916');
      lock.lockNow();
      for (var i = 1; i < AppLock.freeAttempts; i++) {
        expect(await lock.unlock('000000'), PinResult.wrong);
      }
      expect(await lock.unlock('000000'), PinResult.tooManyAttempts);
      expect(await lock.unlock('482916'), PinResult.tooManyAttempts);
      expect(lock.locked, isTrue);

      now = now.add(const Duration(seconds: 31));
      expect(await lock.unlock('111111'), PinResult.tooManyAttempts);
      // The wait doubles after each further wrong try.
      now = now.add(const Duration(seconds: 59));
      expect(lock.retryAt, isNotNull);
      now = now.add(const Duration(seconds: 2));
      expect(await lock.unlock('482916'), PinResult.ok);
      expect(lock.failedAttempts, 0);
    });

    test('locks again after 2 minutes in the background', () async {
      await lock.setPin('482916');
      lock.appPaused();
      now = now.add(const Duration(seconds: 90));
      lock.appResumed();
      expect(lock.locked, isFalse);
      lock.appPaused();
      now = now.add(const Duration(minutes: 3));
      lock.appResumed();
      expect(lock.locked, isTrue);
    });

    test('turning the lock off needs the current PIN', () async {
      await lock.setPin('482916');
      expect(await lock.removePin('123456'), PinResult.wrong);
      expect(lock.hasPin, isTrue);
      expect(await lock.removePin('482916'), PinResult.ok);
      expect(lock.hasPin, isFalse);
      expect(keys.values.keys, isNot(contains('elderly_care.pin')));
    });
  });

  group('Lock screen', () {
    Future<void> typePin(WidgetTester tester, String pin) async {
      for (final d in pin.split('')) {
        await tester.tap(find.bySemanticsLabel(d));
        await tester.pump();
      }
      await tester.tap(find.bySemanticsLabel('Unlock'));
      await tester.pumpAndSettle();
    }

    testWidgets(
      'set a PIN, lock, reject a wrong PIN, unlock with the right one',
      (tester) async {
        final app = await pumpApp(tester, prefs: signedUp);
        await tester.tap(find.byTooltip('My profile'));
        await tester.pumpAndSettle();
        await tester.tapText('Privacy & security');
        expect(find.text('App lock is off'), findsOneWidget);
        expect(find.text('Encrypted on this device'), findsOneWidget);

        await tester.tapText('Lock with a PIN');
        await tester.enterText(
          find.widgetWithText(TextFormField, 'New PIN'),
          '2580',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Type it again'),
          '2581',
        );
        await tester.tapText('Save');
        expect(find.text('The two do not match'), findsOneWidget);
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Type it again'),
          '2580',
        );
        await tester.tapText('Save');
        expect(find.text('App lock is on'), findsWidgets);

        await tester.tapText('Lock now');
        expect(find.byType(LockScreen), findsOneWidget);
        expect(find.text('Privacy & security'), findsNothing); // app hidden

        await typePin(tester, '1111');
        expect(find.textContaining('That PIN is not right'), findsOneWidget);
        expect(app.store.lock.locked, isTrue);

        await typePin(tester, '2580');
        expect(find.byType(LockScreen), findsNothing);
        expect(
          find.text('Privacy & security'),
          findsOneWidget,
        ); // back where we were
      },
    );

    testWidgets('keyboard cannot reach the hidden app; PIN can be typed', (
      tester,
    ) async {
      final app = await pumpApp(tester, prefs: signedUp);
      await app.store.lock.setPin('2580');
      await tester.tap(find.byTooltip('My profile'));
      await tester.pumpAndSettle();
      await tester.tapText('Privacy & security');
      // Focus a button in the app, then lock.
      final turnOff = find.widgetWithText(TextButton, 'Turn off');
      Focus.of(tester.element(find.text('Turn off'))).requestFocus();
      await tester.pump();
      app.store.lock.lockNow();
      await tester.pumpAndSettle();
      expect(turnOff.hitTestable(), findsNothing);
      expect(
        Focus.of(
          tester.element(find.text('Turn off', skipOffstage: false)),
        ).hasFocus,
        isFalse,
      );

      // Enter must not press the hidden "Turn off" button.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Turn off app lock'), findsNothing);
      expect(app.store.lock.hasPin, isTrue);

      for (final key in [
        LogicalKeyboardKey.digit2,
        LogicalKeyboardKey.digit5,
        LogicalKeyboardKey.digit8,
        LogicalKeyboardKey.digit0,
      ]) {
        await tester.sendKeyEvent(key);
      }
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(app.store.lock.locked, isFalse);
    });

    testWidgets('emergency help and Medical ID work while locked', (
      tester,
    ) async {
      final app = await pumpApp(tester, prefs: signedUp);
      await app.store.saveProfile(app.store.profile!..allergies = 'Penicillin');
      await app.store.lock.setPin('2580');
      app.store.lock.lockNow();
      await tester.pumpAndSettle();

      await tester.tapText('Emergency');
      expect(find.text('Penicillin'), findsOneWidget);
      await tester.tapText('Call 112');
      expect(app.contacts.calls, ['112']);
      await tester.tap(find.bySemanticsLabel('Call Anna'));
      expect(app.contacts.calls, ['112', '082 555 0101']);
      expect(app.store.lock.locked, isTrue);

      // The owner can hide it.
      await app.store.lock.setMedicalIdWhenLocked(false);
      await tester.pumpAndSettle();
      expect(find.text('Penicillin'), findsNothing);
      expect(find.text('Call 112'), findsOneWidget);
    });

    testWidgets('forgot PIN: erasing everything is the only way in', (
      tester,
    ) async {
      final app = await pumpApp(tester, prefs: signedUp);
      await app.store.lock.setPin('2580');
      app.store.lock.lockNow();
      await tester.pumpAndSettle();

      await tester.tapText('Forgot PIN?');
      await tester.tapText('Erase everything and start again');
      expect(app.store.profile, isNotNull); // needs a second tap
      await tester.tapText('Yes, erase everything');
      expect(app.store.profile, isNull);
      expect(app.store.relatives, isEmpty);
      expect(app.store.lock.hasPin, isFalse);
      expect(find.text('Never miss a medicine'), findsOneWidget);
    });

    testWidgets('fingerprint or face unlocks when turned on', (tester) async {
      final app = await pumpApp(tester, prefs: signedUp);
      await app.store.lock.setPin('2580');
      await app.store.lock.setBiometricsEnabled(true);
      app.biometrics.succeeds = false;
      app.store.lock.lockNow();
      await tester.pumpAndSettle();
      expect(app.biometrics.prompts, 1); // asked straight away
      expect(app.store.lock.locked, isTrue);

      app.biometrics.succeeds = true;
      await tester.tapText('Use fingerprint or face');
      expect(app.store.lock.locked, isFalse);
    });

    testWidgets('restoring a password-protected backup asks for the password', (
      tester,
    ) async {
      final app = await pumpApp(tester, prefs: signedUp);
      await tester.tap(find.byTooltip('My profile'));
      await tester.pumpAndSettle();
      await tester.tapText('Back up my data');
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Backup password'),
        'short',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Type it again'),
        'short',
      );
      await tester.tapText('Use password');
      expect(find.text('Use at least 8 characters'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Backup password'),
        'blue river 42',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Type it again'),
        'blue river 42',
      );
      await tester.tapText('Use password');
      final file = app.share.files.single.contents;
      expect(file, isNot(contains('Margaret')));

      app.share.fileToPick = file;
      await tester.tapText('Restore from a backup');
      await tester.tapText('Choose file');
      expect(find.text('Backup password'), findsOneWidget);
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'red river',
      );
      await tester.tapText('Restore');
      expect(
        find.text('That password is not right. Please try again.'),
        findsOneWidget,
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Password'),
        'blue river 42',
      );
      await tester.tapText('Restore');
      expect(find.text('Backup restored'), findsOneWidget);
      expect(app.store.profile!.name, 'Margaret Smith');
    });
  });
}
