import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static final all = [
    const Locale('en'), //english
    const Locale('zh'), //chinese
    const Locale('ms'), //malay
    const Locale('hi'), //hindi
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'zh':
        return '🇨🇳';
      case 'ms':
        return '🇲🇾';
      case 'hi':
        return '🇮🇳';
      default:
        return '🇺🇸';
    }
  }

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return ' - Chinese';
      case 'ms':
        return ' - Malay';
      case 'hi':
        return ' - Hindi';
      default:
        return ' - English';
    }
  }

  static AppLocalizations translation(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}