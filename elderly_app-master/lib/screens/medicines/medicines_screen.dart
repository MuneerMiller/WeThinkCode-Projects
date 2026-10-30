import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'dose_check_screen.dart';
import 'medicine_edit_screen.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final now = DateTime.now();
    final doses = store.dosesToday(now);
    final medicines = [...store.medicines]
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(title: const Text('Medicines')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FeatureTheme(
              feature: Feature.medicines,
              child: const MedicineEditScreen(),
            ),
          ),
        ),
        icon: const Icon(Icons.add_rounded, size: 28),
        label: const Text('Add medicine'),
      ),
      body: medicines.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.medication_rounded,
                image: 'assets/images/medicines.png',
                title: 'No medicines yet',
                message:
                    'Add your medicines and we will remind you when each dose is due.',
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              children: [
                ContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SectionHeader(
                        "Today's schedule",
                        trailing: Text(
                          '${doses.where((d) => d.status == DoseStatus.taken).length}'
                          ' of ${doses.length} taken',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Card(
                        child: Column(
                          children: [
                            for (final (i, d) in doses.indexed) ...[
                              if (i > 0)
                                const Divider(indent: 20, endIndent: 20),
                              _DoseRow(d),
                            ],
                          ],
                        ),
                      ),
                      const SectionHeader('My medicines'),
                      for (final m in medicines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: ListTile(
                              leading: IconBadge(m.type.icon),
                              title: Text(m.name),
                              subtitle: Text(
                                [
                                  if (m.dosage.isNotEmpty) m.dosage,
                                  '${m.times.length}× a day',
                                  ([...m.times]..sort())
                                      .map((t) => t.timeOfDay.format(context))
                                      .join(', '),
                                ].join(' · '),
                              ),
                              trailing: const Icon(Icons.edit_rounded),
                              onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => FeatureTheme(
                                    feature: Feature.medicines,
                                    child: MedicineEditScreen(medicine: m),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _DoseRow extends StatelessWidget {
  const _DoseRow(this.dose);
  final Dose dose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (IconData icon, Color color, String label) = switch (dose.status) {
      DoseStatus.taken => (
        Icons.check_circle_rounded,
        const Color(0xFF2E7D32),
        'Taken',
      ),
      DoseStatus.skipped => (Icons.cancel_rounded, scheme.error, 'Not taken'),
      DoseStatus.due => (
        Icons.notifications_active_rounded,
        scheme.primary,
        // More than an hour late reads as overdue rather than due.
        DateTime.now().difference(dose.time).inMinutes > 60
            ? 'Overdue'
            : 'Due now',
      ),
      DoseStatus.upcoming => (
        Icons.schedule_rounded,
        scheme.onSurfaceVariant,
        'Later',
      ),
    };
    return ListTile(
      leading: Icon(icon, color: color, size: 34),
      title: Text(dose.medicine.name),
      subtitle: Text('${formatTime(context, dose.time)} · $label'),
      trailing: dose.status == DoseStatus.due
          ? FilledButton(
              onPressed: () => openDoseCheck(context, dose),
              child: const Text('Check'),
            )
          : null,
      onTap: () => openDoseCheck(context, dose),
    );
  }
}
