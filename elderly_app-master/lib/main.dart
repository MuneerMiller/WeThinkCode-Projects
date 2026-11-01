import 'dart:async';

import 'package:flutter/material.dart';

import 'app_scope.dart';
import 'data/app_store.dart';
import 'legal/legal.dart';
import 'legal/legal_screens.dart';
import 'screens/home/home_screen.dart';
import 'screens/medicines/dose_actions.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/onboarding/setup_screen.dart';
import 'security/lock_screen.dart';
import 'services/notification_service.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerExtraLicenses();
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
  final _navigator = GlobalKey<NavigatorState>();
  final _messenger = GlobalKey<ScaffoldMessengerState>();
  StreamSubscription<DoseResponse>? _doseTaps;
  Timer? _syncTimer;

  @override
  void initState() {
    super.initState();
    final store = widget.store;
    final notifications = widget.services.notifications;
    _lifecycle = AppLifecycleListener(
      // Lock again when the app comes back after a while in the background.
      onHide: store.lock.appPaused,
      onShow: () {
        store.lock.appResumed();
        _syncReminders();
      },
    );
    // Keep the phone's reminders in step with the data.
    store.addListener(_scheduleSync);
    _syncReminders();
    _doseTaps = notifications.responses.listen(_onDoseTap);
    final launch = notifications.takeLaunchResponse();
    if (launch != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onDoseTap(launch));
    }
  }

  void _scheduleSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(milliseconds: 500), _syncReminders);
  }

  void _syncReminders() => widget.services.notifications.sync(
    medicines: widget.store.medicines,
    appointments: widget.store.appointments,
  );

  void _onDoseTap(DoseResponse r) => handleDoseResponse(
    response: r,
    store: widget.store,
    services: widget.services,
    navigator: _navigator,
    messenger: _messenger,
  );

  @override
  void dispose() {
    _lifecycle.dispose();
    widget.store.removeListener(_scheduleSync);
    _doseTaps?.cancel();
    _syncTimer?.cancel();
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
        navigatorKey: _navigator,
        scaffoldMessengerKey: _messenger,
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
    if (store.profile != null) {
      // Existing users accept new or updated legal documents once.
      if (store.legalAcceptedVersion < LegalInfo.version) {
        return const LegalUpdateScreen();
      }
      return const HomeScreen();
    }
    if (!store.onboardingSeen) return const OnboardingScreen();
    return const SetupScreen();
  }
}
