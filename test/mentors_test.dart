import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:yegna_health_app/l10n/app_localizations.dart';
import 'package:yegna_health_app/src/discovery/mentor_detail_sheet.dart';
import 'package:yegna_health_app/src/discovery/mentor_model.dart';
import 'package:yegna_health_app/src/discovery/mentor_repository.dart';
import 'package:yegna_health_app/src/discovery/mentor_schedule_sheet.dart';
import 'package:yegna_health_app/src/discovery/mentors_page.dart';
import 'package:yegna_health_app/src/sync/offline_sync_store.dart';

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

      // Campus filtering
      final fasilCampuses = await repo.getMentors(campus: 'Atse Fasil Campus');
      expect(fasilCampuses.length, 1);
      expect(fasilCampuses.first.id, 'selamawit_tadesse');

      final tewodrosCampuses =
          await repo.getMentors(campus: 'Atse Tewodros Campus');
      expect(tewodrosCampuses.length, 1);
      expect(tewodrosCampuses.first.id, 'dawit_haile');

      final cmhsCampuses =
          await repo.getMentors(campus: 'CMHS / Health College');
      expect(cmhsCampuses.length, 1);
      expect(cmhsCampuses.first.id, 'hana_girma');

      final allCampuses = await repo.getMentors(campus: 'all');
      expect(allCampuses.length, 5);
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
      expect(find.text(en.mentorsIntroduction), findsNothing);
      expect(find.text(en.searchMentors), findsOneWidget);

      // Check mentor presence on clean executive cards
      expect(find.text('Selamawit Tadesse'), findsOneWidget);
      expect(find.text('Dawit Haile'), findsOneWidget);

      // Verify quick action buttons exist on card
      expect(find.byIcon(Icons.phone_rounded), findsWidgets);
      expect(find.byIcon(Icons.send_rounded), findsWidgets);
      expect(find.byTooltip(en.viewProfileBtn), findsWidgets);
      expect(find.byIcon(Icons.person_rounded), findsWidgets);

      // Verify side/horizontal filter chips below search bar are removed
      expect(find.text('🟢 ${en.onlineNowFilter}'), findsNothing);
      expect(find.text(en.allMentors), findsNothing);

      // Search by query
      await tester.enterText(find.byType(TextField), 'Selamawit');
      await tester.pumpAndSettle();

      expect(find.text('Selamawit Tadesse'), findsOneWidget);
      expect(find.text('Dawit Haile'), findsNothing);

      // Open Mentor Detail Sheet via Profile Icon Button
      await tester.tap(find.byTooltip(en.viewProfileBtn).first);
      await tester.pumpAndSettle();

      expect(find.byType(MentorDetailSheet), findsOneWidget);
      expect(find.text(en.directContactsHeading), findsOneWidget);
      expect(find.text('+251 91 123 4567'), findsOneWidget);
      expect(find.text('@selam_tya_peer'), findsOneWidget);
      expect(find.text(en.telegramChatAction), findsWidgets);
      expect(find.text(en.sessionsCountLabel), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text(en.languagesSpokenLabel),
        300,
        scrollable: find.byType(Scrollable).last,
      );
      expect(find.text(en.languagesSpokenLabel), findsOneWidget);
      expect(find.text(en.specialtiesLabel), findsOneWidget);
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
      expect(find.text(am.mentorsIntroduction), findsNothing);
      expect(find.text('ሰላማዊት ታደሰ'), findsOneWidget);
      expect(find.byTooltip(am.callMentorAction), findsWidgets);
      expect(find.byTooltip(am.viewProfileBtn), findsWidgets);
      expect(find.byIcon(Icons.person_rounded), findsWidgets);
    });

    testWidgets(
        'UoG Campus glassmorphic dropdown opens, displays campuses, and filters mentors end-to-end',
        (tester) async {
      const repo = LocalVerifiedMentorRepository();
      await tester.pumpWidget(_buildTestApp(repository: repo));
      await tester.pumpAndSettle();

      final en = await AppLocalizations.delegate.load(const Locale('en'));

      // Check campus dropdown trigger pill exists
      final triggerFinder = find.byKey(const Key('uog_campus_dropdown_trigger'));
      expect(triggerFinder, findsOneWidget);
      expect(find.text(en.allCampuses), findsOneWidget);
      expect(find.text('5 mentors'), findsOneWidget);

      // Tap to open glassmorphic dropdown popup
      await tester.tap(triggerFinder);
      await tester.pumpAndSettle();

      // Verify popup content
      expect(find.text(en.uogCampusesTitle), findsOneWidget);
      expect(find.text('Atse Fasil Campus'), findsWidgets);
      expect(find.text('Atse Tewodros Campus'), findsWidgets);
      expect(find.text('CMHS / Health Sciences College'), findsOneWidget);
      expect(find.text('Maraki Campus'), findsWidgets);
      expect(find.text('Teda Campus'), findsWidgets);

      // Tap on 'Atse Tewodros Campus'
      await tester.tap(find.byKey(const Key('campus_option_Atse Tewodros Campus')));
      await tester.pumpAndSettle();

      // Popup is dismissed
      expect(find.text(en.uogCampusesTitle), findsNothing);

      // Verify filtered result: only Dawit Haile from Atse Tewodros Campus
      expect(find.text('Dawit Haile'), findsOneWidget);
      expect(find.text('Selamawit Tadesse'), findsNothing);
      expect(find.text('1 mentor'), findsOneWidget);

      // Check Clear filter button exists
      final clearFinder = find.byKey(const Key('uog_campus_clear_filter'));
      expect(clearFinder, findsOneWidget);

      // Tap Clear filter button
      await tester.tap(clearFinder);
      await tester.pumpAndSettle();

      // All 5 mentors are restored
      expect(find.text('Selamawit Tadesse'), findsOneWidget);
      expect(find.text('Dawit Haile'), findsOneWidget);
      expect(find.text('5 mentors'), findsOneWidget);
      expect(find.byKey(const Key('uog_campus_clear_filter')), findsNothing);
    });

    test('Mentor model cleanTelegramHandle, cleanWhatsapp, and campus localization', () {
      const mentorWithAt = Mentor(
        id: 'dr_hanna',
        nameEn: 'Dr. Hanna Bekele',
        nameAm: 'ዶ/ር ሃና በቀለ',
        titleEn: 'Certified Youth Peer Counselor',
        titleAm: 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
        organizationEn: 'Marie Stopes Ethiopia',
        organizationAm: 'ማሪ ስቶፕስ ኢትዮጵያ',
        campus: 'Atse Fasil Campus',
        whatsapp: '+251913456789',
        email: 'hanna@mariestopes.org.et',
        telegramHandle: '@@dr_hanna_ms',
        bioEn: 'Counselor bio',
        bioAm: 'የአማካሪ መረጃ',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Available Now',
        nextAvailableSlotAm: 'አሁን ይገኛሉ',
        languages: ['English', 'Amharic'],
        topics: [MentorTopic.mentalHealth],
        sessionsCount: 150,
        experienceYears: 4,
        initials: 'HB',
        avatarColor: Color(0xFF0284C7),
      );

      // Verify telegram handle stripping leading @@
      expect(mentorWithAt.cleanTelegramHandle, 'dr_hanna_ms');
      expect('@${mentorWithAt.cleanTelegramHandle}', '@dr_hanna_ms');

      // Verify whatsapp
      expect(mentorWithAt.hasWhatsapp, isTrue);
      expect(mentorWithAt.cleanWhatsapp, '+251913456789');

      // Verify email
      expect(mentorWithAt.hasEmail, isTrue);
      expect(mentorWithAt.email, 'hanna@mariestopes.org.et');

      // Verify username whatsapp (like Nathy _Zemene)
      const mentorWithUsernameWhatsapp = Mentor(
        id: 'nathy_papa',
        nameEn: 'Nathnael papa',
        nameAm: 'ናትናኤል ፓፓ',
        titleEn: 'Certified Youth Peer Counselor',
        titleAm: 'የተረጋገጠ አማካሪ',
        organizationEn: 'UoG',
        organizationAm: 'ዩኦጂ',
        bioEn: 'Counselor bio',
        bioAm: 'የአማካሪ መረጃ',
        whatsapp: 'Nathy _Zemene',
        email: 'natnaelzemene21@gmail.com',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Available Now',
        nextAvailableSlotAm: 'አሁን ይገኛሉ',
        languages: ['English', 'Amharic'],
        topics: [MentorTopic.mentalHealth],
        sessionsCount: 120,
        experienceYears: 2,
        initials: 'NP',
        avatarColor: Color(0xFF0284C7),
      );
      expect(mentorWithUsernameWhatsapp.hasWhatsapp, isTrue);
      expect(mentorWithUsernameWhatsapp.whatsapp, 'Nathy _Zemene');
      expect(mentorWithUsernameWhatsapp.hasEmail, isTrue);

      // Verify campus localization
      expect(mentorWithAt.localizedCampus(false), 'Atse Fasil Campus');
      expect(mentorWithAt.localizedCampus(true), 'አጼ ፋሲል ግቢ');
    });

    testWidgets('MentorDetailSheet displays campus badge, WhatsApp card, email card, and single @',
        (tester) async {
      const testMentor = Mentor(
        id: 'dr_hanna',
        nameEn: 'Dr. Hanna Bekele',
        nameAm: 'ዶ/ር ሃና በቀለ',
        titleEn: 'Certified Youth Peer Counselor',
        titleAm: 'የተረጋገጠ የወጣቶች አቻ አማካሪ',
        organizationEn: 'Marie Stopes Ethiopia',
        organizationAm: 'ማሪ ስቶፕስ ኢትዮጵያ',
        campus: 'Atse Fasil Campus',
        whatsapp: '+251913456789',
        email: 'hanna@mariestopes.org.et',
        telegramHandle: '@dr_hanna_ms',
        bioEn: 'Certified youth mentor offering confidential guidance.',
        bioAm: 'ሚስጥራዊ የአቻ ምክክር።',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Available Now',
        nextAvailableSlotAm: 'አሁን ይገኛሉ',
        languages: ['English', 'Amharic'],
        topics: [MentorTopic.mentalHealth],
        sessionsCount: 120,
        experienceYears: 2,
        initials: 'HB',
        avatarColor: Color(0xFF0284C7),
      );

      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => MentorDetailSheet.show(ctx, testMentor),
                child: const Text('Open Detail'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Detail'));
      await tester.pumpAndSettle();

      // Check campus badge
      expect(find.text('Atse Fasil Campus'), findsOneWidget);

      // Check single @ for telegram
      expect(find.text('@dr_hanna_ms'), findsOneWidget);
      expect(find.text('@@dr_hanna_ms'), findsNothing);

      // Check WhatsApp card
      expect(find.text('WhatsApp'), findsWidgets);
      expect(find.text('+251913456789'), findsWidgets);

      // Check Email Consultation card
      expect(find.text('Email Consultation'), findsOneWidget);
      expect(find.text('hanna@mariestopes.org.et'), findsOneWidget);
      expect(find.text('Send Email'), findsOneWidget);
    });
  });

  group('Mentor Dynamic Languages & Focus Areas Offline Store', () {
    test('OfflineSyncStore serializes and parses dynamic languages and topics', () {
      const dynamicMentor = Mentor(
        id: 'mentor_dynamic_01',
        nameEn: 'Abebe Bikila',
        nameAm: 'አበበ ቢቂላ',
        titleEn: 'Sports & Wellness Mentor',
        titleAm: 'የስፖርት እና ጤናማነት አማካሪ',
        organizationEn: 'Athletics Youth Foundation',
        organizationAm: 'የአትሌቲክስ ወጣቶች ፋውንዴሽን',
        bioEn: 'Promoting youth active life.',
        bioAm: 'ንቁ የወጣቶች ሕይወት ማበረታታት።',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Available Today',
        nextAvailableSlotAm: 'ዛሬ ክፍት ነው',
        languages: ['Afaan Oromoo', 'Amharic', 'English', 'Sidama'],
        topics: [
          MentorTopic.puberty,
          MentorTopic.substanceAbuse,
          MentorTopic.mentalHealth,
        ],
        sessionsCount: 220,
        experienceYears: 5,
        initials: 'AB',
        avatarColor: Color(0xFF0284C7),
      );

      final map = OfflineSyncStore.mentorToMap(dynamicMentor);
      expect(map['languages'], ['Afaan Oromoo', 'Amharic', 'English', 'Sidama']);
      expect(map['topics'], ['puberty', 'substanceAbuse', 'mentalHealth']);

      final restored = OfflineSyncStore.mentorFromMap(map);
      expect(restored.id, 'mentor_dynamic_01');
      expect(restored.languages, ['Afaan Oromoo', 'Amharic', 'English', 'Sidama']);
      expect(restored.topics, containsAll([
        MentorTopic.puberty,
        MentorTopic.substanceAbuse,
        MentorTopic.mentalHealth,
      ]));
    });

    test('OfflineSyncStore parses backend REST payload with specialties and languages', () {
      final backendPayload = <String, dynamic>{
        'id': 'api_mentor_99',
        'name': 'Chaltu Girma',
        'roleTitleEn': 'Adolescent Health Guide',
        'roleTitleAm': 'የአፍላ ወጣቶች ጤና መሪ',
        'organization': 'Oromia Youth Council',
        'campus': 'Maraki Campus',
        'phoneNumber': '+251922334455',
        'telegramHandle': 'chaltu_peer',
        'isAvailable': true,
        'specialties': ['#Puberty', '#SubstanceAbuse', '#MentalHealth'],
        'languages': ['Afaan Oromoo', 'English'],
        'sessionsCount': 75,
        'experienceYears': 3,
      };

      final mentor = OfflineSyncStore.mentorFromMap(backendPayload);
      expect(mentor.id, 'api_mentor_99');
      expect(mentor.nameEn, 'Chaltu Girma');
      expect(mentor.languages, ['Afaan Oromoo', 'English']);
      expect(mentor.topics, containsAll([
        MentorTopic.puberty,
        MentorTopic.substanceAbuse,
        MentorTopic.mentalHealth,
      ]));
      expect(mentor.isOnline, isTrue);
    });

    test('Mentor weekly schedule slot calculation and offline serialization', () {
      const schedule = {
        'monday': DayAvailability(dayKey: 'monday', isEnabled: true, startTime: '09:00', endTime: '12:00'),
        'friday': DayAvailability(dayKey: 'friday', isEnabled: true, startTime: '14:00', endTime: '17:00'),
        'sunday': DayAvailability(dayKey: 'sunday', isEnabled: false),
      };

      const mentor = Mentor(
        id: 'scheduled_mentor',
        nameEn: 'Abebe Bikila',
        nameAm: 'አበበ ቢቂላ',
        titleEn: 'Counselor',
        titleAm: 'አማካሪ',
        organizationEn: 'Athletics Youth Foundation',
        organizationAm: 'የአትሌቲክስ ወጣቶች ፋውንዴሽን',
        bioEn: 'Counselor bio',
        bioAm: 'የአማካሪ መረጃ',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Available Now',
        nextAvailableSlotAm: 'አሁን ይገኛሉ',
        languages: ['Amharic'],
        topics: [MentorTopic.mentalHealth],
        sessionsCount: 50,
        experienceYears: 2,
        initials: 'AB',
        avatarColor: Color(0xFF0284C7),
        weeklySchedule: schedule,
      );

      // Verify active day checks
      expect(mentor.isDayActive(DateTime.monday), isTrue);
      expect(mentor.isDayActive(DateTime.friday), isTrue);
      expect(mentor.isDayActive(DateTime.sunday), isFalse);

      // Verify slot generation for Monday (09:00 - 12:00 -> 6 half-hour slots)
      final mondayDate = DateTime(2026, 11, 16); // Monday
      final slots = mentor.getAvailableSlotsForDate(mondayDate);
      expect(slots, ['9:00 AM', '9:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM']);

      // Sunday has no slots
      final sundayDate = DateTime(2026, 11, 22); // Sunday
      expect(mentor.getAvailableSlotsForDate(sundayDate), isEmpty);

      // Verify round-trip serialization in OfflineSyncStore
      final map = OfflineSyncStore.mentorToMap(mentor);
      expect(map['weeklySchedule'], isNotNull);
      final restored = OfflineSyncStore.mentorFromMap(map);
      expect(restored.isDayActive(DateTime.monday), isTrue);
      expect(restored.isDayActive(DateTime.sunday), isFalse);
    });

    test('Automatic real-time availability calculation for Wednesday 9:07 AM', () {
      final schedule = {
        'monday': const DayAvailability(dayKey: 'monday', isEnabled: true, startTime: '08:30', endTime: '17:30'),
        'tuesday': const DayAvailability(dayKey: 'tuesday', isEnabled: true, startTime: '08:30', endTime: '17:30'),
        'wednesday': const DayAvailability(dayKey: 'wednesday', isEnabled: true, startTime: '08:30', endTime: '17:30'),
        'thursday': const DayAvailability(dayKey: 'thursday', isEnabled: true, startTime: '08:30', endTime: '17:30'),
        'friday': const DayAvailability(dayKey: 'friday', isEnabled: true, startTime: '08:30', endTime: '17:30'),
        'saturday': const DayAvailability(dayKey: 'saturday', isEnabled: false, startTime: '09:00', endTime: '13:00'),
        'sunday': const DayAvailability(dayKey: 'sunday', isEnabled: false, startTime: '09:00', endTime: '13:00'),
      };

      final mentor = Mentor(
        id: 'dr_hanna_bekele',
        nameEn: 'Dr. Hanna Bekele',
        nameAm: 'ዶ/ር ሀና በቀለ',
        titleEn: 'Counselor',
        titleAm: 'አማካሪ',
        organizationEn: 'Marie Stopes',
        organizationAm: 'ማሪ ስቶፕስ',
        bioEn: 'Bio',
        bioAm: 'መረጃ',
        isVerified: true,
        isOnline: false, // Legacy stored flag must NOT block active operating hours!
        nextAvailableSlotEn: 'Available Tomorrow',
        nextAvailableSlotAm: 'ነገ ይገኛሉ',
        languages: const ['Amharic'],
        topics: const [MentorTopic.srhGuidance],
        sessionsCount: 120,
        experienceYears: 2,
        initials: 'DH',
        avatarColor: const Color(0xFF0284C7),
        weeklySchedule: schedule,
      );

      // Wednesday 9:07 AM (2026-11-18 is Wednesday)
      final wednesdayMorning = DateTime(2026, 11, 18, 9, 7);
      expect(mentor.isAvailableAt(wednesdayMorning), isTrue);

      // Wednesday 6:00 PM (18:00 is after 17:30)
      final wednesdayEvening = DateTime(2026, 11, 18, 18, 0);
      expect(mentor.isAvailableAt(wednesdayEvening), isFalse);

      // Next opening calculation from Wednesday 6:00 PM should be Thursday at 8:30 AM
      final nextInfo = mentor.getNextOpeningInfo(wednesdayEvening);
      expect(nextInfo, isNotNull);
      expect(nextInfo!.weekday, DateTime.thursday);
      expect(nextInfo.daysAhead, 1);
      expect(nextInfo.localizedDayLabel(false), 'Tomorrow');

      // Sunday 11:00 AM (Closed day)
      final sundayMorning = DateTime(2026, 11, 22, 11, 0);
      expect(mentor.isAvailableAt(sundayMorning), isFalse);
      final sundayNextInfo = mentor.getNextOpeningInfo(sundayMorning);
      expect(sundayNextInfo, isNotNull);
      expect(sundayNextInfo!.weekday, DateTime.monday);
      expect(sundayNextInfo.daysAhead, 1);
      expect(sundayNextInfo.localizedDayLabel(false), 'Tomorrow');
    });

    testWidgets('Tapping schedule action opens MentorScheduleSheet displaying weekly hours', (tester) async {
      await tester.pumpWidget(_buildTestApp(
        repository: const LocalVerifiedMentorRepository(),
      ));
      await tester.pumpAndSettle();

      // Find calendar button in the action row
      final calendarButton = find.byIcon(Icons.calendar_month_rounded).first;
      expect(calendarButton, findsOneWidget);

      await tester.tap(calendarButton);
      await tester.pumpAndSettle();

      // Verify MentorScheduleSheet modal opens with weekly hours (Monday to Sunday)
      expect(find.byType(MentorScheduleSheet), findsOneWidget);
      expect(find.text('Weekly Availability Hours'), findsOneWidget);
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Tuesday'), findsOneWidget);
      expect(find.text('Wednesday'), findsOneWidget);
      expect(find.text('Friday'), findsOneWidget);
      expect(find.text('Sunday'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);

      // Verify direct contact actions exist inside the sheet
      expect(find.text('Call Mentor'), findsWidgets);

      // Tap top Close icon to dismiss
      await tester.tap(find.byIcon(Icons.close_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(MentorScheduleSheet), findsNothing);
    });
  });
}
