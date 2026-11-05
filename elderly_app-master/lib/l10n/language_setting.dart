// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/material.dart';

import '../app_scope.dart';
import 'l10n.dart';

/// A row showing the app's language; tapping it lets the user choose another.
class LanguageSetting extends StatelessWidget {
  const LanguageSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final store = context.store;
    final current = store.languageCode;
    return ListTile(
      leading: const Icon(Icons.translate_rounded),
      title: Text(l.languageTitle),
      subtitle: Text(
        current == null ? l.languageSystem : appLanguages[current]!,
      ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () => chooseLanguage(context),
    );
  }
}

/// Lets the user pick the app's language.
Future<void> chooseLanguage(BuildContext context) async {
  final store = context.store;
  final picked = await showDialog<String>(
    context: context,
    builder: (context) {
      final l = context.l10n;
      final shown = Localizations.localeOf(context).languageCode;
      return AlertDialog(
        title: Text(l.languageChoose),
        contentPadding: const EdgeInsets.fromLTRB(8, 16, 8, 0),
        content: SingleChildScrollView(
          child: RadioGroup<String>(
            groupValue: store.languageCode ?? '',
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(value: '', title: Text(l.languageSystem)),
                for (final MapEntry(:key, :value) in appLanguages.entries)
                  RadioListTile<String>(value: key, title: Text(value)),
                if (languagesAwaitingReview.contains(shown))
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Text(l.languageReviewNote),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    l.languageEnglishOnlyNote,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l.commonCancel),
          ),
        ],
      );
    },
  );
  if (picked == null) return;
  await store.setLanguage(picked.isEmpty ? null : picked);
}
