import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../services/contact_service.dart';
import '../../services/location_service.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../profile/medical_id_screen.dart';
import 'family_screen.dart';

/// Emergency options: call emergency services, alert family, or call one
/// relative directly.
Future<void> showSosSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final store = context.store;
      final services = context.services;
      final theme = Theme.of(sheetContext);
      final emergency = store.profile?.emergencyNumber ?? '112';
      return SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('How can we help?', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 16),
                _SosAction(
                  icon: Icons.local_phone_rounded,
                  color: AppTheme.sos,
                  title: 'Call emergency services',
                  subtitle: 'Dial $emergency',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    services.contacts.call(emergency);
                  },
                ),
                _SosAction(
                  icon: Icons.share_location_rounded,
                  color: Feature.family.color,
                  title: 'Alert my family',
                  subtitle: 'Text everyone my location',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    alertFamily(context);
                  },
                ),
                _SosAction(
                  icon: Icons.medical_information_rounded,
                  color: Feature.health.color,
                  title: 'Show my medical ID',
                  subtitle: 'Allergies, medicines and contacts for helpers',
                  onTap: () {
                    Navigator.pop(sheetContext);
                    openMedicalId(context);
                  },
                ),
                for (final r in store.relatives.take(3))
                  _SosAction(
                    icon: Icons.call_rounded,
                    color: Feature.hospitals.color,
                    title: 'Call ${r.name}',
                    subtitle: r.relationship.isEmpty
                        ? r.phone
                        : '${r.relationship} · ${r.phone}',
                    onTap: () {
                      Navigator.pop(sheetContext);
                      services.contacts.call(r.phone);
                    },
                  ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SosAction extends StatelessWidget {
  const _SosAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Card(
      child: ListTile(
        leading: IconBadge(icon, color: color),
        title: Text(title),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    ),
  );
}

/// Finds the user's location and opens a text message to every relative.
Future<void> alertFamily(BuildContext context) async {
  final store = context.store;
  final services = context.services;
  if (store.relatives.isEmpty) {
    final add = await confirm(
      context,
      title: 'No family added yet',
      message: 'Add a family member so we know who to alert.',
      confirmLabel: 'Add family',
    );
    if (add && context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FeatureTheme(
            feature: Feature.family,
            child: const FamilyScreen(),
          ),
        ),
      );
    }
    return;
  }

  final name = store.profile?.firstName ?? 'I';
  var message = '$name needs help and asked Elderly Care to alert you.';
  showMessage(context, 'Finding your location…');
  try {
    final here = await services.location.current();
    message += ' Current location: ${mapsLink(here.lat, here.lon)}';
  } on LocationException catch (e) {
    if (context.mounted) {
      showMessage(context, '${e.message} Sending without location.');
    }
  } catch (_) {
    if (context.mounted) {
      showMessage(context, 'Location unavailable. Sending without it.');
    }
  }
  await services.contacts.sms([
    for (final r in store.relatives) r.phone,
  ], message);
}
