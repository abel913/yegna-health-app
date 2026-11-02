import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/main.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/chatbot/yegna_chatbot_fab.dart';
import 'package:yegna_health_app/src/chatbot/yegna_chatbot_page.dart';
import 'package:yegna_health_app/src/locale_controller.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'YegnaChatbotFab is visible on Home and Learn tabs, hidden on Facilities, Mentors, Account',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final preferences = await SharedPreferences.getInstance();
    final localeController = LocaleController(preferences);
    final authController = AuthController(FakeAuthRepository());

    await tester.pumpWidget(YegnaHealthApp(
      localeController: localeController,
      authController: authController,
      progressStore: FakeLearningProgressStore(),
    ));
    await tester.pumpAndSettle();

    // 1. On Home Tab (index 0) -> FAB should be present
    expect(find.byType(YegnaChatbotFab), findsOneWidget);

    // 2. Switch to Facilities (index 1) -> FAB should not be present
    final facilitiesIcon = find.byIcon(Icons.local_hospital_outlined);
    expect(facilitiesIcon, findsOneWidget);
    await tester.tap(facilitiesIcon);
    await tester.pumpAndSettle();
    expect(find.byType(YegnaChatbotFab), findsNothing);

    // 3. Switch to Mentors (index 2) -> FAB should not be present
    final mentorsIcon = find.byIcon(Icons.people_alt_outlined);
    expect(mentorsIcon, findsOneWidget);
    await tester.tap(mentorsIcon);
    await tester.pumpAndSettle();
    expect(find.byType(YegnaChatbotFab), findsNothing);

    // 4. Switch to Learn (index 3) -> FAB should be present
    final learnIcon = find.byIcon(Icons.menu_book_outlined);
    expect(learnIcon, findsOneWidget);
    await tester.tap(learnIcon);
    await tester.pumpAndSettle();
    expect(find.byType(YegnaChatbotFab), findsOneWidget);

    // 5. Tapping FAB opens YegnaChatbotPage
    await tester.tap(find.byType(YegnaChatbotFab));
    await tester.pumpAndSettle();
    expect(find.byType(YegnaChatbotPage), findsOneWidget);

    authController.dispose();
  });
}
