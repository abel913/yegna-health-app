import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/account/app_settings_controller.dart';

void main() {
  group('AppSettingsController', () {
    test('initializes with default values when no prefs are saved', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = AppSettingsController(prefs);
      await controller.load();

      expect(controller.themeMode, ThemeMode.light);
      expect(controller.isDark, isFalse);
      expect(controller.textScale, AppTextScale.normal);
      expect(controller.textScaleFactor, 1.0);
      expect(controller.pushAlertsEnabled, isTrue);
      expect(controller.healthTipsEnabled, isTrue);
      expect(controller.assessmentRemindersEnabled, isTrue);
    });

    test('loads saved preferences correctly', () async {
      SharedPreferences.setMockInitialValues({
        'app_theme_mode': 'dark',
        'app_text_scale': 'large',
        'notifications_push_alerts': false,
        'notifications_health_tips': true,
        'notifications_assessment_reminders': false,
      });
      final prefs = await SharedPreferences.getInstance();
      final controller = AppSettingsController(prefs);
      await controller.load();

      expect(controller.themeMode, ThemeMode.dark);
      expect(controller.textScale, AppTextScale.large);
      expect(controller.textScaleFactor, 1.18);
      expect(controller.pushAlertsEnabled, isFalse);
      expect(controller.healthTipsEnabled, isTrue);
      expect(controller.assessmentRemindersEnabled, isFalse);
    });

    test('updates theme mode and notifies listeners', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = AppSettingsController(prefs);
      await controller.load();

      int notifications = 0;
      controller.addListener(() => notifications++);

      expect(controller.themeMode, ThemeMode.light);
      expect(controller.isDark, isFalse);

      await controller.setThemeMode(ThemeMode.dark);
      expect(controller.themeMode, ThemeMode.dark);
      expect(controller.isDark, isTrue);
      expect(prefs.getString('app_theme_mode'), 'dark');
      expect(notifications, 1);

      await controller.setThemeMode(ThemeMode.light);
      expect(controller.themeMode, ThemeMode.light);
      expect(controller.isDark, isFalse);
      expect(prefs.getString('app_theme_mode'), 'light');
      expect(notifications, 2);
    });

    test('updates text scale and notifies listeners', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = AppSettingsController(prefs);
      await controller.load();

      int notifications = 0;
      controller.addListener(() => notifications++);

      await controller.setTextScale(AppTextScale.small);
      expect(controller.textScale, AppTextScale.small);
      expect(controller.textScaleFactor, 0.88);
      expect(prefs.getString('app_text_scale'), 'small');
      expect(notifications, 1);

      await controller.setTextScale(AppTextScale.large);
      expect(controller.textScale, AppTextScale.large);
      expect(controller.textScaleFactor, 1.18);
      expect(prefs.getString('app_text_scale'), 'large');
      expect(notifications, 2);
    });

    test('updates notification toggles and notifies listeners', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final controller = AppSettingsController(prefs);
      await controller.load();

      int notifications = 0;
      controller.addListener(() => notifications++);

      await controller.setPushAlerts(false);
      expect(controller.pushAlertsEnabled, isFalse);
      expect(prefs.getBool('notifications_push_alerts'), isFalse);
      expect(notifications, 1);

      await controller.setHealthTips(false);
      expect(controller.healthTipsEnabled, isFalse);
      expect(prefs.getBool('notifications_health_tips'), isFalse);
      expect(notifications, 2);

      await controller.setAssessmentReminders(false);
      expect(controller.assessmentRemindersEnabled, isFalse);
      expect(prefs.getBool('notifications_assessment_reminders'), isFalse);
      expect(notifications, 3);
    });
  });
}
