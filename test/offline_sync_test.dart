import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:yegna_health_app/src/clubs/club_models.dart';
import 'package:yegna_health_app/src/clubs/club_repository.dart';
import 'package:yegna_health_app/src/clubs/sync_club_repository.dart';
import 'package:yegna_health_app/src/discovery/facility_model.dart';
import 'package:yegna_health_app/src/discovery/facility_repository.dart';
import 'package:yegna_health_app/src/discovery/mentor_model.dart';
import 'package:yegna_health_app/src/discovery/mentor_repository.dart';
import 'package:yegna_health_app/src/discovery/sync_facility_repository.dart';
import 'package:yegna_health_app/src/discovery/sync_mentor_repository.dart';
import 'package:yegna_health_app/src/learning/sync_education_repository.dart';
import 'package:yegna_health_app/src/sync/api_client.dart';
import 'package:yegna_health_app/src/sync/offline_sync_store.dart';
import 'package:yegna_health_app/src/sync/sync_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('OfflineSyncStore Tests', () {
    test('Saves and retrieves facilities from local cache', () async {
      final store = OfflineSyncStore();
      expect(await store.getCachedFacilities(), isNull);

      const testFacility = Facility(
        id: 'test_fac_1',
        nameEn: 'Arada Youth Clinic',
        nameAm: 'የአራዳ ወጣቶች ክሊኒክ',
        subCityEn: 'Arada Sub-City',
        subCityAm: 'አራዳ ክፍለ ከተማ',
        addressEn: 'Churchill Road',
        addressAm: 'ቸርችል ጎዳና',
        landmarkEn: 'Near Church',
        landmarkAm: 'ቤተክርስቲያን አጠገብ',
        phone: '+251-11-155-2233',
        type: FacilityType.youthCenter,
        latitude: 9.0345,
        longitude: 38.7521,
        distanceKm: 1.2,
        isYouthFriendly: true,
        isFreeForYouth: true,
        openingHour: 8,
        closingHour: 18,
        services: ['SRH Services', 'Mental Health'],
      );

      await store.saveFacilities([testFacility]);

      final cached = await store.getCachedFacilities();
      expect(cached, isNotNull);
      expect(cached!.length, 1);
      expect(cached.first.id, 'test_fac_1');
      expect(cached.first.nameEn, 'Arada Youth Clinic');
      expect(cached.first.services, contains('SRH Services'));

      final lastSync = await store.getLastSyncTime('facilities');
      expect(lastSync, isNotNull);
    });

    test('Saves and retrieves mentors from local cache', () async {
      final store = OfflineSyncStore();
      expect(await store.getCachedMentors(), isNull);

      const testMentor = Mentor(
        id: 'test_men_1',
        nameEn: 'Selamawit Tadesse',
        nameAm: 'ሰላማዊት ታደሰ',
        titleEn: 'Youth Counselor',
        titleAm: 'የወጣቶች አማካሪ',
        organizationEn: 'TYA',
        organizationAm: 'ታለንት',
        bioEn: 'Counselor bio',
        bioAm: 'የአማካሪ ታሪክ',
        isVerified: true,
        isOnline: true,
        nextAvailableSlotEn: 'Available Now',
        nextAvailableSlotAm: 'አሁን ይገኛሉ',
        languages: ['Amharic', 'English'],
        topics: [MentorTopic.mentalHealth, MentorTopic.srhGuidance],
        sessionsCount: 150,
        experienceYears: 3,
        initials: 'ST',
        avatarColor: Color(0xFF0284C7),
      );

      await store.saveMentors([testMentor]);

      final cached = await store.getCachedMentors();
      expect(cached, isNotNull);
      expect(cached!.length, 1);
      expect(cached.first.id, 'test_men_1');
      expect(cached.first.nameEn, 'Selamawit Tadesse');
      expect(cached.first.topics, contains(MentorTopic.mentalHealth));
    });

    test('Saves and retrieves student clubs from local cache', () async {
      final store = OfflineSyncStore();
      expect(await store.getCachedClubs(), isNull);

      final testClub = StudentClub(
        id: 'test_club_1',
        nameEn: 'Addis Wellness Club',
        nameAm: 'የአዲስ ጤና ክበብ',
        descriptionEn: 'Wellness discussion group',
        descriptionAm: 'የጤና ውይይት ቡድን',
        category: ClubCategory.mentalHealth,
        meetingScheduleEn: 'Saturdays 10:00 AM',
        meetingScheduleAm: 'ቅዳሜ 4:00',
        meetingLocationEn: 'Arada Hall',
        meetingLocationAm: 'አራዳ አዳራሽ',
        mentorNameEn: 'Selamawit',
        mentorNameAm: 'ሰላማዊት',
        memberCount: 25,
        createdAt: DateTime.now(),
      );

      await store.saveClubs([testClub]);

      final cached = await store.getCachedClubs();
      expect(cached, isNotNull);
      expect(cached!.length, 1);
      expect(cached.first.id, 'test_club_1');
      expect(cached.first.category, ClubCategory.mentalHealth);
    });
  });

  group('ApiClient Mock Tests', () {
    test('fetchFacilities parses backend response accurately', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/facilities')) {
          return http.Response(
            jsonEncode({
              'facilities': [
                {
                  'id': 'api_fac_1',
                  'nameEn': 'Kirkos Health Center',
                  'nameAm': 'ቂርቆስ ጤና ጣቢያ',
                  'subCity': 'Kirkos',
                  'woreda': '04',
                  'addressEn': 'Meshualekia',
                  'addressAm': 'መሸለቂያ',
                  'phone': '+251-11-551-8844',
                  'latitude': 9.0112,
                  'longitude': 38.7582,
                  'operatingHours': '08:00 - 18:00',
                  'isVerified': true,
                  'services': ['SRH Services', 'VCT / HIV Testing'],
                }
              ]
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://test-server/api',
        httpClient: mockClient,
      );

      final list = await apiClient.fetchFacilities();
      expect(list, isNotNull);
      expect(list!.length, 1);
      expect(list.first['nameEn'], 'Kirkos Health Center');
    });

    test('Handles server error gracefully without throwing', () async {
      final mockClient = MockClient((request) async {
        return http.Response('Internal Server Error', 500);
      });

      final apiClient = ApiClient(
        baseUrl: 'http://test-server/api',
        httpClient: mockClient,
      );

      final list = await apiClient.fetchFacilities();
      expect(list, isNull);

      final health = await apiClient.checkHealth();
      expect(health, isFalse);
    });
  });

  group('SyncFacilityRepository Offline Tests', () {
    test('Falls back to bundled verified clinics on cold start without network',
        () async {
      final store = OfflineSyncStore();
      final repo = SyncFacilityRepository(
        store: store,
        fallback: const LocalVerifiedFacilityRepository(),
      );

      final facilities = await repo.getFacilities();
      expect(facilities.isNotEmpty, isTrue);
      expect(facilities.any((f) => f.nameEn.contains('Arada')), isTrue);

      // Verify it cached the fallback seed so subsequent reads are immediate
      final cached = await store.getCachedFacilities();
      expect(cached, isNotNull);
      expect(cached!.length, facilities.length);
    });

    test('Filters facilities by category correctly', () async {
      final store = OfflineSyncStore();
      final repo = SyncFacilityRepository(store: store);

      final srhFacilities = await repo.getFacilities(
        category: FacilityFilterCategory.srhVct,
      );
      expect(srhFacilities.isNotEmpty, isTrue);
      for (final f in srhFacilities) {
        expect(
          f.services.any((s) => s.contains('SRH') || s.contains('VCT')),
          isTrue,
        );
      }
    });

    test('Searches facilities by query in English and Amharic', () async {
      final store = OfflineSyncStore();
      final repo = SyncFacilityRepository(store: store);

      final searchEn = await repo.getFacilities(query: 'kirkos');
      expect(searchEn.isNotEmpty, isTrue);

      final searchAm = await repo.getFacilities(query: 'አራዳ');
      expect(searchAm.isNotEmpty, isTrue);
    });
  });

  group('SyncMentorRepository Offline Tests', () {
    test('Falls back to bundled verified mentors on cold start', () async {
      final store = OfflineSyncStore();
      final repo = SyncMentorRepository(
        store: store,
        fallback: const LocalVerifiedMentorRepository(),
      );

      final mentors = await repo.getMentors();
      expect(mentors.isNotEmpty, isTrue);
      expect(mentors.first.nameEn, isNotEmpty);
    });

    test('Filters mentors by topic and online status', () async {
      final store = OfflineSyncStore();
      final repo = SyncMentorRepository(store: store);

      final mentalHealthMentors = await repo.getMentors(
        topic: MentorTopic.mentalHealth,
      );
      expect(mentalHealthMentors.isNotEmpty, isTrue);
      for (final m in mentalHealthMentors) {
        expect(m.topics.contains(MentorTopic.mentalHealth), isTrue);
      }

      final onlineMentors = await repo.getMentors(onlineOnly: true);
      for (final m in onlineMentors) {
        expect(m.isOnline, isTrue);
      }
    });
  });

  group('SyncClubRepository Offline Tests', () {
    test('Allows joining a club offline and persists to local roster', () async {
      final store = OfflineSyncStore();
      final localRepo = LocalClubRepository();
      final repo = SyncClubRepository(
        store: store,
        localRepository: localRepo,
      );

      final clubs = await repo.getClubs();
      expect(clubs.isNotEmpty, isTrue);
      final firstClub = clubs.first;

      const testUserId = 'student_test_user_42';
      final joinResult = await repo.joinClub(
        firstClub.id,
        testUserId,
        userEmail: 'student@aau.edu.et',
        userName: 'Abebe Bikila',
      );
      expect(joinResult, isTrue);

      final joinedIds = await repo.getJoinedClubIds(testUserId);
      expect(joinedIds, contains(firstClub.id));

      final roster = await repo.getClubMembers(firstClub.id);
      expect(roster.any((m) => m.userId == testUserId), isTrue);
    });
  });

  group('SyncEducationRepository Offline Tests', () {
    test('Provides categories and articles with zero network', () async {
      final store = OfflineSyncStore();
      final repo = SyncEducationRepository(store: store);

      final catRes = await repo.categories('en');
      expect(catRes.value.isNotEmpty, isTrue);

      final artRes = await repo.articles('en');
      expect(artRes.value.isNotEmpty, isTrue);

      final firstArticleId = artRes.value.first.id;
      final articleDetail = await repo.article(firstArticleId, 'en');
      expect(articleDetail, isNotNull);
      expect(articleDetail!.value.title, isNotEmpty);
    });
  });

  group('SyncManager Orchestration Tests', () {
    test('Updates status to synced when backend responds with fresh data',
        () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/facilities')) {
          return http.Response(
            jsonEncode({'facilities': []}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/mentors')) {
          return http.Response(
            jsonEncode({'mentors': []}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/modules')) {
          return http.Response(
            jsonEncode({
              'modules': [
                {
                  'id': 'mod_synced_1',
                  'titleEn': 'Adolescent Nutrition',
                  'titleAm': 'የአፍላ ወጣቶች አመጋገብ',
                  'summaryEn': 'Healthy diets for youth.',
                  'summaryAm': 'ለወጣቶች ጤናማ አመጋገብ።',
                  'category': 'wellness',
                }
              ]
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/quizzes')) {
          return http.Response(
            jsonEncode({'questions': []}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        if (request.url.path.endsWith('/clubs')) {
          return http.Response(
            jsonEncode({'clubs': []}),
            200,
            headers: {'content-type': 'application/json'},
          );
        }
        return http.Response('Not Found', 404);
      });

      final store = OfflineSyncStore();
      final apiClient = ApiClient(
        baseUrl: 'http://test-server/api',
        httpClient: mockClient,
      );

      final manager = SyncManager(apiClient: apiClient, store: store);
      expect(manager.status, SyncStatus.idle);

      final success = await manager.syncAll();
      expect(success, isTrue);
      expect(manager.status, SyncStatus.synced);
      expect(manager.lastSyncedAt, isNotNull);

      final cachedModules = await store.getCachedModules();
      expect(cachedModules, isNotNull);
      expect(cachedModules!.first['titleEn'], 'Adolescent Nutrition');
    });

    test('Gracefully sets status to offline when server connection fails',
        () async {
      final mockClient = MockClient((request) async {
        return http.Response('Server Down', 503);
      });

      final store = OfflineSyncStore();
      final apiClient = ApiClient(
        baseUrl: 'http://unreachable-server/api',
        httpClient: mockClient,
      );

      final manager = SyncManager(apiClient: apiClient, store: store);
      final success = await manager.syncAll();
      expect(success, isFalse);
      expect(manager.status, SyncStatus.offline);
      expect(manager.isOffline, isTrue);
    });
  });
}
