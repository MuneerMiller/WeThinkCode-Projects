// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

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
