import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/auth/auth_controller.dart';
import 'package:yegna_health_app/src/learning/dynamic_module_detail_page.dart';
import 'package:yegna_health_app/src/learning/learning_modules_carousel.dart';
import 'package:yegna_health_app/src/learning/learning_progress_controller.dart';
import 'package:yegna_health_app/src/learning/modules/dynamic/dynamic_module_parser.dart';
import 'package:yegna_health_app/src/learning/widgets/curriculum/section_video_card.dart';

import 'support/fake_auth_repository.dart';
import 'support/fake_learning.dart';

void main() {
  group('LearningModuleItem Model & Asset Resolver Tests', () {
    test('fromMap creates valid item with localized fallbacks and padding', () {
      final data = {
        'id': 'module-09',
        'category': 'nutrition',
        'titleEn': 'Adolescent Nutrition & Diet',
        'titleAm': 'የአፍላ ወጣቶች አመጋገብና ጤና',
        'summaryEn': 'Balanced nutrition guidelines for growing youth.',
        'summaryAm': 'ለሚያድጉ ወጣቶች የተመጣጠነ ምግብ መመሪያ።',
        'contentEn':
            '## Nutrition Basics\n\nEat balanced meals daily.\n- Fruits\n- Vegetables',
        'contentAm': '## የምግብ መሰረቶች\n\nበየቀኑ የተመጣጠነ ምግብ ይመገቡ።',
        'readTimeMin': 5,
        'authorName': 'Dr. Hanna Bekele',
        'orderIndex': 9,
      };

      final item = LearningModuleItem.fromMap(data, 8);

      expect(item.id, 'module-09');
      expect(item.number, '09');
      expect(item.readTimeMin, 5);
      expect(item.authorName, 'Dr. Hanna Bekele');
      expect(item.category, 'nutrition');
      expect(item.contentEn, contains('Nutrition Basics'));
    });

    test('resolveImageAsset resolves category specific assets correctly', () {
      expect(
        LearningModuleItem.resolveImageAsset('module-01', 'puberty'),
        'assets/images/learning/module_01_puberty.jpg',
      );
      expect(
        LearningModuleItem.resolveImageAsset('custom-mod', 'sti'),
        'assets/images/learning/module_02_sti.png',
      );
      expect(
        LearningModuleItem.resolveImageAsset('custom-mod', 'hepatitis'),
        'assets/images/learning/module_03_hepatitis.png',
      );
      expect(
        LearningModuleItem.resolveImageAsset('custom-mod', 'gbv'),
        'assets/images/learning/module_04_gbv.png',
      );
      expect(
        LearningModuleItem.resolveImageAsset('custom-mod', 'mental_health'),
        'assets/images/learning/module_06_mental_health.jpg',
      );
      expect(
        LearningModuleItem.resolveImageAsset('custom-mod', 'substance'),
        'assets/images/learning/module_08_substance_abuse.png',
      );
    });

    test('normalizeImagePath preserves remote URLs and handles web illustration paths', () {
      // Remote URLs
      expect(
        LearningModuleItem.normalizeImagePath(
          'https://images.unsplash.com/photo-1234.jpg',
          'mod-1',
          'puberty',
        ),
        'https://images.unsplash.com/photo-1234.jpg',
      );

      // Web CMS illustration path (/illustrations/...)
      expect(
        LearningModuleItem.normalizeImagePath(
          '/illustrations/module_01_puberty.jpg',
          'mod-1',
          'puberty',
        ),
        'assets/images/learning/module_01_puberty.jpg',
      );

      // Bare illustration filename
      expect(
        LearningModuleItem.normalizeImagePath(
          'module_02_sti.png',
          'mod-2',
          'sti',
        ),
        'assets/images/learning/module_02_sti.png',
      );

      // Null or empty falls back to category
      expect(
        LearningModuleItem.normalizeImagePath(
          null,
          'mod-uuid-123',
          'adolescent health & puberty',
        ),
        'assets/images/learning/module_01_puberty.jpg',
      );

      expect(
        LearningModuleItem.normalizeImagePath(
          '',
          'mod-uuid-456',
          'stress management',
        ),
        'assets/images/learning/module_06_mental_health.jpg',
      );
    });
  });

  group('DynamicModuleDetailPage Widget Tests', () {
    testWidgets('renders hero banner, doctor note, and expandable sections',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final authRepository = FakeAuthRepository();
      final authController = AuthController(authRepository);
      final progressStore = FakeLearningProgressStore();
      final progressController = LearningProgressController(
        repository: progressStore,
        authController: authController,
      );

      final testModule = LearningModuleItem(
        id: 'module-09',
        number: '09',
        title: (_) => 'Nutrition & Wellness',
        description: (_) => 'Healthy diet habits for students.',
        imageAsset: 'assets/images/learning/module_05_srh.png',
        illustrationOnTop: true,
        category: 'nutrition',
        contentEn:
            '## Healthy Breakfast\n\nNever skip morning breakfast.\n- Whole grains\n- Milk & fruit\n> Doctor Tip: Hydrate well during exam weeks.',
        contentAm: '## ጤናማ ቁርስ\n\nየጠዋት ቁርስን በፍጹም አያምልጡ።',
        readTimeMin: 4,
        authorName: 'Dr. Hanna Bekele',
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: DynamicModuleDetailPage(
            module: testModule,
            progressController: progressController,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify title & summary
      expect(find.text('Nutrition & Wellness'), findsWidgets);
      expect(find.text('Healthy diet habits for students.'), findsOneWidget);
      expect(find.text('Dr. Hanna Bekele'), findsOneWidget);

      // Verify doctor's note container is displayed
      expect(find.byIcon(Icons.lightbulb_outline_rounded), findsOneWidget);

      // Verify parsed section heading
      expect(find.text('Healthy Breakfast'), findsOneWidget);

      // Scroll and tap accordion card to toggle expansion
      await tester.ensureVisible(find.text('Healthy Breakfast'));
      await tester.tap(find.text('Healthy Breakfast'));
      await tester.pumpAndSettle();

      // Verify bullet items
      expect(find.text('Whole grains'), findsOneWidget);
      expect(find.text('Milk & fruit'), findsOneWidget);
      expect(find.text('Doctor Tip: Hydrate well during exam weeks.'),
          findsOneWidget);
    });

    test('DynamicModuleParser extracts YouTube video URLs and IDs correctly', () {
      const content = '''
## Video Guide
Watch this demonstration on nutrition.
- Balanced meals
> Clinical Tip: Eat slow
> Video: https://www.youtube.com/watch?v=dQw4w9WgXcQ

## Text Only
Just plain reading here.
''';

      final sections = DynamicModuleParser.parseSections(content, false);
      expect(sections.length, 2);
      expect(sections[0].videoId, 'dQw4w9WgXcQ');
      expect(sections[0].videoUrl, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
      expect(sections[1].videoId, isNull);
      expect(sections[1].videoUrl, isNull);
    });

    testWidgets('renders SectionVideoCard when section includes a video URL',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final authController = AuthController(FakeAuthRepository());
      final progressController = LearningProgressController(
        repository: FakeLearningProgressStore(),
        authController: authController,
      );

      final videoModule = LearningModuleItem(
        id: 'mod-vid',
        number: '10',
        title: (_) => 'Video Health Module',
        description: (_) => 'Health education with video.',
        imageAsset: 'assets/images/learning/module_01_puberty.jpg',
        illustrationOnTop: true,
        category: 'srh',
        contentEn:
            '## Physical Exercise\n\nDaily cardio is essential.\n- 30 mins walking\n> Video: https://youtu.be/dQw4w9WgXcQ',
        contentAm: '## የአካል ብቃት እንቅስቃሴ\n\nየዕለት ተዕለት እንቅስቃሴ።',
        readTimeMin: 5,
      );

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: DynamicModuleDetailPage(
            module: videoModule,
            progressController: progressController,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open the accordion
      await tester.ensureVisible(find.text('Physical Exercise'));
      await tester.tap(find.text('Physical Exercise'));
      await tester.pumpAndSettle();

      // SectionVideoCard should be rendered
      expect(find.byType(SectionVideoCard), findsOneWidget);
      expect(find.text('YOUTUBE'), findsOneWidget);
      expect(find.text('Educational Video'), findsOneWidget);
      expect(find.text('Tap to watch video'), findsOneWidget);
    });
  });
}
