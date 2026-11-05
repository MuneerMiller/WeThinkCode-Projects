// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Reads text aloud with the device's own voice.
class SpeechService {
  SpeechService();

  FlutterTts? _tts;

  /// The app's language, e.g. 'af'. Read-aloud uses a matching voice when the
  /// phone has one, and the phone's own voice otherwise.
  String? language;
  String? _voiceLanguage;

  /// The text being read right now, if any.
  final speaking = ValueNotifier<String?>(null);

  Future<FlutterTts> _engine() async {
    if (_tts != null) return _tts!;
    final tts = FlutterTts();
    // A little slower than normal, which is easier to follow.
    await tts.setSpeechRate(kIsWeb ? 0.85 : 0.42);
    tts
      ..setCompletionHandler(() => speaking.value = null)
      ..setCancelHandler(() => speaking.value = null)
      ..setErrorHandler((_) => speaking.value = null);
    return _tts = tts;
  }

  Future<void> speak(String text) async {
    try {
      final tts = await _engine();
      await tts.stop();
      await _useLanguage(tts);
      speaking.value = text;
      await tts.speak(text);
    } catch (e) {
      speaking.value = null;
      debugPrint('Read aloud unavailable (${e.runtimeType})');
    }
  }

  Future<void> _useLanguage(FlutterTts tts) async {
    final lang = language;
    if (lang == null || lang == _voiceLanguage) return;
    _voiceLanguage = lang;
    for (final tag in ['$lang-ZA', lang]) {
      try {
        if (await tts.isLanguageAvailable(tag) == true) {
          await tts.setLanguage(tag);
          return;
        }
      } catch (_) {}
    }
  }

  Future<void> stop() async {
    speaking.value = null;
    try {
      await _tts?.stop();
    } catch (_) {}
  }
}
