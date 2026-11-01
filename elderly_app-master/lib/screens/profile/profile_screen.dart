import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';
import '../../data/app_store.dart';
import '../../widgets/secret_dialogs.dart';
import '../../legal/legal_screens.dart';
import '../../l10n/l10n.dart';
import '../../l10n/language_setting.dart';
import '../../l10n/labels.dart';
import '../../theme.dart';
import '../onboarding/personal_widgets.dart';
import 'medical_id_screen.dart';
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
                const _MadeForYouCard(),
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
                const _BackupCard(),
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

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.profile});
  final UserProfile profile;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _form = GlobalKey<FormState>();
  // One controller per text field; other settings (interests, times) are
  // kept as they are.
  late final Map<String, TextEditingController> _c = {
    for (final e in widget.profile.toJson().entries)
      if (e.value is String) e.key: TextEditingController(text: e.value),
  };

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final updated = UserProfile.fromJson({
      ...widget.profile.toJson(),
      for (final e in _c.entries) e.key: e.value.text.trim(),
    });
    await context.store.saveProfile(updated);
    if (mounted) {
      showMessage(context, context.l10n.profileSaved);
      Navigator.pop(context);
    }
  }

  Widget _field(
    String key,
    String label, {
    TextInputType? keyboard,
    String? hint,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _c[key],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
        ),
        keyboardType: keyboard,
        textCapitalization: keyboard == null
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const number = TextInputType.numberWithOptions(decimal: true);
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(l.profileSave),
        ),
      ),
      appBar: AppBar(title: Text(l.profileEditTitle)),
      body: Form(
        key: _form,
        // Clear an error as soon as the user fixes it.
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _field(
                    'name',
                    l.profileName,
                    validator: (v) => requiredField(v, l.profileNameRequired),
                  ),
                  _field(
                    'nickname',
                    l.setupNickname,
                    hint: l.setupNicknameHint,
                  ),
                  _field(
                    'phone',
                    l.profilePhone,
                    keyboard: TextInputType.phone,
                  ),
                  _field(
                    'email',
                    l.profileEmail,
                    keyboard: TextInputType.emailAddress,
                  ),
                  _field(
                    'emergencyNumber',
                    l.profileEmergencyNumber,
                    keyboard: TextInputType.phone,
                    hint: l.profileEmergencyNumberHint,
                    validator: (v) =>
                        requiredField(v, l.profileEmergencyNumberRequired),
                  ),
                  SectionHeader(l.profileMedicalDetails),
                  _field('age', l.profileAge, keyboard: TextInputType.number),
                  _field('gender', l.profileGender),
                  _field(
                    'bloodGroup',
                    l.profileBloodGroup,
                    hint: l.profileBloodGroupHint,
                  ),
                  _field(
                    'height',
                    l.profileHeight,
                    keyboard: number,
                    suffix: 'cm',
                  ),
                  _field(
                    'weight',
                    l.profileWeight,
                    keyboard: number,
                    suffix: 'kg',
                  ),
                  _field(
                    'bloodPressure',
                    l.profileUsualBloodPressure,
                    hint: l.profileBloodPressureHint,
                  ),
                  _field(
                    'bloodSugar',
                    l.profileUsualBloodSugar,
                    hint: l.profileBloodSugarHint,
                  ),
                  _field(
                    'allergies',
                    l.profileAllergies,
                    hint: l.profileAllergiesHint,
                  ),
                  _field(
                    'conditions',
                    l.profileConditions,
                    hint: l.profileConditionsHint,
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

class _BackupCard extends StatelessWidget {
  const _BackupCard();

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
class _MadeForYouCard extends StatelessWidget {
  const _MadeForYouCard();

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
