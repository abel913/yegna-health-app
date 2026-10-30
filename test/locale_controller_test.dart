import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/locale_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads and persists the selected supported language', () async {
    SharedPreferences.setMockInitialValues({'preferred_locale': 'am'});
    final preferences = await SharedPreferences.getInstance();
    final controller = LocaleController(preferences);

    await controller.load();
    expect(controller.locale.languageCode, 'am');

    await controller.setLanguage('en');
    expect(controller.locale.languageCode, 'en');
    expect(preferences.getString('preferred_locale'), 'en');
  });

  test('ignores unsupported languages', () async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final controller = LocaleController(preferences);

    await controller.setLanguage('fr');
    expect(controller.locale.languageCode, 'en');
    expect(preferences.getString('preferred_locale'), isNull);
  });
}
