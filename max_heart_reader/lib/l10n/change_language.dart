import 'package:flutter/material.dart';
import '../globals.dart';
import 'l10n.dart';

class LanguageButton extends StatefulWidget {
  @override
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  void changeLanguage(Locale newLocale) {
    (newLocale != currentLocale)
        ? (setState(() {
            currentLocale = newLocale;
          }))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return  DropdownButton<Locale>(
              value: currentLocale,
              onChanged: (Locale? newLocale) {
                (newLocale != null)
                  ? changeLanguage(newLocale)
                  : null;
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