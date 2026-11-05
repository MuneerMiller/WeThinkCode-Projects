// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_scope.dart';
import 'data/app_store.dart';
import 'demo/demo.dart';
import 'legal/legal.dart';
import 'l10n/l10n.dart';
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
  // Draw behind the status and navigation bars, as modern Android expects.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  registerExtraLicenses();
  if (isDemo) await prepareDemo();
  final store = await AppStore.load();
  if (isDemo) await store.lock.clear();
  final services = AppServices();
  await services.notifications.init(
    l10n: lookupAppLocalizations(appLocaleFor(store.languageCode)),
  );
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
    _language = store.languageCode;
    store.addListener(_languageChanged);
    _syncReminders();
    _doseTaps = notifications.responses.listen(_onDoseTap);
    final launch = notifications.takeLaunchResponse();
    if (launch != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _onDoseTap(launch));
    }
  }

  String? _language;

  /// Rebuilds the app in a newly chosen language (and rewrites reminders).
  void _languageChanged() {
    if (widget.store.languageCode == _language) return;
    setState(() => _language = widget.store.languageCode);
  }

  void _scheduleSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(milliseconds: 500), _syncReminders);
  }

  /// The language the app is shown in.
  void _syncReminders() => widget.services.notifications.sync(
    medicines: widget.store.medicines,
    appointments: widget.store.appointments,
    l10n: lookupAppLocalizations(appLocaleFor(widget.store.languageCode)),
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
    widget.store.removeListener(_languageChanged);
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
        onGenerateTitle: (context) => context.l10n.appTitle,
        locale: _language == null ? null : Locale(_language!),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: appLocalizationsDelegates,
        navigatorKey: _navigator,
        scaffoldMessengerKey: _messenger,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        // Apply the in-app text size on top of the phone's own setting.
        builder: (context, child) {
          final locale = Localizations.localeOf(context);
          applyIntlLocale(locale);
          services.speech.language = locale.languageCode;
          final mq = MediaQuery.of(context);
          final scale = mq.textScaler.scale(1) * context.store.textScale;
          final locked = context.store.lock.locked;
          // While locked the app stays alive underneath, but hidden from
          // view, screen readers, touch and keyboard focus.
          final app = Stack(
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
          );
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: AppTheme.overlayFor(Theme.of(context).brightness),
            child: MediaQuery(
              data: mq.copyWith(textScaler: TextScaler.linear(scale)),
              child: isDemo
                  // The demo strip sits above the app, which starts below it.
                  ? Builder(
                      builder: (context) => Column(
                        children: [
                          Semantics(
                            container: true,
                            child: DemoBanner(navigator: _navigator),
                          ),
                          Expanded(
                            // Its own container, so the app's pages don't
                            // hide the strip from screen readers.
                            child: Semantics(
                              container: true,
                              child: MediaQuery.removePadding(
                                context: context,
                                removeTop: true,
                                child: app,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : app,
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
