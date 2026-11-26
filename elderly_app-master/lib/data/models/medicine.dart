// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

enum MedicineType {
  tablet('Tablet', Icons.medication),
  capsule('Capsule', Icons.medication_outlined),
  syrup('Syrup', Icons.local_drink),
  drops('Drops', Icons.water_drop),
  injection('Injection', Icons.vaccines),
  inhaler('Inhaler', Icons.air),
  other('Other', Icons.healing);

  const MedicineType(this.label, this.icon);
  final String label;
  final IconData icon;
}

class IntakeRecord {
  IntakeRecord({required this.date, required this.slot, required this.taken});

  factory IntakeRecord.fromJson(Map<String, dynamic> j) => IntakeRecord(
    date: j['date'],
    slot: ClockTime.parse(j['slot']),
    taken: j['taken'] == true,
  );

  /// yyyy-MM-dd of the scheduled dose.
  final String date;
  final ClockTime slot;
  final bool taken;

  Map<String, dynamic> toJson() => {
    'date': date,
    'slot': slot.key,
    'taken': taken,
  };
}

enum DoseStatus { taken, skipped, due, upcoming }

class Dose {
  const Dose(this.medicine, this.time, this.status);
  final Medicine medicine;
  final DateTime time;
  final DoseStatus status;
}

class Medicine {
  Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.times,
    this.dosage = '',
    this.supply,
    DateTime? addedOn,
    List<IntakeRecord>? history,
  }) : addedOn = addedOn ?? DateTime.now(),
       history = history ?? [];

  factory Medicine.fromJson(Map<String, dynamic> j) => Medicine(
    id: j['id'],
    name: j['name'],
    type: MedicineType.values.byName(j['type'] ?? 'other'),
    dosage: j['dosage'] ?? '',
    supply: j['supply'],
    addedOn: j['addedOn'] == null ? null : DateTime.parse(j['addedOn']),
    times: [for (final t in j['times']) ClockTime.parse(t)],
    history: [
      for (final h in (j['history'] ?? const [])) IntakeRecord.fromJson(h),
    ],
  );

  final int id;
  String name;
  MedicineType type;
  String dosage;
  List<ClockTime> times;
  List<IntakeRecord> history;

  /// When the reminder was created; earlier doses don't count as missed.
  final DateTime addedOn;

  /// Doses left in the pack, if the user tracks it.
  int? supply;

  /// Days of medicine left at the current schedule.
  int? get daysLeft => supply == null ? null : supply! ~/ times.length;

  /// Running low: three days or less left.
  bool get isLow => daysLeft != null && daysLeft! <= 3;

  IntakeRecord? recordFor(DateTime day, ClockTime slot) {
    final key = _dateKey(day);
    for (final r in history.reversed) {
      if (r.date == key && r.slot == slot) return r;
    }
    return null;
  }

  void record(DateTime day, ClockTime slot, bool taken) {
    final wasTaken = recordFor(day, slot)?.taken ?? false;
    final key = _dateKey(day);
    history.removeWhere((r) => r.date == key && r.slot == slot);
    history.add(IntakeRecord(date: key, slot: slot, taken: taken));
    // Keep the pack count in step, including when an answer is changed.
    if (supply != null && taken != wasTaken) {
      supply = (supply! + (taken ? -1 : 1)).clamp(0, 1 << 30);
    }
  }

  /// Doses taken vs. doses that were due over the last [days] days,
  /// counting answered doses and unanswered ones whose time has passed.
  ({int taken, int due}) adherence(DateTime now, {int days = 7}) {
    var taken = 0, due = 0;
    for (var d = 0; d < days; d++) {
      final day = DateTime(now.year, now.month, now.day - d);
      for (final slot in times) {
        final rec = recordFor(day, slot);
        final at = slot.on(day);
        // An answered dose always counts; an unanswered one only if its time
        // has passed since the medicine was added.
        if (rec == null && (at.isAfter(now) || at.isBefore(addedOn))) continue;
        due++;
        if (rec?.taken ?? false) taken++;
      }
    }
    return (taken: taken, due: due);
  }

  /// Today's doses. A dose becomes "due" 30 minutes before its time and stays
  /// due until it is answered.
  List<Dose> dosesOn(DateTime now) {
    final sorted = [...times]..sort();
    return [
      for (final slot in sorted) Dose(this, slot.on(now), _status(now, slot)),
    ];
  }

  DoseStatus _status(DateTime now, ClockTime slot) {
    final rec = recordFor(now, slot);
    if (rec != null) return rec.taken ? DoseStatus.taken : DoseStatus.skipped;
    final due = slot.on(now).subtract(const Duration(minutes: 30));
    return now.isBefore(due) ? DoseStatus.upcoming : DoseStatus.due;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'dosage': dosage,
    'supply': supply,
    'addedOn': addedOn.toIso8601String(),
    'times': [for (final t in times) t.key],
    'history': [for (final h in history) h.toJson()],
  };
}
