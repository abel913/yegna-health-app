import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/discovery/mentor_detail_sheet.dart';
import 'package:yegna_health_app/src/discovery/mentor_model.dart';
import 'package:yegna_health_app/src/discovery/mentor_repository.dart';
import 'package:yegna_health_app/src/discovery/mentors_page.dart';

Widget _buildTestApp({
  required MentorRepository repository,
  Locale locale = const Locale('en'),
}) =>
    MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: Scaffold(
        body: MentorsPage(mentorRepository: repository),
      ),
    );

void main() {
  group('MentorRepository', () {
    test(
        'LocalVerifiedMentorRepository returns 5 verified mentors with contacts',
        () async {
      const repo = LocalVerifiedMentorRepository();
      final all = await repo.getMentors();
      expect(all.length, 5);
      expect(
        all.every((m) =>
            m.phoneNumber.isNotEmpty &&
            m.displayPhoneNumber.isNotEmpty &&
            m.telegramHandle.isNotEmpty),
        isTrue,
      );

      final onlineOnly = await repo.getMentors(onlineOnly: true);
      expect(onlineOnly.every((m) => m.isOnline), isTrue);

      final mentalHealthOnly = await repo.getMentors(
        topic: MentorTopic.mentalHealth,
      );
      expect(
        mentalHealthOnly
            .every((m) => m.topics.contains(MentorTopic.mentalHealth)),
        isTrue,
      );

      final searchResult = await repo.getMentors(query: 'Selamawit');
      expect(searchResult.length, 1);
      expect(searchResult.first.id, 'selamawit_tadesse');

      final searchByPhone = await repo.getMentors(query: '911234567');
      expect(searchByPhone.length, 1);
      expect(searchByPhone.first.id, 'selamawit_tadesse');

      final searchByTelegram = await repo.getMentors(query: 'selam_tya');
      expect(searchByTelegram.length, 1);
      expect(searchByTelegram.first.id, 'selamawit_tadesse');
    });

    test('UnconfiguredMentorRepository returns empty list', () async {
      const repo = UnconfiguredMentorRepository();
      final list = await repo.getMentors();
      expect(list, isEmpty);
    });
  });

  group('MentorsPage Widget Tests', () {
    testWidgets(
        'renders verified mentor cards with phone badges, call buttons, and profile contacts',
        (tester) async {
      const repo = LocalVerifiedMentorRepository();
      await tester.pumpWidget(_buildTestApp(repository: repo));
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));

      // Check header and search bar
      expect(find.text(en.mentorsIntroduction), findsOneWidget);
      expect(find.text(en.searchMentors), findsOneWidget);

      // Check mentor presence & phone badges
      expect(find.text('Selamawit Tadesse'), findsOneWidget);
      expect(find.text('Dawit Haile'), findsOneWidget);
      expect(find.text('+251 91 123 4567'), findsOneWidget);
      expect(find.text('@selam_tya_peer'), findsOneWidget);

      // Check Call Mentor button on card
      expect(find.text(en.callMentorAction), findsWidgets);

      // Filter by Online
      await tester.tap(find.text('🟢 ${en.onlineNowFilter}'));
      await tester.pumpAndSettle();

      expect(find.text('Selamawit Tadesse'), findsOneWidget);
      expect(find.text('Dawit Haile'), findsNothing); // Dawit is offline

      // Open Mentor Detail Sheet
      await tester.tap(find.text(en.viewProfileBtn).first);
      await tester.pumpAndSettle();

      expect(find.byType(MentorDetailSheet), findsOneWidget);
      expect(find.text(en.directContactsHeading), findsOneWidget);
      expect(find.text(en.telegramChatAction), findsOneWidget);
      expect(find.text(en.sessionsCountLabel), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text(en.callHotlineAction('952')),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(en.callHotlineAction('952')), findsOneWidget);
      expect(find.text(en.callHotlineAction('8335')), findsOneWidget);
    });

    testWidgets('unconfigured repository displays honest empty state',
        (tester) async {
      const repo = UnconfiguredMentorRepository();
      await tester.pumpWidget(_buildTestApp(repository: repo));
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));
      expect(find.text(en.noVerifiedMentorsTitle), findsOneWidget);
      expect(find.text(en.noVerifiedMentorsBody), findsOneWidget);
    });

    testWidgets('renders properly in Amharic locale with Amharic call button',
        (tester) async {
      const repo = LocalVerifiedMentorRepository();
      await tester.pumpWidget(
        _buildTestApp(repository: repo, locale: const Locale('am')),
      );
      await tester.pumpAndSettle();

      final am = await AppLocalizations.delegate.load(const Locale('am'));
      expect(find.text(am.mentorsIntroduction), findsOneWidget);
      expect(find.text('ሰላማዊት ታደሰ'), findsOneWidget);
      expect(find.text(am.callMentorAction), findsWidgets);
    });
  });
}
