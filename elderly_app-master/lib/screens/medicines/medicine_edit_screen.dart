// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../l10n/labels.dart';
import '../../widgets/common.dart';

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
  late final _supply = TextEditingController(
    text: widget.medicine?.supply?.toString(),
  );
  late MedicineType _type = widget.medicine?.type ?? MedicineType.tablet;
  late final List<ClockTime> _times = [...?widget.medicine?.times]..sort();

  /// Times fitted to the user's day, from setup or My profile.
  late final List<ClockTime> _defaultTimes =
      (context.store.profile ?? UserProfile(name: '')).suggestedDoseTimes;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_times.isEmpty) _times.add(_defaultTimes.first);
  }

  @override
  void dispose() {
    _name.dispose();
    _dosage.dispose();
    _supply.dispose();
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
      helpText: context.l10n.medicineEditDoseTime(i + 1),
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
    final l = context.l10n;
    final store = context.store;
    final m =
        widget.medicine ??
        Medicine(id: store.newId(), name: '', type: _type, times: []);
    m
      ..name = _name.text.trim()
      ..dosage = _dosage.text.trim()
      ..supply = int.tryParse(_supply.text.trim())
      ..type = _type
      ..times = _times.toSet().toList();
    await store.saveMedicine(m);
    if (mounted) {
      showMessage(
        context,
        widget.medicine == null
            ? l.medicineEditReminderSet(m.name)
            : l.medicineEditSaved(m.name),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final l = context.l10n;
    final m = widget.medicine!;
    final ok = await confirm(
      context,
      title: l.medicineEditDeleteTitle(m.name),
      message: l.medicineEditDeleteMessage,
      confirmLabel: l.commonDelete,
      destructive: true,
    );
    if (!ok || !mounted) return;
    final store = context.store;
    await store.deleteMedicine(m.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final editing = widget.medicine != null;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(
            editing ? l.medicineEditSaveChanges : l.medicineEditSaveNew,
          ),
        ),
      ),
      appBar: AppBar(
        title: Text(editing ? l.medicineEditTitle : l.medicinesAdd),
        actions: [
          if (editing)
            IconButton(
              tooltip: l.medicineEditDeleteTooltip,
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
                    decoration: InputDecoration(
                      labelText: l.medicineEditNameLabel,
                      hintText: l.medicineEditNameHint,
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        requiredField(v, l.medicineEditNameRequired),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _dosage,
                    decoration: InputDecoration(
                      labelText: l.medicineEditDosageLabel,
                      hintText: l.medicineEditDosageHint,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _supply,
                    decoration: InputDecoration(
                      labelText: l.medicineEditSupplyLabel,
                      hintText: l.medicineEditSupplyHint,
                      helperText: l.medicineEditSupplyHelper,
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return null;
                      final n = int.tryParse(v.trim());
                      return n == null || n < 0 || n > 10000
                          ? l.medicineEditSupplyInvalid
                          : null;
                    },
                  ),
                  SectionHeader(l.medicineEditType),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final t in MedicineType.values)
                        ChoiceChip(
                          avatar: Icon(t.icon, size: 22),
                          label: Text(t.title(l)),
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
                  SectionHeader(l.medicineEditHowOften),
                  SegmentedButton<int>(
                    segments: [
                      ButtonSegment(value: 1, label: Text(l.medicineEditOnce)),
                      ButtonSegment(value: 2, label: Text(l.medicineEditTwice)),
                      ButtonSegment(
                        value: 3,
                        label: Text(l.medicineEditThreeTimes),
                      ),
                    ],
                    selected: {_times.length},
                    onSelectionChanged: (s) => _setCount(s.first),
                  ),
                  SectionHeader(l.medicineEditAtWhatTimes),
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
                          subtitle: Text(l.medicineEditDoseNumber(i + 1)),
                          trailing: Text(l.medicineEditChange),
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
