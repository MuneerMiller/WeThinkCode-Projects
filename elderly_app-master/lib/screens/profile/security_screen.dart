import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../security/app_lock.dart';
import '../../widgets/common.dart';
import '../../widgets/secret_dialogs.dart';
import 'privacy_policy_screen.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  static String pinMessage(PinResult r) => switch (r) {
    PinResult.ok => '',
    PinResult.wrong => 'That PIN is not right.',
    PinResult.tooManyAttempts =>
      'Too many wrong tries. Please wait a little and try again.',
  };

  Future<void> _setPin(BuildContext context) async {
    final lock = context.store.lock;
    final pin = await askNewSecret(
      context,
      title: 'Choose a PIN',
      message:
          'You will type this PIN to open Elderly Care. Use 4 to 8 numbers '
          'that others would not guess.',
      label: 'New PIN',
      digitsOnly: true,
      maxLength: 8,
    );
    if (pin == null) return;
    try {
      await lock.setPin(pin);
    } catch (_) {
      if (context.mounted) {
        showMessage(
          context,
          'This device cannot store a PIN securely, so app lock is not '
          'available here.',
        );
      }
      return;
    }
    if (context.mounted) showMessage(context, 'App lock is on');
  }

  /// Asks for the current PIN; true if it was right.
  Future<bool> _confirmCurrent(BuildContext context, String title) async {
    final lock = context.store.lock;
    final pin = await askSecret(
      context,
      title: title,
      message: 'Enter your current PIN.',
      label: 'Current PIN',
      digitsOnly: true,
    );
    if (pin == null) return false;
    final result = await lock.checkPin(pin);
    if (result != PinResult.ok && context.mounted) {
      showMessage(context, pinMessage(result));
    }
    return result == PinResult.ok;
  }

  Future<void> _changePin(BuildContext context) async {
    if (await _confirmCurrent(context, 'Change PIN') && context.mounted) {
      await _setPin(context);
    }
  }

  Future<void> _turnOff(BuildContext context) async {
    final lock = context.store.lock;
    if (!await _confirmCurrent(context, 'Turn off app lock')) return;
    await lock.clear();
    if (context.mounted) showMessage(context, 'App lock is off');
  }

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final lock = store.lock;
    final theme = Theme.of(context);

    Widget point(IconData icon, String title, String text) =>
        ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(text));

    return Scaffold(
      appBar: AppBar(title: const Text('Privacy & security')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionHeader('App lock'),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          lock.hasPin
                              ? Icons.lock_rounded
                              : Icons.lock_open_rounded,
                        ),
                        title: Text(
                          lock.hasPin ? 'App lock is on' : 'App lock is off',
                        ),
                        subtitle: Text(
                          lock.hasPin
                              ? 'The app asks for your PIN when it opens, and '
                                    'after 2 minutes away.'
                              : 'Anyone holding your phone can see your health '
                                    'details. A PIN keeps them private.',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                        child: lock.hasPin
                            ? Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  FilledButton.tonal(
                                    onPressed: lock.lockNow,
                                    child: const Text('Lock now'),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => _changePin(context),
                                    child: const Text('Change PIN'),
                                  ),
                                  TextButton(
                                    onPressed: () => _turnOff(context),
                                    child: const Text('Turn off'),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => _setPin(context),
                                  icon: const Icon(Icons.pin_rounded),
                                  label: const Text('Lock with a PIN'),
                                ),
                              ),
                      ),
                      if (lock.hasPin) ...[
                        FutureBuilder<bool>(
                          future: lock.biometrics.available(),
                          builder: (context, snap) => snap.data == true
                              ? SwitchListTile(
                                  secondary: const Icon(
                                    Icons.fingerprint_rounded,
                                  ),
                                  title: const Text(
                                    'Unlock with fingerprint or face',
                                  ),
                                  value: lock.biometricsEnabled,
                                  onChanged: lock.setBiometricsEnabled,
                                )
                              : const SizedBox.shrink(),
                        ),
                        SwitchListTile(
                          secondary: const Icon(
                            Icons.medical_information_rounded,
                          ),
                          title: const Text('Show Medical ID when locked'),
                          subtitle: const Text(
                            'Lets paramedics see your allergies and medicines '
                            'and call for help without your PIN.',
                          ),
                          value: lock.medicalIdWhenLocked,
                          onChanged: lock.setMedicalIdWhenLocked,
                        ),
                      ],
                    ],
                  ),
                ),
                const SectionHeader('How your information is protected'),
                Card(
                  child: Column(
                    children: [
                      point(
                        store.isEncrypted
                            ? Icons.enhanced_encryption_rounded
                            : Icons.no_encryption_gmailerrorred_rounded,
                        store.isEncrypted
                            ? 'Encrypted on this device'
                            : 'Not encrypted on this device',
                        store.isEncrypted
                            ? 'Your health details are scrambled with a key '
                                  'kept in this device\'s secure storage.'
                            : 'This browser has no secure storage. Use the '
                                  'phone app, or open the website over https.',
                      ),
                      point(
                        Icons.phone_android_rounded,
                        'Kept only on this device',
                        'There is no account and no server. Nothing is '
                            'uploaded, and there are no ads or tracking.',
                      ),
                      point(
                        Icons.send_rounded,
                        'Only shared when you choose',
                        'Calls and texts go through your own phone. Health '
                            'summaries and backups only leave the app when '
                            'you send them.',
                      ),
                      point(
                        Icons.travel_explore_rounded,
                        'Hospital search',
                        'To find hospitals, your location is sent to the '
                            'free OpenStreetMap service. Nothing else about '
                            'you is sent.',
                      ),
                      point(
                        Icons.videocam_rounded,
                        'Video calls',
                        'Calls use the free Jitsi Meet service in a private '
                            'room with a long random name. Only people you '
                            'send the link to can join.',
                      ),
                      point(
                        Icons.cloud_off_rounded,
                        'No automatic cloud copy',
                        'The phone does not copy this app\'s data to the '
                            'cloud. Use "Back up my data" in My profile, '
                            'ideally with a password.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.policy_rounded),
                  label: const Text('Read the full privacy policy'),
                ),
                const SizedBox(height: 12),
                Text(
                  'You can erase everything at any time in My profile.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
