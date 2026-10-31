import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/models.dart';
import 'reminder_plan.dart';

/// What the user did with a medicine notification.
enum DoseAction { open, taken, snooze, notYet }

class DoseResponse {
  const DoseResponse(this.action, this.dose);
  final DoseAction action;
  final DosePayload dose;
}

/// Shows phone notifications for medicines and appointments.
///
/// Call [sync] whenever data changes: it makes the phone's scheduled
/// notifications match [ReminderPlan]. Scheduled notifications need Android
/// or iOS; elsewhere (web, tests) this does nothing and the app relies on
/// its in-app reminders.
class NotificationService {
  NotificationService();

  final _plugin = FlutterLocalNotificationsPlugin();
  final _responses = StreamController<DoseResponse>.broadcast();
  DoseResponse? _launchResponse;
  bool _ready = false;

  /// Taps on medicine notifications and their buttons.
  Stream<DoseResponse> get responses => _responses.stream;

  /// The notification the app was opened from, if any (read once).
  DoseResponse? takeLaunchResponse() {
    final r = _launchResponse;
    _launchResponse = null;
    return r;
  }

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static const _doseCategory = 'dose';

  // Each button opens the app so the answer is saved in the encrypted store.
  static const _doseActions = [
    AndroidNotificationAction('taken', 'Taken', showsUserInterface: true),
    AndroidNotificationAction('snooze', 'In 10 min', showsUserInterface: true),
    AndroidNotificationAction('not_yet', 'Not yet', showsUserInterface: true),
  ];

  static const _medicineDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'medicine',
      'Medicine reminders',
      channelDescription: 'Reminds you when it is time to take a medicine',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      // Hide medicine and doctor names on a secure lock screen.
      visibility: NotificationVisibility.private,
      actions: _doseActions,
    ),
    iOS: DarwinNotificationDetails(
      categoryIdentifier: _doseCategory,
      interruptionLevel: InterruptionLevel.timeSensitive,
    ),
  );

  static const _appointmentDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'appointment',
      'Appointment reminders',
      channelDescription: 'Reminds you an hour before a doctor appointment',
      importance: Importance.high,
      priority: Priority.high,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.private,
    ),
    iOS: DarwinNotificationDetails(),
  );

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  Future<void> init() async {
    if (!supported) return;
    try {
      tz.initializeTimeZones();
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local.identifier));
      final options = {DarwinNotificationActionOption.foreground};
      await _plugin.initialize(
        settings: InitializationSettings(
          android: const AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(
            notificationCategories: [
              DarwinNotificationCategory(
                _doseCategory,
                actions: [
                  DarwinNotificationAction.plain(
                    'taken',
                    'Taken',
                    options: options,
                  ),
                  DarwinNotificationAction.plain(
                    'snooze',
                    'In 10 min',
                    options: options,
                  ),
                  DarwinNotificationAction.plain(
                    'not_yet',
                    'Not yet',
                    options: options,
                  ),
                ],
              ),
            ],
          ),
        ),
        onDidReceiveNotificationResponse: (r) {
          final response = _parse(r);
          if (response != null) _responses.add(response);
        },
      );
      final launch = await _plugin.getNotificationAppLaunchDetails();
      if (launch?.didNotificationLaunchApp ?? false) {
        final r = launch!.notificationResponse;
        if (r != null) _launchResponse = _parse(r);
      }
      await _android?.requestNotificationsPermission();
      _ready = true;
    } catch (e) {
      debugPrint('Notifications unavailable (${e.runtimeType})');
    }
  }

  static DoseResponse? _parse(NotificationResponse r) {
    final dose = DosePayload.parse(r.payload);
    if (dose == null) return null;
    final action = switch (r.actionId) {
      'taken' => DoseAction.taken,
      'snooze' => DoseAction.snooze,
      'not_yet' => DoseAction.notYet,
      _ => DoseAction.open,
    };
    return DoseResponse(action, dose);
  }

  /// Whether reminders can fire at the exact minute. Null where the question
  /// doesn't apply (iOS, web, tests).
  Future<bool?> exactTimingAllowed() async {
    if (!_ready) return null;
    try {
      return await _android?.canScheduleExactNotifications();
    } catch (_) {
      return null;
    }
  }

  /// Opens the Android setting that lets reminders fire on time.
  Future<void> requestExactTiming() async {
    if (!_ready) return;
    try {
      await _android?.requestExactAlarmsPermission();
    } catch (_) {}
  }

  bool _syncing = false;
  bool _syncAgain = false;

  /// Makes the scheduled notifications match the current data.
  Future<void> sync({
    required List<Medicine> medicines,
    required List<Appointment> appointments,
  }) async {
    if (!_ready) return;
    if (_syncing) {
      _syncAgain = true;
      return;
    }
    _syncing = true;
    try {
      do {
        _syncAgain = false;
        await _apply(
          ReminderPlan.build(
            medicines: medicines,
            appointments: appointments,
            now: DateTime.now(),
          ),
        );
      } while (_syncAgain);
    } catch (e) {
      debugPrint('Could not schedule reminders (${e.runtimeType})');
    } finally {
      _syncing = false;
    }
  }

  Future<void> _apply(List<PlannedReminder> plan) async {
    final mode = await _mode();
    final wanted = {for (final r in plan) r.id};
    for (final p in await _plugin.pendingNotificationRequests()) {
      if (!wanted.contains(p.id) && !ReminderPlan.isSnooze(p.id)) {
        await _plugin.cancel(id: p.id);
      }
    }
    for (final r in plan) {
      await _plugin.zonedSchedule(
        id: r.id,
        title: r.title,
        body: r.body,
        payload: r.payload,
        scheduledDate: tz.TZDateTime.from(r.at, tz.local),
        notificationDetails: r.isMedicine
            ? _medicineDetails
            : _appointmentDetails,
        androidScheduleMode: mode,
        matchDateTimeComponents: r.daily ? DateTimeComponents.time : null,
      );
    }
  }

  Future<AndroidScheduleMode> _mode() async =>
      (await exactTimingAllowed() ?? false)
      ? AndroidScheduleMode.exactAllowWhileIdle
      : AndroidScheduleMode.inexactAllowWhileIdle;

  /// Reminds about one dose again in [after].
  Future<void> snooze(
    Medicine m,
    DosePayload dose, {
    Duration after = const Duration(minutes: 10),
  }) async {
    if (!_ready) return;
    final slot = ([...m.times]..sort()).indexOf(dose.slot);
    await _plugin.zonedSchedule(
      id: ReminderPlan.snoozeId(m.id, slot < 0 ? 0 : slot),
      title: 'Time for ${m.name}',
      body: 'Reminding you again, as you asked.',
      payload: dose.toString(),
      scheduledDate: tz.TZDateTime.now(tz.local).add(after),
      notificationDetails: _medicineDetails,
      androidScheduleMode: await _mode(),
    );
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    await _plugin.cancelAll();
  }
}
