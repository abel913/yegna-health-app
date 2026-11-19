import 'package:flutter/material.dart';

import '../discovery/facility_model.dart';
import '../discovery/mentor_model.dart';

/// Seed templates for verified facilities and mentors.
class DirectoryContentTemplates {
  DirectoryContentTemplates._();

  static const List<Facility> facilityTemplates = [
    Facility(
      id: 'template_uog_clinic',
      nameEn: 'UoG Maraki Student Health & Counseling Center',
      nameAm: 'የጎንደር ዩኒቨርሲቲ ማራኪ የተማሪዎች ጤናና የምክር ማዕከል',
      category: FacilityCategory.clinical,
      subCityEn: 'UoG - Maraki Campus',
      subCityAm: 'ዩኦጂ ማራኪ ካምፓስ',
      campusNameEn: 'UoG - Maraki Campus',
      campusNameAm: 'ዩኦጂ ማራኪ ካምፓስ',
      buildingEn: 'Block 42, Ground Floor (Near Student Lounge)',
      buildingAm: 'ብሎክ 42፣ ምድር ቤት (ከተማሪዎች ማረፊያ አጠገብ)',
      addressEn: 'Inside Maraki Campus, Student Services Wing, Gondar',
      addressAm: 'ማራኪ ካምፓስ ውስጥ፣ የተማሪዎች አገልግሎት ዘርፍ፣ ጎንደር',
      landmarkEn: 'Opposite Student Dining Hall',
      landmarkAm: 'ከተማሪዎች መመገቢያ አዳራሽ ፊት ለፊት',
      focalPerson: 'Sr. Tigist Alemayehu',
      focalPhone: '+251-58-114-1234',
      telegramHandle: 'uog_maraki_health',
      phone: '+251-58-114-1234',
      type: FacilityType.campusClinic,
      latitude: 12.6075,
      longitude: 37.4589,
      distanceKm: 0.5,
      isYouthFriendly: true,
      isFreeForYouth: true,
      isWheelchairAccessible: true,
      hasPrivateRoom: true,
      operatingHours: 'Mon-Fri 08:00 - 18:00, Sat 08:30 - 12:30',
      openingHour: 8,
      closingHour: 18,
      services: [
        '#Youth_Friendly',
        '#Student_Clinic',
        '#SRH_Counseling',
        '#MentalHealth',
        '#Free_Services',
      ],
    ),
  ];

  static const List<Mentor> mentorTemplates = [
    Mentor(
      id: 'template_peer_mentor',
      nameEn: 'Hanan Mohammed',
      nameAm: 'ሀናን መሀመድ',
      titleEn: 'Certified Youth Peer Counselor',
      titleAm: 'የተመሰከረላት የወጣቶች አቻ አማካሪ',
      organizationEn: 'Yegna Health Peer Network',
      organizationAm: 'የእኛ ጤና የአቻ አውታረ መረብ',
      bioEn:
          'Passionate peer mentor with over 4 years experience supporting students through mental wellness, puberty, and relationship questions.',
      bioAm:
          'ለተማሪዎች በአእምሮ ጤና፣ በአፍላ ጉርምስና እና በግንኙነት ጉዳዮች ላይ ከ4 ዓመታት በላይ የአቻ የምክር ድጋፍ የሰጠች አጋዥ አቻ አማካሪ።',
      isVerified: true,
      isOnline: true,
      nextAvailableSlotEn: 'Today at 3:00 PM',
      nextAvailableSlotAm: 'ዛሬ ከቀኑ 9:00',
      languages: ['Amharic', 'English', 'Oromiffa'],
      topics: [
        MentorTopic.mentalHealth,
        MentorTopic.puberty,
        MentorTopic.srhGuidance
      ],
      sessionsCount: 380,
      experienceYears: 4,
      initials: 'HM',
      avatarColor: Color(0xFF0284C7),
      phoneNumber: '+251911998877',
      displayPhoneNumber: '+251 91 199 8877',
      telegramHandle: 'hanan_peer_counselor',
      workingHoursEn: 'Mon – Fri: 9:00 AM – 5:00 PM',
      workingHoursAm: 'ከሰኞ – ዓርብ፡ 3:00 – 11:00',
    ),
  ];
}
