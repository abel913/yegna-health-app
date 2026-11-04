import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/clubs/club_controller.dart';
import 'package:yegna_health_app/src/clubs/club_models.dart';
import 'package:yegna_health_app/src/clubs/club_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Student Clubs Unit & Controller Tests', () {
    late SharedPreferences prefs;
    late ClubRepository repository;
    late ClubController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      repository = LocalClubRepository(preferences: prefs);
      controller = ClubController(repository: repository);
    });

    test('loads pre-seeded clubs and initial state', () async {
      await controller.loadClubs('student_123');

      expect(controller.clubs.isNotEmpty, isTrue);
      expect(controller.clubs.length, greaterThanOrEqualTo(4));
      expect(controller.isLoading, isFalse);
      expect(controller.joinedCount, 0);
      expect(controller.selectedCategory, ClubCategory.all);
    });

    test('filters clubs by category', () async {
      await controller.loadClubs('student_123');
      controller.setCategory(ClubCategory.mentalHealth);
      await pumpEventQueue();

      expect(
        controller.clubs.every((c) => c.category == ClubCategory.mentalHealth),
        isTrue,
      );
    });

    test('searches clubs by title or topic query', () async {
      await controller.loadClubs('student_123');
      controller.setSearchQuery('Girls');
      await pumpEventQueue();

      expect(
        controller.clubs.any((c) => c.nameEn.contains('Girls')),
        isTrue,
      );
    });

    test('joins club, updates membership, and increments count', () async {
      await controller.loadClubs('student_123');
      final target = controller.clubs.first;
      final initialCount = target.memberCount;

      final joined = await controller.joinClub(
        target.id,
        'student_123',
        userEmail: 'student@aau.edu.et',
        userName: 'Abebe B.',
      );

      expect(joined, isTrue);
      expect(controller.isJoined(target.id), isTrue);
      expect(controller.joinedCount, 1);
      expect(controller.myClubs.length, 1);
      expect(controller.myClubs.first.id, target.id);

      final updatedClub = await repository.getClubById(target.id);
      expect(updatedClub?.memberCount, initialCount + 1);
    });

    test('leaves club, removes membership, and decrements count', () async {
      await controller.loadClubs('student_123');
      final target = controller.clubs.first;

      await controller.joinClub(target.id, 'student_123');
      expect(controller.isJoined(target.id), isTrue);

      final left = await controller.leaveClub(target.id, 'student_123');
      expect(left, isTrue);
      expect(controller.isJoined(target.id), isFalse);
      expect(controller.joinedCount, 0);
      expect(controller.myClubs.isEmpty, isTrue);
    });

    test('toggles showOnlyJoined filter cleanly', () async {
      await controller.loadClubs('student_123');
      final target = controller.clubs.first;
      await controller.joinClub(target.id, 'student_123');

      controller.toggleFilterJoined(true);
      expect(controller.showOnlyJoined, isTrue);
      expect(controller.clubs.length, 1);
      expect(controller.clubs.first.id, target.id);

      controller.toggleFilterJoined(false);
      expect(controller.showOnlyJoined, isFalse);
      expect(controller.clubs.length, greaterThan(1));
    });

    test('saves new club and retrieves member roster', () async {
      final newClub = StudentClub(
        id: 'test_club_99',
        nameEn: 'Youth First Aid & Safety Club',
        nameAm: 'የወጣቶች የመጀመሪያ እርዳታ ክበብ',
        descriptionEn: 'Emergency first aid and disaster readiness skills.',
        descriptionAm: 'የአደጋ ጊዜ የመጀመሪያ እርዳታ ክህሎት።',
        category: ClubCategory.firstAid,
        meetingScheduleEn: 'Saturdays at 10:00 AM',
        meetingScheduleAm: 'ቅዳሜ ከጠዋቱ 4:00',
        meetingLocationEn: 'Red Cross Hall',
        meetingLocationAm: 'ቀይ መስቀል አዳራሽ',
        mentorNameEn: 'Dr. Tadesse',
        mentorNameAm: 'ዶ/ር ታደሰ',
        createdAt: DateTime.now(),
      );

      await repository.saveClub(newClub);
      await controller.loadClubs('student_123');

      expect(controller.clubs.any((c) => c.id == 'test_club_99'), isTrue);

      await controller.joinClub(
        'test_club_99',
        'student_123',
        userName: 'Member Student',
      );
      final roster = await repository.getClubMembers('test_club_99');
      expect(roster.length, 1);
      expect(roster.first.userName, 'Member Student');

      await repository.deleteClub('test_club_99');
      final deleted = await repository.getClubById('test_club_99');
      expect(deleted, isNull);
    });
  });
}
