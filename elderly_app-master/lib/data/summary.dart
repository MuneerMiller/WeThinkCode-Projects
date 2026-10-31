import 'package:intl/intl.dart';

import 'app_store.dart';
import 'models.dart';

/// A plain-text health summary to send to a doctor or carer.
String healthSummary(AppStore store, DateTime now, {int days = 30}) {
  final p = store.profile;
  final since = now.subtract(Duration(days: days));
  final date = DateFormat('d MMM y');
  final when = DateFormat('d MMM, HH:mm');
  final out = StringBuffer()
    ..writeln('Health summary for ${p?.name ?? 'me'}')
    ..writeln('${date.format(since)} – ${date.format(now)}');

  final details = [
    if (p != null && p.age.isNotEmpty) 'Age ${p.age}',
    if (p != null && p.bloodGroup.isNotEmpty) 'Blood group ${p.bloodGroup}',
  ];
  if (details.isNotEmpty) out.writeln(details.join(' · '));
  if (p != null && p.conditions.isNotEmpty) {
    out.writeln('Conditions: ${p.conditions}');
  }
  if (p != null && p.allergies.isNotEmpty) {
    out.writeln('Allergies: ${p.allergies}');
  }

  if (store.medicines.isNotEmpty) {
    out
      ..writeln()
      ..writeln('MEDICINES');
    for (final m in store.medicines) {
      final times = ([...m.times]..sort()).map((t) => t.key).join(', ');
      final a = m.adherence(now, days: 7);
      out.writeln(
        '- ${m.name}${m.dosage.isEmpty ? '' : ' ${m.dosage}'} at $times'
        '${a.due == 0 ? '' : ' (taken ${a.taken} of ${a.due} doses in the last 7 days)'}',
      );
    }
  }

  for (final type in TrackerType.values) {
    final entries = store
        .entriesFor(type)
        .where((e) => e.at.isAfter(since))
        .toList();
    if (entries.isEmpty) continue;
    out
      ..writeln()
      ..writeln(
        '${type.label.toUpperCase()} (${entries.length} ${entries.length == 1 ? 'reading' : 'readings'})',
      );
    for (final e in entries.reversed.take(10)) {
      out.writeln(
        '- ${when.format(e.at)}: ${e.display}'
        '${e.notes.isEmpty ? '' : ' – ${e.notes}'}',
      );
    }
    if (entries.length > 10) {
      out.writeln('  …and ${entries.length - 10} earlier');
    }
  }

  final upcoming = store.upcomingAppointments(now);
  if (upcoming.isNotEmpty) {
    out
      ..writeln()
      ..writeln('UPCOMING APPOINTMENTS');
    for (final a in upcoming.take(5)) {
      out.writeln(
        '- ${when.format(a.dateTime)}: ${a.doctor}'
        '${a.specialty.isEmpty ? '' : ' (${a.specialty})'}',
      );
    }
  }

  out
    ..writeln()
    ..write('Sent from the Elderly Care app.');
  return out.toString();
}
