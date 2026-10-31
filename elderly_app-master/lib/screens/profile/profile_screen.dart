import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';
import 'medical_id_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        value.isEmpty ? 'Not set' : value,
        style: theme.textTheme.titleMedium?.copyWith(
          color: value.isEmpty ? theme.colorScheme.onSurfaceVariant : null,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('My profile'),
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
              label: const Text('Edit'),
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
                  label: const Text('Show my medical ID'),
                ),
                const SectionHeader('Contact'),
                Card(
                  child: Column(
                    children: [
                      row(Icons.phone_rounded, 'Phone', p.phone),
                      row(Icons.email_rounded, 'Email', p.email),
                      row(
                        Icons.emergency_rounded,
                        'Emergency number',
                        p.emergencyNumber,
                      ),
                    ],
                  ),
                ),
                const SectionHeader('Medical details'),
                Card(
                  child: Column(
                    children: [
                      row(Icons.cake_rounded, 'Age', p.age),
                      row(Icons.wc_rounded, 'Gender', p.gender),
                      row(Icons.bloodtype_rounded, 'Blood group', p.bloodGroup),
                      row(
                        Icons.height_rounded,
                        'Height',
                        p.height.isEmpty ? '' : '${p.height} cm',
                      ),
                      row(
                        Icons.monitor_weight_rounded,
                        'Weight',
                        p.weight.isEmpty ? '' : '${p.weight} kg',
                      ),
                      row(
                        Icons.favorite_rounded,
                        'Usual blood pressure',
                        p.bloodPressure,
                      ),
                      row(
                        Icons.water_drop_rounded,
                        'Usual blood sugar',
                        p.bloodSugar,
                      ),
                      row(
                        Icons.warning_amber_rounded,
                        'Allergies',
                        p.allergies,
                      ),
                      row(
                        Icons.healing_rounded,
                        'Medical conditions',
                        p.conditions,
                      ),
                    ],
                  ),
                ),
                const SectionHeader('Text size'),
                const _TextSizePicker(),
                const SectionHeader('Backup'),
                const _BackupCard(),
                const SectionHeader('This app'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_rounded),
                        title: const Text('Your data stays on this device'),
                        subtitle: const Text(
                          'Nothing is uploaded. Calls and texts use your own phone.',
                        ),
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delete_forever_rounded,
                          color: theme.colorScheme.error,
                        ),
                        title: Text(
                          'Erase all my data',
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        onTap: () async {
                          final ok = await confirm(
                            context,
                            title: 'Erase everything?',
                            message:
                                'All medicines, appointments, readings, notes, documents '
                                'and family contacts will be deleted. This cannot be undone.',
                            confirmLabel: 'Erase',
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
  late final Map<String, TextEditingController> _c = {
    for (final e in widget.profile.toJson().entries)
      e.key: TextEditingController(text: e.value as String),
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
      for (final e in _c.entries) e.key: e.value.text.trim(),
    });
    await context.store.saveProfile(updated);
    if (mounted) {
      showMessage(context, 'Profile saved');
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
    const number = TextInputType.numberWithOptions(decimal: true);
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Save profile'),
        ),
      ),
      appBar: AppBar(title: const Text('Edit profile')),
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
                    'Name',
                    validator: (v) => requiredField(v, 'your name'),
                  ),
                  _field('phone', 'Phone', keyboard: TextInputType.phone),
                  _field(
                    'email',
                    'Email',
                    keyboard: TextInputType.emailAddress,
                  ),
                  _field(
                    'emergencyNumber',
                    'Emergency number',
                    keyboard: TextInputType.phone,
                    hint: '112 works from any mobile phone',
                    validator: (v) => requiredField(v, 'an emergency number'),
                  ),
                  const SectionHeader('Medical details'),
                  _field('age', 'Age', keyboard: TextInputType.number),
                  _field('gender', 'Gender'),
                  _field('bloodGroup', 'Blood group', hint: 'e.g. O+'),
                  _field('height', 'Height', keyboard: number, suffix: 'cm'),
                  _field('weight', 'Weight', keyboard: number, suffix: 'kg'),
                  _field(
                    'bloodPressure',
                    'Usual blood pressure',
                    hint: 'e.g. 120/80',
                  ),
                  _field(
                    'bloodSugar',
                    'Usual blood sugar',
                    hint: 'e.g. Normal',
                  ),
                  _field('allergies', 'Allergies', hint: 'e.g. Penicillin'),
                  _field(
                    'conditions',
                    'Medical conditions',
                    hint: 'e.g. Type 2 diabetes, high blood pressure',
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

class _TextSizePicker extends StatelessWidget {
  const _TextSizePicker();

  static final sizes = {1.0: 'Normal', 1.15: 'Large', 1.3: 'Extra large'};

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedButton<double>(
          showSelectedIcon: false,
          segments: [
            for (final MapEntry(:key, :value) in sizes.entries)
              ButtonSegment(value: key, label: Text(value)),
          ],
          selected: {
            sizes.containsKey(store.textScale) ? store.textScale : 1.0,
          },
          onSelectionChanged: (s) => store.setTextScale(s.first),
        ),
        const SizedBox(height: 8),
        Text(
          'Makes all writing in the app bigger. It adds to your phone\'s own text size.',
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
    final store = context.store;
    final sharing = context.services.sharing;
    final stamp = DateTime.now().toIso8601String().substring(0, 10);
    final ok = await sharing.shareFile(
      'elderly-care-backup-$stamp.json',
      store.exportBackup(),
      subject: 'Elderly Care backup',
    );
    if (context.mounted) {
      showMessage(
        context,
        ok
            ? 'Backup ready. Keep it somewhere safe, like your email or cloud storage.'
            : 'Could not create the backup.',
      );
    }
  }

  Future<void> _restore(BuildContext context) async {
    final store = context.store;
    final sharing = context.services.sharing;
    final ok = await confirm(
      context,
      title: 'Restore from a backup?',
      message:
          'Everything currently in the app will be replaced by what is '
          'in the backup file.',
      confirmLabel: 'Choose file',
    );
    if (!ok || !context.mounted) return;
    try {
      final json = await sharing.pickBackupFile();
      if (json == null) return;
      await store.importBackup(json);
      if (context.mounted) {
        showMessage(context, 'Backup restored');
        Navigator.of(context).popUntil((r) => r.isFirst);
      }
    } on FormatException catch (e) {
      if (context.mounted) showMessage(context, e.message);
    } catch (_) {
      if (context.mounted) showMessage(context, 'Could not read that file.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.cloud_upload_rounded),
            title: const Text('Back up my data'),
            subtitle: const Text(
              'Save everything to a file you can email to yourself or keep in the cloud.',
            ),
            onTap: () => _backUp(context),
          ),
          const Divider(indent: 20, endIndent: 20),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore_rounded),
            title: const Text('Restore from a backup'),
            subtitle: const Text(
              'Use this on a new phone to get your data back.',
            ),
            onTap: () => _restore(context),
          ),
        ],
      ),
    );
  }
}
