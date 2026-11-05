// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:convert';
import 'dart:io';

import 'package:elderly_app/l10n/l10n.dart';
import 'package:elderly_app/services/reminder_plan.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';
import 'reminders_test.dart' show metformin;

Map<String, dynamic> arb(String code) =>
    jsonDecode(File('lib/l10n/app_$code.arb').readAsStringSync());

/// Placeholder names used in an ICU message, e.g. {name} or {count, plural…}.
Set<String> placeholders(String message) => {
  for (final m in RegExp(r'\{(\w+)\s*[,}]').allMatches(message)) m.group(1)!,
};

const translations = ['af', 'zu', 'xh'];

void main() {
  final en = arb('en');
  final keys = en.keys.where((k) => !k.startsWith('@')).toSet();

  group('Translations', () {
    for (final code in translations) {
      test('$code has every message, with the same placeholders', () {
        final t = arb(code);
        expect(t['@@locale'], code);
        final tKeys = t.keys.where((k) => !k.startsWith('@')).toSet();
        expect(keys.difference(tKeys), isEmpty, reason: 'missing in $code');
        expect(tKeys.difference(keys), isEmpty, reason: 'extra in $code');
        for (final k in keys) {
          final value = t[k] as String;
          expect(value.trim(), isNotEmpty, reason: '$code $k');
          final declared =
              ((en['@$k'] as Map?)?['placeholders'] as Map?)?.keys.toSet() ??
              <String>{};
          // Plural/select branches can drop the number itself ("one dose").
          expect(
            placeholders(value).difference(declared),
            isEmpty,
            reason: '$code $k uses an unknown placeholder',
          );
          final isChoice = RegExp(r',\s*(plural|select)\s*,').hasMatch(value);
          if (!isChoice) {
            expect(
              placeholders(value),
              declared,
              reason: '$code $k must keep every placeholder',
            );
          }
        }
      });
    }

    test('the app offers exactly the translated languages', () {
      expect(
        AppLocalizations.supportedLocales.map((l) => l.languageCode).toSet(),
        {'en', ...translations},
      );
      expect(appLanguages.keys.toSet(), {'en', ...translations});
    });

    test('reminders are written in the chosen language', () {
      final zu = lookupAppLocalizations(const Locale('zu'));
      final plan = ReminderPlan.build(
        l10n: zu,
        medicines: [metformin()],
        appointments: const [],
        now: DateTime(2026, 3, 10, 9, 30),
      );
      expect(plan.first.title, zu.notifyDoseTitle('Metformin'));
      expect(plan.first.title, isNot(contains('Time for')));
    });
  });

  for (final code in translations) {
    testWidgets('the app works in ${appLanguages[code]}', (tester) async {
      final t = arb(code);
      final app = await pumpApp(tester, prefs: {...signedUp, 'language': code});
      expect(find.text(t['featureMedicines']), findsOneWidget);
      expect(find.text(en['featureMedicines']), findsNothing);

      // Visit screens that use dates, Flutter's own dialogs and the speech.
      for (final feature in ['featureMedicines', 'featureHealth']) {
        await tester.tapText(t[feature]);
        expect(tester.takeException(), isNull);
        tester.state<NavigatorState>(find.byType(Navigator).first).pop();
        await tester.pumpAndSettle();
      }
      await tester.tap(find.byTooltip(t['homeMyProfile']));
      await tester.pumpAndSettle();
      expect(find.text(t['languageTitle']), findsOneWidget);
      expect(find.text(appLanguages[code]!), findsOneWidget);
      expect(app.store.languageCode, code);
    });
  }

  testWidgets('choosing a language in My profile switches the app', (
    tester,
  ) async {
    final af = arb('af');
    final app = await pumpApp(tester, prefs: signedUp);
    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    await tester.tapText('Language');
    await tester.tapText('Afrikaans');
    expect(app.store.languageCode, 'af');
    expect(find.text(af['languageTitle']), findsOneWidget);

    await tester.tapText(af['languageTitle']);
    await tester.tapText(af['languageSystem']);
    expect(app.store.languageCode, isNull);
    expect(find.text('Language'), findsOneWidget);
  });

  testWidgets('the welcome screen offers a language choice', (tester) async {
    final xh = arb('xh');
    final app = await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.translate_rounded));
    await tester.pumpAndSettle();
    await tester.tapText('isiXhosa');
    expect(app.store.languageCode, 'xh');
    expect(find.text('isiXhosa'), findsOneWidget);
    expect(find.text(xh['onboardingSkip']), findsWidgets);
  });
}
