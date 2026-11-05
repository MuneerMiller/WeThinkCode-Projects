// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import 'relative_edit_screen.dart';
import 'sos.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  void _edit(BuildContext context, [Relative? r]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => FeatureTheme(
          feature: Feature.family,
          child: RelativeEditScreen(relative: r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final relatives = [...store.relatives]
      ..sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(title: Text(l.featureFamily)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _edit(context),
        icon: const Icon(Icons.person_add_rounded, size: 28),
        label: Text(l.familyAddPerson),
      ),
      body: relatives.isEmpty
          ? Center(
              child: SingleChildScrollView(
                child: EmptyState(
                  icon: Icons.family_restroom_rounded,
                  title: l.familyNoneTitle,
                  message: l.familyNoneMessage,
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
              children: [
                ContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppTheme.sos,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(64),
                        ),
                        onPressed: () => alertFamily(context),
                        icon: const Icon(
                          Icons.share_location_rounded,
                          size: 28,
                        ),
                        label: Text(l.familyAlertEveryone),
                      ),
                      const SizedBox(height: 8),
                      for (final r in relatives) ...[
                        const SizedBox(height: 12),
                        _RelativeCard(r, onEdit: () => _edit(context, r)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _RelativeCard extends StatelessWidget {
  const _RelativeCard(this.r, {required this.onEdit});
  final Relative r;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final contacts = context.services.contacts;
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 28,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  r.name.isEmpty ? '?' : r.name[0].toUpperCase(),
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              title: Text(r.name),
              subtitle: Text(
                [
                  if (r.relationship.isNotEmpty) r.relationship,
                  r.phone,
                ].join(' · '),
              ),
              trailing: IconButton(
                tooltip: l.familyEditPerson(r.name),
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () => contacts.call(r.phone),
                      icon: const Icon(Icons.call_rounded),
                      label: Text(l.commonCall),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => contacts.sms([r.phone], ''),
                      icon: const Icon(Icons.sms_rounded),
                      label: Text(l.commonText),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
