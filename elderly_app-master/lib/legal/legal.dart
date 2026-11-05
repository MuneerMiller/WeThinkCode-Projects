// Copyright (c) 2026 Mogamat Muneer Miller. All rights reserved.
// Part of the Elderly Care app. Source-available for viewing only;
// copying or reuse without written permission is prohibited. See LICENSE.

import 'package:flutter/foundation.dart'
    show LicenseEntryWithLineBreaks, LicenseRegistry;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../l10n/l10n.dart';

/// The app's version, shown under "Legal & about". A test keeps it in step
/// with pubspec.yaml.
const appVersion = '2.2.0';

/// The author and the copyright line shown on the "Legal & about" and the
/// open-source licences screens. A copyright notice is kept in this standard
/// form rather than translated.
const appAuthor = 'Mogamat Muneer Miller';
const appCopyright = '© 2026 $appAuthor. All rights reserved.';

/// Details filled into the legal documents.
///
/// **Before publishing**, replace every value marked "to be completed" with
/// the publisher's real details, have the documents reviewed by a South
/// African attorney, and bump [version] whenever the documents change in a
/// way users must accept again.
abstract final class LegalInfo {
  /// Raise this to ask everyone to accept the documents again.
  static const version = 1;
  static const effectiveDate = '1 November 2026';

  /// [effectiveDate] as a date, for showing in the app's language.
  static final effectiveDay = DateTime(2026, 11, 1);

  static const values = <String, String>{
    'publisher_name': '[publisher name – to be completed before release]',
    'publisher_legal_status':
        '[legal status, e.g. sole proprietor or (Pty) Ltd – to be completed]',
    'publisher_registration':
        '[company or ID registration number – to be completed]',
    'publisher_address': '[physical address – to be completed]',
    'contact_email': '[contact email – to be completed]',
    'contact_phone': '[contact telephone – to be completed]',
    'information_officer':
        '[Information Officer name and contact – to be completed]',
    'illustration_credit':
        '[Their original source and licence must be confirmed, and credited '
        'here, before release.]',
  };

  static String fill(String text) {
    var out = text
        .replaceAll('{{legal_version}}', '$version')
        .replaceAll('{{effective_date}}', effectiveDate);
    for (final MapEntry(:key, :value) in values.entries) {
      out = out.replaceAll('{{$key}}', value);
    }
    return out;
  }
}

enum LegalDoc {
  terms('Terms of Use', 'terms_of_use', Icons.gavel_rounded),
  medical(
    'Medical disclaimer',
    'medical_disclaimer',
    Icons.health_and_safety_rounded,
  ),
  privacy('Privacy policy', 'privacy_policy', Icons.policy_rounded),
  accessibility(
    'Accessibility statement',
    'accessibility',
    Icons.accessibility_new_rounded,
  ),
  credits(
    'Credits and third-party notices',
    'credits',
    Icons.handshake_rounded,
  );

  const LegalDoc(this.title, this.file, this.icon);

  /// The English title, as used in the documents themselves. Show
  /// [LegalDocL10n.titleIn] in the app.
  final String title;
  final String file;
  final IconData icon;

  String get asset => 'assets/legal/$file.md';

  Future<String> load() async =>
      LegalInfo.fill(await rootBundle.loadString(asset, cache: false));
}

extension LegalDocL10n on LegalDoc {
  /// The document's title in the app's language.
  String titleIn(AppLocalizations l) => switch (this) {
    LegalDoc.terms => l.legalDocTerms,
    LegalDoc.medical => l.legalDocMedical,
    LegalDoc.privacy => l.legalDocPrivacy,
    LegalDoc.accessibility => l.legalDocAccessibility,
    LegalDoc.credits => l.legalDocCredits,
  };
}

/// Adds the licences that Flutter can't find by itself to the
/// "Open-source licences" page.
void registerExtraLicenses() {
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(
      const ['Lexend (font)'],
      await rootBundle.loadString('assets/legal/OFL-Lexend.txt', cache: false),
    );
    yield const LicenseEntryWithLineBreaks(
      ['OpenStreetMap data (hospital search)'],
      'Map data © OpenStreetMap contributors.\n\n'
      'Available under the Open Database Licence (ODbL) 1.0: '
      'https://opendatacommons.org/licenses/odbl/1-0/\n\n'
      'See https://www.openstreetmap.org/copyright',
    );
  });
}
