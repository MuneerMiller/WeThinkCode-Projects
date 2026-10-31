import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
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
      showMessage(context, 'Appointment with ${a.doctor} saved');
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final a = widget.appointment!;
    final ok = await confirm(
      context,
      title: 'Delete appointment?',
      message: 'Your appointment with ${a.doctor} will be removed.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    final store = context.store;
    await store.deleteAppointment(a.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.appointment != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(editing ? 'Save changes' : 'Save appointment'),
        ),
      ),
      appBar: AppBar(
        title: Text(editing ? 'Appointment' : 'New appointment'),
        actions: [
          if (editing)
            IconButton(
              tooltip: 'Delete appointment',
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
                    decoration: const InputDecoration(
                      labelText: "Doctor's name",
                      hintText: 'e.g. Dr. Naidoo',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => requiredField(v, "the doctor's name"),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _specialty,
                    decoration: const InputDecoration(
                      labelText: 'Type of doctor (optional)',
                      hintText: 'e.g. Cardiologist',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _place,
                    decoration: const InputDecoration(
                      labelText: 'Where (optional)',
                      hintText: 'Hospital, clinic or home visit',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  const SectionHeader('When'),
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
                      trailing: const Text('Change'),
                      onTap: _pickWhen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notes,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'Questions to ask, things to bring…',
                      alignLabelWithHint: true,
                    ),
                    minLines: 3,
                    maxLines: 6,
                    textCapitalization: TextCapitalization.sentences,
                  ),
                  if (editing) ...[
                    const SizedBox(height: 12),
                    SwitchListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: const Text('I went to this appointment'),
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
