import dotenv from 'dotenv';
dotenv.config();

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const baselineQuestions = [
  {
    position: 1,
    key: 'age_group',
    titleEn: 'What is your age?',
    titleAm: 'ዕድሜዎ ስንት ነው?',
    type: 'SINGLE_CHOICE',
    isRequired: true,
    isActive: true,
    options: [
      { position: 1, value: '18–20', labelEn: '18–20', labelAm: '18–20' },
      { position: 2, value: '21–24', labelEn: '21–24', labelAm: '21–24' },
      { position: 3, value: '25–29', labelEn: '25–29', labelAm: '25–29' },
      { position: 4, value: '30+', labelEn: '30 and above', labelAm: '30 እና ከዚያ በላይ' },
    ],
  },
  {
    position: 2,
    key: 'year_of_study',
    titleEn: 'Current Year of Study',
    titleAm: 'በምን ዓመት የትምህርት ደረጃ ላይ ይገኛሉ?',
    type: 'SINGLE_CHOICE',
    isRequired: true,
    isActive: true,
    options: [
      { position: 1, value: '1st Year', labelEn: '1st Year', labelAm: '1ኛ ዓመት' },
      { position: 2, value: '2nd Year', labelEn: '2nd Year', labelAm: '2ኛ ዓመት' },
      { position: 3, value: '3rd Year', labelEn: '3rd Year', labelAm: '3ኛ ዓመት' },
      { position: 4, value: '4th Year and above', labelEn: '4th Year and above', labelAm: '4ኛ ዓመት እና ከዚያ በላይ' },
      { position: 5, value: 'Postgraduate', labelEn: 'Postgraduate', labelAm: 'የድህረ-ምረቃ' },
    ],
  },
  {
    position: 3,
    key: 'disability_need',
    titleEn: 'Disability & Accessibility Needs',
    titleAm: 'የአካል ጉዳት ወይም የተለየ የተደራሽነት ፍላጎት አለዎት?',
    type: 'SINGLE_CHOICE',
    isRequired: true,
    isActive: true,
    options: [
      { position: 1, value: 'NONE', labelEn: 'None', labelAm: 'የለብኝም' },
      { position: 2, value: 'VISUAL', labelEn: 'Visual impairment', labelAm: 'የእይታ ድጋፍ' },
      { position: 3, value: 'HEARING', labelEn: 'Hearing impairment', labelAm: 'የመስማት ድጋፍ' },
      { position: 4, value: 'PHYSICAL', labelEn: 'Physical / Mobility assistance', labelAm: 'የእንቅስቃሴ ድጋፍ' },
      { position: 5, value: 'PREFER_NOT_TO_SAY', labelEn: 'Prefer not to say', labelAm: 'መግለጽ አልፈልግም' },
    ],
  },
  {
    position: 4,
    key: 'gondar_srh',
    titleEn: 'University of Gondar SRH Clinic Awareness',
    titleAm: 'በጎንደር ዩኒቨርሲቲ የጾታዊና የስነ-ተዋልዶ ጤና አገልግሎት የት እንደሚገኝ ያውቃሉ?',
    type: 'SINGLE_CHOICE',
    isRequired: true,
    isActive: true,
    options: [
      { position: 1, value: 'YES', labelEn: 'Yes, I know', labelAm: 'አዎ አውቃለሁ' },
      { position: 2, value: 'NO', labelEn: 'No, not yet', labelAm: 'አላውቅም' },
      { position: 3, value: 'NOT_SURE', labelEn: 'Not sure', labelAm: 'እርግጠኛ አይደለሁም' },
    ],
  },
];

async function seed() {
  console.log('Seeding baseline survey questions...');
  for (const q of baselineQuestions) {
    const existing = await prisma.surveyQuestion.findUnique({
      where: { key: q.key },
    });

    if (!existing) {
      await prisma.surveyQuestion.create({
        data: {
          position: q.position,
          key: q.key,
          titleEn: q.titleEn,
          titleAm: q.titleAm,
          type: q.type,
          isRequired: q.isRequired,
          isActive: q.isActive,
          options: {
            create: q.options,
          },
        },
      });
      console.log(`Created question: ${q.titleEn}`);
    } else {
      console.log(`Question already exists: ${q.titleEn}`);
    }
  }
  console.log('Survey question seeding completed successfully.');
}

seed()
  .catch((err) => {
    console.error('Seeding error:', err);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
