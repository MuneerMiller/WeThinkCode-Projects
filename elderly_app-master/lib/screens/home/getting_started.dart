import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../appointments/appointment_edit_screen.dart';
import '../family/relative_edit_screen.dart';
import '../medicines/medicine_edit_screen.dart';
import '../profile/security_screen.dart';

class _Step {
  const _Step(this.title, this.icon, this.done, this.open, [this.feature]);
  final String title;
  final IconData icon;
  final bool done;
  final Widget Function() open;
  final Feature? feature;
}

/// After setup, suggests first steps that match what the user said they
/// want help with, ticking each off as it is done.
class GettingStartedCard extends StatelessWidget {
  const GettingStartedCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final theme = Theme.of(context);
    final wanted = store.profile?.interests;
    bool wants(Feature f) => wanted == null || wanted.contains(f.name);

    final steps = [
      if (wants(Feature.medicines))
        _Step(
          l.startAddMedicine,
          Feature.medicines.icon,
          store.medicines.isNotEmpty,
          () => const MedicineEditScreen(),
          Feature.medicines,
        ),
      if (wants(Feature.appointments))
        _Step(
          l.startAddAppointment,
          Feature.appointments.icon,
          store.appointments.isNotEmpty,
          () => const AppointmentEditScreen(),
          Feature.appointments,
        ),
      _Step(
        l.startAddFamily,
        Feature.family.icon,
        store.relatives.isNotEmpty,
        () => const RelativeEditScreen(),
        Feature.family,
      ),
      _Step(
        l.startAddPin,
        Icons.lock_rounded,
        store.lock.hasPin,
        () => const SecurityScreen(),
      ),
    ];
    final left = steps.where((s) => !s.done).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    left == 0 ? l.startAllDone : l.startTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: l.commonClose,
                  onPressed: () => store.setShowGettingStarted(false),
                  icon: const Icon(Icons.close_rounded),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 4),
              child: Text(
                left == 0 ? l.startAllDoneBody : l.startBody,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            for (final s in steps)
              ListTile(
                contentPadding: const EdgeInsets.only(right: 4),
                leading: Icon(
                  s.done ? Icons.check_circle_rounded : s.icon,
                  color: s.done
                      ? Colors.green.shade700
                      : (s.feature?.color ?? theme.colorScheme.primary),
                  size: 30,
                ),
                title: Text(
                  s.title,
                  style: s.done
                      ? TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.onSurfaceVariant,
                        )
                      : null,
                ),
                trailing: s.done
                    ? null
                    : const Icon(Icons.chevron_right_rounded),
                enabled: !s.done,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => s.feature == null
                        ? s.open()
                        : FeatureTheme(feature: s.feature!, child: s.open()),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
