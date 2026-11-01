import 'package:flutter/material.dart';

import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../l10n/labels.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

/// Large tick-boxes for the features a user wants help with.
class InterestsPicker extends StatelessWidget {
  const InterestsPicker({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final Set<Feature> selected;
  final ValueChanged<Set<Feature>> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Column(
      children: [
        for (final f in Feature.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Material(
              color: selected.contains(f)
                  ? f.scheme(theme.brightness).primaryContainer
                  : theme.colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(
                  color: selected.contains(f)
                      ? f.color
                      : theme.colorScheme.outlineVariant,
                  width: selected.contains(f) ? 2 : 1,
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: CheckboxListTile(
                value: selected.contains(f),
                onChanged: (v) => onChanged(
                  v == true ? {...selected, f} : ({...selected}..remove(f)),
                ),
                secondary: IconBadge(f.icon, color: f.color, size: 46),
                title: Text(f.title(l)),
                subtitle: Text(f.description(l)),
                contentPadding: const EdgeInsets.fromLTRB(12, 4, 8, 4),
              ),
            ),
          ),
      ],
    );
  }
}

/// "I usually get up at … / go to bed at …", with the medicine times that
/// follow from them.
class DayTimesPicker extends StatelessWidget {
  const DayTimesPicker({
    super.key,
    required this.wake,
    required this.bed,
    required this.onChanged,
  });

  final ClockTime wake;
  final ClockTime bed;
  final void Function(ClockTime wake, ClockTime bed) onChanged;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final today = DateTime.now();
    String show(ClockTime t) => formatTime(context, t.on(today));

    Future<void> pick(bool isWake) async {
      final picked = await showTimePicker(
        context: context,
        initialTime: (isWake ? wake : bed).timeOfDay,
      );
      if (picked == null) return;
      final t = ClockTime.fromTimeOfDay(picked);
      isWake ? onChanged(t, bed) : onChanged(wake, t);
    }

    Widget row(IconData icon, String label, ClockTime t, bool isWake) =>
        ListTile(
          leading: Icon(icon, size: 32),
          title: Text(label),
          subtitle: Text(show(t), style: theme.textTheme.headlineSmall),
          trailing: const Icon(Icons.edit_rounded),
          onTap: () => pick(isWake),
        );

    final suggested =
        (UserProfile(name: '')
              ..wakeTime = wake
              ..bedTime = bed)
            .suggestedDoseTimes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Column(
            children: [
              row(Icons.wb_sunny_rounded, l.setupWakeUp, wake, true),
              const Divider(indent: 20, endIndent: 20),
              row(Icons.bedtime_rounded, l.setupBedtime, bed, false),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.medication_rounded, color: Feature.medicines.color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l.setupDaySuggestion(suggested.map(show).join(', ')),
                style: theme.textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Blood groups offered as choices, so nothing needs typing.
const bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
