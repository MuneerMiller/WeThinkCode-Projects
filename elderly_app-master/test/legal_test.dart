import 'dart:io';

import 'package:elderly_app/legal/legal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  group('Legal documents', () {
    test(
      'every document exists, is filled in and has no stray placeholders',
      () {
        for (final doc in LegalDoc.values) {
          final raw = File(doc.asset).readAsStringSync();
          final filled = LegalInfo.fill(raw);
          expect(filled, isNot(contains('{{')), reason: doc.file);
          expect(filled, startsWith('# '), reason: doc.file);
          expect(filled.length, greaterThan(1000), reason: doc.file);
        }
      },
    );

    test('documents cover the essentials', () {
      String read(LegalDoc d) =>
          LegalInfo.fill(File(d.asset).readAsStringSync());
      final terms = read(LegalDoc.terms);
      for (final t in [
        'Consumer Protection Act',
        'not a medical service and not an emergency service',
        'Limitation of liability',
        'Electronic Communications and Transactions Act',
        'section 43',
        'laws of the Republic of South Africa',
        'Changes to these Terms',
      ]) {
        expect(terms, contains(t), reason: 'Terms: $t');
      }
      final privacy = read(LegalDoc.privacy);
      for (final t in [
        'Protection of Personal Information Act',
        'special personal information',
        'Information Officer',
        'section 72',
        'section 22',
        'Information Regulator',
        'GDPR',
        'Promotion of Access to Information Act',
        'Overpass',
        'Jitsi Meet',
      ]) {
        expect(privacy, contains(t), reason: 'Privacy: $t');
      }
      final medical = read(LegalDoc.medical);
      for (final t in ['112', '10177', '10111', 'SAHPRA', 'medical device']) {
        expect(medical, contains(t), reason: 'Medical: $t');
      }
    });

    test('font and map-data licences are registered', () async {
      registerExtraLicenses();
      final packages = <String>{};
      final texts = StringBuffer();
      await for (final entry in LicenseRegistry.licenses) {
        packages.addAll(entry.packages);
        for (final p in entry.paragraphs) {
          texts.writeln(p.text);
        }
      }
      expect(
        packages,
        containsAll(['Lexend (font)', 'OpenStreetMap data (hospital search)']),
      );
      expect(texts.toString(), contains('SIL Open Font License, Version 1.1'));
      expect(texts.toString(), contains('Open Database Licence'));
    });

    test('the app version matches pubspec.yaml', () {
      final pubspec = File('pubspec.yaml').readAsStringSync();
      final version = RegExp(
        r'^version:\s*([\d.]+)',
        multiLine: true,
      ).firstMatch(pubspec)!.group(1);
      expect(appVersion, version);
    });
  });

  testWidgets('existing users accept the documents once before continuing', (
    tester,
  ) async {
    final prefs = {...signedUp}
      ..remove('legal.version')
      ..remove('legal.acceptedAt');
    final app = await pumpApp(tester, prefs: prefs);

    expect(find.text('Please review our terms'), findsOneWidget);
    expect(find.textContaining(', Margaret'), findsNothing);
    await tester.tapText('Continue');
    expect(find.text('Please tick the box to continue.'), findsOneWidget);

    await tester.tapText('Read the medical disclaimer');
    expect(find.text('In an emergency'), findsOneWidget);
    await tester.back();

    await tester.tapText(
      'I agree to the Terms of Use, and I have read the Medical disclaimer '
      'and the Privacy policy',
    );
    await tester.tapText('Continue');
    expect(app.store.legalAcceptedVersion, LegalInfo.version);
    expect(app.store.legalAcceptedAt, isNotNull);
    expect(find.textContaining(', Margaret'), findsOneWidget);
  });

  testWidgets('Legal & about lists every document, licences and the version', (
    tester,
  ) async {
    await pumpApp(tester, prefs: signedUp);
    await tester.tap(find.byTooltip('My profile'));
    await tester.pumpAndSettle();
    await tester.tapText('Legal & about');
    for (final doc in LegalDoc.values) {
      expect(find.text(doc.title), findsOneWidget, reason: doc.title);
    }
    expect(find.text('Elderly Care, version $appVersion'), findsOneWidget);
    expect(
      find.text(
        'You accepted version ${LegalInfo.version} of these documents on '
        '1 November 2026.',
      ),
      findsOneWidget,
    );

    for (final doc in LegalDoc.values) {
      await tester.tapText(doc.title);
      expect(find.text(doc.title), findsWidgets);
      expect(find.byType(Text), findsWidgets);
      await tester.back();
    }

    await tester.tapText('Open-source licences');
    expect(find.text('Elderly Care'), findsWidgets);
    expect(find.text('Version $appVersion'), findsOneWidget);
  });

  testWidgets('disclaimer notes link to the medical disclaimer', (
    tester,
  ) async {
    await pumpApp(tester, prefs: signedUp);
    await tester.tapText('Health tracker');
    await tester.tapText('Read the medical disclaimer');
    expect(find.text('Medical disclaimer'), findsWidgets);
    expect(find.text('The App is not a doctor'), findsOneWidget);
  });
}
