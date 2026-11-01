import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
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
    final l = context.l10n;
    final services = context.services;
    final emergency = context.store.profile?.emergencyNumber ?? '112';
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.featureHospitals),
        actions: [
          IconButton(
            tooltip: l.hospitalRefresh,
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
                  label: Text(l.hospitalEmergencyCall(emergency)),
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
                              l.hospitalSearching,
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
                            title: l.hospitalSearchFailed,
                            message: error is LocationException
                                ? error.message(l)
                                : l.hospitalCheckInternet,
                          ),
                          OutlinedButton.icon(
                            onPressed: _retry,
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(l.hospitalTryAgain),
                          ),
                        ],
                      );
                    }
                    final hospitals = snap.data!;
                    if (hospitals.isEmpty) {
                      return EmptyState(
                        icon: Icons.local_hospital_rounded,
                        title: l.hospitalNoneFound,
                        message: l.hospitalNoneFoundMessage,
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SectionHeader(l.hospitalCount(hospitals.length)),
                        for (final h in hospitals)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _HospitalCard(h),
                          ),
                        Text(
                          l.hospitalListNote,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.hospitalAttribution,
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
    final l = context.l10n;
    final theme = Theme.of(context);
    final contacts = context.services.contacts;
    final km = h.distanceKm < 1
        ? l.hospitalDistanceMeters((h.distanceKm * 1000).round())
        : l.hospitalDistanceKm(h.distanceKm.toStringAsFixed(1));
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
                    label: Text(l.hospitalDirections),
                  ),
                ),
                if (h.phone != null) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: _compact,
                      onPressed: () => contacts.call(h.phone!),
                      icon: const Icon(Icons.call_rounded),
                      label: Text(l.commonCall),
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
