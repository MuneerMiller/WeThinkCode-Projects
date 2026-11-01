import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/app_store.dart';
import '../../services/notification_service.dart';
import '../../theme.dart';
import 'dose_check_screen.dart';

/// Acts on a tap on a medicine notification or one of its buttons.
Future<void> handleDoseResponse({
  required DoseResponse response,
  required AppStore store,
  required AppServices services,
  required GlobalKey<NavigatorState> navigator,
  required GlobalKey<ScaffoldMessengerState> messenger,
  DateTime? now,
}) async {
  now ??= DateTime.now();
  final m = store.medicines
      .where((m) => m.id == response.dose.medicineId)
      .firstOrNull;
  if (m == null) return;
  final slot = response.dose.slot;
  final day = response.dose.dayFor(now);

  void say(String text) => messenger.currentState
    ?..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));

  switch (response.action) {
    case DoseAction.taken:
      await store.recordDose(m, day, slot, true);
      say('${m.name} recorded as taken. Well done!');
    case DoseAction.snooze:
      await services.notifications.snooze(m, response.dose);
      say('We will remind you about ${m.name} again in 10 minutes.');
    case DoseAction.open || DoseAction.notYet:
      final dose = m
          .dosesOn(day)
          .where((d) => d.time == slot.on(day))
          .firstOrNull;
      if (dose == null) return;
      navigator.currentState?.push(
        MaterialPageRoute(
          builder: (_) => FeatureTheme(
            feature: Feature.medicines,
            child: DoseCheckScreen(dose: dose),
          ),
        ),
      );
  }
}
