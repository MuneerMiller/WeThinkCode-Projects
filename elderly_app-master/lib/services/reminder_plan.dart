import '../data/models.dart';

enum ReminderKind { dose, followUp, appointment }

/// One notification the phone should show.
class PlannedReminder {
  const PlannedReminder({
    required this.id,
    required this.kind,
    required this.at,
    required this.title,
    required this.body,
    this.payload,
    this.daily = false,
  });

  final int id;
  final ReminderKind kind;

  /// When it first fires; [daily] reminders then repeat at the same time.
  final DateTime at;
  final String title;
  final String body;

  /// Identifies the dose (`dose:medicineId:HH:mm`) for medicine reminders.
  final String? payload;
  final bool daily;

  bool get isMedicine => kind != ReminderKind.appointment;

  @override
  String toString() => '$kind #$id at $at: $title';
}

/// Identifies a dose in a notification so a tap can act on it.
class DosePayload {
  const DosePayload(this.medicineId, this.slot);

  final int medicineId;
  final ClockTime slot;

  static DosePayload? parse(String? payload) {
    final parts = payload?.split(':');
    if (parts == null || parts.length != 4 || parts[0] != 'dose') return null;
    final id = int.tryParse(parts[1]);
    final h = int.tryParse(parts[2]);
    final m = int.tryParse(parts[3]);
    if (id == null || h == null || m == null || h > 23 || m > 59) return null;
    return DosePayload(id, ClockTime(h, m));
  }

  @override
  String toString() => 'dose:$medicineId:${slot.key}';

  /// The day this dose belongs to, for a notification acted on at [now]:
  /// a late-evening dose answered just after midnight counts for yesterday.
  DateTime dayFor(DateTime now) {
    final today = slot.on(now);
    return today.difference(now).inHours >= 12
        ? today.subtract(const Duration(days: 1))
        : today;
  }
}

/// Works out every notification to schedule from the app's data.
///
/// - Each dose time gets a reminder that repeats daily, so it keeps working
///   even if the app isn't opened for a long time.
/// - For the next [days] days, each dose that hasn't been answered gets a
///   follow-up [followUpAfter] later ("Did you take…?"). Answering a dose
///   removes its follow-up the next time the plan is applied.
/// - Each upcoming appointment gets a reminder an hour before.
class ReminderPlan {
  static const followUpAfter = Duration(hours: 1);
  static const days = 7;

  // Notification id ranges (Android ids are 32-bit ints).
  static int doseId(int medicineId, int slot) => 10 + medicineId * 10 + slot;
  static int followUpId(int medicineId, int slot, int day) =>
      200000000 + (medicineId * 10 + slot) * 10 + day;
  static int snoozeId(int medicineId, int slot) =>
      300000000 + medicineId * 10 + slot;
  static int appointmentId(int appointmentId) => 400000000 + appointmentId;

  static bool isSnooze(int id) => id >= 300000000 && id < 400000000;

  static List<PlannedReminder> build({
    required List<Medicine> medicines,
    required List<Appointment> appointments,
    required DateTime now,
  }) {
    final out = <PlannedReminder>[];
    for (final m in medicines) {
      final slots = [...m.times]..sort();
      for (final (i, slot) in slots.indexed) {
        final payload = DosePayload(m.id, slot).toString();
        var first = slot.on(now);
        if (!first.isAfter(now)) first = first.add(const Duration(days: 1));
        out.add(
          PlannedReminder(
            id: doseId(m.id, i),
            kind: ReminderKind.dose,
            at: first,
            daily: true,
            title: 'Time for ${m.name}',
            body: m.dosage.isEmpty
                ? 'Tap "Taken" once you have taken it.'
                : 'Take ${m.dosage}, then tap "Taken".',
            payload: payload,
          ),
        );
        for (var d = 0; d < days; d++) {
          final day = DateTime(now.year, now.month, now.day + d);
          final due = slot.on(day);
          final at = due.add(followUpAfter);
          if (!at.isAfter(now) || due.isBefore(m.addedOn)) continue;
          if (m.recordFor(day, slot) != null) continue;
          out.add(
            PlannedReminder(
              id: followUpId(m.id, i, d),
              kind: ReminderKind.followUp,
              at: at,
              title: 'Did you take your ${m.name}?',
              body:
                  'It was due at ${slot.key}. Let us know so your record '
                  'stays right.',
              payload: payload,
            ),
          );
        }
      }
    }
    for (final a in appointments) {
      final at = a.dateTime.subtract(const Duration(hours: 1));
      if (a.done || !at.isAfter(now)) continue;
      out.add(
        PlannedReminder(
          id: appointmentId(a.id),
          kind: ReminderKind.appointment,
          at: at,
          title: 'Appointment in 1 hour',
          body: [a.doctor, if (a.place.isNotEmpty) a.place].join(' · '),
        ),
      );
    }
    return out;
  }
}
