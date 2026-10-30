import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';

void main() {
  test('English and Amharic include the same user-facing message keys',
      () async {
    final english = await AppLocalizations.delegate.load(const Locale('en'));
    final amharic = await AppLocalizations.delegate.load(const Locale('am'));

    expect(english.welcomeTitle, isNotEmpty);
    expect(amharic.welcomeTitle, isNotEmpty);
    expect(english.languageTitle, isNot(amharic.languageTitle));
    expect(amharic.amharicLanguage, contains('አማርኛ'));
  });
}
