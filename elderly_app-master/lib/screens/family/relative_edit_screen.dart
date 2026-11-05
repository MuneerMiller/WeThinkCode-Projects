// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
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
      showMessage(context, context.l10n.relativeSaved(r.name));
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final r = widget.relative!;
    final ok = await confirm(
      context,
      title: l.relativeRemoveTitle(r.name),
      message: l.relativeRemoveMessage,
      confirmLabel: l.commonRemove,
      destructive: true,
    );
    if (!ok || !mounted) return;
    await context.store.deleteRelative(r.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final editing = widget.relative != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(l.commonSave),
        ),
      ),
      appBar: AppBar(
        title: Text(editing ? l.relativeEditTitle : l.relativeAddTitle),
        actions: [
          if (editing)
            IconButton(
              tooltip: l.relativeRemove,
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
                    decoration: InputDecoration(labelText: l.relativeName),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => requiredField(v, l.relativeNameRequired),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _relationship,
                    decoration: InputDecoration(
                      labelText: l.relativeRelationship,
                      hintText: l.relativeRelationshipHint,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phone,
                    decoration: InputDecoration(labelText: l.relativePhone),
                    keyboardType: TextInputType.phone,
                    validator: (v) {
                      final missing = requiredField(v, l.relativePhoneRequired);
                      if (missing != null) return missing;
                      final digits = v!.replaceAll(RegExp(r'\D'), '');
                      return digits.length < 6 ? l.relativePhoneTooShort : null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: l.relativeEmail),
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
