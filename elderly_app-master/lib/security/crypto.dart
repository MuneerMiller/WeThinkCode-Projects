import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart' show DartPbkdf2;
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small key-value store for secrets (the data key, the PIN record).
abstract class KeyStore {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> delete(String key);
}

/// Android Keystore / iOS Keychain / WebCrypto-protected browser storage.
class SecureKeyStore implements KeyStore {
  const SecureKeyStore();

  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write(String key, String value) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);
}

/// Keeps secrets in memory; used by tests.
class MemoryKeyStore implements KeyStore {
  final values = <String, String>{};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

final _aes = AesGcm.with256bits();

/// Encrypts the app's stored data with a random AES-256-GCM key that lives
/// only in the platform's secure key storage.
class Vault {
  Vault._(this._key);

  static const _keyName = 'elderly_care.data_key';
  static const _prefix = 'enc1:';

  final SecretKey? _key;

  /// Whether data is actually encrypted. False only when the device offers no
  /// secure key storage (e.g. a browser page not served over HTTPS).
  bool get isEncrypted => _key != null;

  static Future<Vault> open(KeyStore keys) async {
    try {
      final existing = await keys.read(_keyName);
      if (existing != null) return Vault._(SecretKey(base64Decode(existing)));
      final key = await _aes.newSecretKey();
      await keys.write(_keyName, base64Encode(await key.extractBytes()));
      return Vault._(key);
    } catch (e) {
      debugPrint(
        'Secure key storage unavailable (${e.runtimeType}); '
        'data will be stored unencrypted.',
      );
      return Vault._(null);
    }
  }

  /// A vault that never encrypts; for tests of plain behaviour.
  factory Vault.plain() => Vault._(null);

  static bool isSealed(String stored) => stored.startsWith(_prefix);

  Future<String> seal(String plain) async {
    if (_key == null) return plain;
    final box = await _aes.encrypt(utf8.encode(plain), secretKey: _key);
    return _prefix + base64Encode(box.concatenation());
  }

  /// Decrypts [stored]; values written before encryption existed are
  /// returned unchanged so they can be migrated.
  Future<String> unseal(String stored) async {
    if (!isSealed(stored)) return stored;
    if (_key == null) {
      throw StateError('Encrypted data but no key is available.');
    }
    final box = SecretBox.fromConcatenation(
      base64Decode(stored.substring(_prefix.length)),
      nonceLength: _aes.nonceLength,
      macLength: _aes.macAlgorithm.macLength,
    );
    return utf8.decode(await _aes.decrypt(box, secretKey: _key));
  }
}

/// Password protection for backup files: PBKDF2-HMAC-SHA256 then AES-GCM.
class PasswordCrypto {
  static const iterations = 210000;

  /// Hashing yields briefly every few thousand rounds so the screen stays
  /// responsive. Tests turn this off because they run on a fake clock.
  static bool yieldWhileHashing = true;

  static Future<SecretKey> _derive(
    String password,
    List<int> salt,
    int rounds,
  ) {
    // In browsers this uses the fast built-in Web Crypto implementation.
    final Pbkdf2 kdf = yieldWhileHashing
        ? Pbkdf2.hmacSha256(iterations: rounds, bits: 256)
        : DartPbkdf2(
            macAlgorithm: Hmac.sha256(),
            iterations: rounds,
            bits: 256,
            pauseFrequency: 0,
          );
    return kdf.deriveKeyFromPassword(password: password, nonce: salt);
  }

  static Future<Map<String, Object>> encrypt(
    String plain,
    String password,
  ) async {
    final salt = SecretKeyData.random(length: 16).bytes;
    final key = await _derive(password, salt, iterations);
    final box = await _aes.encrypt(utf8.encode(plain), secretKey: key);
    return {
      'kdf': 'pbkdf2-hmac-sha256',
      'iterations': iterations,
      'salt': base64Encode(salt),
      'cipher': 'aes-256-gcm',
      'payload': base64Encode(box.concatenation()),
    };
  }

  /// Throws [SecretBoxAuthenticationError] if the password is wrong.
  static Future<String> decrypt(
    Map<String, Object?> sealed,
    String password,
  ) async {
    final rounds = sealed['iterations'];
    if (sealed['kdf'] != 'pbkdf2-hmac-sha256' ||
        sealed['cipher'] != 'aes-256-gcm' ||
        rounds is! int ||
        rounds < 10000 ||
        rounds > 5000000) {
      throw const FormatException(
        'This backup uses an unknown protection method.',
      );
    }
    final key = await _derive(
      password,
      base64Decode(sealed['salt'] as String),
      rounds,
    );
    final box = SecretBox.fromConcatenation(
      base64Decode(sealed['payload'] as String),
      nonceLength: _aes.nonceLength,
      macLength: _aes.macAlgorithm.macLength,
    );
    return utf8.decode(await _aes.decrypt(box, secretKey: key));
  }

  /// Salted, slow hash for the app-lock PIN.
  static Future<String> hashPin(String pin, List<int> salt, int rounds) async {
    final key = await _derive(pin, salt, rounds);
    return base64Encode(await key.extractBytes());
  }
}

/// Compares two strings in time independent of where they differ.
bool constantTimeEquals(String a, String b) {
  if (a.length != b.length) return false;
  var diff = 0;
  for (var i = 0; i < a.length; i++) {
    diff |= a.codeUnitAt(i) ^ b.codeUnitAt(i);
  }
  return diff == 0;
}
