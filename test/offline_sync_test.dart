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
}
