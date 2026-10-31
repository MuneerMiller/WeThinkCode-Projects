import 'package:flutter/material.dart';

import '../../app_scope.dart';
import '../../data/models.dart';
import '../../data/summary.dart';
import '../../data/summary_pdf.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../theme.dart';
import '../../widgets/common.dart';
import 'tracker_screen.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.store;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health tracker'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: () => shareHealthSummary(context),
              icon: const Icon(Icons.ios_share_rounded),
              label: const Text('Share'),
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
                  'Keep a record of your readings, then tap Share to send your doctor a summary.',
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
                    Text(type.label, style: theme.textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      latest == null
                          ? 'No readings yet'
                          : '${latest!.display}\n${formatDay(latest!.at)}, ${formatTime(context, latest!.at)}',
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
  final subject = 'Health summary for ${store.profile?.name ?? 'me'}';
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
                'Send your doctor a summary of the last 30 days',
                style: Theme.of(sheet).textTheme.titleMedium,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf_rounded, size: 30),
              title: const Text('As a PDF document'),
              subtitle: const Text('Neat tables, easy to print'),
              onTap: () => Navigator.pop(sheet, 'pdf'),
            ),
            ListTile(
              leading: const Icon(Icons.sms_rounded, size: 30),
              title: const Text('As a message'),
              subtitle: const Text('Plain text for email or WhatsApp'),
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
