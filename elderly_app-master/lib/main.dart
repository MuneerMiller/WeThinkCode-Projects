import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data/app_store.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/setup_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await AppStore.load();
  final services = AppServices();
  await services.notifications.init();
  runApp(ElderlyApp(store: store, services: services));
}

class ElderlyApp extends StatelessWidget {
  const ElderlyApp({super.key, required this.store, required this.services});

  final AppStore store;
  final AppServices services;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      store: store,
      services: services,
      child: MaterialApp(
        title: 'Elderly Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        home: const StartGate(),
      ),
    );
  }
}

/// Shows the intro and setup until a profile exists, then the home screen.
class StartGate extends StatelessWidget {
  const StartGate({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    if (store.profile != null) return const HomeScreen();
    if (!store.onboardingSeen) return const OnboardingScreen();
    return const SetupScreen();
  }
}
