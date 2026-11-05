// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'app_store.dart';
import 'models.dart';

/// A printable health summary for a doctor, as PDF bytes.
///
/// [regular] and [bold] are the TTF fonts to embed (the app's Lexend).
Future<Uint8List> healthSummaryPdf(
  AppStore store,
  DateTime now, {
  required ByteData regular,
  required ByteData bold,
  int days = 30,
}) async {
  final theme = pw.ThemeData.withFont(
    base: pw.Font.ttf(regular),
    bold: pw.Font.ttf(bold),
  );
  final p = store.profile;
  final since = now.subtract(Duration(days: days));
  final date = DateFormat('d MMM y');
  final when = DateFormat('d MMM y, HH:mm');
  const accent = PdfColor.fromInt(0xFF1B6B5F);
  const muted = PdfColor.fromInt(0xFF5F6B68);

  pw.Widget heading(String text) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 18, bottom: 6),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: 14,
        fontWeight: pw.FontWeight.bold,
        color: accent,
      ),
    ),
  );

  pw.Widget table(List<String>? headers, List<List<String>> rows) =>
      pw.TableHelper.fromTextArray(
        headers: headers,
        data: rows,
        headerCount: headers == null ? 0 : 1,
        headerStyle: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
          fontSize: 10,
        ),
        headerDecoration: const pw.BoxDecoration(color: accent),
        cellStyle: const pw.TextStyle(fontSize: 10),
        oddRowDecoration: const pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFF1F5F4),
        ),
        border: null,
        headerAlignment: pw.Alignment.centerLeft,
        cellPadding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 5),
      );

  final details = <List<String>>[
    if (p != null && p.age.isNotEmpty) ['Age', p.age],
    if (p != null && p.gender.isNotEmpty) ['Gender', p.gender],
    if (p != null && p.bloodGroup.isNotEmpty) ['Blood group', p.bloodGroup],
    if (p != null && p.height.isNotEmpty) ['Height', '${p.height} cm'],
    if (p != null && p.weight.isNotEmpty) ['Weight', '${p.weight} kg'],
    [
      'Allergies',
      (p?.allergies.isEmpty ?? true) ? 'None recorded' : p!.allergies,
    ],
    if (p != null && p.conditions.isNotEmpty) ['Conditions', p.conditions],
  ];

  final medicines = [...store.medicines]
    ..sort((a, b) => a.name.compareTo(b.name));
  final upcoming = store.upcomingAppointments(now).take(5).toList();

  final doc = pw.Document(
    title: 'Health summary – ${p?.name ?? ''}',
    author: 'Elderly Care',
    theme: theme,
  );
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      footer: (context) => pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Made with the Elderly Care app on ${date.format(now)}. '
            'Readings are entered by the patient.',
            style: const pw.TextStyle(fontSize: 8, color: muted),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 8, color: muted),
          ),
        ],
      ),
      build: (context) => [
        pw.Text(
          'Health summary',
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.Text(
          '${p?.name ?? ''} · ${date.format(since)} – ${date.format(now)}',
          style: const pw.TextStyle(fontSize: 12, color: muted),
        ),
        heading('About the patient'),
        table(null, details),
        if (medicines.isNotEmpty) ...[
          heading('Medicines'),
          table(
            ['Medicine', 'Dose', 'Times', 'Taken (last 7 days)'],
            [
              for (final m in medicines)
                [
                  m.name,
                  m.dosage,
                  ([...m.times]..sort()).map((t) => t.key).join(', '),
                  () {
                    final a = m.adherence(now);
                    return a.due == 0 ? '–' : '${a.taken} of ${a.due}';
                  }(),
                ],
            ],
          ),
        ],
        for (final type in TrackerType.values)
          ...() {
            final entries = store
                .entriesFor(type)
                .where((e) => e.at.isAfter(since))
                .toList()
                .reversed
                .toList();
            if (entries.isEmpty) return <pw.Widget>[];
            return [
              heading(
                '${type.label} (${entries.length} ${entries.length == 1 ? 'reading' : 'readings'})',
              ),
              table(
                ['Date', 'Reading', 'Notes'],
                [
                  for (final e in entries)
                    [when.format(e.at), e.display, e.notes],
                ],
              ),
            ];
          }(),
        if (upcoming.isNotEmpty) ...[
          heading('Upcoming appointments'),
          table(
            ['When', 'Doctor', 'Where'],
            [
              for (final a in upcoming)
                [
                  when.format(a.dateTime),
                  [
                    a.doctor,
                    if (a.specialty.isNotEmpty) '(${a.specialty})',
                  ].join(' '),
                  a.place,
                ],
            ],
          ),
        ],
      ],
    ),
  );
  return doc.save();
}
