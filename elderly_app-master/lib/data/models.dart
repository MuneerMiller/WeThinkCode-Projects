// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

part 'models/clock_time.dart';
part 'models/profile.dart';
part 'models/medicine.dart';
part 'models/appointment.dart';
part 'models/note.dart';
part 'models/document.dart';
part 'models/tracker.dart';

/// yyyy-MM-dd key, shared by the models in this library.
String _dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
