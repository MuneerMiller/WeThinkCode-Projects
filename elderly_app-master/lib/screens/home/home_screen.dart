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
import 'getting_started.dart';
import '../../l10n/l10n.dart';
import '../../l10n/labels.dart';

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
    final l = context.l10n;
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
            Flexible(child: Text(l.appTitle, overflow: TextOverflow.ellipsis)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              tooltip: l.homeMyProfile,
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
                  l.homeGreeting(greeting(l, now), profile.callName),
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
                if (store.showGettingStarted) ...[
                  const SizedBox(height: 16),
                  const GettingStartedCard(),
                ],
                SectionHeader(l.homeWhatToDo),
                LayoutBuilder(
                  builder: (context, c) {
                    // Each tile needs about 170px at normal text size; with
                    // larger text use fewer, wider tiles so words don't break.
                    final textScale = MediaQuery.textScalerOf(context).scale(1);
                    final columns = (c.maxWidth / (170 * textScale))
                        .floor()
                        .clamp(1, 4);
                    // What the user asked for help with comes first.
                    final wanted = profile.interests ?? const [];
                    final features = [
                      ...Feature.values.where((f) => wanted.contains(f.name)),
                      ...Feature.values.where((f) => !wanted.contains(f.name)),
                    ];
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
    final l = context.l10n;
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
                      l.homeSosTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      l.homeSosSubtitle,
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
    final l = context.l10n;
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
    String spokenDose(Dose d) {
      final name = d.medicine.name;
      final dosage = d.medicine.dosage;
      final time = formatTime(context, d.time);
      final due = d.status == DoseStatus.due;
      if (dosage.isEmpty) {
        return due
            ? l.homeSpokenDoseDue(name, time)
            : l.homeSpokenDoseNext(name, time);
      }
      return due
          ? l.homeSpokenDoseDueWithDosage(name, dosage, time)
          : l.homeSpokenDoseNextWithDosage(name, dosage, time);
    }

    final spoken = [
      if (profile != null)
        l.homeSpokenGreeting(greeting(l, now), profile.callName),
      l.homeSpokenToday(DateFormat('EEEE d MMMM').format(now)),
      if (doses.isEmpty)
        l.homeSpokenNoMedicines
      else if (nextDose == null)
        l.homeSpokenAllTaken
      else
        spokenDose(nextDose),
      for (final m in runningLow) l.homeSpokenRefill(m.name),
      if (nextAppt != null)
        l.homeSpokenAppointment(
          nextAppt.doctor,
          formatDay(context, nextAppt.dateTime, now: now).toLowerCase(),
          formatTime(context, nextAppt.dateTime),
        ),
    ].join(' ');

    final Widget medicineRow;
    if (doses.isEmpty) {
      medicineRow = ListTile(
        leading: IconBadge(
          Feature.medicines.icon,
          color: Feature.medicines.color,
        ),
        title: Text(l.homeNoMedicines),
        subtitle: Text(l.homeNoMedicinesHint),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => openFeature(context, Feature.medicines),
      );
    } else if (pending.isEmpty) {
      medicineRow = ListTile(
        leading: IconBadge(
          Icons.check_circle_rounded,
          color: Feature.notes.color,
        ),
        title: Text(l.homeAllMedicinesDone),
        subtitle: Text(l.homeDosesTaken(taken, doses.length)),
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
              ? l.homeTimeFor(next.medicine.name)
              : l.homeNextMedicine(next.medicine.name),
        ),
        subtitle: Text(
          '${formatTime(context, next.time)}'
          '${next.medicine.dosage.isEmpty ? '' : ' · ${next.medicine.dosage}'}',
        ),
        trailing: isDue
            ? FilledButton.tonal(
                onPressed: () => openDoseCheck(context, next),
                child: Text(l.homeCheckDose),
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
            // Wraps the button under the heading when a language's words
            // are too long to share one line.
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 4,
              children: [
                Text(l.commonToday, style: theme.textTheme.titleMedium),
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
              title: Text(l.homeRefillSoon(m.name)),
              subtitle: Text(l.homeDosesLeft(m.supply!)),
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
                l.homeAppointmentWhen(
                  formatDay(context, nextAppt.dateTime, now: now),
                  formatTime(context, nextAppt.dateTime),
                ),
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
    final l = context.l10n;
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
                feature.title(l),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: s.onPrimaryContainer,
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 2),
              Text(
                feature.description(l),
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
