// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/widgets.dart';

import 'data/app_store.dart';
import 'services/contact_service.dart';
import 'services/location_service.dart';
import 'services/notification_service.dart';
import 'services/share_service.dart';
import 'services/speech_service.dart';

class AppServices {
  AppServices({
    ContactService? contacts,
    LocationService? location,
    HospitalService? hospitals,
    NotificationService? notifications,
    ShareService? sharing,
    SpeechService? speech,
    this.jitsiServer = 'https://meet.jit.si',
  }) : contacts = contacts ?? const ContactService(),
       location = location ?? const LocationService(),
       hospitals = hospitals ?? HospitalService(),
       notifications = notifications ?? NotificationService(),
       sharing = sharing ?? const ShareService(),
       speech = speech ?? SpeechService();

  final ContactService contacts;
  final LocationService location;
  final HospitalService hospitals;
  final NotificationService notifications;
  final ShareService sharing;
  final SpeechService speech;
  final String jitsiServer;
}

/// Makes the [AppStore] and [AppServices] available to every screen and
/// rebuilds dependants whenever the store changes.
class AppScope extends InheritedNotifier<AppStore> {
  const AppScope({
    super.key,
    required AppStore store,
    required this.services,
    required super.child,
  }) : super(notifier: store);

  final AppServices services;

  static AppScope _of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!;

  static AppStore storeOf(BuildContext context) => _of(context).notifier!;

  static AppServices servicesOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.services;
}

extension AppContext on BuildContext {
  AppStore get store => AppScope.storeOf(this);
  AppServices get services => AppScope.servicesOf(this);
}
