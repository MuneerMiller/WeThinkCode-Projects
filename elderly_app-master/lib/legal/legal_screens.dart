import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_scope.dart';
import '../l10n/l10n.dart';
import '../widgets/common.dart';
import 'legal.dart';

void openLegalDoc(BuildContext context, LegalDoc doc) {
  Navigator.of(
    context,
  ).push(MaterialPageRoute(builder: (_) => LegalDocScreen(doc: doc)));
}

/// Shows one legal document from assets/legal.
class LegalDocScreen extends StatelessWidget {
  const LegalDocScreen({super.key, required this.doc});
  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    // The documents are only written in English.
    final english = Localizations.localeOf(context).languageCode == 'en';
    return Scaffold(
      appBar: AppBar(title: Text(doc.titleIn(l))),
      body: FutureBuilder<String>(
        future: doc.load(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              ContentWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!english)
                      Card(
                        color: theme.colorScheme.secondaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.translate_rounded,
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l.legalEnglishOnly,
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color:
                                        theme.colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ...renderSimpleMarkdown(context, snap.data!),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// "Legal & about": every document, the open-source licences and the version.
class LegalHubScreen extends StatelessWidget {
  const LegalHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final accepted = context.store.legalAcceptedAt;
    return Scaffold(
      appBar: AppBar(title: Text(l.legalHubTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          ContentWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Column(
                    children: [
                      for (final (i, doc) in LegalDoc.values.indexed) ...[
                        if (i > 0) const Divider(indent: 20, endIndent: 20),
                        ListTile(
                          leading: Icon(doc.icon),
                          title: Text(doc.titleIn(l)),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => openLegalDoc(context, doc),
                        ),
                      ],
                      const Divider(indent: 20, endIndent: 20),
                      ListTile(
                        leading: const Icon(Icons.code_rounded),
                        title: Text(l.legalOpenSourceLicences),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => showLicensePage(
                          context: context,
                          applicationName: l.appTitle,
                          applicationVersion: l.legalVersion(appVersion),
                          applicationIcon: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: 56,
                              excludeFromSemantics: true,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l.legalAppVersion(appVersion),
                  style: theme.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                if (accepted != null)
                  Text(
                    l.legalAcceptedOn(
                      context.store.legalAcceptedVersion,
                      DateFormat('d MMMM y').format(accepted),
                    ),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// "I agree" checkbox with links to the documents it covers.
class LegalAgreement extends StatelessWidget {
  const LegalAgreement({
    super.key,
    required this.agreed,
    required this.onChanged,
    this.showError = false,
  });

  final bool agreed;
  final ValueChanged<bool> onChanged;
  final bool showError;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    Widget link(LegalDoc doc, String label) => TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.centerLeft,
      ),
      onPressed: () => openLegalDoc(context, doc),
      child: Text(label),
    );
    return Card(
      color: showError ? theme.colorScheme.errorContainer : null,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              value: agreed,
              onChanged: (v) => onChanged(v ?? false),
              title: Text(l.legalAgree),
              subtitle: showError
                  ? Text(
                      l.legalTickBox,
                      style: TextStyle(color: theme.colorScheme.error),
                    )
                  : Text(l.legalNotMedicalService),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Wrap(
                children: [
                  link(LegalDoc.terms, l.legalReadTerms),
                  link(LegalDoc.medical, l.commonReadMedicalDisclaimer),
                  link(LegalDoc.privacy, l.legalReadPrivacy),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Asks someone who already uses the app to accept updated documents.
class LegalUpdateScreen extends StatefulWidget {
  const LegalUpdateScreen({super.key});

  @override
  State<LegalUpdateScreen> createState() => _LegalUpdateScreenState();
}

class _LegalUpdateScreenState extends State<LegalUpdateScreen> {
  bool _agreed = false;
  bool _showError = false;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final first = context.store.legalAcceptedVersion == 0;
    return Scaffold(
      bottomNavigationBar: BottomAction(
        child: FilledButton(
          onPressed: () {
            if (!_agreed) {
              setState(() => _showError = true);
              return;
            }
            context.store.acceptLegal(LegalInfo.version);
          },
          child: Text(l.commonContinue),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            ContentWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.description_rounded,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    first ? l.legalReviewTitle : l.legalUpdatedTitle,
                    style: theme.textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.legalUpdateBody(
                      LegalInfo.version,
                      DateFormat('d MMMM y').format(LegalInfo.effectiveDay),
                    ),
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  LegalAgreement(
                    agreed: _agreed,
                    showError: _showError && !_agreed,
                    onChanged: (v) => setState(() => _agreed = v),
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

/// Renders the small Markdown subset the documents use: `#`, `##` and `###`
/// headings, `- ` bullets, paragraphs and `**bold**`.
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
          child: Semantics(
            header: true,
            child: Text(
              first.substring(2),
              style: theme.textTheme.headlineSmall,
            ),
          ),
        ),
      );
    } else if (first.startsWith('## ')) {
      out.add(
        Semantics(header: true, child: SectionHeader(first.substring(3))),
      );
    } else if (first.startsWith('### ')) {
      out.add(
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Semantics(
            header: true,
            child: Text(
              first.substring(4),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    } else if (first.startsWith('- ')) {
      for (final line in lines) {
        out.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExcludeSemantics(
                  child: Text('•  ', style: theme.textTheme.bodyLarge),
                ),
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
