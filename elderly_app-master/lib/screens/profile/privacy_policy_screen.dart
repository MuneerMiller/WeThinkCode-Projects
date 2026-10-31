import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../widgets/common.dart';

/// Shows assets/privacy_policy.md (also published with the source code).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  static Future<String> load() =>
      rootBundle.loadString('assets/privacy_policy.md');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy policy')),
      body: FutureBuilder<String>(
        future: load(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: renderSimpleMarkdown(context, snap.data!),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Renders the small Markdown subset the policy uses: `#`/`##` headings,
/// `- ` bullets, paragraphs and `**bold**`.
List<Widget> renderSimpleMarkdown(BuildContext context, String md) {
  final theme = Theme.of(context);
  final out = <Widget>[];

  TextSpan inline(String text, TextStyle? style) {
    final parts = text.split('**');
    return TextSpan(
      style: style,
      children: [
        for (final (i, part) in parts.indexed)
          TextSpan(
            text: part,
            style: i.isOdd
                ? const TextStyle(fontWeight: FontWeight.w600)
                : null,
          ),
      ],
    );
  }

  for (final block in md.trim().split(RegExp(r'\n\s*\n'))) {
    final lines = block.trim().split('\n');
    final first = lines.first;
    if (first.startsWith('# ')) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            first.substring(2),
            style: theme.textTheme.headlineSmall,
            semanticsLabel: first.substring(2),
          ),
        ),
      );
    } else if (first.startsWith('## ')) {
      out.add(SectionHeader(first.substring(3)));
    } else if (first.startsWith('- ')) {
      for (final line in lines) {
        out.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('•  ', style: theme.textTheme.bodyLarge),
                Expanded(
                  child: Text.rich(
                    inline(line.substring(2), theme.textTheme.bodyLarge),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      out.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text.rich(inline(lines.join(' '), theme.textTheme.bodyLarge)),
        ),
      );
    }
  }
  return out;
}
