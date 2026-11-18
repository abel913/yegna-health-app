import 'package:flutter/material.dart';

enum FacilityType {
  publicHealthCenter,
  campusClinic,
  youthCenter,
}

enum FacilityCategory {
  clinical,
  counseling,
  academic,
  studentAffairs,
  sportsDining,
  accessibility;

  static FacilityCategory fromString(String? val) {
    if (val == null) return FacilityCategory.clinical;
    switch (val.toLowerCase().trim()) {
      case 'counseling':
        return FacilityCategory.counseling;
      case 'academic':
        return FacilityCategory.academic;
      case 'student_affairs':
      case 'studentaffairs':
        return FacilityCategory.studentAffairs;
      case 'sports_dining':
      case 'sportsdining':
      case 'sports':
        return FacilityCategory.sportsDining;
      case 'accessibility':
        return FacilityCategory.accessibility;
      case 'clinical':
      default:
        return FacilityCategory.clinical;
    }
  }

  String toDbString() {
    switch (this) {
      case FacilityCategory.clinical:
        return 'clinical';
      case FacilityCategory.counseling:
        return 'counseling';
      case FacilityCategory.academic:
        return 'academic';
      case FacilityCategory.studentAffairs:
        return 'student_affairs';
      case FacilityCategory.sportsDining:
        return 'sports_dining';
      case FacilityCategory.accessibility:
        return 'accessibility';
    }
  }
}

enum FacilityFilterCategory {
  all,
  nearby,
  campus,
  srhVct,
  mentalHealth,
  clinical,
  counseling,
  academic,
  studentAffairs,
  sportsDining,
  accessibility,
}

class Facility {
  const Facility({
    required this.id,
    required this.nameEn,
    required this.nameAm,
    required this.subCityEn,
    required this.subCityAm,
    required this.addressEn,
    required this.addressAm,
    required this.landmarkEn,
    required this.landmarkAm,
    required this.phone,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.isYouthFriendly,
    required this.isFreeForYouth,
    required this.openingHour,
    required this.closingHour,
    required this.services,
    this.category = FacilityCategory.clinical,
    this.buildingEn,
    this.buildingAm,
    this.focalPerson,
    this.focalPhone,
    this.telegramHandle,
    this.isWheelchairAccessible = false,
    this.hasPrivateRoom = false,
    this.operatingHours = '08:30 - 17:30',
    this.isVerified = true,
    this.campusNameEn,
    this.campusNameAm,
    this.confidentialityPolicyEn =
        'Private and youth-friendly services. All reproductive health consultations and screenings are strictly confidential without mandatory parental disclosure.',
    this.confidentialityPolicyAm =
        'ሚስጥራዊ እና ለወጣቶች ምቹ የጤና አገልግሎት። ሁሉም የስነ-ተዋልዶ ጤና ምክክር እና ምርመራዎች ያለ ወላጆች ጣልቃ ገብነት በጥብቅ ሚስጥራዊነት የተጠበቁ ናቸው።',
  });

  final String id;
  final String nameEn;
  final String nameAm;
  final String subCityEn;
  final String subCityAm;
  final String addressEn;
  final String addressAm;
  final String landmarkEn;
  final String landmarkAm;
  final String phone;
  final FacilityType type;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final bool isYouthFriendly;
  final bool isFreeForYouth;
  final int openingHour; // 24h format, e.g. 8
  final int closingHour; // 24h format, e.g. 17
  final List<String> services;
  final FacilityCategory category;
  final String? buildingEn;
  final String? buildingAm;
  final String? focalPerson;
  final String? focalPhone;
  final String? telegramHandle;
  final bool isWheelchairAccessible;
  final bool hasPrivateRoom;
  final String operatingHours;
  final bool isVerified;
  final String? campusNameEn;
  final String? campusNameAm;
  final String confidentialityPolicyEn;
  final String confidentialityPolicyAm;

