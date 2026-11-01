import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../data/summary.dart';
import '../../data/summary_pdf.dart';
import '../../l10n/l10n.dart';
import '../../l10n/labels.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../theme.dart';
import '../../widgets/common.dart';
import '../../legal/legal_screens.dart';
import '../../legal/legal.dart';
import 'tracker_screen.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l.featureHealth),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => shareHealthSummary(context),
              icon: const Icon(Icons.ios_share_rounded),
              label: Text(l.commonShare),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.healthIntro,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                for (final type in TrackerType.values) ...[
                  _TrackerCard(
                    type: type,
                    latest: store.entriesFor(type).lastOrNull,
                  ),
                  const SizedBox(height: 12),
                ],
                DisclaimerNote(
                  l.healthDisclaimer,
                  onReadMore: () => openLegalDoc(context, LegalDoc.medical),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TrackerCard extends StatelessWidget {
  const _TrackerCard({required this.type, required this.latest});
  final TrackerType type;
  final TrackerEntry? latest;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => FeatureTheme(
              feature: Feature.health,
              child: TrackerScreen(type: type),
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              IconBadge(type.icon, color: type.color, size: 60),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(type.title(l), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      latest == null
                          ? l.healthNoReadings
                          : '${latest!.displayIn(l)}\n${formatDay(context, latest!.at)}, ${formatTime(context, latest!.at)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lets the user send their doctor a summary, as a PDF or as a message.
Future<void> shareHealthSummary(BuildContext context) async {
  final store = context.store;
  final sharing = context.services.sharing;
  final l = context.l10n;
  final name = store.profile?.name;
  final subject = name == null
      ? l.healthShareSubjectNoName
      : l.healthShareSubject(name);
  final choice = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (sheet) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
              child: Text(
                l.healthShareTitle,
                style: Theme.of(sheet).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded, size: 30),
              title: Text(l.healthShareAsPdf),
              subtitle: Text(l.healthShareAsPdfSubtitle),
              onTap: () => Navigator.pop(sheet, 'pdf'),
            ),
            ListTile(
              leading: const Icon(Icons.sms_rounded, size: 30),
              title: Text(l.healthShareAsText),
              subtitle: Text(l.healthShareAsTextSubtitle),
              onTap: () => Navigator.pop(sheet, 'text'),
            ),
          ],
        ),
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  final now = DateTime.now();
  if (choice == 'text') {
    await sharing.shareText(healthSummary(store, now), subject: subject);
    return;
  }
  final bytes = await healthSummaryPdf(
    store,
    now,
    regular: await rootBundle.load('assets/fonts/Lexend-400.ttf'),
    bold: await rootBundle.load('assets/fonts/Lexend-700.ttf'),
  );
  final stamp = now.toIso8601String().substring(0, 10);
  await sharing.shareBytes(
    'health-summary-$stamp.pdf',
    bytes,
    mimeType: 'application/pdf',
    subject: subject,
  );
}
