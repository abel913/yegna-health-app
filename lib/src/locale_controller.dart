import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController(this._preferences);

  static const _localeKey = 'preferred_locale';
  final SharedPreferences _preferences;
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> load() async {
    final savedLanguage = _preferences.getString(_localeKey);
    if (savedLanguage == 'am' || savedLanguage == 'en') {
      _locale = Locale(savedLanguage!);
    }
  }

  Future<void> setLanguage(String languageCode) async {
    if (languageCode != 'en' && languageCode != 'am') return;
    if (_locale.languageCode == languageCode) return;
    await _preferences.setString(_localeKey, languageCode);
    _locale = Locale(languageCode);
    notifyListeners();
  }
}
