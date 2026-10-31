import 'package:flutter/material.dart';

import '../../app_scope.dart';
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
    appBar: AppBar(title: const Text('Medical ID')),
    body: const MedicalIdView(
      footer: 'Keep your details up to date in My profile.',
    ),
  );
}

/// The Medical ID itself; also shown on the lock screen, so it must not need
/// a Navigator or Overlay (no tooltips, dialogs or routes).
class MedicalIdView extends StatelessWidget {
  const MedicalIdView({super.key, this.footer});
  final String? footer;

  @override
  Widget build(BuildContext context) {
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
                value.isEmpty ? 'Not recorded' : value,
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
                  'Medical ID for ${p.name}.',
                  if (p.age.isNotEmpty) 'Age ${p.age}.',
                  if (p.bloodGroup.isNotEmpty) 'Blood group ${p.bloodGroup}.',
                  p.allergies.isEmpty
                      ? 'No allergies recorded.'
                      : 'Allergies: ${p.allergies}.',
                  if (p.conditions.isNotEmpty)
                    'Medical conditions: ${p.conditions}.',
                  if (medicines.isNotEmpty)
                    'Medicines: ${medicines.map((m) => m.dosage.isEmpty ? m.name : '${m.name} ${m.dosage}').join(', ')}.',
                  for (final r in store.relatives)
                    'Emergency contact: ${r.name}'
                        '${r.relationship.isEmpty ? '' : ', ${r.relationship}'}, '
                        '${r.phone.replaceAll(' ', '').split('').join(' ')}.',
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
                              Expanded(child: fact('Age', p.age)),
                              Expanded(
                                child: fact('Blood group', p.bloodGroup),
                              ),
                            ],
                          ),
                          fact('Allergies', p.allergies, important: true),
                          fact('Medical conditions', p.conditions),
                          fact(
                            'Medicines',
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
                const SectionHeader('Emergency contacts'),
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
                          label: Text('Call', semanticsLabel: 'Call ${r.name}'),
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