  String localizedName(bool isAmharic) => isAmharic ? nameAm : nameEn;
  String localizedSubCity(bool isAmharic) {
    final raw = isAmharic ? subCityAm : subCityEn;
    return raw.replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '').trim();
  }
  String localizedAddress(bool isAmharic) => isAmharic ? addressAm : addressEn;
  String localizedLandmark(bool isAmharic) =>
      isAmharic ? landmarkAm : landmarkEn;
  String? localizedCampus(bool isAmharic) {
    final raw = isAmharic ? (campusNameAm ?? subCityAm) : (campusNameEn ?? subCityEn);
    return raw.replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '').trim();
  }
  String? localizedBuilding(bool isAmharic) =>
      isAmharic ? (buildingAm ?? buildingEn) : (buildingEn ?? buildingAm);
  String localizedPolicy(bool isAmharic) =>
      isAmharic ? confidentialityPolicyAm : confidentialityPolicyEn;

  IconData get categoryIcon {
    switch (category) {
      case FacilityCategory.clinical:
        return Icons.medical_services_rounded;
      case FacilityCategory.counseling:
        return Icons.volunteer_activism_rounded;
      case FacilityCategory.academic:
        return Icons.menu_book_rounded;
      case FacilityCategory.studentAffairs:
        return Icons.account_balance_rounded;
      case FacilityCategory.sportsDining:
        return Icons.fitness_center_rounded;
      case FacilityCategory.accessibility:
        return Icons.accessible_forward_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case FacilityCategory.clinical:
        return const Color(0xFF0284C7); // Sky / Teal
      case FacilityCategory.counseling:
        return const Color(0xFF6366F1); // Indigo / Violet
      case FacilityCategory.academic:
        return const Color(0xFF059669); // Emerald
      case FacilityCategory.studentAffairs:
        return const Color(0xFFD97706); // Amber
      case FacilityCategory.sportsDining:
        return const Color(0xFF2563EB); // Royal Blue
      case FacilityCategory.accessibility:
        return const Color(0xFF0D9488); // Cyan / Teal
    }
  }

  bool get isOpenNow {
    final lower = operatingHours.toLowerCase().trim();
    if (lower.contains('24/7') ||
        lower.contains('24 hours') ||
        lower.contains('emergency') ||
        lower.startsWith('open now') ||
        (openingHour == 0 && closingHour >= 24)) {
      return true;
    }
    final now = DateTime.now();
    final hour = now.hour;
    return hour >= openingHour && hour < closingHour;
  }

  Facility copyWith({
    String? id,
    String? nameEn,
    String? nameAm,
    String? subCityEn,
    String? subCityAm,
    String? addressEn,
    String? addressAm,
    String? landmarkEn,
    String? landmarkAm,
    String? phone,
    FacilityType? type,
    double? latitude,
    double? longitude,
    double? distanceKm,
    bool? isYouthFriendly,
    bool? isFreeForYouth,
    int? openingHour,
    int? closingHour,
    List<String>? services,
    FacilityCategory? category,
    String? buildingEn,
    String? buildingAm,
    String? focalPerson,
    String? focalPhone,
    String? telegramHandle,
    bool? isWheelchairAccessible,
    bool? hasPrivateRoom,
    String? operatingHours,
    bool? isVerified,
    String? campusNameEn,
    String? campusNameAm,
    String? confidentialityPolicyEn,
    String? confidentialityPolicyAm,
  }) =>
      Facility(
        id: id ?? this.id,
        nameEn: nameEn ?? this.nameEn,
        nameAm: nameAm ?? this.nameAm,
        subCityEn: subCityEn ?? this.subCityEn,
        subCityAm: subCityAm ?? this.subCityAm,
        addressEn: addressEn ?? this.addressEn,
        addressAm: addressAm ?? this.addressAm,
        landmarkEn: landmarkEn ?? this.landmarkEn,
        landmarkAm: landmarkAm ?? this.landmarkAm,
        phone: phone ?? this.phone,
        type: type ?? this.type,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        distanceKm: distanceKm ?? this.distanceKm,
        isYouthFriendly: isYouthFriendly ?? this.isYouthFriendly,
        isFreeForYouth: isFreeForYouth ?? this.isFreeForYouth,
        openingHour: openingHour ?? this.openingHour,
        closingHour: closingHour ?? this.closingHour,
        services: services ?? this.services,
        category: category ?? this.category,
        buildingEn: buildingEn ?? this.buildingEn,
        buildingAm: buildingAm ?? this.buildingAm,
        focalPerson: focalPerson ?? this.focalPerson,
        focalPhone: focalPhone ?? this.focalPhone,
        telegramHandle: telegramHandle ?? this.telegramHandle,
        isWheelchairAccessible:
            isWheelchairAccessible ?? this.isWheelchairAccessible,
        hasPrivateRoom: hasPrivateRoom ?? this.hasPrivateRoom,
        operatingHours: operatingHours ?? this.operatingHours,
        isVerified: isVerified ?? this.isVerified,
        campusNameEn: campusNameEn ?? this.campusNameEn,
        campusNameAm: campusNameAm ?? this.campusNameAm,
        confidentialityPolicyEn:
            confidentialityPolicyEn ?? this.confidentialityPolicyEn,
        confidentialityPolicyAm:
            confidentialityPolicyAm ?? this.confidentialityPolicyAm,
      );
}
