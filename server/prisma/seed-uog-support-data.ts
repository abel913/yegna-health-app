import 'dotenv/config';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

const databaseUrl = process.env.DIRECT_URL || process.env.DATABASE_URL;
if (!databaseUrl) {
  throw new Error('Set DIRECT_URL or DATABASE_URL before seeding UoG support services.');
}

let schema: string | undefined;
try {
  const parsedUrl = new URL(databaseUrl);
  schema = parsedUrl.searchParams.get('schema') || 'yegna';
} catch (_) {
  schema = 'yegna';
}

const prisma = new PrismaClient({
  adapter: new PrismaPg({ connectionString: databaseUrl }, { schema }),
});

interface FacilitySeed {
  id: string;
  nameEn: string;
  nameAm: string;
  category: string;
  subCity: string;
  buildingEn: string;
  buildingAm: string;
  landmarkEn: string;
  landmarkAm: string;
  focalPerson: string;
  focalPhone: string;
  phone: string;
  telegramHandle: string;
  addressEn: string;
  addressAm: string;
  latitude: number;
  longitude: number;
  operatingHours: string;
  isVerified: boolean;
  isWheelchairAccessible: boolean;
  hasPrivateRoom: boolean;
  services: string[];
}

const UOG_FACILITIES: FacilitySeed[] = [
  // 1. Maraki Student Clinic
  {
    id: 'uog_maraki_student_clinic',
    nameEn: 'UoG Maraki Student Health Center',
    nameAm: 'የጎንደር ዩኒቨርሲቲ ማራኪ የተማሪዎች ጤና ጣቢያ',
    category: 'clinical',
    subCity: 'UoG - Maraki Campus',
    buildingEn: 'Block 42, Ground Floor (Near Student Lounge)',
    buildingAm: 'ብሎክ 42፣ ምድር ቤት (ከተማሪዎች ማረፊያ አጠገብ)',
    landmarkEn: 'Behind Maraki Main Library, Next to Campus Gate 2',
    landmarkAm: 'ከማራኪ ዋና ቤተ-መጽሐፍት ጀርባ፣ ከግቢ በር 2 አጠገብ',
    focalPerson: 'Ato Eshete Wube (Head: 0918735495) / Sr. Mulu Gebeya (0911543471)',
    focalPhone: '+251918735495',
    phone: '+251918735495',
    telegramHandle: 'uog_maraki_clinic',
    addressEn: 'Maraki Campus, University of Gondar, Gondar, Ethiopia',
    addressAm: 'ማራኪ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.6075,
    longitude: 37.4589,
    operatingHours: '24/7 (24hr Examination, Lab, & Pharmacy)',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#24hr_Exam',
      '#24hr_Pharmacy',
      '#24hr_Lab',
      '#FamilyPlanning',
      '#STI_TB_HIV',
      '#SickLeaveEvidence',
      '#Student_Clinic',
      '#Free_Services',
    ],
  },
  // 2. Maraki Guidance Center
  {
    id: 'uog_maraki_guidance_center',
    nameEn: 'UoG Maraki Guidance & Psychological Counseling Center',
    nameAm: 'የማራኪ ተማሪዎች ስነ-ልቦና ምክር እና ድጋፍ ማዕከል',
    category: 'counseling',
    subCity: 'UoG - Maraki Campus',
    buildingEn: 'Old Library, Student Dean Office',
    buildingAm: 'አሮጌው ቤተ-መጽሐፍት፣ የተማሪዎች ዲን ቢሮ',
    landmarkEn: 'Old Library Building, Student Dean Wing',
    landmarkAm: 'አሮጌው ቤተ-መጽሐፍት ህንፃ፣ የተማሪዎች ዲን ክንፍ',
    focalPerson: 'Rehemate Dawed (0920488192) / Saied Desalghe (0963727978)',
    focalPhone: '+251920488192',
    phone: '+251920488192',
    telegramHandle: 'uog_maraki_counseling',
    addressEn: 'Maraki Campus, University of Gondar, Gondar, Ethiopia',
    addressAm: 'ማራኪ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.6080,
    longitude: 37.4595,
    operatingHours: 'Mon-Fri 08:30 - 17:30',
    isVerified: true,
    isWheelchairAccessible: false,
    hasPrivateRoom: true,
    services: [
      '#MentalHealth',
      '#DepressionSupport',
      '#StressManagement',
      '#Homesickness',
      '#AddictionSupport',
      '#ConfidentialCounseling',
    ],
  },
  // 3. Atse Tewodros Student Clinic
  {
    id: 'uog_tewodros_health_post',
    nameEn: 'UoG Atse Tewodros Campus Student Clinic',
    nameAm: 'የአፄ ቴዎድሮስ ካምፓስ የተማሪዎች ጤና ጣቢያ',
    category: 'clinical',
    subCity: 'UoG - Atse Tewodros Campus',
    buildingEn: 'Technology Campus Clinical Block',
    buildingAm: 'የቴክኖሎጂ ግቢ ክሊኒካል ብሎክ',
    landmarkEn: 'Near Technology Faculty Gate & Sports Field',
    landmarkAm: 'ከቴክኖሎጂ ፋኩልቲ መግቢያ በር እና ስፖርት ሜዳ አጠገብ',
    focalPerson: 'Ato Getu Admasu (Head: 0918729899) / Sr. Habtam Reda (0953250303)',
    focalPhone: '+251918729899',
    phone: '+251918711993',
    telegramHandle: 'uog_tewodros_clinic',
    addressEn: 'Atse Tewodros Campus, University of Gondar, Gondar, Ethiopia',
    addressAm: 'አፄ ቴዎድሮስ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.5982,
    longitude: 37.4520,
    operatingHours: '24/7 (24hr Examination, Lab, & Pharmacy)',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#24hr_Exam',
      '#24hr_Pharmacy',
      '#24hr_Lab',
      '#FamilyPlanning',
      '#STI_TB_HIV',
      '#SickLeaveEvidence',
      '#Student_Clinic',
    ],
  },
  // 4. Atse Tewodros Guidance Center
  {
    id: 'uog_tewodros_guidance_center',
    nameEn: 'UoG Atse Tewodros Guidance & Counseling Office',
    nameAm: 'የአፄ ቴዎድሮስ ካምፓስ የተማሪዎች የምክርና ስነ-ልቦና ቢሮ',
    category: 'counseling',
    subCity: 'UoG - Atse Tewodros Campus',
    buildingEn: 'Inside Students Clinic Building',
    buildingAm: 'በተማሪዎች ክሊኒክ ህንፃ ውስጥ',
    landmarkEn: 'Inside Students Clinic, Counseling Section',
    landmarkAm: 'በተማሪዎች ክሊኒክ ውስጥ፣ የምክር ክፍል',
    focalPerson: 'Berhanu Ashagera (0918736102 / 0918616277)',
    focalPhone: '+251918736102',
    phone: '+251918736102',
    telegramHandle: 'uog_tewodros_counseling',
    addressEn: 'Atse Tewodros Campus, University of Gondar, Gondar, Ethiopia',
    addressAm: 'አፄ ቴዎድሮስ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.5985,
    longitude: 37.4523,
    operatingHours: 'Mon-Fri 08:30 - 17:30',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#MentalHealth',
      '#ExamStress',
      '#StudySkills',
      '#AddictionSupport',
      '#ConfidentialCounseling',
    ],
  },
  // 5. Atse Fasil Student Clinic
  {
    id: 'uog_fasil_student_clinic',
    nameEn: 'UoG Atse Fasil Campus Student Clinic',
    nameAm: 'የአፄ ፋሲል ካምፓስ የተማሪዎች ጤና ማዕከል',
    category: 'clinical',
    subCity: 'UoG - Atse Fasil Campus',
    buildingEn: 'Natural Sciences Block, Ground Floor',
    buildingAm: 'የተፈጥሮ ሳይንስ ብሎክ፣ ምድር ቤት',
    landmarkEn: 'Near Main Auditorium and Fasil Dining Hall',
    landmarkAm: 'ከዋናው አዳራሽ እና ከፋሲል የተማሪዎች መመገቢያ አዳራሽ አጠገብ',
    focalPerson: 'Ato Biruk Bogale (Head: 0918232881) / Sr. Tseganesh G/M (0912692519)',
    focalPhone: '+251918232881',
    phone: '+251918232881',
    telegramHandle: 'uog_fasil_clinic',
    addressEn: 'Atse Fasil Campus, University of Gondar, Gondar, Ethiopia',
    addressAm: 'አፄ ፋሲል ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.6025,
    longitude: 37.4485,
    operatingHours: '24/7 (24hr Examination, Lab, & Pharmacy)',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#24hr_Exam',
      '#24hr_Pharmacy',
      '#24hr_Lab',
      '#FamilyPlanning',
      '#STI_TB_HIV',
      '#SickLeaveEvidence',
      '#Student_Clinic',
    ],
  },
  // 6. Atse Fasil Guidance Center
  {
    id: 'uog_fasil_guidance_center',
    nameEn: 'UoG Atse Fasil Guidance & Psychological Counseling Office',
    nameAm: 'የአፄ ፋሲል ካምፓስ የተማሪዎች የምክርና ስነ-ልቦና ቢሮ',
    category: 'counseling',
    subCity: 'UoG - Atse Fasil Campus',
    buildingEn: 'Inside Students Clinic Building',
    buildingAm: 'በተማሪዎች ክሊኒክ ህንፃ ውስጥ',
    landmarkEn: 'Inside Fasil Students Clinic',
    landmarkAm: 'በፋሲል ተማሪዎች ክሊኒክ ውስጥ',
    focalPerson: 'Ayalnesh Adgo (0911719684) / Helina Desalghe (0918068870)',
    focalPhone: '+251911719684',
    phone: '+251911719684',
    telegramHandle: 'uog_fasil_counseling',
    addressEn: 'Atse Fasil Campus, University of Gondar, Gondar, Ethiopia',
    addressAm: 'አፄ ፋሲል ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.6028,
    longitude: 37.4488,
    operatingHours: 'Mon-Fri 08:30 - 17:30',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#MentalHealth',
      '#RelationshipCounseling',
      '#HarassmentSupport',
      '#DecisionMaking',
      '#ConfidentialCounseling',
    ],
  },
  // 7. Tseda Student Clinic
  {
    id: 'uog_tseda_health_center',
    nameEn: 'UoG Tseda Campus Student Health Center',
    nameAm: 'የጼዳ ካምፓስ የተማሪዎች ጤና ማዕከል',
    category: 'clinical',
    subCity: 'UoG - Tseda Campus',
    buildingEn: 'Agricultural Science Complex, Room 05',
    buildingAm: 'የግብርና ሳይንስ ኮምፕሌክስ፣ ቢሮ ቁጥር 05',
    landmarkEn: 'Next to Administration Gate, Tseda Field Compound',
    landmarkAm: 'ከአስተዳደር በር አጠገብ፣ የጼዳ መስክ ግቢ',
    focalPerson: 'Ato Amare Molla (Head: 0920216525) / Ato Fasil Getu (0939612644)',
    focalPhone: '+251920216525',
    phone: '+251920216525',
    telegramHandle: 'uog_tseda_clinic',
    addressEn: 'Tseda Campus, University of Gondar, Tseda, Ethiopia',
    addressAm: 'ጼዳ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጼዳ፣ ኢትዮጵያ',
    latitude: 12.5510,
    longitude: 37.4820,
    operatingHours: '24/7 (24hr Examination, Lab, & Pharmacy)',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#24hr_Exam',
      '#24hr_Pharmacy',
      '#24hr_Lab',
      '#FamilyPlanning',
      '#STI_TB_HIV',
      '#SickLeaveEvidence',
      '#Student_Clinic',
    ],
  },
  // 8. Tseda Guidance Center
  {
    id: 'uog_tseda_guidance_center',
    nameEn: 'UoG Tseda Guidance & Student Counseling Office',
    nameAm: 'የጼዳ ካምፓስ የተማሪዎች የምክርና ስነ-ልቦና ቢሮ',
    category: 'counseling',
    subCity: 'UoG - Tseda Campus',
    buildingEn: 'Administrative Building, 4th Floor',
    buildingAm: 'አስተዳደር ህንፃ፣ 4ኛ ፎቅ',
    landmarkEn: 'Administrative Building, 4th Floor',
    landmarkAm: 'አስተዳደር ህንፃ፣ 4ኛ ፎቅ',
    focalPerson: 'Tseda Campus Counseling Officer (0918605438)',
    focalPhone: '+251918605438',
    phone: '+251918605438',
    telegramHandle: 'uog_tseda_counseling',
    addressEn: 'Tseda Campus, University of Gondar, Tseda, Ethiopia',
    addressAm: 'ጼዳ ግቢ፣ ጎንደር ዩኒቨርሲቲ፣ ጼዳ፣ ኢትዮጵያ',
    latitude: 12.5512,
    longitude: 37.4822,
    operatingHours: 'Mon-Fri 08:30 - 17:30',
    isVerified: true,
    isWheelchairAccessible: false,
    hasPrivateRoom: true,
    services: [
      '#MentalHealth',
      '#Homesickness',
      '#Adjustment',
      '#StudySkills',
      '#ConfidentialCounseling',
    ],
  },
  // 9. CMHS Student Clinic
  {
    id: 'uog_gcms_adolescent_clinic',
    nameEn: 'UoG College of Medicine & Health Sciences Student Clinic',
    nameAm: 'የጎንደር ዩኒቨርሲቲ ህ/ጤ/ሳ/ኮ የተማሪዎች ክሊኒክ',
    category: 'clinical',
    subCity: 'UoG - GCMS Referral Hospital / CMHS',
    buildingEn: 'CMHS Clinical Block, OPD Room 14',
    buildingAm: 'የጤና ሳይንስ ክሊኒካል ብሎክ፣ ታካሚ ክፍል 14',
    landmarkEn: 'Opposite Chechela Police Station, Referral Hospital Main Gate',
    landmarkAm: 'ከቼቼላ ፖሊስ ጣቢያ ፊት ለፊት፣ ከዋናው የሪፈራል በር',
    focalPerson: 'Sr. Halima Mohammed (Head: 0975534866) / Ato Adugna Ayalew (0918036741)',
    focalPhone: '+251975534866',
    phone: '+251975534866',
    telegramHandle: 'uog_cmhs_clinic',
    addressEn: 'Chechela, CMHS Hospital Compound, Gondar, Ethiopia',
    addressAm: 'ቼቼላ፣ ጤና ሳይንስ ሆስፒታል ግቢ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.6133,
    longitude: 37.4642,
    operatingHours: '24/7 (24hr Examination, Lab, Pharmacy & Specialty Care)',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#24hr_Exam',
      '#24hr_Pharmacy',
      '#24hr_Lab',
      '#FamilyPlanning',
      '#STI_TB_HIV',
      '#HospitalReferral',
      '#Emergency_Care',
    ],
  },
  // 10. CMHS Guidance Center
  {
    id: 'uog_cmhs_guidance_center',
    nameEn: 'UoG CMHS Guidance & Psychological Counseling Center',
    nameAm: 'የጤና ሳይንስ ኮሌጅ የተማሪዎች የምክርና ስነ-ልቦና ማዕከል',
    category: 'counseling',
    subCity: 'UoG - GCMS Referral Hospital / CMHS',
    buildingEn: 'Block GC-21',
    buildingAm: 'ብሎክ GC-21',
    landmarkEn: 'Block GC-21, Near Medical Classrooms',
    landmarkAm: 'ብሎክ GC-21፣ ከህክምና መማሪያ ክፍሎች አጠገብ',
    focalPerson: 'Takele Adeno (0918816741 / 0918151390)',
    focalPhone: '+251918816741',
    phone: '+251918816741',
    telegramHandle: 'uog_cmhs_counseling',
    addressEn: 'Chechela, CMHS Compound, Gondar, Ethiopia',
    addressAm: 'ቼቼላ፣ ጤና ሳይንስ ግቢ፣ ጎንደር፣ ኢትዮጵያ',
    latitude: 12.6136,
    longitude: 37.4645,
    operatingHours: 'Mon-Fri 08:30 - 17:30',
    isVerified: true,
    isWheelchairAccessible: true,
    hasPrivateRoom: true,
    services: [
      '#MentalHealth',
      '#BurnoutSupport',
      '#ClinicalStress',
      '#PsychiatricConsultation',
      '#ConfidentialCounseling',
    ],
  },
];

