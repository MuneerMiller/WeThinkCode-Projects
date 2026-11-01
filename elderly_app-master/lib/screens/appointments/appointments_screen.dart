import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'appointment_edit_screen.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  void _edit(BuildContext context, [Appointment? a]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeatureTheme(
          feature: Feature.appointments,
          child: AppointmentEditScreen(appointment: a),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final now = DateTime.now();
    final upcoming = store.upcomingAppointments(now);
    final past = store.pastAppointments(now);

    Widget list(List<Appointment> items, {required bool isPast}) {
      if (items.isEmpty) {
        return Center(
          child: SingleChildScrollView(
            child: EmptyState(
              icon: Icons.event_available_rounded,
              image: isPast ? null : 'assets/images/appointment.png',
              title: isPast
                  ? 'No past appointments'
                  : 'No upcoming appointments',
              message: isPast
                  ? 'Appointments move here once they are over.'
                  : 'Add your next doctor visit and we will remind you an hour before.',
            ),
          ),
        );
      }
      return ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
        children: [
          for (final a in items)
            ContentWidth(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AppointmentCard(
                  a,
                  isPast: isPast,
                  onTap: () => _edit(context, a),
                ),
              ),
            ),
        ],
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          bottom: TabBar(
            labelStyle: Theme.of(context).textTheme.labelLarge,
            tabs: [
              Tab(text: 'Upcoming (${upcoming.length})'),
              Tab(text: 'Past (${past.length})'),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _edit(context),
          icon: const Icon(Icons.add_rounded, size: 28),
          label: const Text('Add appointment'),
        ),
        body: TabBarView(
          children: [list(upcoming, isPast: false), list(past, isPast: true)],
        ),
      ),
    );
  }
}

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard(this.a, {required this.isPast, required this.onTap});
  final Appointment a;
  final bool isPast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 72,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isPast
                      ? scheme.surfaceContainerHighest
                      : scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('MMM').format(a.dateTime).toUpperCase(),
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isPast
                            ? scheme.onSurfaceVariant
                            : scheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${a.dateTime.day}',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: isPast
                            ? scheme.onSurfaceVariant
                            : scheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(a.doctor, style: theme.textTheme.titleMedium),
                    if (a.specialty.isNotEmpty)
                      Text(a.specialty, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(
                      '${formatDay(a.dateTime)} · ${formatTime(context, a.dateTime)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    if (a.place.isNotEmpty)
                      Text(
                        a.place,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    if (a.done)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 20,
                              color: Color(0xFF2E7D32),
                            ),
                            const SizedBox(width: 6),
                            Text('Attended', style: theme.textTheme.bodyMedium),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}
