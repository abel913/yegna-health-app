import 'facility_model.dart';

abstract class FacilityRepository {
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  });
}

class UnconfiguredFacilityRepository implements FacilityRepository {
  const UnconfiguredFacilityRepository();

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async =>
      const [];
}

class LocalVerifiedFacilityRepository implements FacilityRepository {
  const LocalVerifiedFacilityRepository();

  static const List<Facility> _verifiedFacilities = [
    Facility(
      id: 'arada_youth_center',
      nameEn: 'Arada Youth-Friendly Health Center',
      nameAm: 'የአራዳ ወጣቶች ተስማሚ ጤና ጣቢያ',
      subCityEn: 'Arada Sub-City, Woreda 01',
      subCityAm: 'አራዳ ክፍለ ከተማ፣ ወረዳ 01',
      addressEn: 'Near St. George Church & Churchill Road, Addis Ababa',
      addressAm: 'ቅዱስ ጊዮርጊስ ቤተክርስቲያን እና ቸርችል ጎዳና አጠገብ፣ አዲስ አበባ',
      landmarkEn: 'Behind Arada Sub-City Administration',
      landmarkAm: 'ከአራዳ ክፍለ ከተማ አስተዳደር ጀርባ',
      phone: '+251-11-155-2233',
      type: FacilityType.youthCenter,
      latitude: 9.0345,
      longitude: 38.7521,
      distanceKm: 1.2,
      isYouthFriendly: true,
      isFreeForYouth: true,
      openingHour: 8,
      closingHour: 18,
      services: [
        'SRH Services',
        'VCT / HIV Testing',
        'Mental Health & Counseling',
        'Free Contraceptives',
      ],
    ),
    Facility(
      id: 'aau_sidist_kilo_clinic',
      nameEn: 'AAU Student Health Clinic (Sidist Kilo)',
      nameAm: 'የአዲስ አበባ ዩኒቨርሲቲ ተማሪዎች ክሊኒክ (ስድስት ኪሎ)',
      subCityEn: 'Yeka Sub-City, Sidist Kilo Campus',
      subCityAm: 'የካ ክፍለ ከተማ፣ ስድስት ኪሎ ግቢ',
      addressEn: 'AAU Main Campus, Algeria Street, Addis Ababa',
      addressAm: 'አዲስ አበባ ዩኒቨርሲቲ ዋና ግቢ፣ አልጄሪያ ጎዳና፣ አዲስ አበባ',
      landmarkEn: 'Near Institute of Ethiopian Studies (IES)',
      landmarkAm: 'የኢትዮጵያ ጥናት ተቋም አጠገብ',
      phone: '+251-11-123-9700',
      type: FacilityType.campusClinic,
      latitude: 9.0478,
      longitude: 38.7619,
      distanceKm: 2.5,
      isYouthFriendly: true,
      isFreeForYouth: true,
      openingHour: 8,
      closingHour: 20,
      campusNameEn: 'Addis Ababa University (Main Campus)',
      campusNameAm: 'አዲስ አበባ ዩኒቨርሲቲ (ዋና ግቢ)',
      services: [
        'Campus Student Health',
        'SRH Counseling',
        'Emergency First Aid',
        'Mental Health & Counseling',
      ],
    ),
    Facility(
      id: 'kirkos_youth_center',
      nameEn: 'Kirkos Youth Reproductive Health Center',
      nameAm: 'የቂርቆስ ወጣቶች የስነ-ተዋልዶ ጤና ማዕከል',
      subCityEn: 'Kirkos Sub-City, Woreda 04',
      subCityAm: 'ቂርቆስ ክፍለ ከተማ፣ ወረዳ 04',
      addressEn: 'Meshualekia, near Meskel Square, Addis Ababa',
      addressAm: 'መሸለቂያ፣ መስቀል አደባባይ አጠገብ፣ አዲስ አበባ',
      landmarkEn: 'Next to Kirkos Youth Center & Sports Ground',
      landmarkAm: 'ከቂርቆስ ወጣቶች ማዕከል እና ስፖርት ሜዳ ጎን',
      phone: '+251-11-551-8844',
      type: FacilityType.youthCenter,
      latitude: 9.0112,
      longitude: 38.7582,
      distanceKm: 3.1,
      isYouthFriendly: true,
      isFreeForYouth: true,
      openingHour: 8,
      closingHour: 17,
      services: [
        'SRH Services',
        'VCT / HIV Testing',
        'Mental Health & Counseling',
        'Peer Support & Education',
      ],
    ),
    Facility(
      id: 'bole_17_health_center',
      nameEn: 'Bole 17 Public Health Center',
      nameAm: 'ቦሌ 17 ጤና ጣቢያ',
      subCityEn: 'Bole Sub-City, Woreda 03',
      subCityAm: 'ቦሌ ክፍለ ከተማ፣ ወረዳ 03',
      addressEn: 'Near 22 Mazoria & Lem Hotel, Addis Ababa',
      addressAm: '22 ማዞሪያ እና ሌም ሆቴል አካባቢ፣ አዲስ አበባ',
      landmarkEn: 'Opposite Bole Community High School',
      landmarkAm: 'ከቦሌ ማህበረሰብ ሁለተኛ ደረጃ ት/ቤት ፊት ለፊት',
      phone: '+251-11-662-3311',
      type: FacilityType.publicHealthCenter,
      latitude: 9.0205,
      longitude: 38.7891,
      distanceKm: 4.8,
      isYouthFriendly: true,
      isFreeForYouth: true,
      openingHour: 8,
      closingHour: 18,
      services: [
        'SRH Services',
        'VCT / HIV Testing',
        'Adolescent Health',
        'General Health Checkup',
      ],
    ),
    Facility(
      id: 'aastu_clinic',
      nameEn: 'AASTU Student Health Center (Kilinto Campus)',
      nameAm: 'የአ.ሳ.ቴ.ዩ የተማሪዎች ጤና ማዕከል (ኪሊንጦ)',
      subCityEn: 'Akaki-Kality Sub-City, Kilinto',
      subCityAm: 'አቃቂ ቃሊቲ ክፍለ ከተማ፣ ኪሊንጦ',
      addressEn: 'AASTU Campus, Kality Road, Addis Ababa',
      addressAm: 'የአ.አ.ሳ.ቴ.ዩ ግቢ፣ ቃሊቲ መንገድ፣ አዲስ አበባ',
      landmarkEn: 'AASTU Administration Gate 2',
      landmarkAm: 'የአ.አ.ሳ.ቴ.ዩ አስተዳደር በር 2',
      phone: '+251-11-888-0600',
      type: FacilityType.campusClinic,
      latitude: 8.8872,
      longitude: 38.8105,
      distanceKm: 7.2,
      isYouthFriendly: true,
      isFreeForYouth: true,
      openingHour: 8,
      closingHour: 21,
      campusNameEn: 'Addis Ababa Science & Technology University',
      campusNameAm: 'አዲስ አበባ ሳይንስና ቴክኖሎጂ ዩኒቨርሲቲ',
      services: [
        'Campus Student Health',
        'Emergency First Aid',
        'Mental Health & Counseling',
        'SRH Services',
      ],
    ),
  ];

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    var result = List<Facility>.from(_verifiedFacilities);