interface MentorSeed {
  id: string;
  name: string;
  organization: string;
  campus: string;
  roleTitleEn: string;
  roleTitleAm: string;
  phone: string;
  email?: string;
  telegramHandle?: string;
  specialties: string[];
  bioEn: string;
  bioAm: string;
  languages: string[];
  experienceYears: number;
  sessionsCount: number;
  workingHoursEn: string;
  workingHoursAm: string;
}

const UOG_MENTORS: MentorSeed[] = [
  {
    id: 'berhanu_ashagera',
    name: 'Berhanu Ashagera',
    organization: 'UoG Guidance & Counseling Directorate',
    campus: 'Atse Tewodros Campus',
    roleTitleEn: 'Senior Campus Counselor & Student Advisor',
    roleTitleAm: 'የካምፓስ ከፍተኛ አማካሪ እና የተማሪዎች መካሪ',
    phone: '+251918736102',
    email: 'brashagrie@gmail.com',
    telegramHandle: 'berhanu_uog_counselor',
    specialties: ['#MentalHealth', '#SubstanceAbuse', '#Puberty'],
    bioEn:
      'Guidance counselor inside students clinic providing confidential help for test anxiety, study habits, addiction recovery, and freshman adjustment.',
    bioAm:
      'በተማሪዎች ክሊኒክ ውስጥ በፈተና ጭንቀት፣ የጥናት ክህሎት፣ የሱስ መቋቋም እና የዩኒቨርሲቲ ቆይታ መላመድ ላይ ሚስጥራዊ እና ሙያዊ የምክር ድጋፍ የሚሰጥ አማካሪ።',
    languages: ['Amharic', 'English'],
    experienceYears: 6,
    sessionsCount: 480,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  },
  {
    id: 'ayalnesh_adgo',
    name: 'Ayalnesh Adgo',
    organization: 'UoG Guidance & Counseling Directorate',
    campus: 'Atse Fasil Campus',
    roleTitleEn: 'Central Counseling Coordinator & Senior Counselor',
    roleTitleAm: 'የስነ-ልቦና ምክር ማዕከላዊ አስተባባሪ እና ከፍተኛ አማካሪ',
    phone: '+251911719684',
    email: 'ayalneshadgo@gmail.com',
    telegramHandle: 'ayalnesh_uog_counselor',
    specialties: ['#MentalHealth', '#GBV', '#SRH'],
    bioEn:
      'Central coordinator specializing in relationship counseling, gender-based harassment prevention, crisis de-escalation, and coping mechanisms.',
    bioAm:
      'በግንኙነት ችግሮች፣ በፆታዊ ትንኮሳ መከላከል፣ በስሜታዊ ጫና አያያዝ እና ውሳኔ አሰጣጥ ላይ የካበተ ልምድ ያላት ማዕከላዊ አስተባባሪ።',
    languages: ['Amharic', 'English'],
    experienceYears: 8,
    sessionsCount: 750,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  },
  {
    id: 'helina_desalghe',
    name: 'Helina Desalghe',
    organization: 'UoG Guidance & Counseling Directorate',
    campus: 'Atse Fasil Campus',
    roleTitleEn: 'Campus Counselor & Peer Support Lead',
    roleTitleAm: 'የካምፓስ ስነ-ልቦና አማካሪ',
    phone: '+251918068870',
    telegramHandle: 'helina_uog_counselor',
    specialties: ['#MentalHealth', '#SRH'],
    bioEn:
      'Dedicated counselor inside students clinic helping students navigate academic pressure, interpersonal conflicts, and psychological wellness.',
    bioAm:
      'ተማሪዎች የትምህርት ጫናን እንዲቋቋሙ፣ ጤናማ ማህበራዊ ግንኙነት እንዲገነቡ እና አእምሮአዊ ደህንነታቸውን እንዲጠብቁ የምትረዳ አማካሪ።',
    languages: ['Amharic', 'English'],
    experienceYears: 4,
    sessionsCount: 310,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  },
  {
    id: 'rehemate_dawed',
    name: 'Rehemate Dawed',
    organization: 'UoG Guidance & Counseling Directorate',
    campus: 'Maraki Campus',
    roleTitleEn: 'Student Wellbeing & Counseling Officer',
    roleTitleAm: 'የተማሪዎች ደህንነትና ምክር ባለሙያ',
    phone: '+251920488192',
    telegramHandle: 'rehemate_uog_counselor',
    specialties: ['#MentalHealth', '#Puberty'],
    bioEn:
      'Counselor at the Old Library student office helping students overcome homesickness, depression symptoms, and self-esteem challenges.',
    bioAm:
      'በአሮጌው ቤተ-መጽሐፍት ተማሪዎች ቢሮ የናፍቆት ስሜትን፣ ድብርትን እና በራስ መተማመንን ማዳበር ላይ ያተኮረች አማካሪ።',
    languages: ['Amharic', 'English'],
    experienceYears: 5,
    sessionsCount: 420,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  },
  {
    id: 'saied_desalghe',
    name: 'Saied Desalghe',
    organization: 'UoG Guidance & Counseling Directorate',
    campus: 'Maraki Campus',
    roleTitleEn: 'Campus Counselor & Student Advisor',
    roleTitleAm: 'የካምፓስ የምክር እና ስነ-ልቦና ባለሙያ',
    phone: '+251963727978',
    telegramHandle: 'saied_uog_counselor',
    specialties: ['#MentalHealth', '#SubstanceAbuse'],
    bioEn:
      'Empathetic counselor focusing on conflict resolution, time management, and mental resilience under academic stress.',
    bioAm:
      'ተማሪዎች የጊዜ አጠቃቀም ክህሎታቸውን እንዲያሳድጉ፣ ውጥረትን እንዲቆጣጠሩ እና የተረጋጋ ህይወት እንዲመሩ የሚያግዝ አማካሪ።',
    languages: ['Amharic', 'English', 'Afaan Oromoo'],
    experienceYears: 4,
    sessionsCount: 290,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  },
  {
    id: 'takele_adeno',
    name: 'Takele Adeno',
    organization: 'UoG CMHS Student Support',
    campus: 'CMHS / Health College',
    roleTitleEn: 'Medical & Health Sciences Student Counselor',
    roleTitleAm: 'የህክምናና ጤና ሳይንስ ተማሪዎች አማካሪ',
    phone: '+251918816741',
    telegramHandle: 'takele_uog_counselor',
    specialties: ['#MentalHealth', '#SubstanceAbuse'],
    bioEn:
      'Counselor at Block GC-21 guiding health science students through intense study pressure, clinical rotations, and emotional health.',
    bioAm:
      'በብሎክ GC-21 የጤና ሳይንስ ተማሪዎችን ከክሊኒካል ጫና፣ ውጥረት እና ስነ-ልቦናዊ ድካም እንዲያገግሙ የሚያግዝ አማካሪ።',
    languages: ['Amharic', 'English', 'Tigrinya'],
    experienceYears: 6,
    sessionsCount: 510,
    workingHoursEn: 'Mon – Fri: 8:30 AM – 5:30 PM',
    workingHoursAm: 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
  },
  {
    id: 'tewodros_eyasu',
    name: 'Tewodros Eyasu',
    organization: 'UoG Student Clinics Directorate',
    campus: 'Central Directorate / All Campuses',
    roleTitleEn: '5-Campuses Student Health Clinics Coordinator',
    roleTitleAm: 'የ5ቱ ግቢ የተማሪዎች ክሊኒክ አስተባባሪ',
    phone: '+251918711993',
    email: 'tedohareg26@gmail.com',
    telegramHandle: 'tewodros_uog_clinics',
    specialties: ['#SRH', '#MentalHealth'],
    bioEn:
      'General coordinator overseeing 24/7 student health clinic services, medical supplies, referrals, and campus hygiene surveillance across all 5 campuses.',
    bioAm:
      'በሁሉም 5 ግቢዎች የ24 ሰዓት የተማሪዎች ክሊኒክ አገልግሎትን፣ የመድኃኒት አቅርቦትን፣ ሪፈራል እና የግቢ ጤና ጥበቃን የሚያስተባብሩ ዋና ሃላፊ።',
    languages: ['Amharic', 'English'],
    experienceYears: 9,
    sessionsCount: 890,
    workingHoursEn: '24/7 Coordination Desk',
    workingHoursAm: 'የ24 ሰዓት ማስተባበሪያ',
  },
];

