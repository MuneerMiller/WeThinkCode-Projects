import 'dart:async';
import 'dart:io';

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
  await testMain();
}
