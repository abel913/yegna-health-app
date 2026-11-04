import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yegna_health_app/src/admin/admin_controller.dart';
import 'package:yegna_health_app/src/admin/admin_models.dart';
import 'package:yegna_health_app/src/admin/admin_repository.dart';
import 'package:yegna_health_app/src/admin/content_templates.dart';
import 'package:yegna_health_app/src/clubs/club_repository.dart';
import 'package:yegna_health_app/src/discovery/facility_model.dart';
import 'package:yegna_health_app/src/discovery/mentor_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Admin Controller & Unified Repository Tests', () {
    late SharedPreferences prefs;
    late ClubRepository clubRepository;
    late AdminRepository adminRepository;
    late AdminController controller;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      clubRepository = LocalClubRepository(preferences: prefs);
      adminRepository = LocalAdminRepository(
        clubRepository: clubRepository,
        preferences: prefs,
      );
      controller = AdminController(repository: adminRepository);
    });

    test('authenticates admin with valid credentials and rejects invalid',
        () async {
      expect(controller.isAuthenticated, isFalse);

      final failed = await controller.signIn('user@test.com', 'wrongPass');
      expect(failed, isFalse);
      expect(controller.isAuthenticated, isFalse);
      expect(controller.errorMessage, isNotNull);

      final success =
          await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      expect(success, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentAdminEmail, 'admin@yegnahealth.org');
      expect(controller.metrics, isNotNull);

      // Verify Natnael Zemene superadmin credentials
      controller.signOut();
      expect(controller.isAuthenticated, isFalse);
      final natnaelSuccess =
          await controller.signIn('natnaelzemene21@gmail.com', 'admin1234');
      expect(natnaelSuccess, isTrue);
      expect(controller.isAuthenticated, isTrue);
      expect(controller.currentAdminEmail, 'natnaelzemene21@gmail.com');
    });

    test('loads dashboard metrics cleanly', () async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      final m = controller.metrics!;

      expect(m.learningModules, greaterThanOrEqualTo(1));
      expect(m.quizQuestions, greaterThanOrEqualTo(2));
      expect(m.activeArticles, greaterThanOrEqualTo(1));
      expect(m.verifiedFacilities, greaterThanOrEqualTo(1));
      expect(m.counselorMentors, greaterThanOrEqualTo(1));
      expect(m.studentClubs, greaterThanOrEqualTo(4));
      expect(m.registeredUsers, greaterThanOrEqualTo(3));
    });

    test('adds, edits, and deletes a learning module', () async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      final initialCount = controller.modules.length;

      const draft = ModuleDraft(
        id: 'new_module_x',
        titleEn: 'Adolescent Nutrition & Growth',
        titleAm: 'የአፍላ ወጣቶች አመጋገብ እና እድገት',
        descriptionEn: 'Balanced diet and active habits for growth.',
        descriptionAm: 'የተመጣጠነ ምግብ እና ንቁ ልምዶች።',
        iconAsset: 'assets/images/yegna_health_icon.png',
        estimatedReadTimeMinutes: 8,
        sections: [
          ModuleSectionDraft(
            titleEn: '1. Food Groups',
            titleAm: '1. የምግብ ምድቦች',
            contentEn: 'Vitamins, proteins, and minerals.',
            contentAm: 'ቫይታሚን እና ፕሮቲን።',
            order: 1,
          ),
        ],
      );

      await controller.saveModule(draft);
      expect(controller.modules.length, initialCount + 1);
      expect(controller.modules.any((m) => m.id == 'new_module_x'), isTrue);

      // Edit
      final updated = ModuleDraft(
        id: 'new_module_x',
        titleEn: 'Adolescent Nutrition & Growth (Updated)',
        titleAm: 'የአፍላ ወጣቶች አመጋገብ እና እድገት (የተሻሻለ)',
        descriptionEn: draft.descriptionEn,
        descriptionAm: draft.descriptionAm,
        iconAsset: draft.iconAsset,
        estimatedReadTimeMinutes: 10,
        sections: draft.sections,
      );
      await controller.saveModule(updated);
      expect(
        controller.modules.firstWhere((m) => m.id == 'new_module_x').titleEn,
        'Adolescent Nutrition & Growth (Updated)',
      );

      // Delete
      await controller.deleteModule('new_module_x');
      expect(controller.modules.length, initialCount);
    });

    test('adds, edits, and deletes a quiz question', () async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      final initialCount = controller.questions.length;

      const question = QuestionDraft(
        id: 'q_test_101',
        quizId: 'general',
        promptEn: 'How much water should adolescents drink daily?',
        promptAm: 'ወጣቶች በየቀኑ ምን ያህል ውሃ መጠጣት አለባቸው?',
        options: [
          QuestionOptionDraft(
            id: 'o1',
            labelEn: 'At least 2 to 3 liters',
            labelAm: 'ቢያንስ ከ 2 እስከ 3 ሊትር',
            isCorrect: true,
          ),
          QuestionOptionDraft(
            id: 'o2',
            labelEn: 'None',
            labelAm: 'ምንም',
            isCorrect: false,
          ),
        ],
        explanationEn: 'Adequate hydration maintains bodily functions.',
        explanationAm: 'በቂ ውሃ መጠጣት የሰውነት ጤንነትን ይጠብቃል።',
      );

      await controller.saveQuestion(question);
      expect(controller.questions.length, initialCount + 1);

      await controller.deleteQuestion('q_test_101');
      expect(controller.questions.length, initialCount);
    });

    test('posts, updates, and deletes an article', () async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      final initialCount = controller.articles.length;

      const article = ArticleDraft(
        id: 'art_new_1',
        titleEn: 'Sleep & Youth Mental Health',
        titleAm: 'እንቅልፍ እና የወጣቶች አእምሮ ጤና',
        summaryEn: 'Why restful sleep resets your emotional wellbeing.',
        summaryAm: 'ጥሩ እንቅልፍ ለስሜታዊ ጤንነት ያለው ጥቅም።',
        bodyMarkdownEn: '### Rest is vital\nSleep allows brain recovery.',
        bodyMarkdownAm: '### እረፍት አስፈላጊ ነው',
        authorName: 'Dr. Hanna',
        category: 'Mental Health',
        sources: ['WHO Guidelines'],
      );

      await controller.saveArticle(article);
      expect(controller.articles.length, initialCount + 1);

      await controller.deleteArticle('art_new_1');
      expect(controller.articles.length, initialCount);
    });

    test('adds and removes health facilities and mentors', () async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      final facCount = controller.facilities.length;
      final mentorCount = controller.mentors.length;

      const fac = Facility(
        id: 'fac_custom_1',
        nameEn: 'Yeka Youth Clinic',
        nameAm: 'የየካ ወጣቶች ክሊኒክ',
        subCityEn: 'Yeka',
        subCityAm: 'የካ',
        addressEn: 'Near Kotebe',
        addressAm: 'ኮተቤ አጠገብ',
        landmarkEn: 'Main Gate',
        landmarkAm: 'ዋና በር',
        phone: '+251-11-223-4455',
        type: FacilityType.youthCenter,
        latitude: 9.02,
        longitude: 38.79,
        distanceKm: 2.0,
        isYouthFriendly: true,
        isFreeForYouth: true,
        openingHour: 8,
        closingHour: 18,
        services: ['SRH', 'VCT'],
      );

      await controller.saveFacility(fac);
      expect(controller.facilities.length, facCount + 1);
      await controller.deleteFacility('fac_custom_1');
      expect(controller.facilities.length, facCount);

      const mentor = Mentor(
        id: 'mentor_custom_1',
        nameEn: 'Marta Girma',
        nameAm: 'ማርታ ግርማ',
        titleEn: 'Peer Educator',
        titleAm: 'የአቻ አስተማሪ',
        organizationEn: 'Health Alliance',
        organizationAm: 'የጤና ህብረት',
        bioEn: 'Counselor bio',
        bioAm: 'የአማካሪ መግለጫ',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Today',
        nextAvailableSlotAm: 'ዛሬ',
        languages: ['Amharic'],
        topics: [MentorTopic.mentalHealth],
        sessionsCount: 50,
        experienceYears: 2,
        initials: 'MG',
        avatarColor: Color(0xFF0284C7),
      );

      await controller.saveMentor(mentor);
      expect(controller.mentors.length, mentorCount + 1);
      await controller.deleteMentor('mentor_custom_1');
      expect(controller.mentors.length, mentorCount);
    });

    test('manages user roles, status toggling, and audit trail', () async {
      await controller.signIn('admin@yegnahealth.org', 'Admin@123');
      final targetUser =
          controller.users.firstWhere((u) => u.id == 'student_usr_02');

      // Update role
      await controller.updateUserRole(targetUser.id, 'mentor');
      final updated =
          controller.users.firstWhere((u) => u.id == 'student_usr_02');
      expect(updated.role, 'mentor');

      // Toggle suspension status
      await controller.toggleUserStatus(targetUser.id);
      final suspended =
          controller.users.firstWhere((u) => u.id == 'student_usr_02');
      expect(suspended.status, AccountStatus.suspended);

      // Verify audit logs were captured
      expect(controller.auditLogs.isNotEmpty, isTrue);
      expect(controller.auditLogs.first.performedBy, 'admin@yegnahealth.org');
    });

    test('database admin accounts can be retrieved and updated', () async {
      await controller.signIn('natnaelzemene21@gmail.com', 'admin1234');
      final accounts = controller.adminAccounts;
      expect(accounts.length, greaterThanOrEqualTo(2));
      expect(
          accounts.any((a) => a.email == 'natnaelzemene21@gmail.com'), isTrue);

      // Save new admin account into database
      final newAccount = AdminAccount(
        id: 'new_admin_09',
        email: 'editor@yegnahealth.org',
        passwordHash: LocalAdminRepository.hashPassword('Editor@2026'),
        displayName: 'Content Editor',
        role: 'contentAuthor',
        isActive: true,
        createdAt: DateTime.now(),
      );
      await controller.saveAdminAccount(newAccount);
      expect(
          controller.adminAccounts
              .any((a) => a.email == 'editor@yegnahealth.org'),
          isTrue);

      // Verify sign in with newly created database admin account
      controller.signOut();
      final editorSuccess =
          await controller.signIn('editor@yegnahealth.org', 'Editor@2026');
      expect(editorSuccess, isTrue);
      expect(controller.currentAdminEmail, 'editor@yegnahealth.org');
    });
  });
}
