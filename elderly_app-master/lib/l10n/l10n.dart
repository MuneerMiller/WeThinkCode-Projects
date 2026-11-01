import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

extension L10nContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}

/// The languages the app speaks, with each one's name in that language.
const appLanguages = <String, String>{
  'en': 'English',
  'af': 'Afrikaans',
  'zu': 'isiZulu',
  'xh': 'isiXhosa',
};

/// Languages whose translations still need a review by a native speaker.
const languagesAwaitingReview = {'zu', 'xh'};

/// The locale to use for dates and numbers. Flutter and intl have no
/// isiXhosa data, so isiXhosa uses South African English formats.
String intlLocaleFor(Locale locale) =>
    locale.languageCode == 'xh' ? 'en_ZA' : locale.toLanguageTag();

const appLocalizationsDelegates = <LocalizationsDelegate<dynamic>>[
  AppLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  _FallbackMaterialDelegate(),
  _FallbackCupertinoDelegate(),
  _FallbackWidgetsDelegate(),
];

/// Flutter's own buttons and dialogs have no isiXhosa text, so they use
/// South African English for languages Flutter doesn't know.
bool _needsFallback(Locale locale) =>
    AppLocalizations.delegate.isSupported(locale) &&
    !GlobalMaterialLocalizations.delegate.isSupported(locale);

const _fallback = Locale('en', 'ZA');

class _FallbackMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialDelegate();
  @override
  bool isSupported(Locale locale) => _needsFallback(locale);
  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(_fallback);
  @override
  bool shouldReload(_FallbackMaterialDelegate old) => false;
}

class _FallbackCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoDelegate();
  @override
  bool isSupported(Locale locale) => _needsFallback(locale);
  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(_fallback);
  @override
  bool shouldReload(_FallbackCupertinoDelegate old) => false;
}

class _FallbackWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsDelegate();
  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.delegate.isSupported(locale) &&
      !GlobalWidgetsLocalizations.delegate.isSupported(locale);
  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture(const DefaultWidgetsLocalizations());
  @override
  bool shouldReload(_FallbackWidgetsDelegate old) => false;
}

/// The language the app is shown in: the one chosen in the app, or else the
/// best match for the phone's languages.
Locale appLocaleFor(String? chosen) {
  if (chosen != null) return Locale(chosen);
  return basicLocaleListResolution(
    WidgetsBinding.instance.platformDispatcher.locales,
    AppLocalizations.supportedLocales,
  );
}

/// Sets the default locale for dates written outside the widget tree.
void applyIntlLocale(Locale locale) {
  Intl.defaultLocale = intlLocaleFor(locale);
}
