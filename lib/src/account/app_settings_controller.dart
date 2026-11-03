import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTextScale {
  small(0.88, 'small'),
  normal(1.0, 'normal'),
  large(1.18, 'large');

  const AppTextScale(this.factor, this.key);
  final double factor;
  final String key;

  static AppTextScale fromKey(String? key) {
    if (key == 'small') return AppTextScale.small;
    if (key == 'large') return AppTextScale.large;
    return AppTextScale.normal;
  }
}

class AppSettingsController extends ChangeNotifier {
  AppSettingsController([this._preferences]);

  static const _themeKey = 'app_theme_mode';
  static const _textScaleKey = 'app_text_scale';
  static const _pushAlertsKey = 'notifications_push_alerts';
  static const _healthTipsKey = 'notifications_health_tips';
  static const _assessmentRemindersKey = 'notifications_assessment_reminders';

  final SharedPreferences? _preferences;

  ThemeMode _themeMode = ThemeMode.light;
  AppTextScale _textScale = AppTextScale.normal;
  bool _pushAlertsEnabled = true;
  bool _healthTipsEnabled = true;
  bool _assessmentRemindersEnabled = true;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;
  AppTextScale get textScale => _textScale;
  double get textScaleFactor => _textScale.factor;
  bool get pushAlertsEnabled => _pushAlertsEnabled;
  bool get healthTipsEnabled => _healthTipsEnabled;
  bool get assessmentRemindersEnabled => _assessmentRemindersEnabled;

  Future<void> load() async {
    final prefs = _preferences;
    if (prefs == null) return;

    final themeStr = prefs.getString(_themeKey);
    if (themeStr == 'dark') {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }

    final scaleStr = prefs.getString(_textScaleKey);
    _textScale = AppTextScale.fromKey(scaleStr);

    _pushAlertsEnabled = prefs.getBool(_pushAlertsKey) ?? true;
    _healthTipsEnabled = prefs.getBool(_healthTipsKey) ?? true;
    _assessmentRemindersEnabled =
        prefs.getBool(_assessmentRemindersKey) ?? true;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final targetMode =
        mode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light;
    if (_themeMode == targetMode) return;
    _themeMode = targetMode;
    notifyListeners();
    final prefs = _preferences;
    if (prefs != null) {
      await prefs.setString(
        _themeKey,
        targetMode == ThemeMode.dark ? 'dark' : 'light',
      );
    }
  }

  Future<void> setTextScale(AppTextScale scale) async {
    if (_textScale == scale) return;
    _textScale = scale;
    notifyListeners();
    final prefs = _preferences;
    if (prefs != null) {
      await prefs.setString(_textScaleKey, scale.key);
    }
  }

  Future<void> setPushAlerts(bool enabled) async {
    if (_pushAlertsEnabled == enabled) return;
    _pushAlertsEnabled = enabled;
    notifyListeners();
    final prefs = _preferences;
    if (prefs != null) {
      await prefs.setBool(_pushAlertsKey, enabled);
    }
  }

  Future<void> setHealthTips(bool enabled) async {
    if (_healthTipsEnabled == enabled) return;
    _healthTipsEnabled = enabled;
    notifyListeners();
    final prefs = _preferences;
    if (prefs != null) {
      await prefs.setBool(_healthTipsKey, enabled);
    }
  }

  Future<void> setAssessmentReminders(bool enabled) async {
    if (_assessmentRemindersEnabled == enabled) return;
    _assessmentRemindersEnabled = enabled;
    notifyListeners();
    final prefs = _preferences;
    if (prefs != null) {
      await prefs.setBool(_assessmentRemindersKey, enabled);
    }
  }
}
