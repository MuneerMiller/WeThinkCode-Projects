// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

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
