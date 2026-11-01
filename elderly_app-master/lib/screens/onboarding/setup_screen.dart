import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../l10n/l10n.dart';
import '../../l10n/labels.dart';
import '../../legal/legal.dart';
import '../../legal/legal_screens.dart';
import '../../theme.dart';
import '../../widgets/common.dart';
import '../profile/profile_screen.dart' show TextSizePicker;
import 'personal_widgets.dart';

enum _Step { you, reading, help, day, health, contact, finish }

/// First-run setup: one short question per screen, so the app can greet
/// the user by name, show what they need first, fit medicine times to their
/// day and know who to call in an emergency. Only the name is required.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _youForm = GlobalKey<FormState>();
  final _contactForm = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _nickname = TextEditingController();
  final _phone = TextEditingController();
  final _age = TextEditingController();
  final _allergies = TextEditingController();
  final _conditions = TextEditingController();
  final _relName = TextEditingController();
  final _relPhone = TextEditingController();
  final _relRelationship = TextEditingController();
  final _scroll = ScrollController();

  var _step = _Step.you;
  final _interests = <Feature>{};
  var _wake = const ClockTime(7, 0);
  var _bed = const ClockTime(21, 0);
  String _bloodGroup = '';
  bool _agreed = false;
  bool _showAgreeError = false;

  @override
  void dispose() {
    for (final c in [
      _name,
      _nickname,
      _phone,
      _age,
      _allergies,
      _conditions,
      _relName,
      _relPhone,
      _relRelationship,
    ]) {
      c.dispose();
    }
    _scroll.dispose();
    super.dispose();
  }

  bool get _optional => _step == _Step.health || _step == _Step.contact;

  void _go(_Step step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    if (_scroll.hasClients) _scroll.jumpTo(0);
  }

  void _back() => _go(_Step.values[_step.index - 1]);

  Future<void> _next() async {
    switch (_step) {
      case _Step.you:
        if (!_youForm.currentState!.validate()) return;
      case _Step.contact:
        if (!_contactForm.currentState!.validate()) return;
      case _Step.finish:
        return _finish();
      default:
    }
    _go(_Step.values[_step.index + 1]);
  }

  void _skip() {
    if (_step == _Step.contact) {
      for (final c in [_relName, _relPhone, _relRelationship]) {
        c.clear();
      }
    }
    _go(_Step.values[_step.index + 1]);
  }

  Future<void> _finish() async {
    if (!_agreed) {
      setState(() => _showAgreeError = true);
      return;
    }
    final store = context.store;
    await store.acceptLegal(LegalInfo.version);
    if (_relName.text.trim().isNotEmpty) {
      await store.saveRelative(
        Relative(
          id: store.newId(),
          name: _relName.text.trim(),
          phone: _relPhone.text.trim(),
          relationship: _relRelationship.text.trim(),
        ),
      );
    }
    await store.setShowGettingStarted(true);
    await store.saveProfile(
      UserProfile(
        name: _name.text.trim(),
        nickname: _nickname.text.trim(),
        phone: _phone.text.trim(),
        age: _age.text.trim(),
        bloodGroup: _bloodGroup,
        allergies: _allergies.text.trim(),
        conditions: _conditions.text.trim(),
        interests: [
          for (final f in Feature.values)
            if (_interests.contains(f)) f.name,
        ],
        wakeTime: _wake,
        bedTime: _bed,
      ),
    );
  }

  String get _callName {
    final nick = _nickname.text.trim();
    if (nick.isNotEmpty) return nick;
    return _name.text.trim().split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final (title, body) = switch (_step) {
      _Step.you => (l.setupWelcome, l.setupIntro),
      _Step.reading => (l.setupReadingTitle, l.setupReadingBody),
      _Step.help => (l.setupHelpTitle, l.setupHelpBody),
      _Step.day => (l.setupDayTitle, l.setupDayBody),
      _Step.health => (l.setupHealthTitle, l.setupHealthBody),
      _Step.contact => (l.setupEmergencyContact, l.setupEmergencyContactInfo),
      _Step.finish => (l.setupFinishTitle(_callName), l.setupFinishBody),
    };
    final last = _step == _Step.finish;

    return PopScope(
      canPop: _step == _Step.you,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        bottomNavigationBar: BottomAction(
          child: Row(
            children: [
              if (_step != _Step.you) ...[
                Expanded(
                  child: OutlinedButton(
                    onPressed: _back,
                    child: Text(l.commonBack),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(last ? l.setupFinish : l.commonContinue),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: ContentWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              l.setupStepOf(
                                _step.index + 1,
                                _Step.values.length,
                              ),
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          if (_optional)
                            TextButton(
                              onPressed: _skip,
                              child: Text(l.setupSkip),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ExcludeSemantics(
                        child: LinearProgressIndicator(
                          value: (_step.index + 1) / _Step.values.length,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  key: ValueKey(_step),
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  children: [
                    ContentWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_step == _Step.you) ...[
                            Image.asset(
                              'assets/images/logo.png',
                              height: 80,
                              excludeFromSemantics: true,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Semantics(
                            header: true,
                            child: Text(
                              title,
                              style: theme.textTheme.headlineMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            body,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ..._content(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _content(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    const gap = SizedBox(height: 16);
    switch (_step) {
      case _Step.you:
        return [
          Form(
            key: _youForm,
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            child: Column(
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l.setupYourName),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  validator: (v) => requiredField(v, l.setupNameRequired),
                ),
                gap,
                TextFormField(
                  controller: _nickname,
                  decoration: InputDecoration(
                    labelText: l.setupNickname,
                    hintText: l.setupNicknameHint,
                    helperText: l.setupNicknameHelp,
                    helperMaxLines: 3,
                  ),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  controller: _phone,
                  decoration: InputDecoration(labelText: l.setupYourPhone),
                  keyboardType: TextInputType.phone,
                  onFieldSubmitted: (_) => _next(),
                ),
              ],
            ),
          ),
        ];
      case _Step.reading:
        return [
          const TextSizePicker(),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconBadge(
                    Feature.medicines.icon,
                    color: Feature.medicines.color,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      l.setupReadingSample,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      case _Step.help:
        return [
          InterestsPicker(
            selected: _interests,
            onChanged: (s) => setState(
              () => _interests
                ..clear()
                ..addAll(s),
            ),
          ),
        ];
      case _Step.day:
        return [
          DayTimesPicker(
            wake: _wake,
            bed: _bed,
            onChanged: (wake, bed) => setState(() {
              _wake = wake;
              _bed = bed;
            }),
          ),
        ];
      case _Step.health:
        return [
          TextFormField(
            controller: _age,
            decoration: InputDecoration(labelText: l.profileAge),
            keyboardType: TextInputType.number,
          ),
          gap,
          DropdownButtonFormField<String>(
            initialValue: _bloodGroup,
            decoration: InputDecoration(labelText: l.profileBloodGroup),
            items: [
              DropdownMenuItem(
                value: '',
                child: Text(l.setupBloodGroupUnknown),
              ),
              for (final g in bloodGroups)
                DropdownMenuItem(value: g, child: Text(g)),
            ],
            onChanged: (v) => setState(() => _bloodGroup = v ?? ''),
          ),
          gap,
          TextFormField(
            controller: _allergies,
            decoration: InputDecoration(
              labelText: l.profileAllergies,
              hintText: l.profileAllergiesHint,
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          gap,
          TextFormField(
            controller: _conditions,
            decoration: InputDecoration(
              labelText: l.profileConditions,
              hintText: l.profileConditionsHint,
            ),
            textCapitalization: TextCapitalization.sentences,
            maxLines: null,
          ),
        ];
      case _Step.contact:
        return [
          Form(
            key: _contactForm,
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            child: Column(
              children: [
                TextFormField(
                  controller: _relName,
                  decoration: InputDecoration(labelText: l.setupTheirName),
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  controller: _relRelationship,
                  decoration: InputDecoration(
                    labelText: l.setupRelationship,
                    hintText: l.setupRelationshipHint,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  textInputAction: TextInputAction.next,
                ),
                gap,
                TextFormField(
                  controller: _relPhone,
                  decoration: InputDecoration(labelText: l.setupTheirPhone),
                  keyboardType: TextInputType.phone,
                  validator: (v) => _relName.text.trim().isNotEmpty
                      ? requiredField(v, l.setupTheirPhoneRequired)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l.setupAddMoreLater,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ];
      case _Step.finish:
        final today = DateTime.now();
        final times =
            (UserProfile(name: '')
                  ..wakeTime = _wake
                  ..bedTime = _bed)
                .suggestedDoseTimes
                .map((t) => formatTime(context, t.on(today)))
                .join(', ');
        final first = [
          for (final f in Feature.values)
            if (_interests.contains(f)) f.title(l),
        ];
        final contact = _relName.text.trim();
        Widget line(IconData icon, String text) => ListTile(
          leading: Icon(icon, color: theme.colorScheme.primary),
          title: Text(text),
        );
        return [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  line(
                    Icons.waving_hand_rounded,
                    l.setupSummaryName(_callName),
                  ),
                  if (first.isNotEmpty)
                    line(
                      Icons.home_rounded,
                      l.setupSummaryFirst(first.join(', ')),
                    ),
                  line(Icons.schedule_rounded, l.setupDaySuggestion(times)),
                  line(
                    Icons.contact_phone_rounded,
                    contact.isEmpty
                        ? l.setupSummaryNoContact
                        : l.setupSummaryContact(contact),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          LegalAgreement(
            agreed: _agreed,
            showError: _showAgreeError && !_agreed,
            onChanged: (v) => setState(() => _agreed = v),
          ),
        ];
    }
  }
}
