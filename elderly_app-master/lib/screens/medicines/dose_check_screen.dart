import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

void openDoseCheck(BuildContext context, Dose dose) {
  // Don't let an earlier message cover the answer buttons.
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => FeatureTheme(
        feature: Feature.medicines,
        child: DoseCheckScreen(dose: dose),
      ),
    ),
  );
}

/// "Did you take it?" — records the answer and, if a dose was missed,
/// offers to let the family know.
class DoseCheckScreen extends StatelessWidget {
  const DoseCheckScreen({super.key, required this.dose});
  final Dose dose;

  Future<void> _answer(BuildContext context, bool taken) async {
    final store = context.store;
    final contacts = context.services.contacts;
    final m = dose.medicine;
    final timeLabel = formatTime(context, dose.time);
    await store.recordDose(
      m,
      dose.time,
      ClockTime(dose.time.hour, dose.time.minute),
      taken,
    );
    if (!context.mounted) return;

    if (!taken && store.relatives.isNotEmpty) {
      final tell = await confirm(
        context,
        title: 'Let your family know?',
        message:
            'We can send a text to ${store.relatives.map((r) => r.name).join(', ')} '
            'saying you missed your ${m.name}.',
        confirmLabel: 'Send text',
      );
      if (tell) {
        final name = store.profile?.firstName ?? 'I';
        await contacts.sms(
          [for (final r in store.relatives) r.phone],
          '$name did not take ${m.name} '
          '($timeLabel) today. Please check in.',
        );
      }
    }
    if (context.mounted) {
      showMessage(
        context,
        taken
            ? 'Well done! ${m.name} recorded.'
            : 'Noted. ${m.name} not taken.',
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final m = dose.medicine;
    return Scaffold(
      appBar: AppBar(title: const Text('Medicine check')),
      body: SafeArea(
        child: ContentWidth(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                CircleAvatar(
                  radius: 56,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    m.type.icon,
                    size: 60,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Did you take your ${m.name}?',
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  [
                    if (m.dosage.isNotEmpty) m.dosage,
                    '${formatDay(dose.time)} at ${formatTime(context, dose.time)}',
                  ].join(' · '),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ReadAloudButton(
                  text:
                      'Did you take your ${m.name}? '
                      '${m.dosage.isEmpty ? '' : '${m.dosage}. '}'
                      '${formatDay(dose.time)} at ${formatTime(context, dose.time)}.',
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF2E7D32),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _answer(context, true),
                    icon: const Icon(Icons.check_rounded, size: 32),
                    label: const Text('Yes, I took it'),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: OutlinedButton.icon(
                    onPressed: () => _answer(context, false),
                    icon: const Icon(Icons.close_rounded, size: 32),
                    label: const Text('No, not yet'),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
