import '../clubs/club_models.dart';

/// Seed templates for verified student clubs.
class ClubContentTemplates {
  ClubContentTemplates._();

  static List<StudentClub> get clubTemplates => [
        StudentClub(
          id: 'template_girls_wellness',
          nameEn: 'Girls\' Health & Wellness Club',
          nameAm: 'የሴቶች ጤና እና ደህንነት ክበብ',
          descriptionEn:
              'A safe, supportive space for young women to discuss menstrual hygiene, self-esteem, nutrition, and personal wellness.',
          descriptionAm:
              'ወጣት ሴቶች የወር አበባ ንፅህናን፣ በራስ መተማመንን፣ የተመጣጠነ ምግብን እና አጠቃላይ ደህንነትን በግልፅ የሚወያዩበት ደጋፊ ክበብ።',
          category: ClubCategory.girlsHygiene,
          meetingScheduleEn: 'Every Thursday, 4:00 PM – 5:30 PM',
          meetingScheduleAm: 'በየሳምንቱ ሐሙስ፡ ከቀኑ 10:00 – 11:30',
          meetingLocationEn: 'Campus Student Center, Room 204',
          meetingLocationAm: 'የግቢው የተማሪዎች ማዕከል፣ ቢሮ ቁጥር 204',
          mentorNameEn: 'Sister Selamawit Tadesse',
          mentorNameAm: 'ሲስተር ሰላማዊት ታደሰ',
          mentorContact: '+251 91 144 8899',
          maxCapacity: 40,
          rulesEn: const [
            'Maintain strict mutual respect and confidentiality.',
            'Support every member without judgment.',
            'Be punctual for weekly dialogue circles.',
          ],
          rulesAm: const [
            'የጋራ መከባበር እና ጥብቅ ሚስጥራዊነትን መጠበቅ።',
            'ማናቸውንም አባል ያለ ፍረጃ መደገፍ።',
            'ለሳምንታዊ የውይይት መድረኮች በሰዓቱ መገኘት።',
          ],
          tags: const ['Menstrual Health', 'Hygiene', 'Peer Support'],
          createdAt: DateTime.now(),
        ),
        StudentClub(
          id: 'template_mental_health',
          nameEn: 'Mind & Wellbeing Champions',
          nameAm: 'የአእምሮ ጤና እና ደህንነት አምባሳደሮች',
          descriptionEn:
              'Peer-led discussions on managing academic stress, building resilience, mindfulness, and eliminating mental health stigma.',
          descriptionAm:
              'የትምህርት ጭንቀትን መቆጣጠር፣ ፅናትን ማዳበር፣ አእምሯዊ መረጋጋት እና የአእምሮ ጤና መገለልን ስለማስወገድ የሚሰራ የአቻ ተማሪዎች ክበብ።',
          category: ClubCategory.mentalHealth,
          meetingScheduleEn: 'Every Wednesday, 3:30 PM – 5:00 PM',
          meetingScheduleAm: 'በየሳምንቱ ረቡዕ፡ ከቀኑ 9:30 – 11:00',
          meetingLocationEn: 'Library Discussion Hall & Telegram Online',
          meetingLocationAm: 'የቤተ-መጽሐፍት የውይይት አዳራሽ እና በቴሌግራም',
          mentorNameEn: 'Dr. Yonas Girma (Counselor)',
          mentorNameAm: 'ዶ/ር ዮናስ ግርማ (አማካሪ)',
          mentorContact: '@yonas_counseling',
          maxCapacity: 50,
          rulesEn: const [
            'Everything shared in the circle stays in the circle.',
            'Practice active, empathetic listening.',
            'Direct crisis cases immediately to certified hotlines (8335 / 952).',
          ],
          rulesAm: const [
            'በክበቡ ውስጥ የተነገረ ነገር ሁሉ እዛው ሚስጥር ሆኖ ይቀራል።',
            'ትኩረት ሰጥቶ ማዳመጥ እና መረዳት።',
            'አስቸኳይ ጉዳዮች ሲያጋጥሙ ወዲያውኑ ወደ ነፃ የስልክ መስመሮች (8335 / 952) ማስተላለፍ።',
          ],
          tags: const ['Mental Health', 'Stress Management', 'Mindfulness'],
          createdAt: DateTime.now(),
        ),
        StudentClub(
          id: 'template_srh_wellness',
          nameEn: 'Campus Reproductive Health Pioneers',
          nameAm: 'የግቢው ስነ-ተዋልዶ ጤና አቅኚዎች',
          descriptionEn:
              'Promoting safe reproductive health practices, STI and HIV prevention, and facilitating access to youth-friendly clinics.',
          descriptionAm:
              'ደህንነቱ የተጠበቀ የስነ-ተዋልዶ ጤና፣ የአባለዘር እና የኤች አይ ቪ መከላከል እና የወጣቶች ክሊኒክ አገልግሎቶችን ተደራሽ ማድረግ ላይ የሚሰራ ክበብ።',
          category: ClubCategory.srhWellness,
          meetingScheduleEn: 'Every Friday, 4:30 PM – 6:00 PM',
          meetingScheduleAm: 'በየሳምንቱ አርብ፡ ከቀኑ 10:30 – 12:00',
          meetingLocationEn: 'Youth Resource Center & Amphitheater',
          meetingLocationAm: 'የወጣቶች የመረጃ ማዕከል እና አምፊቲያትር',
          mentorNameEn: 'Alemayehu Kebede (Health Officer)',
          mentorNameAm: 'አለማየሁ ከበደ (የጤና መኮንን)',
          mentorContact: '+251 92 333 4455',
          maxCapacity: 60,
          rulesEn: const [
            'Open, honest, and respectful conversations.',
            'Adhere to certified Ministry of Health scientific facts.',
            'Respect bodily autonomy and diversity.',
          ],
          rulesAm: const [
            'ግልጽ፣ ታማኝ እና የተከበረ ውይይት ማድረግ።',
            'በጤና ጥበቃ ሚኒስቴር የተረጋገጡ ሳይንሳዊ እውነታዎችን ብቻ መከተል።',
            'የሰውነት ክብርን እና ልዩነቶችን ማክበር።',
          ],
          tags: const ['SRH', 'HIV Prevention', 'Youth Clinics'],
          createdAt: DateTime.now(),
        ),
        StudentClub(
          id: 'template_anti_substance',
          nameEn: 'Substance-Free Healthy Youth Alliance',
          nameAm: 'ከሱሶች የፀዱ ጤናማ ወጣቶች ህብረት',
          descriptionEn:
              'Empowering students to live healthy, addiction-free lives through sports, art, positive mentorship, and peer intervention.',
          descriptionAm:
              'ተማሪዎች በስፖርት፣ በስነ-ጥበብ እና በአቻ ድጋፍ ጤናማ እና ከሱስ ነፃ የሆነ ህይወት እንዲመሩ የሚያበረታታ የወጣቶች ህብረት።',
          category: ClubCategory.antiSubstance,
          meetingScheduleEn: 'Every Saturday, 9:30 AM – 11:30 AM',
          meetingScheduleAm: 'በየሳምንቱ ቅዳሜ፡ ከጠዋቱ 3:30 – 5:30',
          meetingLocationEn: 'University Sports Complex',
          meetingLocationAm: 'የዩኒቨርሲቲው የስፖርት ማዕከል',
          mentorNameEn: 'Coach Dawit Mulugeta',
          mentorNameAm: 'አሰልጣኝ ዳዊት ሙሉጌታ',
          mentorContact: '+251 91 777 8899',
          maxCapacity: 100,
          rulesEn: const [
            'Total commitment to clean, healthy living.',
            'Encourage and assist peers seeking recovery.',
            'Participate actively in positive extracurriculars.',
          ],
          rulesAm: const [
            'ጤናማ እና ንፁህ ህይወት ለመኖር ቁርጠኝነት ማሳየት።',
            'ከሱስ ለመላቀቅ የሚጥሩ ጓደኞችን ማበረታታት እና መደገፍ።',
            'በትምህርት ውጭ እንቅስቃሴዎች እና ስፖርት ላይ በንቃት መሳተፍ።',
          ],
          tags: const ['Substance Free', 'Fitness', 'Peer Mentorship'],
          createdAt: DateTime.now(),
        ),
      ];
}
