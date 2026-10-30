import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../widgets/common.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key, required this.type});
  final TrackerType type;

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final theme = Theme.of(context);
    final entries = store.entriesFor(type);

    return Scaffold(
      appBar: AppBar(title: Text(type.label)),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: type.color,
        foregroundColor: Colors.white,
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => AddReadingScreen(type: type))),
        icon: const Icon(Icons.add_rounded, size: 28),
        label: const Text('Add reading'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 20, 28, 12),
                    child: entries.length < 2
                        ? SizedBox(
                            height: 140,
                            child: Center(
                              child: Text(
                                entries.isEmpty
                                    ? 'Add your first reading to start tracking.'
                                    : 'Add one more reading to see a chart.',
                                style: theme.textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 220,
                            child: _Chart(type: type, entries: entries),
                          ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.lightbulb_outline_rounded, color: type.color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(type.tip, style: theme.textTheme.bodyMedium),
                    ),
                  ],
                ),
                if (entries.isNotEmpty) const SectionHeader('Readings'),
                for (final e in entries.reversed)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Dismissible(
                      key: ValueKey(e.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.delete_rounded,
                          color: theme.colorScheme.onErrorContainer,
                        ),
                      ),
                      confirmDismiss: (_) => confirm(
                        context,
                        title: 'Delete reading?',
                        message: '${e.display} on ${formatDay(e.at)}',
                        confirmLabel: 'Delete',
                        destructive: true,
                      ),
                      onDismissed: (_) => store.deleteTrackerEntry(e.id),
                      child: Card(
                        child: ListTile(
                          title: Text(e.display),
                          subtitle: Text(
                            [
                              '${formatDay(e.at)}, ${formatTime(context, e.at)}',
                              if (e.notes.isNotEmpty) e.notes,
                            ].join('\n'),
                          ),
                          trailing: IconButton(
                            tooltip: 'Delete reading',
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () async {
                              final ok = await confirm(
                                context,
                                title: 'Delete reading?',
                                message: '${e.display} on ${formatDay(e.at)}',
                                confirmLabel: 'Delete',
                                destructive: true,
                              );
                              if (ok) store.deleteTrackerEntry(e.id);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({required this.type, required this.entries});
  final TrackerType type;
  final List<TrackerEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shown = entries.length > 14
        ? entries.sublist(entries.length - 14)
        : entries;
    LineChartBarData line(List<FlSpot> spots, Color color) => LineChartBarData(
      spots: spots,
      color: color,
      barWidth: 3.5,
      isCurved: true,
      preventCurveOverShooting: true,
      dotData: FlDotData(
        getDotPainter: (_, _, _, _) => FlDotCirclePainter(
          radius: 5,
          color: color,
          strokeWidth: 2,
          strokeColor: theme.colorScheme.surface,
        ),
      ),
    );

    final bars = <LineChartBarData>[
      line([
        for (final (i, e) in shown.indexed) FlSpot(i.toDouble(), e.chartValue),
      ], type.color),
      if (type == TrackerType.bloodPressure)
        line([
          for (final (i, e) in shown.indexed)
            FlSpot(i.toDouble(), e.values['diastolic']!.toDouble()),
        ], type.color.withValues(alpha: 0.45)),
    ];
    final labelStyle = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    return Semantics(
      label:
          '${type.label} chart of the last ${shown.length} readings. '
          'Latest ${shown.last.display}.',
      child: LineChart(
        LineChartData(
          lineBarsData: bars,
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) =>
                FlLine(color: theme.colorScheme.outlineVariant, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => theme.colorScheme.inverseSurface,
              getTooltipItems: (spots) => [
                for (final s in spots)
                  LineTooltipItem(
                    s.barIndex == 0
                        ? '${shown[s.x.toInt()].display}\n${DateFormat('d MMM').format(shown[s.x.toInt()].at)}'
                        : '',
                    TextStyle(
                      color: theme.colorScheme.onInverseSurface,
                      fontSize: 15,
                    ),
                  ),
              ],
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 44,
                // The chart's own min/max labels collide with the grid ones.
                minIncluded: false,
                maxIncluded: false,
                getTitlesWidget: (v, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(meta.formattedValue, style: labelStyle),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                reservedSize: 30,
                getTitlesWidget: (v, meta) {
                  final i = v.toInt();
                  final step = (shown.length / 5).ceil();
                  if (v != i || i % step != 0 || i >= shown.length) {
                    return const SizedBox();
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      DateFormat('d/M').format(shown[i].at),
                      style: labelStyle,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddReadingScreen extends StatefulWidget {
  const AddReadingScreen({super.key, required this.type});
  final TrackerType type;

  @override
  State<AddReadingScreen> createState() => _AddReadingScreenState();
}

class _AddReadingScreenState extends State<AddReadingScreen> {
  final _form = GlobalKey<FormState>();
  late final _controllers = {
    for (final f in widget.type.fields) f.key: TextEditingController(),
  };
  final _notes = TextEditingController();
  DateTime _at = DateTime.now();

  @override
  void dispose() {
    for (final c in [..._controllers.values, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _validate(TrackerField f, String? v) {
    final optional = f.key == 'minutes';
    if (v == null || v.trim().isEmpty) {
      return optional ? null : 'Please enter ${f.label.toLowerCase()}';
    }
    final n = num.tryParse(v.trim().replaceAll(',', '.'));
    if (n == null) return 'Please enter a number';
    if (n < f.min || n > f.max) {
      return 'Should be between ${f.min} and ${f.max}';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final store = context.store;
    final values = <String, num>{
      for (final f in widget.type.fields)
        f.key:
            num.tryParse(
              _controllers[f.key]!.text.trim().replaceAll(',', '.'),
            ) ??
            0,
    };
    await store.saveTrackerEntry(
      TrackerEntry(
        id: store.newId(),
        type: widget.type,
        at: _at,
        values: values,
        notes: _notes.text.trim(),
      ),
    );
    if (mounted) {
      showMessage(context, '${widget.type.label} reading saved');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.type;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: type.color,
            foregroundColor: Colors.white,
          ),
          onPressed: _save,
          icon: const Icon(Icons.check_rounded),
          label: const Text('Save reading'),
        ),
      ),
      appBar: AppBar(title: Text('New ${type.label.toLowerCase()} reading')),
      body: Form(
        key: _form,
        // Clear an error as soon as the user fixes it.
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final f in type.fields) ...[
                    TextFormField(
                      controller: _controllers[f.key],
                      decoration: InputDecoration(
                        labelText: f.label,
                        suffixText: f.unit,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) => _validate(f, v),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule_rounded, size: 30),
                      title: Text(
                        '${formatDay(_at)}, ${formatTime(context, _at)}',
                      ),
                      trailing: const Text('Change'),
                      onTap: () async {
                        final picked = await pickDateTime(context, _at);
                        if (picked != null) setState(() => _at = picked);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notes,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText: 'e.g. after breakfast',
                    ),
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
