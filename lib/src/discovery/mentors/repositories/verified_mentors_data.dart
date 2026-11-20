import 'package:flutter/material.dart';

import '../models/mentor.dart';
import 'uog_central_mentors_data.dart';

export 'uog_central_mentors_data.dart';

const List<Mentor> _uogCampusCounselors = [
  Mentor(
    id: 'berhanu_ashagera',
    nameEn: 'Berhanu Ashagera',
    nameAm: 'ብርሃኑ አሻግሬ',
    titleEn: 'Senior Campus Counselor & Student Advisor',
    titleAm: 'የካምፓስ ከፍተኛ አማካሪ እና የተማሪዎች መካሪ',
    organizationEn: 'UoG Guidance & Counseling (Atse Tewodros)',
    organizationAm: 'የጎንደር ዩኒቨርሲቲ የስነ-ልቦና ምክር (አፄ ቴዎድሮስ)',
    bioEn:
      'Guidance counselor inside students clinic providing confidential help for test anxiety, study habits, addiction recovery, and freshman adjustment.',
    bioAm:
      'በተማሪዎች ክሊኒክ ውስጥ በፈተና ጭንቀት፣ የጥናት ክህሎት፣ የሱስ መቋቋም እና የዩኒቨርሲቲ ቆይታ መላመድ ላይ ሚስጥራዊ እና ሙያዊ የምክር ድጋፍ የሚሰጥ አማካሪ።',
    isVerified: true,
    isOnline: true,
    nextAvailableSlotEn: 'Available Now',
    nextAvailableSlotAm: 'አሁን ይገኛሉ',
    languages: ['Amharic', 'English'],
    topics: [
      MentorTopic.mentalHealth,
      MentorTopic.substanceAbuse,
    ],
    sessionsCount: 480,
    experienceYears: 6,
    initials: 'BA',
    avatarColor: Color(0xFF0284C7),
    phoneNumber: '+251918736102',
    displayPhoneNumber: '+251 91 873 6102',
    telegramHandle: 'berhanu_uog_counselor',
    email: 'brashagrie@gmail.com',
    campus: 'Atse Tewodros Campus',
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  ),
  Mentor(
    id: 'helina_desalghe',
    nameEn: 'Helina Desalghe',
    nameAm: 'ሄሊና ደሳለኝ',
    titleEn: 'Campus Counselor & Peer Support Lead',
    titleAm: 'የካምፓስ ስነ-ልቦና አማካሪ',
    organizationEn: 'UoG Guidance & Counseling (Atse Fasil)',
    organizationAm: 'የጎንደር ዩኒቨርሲቲ የስነ-ልቦና ምክር (አፄ ፋሲል)',
    bioEn:
      'Dedicated counselor inside students clinic helping students navigate academic pressure, interpersonal conflicts, and psychological wellness.',
    bioAm:
      'ተማሪዎች የትምህርት ጫናን እንዲቋቋሙ፣ ጤናማ ማህበራዊ ግንኙነት እንዲገነቡ እና አእምሮአዊ ደህንነታቸውን እንዲጠብቁ የምትረዳ አማካሪ።',
    isVerified: true,
    isOnline: true,
    nextAvailableSlotEn: 'Today at 3:00 PM',
    nextAvailableSlotAm: 'ዛሬ ከቀኑ 9:00',
    languages: ['Amharic', 'English'],
    topics: [
      MentorTopic.mentalHealth,
      MentorTopic.srhGuidance,
    ],
    sessionsCount: 310,
    experienceYears: 4,
    initials: 'HD',
    avatarColor: Color(0xFF7C3AED),
    phoneNumber: '+251918068870',
    displayPhoneNumber: '+251 91 806 8870',
    telegramHandle: 'helina_uog_counselor',
    campus: 'Atse Fasil Campus',
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  ),
  Mentor(
    id: 'rehemate_dawed',
    nameEn: 'Rehemate Dawed',
    nameAm: 'ረህማት ዳውድ',
    titleEn: 'Student Wellbeing & Counseling Officer',
    titleAm: 'የተማሪዎች ደህንነትና ምክር ባለሙያ',
    organizationEn: 'UoG Guidance & Counseling (Maraki)',
    organizationAm: 'የጎንደር ዩኒቨርሲቲ የስነ-ልቦና ምክር (ማራኪ)',
    bioEn:
      'Counselor at Old Library student office helping students overcome homesickness, depression symptoms, and self-esteem challenges.',
    bioAm:
      'በአሮጌው ቤተ-መጽሐፍት ተማሪዎች ቢሮ የናፍቆት ስሜትን፣ ድብርትን እና በራስ መተማመንን ማዳበር ላይ ያተኮረች አማካሪ።',
    isVerified: true,
    isOnline: true,
    nextAvailableSlotEn: 'Available Now',
    nextAvailableSlotAm: 'አሁን ይገኛሉ',
    languages: ['Amharic', 'English'],
    topics: [
      MentorTopic.mentalHealth,
      MentorTopic.puberty,
    ],
    sessionsCount: 420,
    experienceYears: 5,
    initials: 'RD',
    avatarColor: Color(0xFF0D9488),
    phoneNumber: '+251920488192',
    displayPhoneNumber: '+251 92 048 8192',
    telegramHandle: 'rehemate_uog_counselor',
    campus: 'Maraki Campus',
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  ),
  Mentor(
    id: 'saied_desalghe',
    nameEn: 'Saied Desalghe',
    nameAm: 'ሰኢድ ደሳለኝ',
    titleEn: 'Campus Counselor & Student Advisor',
    titleAm: 'የካምፓስ የምክር እና ስነ-ልቦና ባለሙያ',
    organizationEn: 'UoG Guidance & Counseling (Maraki)',
    organizationAm: 'የጎንደር ዩኒቨርሲቲ የስነ-ልቦና ምክር (ማራኪ)',
    bioEn:
      'Empathetic counselor focusing on conflict resolution, time management, and mental resilience under academic stress.',
    bioAm:
      'ተማሪዎች የጊዜ አጠቃቀም ክህሎታቸውን እንዲያሳድጉ፣ ውጥረትን እንዲቆጣጠሩ እና የተረጋጋ ህይወት እንዲመሩ የሚያግዝ አማካሪ።',
    isVerified: true,
    isOnline: true,
    nextAvailableSlotEn: 'Tomorrow at 10:00 AM',
    nextAvailableSlotAm: 'ነገ ጠዋት 4:00',
    languages: ['Amharic', 'English', 'Afaan Oromoo'],
    topics: [
      MentorTopic.mentalHealth,
      MentorTopic.substanceAbuse,
    ],
    sessionsCount: 290,
    experienceYears: 4,
    initials: 'SD',
    avatarColor: Color(0xFFD97706),
    phoneNumber: '+251963727978',
    displayPhoneNumber: '+251 96 372 7978',
    telegramHandle: 'saied_uog_counselor',
    campus: 'Maraki Campus',
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  ),
];

const List<Mentor> verifiedMentors = [
  ...uogCentralMentors,
  ..._uogCampusCounselors,
];
