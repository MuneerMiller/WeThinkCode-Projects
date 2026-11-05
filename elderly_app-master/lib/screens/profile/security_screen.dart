import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../security/app_lock.dart';
import '../../widgets/common.dart';
import '../../widgets/secret_dialogs.dart';
import '../../legal/legal.dart';
import '../../legal/legal_screens.dart';
import '../../l10n/l10n.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  static String pinMessage(AppLocalizations l, PinResult r) => switch (r) {
    PinResult.ok => '',
    PinResult.wrong => l.securityWrongPin,
    PinResult.tooManyAttempts => l.securityTooManyAttempts,
  };

  Future<void> _setPin(BuildContext context) async {
    final l = context.l10n;
    final lock = context.store.lock;
    final pin = await askNewSecret(
      context,
      title: l.securityChoosePin,
      message: l.securityChoosePinMessage,
      label: l.securityNewPin,
      digitsOnly: true,
      maxLength: 8,
    );
    if (pin == null) return;
    try {
      await lock.setPin(pin);
    } catch (_) {
      if (context.mounted) {
        showMessage(context, l.securityPinUnavailable);
      }
      return;
    }
    if (context.mounted) showMessage(context, l.securityAppLockOn);
  }

  /// Asks for the current PIN; true if it was right.
  Future<bool> _confirmCurrent(BuildContext context, String title) async {
    final l = context.l10n;
    final lock = context.store.lock;
    final pin = await askSecret(
      context,
      title: title,
      message: l.securityEnterCurrentPin,
      label: l.securityCurrentPin,
      digitsOnly: true,
    );
    if (pin == null) return false;
    final result = await lock.checkPin(pin);
    if (result != PinResult.ok && context.mounted) {
      showMessage(context, pinMessage(l, result));
    }
    return result == PinResult.ok;
  }

  Future<void> _changePin(BuildContext context) async {
    if (await _confirmCurrent(context, context.l10n.securityChangePin) &&
        context.mounted) {
      await _setPin(context);
    }
  }

  Future<void> _turnOff(BuildContext context) async {
    final l = context.l10n;
    final lock = context.store.lock;
    if (!await _confirmCurrent(context, l.securityTurnOffAppLock)) return;
    await lock.clear();
    if (context.mounted) showMessage(context, l.securityAppLockOff);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final lock = store.lock;
    final theme = Theme.of(context);

    Widget point(IconData icon, String title, String text) =>
        ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(text));

    return Scaffold(
      appBar: AppBar(title: Text(l.securityTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionHeader(l.securityAppLock),
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
                          lock.hasPin
                              ? l.securityAppLockOn
                              : l.securityAppLockOff,
                        ),
                        subtitle: Text(
                          lock.hasPin
                              ? l.securityAppLockOnDetail
                              : l.securityAppLockOffDetail,
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
                                    child: Text(l.securityLockNow),
                                  ),
                                  OutlinedButton(
                                    onPressed: () => _changePin(context),
                                    child: Text(l.securityChangePin),
                                  ),
                                  TextButton(
                                    onPressed: () => _turnOff(context),
                                    child: Text(l.securityTurnOff),
                                  ),
                                ],
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: FilledButton.icon(
                                  onPressed: () => _setPin(context),
                                  icon: const Icon(Icons.pin_rounded),
                                  label: Text(l.securityLockWithPin),
                                ),
                              ),
                      ),
                      if (lock.hasPin) ...[
                        FutureBuilder<bool>(
                          future: lock.biometrics.available(),
                          builder: (context, snap) => snap.data == true
                              ? SwitchListTile.adaptive(
                                  secondary: const Icon(
                                    Icons.fingerprint_rounded,
                                  ),
                                  title: Text(l.securityBiometrics),
                                  value: lock.biometricsEnabled,
                                  onChanged: lock.setBiometricsEnabled,
                                )
                              : const SizedBox.shrink(),
                        ),
                        SwitchListTile.adaptive(
                          secondary: const Icon(
                            Icons.medical_information_rounded,
                          ),
                          title: Text(l.securityMedicalIdWhenLocked),
                          subtitle: Text(l.securityMedicalIdWhenLockedDetail),
                          value: lock.medicalIdWhenLocked,
                          onChanged: lock.setMedicalIdWhenLocked,
                        ),
                      ],
                    ],
                  ),
                ),
                SectionHeader(l.securityHowProtected),
                Card(
                  child: Column(
                    children: [
                      point(
                        store.isEncrypted
                            ? Icons.enhanced_encryption_rounded
                            : Icons.no_encryption_gmailerrorred_rounded,
                        store.isEncrypted
                            ? l.securityEncrypted
                            : l.securityNotEncrypted,
                        store.isEncrypted
                            ? l.securityEncryptedDetail
                            : l.securityNotEncryptedDetail,
                      ),
                      point(
                        Icons.phone_android_rounded,
                        l.securityLocalOnly,
                        l.securityLocalOnlyDetail,
                      ),
                      point(
                        Icons.send_rounded,
                        l.securitySharedByChoice,
                        l.securitySharedByChoiceDetail,
                      ),
                      point(
                        Icons.travel_explore_rounded,
                        l.securityHospitalSearch,
                        l.securityHospitalSearchDetail,
                      ),
                      point(
                        Icons.videocam_rounded,
                        l.securityVideoCalls,
                        l.securityVideoCallsDetail,
                      ),
                      point(
                        Icons.cloud_off_rounded,
                        l.securityNoCloudCopy,
                        l.securityNoCloudCopyDetail,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => openLegalDoc(context, LegalDoc.privacy),
                  icon: const Icon(Icons.policy_rounded),
                  label: Text(l.securityReadPrivacyPolicy),
                ),
                const SizedBox(height: 12),
                Text(
                  l.securityEraseAnyTime,
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
