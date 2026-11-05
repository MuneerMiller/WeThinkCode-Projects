// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart' show SecretKeyData;
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'crypto.dart';

/// Fingerprint / face unlock, where the device has it.
class Biometrics {
  const Biometrics();

  Future<bool> available() async => false;
  Future<bool> authenticate(String reason) async => false;
}

class DeviceBiometrics extends Biometrics {
  const DeviceBiometrics();

  static final _auth = LocalAuthentication();

  @override
  Future<bool> available() async {
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported() &&
          (await _auth.getAvailableBiometrics()).isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      return await _auth.authenticate(
        localizedReason: reason,
        biometricOnly: true,
      );
    } catch (_) {
      return false;
    }
  }
}

enum PinResult { ok, wrong, tooManyAttempts }

/// Optional PIN (and fingerprint/face) lock for the app.
///
/// The PIN is never stored: only a salted PBKDF2 hash, kept in secure key
/// storage. After 5 wrong tries each further try is delayed, doubling up
/// to 15 minutes.
class AppLock extends ChangeNotifier {
  AppLock._(this._prefs, this._keys, this.biometrics);

  static Future<AppLock> load(
    SharedPreferences prefs,
    KeyStore keys,
    Biometrics biometrics,
  ) async {
    final lock = AppLock._(prefs, keys, biometrics);
    try {
      lock._pin = await keys.read(_pinKey);
    } catch (_) {
      lock._pin = null;
    }
    lock.locked = lock.hasPin;
    return lock;
  }

  static const _pinKey = 'elderly_care.pin';
  static const pinRounds = 120000;
  static const freeAttempts = 5;

  /// Lock again after the app has been in the background this long.
  static const relockAfter = Duration(minutes: 2);

  final SharedPreferences _prefs;
  final KeyStore _keys;
  final Biometrics biometrics;
  String? _pin;

  /// Clock; tests replace it to skip waiting.
  DateTime Function() now = DateTime.now;

  bool locked = false;
  DateTime? _backgroundedAt;

  bool get hasPin => _pin != null;

  bool get biometricsEnabled => _prefs.getBool('lock.biometrics') ?? false;

  /// Whether the Medical ID and emergency call can be reached while locked.
  bool get medicalIdWhenLocked => _prefs.getBool('lock.medicalId') ?? true;

  int get failedAttempts => _prefs.getInt('lock.failed') ?? 0;

  /// While set and in the future, no PIN tries are accepted.
  DateTime? get retryAt {
    final ms = _prefs.getInt('lock.retryAt');
    if (ms == null) return null;
    final t = DateTime.fromMillisecondsSinceEpoch(ms);
    return t.isAfter(now()) ? t : null;
  }

  static bool isValidPin(String pin) => RegExp(r'^\d{4,8}$').hasMatch(pin);

  Future<void> setPin(String pin) async {
    if (!isValidPin(pin)) throw ArgumentError('PIN must be 4–8 digits');
    final salt = SecretKeyData.random(length: 16).bytes;
    final hash = await PasswordCrypto.hashPin(pin, salt, pinRounds);
    final record = jsonEncode({
      'salt': base64Encode(salt),
      'hash': hash,
      'rounds': pinRounds,
    });
    // Save first: only treat the PIN as set once it is safely stored.
    await _keys.write(_pinKey, record);
    _pin = record;
    await _resetAttempts();
    locked = false;
    notifyListeners();
  }

  Future<bool> _matches(String pin) async {
    if (_pin == null) return false;
    final record = jsonDecode(_pin!) as Map<String, dynamic>;
    final hash = await PasswordCrypto.hashPin(
      pin,
      base64Decode(record['salt'] as String),
      record['rounds'] as int,
    );
    return constantTimeEquals(hash, record['hash'] as String);
  }

  /// Checks [pin] without changing whether the app is locked. Wrong tries
  /// count towards the delay, wherever the PIN is asked for.
  Future<PinResult> checkPin(String pin) async {
    if (retryAt != null) return PinResult.tooManyAttempts;
    if (await _matches(pin)) {
      await _resetAttempts();
      return PinResult.ok;
    }
    final failed = failedAttempts + 1;
    await _prefs.setInt('lock.failed', failed);
    if (failed >= freeAttempts) {
      final seconds = min(30 * pow(2, failed - freeAttempts).toInt(), 15 * 60);
      await _prefs.setInt(
        'lock.retryAt',
        now().add(Duration(seconds: seconds)).millisecondsSinceEpoch,
      );
    }
    notifyListeners();
    return failed >= freeAttempts ? PinResult.tooManyAttempts : PinResult.wrong;
  }

  /// Checks [pin]; on success the app unlocks.
  Future<PinResult> unlock(String pin) async {
    final result = await checkPin(pin);
    if (result == PinResult.ok) {
      locked = false;
      notifyListeners();
    }
    return result;
  }

  Future<bool> unlockWithBiometrics() async {
    if (!hasPin || !biometricsEnabled) return false;
    if (!await biometrics.authenticate('Unlock Elderly Care')) return false;
    await _resetAttempts();
    locked = false;
    notifyListeners();
    return true;
  }

  /// Turns the lock off; needs the current PIN.
  Future<PinResult> removePin(String currentPin) async {
    final result = await checkPin(currentPin);
    if (result == PinResult.ok) await clear();
    return result;
  }

  Future<void> setBiometricsEnabled(bool value) async {
    await _prefs.setBool('lock.biometrics', value);
    notifyListeners();
  }

  Future<void> setMedicalIdWhenLocked(bool value) async {
    await _prefs.setBool('lock.medicalId', value);
    notifyListeners();
  }

  void lockNow() {
    if (!hasPin) return;
    locked = true;
    notifyListeners();
  }

  void appPaused() => _backgroundedAt ??= now();

  void appResumed() {
    final since = _backgroundedAt;
    _backgroundedAt = null;
    if (since != null && now().difference(since) >= relockAfter) lockNow();
  }

  /// Removes the PIN and lock settings (used when erasing all data).
  Future<void> clear() async {
    _pin = null;
    locked = false;
    try {
      await _keys.delete(_pinKey);
    } catch (_) {}
    for (final k in ['lock.biometrics', 'lock.medicalId']) {
      await _prefs.remove(k);
    }
    await _resetAttempts();
    notifyListeners();
  }

  Future<void> _resetAttempts() async {
    await _prefs.remove('lock.failed');
    await _prefs.remove('lock.retryAt');
  }
}
