// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/app_store.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../l10n/labels.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../widgets/secret_dialogs.dart';
import '../onboarding/personal_widgets.dart';
import 'profile_edit_screen.dart';

class TextSizePicker extends StatelessWidget {
  const TextSizePicker({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final sizes = {
      1.0: l.profileTextSizeNormal,
      1.15: l.profileTextSizeLarge,
      1.3: l.profileTextSizeExtraLarge,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<double>(
          showSelectedIcon: false,
          segments: [
            for (final MapEntry(:key, :value) in sizes.entries)
              ButtonSegment(
                value: key,
                // Several words wrap onto two lines; a single word too long
                // for its button is shrunk rather than broken.
                label: value.contains(' ')
                    ? Text(value, textAlign: TextAlign.center)
                    : FittedBox(fit: BoxFit.scaleDown, child: Text(value)),
              ),
          ],
          selected: {
            sizes.containsKey(store.textScale) ? store.textScale : 1.0,
          },
          onSelectionChanged: (s) => store.setTextScale(s.first),
        ),
        const SizedBox(height: 8),
        Text(
          l.profileTextSizeExplain,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class BackupCard extends StatelessWidget {
  const BackupCard({super.key});

  Future<void> _backUp(BuildContext context) async {
    final l = context.l10n;
    final store = context.store;
    final sharing = context.services.sharing;
    final password = await askNewSecret(
      context,
      title: l.backupProtectTitle,
      message: l.backupProtectMessage,
      label: l.backupPasswordLabel,
      minLength: 8,
      skipLabel: l.backupNoPassword,
      confirmLabel: l.backupUsePassword,
    );
    if (password == null || !context.mounted) return;
    final contents = await store.exportBackup(password: password);
    final stamp = DateTime.now().toIso8601String().substring(0, 10);
    final ok = await sharing.shareFile(
      'elderly-care-backup-$stamp.json',
      contents,
      subject: l.backupShareSubject,
    );
    if (context.mounted) {
      showMessage(context, ok ? l.backupReady : l.backupFailed);
    }
  }

  Future<void> _restore(BuildContext context) async {
    final l = context.l10n;
    final store = context.store;
    final sharing = context.services.sharing;
    final ok = await confirm(
      context,
      title: l.backupRestoreTitle,
      message: l.backupRestoreMessage,
      confirmLabel: l.backupChooseFile,
    );
    if (!ok || !context.mounted) return;
    final String? json;
    try {
      json = await sharing.pickBackupFile(title: l.shareBackupPickerTitle);
    } catch (_) {
      if (context.mounted) showMessage(context, l.backupCouldNotReadFile);
      return;
    }
    if (json == null || !context.mounted) return;

    String? password;
    var message = l.backupProtectedMessage;
    while (true) {
      try {
        await store.importBackup(json, password: password);
        break;
      } on BackupPasswordException catch (e) {
        if (!context.mounted) return;
        if (e.wrongPassword) {
          message = l.backupWrongPasswordRetry;
        }
        password = await askSecret(
          context,
          title: l.backupPasswordTitle,
          message: message,
          label: l.backupPassword,
          confirmLabel: l.backupRestore,
        );
        if (password == null) return;
      } on BackupException catch (e) {
        if (context.mounted) showMessage(context, backupErrorText(l, e.reason));
        return;
      } on FormatException {
        if (context.mounted) {
          showMessage(context, l.backupErrorDamaged);
        }
        return;
      }
    }
    if (context.mounted) {
      showMessage(context, l.backupRestored);
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_upload_rounded),
            title: Text(l.backupBackUp),
            subtitle: Text(l.backupBackUpSubtitle),
            onTap: () => _backUp(context),
          ),
          const Divider(indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore_rounded),
            title: Text(l.backupRestoreFrom),
            subtitle: Text(l.backupRestoreFromSubtitle),
            onTap: () => _restore(context),
          ),
        ],
      ),
    );
  }
}

/// The message shown when a backup cannot be restored.
String backupErrorText(AppLocalizations l, BackupError e) => switch (e) {
  BackupError.notBackup => l.backupErrorNotBackup,
  BackupError.tooLarge => l.backupErrorTooLarge,
  BackupError.damaged => l.backupErrorDamaged,
  BackupError.noProfile => l.backupErrorNoProfile,
  BackupError.unknownProtection => l.backupErrorUnknownProtection,
};

/// The choices from setup: what to call the user, their day and what comes
/// first on the home screen.
class MadeForYouCard extends StatelessWidget {
  const MadeForYouCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final p = store.profile!;
    final today = DateTime.now();
    final wake = p.wakeTime ?? const ClockTime(7, 0);
    final bed = p.bedTime ?? const ClockTime(21, 0);
    final first = [
      for (final f in Feature.values)
        if (p.interests?.contains(f.name) ?? false) f.title(l),
    ];

    Future<void> save(void Function(UserProfile p) change) {
      final updated = UserProfile.fromJson(p.toJson());
      change(updated);
      return store.saveProfile(updated);
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.waving_hand_rounded),
            title: Text(l.profileCallMe),
            subtitle: Text(p.callName),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProfileEditScreen(profile: p)),
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.schedule_rounded),
            title: Text(l.profileMyDay),
            subtitle: Text(
              l.profileMyDayValue(
                formatTime(context, wake.on(today)),
                formatTime(context, bed.on(today)),
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _editIn<(ClockTime, ClockTime)>(
              context,
              title: l.profileMyDay,
              initial: (wake, bed),
              builder: (value, set) => DayTimesPicker(
                wake: value.$1,
                bed: value.$2,
                onChanged: (w, b) => set((w, b)),
              ),
              onSave: (v) => save((p) {
                p.wakeTime = v.$1;
                p.bedTime = v.$2;
              }),
            ),
          ),
          const Divider(indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.home_rounded),
            title: Text(l.profileHomeFirst),
            subtitle: Text(
              first.isEmpty ? l.profileHomeFirstNone : first.join(', '),
            ),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => _editIn<Set<Feature>>(
              context,
              title: l.profileHomeFirst,
              initial: {
                for (final f in Feature.values)
                  if (p.interests?.contains(f.name) ?? false) f,
              },
              builder: (value, set) =>
                  InterestsPicker(selected: value, onChanged: set),
              onSave: (v) => save(
                (p) => p.interests = [
                  for (final f in Feature.values)
                    if (v.contains(f)) f.name,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens a small screen to change one setting, saved with the bottom button.
void _editIn<T>(
  BuildContext context, {
  required String title,
  required T initial,
  required Widget Function(T value, ValueChanged<T> set) builder,
  required Future<void> Function(T value) onSave,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) {
        var value = initial;
        return StatefulBuilder(
          builder: (context, setState) => Scaffold(
            appBar: AppBar(title: Text(title)),
            bottomNavigationBar: BottomAction(
              child: FilledButton.icon(
                onPressed: () async {
                  await onSave(value);
                  if (context.mounted) Navigator.pop(context);
                },
                icon: const Icon(Icons.check_rounded),
                label: Text(context.l10n.commonSave),
              ),
            ),
            body: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                ContentWidth(
                  child: builder(value, (v) => setState(() => value = v)),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}
