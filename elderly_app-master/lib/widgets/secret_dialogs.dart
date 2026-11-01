import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';

/// Asks for a new PIN or password, typed twice.
///
/// Returns null if cancelled, or an empty string if [skipLabel] was chosen.
Future<String?> askNewSecret(
  BuildContext context, {
  required String title,
  required String message,
  required String label,
  bool digitsOnly = false,
  int minLength = 4,
  int? maxLength,
  String? skipLabel,
  String? confirmLabel,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _SecretDialog(
      title: title,
      message: message,
      label: label,
      digitsOnly: digitsOnly,
      minLength: minLength,
      maxLength: maxLength,
      skipLabel: skipLabel,
      confirmLabel: confirmLabel ?? context.l10n.commonSave,
      repeat: true,
    ),
  );
}

/// Asks for an existing PIN or password. Returns null if cancelled.
Future<String?> askSecret(
  BuildContext context, {
  required String title,
  required String message,
  required String label,
  bool digitsOnly = false,
  String? confirmLabel,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _SecretDialog(
      title: title,
      message: message,
      label: label,
      digitsOnly: digitsOnly,
      minLength: 1,
      confirmLabel: confirmLabel ?? context.l10n.secretOk,
      repeat: false,
    ),
  );
}

class _SecretDialog extends StatefulWidget {
  const _SecretDialog({
    required this.title,
    required this.message,
    required this.label,
    required this.digitsOnly,
    required this.minLength,
    required this.confirmLabel,
    required this.repeat,
    this.maxLength,
    this.skipLabel,
  });

  final String title;
  final String message;
  final String label;
  final bool digitsOnly;
  final int minLength;
  final int? maxLength;
  final String? skipLabel;
  final String confirmLabel;
  final bool repeat;

  @override
  State<_SecretDialog> createState() => _SecretDialogState();
}

class _SecretDialogState extends State<_SecretDialog> {
  final _form = GlobalKey<FormState>();
  final _first = TextEditingController();
  final _second = TextEditingController();
  bool _show = false;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void _done() {
    if (_form.currentState!.validate()) Navigator.pop(context, _first.text);
  }

  Widget _field(
    TextEditingController c,
    String label, {
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: c,
    obscureText: !_show,
    autofocus: c == _first,
    enableSuggestions: false,
    autocorrect: false,
    keyboardType: widget.digitsOnly
        ? TextInputType.number
        : TextInputType.visiblePassword,
    inputFormatters: [
      if (widget.digitsOnly) FilteringTextInputFormatter.digitsOnly,
      if (widget.maxLength != null)
        LengthLimitingTextInputFormatter(widget.maxLength),
    ],
    decoration: InputDecoration(labelText: label),
    validator: validator,
    onFieldSubmitted: (_) => _done(),
  );

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return AlertDialog(
      title: Text(widget.title),
      scrollable: true,
      content: Form(
        key: _form,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(widget.message),
            const SizedBox(height: 16),
            _field(
              _first,
              widget.label,
              validator: (v) => (v ?? '').length < widget.minLength
                  ? (widget.digitsOnly
                        ? l.secretMinDigits(widget.minLength)
                        : l.secretMinCharacters(widget.minLength))
                  : null,
            ),
            if (widget.repeat) ...[
              const SizedBox(height: 12),
              _field(
                _second,
                l.secretTypeAgain,
                validator: (v) => v != _first.text ? l.secretNoMatch : null,
              ),
            ],
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(
                widget.digitsOnly ? l.secretShowPin : l.secretShowPassword,
              ),
              value: _show,
              onChanged: (v) => setState(() => _show = v ?? false),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l.commonCancel),
        ),
        if (widget.skipLabel != null)
          TextButton(
            onPressed: () => Navigator.pop(context, ''),
            child: Text(widget.skipLabel!),
          ),
        FilledButton(onPressed: _done, child: Text(widget.confirmLabel)),
      ],
    );
  }
}
