import 'facility_model.dart';
import 'sync_facility_repository.dart';

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
      id: 'uog_maraki_student_clinic',
      nameEn: 'UoG Maraki Student Health Center',
      nameAm: 'የጎንደር ዩኒቨርሲቲ ማራኪ የተማሪዎች ጤና ጣቢያ',
      category: FacilityCategory.clinical,
      subCityEn: 'UoG - Maraki Campus',
      subCityAm: 'ዩኦጂ ማራኪ ካምፓስ',
      campusNameEn: 'UoG - Maraki Campus',
      campusNameAm: 'ዩኦጂ ማራኪ ካምፓስ',
      buildingEn: 'Block 42, Ground Floor (Near Student Lounge)',
      buildingAm: 'ብሎክ 42፣ ምድር ቤት (ከተማሪዎች ማረፊያ አጠገብ)',
      landmarkEn: 'Behind Maraki Main Library, Next to Campus Gate 2',
      landmarkAm: 'ከማራኪ ዋና ቤተ-መጽሐፍት ጀርባ፣ ከግቢ በር 2 አጠገብ',
      focalPerson: 'Sr. Tigist Alemayehu (Chief Campus Nurse)',
      focalPhone: '+251-58-114-1234',
      telegramHandle: 'uog_maraki_health',
      phone: '+251-58-114-1234',
      type: FacilityType.campusClinic,
      latitude: 12.6075,
      longitude: 37.4589,
      distanceKm: 0.8,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: true,
      hasPrivateRoom: true,
      operatingHours: 'Mon-Fri 08:00 - 18:00, Sat 08:30 - 12:30',
      openingHour: 8,
      closingHour: 18,
      addressEn: 'Maraki Campus, University of Gondar, Gondar, Ethiopia',
      addressAm: 'ማራኪ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
      services: [
        '#Youth_Friendly',
        '#Student_Clinic',
        '#SRH_Counseling',
        '#Free_Services',
        '#First_Aid',
      ],
    ),
    Facility(
      id: 'uog_gcms_adolescent_clinic',
      nameEn:
          'UoG Comprehensive Specialized Hospital (GCMS) Adolescent Clinic',
      nameAm: 'የጎንደር ዩኒቨርሲቲ ኮምፕረሄንሲቭ ስፔሻላይዝድ ሆስፒታል የወጣቶች ክሊኒክ',
      category: FacilityCategory.clinical,
      subCityEn: 'UoG - GCMS Referral Hospital / CMHS',
      subCityAm: 'ዩኦጂ ሪፈራል ሆስፒታል / CMHS',
      campusNameEn: 'UoG - GCMS Referral Hospital / CMHS',
      campusNameAm: 'ዩኦጂ ሪፈራል ሆስፒታል / CMHS',
      buildingEn: 'CMHS Clinical Block, OPD Room 14',
      buildingAm: 'የጤና ሳይንስ ክሊኒካል ብሎክ፣ ታካሚ ክፍል 14',
      landmarkEn: 'Opposite Chechela Police Station, Referral Main Gate',
      landmarkAm: 'ከቼቼላ ፖሊስ ጣቢያ ፊት ለፊት፣ ከዋናው የሪፈራል በር',
      focalPerson: 'Dr. Yohannes Tadesse (Youth Specialist)',
      focalPhone: '+251-58-111-0422',
      telegramHandle: 'uog_referral_youth',
      phone: '+251-58-111-0422',
      type: FacilityType.publicHealthCenter,
      latitude: 12.6133,
      longitude: 37.4642,
      distanceKm: 1.5,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: true,
      hasPrivateRoom: true,
      operatingHours: '24/7 Emergency & Specialty Care',
      openingHour: 0,
      closingHour: 24,
      addressEn: 'Chechela, CMHS Hospital Compound, Gondar, Ethiopia',
      addressAm: 'ቼቼላ፣ ጤና ሳይንስ ሆስፒታል ግቢ፣ ጎንደር፣ ኢትዮጵያ',
      services: [
        '#Adolescent_Clinic',
        '#Specialized_Care',
        '#Emergency_Care',
        '#HIV_Testing',
        '#MentalHealth',
      ],
    ),
    Facility(
      id: 'uog_maraki_guidance_center',
      nameEn: 'UoG Maraki Guidance & Psychological Counseling Center',
      nameAm: 'የማራኪ ተማሪዎች ስነ-ልቦና ምክር እና ድጋፍ ማዕከል',
      category: FacilityCategory.counseling,
      subCityEn: 'UoG - Maraki Campus',
      subCityAm: 'ዩኦጂ ማራኪ ካምፓስ',
      campusNameEn: 'UoG - Maraki Campus',
      campusNameAm: 'ዩኦጂ ማራኪ ካምፓስ',
      buildingEn: 'Dean of Students Building, 2nd Floor, Room 204',
      buildingAm: 'የተማሪዎች ዲን ህንፃ፣ 2ኛ ፎቅ፣ ቢሮ ቁጥር 204',
      landmarkEn: 'Above Gender Office, Opposite Student Cafeteria',
      landmarkAm: 'ከስርዓተ-ፆታ ቢሮ በላይ፣ ከተማሪዎች ካፌ ፊት ለፊት',
      focalPerson: 'Mulugeta Worku (Counselor)',
      focalPhone: '+251-58-114-1299',
      telegramHandle: 'uog_counseling_support',
      phone: '+251-58-114-1299',
      type: FacilityType.youthCenter,
      latitude: 12.6080,
      longitude: 37.4595,
      distanceKm: 0.9,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: false,
      hasPrivateRoom: true,
      operatingHours: 'Mon-Fri 08:30 - 17:30',
      openingHour: 8,
      closingHour: 18,
      addressEn: 'Maraki Campus, University of Gondar, Gondar, Ethiopia',
      addressAm: 'ማራኪ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
      services: [
        '#MentalHealth',
        '#SRH_Counseling',
        '#Peer_Counseling',
        '#Confidential_Support',
      ],
    ),
    Facility(
      id: 'uog_tewodros_health_post',
      nameEn: 'UoG Atse Tewodros Campus Health Post & First Aid',
      nameAm: 'የአፄ ቴዎድሮስ ካምፓስ የመጀመሪያ እርዳታ እና ጤና ኬላ',
      category: FacilityCategory.clinical,
      subCityEn: 'UoG - Atse Tewodros Campus',
      subCityAm: 'ዩኦጂ አፄ ቴዎድሮስ ካምፓስ',
      campusNameEn: 'UoG - Atse Tewodros Campus',
      campusNameAm: 'ዩኦጂ አፄ ቴዎድሮስ ካምፓስ',
      buildingEn: 'Engineering Workshop Wing, Block 12',
      buildingAm: 'ኢንጂነሪንግ ወርክሾፕ ክንፍ፣ ብሎክ 12',
      landmarkEn: 'Near Technology Faculty Gate & Sports Field',
      landmarkAm: 'ከቴክኖሎጂ ፋኩልቲ መግቢያ በር እና ስፖርት ሜዳ አጠገብ',
      focalPerson: 'Alemayehu Bogale (Health Officer)',
      focalPhone: '+251-58-114-2200',
      telegramHandle: 'uog_tewodros_clinic',
      phone: '+251-58-114-2200',
      type: FacilityType.campusClinic,
      latitude: 12.5982,
      longitude: 37.4520,
      distanceKm: 2.1,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: true,
      hasPrivateRoom: true,
      operatingHours: 'Mon-Fri 08:00 - 18:00',
      openingHour: 8,
      closingHour: 18,
      addressEn:
          'Atse Tewodros Campus, University of Gondar, Gondar, Ethiopia',
      addressAm: 'አፄ ቴዎድሮስ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
      services: [
        '#First_Aid',
        '#Student_Clinic',
        '#Emergency_Care',
        '#Free_Services',
      ],
    ),
    Facility(
      id: 'uog_fasil_student_clinic',
      nameEn: 'UoG Fasil Campus Student Clinic',
      nameAm: 'የፋሲል ካምፓስ የተማሪዎች ጤና ማዕከል',
      category: FacilityCategory.clinical,
      subCityEn: 'UoG - Fasil Campus',
      subCityAm: 'ዩኦጂ ፋሲል ካምፓስ',
      campusNameEn: 'UoG - Fasil Campus',
      campusNameAm: 'ዩኦጂ ፋሲል ካምፓስ',
      buildingEn: 'Natural Sciences Block, Ground Floor',
      buildingAm: 'የተፈጥሮ ሳይንስ ብሎክ፣ ምድር ቤት',
      landmarkEn: 'Near Main Auditorium and Fasil Dining Hall',
      landmarkAm: 'ከዋናው አዳራሽ እና ከፋሲል የተማሪዎች መመገቢያ አዳራሽ አጠገብ',
      focalPerson: 'Sister Hiwot (Nurse In-Charge)',
      focalPhone: '+251-58-114-3311',
      telegramHandle: 'uog_fasil_health',
      phone: '+251-58-114-3311',
      type: FacilityType.campusClinic,
      latitude: 12.6025,
      longitude: 37.4485,
      distanceKm: 2.8,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: true,
      hasPrivateRoom: true,
      operatingHours: 'Mon-Fri 08:30 - 17:30',
      openingHour: 8,
      closingHour: 18,
      addressEn: 'Fasil Campus, University of Gondar, Gondar, Ethiopia',
      addressAm: 'ፋሲል ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
      services: [
        '#Youth_Friendly',
        '#Student_Clinic',
        '#SRH_Counseling',
        '#First_Aid',
      ],
    ),
    Facility(
      id: 'uog_tseda_health_center',
      nameEn: 'UoG Tseda Campus Health & First Aid Center',
      nameAm: 'የጼዳ ካምፓስ የጤና እና የመጀመሪያ እርዳታ ማዕከል',
      category: FacilityCategory.clinical,
      subCityEn: 'UoG - Tseda Campus',
      subCityAm: 'ዩኦጂ ጼዳ ካምፓስ',
      campusNameEn: 'UoG - Tseda Campus',
      campusNameAm: 'ዩኦጂ ጼዳ ካምፓስ',
      buildingEn: 'Agricultural Science Complex, Room 05',
      buildingAm: 'የግብርና ሳይንስ ኮምፕሌክስ፣ ቢሮ ቁጥር 05',
      landmarkEn: 'Next to Administration Gate, Tseda Field Compound',
      landmarkAm: 'ከአስተዳደር በር አጠገብ፣ የጼዳ መስክ ግቢ',
      focalPerson: 'Ephrem G. (Emergency Medic)',
      focalPhone: '+251-58-114-4422',
      telegramHandle: 'uog_tseda_clinic',
      phone: '+251-58-114-4422',
      type: FacilityType.campusClinic,
      latitude: 12.5510,
      longitude: 37.4820,
      distanceKm: 8.5,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: true,
      hasPrivateRoom: true,
      operatingHours: 'Mon-Fri 08:30 - 17:00',
      openingHour: 8,
      closingHour: 17,
      addressEn: 'Tseda Campus, University of Gondar, Tseda, Ethiopia',
      addressAm: 'ጼዳ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጼዳ፣ ኢትዮጵያ',
      services: [
        '#First_Aid',
        '#Student_Clinic',
        '#Emergency_Care',
        '#Disability_Support',
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
                  f.services.any((s) => s.toLowerCase().contains('mental')) ||
                  f.category == FacilityCategory.counseling)
              .toList();
          break;
        case FacilityFilterCategory.clinical:
          result =
              result.where((f) => f.category == FacilityCategory.clinical).toList();
          break;
        case FacilityFilterCategory.counseling:
          result = result
              .where((f) => f.category == FacilityCategory.counseling)
              .toList();
          break;
        case FacilityFilterCategory.academic:
          result =
              result.where((f) => f.category == FacilityCategory.academic).toList();
          break;
        case FacilityFilterCategory.studentAffairs:
          result = result
              .where((f) => f.category == FacilityCategory.studentAffairs)
              .toList();
          break;
        case FacilityFilterCategory.sportsDining:
          result = result
              .where((f) => f.category == FacilityCategory.sportsDining)
              .toList();
          break;
        case FacilityFilterCategory.accessibility:
          result = result
              .where((f) =>
                  f.category == FacilityCategory.accessibility ||
                  f.isWheelchairAccessible)
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
            (f.buildingEn?.toLowerCase().contains(clean) ?? false) ||
            f.addressEn.toLowerCase().contains(clean) ||
            f.services.any((s) => s.toLowerCase().contains(clean));
        final matchAm = f.nameAm.contains(clean) ||
            f.subCityAm.contains(clean) ||
            (f.buildingAm?.contains(clean) ?? false) ||
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

  Future<List<Facility>> refreshFacilities({
    String? query,
    FacilityFilterCategory? category,
  }) async {
    final fb = fallback;
    List<Facility> base;
    if (fb is SyncFacilityRepository) {
      base = await fb.refreshFacilities(query: query, category: category);
    } else {
      base = await fb.getFacilities(query: query, category: category);
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
