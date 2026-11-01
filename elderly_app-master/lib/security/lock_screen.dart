import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../app_scope.dart';
import '../l10n/l10n.dart';
import '../screens/profile/medical_id_screen.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'app_lock.dart';

enum _Panel { pin, emergency, forgot }

/// Shown over the whole app while it is locked.
///
/// It sits above the app's Navigator, so it avoids anything that needs one
/// (dialogs, tooltips, text fields): the PIN is typed on a built-in keypad.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  String _pin = '';
  String? _error;
  bool _checking = false;
  bool _confirmErase = false;
  _Panel _panel = _Panel.pin;
  Timer? _ticker;
  final _focus = FocusNode(debugLabel: 'lock screen');

  AppLock get _lock => context.store.lock;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _lock.retryAt != null) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Take keyboard focus from whatever was focused in the hidden app.
      _focus.requestFocus();
      _tryBiometrics();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _focus.dispose();
    super.dispose();
  }

  Future<void> _tryBiometrics() async {
    if (!mounted || !_lock.biometricsEnabled) return;
    await _lock.unlockWithBiometrics();
  }

  void _digit(String d) {
    if (_checking || _pin.length >= 8 || _lock.retryAt != null) return;
    setState(() {
      _pin += d;
      _error = null;
    });
  }

  void _backspace() {
    if (_pin.isEmpty) return;
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _submit() async {
    if (_checking || _pin.length < 4) {
      if (_pin.isNotEmpty && _pin.length < 4) {
        setState(() => _error = context.l10n.lockPinTooShort);
      }
      return;
    }
    setState(() => _checking = true);
    final result = await _lock.unlock(_pin);
    if (!mounted) return;
    final l = context.l10n;
    setState(() {
      _checking = false;
      _pin = '';
      final left = AppLock.freeAttempts - _lock.failedAttempts;
      _error = switch (result) {
        PinResult.ok => null,
        PinResult.wrong => l.lockPinWrong(left),
        PinResult.tooManyAttempts => l.lockTooManyTries,
      };
    });
  }

  KeyEventResult _onKey(FocusNode _, KeyEvent e) {
    if (e is! KeyDownEvent || _panel != _Panel.pin) {
      return KeyEventResult.ignored;
    }
    final ch = e.character;
    if (ch != null && RegExp(r'^\d$').hasMatch(ch)) {
      _digit(ch);
    } else if (e.logicalKey == LogicalKeyboardKey.backspace) {
      _backspace();
    } else if (e.logicalKey == LogicalKeyboardKey.enter ||
        e.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _submit();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Material(
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: switch (_panel) {
            _Panel.pin => _pinPanel(theme),
            _Panel.emergency => _emergencyPanel(theme),
            _Panel.forgot => _forgotPanel(theme),
          },
        ),
      ),
    );
  }

  Widget _header(String title, {VoidCallback? onBack}) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
    child: Row(
      children: [
        if (onBack != null)
          Semantics(
            button: true,
            label: context.l10n.commonBack,
            excludeSemantics: true,
            child: IconButton(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_rounded, size: 28),
            ),
          )
        else
          const SizedBox(width: 12),
        const SizedBox(width: 8),
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
      ],
    ),
  );

  Widget _pinPanel(ThemeData theme) {
    final l = context.l10n;
    final retryAt = _lock.retryAt;
    final wait = retryAt?.difference(_lock.now());
    final message = wait != null
        ? l.lockWait(
            '${wait.inMinutes}:${(wait.inSeconds % 60).toString().padLeft(2, '0')}',
          )
        : _error;

    return LayoutBuilder(
      builder: (context, c) => SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: c.maxHeight),
          child: ContentWidth(
            maxWidth: 420,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 64,
                    excludeFromSemantics: true,
                  ),
                  const SizedBox(height: 12),
                  Text(l.lockEnterPin, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  Semantics(
                    label: l.lockPinDigitsEntered(_pin.length),
                    excludeSemantics: true,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (
                          var i = 0;
                          i < (_pin.length < 4 ? 4 : _pin.length);
                          i++
                        )
                          Container(
                            margin: const EdgeInsets.all(6),
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: i < _pin.length
                                  ? theme.colorScheme.primary
                                  : Colors.transparent,
                              border: Border.all(
                                color: theme.colorScheme.outline,
                                width: 2,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 56,
                    child: message == null
                        ? null
                        : Semantics(
                            liveRegion: true,
                            child: Text(
                              message,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                  ),
                  _Keypad(
                    enabled: retryAt == null && !_checking,
                    onDigit: _digit,
                    onBackspace: _backspace,
                    onSubmit: _submit,
                  ),
                  if (_lock.biometricsEnabled) ...[
                    const SizedBox(height: 12),
                    OutlinedButton.icon(
                      onPressed: _tryBiometrics,
                      icon: const Icon(Icons.fingerprint_rounded, size: 28),
                      label: Text(l.lockUseBiometrics),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.sos,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () =>
                              setState(() => _panel = _Panel.emergency),
                          icon: const Icon(Icons.emergency_rounded),
                          label: Text(l.lockEmergency),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextButton(
                          onPressed: () => setState(() {
                            _panel = _Panel.forgot;
                            _confirmErase = false;
                          }),
                          child: Text(l.lockForgotPin),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emergencyPanel(ThemeData theme) {
    final l = context.l10n;
    final store = context.store;
    final emergency = store.profile?.emergencyNumber ?? '112';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          l.lockEmergency,
          onBack: () => setState(() => _panel = _Panel.pin),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: ContentWidth(
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.sos,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(64),
                ),
                onPressed: () => context.services.contacts.call(emergency),
                icon: const Icon(Icons.local_phone_rounded),
                label: Text(l.lockCallNumber(emergency)),
              ),
            ),
          ),
        ),
        Expanded(
          child: _lock.medicalIdWhenLocked
              ? const MedicalIdView()
              : Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l.lockMedicalIdHidden,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _forgotPanel(ThemeData theme) {
    final l = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _header(
          l.lockForgotTitle,
          onBack: () => setState(() => _panel = _Panel.pin),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l.lockForgotBody, style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                        foregroundColor: theme.colorScheme.onError,
                      ),
                      onPressed: () async {
                        if (!_confirmErase) {
                          setState(() => _confirmErase = true);
                          return;
                        }
                        final services = context.services;
                        await services.notifications.cancelAll();
                        if (mounted) await context.store.resetEverything();
                      },
                      child: Text(
                        _confirmErase
                            ? l.lockEraseConfirm
                            : l.lockEraseEverything,
                      ),
                    ),
                    if (_confirmErase) ...[
                      const SizedBox(height: 12),
                      Text(
                        l.lockEraseWarning,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.enabled,
    required this.onDigit,
    required this.onBackspace,
    required this.onSubmit,
  });

  final bool enabled;
  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget key(
      Widget child,
      VoidCallback onTap,
      String label, {
      Color? color,
    }) => Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Semantics(
          button: true,
          label: label,
          excludeSemantics: true,
          child: Material(
            color: color ?? theme.colorScheme.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: enabled ? onTap : null,
              child: SizedBox(height: 68, child: Center(child: child)),
            ),
          ),
        ),
      ),
    );
    Widget digit(String d) => key(
      Text(d, style: theme.textTheme.headlineMedium),
      () => onDigit(d),
      d,
    );

    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Column(
        children: [
          for (final row in const [
            ['1', '2', '3'],
            ['4', '5', '6'],
            ['7', '8', '9'],
          ])
            Row(children: [for (final d in row) digit(d)]),
          Row(
            children: [
              key(
                const Icon(Icons.backspace_outlined, size: 28),
                onBackspace,
                l.lockKeyDelete,
              ),
              digit('0'),
              key(
                Icon(
                  Icons.check_rounded,
                  size: 34,
                  color: theme.colorScheme.onPrimary,
                ),
                onSubmit,
                l.lockKeyUnlock,
                color: theme.colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
