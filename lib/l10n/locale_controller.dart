import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  static const _localeKey = 'app_locale_code';
  static const supportedLocaleCodes = ['en', 'ar'];

  Locale _locale = const Locale('en');

  Locale get locale => _locale;
  bool get isArabic => _locale.languageCode == 'ar';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCode = prefs.getString(_localeKey);

    if (savedCode != null && supportedLocaleCodes.contains(savedCode)) {
      _locale = Locale(savedCode);
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocaleCodes.contains(locale.languageCode)) return;
    if (_locale.languageCode == locale.languageCode) return;

    _locale = Locale(locale.languageCode);
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, locale.languageCode);
  }

  Future<void> setLanguageCode(String languageCode) {
    return setLocale(Locale(languageCode));
  }
}
