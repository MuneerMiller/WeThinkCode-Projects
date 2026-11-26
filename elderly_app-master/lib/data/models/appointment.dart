// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

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
