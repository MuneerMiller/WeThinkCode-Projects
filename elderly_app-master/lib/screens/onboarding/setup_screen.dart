import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';
import '../profile/privacy_policy_screen.dart';

/// First-run form: who is using the app and who to contact in an emergency.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _relName = TextEditingController();
  final _relPhone = TextEditingController();
  final _relRelationship = TextEditingController();

  @override
  void dispose() {
    for (final c in [_name, _phone, _relName, _relPhone, _relRelationship]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _finish() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
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
    await store.saveProfile(
      UserProfile(name: _name.text.trim(), phone: _phone.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton(onPressed: _finish, child: const Text('Continue')),
      ),
      body: SafeArea(
        child: Form(
          key: _form,
          // Clear an error as soon as the user fixes it.
          autovalidateMode: AutovalidateMode.onUserInteractionIfError,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 88,
                      excludeFromSemantics: true,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome to Elderly Care',
                      style: theme.textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Just a few details to get you started. Everything stays on this phone.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SectionHeader('About you'),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(labelText: 'Your name'),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (v) => requiredField(v, 'your name'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        labelText: 'Your phone number (optional)',
                      ),
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                    ),
                    const SectionHeader('Emergency contact'),
                    Text(
                      'Someone we can call or text for you when you need help.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _relName,
                      decoration: const InputDecoration(
                        labelText: 'Their name',
                      ),
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _relRelationship,
                      decoration: const InputDecoration(
                        labelText: 'Relationship',
                        hintText: 'e.g. Daughter',
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _relPhone,
                      decoration: const InputDecoration(
                        labelText: 'Their phone number',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) => _relName.text.trim().isNotEmpty
                          ? requiredField(v, 'their phone number')
                          : null,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'You can add more family members later.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PrivacyPolicyScreen(),
                        ),
                      ),
                      child: const Text('How we look after your information'),
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
}
