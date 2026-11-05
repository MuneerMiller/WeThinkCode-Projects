// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:async';
import 'dart:io';

import 'package:elderly_app/security/crypto.dart';
import 'package:flutter/services.dart';

/// Loads the app's real font so text is measured as it will be on a phone
/// (the default test font draws every glyph as a wide square).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final lexend = FontLoader('Lexend');
  for (final weight in [400, 600, 700]) {
    final bytes = File('assets/fonts/Lexend-$weight.ttf').readAsBytesSync();
    lexend.addFont(Future.value(ByteData.sublistView(bytes)));
  }
  await lexend.load();
  // Widget tests run on a fake clock, where the hashing pauses never end.
  PasswordCrypto.yieldWhileHashing = false;
  await testMain();
}
