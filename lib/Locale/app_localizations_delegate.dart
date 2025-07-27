// lib/locale/app_localizations_delegate.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['es', 'en'].contains(locale.languageCode);

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(locale); // ✅ Ahora funcionará

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}
