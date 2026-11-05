// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Wall-clock time of day stored as "HH:mm" so it survives JSON round trips.
class ClockTime implements Comparable<ClockTime> {
  const ClockTime(this.hour, this.minute);

  factory ClockTime.parse(String value) {
    final parts = value.split(':');
    return ClockTime(int.parse(parts[0]), int.parse(parts[1]));
  }

  factory ClockTime.fromTimeOfDay(TimeOfDay t) => ClockTime(t.hour, t.minute);

  final int hour;
  final int minute;

  TimeOfDay get timeOfDay => TimeOfDay(hour: hour, minute: minute);

  DateTime on(DateTime day) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  String get key =>
      '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

  @override
  int compareTo(ClockTime other) =>
      (hour * 60 + minute).compareTo(other.hour * 60 + other.minute);

  @override
  bool operator ==(Object other) =>
      other is ClockTime && other.hour == hour && other.minute == minute;

  @override
  int get hashCode => Object.hash(hour, minute);

  @override
  String toString() => key;
}

String _dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

class UserProfile {
  UserProfile({
    required this.name,
    this.phone = '',
    this.email = '',
    this.age = '',
    this.gender = '',
    this.bloodGroup = '',
    this.height = '',
    this.weight = '',
    this.bloodPressure = '',
    this.bloodSugar = '',
    this.allergies = '',
    this.conditions = '',
    this.emergencyNumber = '112',
    this.nickname = '',
    this.interests,
    this.wakeTime,
    this.bedTime,
  });

  factory UserProfile.fromJson(Map<String, dynamic> j) => UserProfile(
    name: j['name'] ?? '',
    phone: j['phone'] ?? '',
    email: j['email'] ?? '',
    age: j['age'] ?? '',
    gender: j['gender'] ?? '',
    bloodGroup: j['bloodGroup'] ?? '',
    height: j['height'] ?? '',
    weight: j['weight'] ?? '',
    bloodPressure: j['bloodPressure'] ?? '',
    bloodSugar: j['bloodSugar'] ?? '',
    allergies: j['allergies'] ?? '',
    conditions: j['conditions'] ?? '',
    emergencyNumber: j['emergencyNumber'] ?? '112',
    nickname: j['nickname'] ?? '',
    interests: (j['interests'] as List?)?.whereType<String>().toList(),
    wakeTime: _parseTime(j['wakeTime']),
    bedTime: _parseTime(j['bedTime']),
  );

  static ClockTime? _parseTime(Object? v) {
    if (v is! String || !RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(v)) {
      return null;
    }
    return ClockTime.parse(v);
  }

  String name;
  String phone;
  String email;
  String age;
  String gender;
  String bloodGroup;
  String height;
  String weight;
  String bloodPressure;
  String bloodSugar;
  String allergies;
  String conditions;
  String emergencyNumber;

  /// What the user likes to be called, e.g. "Gogo" or "Mrs Smith".
  String nickname;

  /// Names of the features the user wants help with (see `Feature`), shown
  /// first on the home screen. Null when never chosen: everything is equal.
  List<String>? interests;

  /// When the user usually gets up and goes to bed, used to suggest
  /// medicine times.
  ClockTime? wakeTime;
  ClockTime? bedTime;

  String get firstName => name.trim().split(RegExp(r'\s+')).first;

  /// How the app addresses the user.
  String get callName =>
      nickname.trim().isNotEmpty ? nickname.trim() : firstName;

  /// Suggested times for up to three daily doses, fitted to the user's day:
  /// half an hour after getting up, lunchtime, and an hour before bed.
  List<ClockTime> get suggestedDoseTimes {
    const usual = [ClockTime(8, 0), ClockTime(14, 0), ClockTime(20, 0)];
    if (wakeTime == null && bedTime == null) return usual;
    final wake = wakeTime ?? const ClockTime(7, 30);
    final bed = bedTime ?? const ClockTime(21, 0);
    ClockTime shift(ClockTime t, int minutes) {
      final m = (t.hour * 60 + t.minute + minutes) % (24 * 60);
      return ClockTime(m ~/ 60, m % 60);
    }

    final morning = shift(wake, 30);
    final evening = shift(bed, -60);
    const midday = ClockTime(13, 0);
    // Fall back to the usual times if the user's day is unusual (e.g. night
    // shifts), so the three suggestions stay in order and apart.
    if (morning.compareTo(midday) >= 0 || evening.compareTo(midday) <= 0) {
      return usual;
    }
    return [morning, midday, evening];
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'age': age,
    'gender': gender,
    'bloodGroup': bloodGroup,
    'height': height,
    'weight': weight,
    'bloodPressure': bloodPressure,
    'bloodSugar': bloodSugar,
    'allergies': allergies,
    'conditions': conditions,
    'emergencyNumber': emergencyNumber,
    'nickname': nickname,
    'interests': ?interests,
    if (wakeTime != null) 'wakeTime': wakeTime!.key,
    if (bedTime != null) 'bedTime': bedTime!.key,
  };
}

class Relative {
  Relative({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.relationship = '',
  });

  factory Relative.fromJson(Map<String, dynamic> j) => Relative(
    id: j['id'],
    name: j['name'] ?? '',
    phone: j['phone'] ?? '',
    email: j['email'] ?? '',
    relationship: j['relationship'] ?? '',
  );

  final int id;
  String name;
  String phone;
  String email;
  String relationship;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'email': email,
    'relationship': relationship,
  };
}

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