async function main() {
  console.log('Seeding University of Gondar verified facilities...');
  for (const f of UOG_FACILITIES) {
    await prisma.facility.upsert({
      where: { id: f.id },
      update: {
        nameEn: f.nameEn,
        nameAm: f.nameAm,
        category: f.category,
        subCity: f.subCity,
        buildingEn: f.buildingEn,
        buildingAm: f.buildingAm,
        landmarkEn: f.landmarkEn,
        landmarkAm: f.landmarkAm,
        focalPerson: f.focalPerson,
        focalPhone: f.focalPhone,
        phone: f.phone,
        telegramHandle: f.telegramHandle,
        addressEn: f.addressEn,
        addressAm: f.addressAm,
        latitude: f.latitude,
        longitude: f.longitude,
        operatingHours: f.operatingHours,
        isVerified: f.isVerified,
        isWheelchairAccessible: f.isWheelchairAccessible,
        hasPrivateRoom: f.hasPrivateRoom,
        services: JSON.stringify(f.services),
      },
      create: {
        id: f.id,
        nameEn: f.nameEn,
        nameAm: f.nameAm,
        category: f.category,
        subCity: f.subCity,
        buildingEn: f.buildingEn,
        buildingAm: f.buildingAm,
        landmarkEn: f.landmarkEn,
        landmarkAm: f.landmarkAm,
        focalPerson: f.focalPerson,
        focalPhone: f.focalPhone,
        phone: f.phone,
        telegramHandle: f.telegramHandle,
        addressEn: f.addressEn,
        addressAm: f.addressAm,
        latitude: f.latitude,
        longitude: f.longitude,
        operatingHours: f.operatingHours,
        isVerified: f.isVerified,
        isWheelchairAccessible: f.isWheelchairAccessible,
        hasPrivateRoom: f.hasPrivateRoom,
        services: JSON.stringify(f.services),
      },
    });
  }
  console.log(`Successfully upserted ${UOG_FACILITIES.length} UoG facilities.`);

  console.log('Seeding University of Gondar verified mentors & counselors...');
  for (const m of UOG_MENTORS) {
    await prisma.mentor.upsert({
      where: { id: m.id },
      update: {
        name: m.name,
        organization: m.organization,
        campus: m.campus,
        roleTitleEn: m.roleTitleEn,
        roleTitleAm: m.roleTitleAm,
        phone: m.phone,
        email: m.email ?? null,
        telegramHandle: m.telegramHandle ?? null,
        specialties: JSON.stringify(m.specialties),
        bioEn: m.bioEn,
        bioAm: m.bioAm,
        languages: JSON.stringify(m.languages),
        experienceYears: m.experienceYears,
        sessionsCount: m.sessionsCount,
        workingHoursEn: m.workingHoursEn,
        workingHoursAm: m.workingHoursAm,
        isAvailable: true,
        isVerified: true,
      },
      create: {
        id: m.id,
        name: m.name,
        organization: m.organization,
        campus: m.campus,
        roleTitleEn: m.roleTitleEn,
        roleTitleAm: m.roleTitleAm,
        phone: m.phone,
        email: m.email ?? null,
        telegramHandle: m.telegramHandle ?? null,
        specialties: JSON.stringify(m.specialties),
        bioEn: m.bioEn,
        bioAm: m.bioAm,
        languages: JSON.stringify(m.languages),
        experienceYears: m.experienceYears,
        sessionsCount: m.sessionsCount,
        workingHoursEn: m.workingHoursEn,
        workingHoursAm: m.workingHoursAm,
        isAvailable: true,
        isVerified: true,
      },
    });
  }
  console.log(`Successfully upserted ${UOG_MENTORS.length} UoG mentors & coordinators.`);
}

main()
  .catch((e) => {
    console.error('Error seeding UoG support services:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
