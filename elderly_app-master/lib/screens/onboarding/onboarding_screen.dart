import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../widgets/common.dart';

class _Page {
  const _Page(this.image, this.title, this.text);
  final String image;
  final String title;
  final String text;
}

const _pages = [
  _Page(
    'assets/images/medicines.png',
    'Never miss a medicine',
    'Get a reminder when each dose is due, and let your family know if one is missed.',
  ),
  _Page(
    'assets/images/appointment.png',
    'Remember appointments',
    'Keep your doctor visits in one place and get a reminder an hour before.',
  ),
  _Page(
    'assets/images/tracker.png',
    'Track your health',
    'Record blood pressure, blood sugar, weight and sleep, and see how they change.',
  ),
  _Page(
    'assets/images/hospital.png',
    'Find help nearby',
    'See the closest hospitals and clinics with directions and phone numbers.',
  ),
  _Page(
    'assets/images/urgent.png',
    'Family is one tap away',
    'Call, text or video call your family, or send them your location in an emergency.',
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
    if (_page == _pages.length - 1) {
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
    final theme = Theme.of(context);
    final last = _page == _pages.length - 1;
    return Scaffold(
      body: SafeArea(
        child: ContentWidth(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton(
                    onPressed: () => context.store.markOnboardingSeen(),
                    child: const Text('Skip'),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  itemCount: _pages.length,
                  onPageChanged: (i) => setState(() => _page = i),
                  itemBuilder: (context, i) {
                    final p = _pages[i];
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
                  for (var i = 0; i < _pages.length; i++)
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
                    child: Text(last ? 'Get started' : 'Next'),
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
