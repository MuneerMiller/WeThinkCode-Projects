import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';

class RelativeEditScreen extends StatefulWidget {
  const RelativeEditScreen({super.key, this.relative});
  final Relative? relative;

  @override
  State<RelativeEditScreen> createState() => _RelativeEditScreenState();
}

class _RelativeEditScreenState extends State<RelativeEditScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.relative?.name);
  late final _relationship = TextEditingController(
    text: widget.relative?.relationship,
  );
  late final _phone = TextEditingController(text: widget.relative?.phone);
  late final _email = TextEditingController(text: widget.relative?.email);

  @override
  void dispose() {
    for (final c in [_name, _relationship, _phone, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
    final r =
        widget.relative ?? Relative(id: store.newId(), name: '', phone: '');
    r
      ..name = _name.text.trim()
      ..relationship = _relationship.text.trim()
      ..phone = _phone.text.trim()
      ..email = _email.text.trim();
    await store.saveRelative(r);
    if (mounted) {
      showMessage(context, '${r.name} saved');
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final r = widget.relative!;
    final ok = await confirm(
      context,
      title: 'Remove ${r.name}?',
      message: 'They will no longer be alerted in an emergency.',
      confirmLabel: 'Remove',
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.store.deleteRelative(r.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.relative != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Save'),
        ),
      ),
      appBar: AppBar(
        title: Text(editing ? 'Edit family member' : 'Add family member'),
        actions: [
          if (editing)
            IconButton(
              tooltip: 'Remove family member',
              onPressed: _delete,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
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
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => requiredField(v, 'a name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _relationship,
                    decoration: const InputDecoration(
                      labelText: 'Relationship (optional)',
                      hintText: 'e.g. Son, Neighbour, Nurse',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      final missing = requiredField(v, 'a phone number');
                      if (missing != null) return missing;
                      final digits = v!.replaceAll(RegExp(r'\D'), '');
                      return digits.length < 6
                          ? 'That number looks too short'
                          : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                      labelText: 'Email (optional)',
                    ),
                    keyboardType: TextInputType.emailAddress,
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
