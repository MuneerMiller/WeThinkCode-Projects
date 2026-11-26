// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

part of '../models.dart';

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
