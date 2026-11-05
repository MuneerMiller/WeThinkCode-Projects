// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../../widgets/common.dart';

void openMedicalId(BuildContext context) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => const MedicalIdScreen()));
}

/// Key medical facts in large type, to show a paramedic, nurse or new doctor.
class MedicalIdScreen extends StatelessWidget {
  const MedicalIdScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(context.l10n.medicalIdTitle)),
    body: MedicalIdView(footer: context.l10n.medicalIdFooter),
  );
}

/// The Medical ID itself; also shown on the lock screen, so it must not need
/// a Navigator or Overlay (no tooltips, dialogs or routes).
class MedicalIdView extends StatelessWidget {
  const MedicalIdView({super.key, this.footer});
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final contacts = context.services.contacts;
    final theme = Theme.of(context);
    final p = store.profile;
    if (p == null) return const SizedBox.shrink();
    final medicines = [...store.medicines]
      ..sort((a, b) => a.name.compareTo(b.name));

    Widget fact(String label, String value, {bool important = false}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                value.isEmpty ? l.medicalIdNotRecorded : value,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: value.isEmpty
                      ? theme.colorScheme.onSurfaceVariant
                      : important
                      ? AppTheme.sos
                      : null,
                ),
              ),
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      children: [
        ContentWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ReadAloudButton(
                text: [
                  l.medicalIdSpeakTitle(p.name),
                  if (p.age.isNotEmpty) l.medicalIdSpeakAge(p.age),
                  if (p.bloodGroup.isNotEmpty)
                    l.medicalIdSpeakBloodGroup(p.bloodGroup),
                  p.allergies.isEmpty
                      ? l.medicalIdSpeakNoAllergies
                      : l.medicalIdSpeakAllergies(p.allergies),
                  if (p.conditions.isNotEmpty)
                    l.medicalIdSpeakConditions(p.conditions),
                  if (medicines.isNotEmpty)
                    l.medicalIdSpeakMedicines(
                      medicines
                          .map(
                            (m) => m.dosage.isEmpty
                                ? m.name
                                : '${m.name} ${m.dosage}',
                          )
                          .join(', '),
                    ),
                  for (final r in store.relatives)
                    r.relationship.isEmpty
                        ? l.medicalIdSpeakContact(r.name, _digits(r.phone))
                        : l.medicalIdSpeakContactWithRelationship(
                            r.name,
                            r.relationship,
                            _digits(r.phone),
                          ),
                ].join(' '),
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      color: AppTheme.sos,
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.medical_information_rounded,
                            color: Colors.white,
                            size: 36,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              p.name,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(child: fact(l.medicalIdAge, p.age)),
                              Expanded(
                                child: fact(
                                  l.medicalIdBloodGroup,
                                  p.bloodGroup,
                                ),
                              ),
                            ],
                          ),
                          fact(
                            l.medicalIdAllergies,
                            p.allergies,
                            important: true,
                          ),
                          fact(l.medicalIdConditions, p.conditions),
                          fact(
                            l.medicalIdMedicines,
                            medicines
                                .map(
                                  (m) => m.dosage.isEmpty
                                      ? m.name
                                      : '${m.name} ${m.dosage}',
                                )
                                .join('\n'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (store.relatives.isNotEmpty) ...[
                SectionHeader(l.medicalIdEmergencyContacts),
                for (final r in store.relatives)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Card(
                      child: ListTile(
                        title: Text(r.name),
                        subtitle: Text(
                          [
                            if (r.relationship.isNotEmpty) r.relationship,
                            r.phone,
                          ].join(' · '),
                        ),
                        trailing: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF15803D),
                            foregroundColor: Colors.white,
                            minimumSize: const Size(0, 52),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          onPressed: () => contacts.call(r.phone),
                          icon: const Icon(Icons.call_rounded),
                          label: Text(
                            l.commonCall,
                            semanticsLabel: l.medicalIdCallContact(r.name),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
              if (footer != null) ...[
                const SizedBox(height: 8),
                Text(
                  footer!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A phone number with spaces between the digits, so it is read aloud one
/// digit at a time.
String _digits(String phone) => phone.replaceAll(' ', '').split('').join(' ');
