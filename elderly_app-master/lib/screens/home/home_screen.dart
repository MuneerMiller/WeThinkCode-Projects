import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../appointments/appointments_screen.dart';
import '../documents/documents_screen.dart';
import '../family/family_screen.dart';
import '../family/sos.dart';
import '../health/health_screen.dart';
import '../hospitals/hospitals_screen.dart';
import '../medicines/dose_check_screen.dart';
import '../medicines/medicines_screen.dart';
import '../notes/notes_screen.dart';
import '../profile/profile_screen.dart';
import '../video_call/video_call_screen.dart';

Widget screenFor(Feature f) => switch (f) {
  Feature.medicines => const MedicinesScreen(),
  Feature.appointments => const AppointmentsScreen(),
  Feature.health => const HealthScreen(),
  Feature.family => const FamilyScreen(),
  Feature.hospitals => const HospitalsScreen(),
  Feature.videoCall => const VideoCallScreen(),
  Feature.documents => const DocumentsScreen(),
  Feature.notes => const NotesScreen(),
};

void openFeature(BuildContext context, Feature f) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (_) => FeatureTheme(feature: f, child: screenFor(f)),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final theme = Theme.of(context);
    final now = DateTime.now();
    final profile = store.profile!;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 34,
              excludeFromSemantics: true,
            ),
            const SizedBox(width: 12),
            const Flexible(
              child: Text('Elderly Care', overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: 'My profile',
              onPressed: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const ProfileScreen())),
              icon: CircleAvatar(
                radius: 20,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  profile.name.isEmpty ? '?' : profile.name[0].toUpperCase(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ContentWidth(
            maxWidth: 900,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${greeting(now)}, ${profile.firstName}',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE d MMMM').format(now),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                const _SosButton(),
                const SizedBox(height: 16),
                _TodayCard(now: now),
                const SectionHeader('What would you like to do?'),
                LayoutBuilder(
                  builder: (context, c) {
                    // Each tile needs about 170px at normal text size; with
                    // larger text use fewer, wider tiles so words don't break.
                    final textScale = MediaQuery.textScalerOf(context).scale(1);
                    final columns = (c.maxWidth / (170 * textScale))
                        .floor()
                        .clamp(1, 4);
                    const features = Feature.values;
                    // Rows size to their tallest tile, so large system text
                    // makes tiles taller instead of overflowing.
                    return Column(
                      children: [
                        for (var i = 0; i < features.length; i += columns)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (var j = i; j < i + columns; j++) ...[
                                    if (j > i) const SizedBox(width: 14),
                                    Expanded(
                                      child: j < features.length
                                          ? _FeatureTile(features[j])
                                          : const SizedBox(),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SosButton extends StatelessWidget {
  const _SosButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: AppTheme.sos,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => showSosSheet(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.sos_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'I need help',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Call for help or alert your family',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white,
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Next medicine dose and next appointment at a glance.
class _TodayCard extends StatelessWidget {
  const _TodayCard({required this.now});
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final theme = Theme.of(context);
    final doses = store.dosesToday(now);
    final pending = doses
        .where(
          (d) => d.status == DoseStatus.due || d.status == DoseStatus.upcoming,
        )
        .toList();
    final taken = doses.where((d) => d.status == DoseStatus.taken).length;
    final nextAppt = store.upcomingAppointments(now).firstOrNull;
    final runningLow = store.medicines.where((m) => m.isLow).toList();
    final profile = store.profile;
    final nextDose = pending.firstOrNull;
    final spoken = [
      if (profile != null) '${greeting(now)}, ${profile.firstName}.',
      'Today is ${DateFormat('EEEE d MMMM').format(now)}.',
      if (doses.isEmpty)
        'You have no medicines set up.'
      else if (nextDose == null)
        'You have taken all your medicines for today.'
      else
        '${nextDose.status == DoseStatus.due ? 'It is time for' : 'Your next medicine is'} '
            '${nextDose.medicine.name}'
            '${nextDose.medicine.dosage.isEmpty ? '' : ', ${nextDose.medicine.dosage},'} '
            'at ${formatTime(context, nextDose.time)}.',
      for (final m in runningLow) 'Remember to refill ${m.name} soon.',
      if (nextAppt != null)
        'Your next appointment is with ${nextAppt.doctor}, '
            '${formatDay(nextAppt.dateTime, now: now).toLowerCase()} at '
            '${formatTime(context, nextAppt.dateTime)}.',
    ].join(' ');

    final Widget medicineRow;
    if (doses.isEmpty) {
      medicineRow = ListTile(
        leading: IconBadge(
          Feature.medicines.icon,
          color: Feature.medicines.color,
        ),
        title: const Text('No medicines yet'),
        subtitle: const Text('Add one to get reminders'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => openFeature(context, Feature.medicines),
      );
    } else if (pending.isEmpty) {
      medicineRow = ListTile(
        leading: IconBadge(
          Icons.check_circle_rounded,
          color: Feature.notes.color,
        ),
        title: const Text('All medicines done for today'),
        subtitle: Text('$taken of ${doses.length} taken'),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => openFeature(context, Feature.medicines),
      );
    } else {
      final next = pending.first;
      final isDue = next.status == DoseStatus.due;
      medicineRow = ListTile(
        leading: IconBadge(
          next.medicine.type.icon,
          color: Feature.medicines.color,
        ),
        title: Text(
          isDue
              ? 'Time for ${next.medicine.name}'
              : 'Next: ${next.medicine.name}',
        ),
        subtitle: Text(
          '${formatTime(context, next.time)}'
          '${next.medicine.dosage.isEmpty ? '' : ' · ${next.medicine.dosage}'}',
        ),
        trailing: isDue
            ? FilledButton.tonal(
                onPressed: () => openDoseCheck(context, next),
                child: const Text('Check'),
              )
            : const Icon(Icons.chevron_right_rounded),
        onTap: () => isDue
            ? openDoseCheck(context, next)
            : openFeature(context, Feature.medicines),
      );
    }

    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 12, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('Today', style: theme.textTheme.titleMedium),
                ),
                ReadAloudButton(text: spoken),
              ],
            ),
          ),
          medicineRow,
          for (final m in runningLow) ...[
            const Divider(indent: 20, endIndent: 20),
            ListTile(
              leading: IconBadge(
                Icons.warning_amber_rounded,
                color: Theme.of(context).colorScheme.error,
              ),
              title: Text('Refill ${m.name} soon'),
              subtitle: Text('Only ${m.supply} doses left'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => openFeature(context, Feature.medicines),
            ),
          ],
          if (nextAppt != null) ...[
            const Divider(indent: 20, endIndent: 20),
            ListTile(
              leading: IconBadge(
                Feature.appointments.icon,
                color: Feature.appointments.color,
              ),
              title: Text(nextAppt.doctor),
              subtitle: Text(
                '${formatDay(nextAppt.dateTime, now: now)} at ${formatTime(context, nextAppt.dateTime)}',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => openFeature(context, Feature.appointments),
            ),
          ],
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile(this.feature);
  final Feature feature;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = feature.scheme(theme.brightness);
    return Material(
      color: s.primaryContainer.withValues(
        alpha: theme.brightness == Brightness.light ? 0.55 : 0.35,
      ),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => openFeature(context, feature),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: s.primary,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(feature.icon, color: s.onPrimary, size: 34),
              ),
              const SizedBox(height: 20),
              Text(
                feature.label,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: s.onPrimaryContainer,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Text(
                feature.subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: s.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
