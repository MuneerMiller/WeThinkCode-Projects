import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data/app_store.dart';
import 'screens/home/home_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/setup_screen.dart';
import 'security/lock_screen.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await AppStore.load();
  final services = AppServices();
  await services.notifications.init();
  runApp(ElderlyApp(store: store, services: services));
}

class ElderlyApp extends StatefulWidget {
  const ElderlyApp({super.key, required this.store, required this.services});

  final AppStore store;
  final AppServices services;

  @override
  State<ElderlyApp> createState() => _ElderlyAppState();
}

class _ElderlyAppState extends State<ElderlyApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    // Lock again when the app comes back after a while in the background.
    _lifecycle = AppLifecycleListener(
      onHide: widget.store.lock.appPaused,
      onShow: widget.store.lock.appResumed,
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final services = widget.services;
    return AppScope(
      store: store,
      services: services,
      child: MaterialApp(
        title: 'Elderly Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        // Apply the in-app text size on top of the phone's own setting.
        builder: (context, child) {
          final mq = MediaQuery.of(context);
          final scale = mq.textScaler.scale(1) * context.store.textScale;
          final locked = context.store.lock.locked;
          return MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(scale)),
            // While locked the app stays alive underneath, but hidden from
            // view, screen readers, touch and keyboard focus.
            child: Stack(
              children: [
                Offstage(
                  offstage: locked,
                  child: ExcludeSemantics(
                    excluding: locked,
                    child: ExcludeFocus(
                      excluding: locked,
                      child: TickerMode(enabled: !locked, child: child!),
                    ),
                  ),
                ),
                if (locked) const Positioned.fill(child: LockScreen()),
              ],
            ),
          );
        },
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
