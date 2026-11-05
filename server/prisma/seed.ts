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
    update: { passwordHash, role: 'SUPER_ADMIN' },
    create: {
      email: 'admin@yegnahealth.org',
      displayName: 'Natnael Z. (SuperAdmin)',
      passwordHash,
      role: 'SUPER_ADMIN',
    },
  });
  console.log('Admin account seeded:', admin.email);

  // Also seed alternate admin alias matching mobile user testing
  await prisma.user.upsert({
    where: { email: 'natnaelzemene21@gmail.com' },
    update: { passwordHash, role: 'SUPER_ADMIN' },
    create: {
      email: 'natnaelzemene21@gmail.com',
      displayName: 'Natnael Zemene (Executive Admin)',
      passwordHash,
      role: 'SUPER_ADMIN',
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

  // 4. Seed Core Learning Modules & Articles
  const modules = [
    {
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
    },
    {
      category: 'srh',
      titleEn: 'Sexual & Reproductive Health Foundations',
      titleAm: 'የሥነ-ተዋልዶ ጤና መሠረታዊ ግንዛቤ',
      summaryEn: 'Youth-friendly education on reproductive systems, menstrual health, and safe choices.',
      summaryAm: 'የሥነ-ተዋልዶ ጤና፣ የወር አበባ ንጽህና እና ኃላፊነት የተሞላበት ውሳኔ አሰጣጥ ትምህርት።',
      contentEn: '# Reproductive Health\n\nUnderstanding reproductive anatomy and hygiene is essential for every young person...',
      contentAm: '# የሥነ-ተዋልዶ ጤና\n\nስለ ተዋልዶ አካላትና የንጽህና አጠባበቅ በቂ ግንዛቤ ማግኘት ጤናማ ሕይወትን ለመምራት ቁልፍ ነው...',
      readTimeMin: 5,
      authorName: 'Talent Youth Health Team',
      orderIndex: 2,
    },
    {
      category: 'hiv',
      titleEn: 'HIV & AIDS Prevention and Testing',
      titleAm: 'የኤች.አይ.ቪ/ኤድስ መከላከልና የምርመራ አገልግሎት',
      summaryEn: 'Transmission myths, prevention methods, voluntary counseling, and stigma reduction.',
      summaryAm: 'የኤች.አይ.ቪ መተላለፊያ መንገዶች፣ መከላከያ ዘዴዎች እና የወጣቶች የፈቃደኝነት ምርመራ አገልግሎት።',
      contentEn: '# HIV Prevention & Support\n\nHIV attacks the body immune system. It cannot be transmitted by casual contact, sharing food, or hugs...',
      contentAm: '# ኤች.አይ.ቪን መከላከል\n\nኤች.አይ.ቪ የሰውነት በሽታ የመከላከል አቅምን የሚያጠቃ ቫይረስ ነው። በመተቃቀፍ ወይም አብሮ በመመገብ አይተላለፍም...',
      readTimeMin: 4,
      authorName: 'National Youth HIV Prevention Coalition',
      orderIndex: 3,
    },
    {
      category: 'mental_health',
      titleEn: 'Youth Mental Health & Anxiety Management',
      titleAm: 'የወጣቶች አእምሯዊ ጤናና የጭንቀት አያያዝ',
      summaryEn: 'Recognizing stress, peer pressure, exam anxiety, and free counseling avenues.',
      summaryAm: 'የጭንቀት ምልክቶች፣ የተማሪዎች ጭንቀት አያያዝ እና ነጻ የምክር አገልግሎት መረጃ።',
      contentEn: '# Adolescent Mental Health\n\nYour mental health is just as important as your physical health...',
      contentAm: '# የአእምሮ ጤና\n\nየአእምሮ ጤንነት ልክ እንደ አካል ጤንነት እኩል አስፈላጊና ሊንከባከቡት የሚገባ ነው...',
      readTimeMin: 5,
      authorName: 'Ethiopian Psychologists & Counselors Network',
      orderIndex: 4,
    },
  ];

  for (const mod of modules) {
    const existing = await prisma.module.findFirst({ where: { category: mod.category } });
    if (!existing) {
      const created = await prisma.module.create({ data: mod });
      // Add a sample quiz question to this module
      await prisma.quizQuestion.create({
        data: {
          moduleId: created.id,
          questionEn: `Which of the following is a key practice for ${mod.category} health?`,
          questionAm: `ከሚከተሉት ውስጥ ለ${mod.titleAm} ጤና ትክክለኛ የሆነው የትኛው ነው?`,
          optionsEn: JSON.stringify([
            'Consulting verified health workers & educators',
            'Believing unverified social media rumors',
            'Ignoring persistent health symptoms',
            'Isolating oneself during stress',
          ]),
          optionsAm: JSON.stringify([
            'የተረጋገጡ የጤና ባለሙያዎችንና መረጃዎችን ማማከር',
            'ያልተረጋገጡ የማህበራዊ ሚዲያ ወሬዎችን ማመን',
            'የበሽታ ምልክቶችን ችላ ማለት',
            'በጭንቀት ወቅት ከሰዎች መራቅ',
          ]),
          correctIndex: 0,
          explanationEn: 'Evidence-based guidance from qualified health professionals is the safest way to address health questions.',
          explanationAm: 'ከብቁ የጤና ባለሙያዎች የሚገኝ ትክክለኛ መረጃ ለጤናችን ሁነኛ መፍትሄ ነው።',
        },
      });
    }
  }
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
