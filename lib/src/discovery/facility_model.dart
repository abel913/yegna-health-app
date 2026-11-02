enum FacilityType {
  publicHealthCenter,
  campusClinic,
  youthCenter,
}

enum FacilityFilterCategory {
  all,
  nearby,
  campus,
  srhVct,
  mentalHealth,
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
  final String? campusNameEn;
  final String? campusNameAm;
  final String confidentialityPolicyEn;
  final String confidentialityPolicyAm;

  String localizedName(bool isAmharic) => isAmharic ? nameAm : nameEn;
  String localizedSubCity(bool isAmharic) => isAmharic ? subCityAm : subCityEn;
  String localizedAddress(bool isAmharic) => isAmharic ? addressAm : addressEn;
  String localizedLandmark(bool isAmharic) =>
      isAmharic ? landmarkAm : landmarkEn;
  String? localizedCampus(bool isAmharic) =>
      isAmharic ? campusNameAm : campusNameEn;
  String localizedPolicy(bool isAmharic) =>
      isAmharic ? confidentialityPolicyAm : confidentialityPolicyEn;

  bool get isOpenNow {
    final now = DateTime.now();
    // Monday-Friday standard clinic hours (8:30 - 17:30)
    final hour = now.hour;
    return hour >= openingHour && hour < closingHour;
  }

  Facility copyWith({
    double? distanceKm,
  }) =>
      Facility(
        id: id,
        nameEn: nameEn,
        nameAm: nameAm,
        subCityEn: subCityEn,
        subCityAm: subCityAm,
        addressEn: addressEn,
        addressAm: addressAm,
        landmarkEn: landmarkEn,
        landmarkAm: landmarkAm,
        phone: phone,
        type: type,
        latitude: latitude,
        longitude: longitude,
        distanceKm: distanceKm ?? this.distanceKm,
        isYouthFriendly: isYouthFriendly,
        isFreeForYouth: isFreeForYouth,
        openingHour: openingHour,
        closingHour: closingHour,
        services: services,
        campusNameEn: campusNameEn,
        campusNameAm: campusNameAm,
        confidentialityPolicyEn: confidentialityPolicyEn,
        confidentialityPolicyAm: confidentialityPolicyAm,
      );
}