class Appointment {
  Appointment({
    required this.id,
    required this.doctor,
    required this.dateTime,
    this.specialty = '',
    this.place = '',
    this.notes = '',
    this.done = false,
  });

  factory Appointment.fromJson(Map<String, dynamic> j) => Appointment(
    id: j['id'],
    doctor: j['doctor'] ?? '',
    specialty: j['specialty'] ?? '',
    place: j['place'] ?? '',
    notes: j['notes'] ?? '',
    dateTime: DateTime.parse(j['dateTime']),
    done: j['done'] == true,
  );

  final int id;
  String doctor;
  String specialty;
  String place;
  String notes;
  DateTime dateTime;
  bool done;

  bool isPast(DateTime now) => done || dateTime.isBefore(now);

  Map<String, dynamic> toJson() => {
    'id': id,
    'doctor': doctor,
    'specialty': specialty,
    'place': place,
    'notes': notes,
    'dateTime': dateTime.toIso8601String(),
    'done': done,
  };
}

enum NotePriority { high, normal }

class Note {
  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.priority,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> j) => Note(
    id: j['id'],
    title: j['title'] ?? '',
    body: j['body'] ?? '',
    priority: NotePriority.values.byName(j['priority'] ?? 'normal'),
    createdAt: DateTime.parse(j['createdAt']),
    updatedAt: DateTime.parse(j['updatedAt']),
  );

  final int id;
  String title;
  String body;
  NotePriority priority;
  final DateTime createdAt;
  DateTime updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'priority': priority.name,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class HealthDocument {
  HealthDocument({
    required this.id,
    required this.name,
    required this.imageBase64,
    required this.addedAt,
  });

  factory HealthDocument.fromJson(Map<String, dynamic> j) => HealthDocument(
    id: j['id'],
    name: j['name'] ?? '',
    imageBase64: j['image'] ?? '',
    addedAt: DateTime.parse(j['addedAt']),
  );

  final int id;
  String name;
  final String imageBase64;
  final DateTime addedAt;

  /// Decoded once so lists don't re-decode on every rebuild.
  late final Uint8List bytes = base64Decode(imageBase64);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'image': imageBase64,
    'addedAt': addedAt.toIso8601String(),
  };
}

class TrackerField {
  const TrackerField(this.key, this.label, this.unit, this.min, this.max);
  final String key;
  final String label;
  final String unit;
  final num min;
  final num max;
}

enum TrackerType {
  bloodPressure('Blood pressure', 'mmHg', Icons.favorite, Color(0xFFC62828), [
    TrackerField('systolic', 'Systolic (top number)', 'mmHg', 60, 250),
    TrackerField('diastolic', 'Diastolic (bottom number)', 'mmHg', 30, 160),
    TrackerField('pulse', 'Pulse', 'bpm', 30, 220),
  ], 'Healthy range is below 120/80 mmHg.'),
  bloodSugar('Blood sugar', 'mg/dL', Icons.bloodtype, Color(0xFF6A1B9A), [
    TrackerField('glucose', 'Blood glucose', 'mg/dL', 20, 600),
  ], 'Fasting levels of 70–100 mg/dL are typical.'),
  weight('Weight', 'kg', Icons.monitor_weight, Color(0xFF00695C), [
    TrackerField('weight', 'Weight', 'kg', 20, 300),
  ], 'Weigh yourself at the same time each day.'),
  sleep('Sleep', 'hours', Icons.bedtime, Color(0xFF283593), [
    TrackerField('hours', 'Hours slept', 'h', 0, 24),
    TrackerField('minutes', 'Extra minutes', 'min', 0, 59),
  ], 'Most adults need 7–8 hours of sleep.');

  const TrackerType(
    this.label,
    this.unit,
    this.icon,
    this.color,
    this.fields,
    this.tip,
  );

  final String label;
  final String unit;
  final IconData icon;
  final Color color;
  final List<TrackerField> fields;
  final String tip;
}

class TrackerEntry {
  TrackerEntry({
    required this.id,
    required this.type,
    required this.at,
    required this.values,
    this.notes = '',
  });

  factory TrackerEntry.fromJson(Map<String, dynamic> j) => TrackerEntry(
    id: j['id'],
    type: TrackerType.values.byName(j['type']),
    at: DateTime.parse(j['at']),
    values: {
      for (final e in (j['values'] as Map).entries)
        e.key as String: e.value as num,
    },
    notes: j['notes'] ?? '',
  );

  final int id;
  final TrackerType type;
  final DateTime at;
  final Map<String, num> values;
  final String notes;

  /// Single value plotted on the chart.
  double get chartValue => switch (type) {
    TrackerType.bloodPressure => values['systolic']!.toDouble(),
    TrackerType.bloodSugar => values['glucose']!.toDouble(),
    TrackerType.weight => values['weight']!.toDouble(),
    TrackerType.sleep => values['hours']! + (values['minutes'] ?? 0) / 60.0,
  };

  String get display => switch (type) {
    TrackerType.bloodPressure =>
      '${values['systolic']}/${values['diastolic']} mmHg · ${values['pulse']} bpm',
    TrackerType.bloodSugar => '${values['glucose']} mg/dL',
    TrackerType.weight => '${_trim(values['weight']!)} kg',
    TrackerType.sleep => '${values['hours']} h ${values['minutes'] ?? 0} min',
  };

  static String _trim(num n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toStringAsFixed(1);

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'at': at.toIso8601String(),
    'values': values,
    'notes': notes,
  };
}
