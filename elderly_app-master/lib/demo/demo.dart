// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_scope.dart';
import '../data/models.dart';
import '../legal/legal.dart';

/// Whether this is the public web demo, built with
/// `--dart-define=DEMO=true` (see tool/build_demo.sh).
///
/// The demo opens with sample data and forgets everything on every visit,
/// so it shows the app off without replacing the paid app.
const isDemo = bool.fromEnvironment('DEMO');

/// Replaces whatever a previous visit left with fresh sample data.
Future<void> prepareDemo() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear();
  for (final MapEntry(:key, :value) in demoPrefs(DateTime.now()).entries) {
    switch (value) {
      case final String v:
        await prefs.setString(key, v);
      case final int v:
        await prefs.setInt(key, v);
      case final bool v:
        await prefs.setBool(key, v);
    }
  }
}

String _day(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Sample data for "Margaret Smith", relative to [now] so it always looks
/// current: doses taken this week, readings, upcoming visits and family.
Map<String, Object> demoPrefs(DateTime now) {
  final today = DateTime(now.year, now.month, now.day);
  DateTime daysAgo(int n, [int hour = 8, int minute = 0]) => today
      .subtract(Duration(days: n))
      .add(Duration(hours: hour, minutes: minute));

  List<IntakeRecord> history(
    List<ClockTime> times, {
    Set<String> missed = const {},
  }) => [
    for (var d = 7; d >= 0; d--)
      for (final t in times)
        if (t.on(daysAgo(d, 0)).isBefore(now))
          IntakeRecord(
            date: _day(daysAgo(d)),
            slot: t,
            taken: !missed.contains('$d ${t.key}'),
          ),
  ];

  // One dose a little later today, so "Next" on the home screen is real.
  final soonHour = (now.hour + 2).clamp(9, 22);
  final soon = ClockTime(soonHour, 0);

  final medicines = [
    Medicine(
      id: 10,
      name: 'Metformin',
      type: MedicineType.tablet,
      dosage: '500 mg',
      times: const [ClockTime(8, 0), ClockTime(20, 0)],
      supply: 42,
      addedOn: daysAgo(30),
      history: history(
        const [ClockTime(8, 0), ClockTime(20, 0)],
        missed: {'3 20:00'},
      ),
    ),
    Medicine(
      id: 11,
      name: 'Amlodipine',
      type: MedicineType.tablet,
      dosage: '5 mg',
      times: const [ClockTime(8, 0)],
      supply: 3,
      addedOn: daysAgo(30),
      history: history(const [ClockTime(8, 0)]),
    ),
    Medicine(
      id: 12,
      name: 'Vitamin D',
      type: MedicineType.capsule,
      dosage: '1 capsule',
      times: [soon],
      addedOn: daysAgo(30),
      history: history([soon]),
    ),
  ];

  final appointments = [
    Appointment(
      id: 20,
      doctor: 'Dr. Naidoo',
      specialty: 'Cardiologist',
      place: 'Groote Schuur Hospital',
      notes: 'Bring my blood pressure readings',
      dateTime: daysAgo(-1, 10),
    ),
    Appointment(
      id: 21,
      doctor: 'Dr. van der Merwe',
      specialty: 'GP – diabetes check',
      place: 'Rondebosch Medical Centre',
      dateTime: daysAgo(-6, 14, 30),
    ),
    Appointment(
      id: 22,
      doctor: 'Sister Dlamini',
      specialty: 'Eye test',
      place: 'Day Clinic',
      dateTime: daysAgo(12, 9),
      done: true,
    ),
  ];

  var id = 100;
  final readings = <TrackerEntry>[
    for (final (i, [s, d, p]) in const [
      [134, 86, 74],
      [131, 84, 72],
      [129, 83, 71],
      [132, 85, 73],
      [127, 82, 70],
      [125, 80, 69],
      [126, 81, 70],
      [123, 79, 68],
      [124, 80, 69],
      [121, 78, 67],
    ].indexed)
      TrackerEntry(
        id: id++,
        type: TrackerType.bloodPressure,
        at: daysAgo(9 - i, 8, 30),
        values: {'systolic': s, 'diastolic': d, 'pulse': p},
        notes: i == 9 ? 'after breakfast' : '',
      ),
    for (final (i, g) in const [112, 108, 115, 104, 101, 99, 103, 97].indexed)
      TrackerEntry(
        id: id++,
        type: TrackerType.bloodSugar,
        at: daysAgo(7 - i, 7, 15),
        values: {'glucose': g},
        notes: 'fasting',
      ),
    for (final (i, w) in const [69.4, 69.1, 68.8, 68.9, 68.5, 68.2].indexed)
      TrackerEntry(
        id: id++,
        type: TrackerType.weight,
        at: daysAgo((5 - i) * 2, 7),
        values: {'weight': w},
      ),
    for (final (i, [h, m]) in const [
      [6, 30],
      [7, 15],
      [6, 45],
      [7, 40],
      [8, 0],
      [7, 20],
      [7, 50],
    ].indexed)
      TrackerEntry(
        id: id++,
        type: TrackerType.sleep,
        at: daysAgo(6 - i, 7),
        values: {'hours': h, 'minutes': m},
      ),
  ];

  final notes = [
    Note(
      id: 40,
      title: 'Ask Dr. Naidoo about my knee',
      body: 'Pain when climbing stairs in the morning.',
      priority: NotePriority.high,
      createdAt: daysAgo(2),
      updatedAt: daysAgo(1),
    ),
    Note(
      id: 41,
      title: 'Pharmacy hours',
      body: 'Mon–Sat 8:00–18:00. Closed on public holidays.',
      priority: NotePriority.normal,
      createdAt: daysAgo(5),
      updatedAt: daysAgo(5),
    ),
  ];

  final relatives = [
    Relative(
      id: 1,
      name: 'Anna Smith',
      phone: '082 555 0101',
      relationship: 'Daughter',
    ),
    Relative(
      id: 2,
      name: 'Ben Smith',
      phone: '083 555 0202',
      relationship: 'Son',
    ),
    Relative(
      id: 3,
      name: 'Thandi Mokoena',
      phone: '084 555 0303',
      relationship: 'Neighbour',
    ),
  ];

  final profile = UserProfile(
    name: 'Margaret Smith',
    nickname: 'Margaret',
    phone: '082 555 0100',
    age: '78',
    gender: 'Female',
    bloodGroup: 'O+',
    height: '162',
    weight: '68',
    allergies: 'Penicillin',
    conditions: 'Type 2 diabetes, high blood pressure',
    interests: ['medicines', 'health', 'family'],
    wakeTime: const ClockTime(7, 0),
    bedTime: const ClockTime(21, 0),
  );

  String list(Iterable<Object> items) =>
      jsonEncode([for (final i in items) (i as dynamic).toJson()]);

  return {
    'onboardingSeen': true,
    'nextId': 500,
    'legal.version': LegalInfo.version,
    'legal.acceptedAt': daysAgo(30).toIso8601String(),
    'profile': jsonEncode(profile.toJson()),
    'relatives': list(relatives),
    'medicines': list(medicines),
    'appointments': list(appointments),
    'trackerEntries': list(readings),
    'notes': list(notes),
  };
}

/// The slim strip above the demo: what it is, and a way to try the
/// first-run experience.
class DemoBanner extends StatefulWidget {
  const DemoBanner({super.key, required this.navigator});

  /// The app's navigator (this strip sits above it).
  final GlobalKey<NavigatorState> navigator;

  @override
  State<DemoBanner> createState() => _DemoBannerState();
}

class _DemoBannerState extends State<DemoBanner> {
  // In the browser, focus traversal can run when the page gains focus
  // before the first layout; keep the button out of it until then.
  bool _laidOut = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _laidOut = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Material(
      color: scheme.inverseSurface,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 8, 6),
          child: Row(
            children: [
              Icon(
                Icons.science_rounded,
                color: scheme.onInverseSurface,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Demo with sample data. Resets on reload.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onInverseSurface,
                  ),
                ),
              ),
              ExcludeFocus(
                excluding: !_laidOut,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: scheme.inversePrimary,
                    minimumSize: const Size(48, 40),
                    textStyle: theme.textTheme.labelMedium,
                  ),
                  onPressed: () => _startOver(context),
                  child: const Text('Try it as a new user'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startOver(BuildContext context) async {
    final store = context.store;
    // Back to the first screen, then a clean slate: the welcome pages and
    // the step-by-step setup follow.
    widget.navigator.currentState?.popUntil((r) => r.isFirst);
    await store.resetEverything();
  }
}
