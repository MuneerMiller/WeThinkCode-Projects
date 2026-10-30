import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';

const _defaultTimes = [ClockTime(8, 0), ClockTime(14, 0), ClockTime(20, 0)];

class MedicineEditScreen extends StatefulWidget {
  const MedicineEditScreen({super.key, this.medicine});
  final Medicine? medicine;

  @override
  State<MedicineEditScreen> createState() => _MedicineEditScreenState();
}

class _MedicineEditScreenState extends State<MedicineEditScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.medicine?.name);
  late final _dosage = TextEditingController(text: widget.medicine?.dosage);
  late MedicineType _type = widget.medicine?.type ?? MedicineType.tablet;
  late final List<ClockTime> _times = [...?widget.medicine?.times]..sort();

  @override
  void initState() {
    super.initState();
    if (_times.isEmpty) _times.add(_defaultTimes.first);
  }

  @override
  void dispose() {
    _name.dispose();
    _dosage.dispose();
    super.dispose();
  }

  void _setCount(int count) {
    setState(() {
      while (_times.length < count) {
        _times.add(
          _defaultTimes.firstWhere(
            (t) => !_times.contains(t),
            orElse: () => const ClockTime(12, 0),
          ),
        );
      }
      _times.removeRange(count, _times.length);
      _times.sort();
    });
  }

  Future<void> _pickTime(int i) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _times[i].timeOfDay,
      helpText: 'Dose ${i + 1} time',
    );
    if (picked != null) {
      setState(() {
        _times[i] = ClockTime.fromTimeOfDay(picked);
        _times.sort();
      });
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
    final notifications = context.services.notifications;
    final m =
        widget.medicine ??
        Medicine(id: store.newId(), name: '', type: _type, times: []);
    m
      ..name = _name.text.trim()
      ..dosage = _dosage.text.trim()
      ..type = _type
      ..times = _times.toSet().toList();
    await store.saveMedicine(m);
    await notifications.scheduleMedicine(m);
    if (mounted) {
      showMessage(
        context,
        widget.medicine == null
            ? 'Reminder set for ${m.name}'
            : 'Saved ${m.name}',
      );
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final m = widget.medicine!;
    final ok = await confirm(
      context,
      title: 'Delete ${m.name}?',
      message: 'You will no longer get reminders for this medicine.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (!ok || !mounted) return;
    final store = context.store;
    await context.services.notifications.cancelMedicine(m.id);
    await store.deleteMedicine(m.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final editing = widget.medicine != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(editing ? 'Save changes' : 'Save reminder'),
        ),
      ),
      appBar: AppBar(
        title: Text(editing ? 'Edit medicine' : 'Add medicine'),
        actions: [
          if (editing)
            IconButton(
              tooltip: 'Delete medicine',
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
                    decoration: const InputDecoration(
                      labelText: 'Medicine name',
                      hintText: 'e.g. Metformin',
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => requiredField(v, 'the medicine name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dosage,
                    decoration: const InputDecoration(
                      labelText: 'How much (optional)',
                      hintText: 'e.g. 1 tablet, 500 mg',
                    ),
                  ),
                  const SectionHeader('Type'),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final t in MedicineType.values)
                        ChoiceChip(
                          avatar: Icon(t.icon, size: 22),
                          label: Text(t.label),
                          selected: _type == t,
                          showCheckmark: false,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 10,
                          ),
                          onSelected: (_) => setState(() => _type = t),
                        ),
                    ],
                  ),
                  const SectionHeader('How many times a day?'),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 1, label: Text('Once')),
                      ButtonSegment(value: 2, label: Text('Twice')),
                      ButtonSegment(value: 3, label: Text('3 times')),
                    ],
                    selected: {_times.length},
                    onSelectionChanged: (s) => _setCount(s.first),
                  ),
                  const SectionHeader('At what times?'),
                  for (var i = 0; i < _times.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        child: ListTile(
                          leading: const Icon(Icons.alarm_rounded, size: 30),
                          title: Text(
                            _times[i].timeOfDay.format(context),
                            style: theme.textTheme.titleLarge,
                          ),
                          subtitle: Text('Dose ${i + 1}'),
                          trailing: const Text('Change'),
                          onTap: () => _pickTime(i),
                        ),
                      ),
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
