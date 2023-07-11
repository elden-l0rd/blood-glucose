import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class L10n {
  static final all = [
    const Locale('en'), //english
    const Locale('zh'), //chinese
    const Locale('ar'), //arabic
    const Locale('hi'), //hindi
    const Locale('es'), //spanish
  ];

  static String getFlag(String code) {
    switch (code) {
      case 'zh':
        return '🇨🇳';
      case 'ar':
        return '🇸🇦';
      case 'hi':
        return '🇮🇳';
      case 'es':
        return '🇪🇸';
      default:
        return '🇺🇸';
    }
  }

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'zh':
        return ' - Chinese';
      case 'ar':
        return ' - Arabic';
      case 'hi':
        return ' - Hindi';
      case 'es':
        return ' - Spanish';
      default:
        return ' - English';
    }
  }

  static AppLocalizations translation(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}