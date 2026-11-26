// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

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
