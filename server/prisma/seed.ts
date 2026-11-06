import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding database...');

  // 1. Seed SuperAdmin account
  const salt = await bcrypt.genSalt(10);
  const passwordHash = await bcrypt.hash('admin1234', salt);

  const admin = await prisma.user.upsert({
    where: { email: 'admin@yegnahealth.org' },
    update: { passwordHash, role: 'SUPER_ADMIN', isEmailVerified: true },
    create: {
      email: 'admin@yegnahealth.org',
      displayName: 'Natnael Z. (SuperAdmin)',
      passwordHash,
      role: 'SUPER_ADMIN',
      isEmailVerified: true,
    },
  });
  console.log('Admin account seeded:', admin.email);

  // Also seed alternate admin alias matching mobile user testing
  await prisma.user.upsert({
    where: { email: 'natnaelzemene21@gmail.com' },
    update: { passwordHash, role: 'SUPER_ADMIN', isEmailVerified: true },
    create: {
      email: 'natnaelzemene21@gmail.com',
      displayName: 'Natnael Zemene (Executive Admin)',
      passwordHash,
      role: 'SUPER_ADMIN',
      isEmailVerified: true,
    },
  });

  // 2. Seed Verified Healthcare Facilities in Addis Ababa
  const facilities = [
    {
      nameEn: 'Arada Youth-Friendly Health Center',
      nameAm: 'አራዳ ወጣቶች ተስማሚ የጤና ጣቢያ',
      subCity: 'Arada',
      woreda: 'Woreda 01',
      addressEn: 'Near Churchill Avenue, Arada Sub-City',
      addressAm: 'ቸርችል ጎዳና አጠገብ፣ አራዳ ክ/ከተማ',
      phone: '+251111223344',
      latitude: 9.0345,
      longitude: 38.7523,
      operatingHours: 'Open Now • Closes at 18:00',
      isVerified: true,
      services: JSON.stringify(['#HIV_VCT', '#Contraception', '#Mental_Health', '#STI_Testing']),
    },
    {
      nameEn: 'Kirkos Adolescent Health Post',
      nameAm: 'ቂርቆስ የአፍላ ወጣቶች የጤና ኬላ',
      subCity: 'Kirkos',
      woreda: 'Woreda 04',
      addressEn: 'Mexico Square Area, Kirkos Sub-City',
      addressAm: 'ሜክሲኮ አደባባይ አካባቢ፣ ቂርቆስ ክ/ከተማ',
      phone: '+251115512233',
      latitude: 9.0112,
      longitude: 38.7456,
      operatingHours: '08:30 - 17:30',
      isVerified: true,
      services: JSON.stringify(['#Youth_Friendly', '#SRH_Counseling', '#Nutrition']),
    },
    {
      nameEn: 'Bole Youth Wellness & Reproductive Center',
      nameAm: 'ቦሌ የወጣቶች ጤናና ሥነ-ተዋልዶ ማዕከል',
      subCity: 'Bole',
      woreda: 'Woreda 03',
      addressEn: 'Bole Medhanealem Area, Addis Ababa',
      addressAm: 'ቦሌ መድኃኔዓለም አካባቢ፣ አዲስ አበባ',
      phone: '+251116634455',
      latitude: 8.9982,
      longitude: 38.7891,
      operatingHours: 'Open 24/7 (Emergency)',
      isVerified: true,
      services: JSON.stringify(['#HIV_VCT', '#GBV_Support', '#Emergency_Care', '#Mental_Health']),
    },
    {
      nameEn: 'Lideta Community Youth Health Clinic',
      nameAm: 'ልደታ የማህበረሰብ ወጣቶች ጤና ክሊኒክ',
      subCity: 'Lideta',
      woreda: 'Woreda 02',
      addressEn: 'Lideta Sub-City, Near Commercial College',
      addressAm: 'ልደታ ክ/ከተማ፣ ኮሜርስ ኮሌጅ አጠገብ',
      phone: '+251115546677',
      latitude: 9.0189,
      longitude: 38.7365,
      operatingHours: '08:30 - 17:00',
      isVerified: true,
      services: JSON.stringify(['#Youth_Friendly', '#STI_Testing', '#Puberty_Care']),
    },
    {
      nameEn: 'UoG Maraki Student Health Center',
      nameAm: 'የጎንደር ዩኒቨርሲቲ ማራኪ የተማሪዎች ጤና ጣቢያ',
      subCity: 'UoG - Maraki Campus',
      woreda: 'Student Clinic Wing',
      addressEn: 'Maraki Campus, University of Gondar',
      addressAm: 'ማራኪ ካምፓስ፣ ጎንደር ዩኒቨርሲቲ',
      phone: '+251581141234',
      latitude: 12.6075,
      longitude: 37.4589,
      operatingHours: 'Open Now • Closes at 18:00',
      isVerified: true,
      services: JSON.stringify(['#Youth_Friendly', '#SRH_Counseling', '#Free_Condoms', '#Mental_Health']),
    },
    {
      nameEn: 'UoG Comprehensive Specialized Hospital (GCMS) Adolescent Clinic',
      nameAm: 'የጎንደር ዩኒቨርሲቲ ሪፈራል ሆስፒታል (GCMS) የወጣቶች ክሊኒክ',
      subCity: 'UoG - GCMS Referral Hospital',
      woreda: 'Youth Services OPD',
      addressEn: 'Hospital Road, Gondar',
      addressAm: 'ሆስፒታል መንገድ፣ ጎንደር ከተማ',
      phone: '+251581141200',
      latitude: 12.6033,
      longitude: 37.4522,
      operatingHours: 'Open 24/7 (Emergency & Youth OPD)',
      isVerified: true,
      services: JSON.stringify(['#HIV_VCT', '#Emergency_Care', '#Specialist_Doctor', '#STI_Treatment']),
    },
  ];

  for (const f of facilities) {
    const existing = await prisma.facility.findFirst({ where: { nameEn: f.nameEn } });
    if (!existing) {
      await prisma.facility.create({ data: f });
    }
  }
  console.log('Seeded healthcare facilities.');

  // 3. Seed Certified Mentors
  const mentors = [
    {
      name: 'Selamawit Tadesse',
      organization: 'Talent Youth Association (TYA)',
      phone: '+251911234567',
      telegramHandle: '@selam_tya_peer',
      email: 'selamawit@tya.org.et',
      languages: JSON.stringify(['Amharic', 'English']),
      specialties: JSON.stringify(['#MentalHealth', '#SRH', '#Puberty']),
      isAvailable: true,
      isVerified: true,
    },
    {
      name: 'Dawit Haile',
      organization: 'Ethiopian Red Cross Youth',
      phone: '+251912345678',
      telegramHandle: '@dawit_redcross',
      email: 'dawit@redcross.org.et',
      languages: JSON.stringify(['Amharic', 'Afaan Oromoo', 'English']),
      specialties: JSON.stringify(['#SubstanceAbuse', '#AdolescentLife', '#MentalHealth']),
      isAvailable: true,
      isVerified: true,
    },
    {
      name: 'Dr. Hanna Bekele',
      organization: 'Marie Stopes Ethiopia',
      phone: '+251913456789',
      telegramHandle: '@dr_hanna_ms',
      email: 'hanna@mariestopes.org.et',
      languages: JSON.stringify(['Amharic', 'English', 'Tigrinya']),
      specialties: JSON.stringify(['#SRH_VCT', '#GBV_Support', '#ClinicalConsultation']),
      isAvailable: false,
      isVerified: true,
    },
  ];

  for (const m of mentors) {
    const existing = await prisma.mentor.findFirst({ where: { name: m.name } });
    if (!existing) {
      await prisma.mentor.create({ data: m });
    }
  }
  console.log('Seeded certified mentors.');

  // 4. Seed Core Learning Modules & Comprehensive Quizzes
  const modules = [
    {
      id: 'module-01',
      category: 'puberty',
      titleEn: 'Understanding Puberty & Physical Development',
      titleAm: 'የጉርምስና ወቅትና የአካል ለውጦችን መረዳት',
      summaryEn: 'Comprehensive, clinically verified guide to physical and emotional growth during adolescence.',
      summaryAm: 'በጉርምስና ወቅት ስለሚከሰቱ አካላዊና ስሜታዊ ለውጦች የተሟላ የጤና ትምህርት።',
      contentEn: '# Puberty & Body Development\n\nPuberty is the natural biological phase during which a young person undergoes rapid physical, emotional, and social development...',
      contentAm: '# የጉርምስና ወቅት\n\nየጉርምስና ወቅት ተፈጥሯዊ የሆነ የአካል፣ የስሜትና የአስተሳሰብ ለውጦች የሚታዩበት የዕድገት ደረጃ ነው...',
      readTimeMin: 4,
      authorName: 'Dr. Hanna Bekele, Adolescent Specialist',
      orderIndex: 1,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Puberty begins at the exact same age for everyone regardless of genetics or health.',
          questionAm: 'የጉርምስና ወቅት ለሁሉም ወጣቶች በተመሳሳይ ዕድሜ ይጀምራል።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 1,
          explanationEn: 'Puberty onset varies naturally (typically between ages 9–14 for girls and 10–15 for boys) based on genetics, nutrition, and overall health.',
          explanationAm: 'የጉርምስና መጀመሪያ ዕድሜ እንደየግለሰቡ በዘረመል፣ በአመጋገብና በአጠቃላይ የጤና ሁኔታ በተፈጥሮ ይለያያል።',
        },
        {
          type: 'MULTIPLE_CHOICE',
          questionEn: 'Which physical change is a typical primary milestone for adolescent males during puberty?',
          questionAm: 'በጉርምስና ወቅት በወንዶች ላይ የሚታየው ቁልፍ አካላዊ ለውጥ የትኛው ነው?',
          optionsEn: [
            'Deepening of voice and facial hair growth',
            'Permanent stoppage of bone elongation',
            'Sudden decrease in metabolic rate',
            'Complete cessation of body sweat production',
          ],
          optionsAm: [
            'የድምፅ መጎርነንና የፊት ጸጉር ማደግ',
            'የአጥንት እድገት ሙሉ በሙሉ መቆም',
            'የሰውነት ተፈጭቶ በድንገት መቀነስ',
            'የላብ መመንጨት ሙሉ በሙሉ መቆም',
          ],
          correctIndex: 0,
          explanationEn: 'Rising testosterone levels trigger vocal fold thickening and secondary hair development.',
          explanationAm: 'የቴስቶስትሮን ሆርሞን መጨመር የድምፅ መጎርነንና የሰውነት ጸጉር ዕድገትን ያስከትላል።',
        },
      ],
    },
    {
      id: 'module-02',
      category: 'sti',
      titleEn: 'Sexually Transmitted Infections & Prevention',
      titleAm: 'የአባላዘር በሽታዎች መከላከያና ግንዛቤ',
      summaryEn: 'Youth-friendly guidance on identifying STI symptoms, safe prevention methods, and early clinic testing.',
      summaryAm: 'የአባላዘር በሽታዎች ምልክቶች፣ የመከላከያ ዘዴዎችና የወጣቶች የክሊኒክ ምርመራ መረጃ።',
      contentEn: '# STI Prevention & Awareness\n\nSexually transmitted infections can be transmitted through unprotected sexual contact. Most STIs are treatable when caught early...',
      contentAm: '# የአባላዘር በሽታዎች መከላከል\n\nየአባላዘር በሽታዎች ተገቢውን የጥንቃቄ እርምጃ ባለመውሰድ የሚተላለፉ ሲሆን ቀድሞ ከተመረመሩ በቀላሉ ይታከማሉ...',
      readTimeMin: 4,
      authorName: 'National Youth Health Coalition',
      orderIndex: 2,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Many sexually transmitted infections can show zero early symptoms while remaining transmissible.',
          questionAm: 'ብዙ የአባላዘር በሽታዎች በመጀመሪያው ወቅት ምንም አይነት ምልክት ሳያሳዩ ሊተላለፉ ይችላሉ።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 0,
          explanationEn: 'Asymptomatic infections (like chlamydia and early syphilis) are common, which is why regular screening at youth clinics is recommended.',
          explanationAm: 'በርካታ የአባላዘር በሽታዎች በመጀመሪያ ላይ ምንም ህመም ወይም ምልክት ላያሳዩ ስለሚችሉ መደበኛ የክሊኒክ ምርመራ ማድረግ አስፈላጊ ነው።',
        },
        {
          type: 'MULTIPLE_CHOICE',
          questionEn: 'Which protective measure provides simultaneous dual protection against both pregnancy and STIs?',
          questionAm: 'ያልተፈለገ እርግዝናንና የአባላዘር በሽታዎችን በአንድ ጊዜ የሚከላከል የትኛው ነው?',
          optionsEn: [
            'Correct and consistent condom use',
            'Birth control oral contraceptive pills alone',
            'Washing with antiseptic soap after exposure',
            'Relying solely on physical appearance of partner',
          ],
          optionsAm: [
            'ኮንዶምን በአግባቡና በተከታታይ መጠቀም',
            'የእርግዝና መከላከያ ክኒን ብቻ መውሰድ',
            'ከተገናኙ በኋላ በሳሙና መታጠብ',
            'በግለሰቡ ውጫዊ ገጽታ ላይ ብቻ መተማመን',
          ],
          correctIndex: 0,
          explanationEn: 'Condoms are the only barrier method that effectively blocks both pathogens and sperm.',
          explanationAm: 'ኮንዶም ሁለቱንም ማለትም የአባላዘር በሽታ አምጪዎችንና ያልተፈለገ እርግዝናን በጋራ የሚከላከል ብቸኛ ዘዴ ነው።',
        },
      ],
    },
    {
      id: 'module-03',
      category: 'hepatitis',
      titleEn: 'Viral Hepatitis Prevention & Liver Health',
      titleAm: 'የቫይራል ሄፓታይተስ መከላከያና የጉበት ጤና',
      summaryEn: 'Clinical overview of Hepatitis B and C transmission, safe blood practices, and childhood vaccination.',
      summaryAm: 'ስለ ሄፓታይተስ ቢ እና ሲ መተላለፊያ መንገዶች፣ የደም ደህንነት እና የክትባት አገልግሎት ትምህርት።',
      contentEn: '# Hepatitis Awareness\n\nViral hepatitis primarily affects the liver. Safe injections, screening, and vaccines protect adolescent health...',
      contentAm: '# የሄፓታይተስ ግንዛቤ\n\nቫይራል ሄፓታይተስ ጉበትን የሚያጠቃ በሽታ ሲሆን በክትባትና በንጽህና በቀላሉ መከላከል ይቻላል...',
      readTimeMin: 4,
      authorName: 'Dr. Hanna Bekele, Adolescent Specialist',
      orderIndex: 3,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Hepatitis B is preventable through a safe and highly effective medical vaccine.',
          questionAm: 'የሄፓታይተስ ቢ በሽታ አስተማማኝ በሆነ የህክምና ክትባት ሙሉ በሙሉ መከላከል ይቻላል።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 0,
          explanationEn: 'The Hepatitis B vaccine provides greater than 95% protection against infection and chronic liver disease.',
          explanationAm: 'የሄፓታይተስ ቢ ክትባት ከ95% በላይ በሽታውንና የጉበት ጉዳትን የመከላከል አቅም አለው።',
        },
      ],
    },
    {
      id: 'module-04',
      category: 'gbv',
      titleEn: 'Gender-Based Violence Prevention & Support',
      titleAm: 'ጾታን መሰረት ያደረጉ ጥቃቶችን መከላከልና ድጋፍ',
      summaryEn: 'Recognizing abuse, mutual consent, emergency medical care, and confidential legal/counseling hotlines.',
      summaryAm: 'ስለ ጥቃት አይነቶች፣ የፈቃደኝነት አስፈላጊነት፣ የድንገተኛ ህክምናና ነጻ የስልክ የእርዳታ መስመሮች መረጃ።',
      contentEn: '# Safety & Protection from GBV\n\nEveryone has the fundamental right to safety, dignity, and bodily autonomy. If you or someone you know experienced violence, immediate 72-hour emergency care is critical...',
      contentAm: '# ጥቃትን መከላከልና ድጋፍ\n\nማንኛውም ሰው ከአካላዊና ስነ-ልቦናዊ ጥቃት ነጻ የመሆን ተፈጥሯዊ መብት አለው። ጥቃት ከደረሰ በ72 ሰዓታት ውስጥ ወደ ጤና ተቋም መሄድ ያስፈልጋል...',
      readTimeMin: 5,
      authorName: 'Talent Youth Health Team',
      orderIndex: 4,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Post-exposure prophylaxis (PEP) and emergency care should be sought within 72 hours of sexual assault.',
          questionAm: 'የጾታ ጥቃት የደረሰበት ሰው በ72 ሰዓታት ውስጥ የድንገተኛ ህክምና (PEP) ማግኘት አለበት።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 0,
          explanationEn: 'Seeking clinical assistance within 72 hours allows post-exposure prophylaxis against HIV and emergency pregnancy prevention.',
          explanationAm: 'በ72 ሰዓታት ውስጥ ወደ ክሊኒክ መሄድ ከኤች.አይ.ቪ የሚያድነውን የድንገተኛ መድሃኒት (PEP) እና የእርግዝና መከላከያ ለማግኘት ወሳኝ ነው።',
        },
      ],
    },
    {
      id: 'module-05',
      category: 'srh',
      titleEn: 'Sexual & Reproductive Health Foundations',
      titleAm: 'የሥነ-ተዋልዶ ጤና መሠረታዊ ግንዛቤ',
      summaryEn: 'Youth-friendly education on reproductive systems, menstrual health, and safe choices.',
      summaryAm: 'የሥነ-ተዋልዶ ጤና፣ የወር አበባ ንጽህና እና ኃላፊነት የተሞላበት ውሳኔ አሰጣጥ ትምህርት።',
      contentEn: '# Reproductive Health\n\nUnderstanding reproductive anatomy and hygiene is essential for every young person...',
      contentAm: '# የሥነ-ተዋልዶ ጤና\n\nስለ ተዋልዶ አካላትና የንጽህና አጠባበቅ በቂ ግንዛቤ ማግኘት ጤናማ ሕይወትን ለመምራት ቁልፍ ነው...',
      readTimeMin: 5,
      authorName: 'Talent Youth Health Team',
      orderIndex: 5,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Menstrual health hygiene requires changing clean sanitary pads every 4 to 6 hours.',
          questionAm: 'የወር አበባ ንጽህናን ለመጠበቅ ሞዴስ በየ 4 እስከ 6 ሰዓት መቀየር ይመከራል።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 0,
          explanationEn: 'Regular pad changes prevent bacterial growth, discomfort, and reproductive tract infections.',
          explanationAm: 'ሞዴስን በየጊዜው መቀየር ባክቴሪያዎችንና የቆዳ መቆጣትን እንዲሁም ኢንፌክሽንን ለመከላከል ይረዳል።',
        },
        {
          type: 'MULTIPLE_CHOICE',
          questionEn: 'What constitutes an empowered, healthy adolescent decision regarding reproductive choices?',
          questionAm: 'በስነ-ተዋልዶ ጤና ላይ ጤናማና ኃላፊነት የተሞላበት ውሳኔ የትኛው ነው?',
          optionsEn: [
            'Seeking verified medical guidance and making informed, mutual choices',
            'Surrendering to unverified peer pressure',
            'Concealing serious symptoms due to stigma',
            'Believing common social media myths',
          ],
          optionsAm: [
            'ትክክለኛ የጤና መረጃ ማግኘትና በእውቀት ላይ የተመሠረተ ውሳኔ መወሰን',
            'ለአቻ ግፊት በጭፍን መገዛት',
            'የበሽታ ምልክቶችን በማፈር መደበቅ',
            'የማህበራዊ ሚዲያ ወሬዎችን መቀበል',
          ],
          correctIndex: 0,
          explanationEn: 'Evidence-based knowledge equips adolescents to make autonomous, safe decisions.',
          explanationAm: 'ትክክለኛ የጤና እውቀት ወጣቶች ራሳቸውን እንዲጠብቁና አስተማማኝ ውሳኔ እንዲያደርጉ ያስችላቸዋል።',
        },
      ],
    },
    {
      id: 'module-06',
      category: 'mental_health',
      titleEn: 'Youth Mental Health & Anxiety Management',
      titleAm: 'የወጣቶች አእምሯዊ ጤናና የጭንቀት አያያዝ',
      summaryEn: 'Recognizing stress, peer pressure, exam anxiety, and free counseling avenues.',
      summaryAm: 'የጭንቀት ምልክቶች፣ የተማሪዎች ጭንቀት አያያዝ እና ነጻ የምክር አገልግሎት መረጃ።',
      contentEn: '# Adolescent Mental Health\n\nYour mental health is just as important as your physical health...',
      contentAm: '# የአእምሮ ጤና\n\nየአእምሮ ጤንነት ልክ እንደ አካል ጤንነት እኩል አስፈላጊና ሊንከባከቡት የሚገባ ነው...',
      readTimeMin: 5,
      authorName: 'Ethiopian Psychologists & Counselors Network',
      orderIndex: 6,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Experiencing feelings of sadness or anxiety occasionally during teenage years means a person is permanently broken.',
          questionAm: 'በወጣትነት ወቅት አልፎ አልፎ የመጨነቅ ወይም የማዘን ስሜት መሰማት የአእምሮ መታወክ ምልክት ነው።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 1,
          explanationEn: 'Emotional fluctuations are normal responses to stress and hormonal development; seeking peer counseling or talking to a trusted adult helps manage them.',
          explanationAm: 'ስሜታዊ መዋዠቅ የተለመደ የጉርምስናና የህይወት ፈተና አካል ሲሆን ከአማካሪዎች ጋር መነጋገር ጤናማ መፍትሄን ይሰጣል።',
        },
        {
          type: 'MULTIPLE_CHOICE',
          questionEn: 'What is an evidence-based technique for managing severe exam panic and anxiety?',
          questionAm: 'የፈተና ጭንቀትንና ፍርሃትን ለመቀነስ የሚረዳ የተረጋገጠ ዘዴ የትኛው ነው?',
          optionsEn: [
            'Deep diaphragmatic breathing and structured study intervals',
            'Consuming unprescribed stimulant pills',
            'Staying awake all night before exams',
            'Isolating oneself completely from friends and family',
          ],
          optionsAm: [
            'ረጅም ትንፋሽ መውሰድና ጥናትን በዕረፍት ከፋፍሎ ማጥናት',
            'ያልታዘዙ አነቃቂ መድሃኒቶችን መውሰድ',
            'ፈተና ዋዜማ ሙሉ ሌሊት ባለመተኛት ማደር',
            'ከጓደኞችና ከቤተሰብ ሙሉ ለሙሉ መገለል',
          ],
          correctIndex: 0,
          explanationEn: 'Controlled breathing calms the autonomic nervous system and regular study breaks maintain mental clarity.',
          explanationAm: 'ረጅም ትንፋሽ መውሰድ የነርቭ ስርዓትን ያረጋጋል፤ በዕረፍት ማጥናት ደግሞ አእምሮን ያድሳል።',
        },
      ],
    },
    {
      id: 'module-07',
      category: 'hiv',
      titleEn: 'HIV & AIDS Prevention and Testing',
      titleAm: 'የኤች.አይ.ቪ/ኤድስ መከላከልና የምርመራ አገልግሎት',
      summaryEn: 'Transmission myths, prevention methods, voluntary counseling, and stigma reduction.',
      summaryAm: 'የኤች.አይ.ቪ መተላለፊያ መንገዶች፣ መከላከያ ዘዴዎች እና የወጣቶች የፈቃደኝነት ምርመራ አገልግሎት።',
      contentEn: '# HIV Prevention & Support\n\nHIV attacks the body immune system. It cannot be transmitted by casual contact, sharing food, or hugs...',
      contentAm: '# ኤች.አይ.ቪን መከላከል\n\nኤች.አይ.ቪ የሰውነት በሽታ የመከላከል አቅምን የሚያጠቃ ቫይረስ ነው። በመተቃቀፍ ወይም አብሮ በመመገብ አይተላለፍም...',
      readTimeMin: 4,
      authorName: 'National Youth HIV Prevention Coalition',
      orderIndex: 7,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'HIV can be transmitted by sharing meals, hugging, or using the same toilet as an infected individual.',
          questionAm: 'ኤች.አይ.ቪ አብሮ በመመገብ፣ በመተቃቀፍ ወይም የጋራ መጸዳጃ በመጠቀም ሊተላለፍ ይችላል።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 1,
          explanationEn: 'HIV is transmitted only through specific body fluids (blood, semen, vaginal fluids, breast milk). It cannot be transmitted through saliva, sweat, or casual contact.',
          explanationAm: 'ኤች.አይ.ቪ በደም፣ በግብረ-ስጋ ግንኙነት ፈሳሽና በእናት ጡት ወተት ብቻ የሚተላለፍ ሲሆን በመተቃቀፍ ወይም አብሮ በመብላት በጭራሽ አይተላለፍም።',
        },
        {
          type: 'MULTIPLE_CHOICE',
          questionEn: 'What does U=U (Undetectable = Untransmittable) signify in modern HIV clinical medicine?',
          questionAm: 'በዘመናዊ የኤች.አይ.ቪ ህክምና U=U (የማይታወቅ = የማይተላለፍ) ማለት ምን ማለት ነው?',
          optionsEn: [
            'A person with undetectable viral load on ART cannot sexually transmit HIV',
            'HIV has been completely eradicated globally',
            'Condoms are no longer recommended for youth',
            'Testing is no longer required after age 18',
          ],
          optionsAm: [
            'መድሃኒት በአግባቡ ወስዶ በደሙ ውስጥ ቫይረሱ የማይታይ ሰው ኤች.አይ.ቪን በግንኙነት አያስተላልፍም',
            'ኤች.አይ.ቪ ከአለም ላይ ሙሉ በሙሉ ጠፍቷል',
            'ወጣቶች ኮንዶም መጠቀም አያስፈልጋቸውም',
            'ከ18 ዓመት በኋላ ምርመራ ማድረግ አያስፈልግም',
          ],
          correctIndex: 0,
          explanationEn: 'Scientific consensus confirms that maintaining an undetectable viral load through consistent antiretroviral therapy (ART) prevents sexual transmission.',
          explanationAm: 'የጸረ-ኤች.አይ.ቪ መድሃኒትን በአግባቡ በመውሰድ የቫይረሱን መጠን በደም ውስጥ ዝቅ ማድረግ ቫይረሱ በግንኙነት እንዳይተላለፍ ያደርጋል።',
        },
      ],
    },
    {
      id: 'module-08',
      category: 'substance',
      titleEn: 'Substance Abuse & Addiction Prevention',
      titleAm: 'የአደንዛዥ እጾችና ሱስ መከላከል ትምህርት',
      summaryEn: 'Overcoming peer pressure, dangers of khat/alcohol/shisha, and adolescent rehabilitation support.',
      summaryAm: 'የአቻ ግፊትን መቋቋም፣ የጫት፣ የአልኮልና የሺሻ ጉዳቶች እንዲሁም የሱስ ማገገሚያ ድጋፍ መረጃ።',
      contentEn: '# Substance-Free Healthy Living\n\nSubstance misuse during adolescent brain development poses severe long-term risks. Staying informed and knowing how to say no protects your future...',
      contentAm: '# ከሱስ የጸዳ ህይወት\n\nበጉርምስና ወቅት አደንዛዥ እጾችን መውሰድ የአእምሮ ዕድገትን ይጎዳል። ከሱስ ራስን መጠበቅ ለወደፊት ህይወት ወሳኝ ነው...',
      readTimeMin: 4,
      authorName: 'National Youth Addiction Recovery Network',
      orderIndex: 8,
      questions: [
        {
          type: 'TRUE_FALSE',
          questionEn: 'Adolescent brains are especially vulnerable to addiction because the prefrontal cortex is still developing.',
          questionAm: 'የወጣቶች አእምሮ ሙሉ ለሙሉ እድገቱን ባለመጨረሱ ለሱስ በቀላሉ የመጋለጥ እድል አለው።',
          optionsEn: ['True', 'False'],
          optionsAm: ['እውነት', 'ሐሰት'],
          correctIndex: 0,
          explanationEn: 'The decision-making and impulse-control areas of the brain continue developing until the mid-twenties, making adolescents more susceptible to chemical dependency.',
          explanationAm: 'ውሳኔ ሰጪው የአእምሮ ክፍል እስከ 25 ዓመት ድረስ በማደግ ላይ ስለሚቆይ ወጣቶች ለሱስ በቀላሉ ተጋላጭ ይሆናሉ።',
        },
      ],
    },
  ];

  for (const mod of modules) {
    let moduleRecord = await prisma.module.findFirst({
      where: {
        OR: [{ id: mod.id }, { category: mod.category }],
      },
    });

    if (!moduleRecord) {
      moduleRecord = await prisma.module.create({
        data: {
          id: mod.id,
          category: mod.category,
          titleEn: mod.titleEn,
          titleAm: mod.titleAm,
          summaryEn: mod.summaryEn,
          summaryAm: mod.summaryAm,
          contentEn: mod.contentEn,
          contentAm: mod.contentAm,
          readTimeMin: mod.readTimeMin,
          authorName: mod.authorName,
          orderIndex: mod.orderIndex,
        },
      });
    }

    // Seed questions for this module if none exist
    const existingQuestions = await prisma.quizQuestion.count({
      where: { moduleId: moduleRecord.id },
    });

    if (existingQuestions === 0 && mod.questions) {
      for (const q of mod.questions) {
        await prisma.quizQuestion.create({
          data: {
            moduleId: moduleRecord.id,
            type: q.type,
            questionEn: q.questionEn,
            questionAm: q.questionAm,
            optionsEn: JSON.stringify(q.optionsEn),
            optionsAm: JSON.stringify(q.optionsAm),
            correctIndex: q.correctIndex,
            explanationEn: q.explanationEn,
            explanationAm: q.explanationAm,
          },
        });
      }
    }
  }
  console.log('Seeded learning modules and verified assessment quizzes.');
  console.log('Seeded learning modules and quizzes.');

  // 5. Seed Student Clubs
  const clubs = [
    {
      name: 'Arada High School Youth Wellness Club',
      description: 'Peer support group promoting healthy lifestyle, puberty education, and mental wellness among high school students.',
      category: 'wellness',
      venue: 'Arada High School Main Hall',
      meetingTime: 'Every Wednesday at 4:30 PM',
      isApproved: true,
    },
    {
      name: 'Addis Ababa Youth Mental Health Champions',
      description: 'Safe space for discussions on exam stress, depression prevention, and self-care.',
      category: 'mental_health',
      venue: 'Youth Center Room B',
      meetingTime: 'Every Saturday at 10:00 AM',
      isApproved: true,
    },
    {
      name: 'Substance-Free Youth League',
      description: 'Youth-led advocacy group encouraging alcohol-free and drug-free school environments.',
      category: 'leadership',
      venue: 'Community Library',
      meetingTime: 'Bi-weekly Sunday afternoons',
      isApproved: true,
    },
  ];

  for (const c of clubs) {
    const existing = await prisma.studentClub.findFirst({ where: { name: c.name } });
    if (!existing) {
      await prisma.studentClub.create({ data: c });
    }
  }
  console.log('Seeded student clubs.');

  // 6. Seed initial audit log
  await prisma.auditLog.create({
    data: {
      action: 'SYSTEM_INITIALIZED',
      adminEmail: 'system@yegnahealth.org',
      details: 'Initial database seed completed with verified clinics, mentors, modules, and SuperAdmin account.',
    },
  });

  console.log('Seeding finished successfully!');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
