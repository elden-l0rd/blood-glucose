import 'package:flutter/material.dart';
import '../utils/globals.dart';
import '../main.dart';
import 'l10n.dart';

class LanguageButton extends StatefulWidget {
  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {

  void setLocale(BuildContext context, Locale newLocale) {
    if (newLocale != currentLocale) {
      setState(() {
        currentLocale = newLocale;
        HomeScreen.setLocale(context, newLocale);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: currentLocale,
      onChanged: (Locale? newLocale) {
        setLocale(context, newLocale!);
      },
      items: L10n.all.map((locale) {
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Row(
            children: [
              Text(
                L10n.getFlag(locale.languageCode),
                style: TextStyle(fontSize: 22),
              ),
              Text(
                L10n.getLanguageName(locale),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      }).toList(),
      dropdownColor: Colors.black,
    );
  }
}
