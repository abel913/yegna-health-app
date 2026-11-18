import '../../src/discovery/facility_model.dart';

/// Serialization adapters for caching health facilities offline.
class FacilityOfflineAdapter {
  static Map<String, dynamic> toMap(Facility f) => {
        'id': f.id,
        'nameEn': f.nameEn,
        'nameAm': f.nameAm,
        'category': f.category.toDbString(),
        'subCity': f.subCityEn,
        'subCityEn': f.subCityEn,
        'subCityAm': f.subCityAm,
        'buildingEn': f.buildingEn,
        'buildingAm': f.buildingAm,
        'landmarkEn': f.landmarkEn,
        'landmarkAm': f.landmarkAm,
        'focalPerson': f.focalPerson,
        'focalPhone': f.focalPhone,
        'telegramHandle': f.telegramHandle,
        'addressEn': f.addressEn,
        'addressAm': f.addressAm,
        'phone': f.phone,
        'type': f.type.name,
        'latitude': f.latitude,
        'longitude': f.longitude,
        'distanceKm': f.distanceKm,
        'isYouthFriendly': f.isYouthFriendly,
        'isFreeForYouth': f.isFreeForYouth,
        'isWheelchairAccessible': f.isWheelchairAccessible,
        'hasPrivateRoom': f.hasPrivateRoom,
        'operatingHours': f.operatingHours,
        'openingHour': f.openingHour,
        'closingHour': f.closingHour,
        'isVerified': f.isVerified,
        'services': f.services,
        'campusNameEn': f.campusNameEn ?? f.subCityEn,
        'campusNameAm': f.campusNameAm ?? f.subCityAm,
        'confidentialityPolicyEn': f.confidentialityPolicyEn,
        'confidentialityPolicyAm': f.confidentialityPolicyAm,
      };

  static Facility fromMap(Map<String, dynamic> map) {
    String cleanSubCityStr(String? raw) {
      if (raw == null) return '';
      return raw.replaceAll(RegExp(r'\s+Sub-City', caseSensitive: false), '').trim();
    }

    final rawCampus = (map['subCity'] ?? map['campusNameEn'] ?? map['subCityEn']) as String?;
    final cleanCampus = rawCampus != null && cleanSubCityStr(rawCampus).isNotEmpty
        ? cleanSubCityStr(rawCampus)
        : 'University of Gondar';

    final subCityEn = cleanSubCityStr(map['subCityEn'] as String?).isNotEmpty
        ? cleanSubCityStr(map['subCityEn'] as String?)
        : cleanCampus;
    final subCityAm = cleanSubCityStr(map['subCityAm'] as String?).isNotEmpty
        ? cleanSubCityStr(map['subCityAm'] as String?)
        : (cleanSubCityStr(map['campusNameAm'] as String?).isNotEmpty
            ? cleanSubCityStr(map['campusNameAm'] as String?)
            : cleanCampus);

    final category = FacilityCategory.fromString(map['category'] as String?);
    final operatingHours = map['operatingHours'] as String? ?? '08:30 - 17:30';
    final lowerHours = operatingHours.toLowerCase().trim();
    int openingHour = map['openingHour'] as int? ?? 8;
    int closingHour = map['closingHour'] as int? ?? 18;

    if (lowerHours.contains('24/7') ||
        lowerHours.contains('24 hours') ||
        lowerHours.contains('emergency') ||
        lowerHours.startsWith('open now')) {
      openingHour = 0;
      closingHour = 24;
    } else if (operatingHours.contains('-')) {
      final parts = operatingHours.split('-');
      if (parts.length >= 2) {
        final startRaw = parts[0].trim().replaceAll(RegExp(r'[^0-9]'), '');
        final endRaw = parts[1].trim().replaceAll(RegExp(r'[^0-9]'), '');
        if (startRaw.isNotEmpty) {
          final start = int.tryParse(startRaw.padRight(2, '0').substring(0, 2));
          if (start != null) openingHour = start;
        }
        if (endRaw.isNotEmpty) {
          final end = int.tryParse(endRaw.padRight(2, '0').substring(0, 2));
          if (end != null) closingHour = end;
        }
      }
    }

    final servicesList = (map['services'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        <String>[];

    final typeStr = map['type'] as String? ?? '';
    final type = FacilityType.values.firstWhere(
      (t) => t.name == typeStr,
      orElse: () => FacilityType.campusClinic,
    );

    final rawBuildingEn = (map['buildingEn'] as String?)?.trim();
    final rawWoreda = (map['woreda'] as String?)?.trim();
    final buildingEn = (rawBuildingEn != null && rawBuildingEn.isNotEmpty)
        ? rawBuildingEn
        : ((rawWoreda != null && rawWoreda.isNotEmpty) ? rawWoreda : null);

    return Facility(
      id: map['id']?.toString() ?? 'fac_${DateTime.now().millisecondsSinceEpoch}',
      nameEn: map['nameEn'] as String? ?? 'UoG Campus Facility',
      nameAm: map['nameAm'] as String? ?? 'የዩኒቨርሲቲ ተቋም',
      subCityEn: subCityEn,
      subCityAm: subCityAm,
      category: category,
      buildingEn: buildingEn,
      buildingAm: map['buildingAm'] as String?,
      landmarkEn: map['landmarkEn'] as String? ?? '',
      landmarkAm: map['landmarkAm'] as String? ?? '',
      focalPerson: map['focalPerson'] as String?,
      focalPhone: map['focalPhone'] as String?,
      telegramHandle: map['telegramHandle'] as String?,
      addressEn: map['addressEn'] as String? ?? 'University of Gondar, Gondar, Ethiopia',
      addressAm: map['addressAm'] as String? ?? 'የጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
      phone: map['phone'] as String? ?? '+251-58-114-1234',
      type: type,
      latitude: (map['latitude'] as num?)?.toDouble() ?? 12.6075,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 37.4589,
      distanceKm: (map['distanceKm'] as num?)?.toDouble() ?? 1.5,
      isYouthFriendly: map['isYouthFriendly'] as bool? ?? true,
      isFreeForYouth: map['isFreeForYouth'] as bool? ?? true,
      isWheelchairAccessible: map['isWheelchairAccessible'] as bool? ?? false,
      hasPrivateRoom: map['hasPrivateRoom'] as bool? ?? false,
      operatingHours: operatingHours,
      openingHour: openingHour,
      closingHour: closingHour,
      isVerified: map['isVerified'] as bool? ?? true,
      services: servicesList,
      campusNameEn: cleanCampus,
      campusNameAm: cleanSubCityStr(map['campusNameAm'] as String?).isNotEmpty
          ? cleanSubCityStr(map['campusNameAm'] as String?)
          : cleanCampus,
      confidentialityPolicyEn: map['confidentialityPolicyEn'] as String? ??
          'Private and youth-friendly services. All student health, guidance, and counseling sessions are strictly confidential without mandatory disclosure.',
      confidentialityPolicyAm: map['confidentialityPolicyAm'] as String? ??
          'ሚስጥራዊ እና ለወጣቶች ምቹ የጤና አገልግሎት። ሁሉም የተማሪዎች ጤና፣ ምክር እና ድጋፍ አገልግሎቶች በጥብቅ ሚስጥራዊነት የተጠበቁ ናቸው።',
    );
  }
}
