// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';

class AppointmentEditScreen extends StatefulWidget {
  const AppointmentEditScreen({super.key, this.appointment});
  final Appointment? appointment;

  @override
  State<AppointmentEditScreen> createState() => _AppointmentEditScreenState();
}

class _AppointmentEditScreenState extends State<AppointmentEditScreen> {
  final _form = GlobalKey<FormState>();
  late final _doctor = TextEditingController(text: widget.appointment?.doctor);
  late final _specialty = TextEditingController(
    text: widget.appointment?.specialty,
  );
  late final _place = TextEditingController(text: widget.appointment?.place);
  late final _notes = TextEditingController(text: widget.appointment?.notes);
  late DateTime _when = widget.appointment?.dateTime ?? _defaultTime();
  late bool _done = widget.appointment?.done ?? false;

  static DateTime _defaultTime() {
    final t = DateTime.now().add(const Duration(days: 1));
    return DateTime(t.year, t.month, t.day, 10);
  }

  @override
  void dispose() {
    for (final c in [_doctor, _specialty, _place, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickWhen() async {
    final picked = await pickDateTime(context, _when);
    if (picked != null) setState(() => _when = picked);
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
    final a =
        widget.appointment ??
        Appointment(id: store.newId(), doctor: '', dateTime: _when);
    a
      ..doctor = _doctor.text.trim()
      ..specialty = _specialty.text.trim()
      ..place = _place.text.trim()
      ..notes = _notes.text.trim()
      ..dateTime = _when
      ..done = _done;
    await store.saveAppointment(a);
    if (mounted) {
      showMessage(context, context.l10n.appointmentEditSaved(a.doctor));
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final a = widget.appointment!;
    final ok = await confirm(
      context,
      title: l.appointmentEditDeleteTitle,
      message: l.appointmentEditDeleteMessage(a.doctor),
      confirmLabel: l.commonDelete,
      destructive: true,
    );
    if (!ok || !mounted) return;
    final store = context.store;
    await store.deleteAppointment(a.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final editing = widget.appointment != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(
            editing ? l.appointmentEditSaveChanges : l.appointmentEditSaveNew,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(
          editing ? l.appointmentEditTitle : l.appointmentEditNewTitle,
        ),
        actions: [
          if (editing)
            IconButton(
              tooltip: l.appointmentEditDeleteTooltip,
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
                    controller: _doctor,
                    decoration: InputDecoration(
                      labelText: l.appointmentEditDoctorLabel,
                      hintText: l.appointmentEditDoctorHint,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        requiredField(v, l.appointmentEditDoctorRequired),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specialty,
                    decoration: InputDecoration(
                      labelText: l.appointmentEditSpecialtyLabel,
                      hintText: l.appointmentEditSpecialtyHint,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _place,
                    decoration: InputDecoration(
                      labelText: l.appointmentEditPlaceLabel,
                      hintText: l.appointmentEditPlaceHint,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  SectionHeader(l.appointmentEditWhen),
                  Card(
                    child: ListTile(
                      leading: const Icon(
                        Icons.calendar_month_rounded,
                        size: 30,
                      ),
                      title: Text(DateFormat('EEEE d MMMM y').format(_when)),
                      subtitle: Text(
                        formatTime(context, _when),
                        style: theme.textTheme.titleMedium,
                      ),
                      trailing: Text(l.appointmentEditChange),
                      onTap: _pickWhen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notes,
                    decoration: InputDecoration(
                      labelText: l.appointmentEditNotesLabel,
                      hintText: l.appointmentEditNotesHint,
                      alignLabelWithHint: true,
                    ),
                    minLines: 3,
                    maxLines: 6,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  if (editing) ...[
                    const SizedBox(height: 12),
                    SwitchListTile.adaptive(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(l.appointmentEditAttended),
                      value: _done,
                      onChanged: (v) => setState(() => _done = v),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
