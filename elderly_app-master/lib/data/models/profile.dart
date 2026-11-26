// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

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
