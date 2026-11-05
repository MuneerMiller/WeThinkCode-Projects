// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../legal/legal_screens.dart';
import '../../legal/legal.dart';
import '../../l10n/l10n.dart';
import 'dose_check_screen.dart';
import 'medicine_edit_screen.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final now = DateTime.now();
    final doses = store.dosesToday(now);
    final medicines = [...store.medicines]
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      appBar: AppBar(title: Text(l.medicinesTitle)),
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
        label: Text(l.medicinesAdd),
      ),
      body: medicines.isEmpty
          ? Center(
              child: EmptyState(
                icon: Icons.medication_rounded,
                image: 'assets/images/medicines.png',
                title: l.medicinesEmptyTitle,
                message: l.medicinesEmptyMessage,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
              children: [
                ContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _OnTimeRemindersCard(),
                      SectionHeader(
                        l.medicinesTodaySchedule,
                        trailing: Text(
                          l.medicinesTakenToday(
                            doses
                                .where((d) => d.status == DoseStatus.taken)
                                .length,
                            doses.length,
                          ),
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
                      SectionHeader(l.medicinesMine),
                      for (final m in medicines)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Card(
                            child: ListTile(
                              leading: IconBadge(m.type.icon),
                              title: Text(m.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    [
                                      if (m.dosage.isNotEmpty) m.dosage,
                                      l.medicinesTimesADay(m.times.length),
                                      ([...m.times]..sort())
                                          .map(
                                            (t) => t.timeOfDay.format(context),
                                          )
                                          .join(', '),
                                    ].join(' · '),
                                  ),
                                  _MedicineFacts(m, now: now),
                                ],
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
                      DisclaimerNote(
                        l.medicinesDisclaimer,
                        onReadMore: () =>
                            openLegalDoc(context, LegalDoc.medical),
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
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final (IconData icon, Color color, String label) = switch (dose.status) {
      DoseStatus.taken => (
        Icons.check_circle_rounded,
        const Color(0xFF2E7D32),
        l.doseStatusTaken,
      ),
      DoseStatus.skipped => (
        Icons.cancel_rounded,
        scheme.error,
        l.doseStatusNotTaken,
      ),
      DoseStatus.due => (
        Icons.notifications_active_rounded,
        scheme.primary,
        // More than an hour late reads as overdue rather than due.
        DateTime.now().difference(dose.time).inMinutes > 60
            ? l.doseStatusOverdue
            : l.doseStatusDue,
      ),
      DoseStatus.upcoming => (
        Icons.schedule_rounded,
        scheme.onSurfaceVariant,
        l.doseStatusLater,
      ),
    };
    return ListTile(
      leading: Icon(icon, color: color, size: 34),
      title: Text(dose.medicine.name),
      subtitle: Text(l.doseRowSubtitle(formatTime(context, dose.time), label)),
      trailing: dose.status == DoseStatus.due
          ? FilledButton(
              onPressed: () => openDoseCheck(context, dose),
              child: Text(l.doseCheck),
            )
          : null,
      onTap: () => openDoseCheck(context, dose),
    );
  }
}

/// Supply left and the last week's record for one medicine.
class _MedicineFacts extends StatelessWidget {
  const _MedicineFacts(this.m, {required this.now});
  final Medicine m;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final a = m.adherence(now);
    final lines = <Widget>[
      if (m.supply != null)
        Row(
          children: [
            Icon(
              m.isLow
                  ? Icons.warning_amber_rounded
                  : Icons.inventory_2_outlined,
              size: 20,
              color: m.isLow ? theme.colorScheme.error : null,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                m.isLow
                    ? l.medicinesSupplyLow(m.supply!)
                    : l.medicinesSupplyLeft(m.supply!, m.daysLeft!),
                style: m.isLow
                    ? TextStyle(
                        color: theme.colorScheme.error,
                        fontWeight: FontWeight.w600,
                      )
                    : null,
              ),
            ),
          ],
        ),
      if (a.due > 0) Text(l.medicinesLastWeek(a.taken, a.due)),
    ];
    if (lines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: lines,
      ),
    );
  }
}

/// Shown on Android when the phone may delay reminders, with a fix.
class _OnTimeRemindersCard extends StatefulWidget {
  const _OnTimeRemindersCard();

  @override
  State<_OnTimeRemindersCard> createState() => _OnTimeRemindersCardState();
}

class _OnTimeRemindersCardState extends State<_OnTimeRemindersCard>
    with WidgetsBindingObserver {
  bool? _allowed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _check();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Re-check when the user comes back from the settings page.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _check();
  }

  Future<void> _check() async {
    final allowed = await context.services.notifications.exactTimingAllowed();
    if (mounted) setState(() => _allowed = allowed);
  }

  @override
  Widget build(BuildContext context) {
    if (_allowed != false) return const SizedBox.shrink();
    final l = context.l10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Card(
        color: theme.colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.alarm_off_rounded,
                    color: theme.colorScheme.onTertiaryContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.medicinesLateTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l.medicinesLateMessage,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onTertiaryContainer,
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () =>
                    context.services.notifications.requestExactTiming(),
                child: Text(l.medicinesLateAllow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
