import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
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
    final l = context.l10n;
    final store = context.store;
    final contacts = context.services.contacts;
    final m = dose.medicine;
    final timeLabel = formatTime(context, dose.time);
    taken ? HapticFeedback.mediumImpact() : HapticFeedback.lightImpact();
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
        title: l.doseTellFamilyTitle,
        message: l.doseTellFamilyMessage(
          store.relatives.map((r) => r.name).join(', '),
          m.name,
        ),
        confirmLabel: l.doseTellFamilySend,
      );
      if (tell) {
        final name = store.profile?.firstName;
        await contacts.sms(
          [for (final r in store.relatives) r.phone],
          name == null
              ? l.doseMissedSmsNoName(m.name, timeLabel)
              : l.doseMissedSms(name, m.name, timeLabel),
        );
      }
    }
    if (context.mounted) {
      showMessage(
        context,
        taken ? l.doseRecordedTaken(m.name) : l.doseRecordedNotTaken(m.name),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final m = dose.medicine;
    final when = l.doseCheckWhen(
      formatDay(context, dose.time),
      formatTime(context, dose.time),
    );
    return Scaffold(
      appBar: AppBar(title: Text(l.doseCheckTitle)),
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
                  l.doseCheckQuestion(m.name),
                  style: theme.textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  [if (m.dosage.isNotEmpty) m.dosage, when].join(' · '),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ReadAloudButton(
                  text:
                      '${l.doseCheckQuestion(m.name)} '
                      '${m.dosage.isEmpty ? '' : '${m.dosage}. '}'
                      '$when.',
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
                    label: Text(l.doseCheckYes),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: OutlinedButton.icon(
                    onPressed: () => _answer(context, false),
                    icon: const Icon(Icons.close_rounded, size: 32),
                    label: Text(l.doseCheckNo),
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