    if (category != null && category != FacilityFilterCategory.all) {
      switch (category) {
        case FacilityFilterCategory.nearby:
          result.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
          break;
        case FacilityFilterCategory.campus:
          result = result.where((f) => f.campusNameEn != null).toList();
          break;
        case FacilityFilterCategory.srhVct:
          result = result
              .where((f) =>
                  f.services.any((s) => s.contains('SRH') || s.contains('VCT')))
              .toList();
          break;
        case FacilityFilterCategory.mentalHealth:
          result = result
              .where((f) =>
                  f.services.any((s) => s.toLowerCase().contains('mental')))
              .toList();
          break;
        case FacilityFilterCategory.all:
          break;
      }
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((f) {
        final matchEn = f.nameEn.toLowerCase().contains(clean) ||
            f.subCityEn.toLowerCase().contains(clean) ||
            f.addressEn.toLowerCase().contains(clean) ||
            f.services.any((s) => s.toLowerCase().contains(clean));
        final matchAm = f.nameAm.contains(clean) ||
            f.subCityAm.contains(clean) ||
            f.addressAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }
}

class DynamicFacilityRepository implements FacilityRepository {
  const DynamicFacilityRepository({
    this.customFacilitiesProvider,
    this.fallback = const LocalVerifiedFacilityRepository(),
  });

  final Future<List<Facility>> Function()? customFacilitiesProvider;
  final FacilityRepository fallback;

  @override
  Future<List<Facility>> getFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    final base = await fallback.getFacilities(query: query, category: category);
    if (fallback is UnconfiguredFacilityRepository) {
      return base;
    }
    if (customFacilitiesProvider == null) return base;
    try {
      final custom = await customFacilitiesProvider!();
      final ids = base.map((f) => f.id).toSet();
      final extras = custom.where((f) => !ids.contains(f.id)).toList();
      return [...base, ...extras];
    } catch (_) {
      return base;
    }
  }
}
