// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:elderly_app/demo/demo.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

// Most of this runs only in the demo build:
//   flutter test --dart-define=DEMO=true test/demo_test.dart
void main() {
  test('sample data is current and complete', () {
    final now = DateTime(2026, 11, 5, 10);
    final prefs = demoPrefs(now);
    expect(prefs['onboardingSeen'], isTrue);
    for (final key in [
      'profile',
      'relatives',
      'medicines',
      'appointments',
      'trackerEntries',
      'notes',
    ]) {
      expect(prefs[key], isA<String>(), reason: key);
    }
    // Upcoming visits are in the future, whatever the date.
    expect(prefs['appointments'] as String, contains('2026-11-06T10:00'));
  });

  testWidgets(
    'the demo opens on sample data and can start over as a new user',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final app = await pumpApp(tester, prefs: demoPrefs(DateTime.now()));
      expect(find.textContaining(', Margaret'), findsOneWidget);
      expect(
        find.text('Demo with sample data. Resets on reload.'),
        findsOneWidget,
      );
      // Screen readers can reach the strip too.
      expect(find.bySemanticsLabel('Try it as a new user'), findsOneWidget);

      await tester.tapText('Medicines');
      await tester.tapText('Try it as a new user');
      expect(app.store.profile, isNull);
      expect(find.text('Never miss a medicine'), findsOneWidget);
      expect(tester.takeException(), isNull);
      semantics.dispose();
    },
    skip: !isDemo,
  );
}
