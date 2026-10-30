import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/models.dart';

/// Schedules phone notifications for medicines and appointments.
///
/// Scheduled notifications need Android or iOS; elsewhere (web, tests) the
/// methods do nothing and the app relies on its in-app reminders.
class NotificationService {
  NotificationService();

  final _plugin = FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  static const _medicineDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'medicine',
      'Medicine reminders',
      channelDescription: 'Reminds you when it is time to take a medicine',
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  static const _appointmentDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'appointment',
      'Appointment reminders',
      channelDescription: 'Reminds you an hour before a doctor appointment',
      importance: Importance.high,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(),
  );

  Future<void> init() async {
    if (!supported) return;
    try {
      tz.initializeTimeZones();
      final local = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(local.identifier));
      await _plugin.initialize(
        settings: const InitializationSettings(
          android: AndroidInitializationSettings('@mipmap/ic_launcher'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
      _ready = true;
    } catch (e) {
      debugPrint('Notifications unavailable: $e');
    }
  }

  // Each medicine gets ids medicine.id * 10 + slot index (max 3 slots).
  static int _medicineSlotId(int medicineId, int slot) =>
      medicineId * 10 + slot;
  static int _appointmentId(int appointmentId) => 1000000000 + appointmentId;

  Future<void> scheduleMedicine(Medicine m) async {
    if (!_ready) return;
    await cancelMedicine(m.id);
    final now = tz.TZDateTime.now(tz.local);
    for (var i = 0; i < m.times.length; i++) {
      final t = m.times[i];
      var at = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        t.hour,
        t.minute,
      );
      if (at.isBefore(now)) at = at.add(const Duration(days: 1));
      await _plugin.zonedSchedule(
        id: _medicineSlotId(m.id, i),
        title: 'Time for ${m.name}',
        body: m.dosage.isEmpty
            ? 'Open Elderly Care to confirm you took it.'
            : 'Take ${m.dosage}. Open Elderly Care to confirm.',
        scheduledDate: at,
        notificationDetails: _medicineDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  Future<void> cancelMedicine(int medicineId) async {
    if (!_ready) return;
    for (var i = 0; i < 3; i++) {
      await _plugin.cancel(id: _medicineSlotId(medicineId, i));
    }
  }

  Future<void> scheduleAppointment(Appointment a) async {
    if (!_ready) return;
    await cancelAppointment(a.id);
    final at = tz.TZDateTime.from(
      a.dateTime.subtract(const Duration(hours: 1)),
      tz.local,
    );
    if (a.done || at.isBefore(tz.TZDateTime.now(tz.local))) return;
    await _plugin.zonedSchedule(
      id: _appointmentId(a.id),
      title: 'Appointment in 1 hour',
      body: [a.doctor, if (a.place.isNotEmpty) a.place].join(' · '),
      scheduledDate: at,
      notificationDetails: _appointmentDetails,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> cancelAppointment(int appointmentId) async {
    if (!_ready) return;
    await _plugin.cancel(id: _appointmentId(appointmentId));
  }

  Future<void> cancelAll() async {
    if (!_ready) return;
    await _plugin.cancelAll();
  }
}
