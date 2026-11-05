// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'main screens work and feel native on Android and iOS',
    (tester) async {
      final ios = defaultTargetPlatform == TargetPlatform.iOS;
      await pumpApp(tester, prefs: signedUp);

      // Native page transitions on each platform.
      final theme = Theme.of(tester.element(find.text('I need help')));
      expect(
        theme.pageTransitionsTheme.builders[defaultTargetPlatform],
        ios
            ? isA<CupertinoPageTransitionsBuilder>()
            : isA<PredictiveBackPageTransitionsBuilder>(),
      );

      for (final feature in [
        'Medicines',
        'Appointments',
        'Health tracker',
        'My family',
        'Documents',
        'Notes',
      ]) {
        await tester.tapText(feature);
        expect(tester.takeException(), isNull, reason: feature);
        await tester.back();
      }

      // Adaptive switches (drawn in the iOS style on iPhone).
      await tester.tapText('Video call');
      expect(find.byType(Switch), findsWidgets);
      expect(tester.takeException(), isNull);
      await tester.back();

      await tester.tapText('I need help');
      expect(tester.takeException(), isNull);
      expect(find.byType(BottomSheet), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );
}
