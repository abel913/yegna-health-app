/// Campus focal person contact model for the University of Gondar directory.
class CampusFocalPerson {
  const CampusFocalPerson({
    required this.campusEn,
    required this.campusAm,
    required this.nameEn,
    required this.nameAm,
    required this.roleEn,
    required this.roleAm,
    required this.phone,
  });

  final String campusEn;
  final String campusAm;
  final String nameEn;
  final String nameAm;
  final String roleEn;
  final String roleAm;
  final String phone;
}

/// Official University of Gondar SRH Campus Focal Persons Directory list.
const List<CampusFocalPerson> kUogCampusFocalPersons = [
  CampusFocalPerson(
    campusEn: 'Atse Fasil Campus',
    campusAm: 'አጼ ፋሲል ግቢ',
    nameEn: 'Mr. Mengistu Aragie',
    nameAm: 'አቶ መንግስቱ አራጌ',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918780432',
  ),
  CampusFocalPerson(
    campusEn: 'Atse Fasil Campus',
    campusAm: 'አጼ ፋሲል ግቢ',
    nameEn: 'Sr. Assegedech Birhanu',
    nameAm: 'ሲ/ር አሰገደች ብርሃኑ',
    roleEn: 'Clinical Focal Nurse',
    roleAm: 'ክሊኒካል ነርስ',
    phone: '+251918775510',
  ),
  CampusFocalPerson(
    campusEn: 'Atse Tewodros Campus',
    campusAm: 'አጼ ቴዎድሮስ ግቢ',
    nameEn: 'Dr. Tadele Melese',
    nameAm: 'ዶ/ር ታደለ መለሰ',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918768912',
  ),
  CampusFocalPerson(
    campusEn: 'Atse Tewodros Campus',
    campusAm: 'አጼ ቴዎድሮስ ግቢ',
    nameEn: 'Sr. Zewditu Kebede',
    nameAm: 'ሲ/ር ዘውዲቱ ከበደ',
    roleEn: 'Clinical Counselor',
    roleAm: 'ክሊኒካል አማካሪ',
    phone: '+251918712345',
  ),
  CampusFocalPerson(
    campusEn: 'CMHS / Health College',
    campusAm: 'የጤና ሳይንስ ኮሌጅ ግቢ',
    nameEn: 'Dr. Wubet Worku',
    nameAm: 'ዶ/ር ውበት ወርቁ',
    roleEn: 'SRH Clinical Lead',
    roleAm: 'የስነ-ተዋልዶ ጤና መሪ',
    phone: '+251918701234',
  ),
  CampusFocalPerson(
    campusEn: 'CMHS / Health College',
    campusAm: 'የጤና ሳይንስ ኮሌጅ ግቢ',
    nameEn: 'Sr. Emebet Kassahun',
    nameAm: 'ሲ/ር እመቤት ካሳሁን',
    roleEn: 'Youth Friendly Clinic Lead',
    roleAm: 'የወጣቶች ክሊኒክ ኃላፊ',
    phone: '+251918705678',
  ),
  CampusFocalPerson(
    campusEn: 'Maraki Campus',
    campusAm: 'ማራኪ ግቢ',
    nameEn: 'Mr. Solomon Amsalu',
    nameAm: 'አቶ ሰለሞን አምሳሉ',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918734567',
  ),
  CampusFocalPerson(
    campusEn: 'Maraki Campus',
    campusAm: 'ማራኪ ግቢ',
    nameEn: 'Sr. Bethlehem Tadesse',
    nameAm: 'ሲ/ር ቤተልሔም ታደሰ',
    roleEn: 'Counselor',
    roleAm: 'አማካሪ',
    phone: '+251918745678',
  ),
  CampusFocalPerson(
    campusEn: 'Teda Campus',
    campusAm: 'ተዳ ግቢ',
    nameEn: 'Mr. Hailemariam Getachew',
    nameAm: 'አቶ ኃይለማርያም ጌታቸው',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918756789',
  ),
  CampusFocalPerson(
    campusEn: 'Teda Campus',
    campusAm: 'ተዳ ግቢ',
    nameEn: 'Sr. Tigist Alemayehu',
    nameAm: 'ሲ/ር ትዕግስት አለማየሁ',
    roleEn: 'Clinical Nurse',
    roleAm: 'ክሊኒካል ነርስ',
    phone: '+251918767890',
  ),
];
