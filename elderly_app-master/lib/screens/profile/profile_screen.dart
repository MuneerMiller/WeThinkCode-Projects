// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
import '../../l10n/language_setting.dart';
import '../../legal/legal_screens.dart';
import '../../widgets/common.dart';
import 'medical_id_screen.dart';
import 'profile_edit_screen.dart';
import 'profile_widgets.dart';
import 'security_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final p = store.profile;
    final theme = Theme.of(context);
    if (p == null) return const Scaffold();

    Widget row(IconData icon, String label, String value) => ListTile(
      leading: Icon(icon),
      title: Text(
        label,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(
        value.isEmpty ? l.profileNotSet : value,
        style: theme.textTheme.titleMedium?.copyWith(
          color: value.isEmpty ? theme.colorScheme.onSurfaceVariant : null,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l.profileTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ProfileEditScreen(profile: p),
                ),
              ),
              icon: const Icon(Icons.edit_rounded),
              label: Text(l.commonEdit),
            ),
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
                CircleAvatar(
                  radius: 48,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    p.name.isEmpty ? '?' : p.name[0].toUpperCase(),
                    style: theme.textTheme.displaySmall?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  p.name,
                  style: theme.textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => openMedicalId(context),
                  icon: const Icon(Icons.medical_information_rounded),
                  label: Text(l.profileShowMedicalId),
                ),
                SectionHeader(l.profileMadeForYou),
                const MadeForYouCard(),
                SectionHeader(l.profileContact),
                Card(
                  child: Column(
                    children: [
                      row(Icons.phone_rounded, l.profilePhone, p.phone),
                      row(Icons.email_rounded, l.profileEmail, p.email),
                      row(
                        Icons.emergency_rounded,
                        l.profileEmergencyNumber,
                        p.emergencyNumber,
                      ),
                    ],
                  ),
                ),
                SectionHeader(l.profileMedicalDetails),
                Card(
                  child: Column(
                    children: [
                      row(Icons.cake_rounded, l.profileAge, p.age),
                      row(Icons.wc_rounded, l.profileGender, p.gender),
                      row(
                        Icons.bloodtype_rounded,
                        l.profileBloodGroup,
                        p.bloodGroup,
                      ),
                      row(
                        Icons.height_rounded,
                        l.profileHeight,
                        p.height.isEmpty ? '' : '${p.height} cm',
                      ),
                      row(
                        Icons.monitor_weight_rounded,
                        l.profileWeight,
                        p.weight.isEmpty ? '' : '${p.weight} kg',
                      ),
                      row(
                        Icons.favorite_rounded,
                        l.profileUsualBloodPressure,
                        p.bloodPressure,
                      ),
                      row(
                        Icons.water_drop_rounded,
                        l.profileUsualBloodSugar,
                        p.bloodSugar,
                      ),
                      row(
                        Icons.warning_amber_rounded,
                        l.profileAllergies,
                        p.allergies,
                      ),
                      row(
                        Icons.healing_rounded,
                        l.profileConditions,
                        p.conditions,
                      ),
                    ],
                  ),
                ),
                SectionHeader(l.profileTextSize),
                const TextSizePicker(),
                const SizedBox(height: 12),
                const Card(child: LanguageSetting()),
                SectionHeader(l.profileBackup),
                const BackupCard(),
                SectionHeader(l.profileThisApp),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_rounded),
                        title: Text(l.profilePrivacySecurity),
                        subtitle: Text(
                          store.lock.hasPin
                              ? l.profileAppLockOn
                              : l.profileSetPinHint,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SecurityScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.description_rounded),
                        title: Text(l.profileLegalAbout),
                        subtitle: Text(l.profileLegalAboutSubtitle),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const LegalHubScreen(),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete_forever_rounded,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(
                          l.profileEraseAll,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        onTap: () async {
                          final ok = await confirm(
                            context,
                            title: l.profileEraseTitle,
                            message: l.profileEraseMessage,
                            confirmLabel: l.profileEraseConfirm,
                            destructive: true,
                          );
                          if (!ok || !context.mounted) return;
                          final services = context.services;
                          final navigator = Navigator.of(context);
                          await services.notifications.cancelAll();
                          await store.resetEverything();
                          navigator.popUntil((r) => r.isFirst);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
