// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../widgets/common.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key, required this.profile});
  final UserProfile profile;

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  final _form = GlobalKey<FormState>();
  // One controller per text field; other settings (interests, times) are
  // kept as they are.
  late final Map<String, TextEditingController> _c = {
    for (final e in widget.profile.toJson().entries)
      if (e.value is String) e.key: TextEditingController(text: e.value),
  };

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final updated = UserProfile.fromJson({
      ...widget.profile.toJson(),
      for (final e in _c.entries) e.key: e.value.text.trim(),
    });
    await context.store.saveProfile(updated);
    if (mounted) {
      showMessage(context, context.l10n.profileSaved);
      Navigator.pop(context);
    }
  }

  Widget _field(
    String key,
    String label, {
    TextInputType? keyboard,
    String? hint,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: _c[key],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixText: suffix,
        ),
        keyboardType: keyboard,
        textCapitalization: keyboard == null
            ? TextCapitalization.sentences
            : TextCapitalization.none,
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    const number = TextInputType.numberWithOptions(decimal: true);
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: Text(l.profileSave),
        ),
      ),
      appBar: AppBar(title: Text(l.profileEditTitle)),
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
                  _field(
                    'name',
                    l.profileName,
                    validator: (v) => requiredField(v, l.profileNameRequired),
                  ),
                  _field(
                    'nickname',
                    l.setupNickname,
                    hint: l.setupNicknameHint,
                  ),
                  _field(
                    'phone',
                    l.profilePhone,
                    keyboard: TextInputType.phone,
                  ),
                  _field(
                    'email',
                    l.profileEmail,
                    keyboard: TextInputType.emailAddress,
                  ),
                  _field(
                    'emergencyNumber',
                    l.profileEmergencyNumber,
                    keyboard: TextInputType.phone,
                    hint: l.profileEmergencyNumberHint,
                    validator: (v) =>
                        requiredField(v, l.profileEmergencyNumberRequired),
                  ),
                  SectionHeader(l.profileMedicalDetails),
                  _field('age', l.profileAge, keyboard: TextInputType.number),
                  _field('gender', l.profileGender),
                  _field(
                    'bloodGroup',
                    l.profileBloodGroup,
                    hint: l.profileBloodGroupHint,
                  ),
                  _field(
                    'height',
                    l.profileHeight,
                    keyboard: number,
                    suffix: 'cm',
                  ),
                  _field(
                    'weight',
                    l.profileWeight,
                    keyboard: number,
                    suffix: 'kg',
                  ),
                  _field(
                    'bloodPressure',
                    l.profileUsualBloodPressure,
                    hint: l.profileBloodPressureHint,
                  ),
                  _field(
                    'bloodSugar',
                    l.profileUsualBloodSugar,
                    hint: l.profileBloodSugarHint,
                  ),
                  _field(
                    'allergies',
                    l.profileAllergies,
                    hint: l.profileAllergiesHint,
                  ),
                  _field(
                    'conditions',
                    l.profileConditions,
                    hint: l.profileConditionsHint,
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
