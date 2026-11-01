import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../services/contact_service.dart';
import '../../services/location_service.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

class HospitalsScreen extends StatefulWidget {
  const HospitalsScreen({super.key});

  @override
  State<HospitalsScreen> createState() => _HospitalsScreenState();
}

class _HospitalsScreenState extends State<HospitalsScreen> {
  Future<List<Hospital>>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Search once; later dependency changes (e.g. other data being saved)
    // must not trigger a new search.
    _future ??= _load();
  }

  Future<List<Hospital>> _load() {
    final services = context.services;
    final search = services.location.current().then(services.hospitals.near);
    // The FutureBuilder reports errors; this stops a failure that lands
    // before the next frame from also being reported as unhandled.
    search.ignore();
    return search;
  }

  void _retry() {
    setState(() {
      _future = _load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final services = context.services;
    final emergency = context.store.profile?.emergencyNumber ?? '112';
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospitals nearby'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: _retry,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.sos,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () => services.contacts.call(emergency),
                  icon: const Icon(Icons.emergency_rounded),
                  label: Text('Emergency? Call $emergency'),
                ),
                const SizedBox(height: 8),
                FutureBuilder<List<Hospital>>(
                  future: _future,
                  builder: (context, snap) {
                    if (snap.connectionState != ConnectionState.done) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 48),
                        child: Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              'Looking for hospitals near you…',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }
                    if (snap.hasError) {
                      final error = snap.error;
                      return Column(
                        children: [
                          EmptyState(
                            icon: Icons.location_off_rounded,
                            title: 'Could not search',
                            message: error is LocationException
                                ? error.message
                                : 'Please check your internet connection and try again.',
                          ),
                          OutlinedButton.icon(
                            onPressed: _retry,
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Try again'),
                          ),
                        ],
                      );
                    }
                    final hospitals = snap.data!;
                    if (hospitals.isEmpty) {
                      return const EmptyState(
                        icon: Icons.local_hospital_rounded,
                        title: 'None found within 10 km',
                        message: 'In an emergency, call the number above.',
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionHeader(
                          '${hospitals.length} places within 10 km',
                        ),
                        for (final h in hospitals)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _HospitalCard(h),
                          ),
                        Text(
                          'This list comes from OpenStreetMap and may be '
                          'incomplete or out of date. Not every place has an '
                          'emergency unit: phone first if you can.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Data © OpenStreetMap contributors',
                          style: theme.textTheme.bodySmall,
                          textAlign: TextAlign.center,
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

// Two buttons share a row, so trim the side padding to keep labels on one line.
final _compact = ButtonStyle(
  padding: WidgetStateProperty.all(
    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  ),
);

class _HospitalCard extends StatelessWidget {
  const _HospitalCard(this.h);
  final Hospital h;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final contacts = context.services.contacts;
    final km = h.distanceKm < 1
        ? '${(h.distanceKm * 1000).round()} m away'
        : '${h.distanceKm.toStringAsFixed(1)} km away';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const IconBadge(Icons.local_hospital_rounded),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(h.name, style: theme.textTheme.titleMedium),
                      Text(km, style: theme.textTheme.bodyMedium),
                      if (h.address != null)
                        Text(
                          h.address!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    style: _compact,
                    onPressed: () => contacts.openUrl(
                      directionsLink(h.location.lat, h.location.lon),
                    ),
                    icon: const Icon(Icons.directions_rounded),
                    label: const Text('Directions'),
                  ),
                ),
                if (h.phone != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: _compact,
                      onPressed: () => contacts.call(h.phone!),
                      icon: const Icon(Icons.call_rounded),
                      label: const Text('Call'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
