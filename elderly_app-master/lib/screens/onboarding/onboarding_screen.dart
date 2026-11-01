import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../l10n/l10n.dart';
import '../../l10n/language_setting.dart';
import '../../widgets/common.dart';

class _Page {
  const _Page(this.image, this.title, this.text);
  final String image;
  final String title;
  final String text;
}

List<_Page> _pages(AppLocalizations l) => [
  _Page(
    'assets/images/medicines.png',
    l.onboardingMedicinesTitle,
    l.onboardingMedicinesText,
  ),
  _Page(
    'assets/images/appointment.png',
    l.onboardingAppointmentsTitle,
    l.onboardingAppointmentsText,
  ),
  _Page(
    'assets/images/tracker.png',
    l.onboardingHealthTitle,
    l.onboardingHealthText,
  ),
  _Page(
    'assets/images/hospital.png',
    l.onboardingHospitalsTitle,
    l.onboardingHospitalsText,
  ),
  _Page(
    'assets/images/urgent.png',
    l.onboardingFamilyTitle,
    l.onboardingFamilyText,
  ),
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_page == _pages(context.l10n).length - 1) {
      context.store.markOnboardingSeen();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final pages = _pages(l);
    final last = _page == pages.length - 1;
    final language = context.store.languageCode;
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    // Choose the language on the first page, so someone who
                    // doesn't read English can find it.
                    if (_page == 0)
                      Flexible(
                        child: TextButton.icon(
                          onPressed: () => chooseLanguage(context),
                          icon: const Icon(Icons.translate_rounded),
                          label: Text(
                            language == null
                                ? l.languageSystem
                                : appLanguages[language]!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.store.markOnboardingSeen(),
                      child: Text(l.onboardingSkip),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final p = pages[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Image.asset(
                              p.image,
                              height: 240,
                              excludeFromSemantics: true,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            p.title,
                            style: theme.textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            p.text,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < pages.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: i == _page ? 28 : 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: i == _page
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _next,
                    child: Text(last ? l.onboardingGetStarted : l.commonNext),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
