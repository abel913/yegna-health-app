export interface TemplateQuizQuestion {
  type: 'MULTIPLE_CHOICE' | 'TRUE_FALSE';
  questionEn: string;
  questionAm: string;
  optionsEn: string[];
  optionsAm: string[];
  correctIndex: number;
  explanationEn: string;
  explanationAm: string;
}

export interface CurriculumSection {
  id: string;
  titleEn: string;
  titleAm: string;
  bodyEn: string;
  bodyAm: string;
  bulletsEn: string[];
  bulletsAm: string[];
  tipEn: string;
  tipAm: string;
}

export interface CurriculumTemplate {
  id: string;
  nameEn: string;
  nameAm: string;
  category: string;
  imageAsset: string;
  readTimeMin: number;
  authorName: string;
  titleEn: string;
  titleAm: string;
  summaryEn: string;
  summaryAm: string;
  doctorNoteEn: string;
  doctorNoteAm: string;
  contentEn: string;
  contentAm: string;
  questions?: TemplateQuizQuestion[];
}

export const OFFICIAL_ILLUSTRATIONS = [
  {
    id: 'puberty',
    name: 'Puberty & Growth',
    path: 'assets/images/learning/module_01_puberty.jpg',
    previewUrl: '/illustrations/module_01_puberty.jpg',
  },
  {
    id: 'sti',
    name: 'STI Prevention',
    path: 'assets/images/learning/module_02_sti.png',
    previewUrl: '/illustrations/module_02_sti.png',
  },
  {
    id: 'hepatitis',
    name: 'Viral Hepatitis',
    path: 'assets/images/learning/module_03_hepatitis.png',
    previewUrl: '/illustrations/module_03_hepatitis.png',
  },
  {
    id: 'gbv',
    name: 'GBV & Consent',
    path: 'assets/images/learning/module_04_gbv.png',
    previewUrl: '/illustrations/module_04_gbv.png',
  },
  {
    id: 'srh',
    name: 'Reproductive Health',
    path: 'assets/images/learning/module_05_srh.png',
    previewUrl: '/illustrations/module_05_srh.png',
  },
  {
    id: 'mental_health',
    name: 'Mental Health & Stress',
    path: 'assets/images/learning/module_06_mental_health.jpg',
    previewUrl: '/illustrations/module_06_mental_health.jpg',
  },
  {
    id: 'hiv',
    name: 'HIV Awareness',
    path: 'assets/images/learning/module_07_hiv.png',
    previewUrl: '/illustrations/module_07_hiv.png',
  },
  {
    id: 'substance',
    name: 'Substance Prevention',
    path: 'assets/images/learning/module_08_substance_abuse.png',
    previewUrl: '/illustrations/module_08_substance_abuse.png',
  },
];

interface RawParsedSection {
  title: string;
  body: string;
  bullets: string[];
  tip: string;
}

function parseSingleMarkdown(content: string): RawParsedSection[] {
  if (!content) return [];
  // Strip note preamble before first ## section
  const firstHeaderIdx = content.search(/(?:^|[\r\n]+)##\s+/);
  const cleanContent = firstHeaderIdx !== -1 ? content.slice(firstHeaderIdx).replace(/^[\r\n]+/, '') : content;

  // Split on ## Section headers
  const blocks = cleanContent.split(/[\r\n]+##\s+/);
  return blocks
    .map((block) => {
      let trimmed = block.trim();
      if (trimmed.startsWith('##')) {
        trimmed = trimmed.replace(/^##\s*/, '');
      }
      if (!trimmed || trimmed.startsWith('| Note:') || trimmed.startsWith('| ማስታወሻ:')) {
        return null;
      }
      const lines = trimmed.split(/\r?\n/);
      const title = lines[0]?.trim() || '';
      const remainingLines = lines.slice(1);

      const bodyLines: string[] = [];
      const bullets: string[] = [];
      let tip = '';

      remainingLines.forEach((line) => {
        const l = line.trim();
        if (l.startsWith('- ') || l.startsWith('* ')) {
          bullets.push(l.slice(2).trim());
        } else if (l.startsWith('> Clinical Tip:') || l.startsWith('> የዶክተር ማስታወሻ:')) {
          tip = l.replace(/^>\s*(Clinical Tip:|የዶክተር ማስታወሻ:)?\s*/, '').trim();
        } else if (l.startsWith('>')) {
          tip = l.replace(/^>\s*/, '').trim();
        } else if (l.length > 0) {
          bodyLines.push(l);
        }
      });

      return {
        title,
        body: bodyLines.join('\n'),
        bullets,
        tip,
      };
    })
    .filter((sec): sec is RawParsedSection => Boolean(sec && sec.title));
}

export function parseMarkdownToSections(contentEn: string, contentAm: string): CurriculumSection[] {
  const enSections = parseSingleMarkdown(contentEn);
  const amSections = parseSingleMarkdown(contentAm);
  const maxLen = Math.max(enSections.length, amSections.length);

  const result: CurriculumSection[] = [];
  for (let i = 0; i < maxLen; i++) {
    const enSec = enSections[i] || { title: '', body: '', bullets: [], tip: '' };
    const amSec = amSections[i] || { title: '', body: '', bullets: [], tip: '' };
    const maxBullets = Math.max(enSec.bullets.length, amSec.bullets.length);

    const bulletsEn: string[] = [];
    const bulletsAm: string[] = [];
    for (let b = 0; b < maxBullets; b++) {
      bulletsEn.push(enSec.bullets[b] || '');
      bulletsAm.push(amSec.bullets[b] || '');
    }

    result.push({
      id: 'sec-' + (i + 1) + '-' + Date.now(),
      titleEn: enSec.title,
      titleAm: amSec.title,
      bodyEn: enSec.body,
      bodyAm: amSec.body,
      bulletsEn,
      bulletsAm,
      tipEn: enSec.tip,
      tipAm: amSec.tip,
    });
  }
  return result;
}

export function serializeSectionsToMarkdown(sections: CurriculumSection[]): {
  contentEn: string;
  contentAm: string;
} {
  const serializeLang = (lang: 'en' | 'am') => {
    if (!sections || sections.length === 0) return '';
    return sections
      .map((sec) => {
        const title = lang === 'en' ? sec.titleEn : sec.titleAm;
        const body = lang === 'en' ? sec.bodyEn : sec.bodyAm;
        const bullets = lang === 'en' ? sec.bulletsEn : sec.bulletsAm;
        const tip = lang === 'en' ? sec.tipEn : sec.tipAm;

        let md = '## ' + (title || (lang === 'en' ? 'Untitled Section' : 'ያልተሰየመ ክፍል')) + '\n';
        if (body && body.trim()) {
          md += body.trim() + '\n\n';
        }
        if (bullets && bullets.length > 0) {
          bullets
            .filter((b) => b && b.trim())
            .forEach((b) => {
              md += '- ' + b.trim() + '\n';
            });
          md += '\n';
        }
        if (tip && tip.trim()) {
          const prefix = lang === 'en' ? '> Clinical Tip: ' : '> የዶክተር ማስታወሻ: ';
          md += prefix + tip.trim() + '\n\n';
        }
        return md.trim();
      })
      .join('\n\n')
      .trim();
  };

  return {
    contentEn: serializeLang('en'),
    contentAm: serializeLang('am'),
  };
}

export const CURRICULUM_TEMPLATES: CurriculumTemplate[] = [
  {
    id: "module-01",
    nameEn: "Adolescent health & puberty",
    nameAm: "የወጣቶች ጤና እና የጉርምስና ወቅት",
    category: "puberty",
    imageAsset: "module_01_puberty.jpg",
    readTimeMin: 4,
    authorName: "Dr. Hanna Bekele, Adolescent Specialist",
    titleEn: "Adolescent health & puberty",
    titleAm: "የወጣቶች ጤና እና የጉርምስና ወቅት",
    summaryEn: "Puberty is a natural transition from childhood into adulthood, characterized by physical, hormonal, and emotional changes that shape personal growth and health.",
    summaryAm: "የጉርምስና ወቅት ከአካላዊ፣ ከሆርሞንና ከስሜታዊ ለውጦች ጋር የተያያዘ የተፈጥሮ የዕድገት ደረጃ ሲሆን የግል እድገትንና ጤናን ይቀርጻል።",
    doctorNoteEn: "Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition.",
    doctorNoteAm: "እያንዳንዱ ታዳጊ ጉርምስናን በራሱ የተፈጥሮ ፍጥነት ያሳልፋል—ጥሩ የግል ንጽህናን መጠበቅ፣ የሰውነት ለውጦችን መረዳትና በራስ መተማመን ለጤናማ ሽግግር ወሳኝ ናቸው።",
    contentEn: "| Note: Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition.\n\n## Understanding Puberty & Adolescence\nThe Natural Transition to Adulthood\n\nPuberty is the developmental stage where the body undergoes rapid hormonal and biological changes, enabling physical maturity and reproductive capability.\n\n- Hormonal triggers: The pituitary gland releases hormones that signal the body to grow and develop secondary sexual characteristics.\n- Individual timing: Puberty typically begins between ages 9 and 14, varying naturally among individuals.\n- Normal variation: Growing at different rates than peers is completely normal and healthy.\n\n> Clinical Tip: Development pace is genetically driven. Do not measure your worth or progress against peers.\n\n## Physical Changes in Females & Males\nKey Physical Milestones\n\nChanges in Females: and Changes in Males:\n\n- Changes in Females: Breast development and widening of hips\n- Growth of body hair (underarms and pubic area)\n- Onset of menstruation (menarche), the monthly cycle preparing the uterus for potential pregnancy\n- Changes in Males: Deepening of the voice (voice cracks and lower pitch)\n- Growth of facial, underarm, chest, and pubic hair\n- Growth of testicles and penis, along with nocturnal emissions ('wet dreams'), a normal involuntary release of semen during sleep\n\n> Clinical Tip: Growth spurts and voice cracks are temporary adjustments as cartilage and bones adapt to adult proportions.\n\n## Emotional & Psychological Changes\nNavigating Thoughts and Emotions\n\nAlongside physical transformations, teenagers experience significant cognitive and emotional growth.\n\n- Mood shifts: Fluctuating hormones combined with social adjustments can cause temporary mood swings.\n- Identity search: Developing self-awareness, exploring personal values, and discovering individuality.\n- Desire for independence: Transitioning toward greater personal autonomy and decision-making.\n- Peer influence: Friendships and social groups become central to emotional support and communication.\n\n> Clinical Tip: Mood shifts are biochemically real. Take deep breaths, write down thoughts, and talk to trusted counselors.\n\n## Hygiene & Self-Care during Adolescence\nDaily Habits for Lifelong Health\n\n- Bathing and deodorants: Sweat glands become more active; daily washing with clean water and mild soap prevents body odor.\n- Skin and face care: Increased oil production can cause acne; wash the face twice daily and avoid squeezing pimples.\n- Menstrual hygiene: Change sanitary pads or clean supplies every 4–6 hours, wash hands before and after, and dispose of materials safely.\n- Nutrition and sleep: Growing bodies require 8–10 hours of restful sleep each night and a balanced diet rich in vitamins and iron.\n\n> Clinical Tip: Wash face twice daily with mild soap, and never hesitate to consult a clinic for menstrual pain or persistent acne.",
    contentAm: "| ማስታወሻ: እያንዳንዱ ታዳጊ ጉርምስናን በራሱ የተፈጥሮ ፍጥነት ያሳልፋል—ጥሩ የግል ንጽህናን መጠበቅ፣ የሰውነት ለውጦችን መረዳትና በራስ መተማመን ለጤናማ ሽግግር ወሳኝ ናቸው።\n\n## የጉርምስና እና የታዳጊነት ወቅት ግንዛቤ\nወደ ጉልምስና የሚደረግ ተፈጥሯዊ ሽግግር\n\nጉርምስና የሰውነት ሆርሞኖች እና አካላዊ እድገት በፍጥነት የሚከሰቱበት እና የመራባት አቅም የሚዳብርበት ተፈጥሯዊ የዕድገት ምዕራፍ ነው።\n\n- የሆርሞን ለውጦች፡ የፒቱታሪ እጢ ሆርሞኖችን በማመንጨት ሰውነት እንዲያድግና ሁለተኛ ደረጃ የፆታ ባህሪያትን እንዲያሳይ ያደርጋል።\n- የዕድሜ ልዩነት፡ ጉርምስና በአብዛኛው በ9 እና በ14 ዓመት መካከል የሚጀምር ሲሆን በሰዎች መካከል የጊዜ ልዩነት መኖሩ የተለመደ ነው።\n- የተፈጥሮ ልዩነቶች፡ ከእኩዮች ጋር በእድገት ፍጥነት መለያየት ሙሉ በሙሉ ተፈጥሯዊና ጤናማ ነው።\n\n> የዶክተር ማስታወሻ: የእድገትዎን ፍጥነት ከጓደኞችዎ ጋር አያወዳድሩ፤ የተፈጥሮ ዘረመል የራሱን ጊዜ ይከተላል።\n\n## በወንዶች እና በሴቶች ላይ የሚታዩ አካላዊ ለውጦች\nዋና ዋና የአካል ለውጦች\n\nበሴቶች ላይ የሚታዩ ለውጦች፡ እና በወንዶች ላይ የሚታዩ ለውጦች፡\n\n- በሴቶች ላይ የሚታዩ ለውጦች፡ የጡት ማደግ እና የወገብ መስፋት\n- የብብትና የብልት አካባቢ ፀጉር ማብቀል\n- የወር አበባ መጀመር፣ ማህፀን ለእርግዝና ዝግጁ የሚሆንበት ወርሃዊ ተፈጥሯዊ ዑደት\n- በወንዶች ላይ የሚታዩ ለውጦች፡ የድምፅ መጎርነን (የድምፅ መለወጥ)\n- የፊት፣ የብብት፣ የደረት እና የብልት አካባቢ ፀጉር ማብቀል\n- የዘር ፍሬ እና ብልት ማደግ እንዲሁም በእንቅልፍ ወቅት የሚከሰት የተፈጥሮ የዘር ፈሳሽ መፍሰስ\n\n> የዶክተር ማስታወሻ: የድምፅ መሰነጣጠቅና ፈጣን ቁመት መጨመር ጊዜያዊ የሰውነት መላመጃዎች ናቸው።\n\n## ስሜታዊ እና ስነ-ልቦናዊ ለውጦች\nሀሳቦችንና ስሜቶችን በአግባቡ መምራት\n\nከአካላዊ ለውጦች ጎን ለጎን ታዳጊዎች ከፍተኛ የአስተሳሰብ እና የስሜት እድገት ያሳያሉ።\n\n- የስሜት መዋዠቅ፡ የሆርሞን ለውጦች ከማህበራዊ ሁኔታዎች ጋር ተዳምረው ጊዜያዊ የስሜት መለዋወጥ ሊያስከትሉ ይችላሉ።\n- ማንነትን ማወቅ፡ ራስን መረዳት፣ የግል እሴቶችን መለየት እና የራስን ማንነት መገንባት።\n- ነጻነትን መፈለግ፡ የራስን ውሳኔ የመወሰን እና ነጻ የመሆን ፍላጎት መጨመር።\n- የጓደኞች ተጽዕኖ፡ ጓደኝነት እና ማህበራዊ ግንኙነቶች ለስሜታዊ ድጋፍ ትልቅ ቦታ ይኖራቸዋል።\n\n> የዶክተር ማስታወሻ: የስሜት መለዋወጥ ተፈጥሯዊ ነው፤ ስሜት ሲረበሽ በጥልቀት መተንፈስና የታመኑ ሰዎችን ማናገር ይመረጣል።\n\n## በጉርምስና ወቅት የግል ንጽህና እና እንክብካቤ\nለዕድሜ ልክ ጤና የሚጠቅሙ ዕለታዊ ልማዶች\n\n- መታጠብ እና የሰውነት ሽታ መከላከል፡ የላብ እጢዎች በከፍተኛ ሁኔታ ስለሚሰሩ በንጹህ ውሃ እና ሳሙና በየቀኑ መታጠብ የሰውነት ሽታን ይከላከላል።\n- የፊትና የቆዳ እንክብካቤ፡ የቅባት መጨመር የፊት ላይ ብጉር ሊያመጣ ስለሚችል ፊትን በቀን ሁለት ጊዜ መታጠብና ብጉርን አለመንካት ይመረጣል።\n- የወር አበባ ንጽህና፡ ሞዴስን በየ4-6 ሰዓቱ መቀየር፣ እጅን በሳሙና መታጠብ እና ያገለገሉ ቁሳቁሶችን በአግባቡ ማስወገድ።\n- ምግብና እንቅልፍ፡ በማደግ ላይ ያለ ሰውነት በቂ እረፍት (8-10 ሰዓታት እንቅልፍ) እና የተመጣጠነ ምግብ ይፈልጋል።\n\n> የዶክተር ማስታወሻ: ፊትዎን በቀን ሁለት ጊዜ ለስላሳ ሳሙና ይታጠቡ፤ የወር አበባ ህመም ወይም ከባድ ብጉር ካለ የጤና ባለሙያ ያማክሩ።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "Puberty is a natural biological transition where each person grows and develops at their own unique, normal pace.",
            "questionAm": "ጉርምስና እያንዳንዱ ሰው በራሱ የተፈጥሮ ፍጥነት የሚያልፍበት ጤናማና ተፈጥሯዊ የዕድገት ደረጃ ነው።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Puberty begins at different times for everyone, usually between ages 9 and 14. Variance in timing and growth rate is completely normal.",
            "explanationAm": "ጉርምስና ለሁሉም ሰው በተለያየ ዕድሜ (ከ9 እስከ 14 ዓመት) ይጀምራል፤ በጊዜውና በፍጥነቱ መለያየት ፍጹም ተፈጥሯዊ ነው።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "What is a normal and healthy physical change that occurs during male puberty?",
            "questionAm": "በወንዶች የጉርምስና ወቅት የሚታየው ጤናማና ተፈጥሯዊ አካላዊ ለውጥ የትኛው ነው?",
            "optionsEn": [
                "Deepening of the voice and growth of facial/body hair",
                "Sudden complete loss of appetite",
                "Permanent loss of sleep",
                "Inability to run or exercise"
            ],
            "optionsAm": [
                "የድምፅ መጎርነን እና የፊት እንዲሁም የሰውነት ፀጉር ማብቀል",
                "ድንገተኛ የምግብ ፍላጎት ሙሉ በሙሉ መጥፋት",
                "እንቅልፍ ሙሉ በሙሉ ማጣት",
                "የአካል ብቃት እንቅስቃሴ ማድረግ አለመቻል"
            ],
            "correctIndex": 0,
            "explanationEn": "Voice deepening, growth spurts, and hair development are classic signs of testosterone production and healthy male pubertal development.",
            "explanationAm": "የድምፅ መጎርነን እና የሰውነት ፀጉር ማደግ የወንድ ሆርሞን (ቴስቶስትሮን) መመንጨትና የተፈጥሮ ዕድገት ምልክቶች ናቸው።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "What is the recommended hygiene practice during menstruation?",
            "questionAm": "በወር አበባ ወቅት የሚመከረው ትክክለኛ የንጽህና አጠባበቅ የትኛው ነው?",
            "optionsEn": [
                "Change sanitary products regularly (every 4–6 hours) and wash hands",
                "Avoid bathing until the cycle ends",
                "Use unwashed cloths repeatedly without drying",
                "Avoid drinking water throughout the cycle"
            ],
            "optionsAm": [
                "የንጽህና መጠበቂያ ቁሳቁሶችን በየ 4–6 ሰዓት መቀየር እና እጅን መታጠብ",
                "የወር አበባ እስኪያበቃ ድረስ አለመታጠብ",
                "ያልታጠበ ጨርቅን ደጋግሞ መጠቀም",
                "በዑደቱ ወቅት ውሃ አለመጠጣት"
            ],
            "correctIndex": 0,
            "explanationEn": "Regularly changing sanitary supplies every 4 to 6 hours and practicing good hand hygiene prevents irritation and bacterial infections.",
            "explanationAm": "የንጽህና መጠበቂያዎችን በየ 4 እስከ 6 ሰዓቱ መቀየርና እጅን በሳሙና መታጠብ ኢንፌክሽንንና አለርጂን ይከላከላል።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Emotional changes and mood shifts during adolescence are common and can be managed through open communication, exercise, and adequate sleep.",
            "questionAm": "በጉርምስና ወቅት የሚታዩ የስሜት መለዋወጦች የተለመዱ ሲሆኑ በውይይት፣ በአካል ብቃት እንቅስቃሴ እና በበቂ እንቅልፍ ማስተካከል ይቻላል።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Hormonal shifts and expanding social worlds make emotional fluctuations normal. Talking to trusted friends or family helps navigate these feelings.",
            "explanationAm": "የሆርሞን ለውጦች የስሜት መዋዠቅ ሊፈጥሩ ይችላሉ፤ ከታመኑ ቤተሰቦች ወይም ጓደኞች ጋር መወያየት መፍትሄ ያመጣል።"
        }
    ],
  },
  {
    id: "module-02",
    nameEn: "Sexual transmitted infections (STI)",
    nameAm: "በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STI)",
    category: "sti",
    imageAsset: "module_02_sti.png",
    readTimeMin: 4,
    authorName: "National Youth Health Coalition",
    titleEn: "Sexual transmitted infections (STI)",
    titleAm: "በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STI)",
    summaryEn: "STIs are infections spread mainly through unprotected sexual contact; they may show no symptoms but can cause serious health complications if untreated, and can be managed effectively with early diagnosis and proper treatment.",
    summaryAm: "በግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STIs) በዋነኝነት የሚተላለፉት ጥንቃቄ በጎደለው የግብረ ሥጋ ግንኙነት ሲሆን ምንም ምልክት ላያሳዩ ይችላሉ፤ ነገር ግን ካልታከሙ ከባድ የጤና ጉዳቶችን ሊያስከትሉ ይችላሉ። በቅድመ ምርመራና ተገቢ ሕክምና በብቃት መቆጣጠር ይቻላል።",
    doctorNoteEn: "Protect yourself by practicing safe sex, getting tested regularly, and seeking medical care early knowing your status helps prevent complications and protects others.",
    doctorNoteAm: "ደህንነቱ የተጠበቀ የግብረ ሥጋ ግንኙነት በማድረግ፣ አዘውትረው በመመርመር እና አስቀድመው የህክምና እርዳታ በማግኘት ራስዎን ይጠብቁ፤ የጤና ሁኔታዎን ማወቅ ችግሮችን ለመከላከል እና ሌሎችንም ለመጠበቅ ይረዳል።",
    contentEn: "| Note: Protect yourself by practicing safe sex, getting tested regularly, and seeking medical care early knowing your status helps prevent complications and protects others.\n\n## Definition\nWhat are Sexually Transmitted Infections (STIs)?\n\nSexually Transmitted Infections (STIs) are infections passed from person to person primarily through sexual contact (vaginal, oral, or anal intercourse). They are caused by bacteria, viruses, or parasites.\n\n- Common bacterial STIs include Chlamydia, Gonorrhea, and Syphilis. Common viral STIs include HPV (Human Papillomavirus), Herpes (HSV), Hepatitis B, and HIV. Common parasitic STIs include Trichomoniasis.\n- An infection (STI) means a pathogen is present in the body, often without causing symptoms. It becomes a disease (STD) when the infection causes noticeable damage or illness. Many STIs are silent but still contagious.\n\n> Clinical Tip: An STI means a pathogen is present in the body, often without symptoms. STDs represent active tissue damage.\n\n## Signs and Symptoms of STI\nRecognizing common signs and asymptomatic cases\n\nSymptoms can vary depending on the specific infection and gender, but commonly include:\n\n- Unusual discharge: Thick, watery, yellow, green, or foul-smelling discharge from the penis, vagina, or anus.\n- Pain or burning sensation: Discomfort or burning pain during urination (dysuria) or during sexual intercourse.\n- Sores, bumps, or blisters: Painful or painless blisters, ulcers, warts, or lesions on the genitals, groin, mouth, or anus.\n- Itching and irritation: Persistent itching, redness, or swelling around the genital and perineal areas.\n- Abdominal or pelvic pain: Lower belly pain, unexpected bleeding between menstrual periods, or bleeding after intercourse.\n\n> Clinical Tip: Silent infections: Up to 70% of women and many men with STIs like chlamydia or gonorrhea experience NO noticeable symptoms. Regular clinical testing is the only reliable way to confirm status.\n\n## Diagnosis of STI\nHow healthcare providers detect and evaluate STIs\n\nEarly diagnosis ensures quick cure and prevents irreversible reproductive damage. Healthcare providers use:\n\n- Clinical examination: Confidential, private, and respectful physical assessment by a trained health professional.\n- Laboratory tests: Blood tests (for Syphilis, HIV, Hepatitis B), urine samples, and swabs from fluid or sores.\n- National syndromic management: In primary health clinics across Ethiopia, healthcare workers follow national guidelines to treat symptoms immediately on the first visit without waiting days for lab results.\n\n> Clinical Tip: Youth-friendly centers provide completely confidential, stigma-free counseling, tests, and care for adolescents and youth.\n\n## Complications of STI\nSerious risks of leaving STIs untreated\n\nWhen left untreated or improperly treated, STIs can lead to severe and lasting health consequences:\n\n- Infertility & PID: Untreated chlamydia or gonorrhea can cause Pelvic Inflammatory Disease (PID) in women, leading to scarring of fallopian tubes, chronic pain, life-threatening ectopic pregnancy, or infertility. In men, it can cause painful epididymitis and infertility.\n- Higher HIV risk: Open genital sores and mucosal inflammation from STIs multiply the risk of contracting or transmitting HIV by 3 to 5 times.\n- Mother-to-child transmission: Pregnant mothers with untreated STIs can pass infections to their babies, leading to miscarriage, stillbirth, premature birth, low birth weight, and newborn eye infections.\n- Cervical & other cancers: Persistent infections with high-risk HPV strains are the primary cause of cervical cancer in women.\n\n> Clinical Tip: Early clinical treatment prevents pelvic inflammatory disease and preserves lifelong reproductive capacity.\n\n## Management and treatment of STI\nMedical therapies and critical rules for recovery\n\nBacterial and parasitic STIs (Chlamydia, Gonorrhea, Syphilis, Trichomoniasis) are fully curable with specific prescription antibiotics or antiparasitics.\n\nViral STIs (Herpes, HPV, HIV, Hepatitis B) cannot be cured with antibiotics, but modern antiviral medications effectively manage symptoms, reduce recurrences, and prevent complications.\n\n- Finish all medication: Always complete the full prescribed course, even if symptoms vanish early. Incomplete treatment creates antibiotic-resistant strains.\n- Treat sexual partners simultaneously: Both partners must receive treatment at the same time to prevent passing the infection back and forth (ping-pong effect).\n- Abstain during treatment: Refrain from all sexual intercourse until both partners finish all medicines and clinical symptoms are completely gone.\n- Never self-medicate: Do not take leftover pills or buy random antibiotics from pharmacies without a medical diagnosis, as wrong medications can make infections worse.\n\n> Clinical Tip: Always complete the full course of prescribed antibiotics, even if all physical symptoms disappear after 2 days.\n\n## Prevention of STI\nEffective ways to protect yourself and your partner\n\nProtecting yourself from STIs requires practical, consistent safe behaviors:\n\n- Consistent & correct condom use: Latex and polyurethane male and female condoms provide highly effective barrier protection against most STIs when used properly every single time.\n- Mutual fidelity: Being in a faithful relationship with one uninfected partner after both have been tested.\n- Abstinence: Choosing not to engage in sexual intercourse is the only 100% foolproof way to prevent STIs.\n- Vaccination: Vaccines against HPV (protects against cervical cancer) and Hepatitis B are safe, highly effective, and available.\n- Regular checkups & screening: Getting tested before starting a new sexual relationship and getting screened annually if sexually active.\n- Avoid alcohol and substance abuse: Intoxication impairs judgment and significantly reduces the use of protection.\n\n> Clinical Tip: Dual protection (correct condom usage combined with regular screening) is the most reliable strategy.",
    contentAm: "| ማስታወሻ: ደህንነቱ የተጠበቀ የግብረ ሥጋ ግንኙነት በማድረግ፣ አዘውትረው በመመርመር እና አስቀድመው የህክምና እርዳታ በማግኘት ራስዎን ይጠብቁ፤ የጤና ሁኔታዎን ማወቅ ችግሮችን ለመከላከል እና ሌሎችንም ለመጠበቅ ይረዳል።\n\n## ትርጓሜ\nበግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STIs) ምንድን ናቸው?\n\nበግብረ ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች (STIs) በዋነኝነት በግብረ ሥጋ ግንኙነት (በሴት ብልት፣ በአፍ ወይም በፊንጢጣ) ከአንድ ሰው ወደ ሌላ ሰው የሚተላለፉ ኢንፌክሽኖች ናቸው። እነዚህም በባክቴሪያ፣ በቫይረስ ወይም በጥገኛ ተውሳኮች የሚከሰቱ ናቸው።\n\n- የተለመዱ የባክቴሪያ STIs ክላሚዲያ፣ ጨብጥ (ጎኖርያ) እና ቂጥኝ (ሲፊሊስ) ናቸው። የተለመዱ የቫይረስ STIs ደግሞ የሰው ፓፒሎማቫይረስ (HPV)፣ ሄርፒስ (HSV)፣ ሄፓታይተስ ቢ እና ኤችአይቪ ናቸው። የተለመደው የጥገኛ ተውሳክ ኢንፌክሽን ትሪኮሞኒያሲስ ነው።\n- ብዙ ሰዎች የኢንፌክሽን እና የበሽታ ልዩነትን ይደባለቃሉ። ኢንፌክሽን (STI) በሽታ አምጪው በሰውነት ውስጥ መኖሩን የሚያመለክት ሲሆን ብዙውን ጊዜ ምንም የሚታይ ምልክት አያሳይም። ኢንፌክሽኑ የሕመም ምልክቶች ወይም የሰውነት ጉዳት ሲያስከትል ወደ በሽታነት (STD) ይቀየራል። ብዙ STIs ድምፅ-አልባ ቢሆኑም ወደ ሌሎች ሊተላለፉ ይችላሉ።\n\n> የዶክተር ማስታወሻ: ኢንፌክሽን ማለት በሰውነት ውስጥ የበሽታ አምጪ ተህዋስያን መኖር ሲሆን ብዙ ጊዜ ምንም ምልክት ላያሳይ ይችላል።\n\n## የ STI ምልክቶች\nየተለመዱ ምልክቶች እና ምልክት አልባ ሁኔታዎች\n\nምልክቶቹ እንደ ኢንፌክሽኑ ዓይነት እና እንደ ጾታ ሊለያዩ ይችላሉ፣ ነገር ግን በብዛት የሚከተሉትን ያካትታሉ፦\n\n- ያልተለመደ ፈሳሽ፦ ከብልት ወይም ከፊንጢጣ የሚወጣ ወፍራም፣ ቀጭን፣ ቢጫ፣ አረንጓዴ ወይም መጥፎ ጠረን ያለው ፈሳሽ።\n- የሕመም ወይም የማቃጠል ስሜት፦ በሽንት ወይም በግብረ ሥጋ ግንኙነት ወቅት የሚሰማ የማቃጠል ወይም የሕመም ስሜት።\n- ቁስለት፣ እብጠት ወይም ኪንታሮት፦ በብልት፣ በጉሮሮ፣ በአፍ ወይም በፊንጢጣ ዙሪያ የሚታዩ የሚያሳምሙ ወይም የማያሳምሙ ቁስሎች፣ አረፋዎች ወይም እብጠቶች።\n- ማሳከክ እና መቅላት፦ በብልት እና በዙሪያው አካባቢ የሚሰማ የማያቋርጥ ማሳከክ፣ መቅላት ወይም እብጠት።\n- የሆድ ወይም የወገብ ሕመም፦ የታችኛው የሆድ ክፍል ሕመም፣ የወር አበባ ባልሆነ ጊዜ የሚታይ ደም መፍሰስ፣ ወይም ከግንኙነት በኋላ ደም መፍሰስ።\n\n> የዶክተር ማስታወሻ: ድምፅ-አልባ ኢንፌክሽኖች፦ እስከ 70% የሚሆኑ ሴቶች እና ብዙ ወንዶች በክላሚዲያ ወይም በጨብጥ ሲያዙ ምንም ዓይነት የሚታይ ምልክት አያሳዩም። ትክክለኛውን ሁኔታ ለማወቅ ክሊኒካዊ ምርመራ ብቸኛው መንገድ ነው።\n\n## የ STI ምርመራ\nየጤና ባለሙያዎች STIን እንዴት ይመረምራሉ\n\nቀደም ብሎ መመርመር ፈጣን ፈውስን ያረጋግጣል እና ዘላቂ የመራቢያ አካላት ጉዳትን ይከላከላል። የጤና ባለሙያዎች የሚከተሉትን ይጠቀማሉ፦\n\n- ክሊኒካዊ የአካል ምርመራ፦ በሰለጠነ የጤና ባለሙያ የሚደረግ ሚስጥራዊ እና አክብሮት የተሞላበት የአካል ምርመራ።\n- የላቦራቶሪ ምርመራዎች፦ የደም ምርመራ (ለቂጥኝ፣ ኤችአይቪ፣ ሄፓታይተስ ቢ)፣ የሽንት ናሙና፣ እና ከፈሳሽ ወይም ከቁስለት የሚወሰድ ናሙና።\n- የህመም ምልክት ተኮር አያያዝ (ሲንድሮሚክ ማኔጅመንት)፦ በኢትዮጵያ የመጀመሪያ ደረጃ ጤና ጣቢያዎች የጤና ባለሙያዎች የላቦራቶሪ ውጤቶችን ለቀናት ሳይጠብቁ በምልክቶች ላይ ተመስርተው በመጀመሪያው ቀን ህክምና ይሰጣሉ።\n\n> የዶክተር ማስታወሻ: ለወጣቶች ምቹ የሆኑ የጤና ማዕከላት ፍጹም ሚስጥራዊ እና ከስጋት ነጻ የሆነ የምክር፣ የምርመራ እና የእንክብካቤ አገልግሎት ይሰጣሉ።\n\n## የ STI ውስብስብ የጤና ችግሮች\nያልታከሙ የ STI ኢንፌክሽኖች የሚያስከትሉት ከባድ አደጋዎች\n\nSTIs ሳይታከሙ ወይም በአግባቡ ሳይታከሙ ሲቀሩ ከባድ እና ዘላቂ የጤና ችግሮችን ያስከትላሉ፦\n\n- መሃንነት እና የዳሌ እብጠት (PID)፦ ያልታከመ ክላሚዲያ ወይም ጨብጥ በሴቶች ላይ የማህፀን ቱቦ ጠባሳን እና መካንነትን ያስከትላል፤ በወንዶች ላይም የዘር ፍሬ እብጠት እና መካንነት ያመጣል።\n- ከፍተኛ የኤችአይቪ ተጋላጭነት፦ በብልት ላይ ያሉ ቁስሎች እና እብጠቶች በኤችአይቪ የመያዝ ወይም የማስተላለፍ እድልን ከ3 እስከ 5 እጥፍ ይጨምራሉ።\n- ከእናት ወደ ልጅ መተላለፍ፦ ነፍሰጡር እናቶች ያልታከመ STI ካለባቸው ኢንፌክሽኑን ወደ ልጃቸው ሊያስተላልፉ ይችላሉ፤ ይህም ውርጃ፣ የሞተ ልጅ መወለድ፣ ያለጊዜው መወለድ እና የጨቅላ ሕጻናት የአይን ኢንፌክሽን ሊያስከትል ይችላል።\n- የማህፀን በር ካንሰር፦ ከፍተኛ ተጋላጭነት ባላቸው የ HPV ዝርያዎች የሚከሰቱ ዘላቂ ኢንፌክሽኖች ለሴቶች የማህፀን በር ካንሰር ዋነኛ መንስኤ ናቸው።\n\n> የዶክተር ማስታወሻ: ቀደም ብሎ የሚደረግ የህክምና ክትትል የረጅም ጊዜ የመካንነት ችግሮችንና ውስብስብ በሽታዎችን ይከላከላል።\n\n## የ STI አያያዝ እና ሕክምና\nየሕክምና ዘዴዎች እና ለማገገም አስፈላጊ መመሪያዎች\n\nየባክቴሪያ እና የጥገኛ ተውሳክ STIs (ክላሚዲያ፣ ጨብጥ፣ ቂጥኝ፣ ትሪኮሞኒያሲስ) በታዘዙ አንቲባዮቲኮች ሙሉ በሙሉ ይድናሉ።\n\nየቫይረስ STIs (ሄርፒስ፣ HPV፣ ኤችአይቪ፣ ሄፓታይተስ ቢ) በአንቲባዮቲክስ አይድኑም፤ ነገር ግን ዘመናዊ የፀረ-ቫይረስ መድሃኒቶች ምልክቶችን ለመቆጣጠር እና ችግሮችን ለመከላከል ይረዳሉ።\n\n- ሁሉንም መድሃኒቶች ጨርሰው ይውሰዱ፦ ምልክቶቹ ቀድመው ቢጠፉም እንኳ የታዘዘውን ሙሉ መድሃኒት ይጨርሱ። መድሃኒት አለመጨረስ ባክቴሪያዎች መድሃኒትን እንዲላመዱ ያደርጋል።\n- የፍቅር አጋርዎን አብረው ያሳክሙ፦ በሽታው እርስ በእርስ እንዳይተላለፍ ሁለቱም አጋሮች በአንድ ጊዜ ህክምና ማግኘት አለባቸው።\n- በህክምና ወቅት ግንኙነት አያድርጉ፦ ሁለቱም አጋሮች መድሃኒቱን ጨርሰው ምልክቶች ሙሉ በሙሉ እስኪጠፉ ድረስ ከግብረ ሥጋ ግንኙነት ይቆጠቡ።\n- በራስዎ መድሃኒት አይውሰዱ፦ ያለ ሐኪም ትዕዛዝ ከተለመዱ ፋርማሲዎች መድሃኒት ገዝተው አይውሰዱ፤ የተሳሳተ መድሃኒት በሽታውን ሊያባብሰው ይችላል።\n\n> የዶክተር ማስታወሻ: ምልክቶች ቢጠፉም እንኳ የታዘዘልዎትን አንቲባዮቲክስ መድኃኒት ሙሉ በሙሉ ጨርሰው ይውሰዱ።\n\n## የ STI መከላከያ መንገዶች\nራስን እና የፍቅር አጋርን ለመጠበቅ የሚረዱ ተግባራዊ መንገዶች\n\nከ STIs ራስን ለመጠበቅ ተግባራዊ እና ቀጣይነት ያላቸው ጥንቃቄዎችን ማድረግ ያስፈልጋል፦\n\n- ኮንዶምን ዘወትርና በትክክል መጠቀም፦ የላቴክስ እና የፖሊዩረቴን የወንድ እና የሴት ኮንዶሞች በትክክል ጥቅም ላይ ሲውሉ ከብዙዎቹ STIs ከፍተኛ ጥበቃ ያደርጋሉ።\n- የጋራ ታማኝነት፦ ሁለቱም ከተመረመሩ በኋላ ላልተያዘ አንድ የፍቅር አጋር ብቻ ታማኝ መሆን።\n- ከግንኙነት መታቀብ፦ ከግብረ ሥጋ ግንኙነት መታቀብ ከ STIs ለመጠበቅ 100% አስተማማኝ ብቸኛው መንገድ ነው።\n- ክትባት መከተብ፦ የማህፀን በር ካንሰርን የሚከላከለው የ HPV ክትባት እና የሄፓታይተስ ቢ ክትባቶች ደህንነታቸው የተጠበቀና ውጤታማ ናቸው።\n- መደበኛ ምርመራ ማድረግ፦ አዲስ ግንኙነት ከመጀመርዎ በፊት እና በግብረ ሥጋ ግንኙነት ንቁ ከሆኑ በየዓመቱ መመርመር።\n- ከአልኮል እና ከአደንዛዥ ዕፅ መራቅ፦ ስካር ውሳኔ የመስጠት አቅምን ስለሚያዳክም ጥንቃቄ የጎደለው ግንኙነት ውስጥ የመግባት እድልን ይጨምራል።\n\n> የዶክተር ማስታወሻ: ኮንዶምን በአግባቡ መጠቀም እና መደበኛ ምርመራ ማድረግ ከኢንፌክሽኖች ራስን ለመጠበቅ ፍቱን መንገዶች ናቸው።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "Many sexually transmitted infections (STIs) may show no noticeable symptoms at first, which is why regular screening and testing are essential.",
            "questionAm": "ብዙ በግብረ-ሥጋ ግንኙነት የሚተላለፉ ኢንፌክሽኖች መጀመሪያ ላይ ምንም ምልክት ላያሳዩ ስለሚችሉ መደበኛ ምርመራ ማድረግ አስፈላጊ ነው።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Asymptomatic infections are common with STIs like chlamydia and gonorrhea. Regular testing allows prompt treatment before complications occur.",
            "explanationAm": "እንደ ክላሚዲያ እና ጨብጥ ያሉ ኢንፌክሽኖች ብዙ ጊዜ ምልክት አያሳዩም፤ መደበኛ ምርመራ ማድረግ ችግሮች ሳይፈጠሩ ቀድሞ ለማከም ይረዳል።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Which of the following is an effective method for reducing the risk of transmitting most STIs during sexual activity?",
            "questionAm": "በግብረ-ሥጋ ግንኙነት ወቅት የአባላዘር በሽታዎችን የመተላለፍ እድል በከፍተኛ ደረጃ የሚቀንሰው የትኛው ነው?",
            "optionsEn": [
                "Consistent and correct use of male or female condoms",
                "Taking vitamins immediately before contact",
                "Washing with hot water after intercourse only",
                "Relying on herbal teas"
            ],
            "optionsAm": [
                "ኮንዶምን በአግባቡ እና ዘወትር መጠቀም",
                "ከግንኙነት በፊት ቫይታሚን መውሰድ",
                "ከግንኙነት በኋላ በሙቅ ውሃ ብቻ መታጠብ",
                "የባህል ሻይ መጠጣት"
            ],
            "correctIndex": 0,
            "explanationEn": "Condoms provide a physical barrier that drastically lowers the risk of STI transmission when used correctly every time.",
            "explanationAm": "ኮንዶምን በአግባቡና በተከታታይ መጠቀም የአባላዘር ኢንፌክሽኖች እንዳይተላለፉ አስተማማኝ መከላከያ ይሆናል።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "If you test positive for a bacterial STI and start antibiotics, what is the most important instruction to follow?",
            "questionAm": "በአባላዘር በሽታ ተይዘው ፀረ-ባክቴሪያ (አንቲባዮቲክ) መድኃኒት ከታዘዘልዎት መከተል ያለብዎት ዋነኛ መመሪያ የትኛው ነው?",
            "optionsEn": [
                "Complete the entire course of medication as prescribed by the healthcare worker",
                "Stop medication the moment pain disappears",
                "Share the remaining pills with friends",
                "Double the dose on the final day"
            ],
            "optionsAm": [
                "በጤና ባለሙያው የታዘዘውን ሙሉ የመድኃኒት መጠን ሳይቋርጡ መጨረስ",
                "ህመሙ ልክ ሲጠፋ መድኃኒቱን ወዲያው ማቆም",
                "የቀረውን መድኃኒት ለጓደኛ ማጋራት",
                "በመጨረሻው ቀን እጥፍ መጠን መውሰድ"
            ],
            "correctIndex": 0,
            "explanationEn": "Stopping antibiotics early can lead to bacterial resistance and reinfection. Always complete the entire prescribed treatment course.",
            "explanationAm": "መድኃኒትን ቀድሞ ማቆም ባክቴሪያው መድኃኒቱን እንዲላመድ እና በሽታው ተመልሶ እንዲመጣ ያደርጋል፤ ሙሉ መጠኑን መጨረስ ግድ ነው።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "When someone is diagnosed and treated for an STI, it is vital that sexual partners are also notified and treated to prevent reinfection.",
            "questionAm": "አንድ ሰው በአባላዘር በሽታ ተመርምሮ ሲታከም በሽታው እንዳይደጋገም የፍቅር አጋሩም አብሮ መታከም አለበት።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Treating partners simultaneously breaks the cycle of transmission and protects both individuals from repeated health complications.",
            "explanationAm": "አጋርን አብሮ ማከም ኢንፌክሽኑ ተመልሶ እንዳይተላለፍ እና ዘላቂ ጤና እንዲኖር ያደርጋል።"
        }
    ],
  },
  {
    id: "module-03",
    nameEn: "Hepatitis",
    nameAm: "የጉበት በሽታ (ሄፓታይተስ)",
    category: "hepatitis",
    imageAsset: "module_03_hepatitis.png",
    readTimeMin: 4,
    authorName: "Gondar Youth Health Taskforce",
    titleEn: "Hepatitis",
    titleAm: "የጉበት በሽታ (ሄፓታይተስ)",
    summaryEn: "Hepatitis is inflammation of the liver caused by viruses or other factors, often showing mild or no symptoms but potentially leading to serious complications like cirrhosis, liver failure, or cancer if untreated; early diagnosis and proper management are essential.",
    summaryAm: "ሄፓታይተስ በቫይረሶች ወይም በሌሎች ምክንያቶች የሚከሰት የጉበት እብጠት ሲሆን ብዙውን ጊዜ ቀላል ወይም ምንም ምልክት አያሳይም፤ ነገር ግን ካልታከመ ወደ ጉበት ጠባሳ (ሲሮሲስ)፣ የጉበት ሥራ ማቆም ወይም የጉበት ካንሰር ሊያመራ ይችላል። ቅድመ ምርመራ እና ተገቢ ህክምና ወሳኝ ናቸው።",
    doctorNoteEn: "Hepatitis can be prevented and managed—practice good hygiene, avoid risky behaviors, get vaccinated where possible, and seek early testing to protect your liver health.",
    doctorNoteAm: "ሄፓታይተስ መከላከል እና ማከም የሚቻል ነው—ጥሩ ንፅህናን መጠበቅ፣ አደገኛ ልማዶችን ማስወገድ፣ በተቻለ መጠን መከተብ እና የጉበት ጤናዎን ለመጠበቅ ቀድመው መመርመር ይመከራል።",
    contentEn: "| Note: Hepatitis can be prevented and managed—practice good hygiene, avoid risky behaviors, get vaccinated where possible, and seek early testing to protect your liver health.\n\n## Definition\nHepatitis is a general term used to describe inflammation of the liver. Liver inflammation can be caused by several viruses (viral hepatitis), chemicals, drugs, alcohol, certain genetic disorders or by an overactive immune system that mistakenly attacks the liver, called autoimmune hepatitis.\n\n- There are several types of hepatitis, which are categorized as viral hepatitis and non-viral hepatitis. The most common types of viral hepatitis are A, B, C, D, and E. Then there are non-viral causes of hepatitis, such as autoimmune hepatitis, alcoholic hepatitis, and drug-induced hepatitis.\n\n> Clinical Tip: The liver performs essential detox, metabolism, and protein synthesis functions. Preventing viral damage protects your health.\n\n## Sign and symptoms of Hepatitis\nMany people with hepatitis A, B, C, D or E exhibit only mild symptoms or no symptoms at all. Each form of the virus, however, can cause more severe symptoms. Symptoms of hepatitis A, B and C may include: -\n\nHepatitis B: Hepatitis B is a viral infection that affects the liver, caused by the Hepatitis B virus (HBV). It can range from a mild illness to a serious, long-term (chronic) condition that can lead to liver cirrhosis, liver failure, or liver cancer.\n\nHepatitis C: Hepatitis C is a viral infection caused by the Hepatitis C virus (HCV), primarily affecting the liver. It is most commonly spread through blood-to-blood contact, often through:\n\n- fever\n- malaise\n- loss of appetite\n- diarrhea\n- nausea\n- abdominal discomfort\n- dark-colored urine and jaundice (a yellowing of the skin and whites of the eyes).\n- Hepatitis B: Unprotected sexual contact\n- Sharing needles or other drug paraphernalia\n- From an infected mother to her newborn during childbirth\n- Hepatitis C: Sharing needles or other drug equipment\n- Receiving contaminated blood products (though this is less common now due to screening)\n\n> Clinical Tip: Hepatitis B is preventable with a vaccine, but it has no cure.\n\n## Diagnosis of Hepatitis\nThe diagnosis of hepatitis involves a combination of blood tests, imaging, and sometimes liver biopsy to determine the cause, severity, and appropriate treatment of the disease. Each type of hepatitis has its own set of diagnostic markers, so identifying the specific cause is essential for effective management.\n\n- Blood test detecting hepatitis surface antigens and antibodies (HBsAg, Anti-HCV).\n- Liver function enzyme tests (ALT, AST, Bilirubin) to assess hepatic inflammation.\n\n> Clinical Tip: Early diagnosis through screening at campus health centers allows prompt monitoring before irreversible liver damage occurs.\n\n## Complication of Hepatitis\nComplications of hepatitis can vary depending on the type (A, B, C, etc.), the severity of the infection, and whether it becomes chronic. Some common and serious complications include:\n\n- Chronic Hepatitis: Chronic Hepatitis B and C: If untreated, viral hepatitis can progress to chronic infection, where the virus remains in the body for years, leading to ongoing liver inflammation.\n- Cirrhosis: Liver Scarring: Long-term inflammation can cause cirrhosis, a condition where the liver tissue becomes scarred, impairing liver function. This can result from chronic Hepatitis B, C, or alcohol use.\n- Liver Failure: Acute or Chronic Liver Failure: Severe liver damage can lead to liver failure, where the liver loses its ability to perform vital functions such as detoxification and protein production. It can occur acutely (e.g., in acute Hepatitis B or D) or chronically in cases of Hepatitis C.\n- Liver Cancer (Hepatocellular Carcinoma): Chronic Hepatitis B and C increase the risk of developing liver cancer over time due to ongoing liver cell damage and mutations.\n\n> Clinical Tip: Early diagnosis and management of hepatitis, particularly chronic forms, are key to preventing or managing these complications.\n\n## Management and treatment of Hepatitis\nThe treatment of hepatitis varies based on its type and severity. While many forms (especially Hepatitis A and E) resolve on their own with supportive care, others (like Hepatitis B, C, and chronic conditions) require long-term management with antiviral drugs, lifestyle changes, or immunosuppressive therapies. Early diagnosis and appropriate treatment are key to preventing liver damage and complications such as cirrhosis and liver cancer.\n\n- Supportive care: Rest, hydration, and avoiding hepatotoxic substances (alcohol, unnecessary drugs).\n- Antiviral medication: Daily therapy for chronic Hepatitis B to suppress viral replication.\n- Treatment has evolved significantly, with direct-acting antivirals (DAAs) offering a high cure rate, making chronic Hepatitis C much more manageable now than in the past.\n\n> Clinical Tip: Direct-Acting Antivirals (DAA) cure over 95% of Hepatitis C patients within 8 to 12 weeks of treatment.\n\n## Prevention Of Hepatitis\nGeneral Preventive Measures for All Types of Hepatitis\n\n- Good Hygiene Practices: Wash hands thoroughly with soap and water after using the bathroom, handling food, and before eating.\n- Avoid alcohol and drugs: Excessive alcohol use and drug abuse can exacerbate liver damage.\n- Vaccination: Vaccines against Hepatitis A and Hepatitis B are safe, highly effective, and available.\n- Safe needles & blood screening: Always use sterile single-use needles and ensure medical blood products are rigorously screened.\n\n> Clinical Tip: The safe and highly effective Hepatitis B vaccine provides lifelong immunity. Check your immunization status today.",
    contentAm: "| ማስታወሻ: ሄፓታይተስ መከላከል እና ማከም የሚቻል ነው—ጥሩ ንፅህናን መጠበቅ፣ አደገኛ ልማዶችን ማስወገድ፣ በተቻለ መጠን መከተብ እና የጉበት ጤናዎን ለመጠበቅ ቀድመው መመርመር ይመከራል።\n\n## ትርጓሜ (Definition)\nሄፓታይተስ የጉበት እብጠትን ለመግለጽ የሚያገለግል አጠቃላይ የህክምና ቃል ነው። የጉበት እብጠት በተለያዩ ቫይረሶች (ቫይራል ሄፓታይተስ)፣ በኬሚካሎች፣ በመድሃኒቶች፣ በአልኮል፣ በአንዳንድ የዘረመል ችግሮች ወይም የበሽታ መከላከያ ስርዓታችን ጉበትን በስህተት በማጥቃቱ (ኦቶኢሚውን ሄፓታይተስ) ሊከሰት ይችላል።\n\n- ሄፓታይተስ በቫይረስ እና በቫይረስ ባልሆኑ ምክንያቶች የሚከፈልባቸው በርካታ ዓይነቶች አሉት። በጣም የተለመዱት የቫይረስ ሄፓታይተስ ዓይነቶች A, B, C, D እና E ናቸው። በቫይረስ ምክንያት የማይከሰቱት ደግሞ ኦቶኢሚውን ሄፓታይተስ፣ በአልኮል የሚመጣ ሄፓታይተስ እና በመድሃኒት የሚመጣ ሄፓታይተስ ናቸው።\n\n> የዶክተር ማስታወሻ: ጉበት ለሰውነታችን መርዛማ ነገሮችን በማጣራትና በምግብ መፈጨት ውስጥ ወሳኝ ሚና ይጫወታል።\n\n## የሄፓታይተስ ምልክቶች (Sign and symptoms of Hepatitis)\nበሄፓታይተስ A, B, C, D ወይም E የተያዙ ብዙ ሰዎች ቀላል ምልክቶች ብቻ ያሳያሉ ወይም ምንም ዓይነት ምልክት ላያሳዩ ይችላሉ። ይሁን እንጂ እያንዳንዱ የቫይረስ ዓይነት የከፋ ምልክቶችን ሊያስከትል ይችላል። የሄፓታይተስ A, B እና C ምልክቶች የሚከተሉትን ሊያካትቱ ይችላሉ፦\n\nሄፓታይተስ ቢ (Hepatitis B): ሄፓታይተስ ቢ በሄፓታይተስ ቢ ቫይረስ (HBV) የሚከሰት እና ጉበትን የሚያጠቃ የቫይረስ ኢንፌክሽን ነው። ከቀላል ህመም እስከ ከባድና ሥር የሰደደ የጉበት ጠባሳ (ሲሮሲስ)፣ የጉበት ሥራ ማቆም ወይም የጉበት ካንሰር ሊያደርስ ይችላል።\n\nሄፓታይተስ ሲ (Hepatitis C): ሄፓታይተስ ሲ በሄፓታይተስ ሲ ቫይረስ (HCV) የሚከሰት እና በዋናነት ጉበትን የሚያጠቃ የቫይረስ ኢንፌክሽን ነው። በብዛት የሚተላለፈው በደም ንክኪ ሲሆን በዋናነት፦\n\n- ትኩሳት\n- የአካል ድካም እና መዛል\n- የምግብ ፍላጎት መቀነስ\n- ተቅማጥ\n- የማቅለሽለሽ ስሜት\n- የሆድ ህመም እና አለመመቸት\n- የሽንት ቀለም መጥቆር እና የአይን ወይም የቆዳ ቢጫ መሆን (Jaundice)\n- ሄፓታይተስ ቢ (Hepatitis B): ያልተጠበቀ የግብረ-ሥጋ ግንኙነት\n- መርፌዎችን ወይም ሌሎች የዕፅ መርፌ መሳሪያዎችን በጋራ መጠቀም\n- በወሊድ ወቅት በቫይረሱ ከተያዘች እናት ወደ አዲስ ለተወለደው ህፃን\n- ሄፓታይተስ ሲ (Hepatitis C): መርፌዎችን ወይም የዕፅ መጠቀሚያ መሳሪያዎችን በጋራ መጠቀም\n- የተበከሉ የደም ውጤቶችን መውሰድ (ምንም እንኳን አሁን ላይ በምርመራ ምክንያት ይህ አነስተኛ ቢሆንም)\n\n> የዶክተር ማስታወሻ: ሄፓታይተስ ቢ በክትባት መከላከል የሚቻል ሲሆን ነገር ግን እስካሁን ፍቱን ፈውስ የለውም።\n\n## የሄፓታይተስ ምርመራ (Diagnosis of Hepatitis)\nየሄፓታይተስ ምርመራ የበሽታውን መንስኤ፣ ክብደት እና ተገቢውን ህክምና ለመወሰን የደም ምርመራዎችን፣ የምስል (imaging) ምርመራዎችን እና አንዳንዴም የጉበት ባዮፕሲን (biopsy) ማጣመርን ያካትታል። እያንዳንዱ የሄፓታይተስ ዓይነት የራሱ የሆነ የመመርመሪያ ምልክት ስላለው፣ ትክክለኛውን መንስኤ ለይቶ ማወቅ ውጤታማ ህክምና ለመስጠት ወሳኝ ነው።\n\n- የደም ምርመራ የቫይረሱን አንቲጂን እና አንቲቦዲ በመለየት የጉበት ጤንነትን ያረጋግጣል።\n- የጉበት ኢንዛይም ምርመራዎች (ALT, AST) የጉበትን ጤናማ አሰራር ለመከታተል ያገለግላሉ።\n\n> የዶክተር ማስታወሻ: ቀድሞ የሚደረግ የደም ምርመራ ቫይረሱ ጉበትን ከመጉዳቱ በፊት ተገቢውን ክትትል ለማድረግ ይረዳል።\n\n## የሄፓታይተስ ችግሮች (Complication of Hepatitis)\nየሄፓታይተስ ችግሮች እንደ ዓይነቱ (A, B, C, ወዘተ)፣ እንደ ኢንፌክሽኑ ክብደት እና ሥር የሰደደ መሆን አለመሆኑ ሊለያዩ ይችላሉ። አንዳንድ የተለመዱ እና ከባድ ችግሮች የሚከተሉትን ያካትታሉ፦\n\n- ሥር የሰደደ ሄፓታይተስ (Chronic Hepatitis): ሥር የሰደደ ሄፓታይተስ ቢ እና ሲ፦ ካልታከመ የቫይረስ ሄፓታይተስ ወደ ሥር የሰደደ ኢንፌክሽን ሊሸጋገር ይችላል፤ ይህም ቫይረሱ በሰውነት ውስጥ ለዓመታት እንዲቆይ በማድረግ ቀጣይነት ያለው የጉበት እብጠት ያስከትላል።\n- ሲሮሲስ (Cirrhosis): የጉበት ጠባሳ፦ የረጅም ጊዜ እብጠት ወደ ሲሮሲስ ሊያመራ ይችላል፤ ይህም የጉበት ህዋስ በጠባሳ የሚሸፈንበትና የጉበትን ተግባር የሚያውክ ሁኔታ ነው። ይህ ከሥር የሰደደ ሄፓታይተስ ቢ፣ ሲ ወይም ከአልኮል አጠቃቀም ሊመነጭ ይችላል።\n- የጉበት ሥራ ማቆም (Liver Failure): አጣዳፊ ወይም ሥር የሰደደ የጉበት ሥራ ማቆም፦ ከባድ የጉበት ጉዳት ጉበቱ እንደ መርዛማ ንጥረ ነገሮችን ማጣራት እና ፕሮቲን ማምረት ያሉ ወሳኝ ተግባራትን ወደሚያጣበት የጉበት ሥራ ማቆም ደረጃ ሊያደርስ ይችላል። ይህ በድንገት (ለምሳሌ በድንገተኛ ሄፓታይተስ ቢ ወይም ዲ) ወይም በሄፓታይተስ ሲ ምክንያት በረጅም ጊዜ ሂደት ሊከሰት ይችላል።\n- የጉበት ካንሰር (Hepatocellular Carcinoma): ሥር የሰደደ ሄፓታይተስ ቢ እና ሲ ቀጣይነት ባለው የጉበት ህዋሳት ጉዳት እና ለውጥ ምክንያት በጊዜ ሂደት የጉበት ካንሰር የመከሰት እድልን ይጨምራሉ።\n\n> የዶክተር ማስታወሻ: ቀደም ብሎ ማወቅ እና የሄፓታይተስ አያያዝ፣ በተለይም ሥር የሰደዱትን ዓይነቶች፣ እነዚህን ችግሮች ለመከላከል ወይም ለመቆጣጠር ቁልፍ ናቸው።\n\n## የሄፓታይተስ አያያዝ እና ህክምና (Management and treatment of Hepatitis)\nየሄፓታይተስ ህክምና እንደየዓይነቱ እና ክብደቱ ይለያያል። ብዙዎቹ ዓይነቶች (በተለይም ሄፓታይተስ ኤ እና ኢ) በደጋፊ እንክብካቤ በራሳቸው ጊዜ የሚድኑ ሲሆኑ፣ ሌሎች ደግሞ (እንደ ሄፓታይተስ ቢ፣ ሲ እና ሥር የሰደዱ ሁኔታዎች) በፀረ-ቫይረስ መድሃኒቶች፣ በአኗኗር ለውጦች ወይም በበሽታ መከላከያ አፋኝ ህክምናዎች የረጅም ጊዜ ክትትል ያስፈልጋቸዋል። ቀደም ብሎ ማወቅ እና ተገቢ ህክምና ማግኘት የጉበት ጉዳትን እንዲሁም እንደ ሲሮሲስ እና የጉበት ካንሰር ያሉ ችግሮችን ለመከላከል ቁልፍ ናቸው።\n\n- የድጋፍ እንክብካቤ፡ በቂ እረፍት፣ ውሃ መጠጣት እና ጉበትን የሚጎዱ ነገሮችን (አልኮል) ማስወገድ።\n- የፀረ-ቫይረስ መድኃኒቶች፡ ለከባድ የሄፓታይተስ ቢ ህመምተኞች የቫይረሱን ስርጭት የሚቆጣጠሩ መድኃኒቶች።\n- ህክምናው በከፍተኛ ደረጃ የተሻሻለ ሲሆን፣ በቀጥታ የሚሰሩ የፀረ-ቫይረስ መድሃኒቶች (DAAs) ከፍተኛ የመዳን እድል ይሰጣሉ፤ ይህም ሥር የሰደደ ሄፓታይተስ ሲን ከቀድሞው የበለጠ በቀላሉ ማከም የሚቻል አድርጎታል።\n\n> የዶክተር ማስታወሻ: ዘመናዊ የሄፓታይተስ ሲ መድኃኒቶች ከ95% በላይ የሚሆኑ ህመምተኞችን በጥቂት ሳምንታት ውስጥ ሙሉ በሙሉ ያድናሉ።\n\n## ሄፓታይተስን መከላከል (Prevention Of Hepatitis)\nለሁሉም ዓይነት ሄፓታይተስ አጠቃላይ የመከላከያ እርምጃዎች\n\n- ጥሩ የንፅህና አጠባበቅ፦ ሽንት ቤት ከተጠቀሙ በኋላ፣ ምግብ ከማዘጋጀት እና ከመመገብዎ በፊት እጅዎን በሳሙና እና በውሃ በደንብ ይታጠቡ።\n- ከአልኮል እና አደንዛዥ ዕፆች መራቅ፦ ከመጠን በላይ አልኮል እና አደንዛዥ ዕፆችን መጠቀም የጉበት ጉዳትን ያባብሳል።\n- ክትባት መከተብ፦ የሄፓታይተስ ኤ እና የሄፓታይተስ ቢ ክትባቶች ደህንነታቸው የተጠበቀና ውጤታማ ናቸው።\n- ንፁህ መርፌዎችን መጠቀም እና ደም መመርመር፦ ለአንድ ጊዜ ብቻ የሚያገለግሉ መርፌዎችን መጠቀም እና የደም ውጤቶች መመርመራቸውን ማረጋገጥ።\n\n> የዶክተር ማስታወሻ: የሄፓታይተስ ቢ ክትባት ፍጹም አስተማማኝና ዘላቂ መከላከያ ይሰጣል፤ የክትባት ሁኔታዎን ያረጋግጡ።",
    questions: [
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Hepatitis primarily affects which vital organ in the human body?",
            "questionAm": "ሄፓታይተስ በዋናነት የትኛውን የሰውነት ክፍል ያጠቃል?",
            "optionsEn": [
                "Liver",
                "Lungs",
                "Heart",
                "Kidneys"
            ],
            "optionsAm": [
                "ጉበት",
                "ሳንባ",
                "ልብ",
                "ኩላሊት"
            ],
            "correctIndex": 0,
            "explanationEn": "Hepatitis is an inflammation of the liver, which performs vital roles like filtering toxins, aiding digestion, and storing energy.",
            "explanationAm": "ሄፓታይተስ መርዞችን በማጣራት፣ ምግብ በማዋሃድና ሃይል በማከማቸት ወሳኝ የሆነውን ጉበት የሚያጠቃ እብጠት ነው።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Hepatitis A and Hepatitis E are primarily spread through contaminated food and water, making clean water and hand hygiene key defenses.",
            "questionAm": "ሄፓታይተስ ኤ እና ሄፓታይተስ ኢ በዋናነት በተበከለ ምግብ እና ውሃ ስለሚተላለፉ ንጹህ ውሃ መጠቀም እና እጅን መታጠብ ቁልፍ መከላከያ ናቸው።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Hepatitis A and E spread via the fecal-oral route. Thorough handwashing and safe drinking water effectively stop transmission.",
            "explanationAm": "ሄፓታይተስ ኤ እና ኢ በምግብ እና በውሃ ይተላለፋሉ፤ እጅን በአግባቡ መታጠብና ንጹህ ውሃ መጠቀም ስርጭቱን ይከላከላል።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Which safe and effective preventive measure protects against Hepatitis B infection?",
            "questionAm": "ከሄፓታይተስ ቢ ኢንፌክሽን በአስተማማኝ ሁኔታ የሚከላከል የትኛው ነው?",
            "optionsEn": [
                "Hepatitis B vaccination and screening",
                "Drinking caffeinated beverages",
                "Avoiding regular exercise",
                "Taking painkillers daily"
            ],
            "optionsAm": [
                "የሄፓታይተስ ቢ ክትባት መከተብ እና ምርመራ ማድረግ",
                "ካፌይን ያላቸውን መጠጦች አብዝቶ መጠጣት",
                "የሰውነት እንቅስቃሴ አለማድረግ",
                "የህመም ማስታገሻዎችን በየቀኑ መውሰድ"
            ],
            "correctIndex": 0,
            "explanationEn": "The Hepatitis B vaccine provides long-lasting immunity. Avoiding needle-sharing and safe sexual practices also prevent transmission.",
            "explanationAm": "የሄፓታይተስ ቢ ክትባት ዘላቂ የመከላከል አቅም ይሰጣል፤ ስለታማ ቁሳቁሶችን አለመጋራትም በሽታውን ይከላከላል።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Modern direct-acting antiviral (DAA) medications can successfully cure more than 95% of chronic Hepatitis C infections.",
            "questionAm": "ዘመናዊ የፀረ-ቫይረስ (DAA) መድኃኒቶች ከ95% በላይ የሚሆኑ የከፋ የሄፓታይተስ ሲ ታማሚዎችን ሙሉ በሙሉ ማዳን ይችላሉ።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Advances in medicine have made chronic Hepatitis C a curable condition with an oral medication course lasting 8 to 12 weeks.",
            "explanationAm": "የህክምና እድገት ሥር የሰደደውን ሄፓታይተስ ሲ በ8-12 ሳምንታት የጡባዊ መድኃኒት ሙሉ በሙሉ ሊድን የሚችል አድርጎታል።"
        }
    ],
  },
  {
    id: "module-04",
    nameEn: "Gender-based violence (GBV)",
    nameAm: "በጾታ ላይ የተመሰረተ ጥቃት (GBV)",
    category: "gbv",
    imageAsset: "module_04_gbv.png",
    readTimeMin: 4,
    authorName: "Safe Campus Legal & Youth Advocacy Team",
    titleEn: "Gender-based violence (GBV)",
    titleAm: "በጾታ ላይ የተመሰረተ ጥቃት (GBV)",
    summaryEn: "Gender-based violence is harmful behavior directed at individuals based on gender, caused by inequality and cultural norms, leading to serious physical, psychological, social, and economic consequences, but it can be addressed through prevention, support services, and legal protection.",
    summaryAm: "ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት በፆታ ላይ ተመስርቶ በሰዎች ላይ የሚደርስ ጎጂ ድርጊት ሲሆን፣ በእኩልነት ጉድለት እና በባህላዊ ልማዶች የሚመጣ፣ ለአካላዊ፣ ስነ-ልቦናዊ፣ ማህበራዊ እና ኢኮኖሚያዊ ጉዳቶች የሚዳርግ ነው፤ ሆኖም በመከላከል፣ በድጋፍ አገልግሎቶች እና በህጋዊ ጥበቃ መፍትሄ ሊያገኝ ይችላል።",
    doctorNoteEn: "GBV is preventable—promoting respect, equality, and early support for survivors helps build safer communities and protects human dignity.",
    doctorNoteAm: "ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት መከላከል ይቻላል—አክብሮትን፣ እኩልነትን እና ለተጎጂዎች ፈጣን ድጋፍ መስጠት ደህንነቱ የተጠበቀ ማህበረሰብ ለመገንባት እና የሰውን ክብር ለመጠበቅ ይረዳል።",
    contentEn: "| Note: GBV is preventable—promoting respect, equality, and early support for survivors helps build safer communities and protects human dignity.\n\n## Definition\nGender-based violence (GBV) refers to harmful acts directed at an individual based on their gender. It can occur in any context, but it most often affects women and girls, though men and boys can also experience it. GBV is a violation of human rights and a major barrier to achieving gender equality and social justice.\n\nIn humanitarian settings, responding to sexual violence has been a priority because conflict-related violence, in particular rape as a tactic of war, has received international attention. However, there is growing recognition that populations affected by conflict and natural disaster experience various forms of GBV during crisis and displacement, and during and following return. In particular, intimate partner violence is increasingly recognized as a critical concern in humanitarian settings. Gender based violence can manifest in various forms, including:\n\n- Physical Violence: Domestic violence (intimate partner violence): and Sexual violence:\n- Psychological/Emotional Violence: Verbal abuse:, Isolation:\n- Sexual Violence and Exploitation: Rape:, Sexual harassment:\n- Economic Violence: Withholding financial resources:, Coercion through financial dependence:\n- Harmful Traditional Practices: Female genital mutilation/cutting (FGM/C):, Early or forced marriage:\n\n> Clinical Tip: Violence is never the survivor’s fault. Everyone has an inalienable right to bodily safety and dignity.\n\n## Sex and Gender\nUnderstanding the distinction between sex and gender is essential for addressing gender-based violence. Sex refers to biological and physiological characteristics, such as chromosomes, hormones, and reproductive organs. Gender refers to the socially constructed roles, behaviors, expressions, and identities that society considers appropriate for men, women, and gender-diverse individuals.\n\nGender norms dictate how individuals are expected to act, speak, dress, and interact based on their assigned sex. When rigid patriarchal expectations grant unequal power, authority, or entitlement to one group over another, it creates a systemic imbalance that justifies or normalizes violence and discrimination.\n\n- Sex represents biological and physiological attributes determined by genetics.\n- Gender encompasses socially learned roles, behaviors, and expectations.\n- Unequal power relations rooted in rigid gender stereotypes fuel gender-based discrimination.\n\n> Clinical Tip: Promoting gender equality and dismantling harmful stereotypes is fundamental for safe university and community life.\n\n## Consequences of gender-based violence\nGender-based violence causes widespread, compounding physical, psychological, and social trauma:\n\n- Physical, injury, disability, chronic health problem, sexual and reproductive health problems, death\n- Psychological, anxiety, fear, loneliness depression, alcohol or drug use suicide\n- Economic and social impact, reduced ability to participate in social and economic activities, social stigma at community level, negative impact on women income generating power, increased vulnerability to other types of gender-based violence\n- The impact on women family and dependents, divorce, or broken families, jeopardize family's economic and emotional development, emotional and behavioral disturbances\n- Emotional Consequences, Depression stress, low self esteem\n\n> Clinical Tip: Survivors require comprehensive medical, legal, and psychosocial support to heal and regain their strength.\n\n## Management and Prevention of Gender-Based Violence (GBV)\nImmediate Response: Management of GBV\n\nWhen GBV occurs, immediate intervention is necessary to support survivors and address the situation.\n\n- Providing Safety and Protection: Safe spaces: (Shelters and crisis centers provide immediate refuge for survivors.)\n- Comprehensive Support Services: Psychosocial support: (Counseling and therapy to help survivors heal from trauma.)\n- Preventing GBV: Prevention strategies focus on addressing the root causes of violence and working toward a society where GBV is not tolerated.\n- Long-Term Strategies: Changing Structural and Cultural Factors: Long-term efforts are required to address the underlying social, cultural, and economic factors that sustain GBV.\n\n> Clinical Tip: If you or someone you know is experiencing violence or abuse, you are not alone. Safe, confidential medical and legal support is available. Call the national toll-free emergency lines 952, 8335, or 7711 immediately.",
    contentAm: "| ማስታወሻ: ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት መከላከል ይቻላል—አክብሮትን፣ እኩልነትን እና ለተጎጂዎች ፈጣን ድጋፍ መስጠት ደህንነቱ የተጠበቀ ማህበረሰብ ለመገንባት እና የሰውን ክብር ለመጠበቅ ይረዳል።\n\n## ትርጓሜ\nሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት (GBV) በአንድ ግለሰብ ፆታ ላይ ተመስርቶ የሚፈጸም ጎጂ ድርጊትን ያመለክታል። በየትኛውም ሁኔታ ውስጥ ሊከሰት ይችላል፣ ነገር ግን በአብዛኛው ሴቶችን እና ልጃገረዶችን ያጠቃል፣ ምንም እንኳን ወንዶችና ወንዶች ልጆችም ሊያጋጥማቸው ይችላል። GBV የሰብዓዊ መብት ጥሰት እና የፆታ እኩልነትን እንዲሁም ማህበራዊ ፍትህን ለማረጋገጥ ትልቅ እንቅፋት ነው።\n\nበሰብዓዊ ቀውሶች ወቅት ለፆታዊ ጥቃት ምላሽ መስጠት ቅድሚያ የሚሰጠው ጉዳይ ሆኖ ቆይቷል፤ ምክንያቱም ከግጭት ጋር የተያያዘ ጥቃት፣ በተለይም አስገድዶ መድፈር እንደ ጦርነት ስልት መጠቀሙ ዓለም አቀፍ ትኩረት አግኝቷል። ይሁን እንጂ በግጭት እና በተፈጥሮ አደጋ የተጎዱ ሰዎች በቀውስና በመፈናቀል ወቅት እንዲሁም ከተመለሱ በኋላ የተለያዩ የGBV ዓይነቶችን እንደሚያጋጥሟቸው ከጊዜ ወደ ጊዜ ግንዛቤው እያደገ መጥቷል። በተለይም በትዳር ወይም በፍቅር አጋር መካከል የሚፈጸም ጥቃት በሰብዓዊ ድጋፍ መስኮች እንደ ወሳኝ አሳሳቢ ጉዳይ እየታየ ነው። ሥርዓተ-ፆታን መሠረት ያደረገ ጥቃት በተለያዩ መንገዶች ሊገለጽ ይችላል፡-\n\n- አካላዊ ጥቃት: የቤት ውስጥ ጥቃት (የአጋር ጥቃት): እና ፆታዊ ጥቃት:\n- ስነ-ልቦናዊ / ስሜታዊ ጥቃት: የቃል ስድብ:፣ ማግለል:\n- ፆታዊ ጥቃት እና ብዝበዛ: አስገድዶ መድፈር:፣ ፆታዊ ትንኮሳ:\n- ኢኮኖሚያዊ ጥቃት: የገንዘብ ሀብትን መከልከል:፣ በገንዘብ ጥገኝነት ማስገደድ:\n- ጎጂ ባህላዊ ልማዶች: የሴቶች ግርዛት (FGM/C):፣ ያለዕድሜ ወይም ያለፈቃድ ጋብቻ:\n\n> የዶክተር ማስታወሻ: ጥቃት ፈጽሞ የተጠቃጁ ጥፋት አይደለም፤ እያንዳንዱ ሰው በሰላምና በክብር የመኖር መብት አለው።\n\n## ተፈጥሯዊ ፆታ እና ማህበራዊ ፆታ\nበተፈጥሯዊ ፆታ (Sex) እና በማህበራዊ ፆታ (Gender) መካከል ያለውን ልዩነት መረዳት የሥርዓተ-ፆታ ጥቃትን ለመከላከል ወሳኝ ነው። ተፈጥሯዊ ፆታ በባዮሎጂያዊ እና አካላዊ መገለጫዎች (ክሮሞሶሞች፣ ሆርሞኖች እና የመራቢያ አካላት) ላይ የተመሰረተ ነው። ማህበራዊ ፆታ ደግሞ ማህበረሰቡ ለወንዶች ወይም ለሴቶች የሰጠውን ሚና፣ ባህሪ እና የሚጠበቁ ተግባራትን ያመለክታል።\n\nየማህበራዊ ፆታ ልማዶች ሰዎች በተፈጥሮ ፆታቸው መሰረት እንዴት እርምጃ መውሰድ፣ መናገር እና መልበስ እንዳለባቸው ይወስናሉ። ያልተመጣጠነ የስልጣን ክፍፍል እና አንዱን ወገን ከሌላው የማስበለጥ አመለካከቶች ጥቃትን እና አድሎን ወደ ማጽደቅ ያመራሉ፤ ይህም ለሥርዓተ-ፆታ ጥቃት መከሰት መሰረት ይሆናል።\n\n- ፆታ በተፈጥሮ የሚወሰን አካላዊና ባዮሎጂያዊ ልዩነት ነው።\n- ሥርዓተ-ፆታ በማህበረሰቡ የሚሰጡ ሚናዎችንና የሚጠበቁ ባህሪያትን ያጠቃልላል።\n- የስልጣን አለመመጣጠንና የተሳሳቱ አመለካከቶች ለፆታዊ ጥቃት መነሻ ይሆናሉ።\n\n> የዶክተር ማስታወሻ: የእኩልነትን ባህል ማዳበርና የተዛቡ አመለካከቶችን ማረም ለሰላማዊ ማህበረሰብ መኖር መሰረት ነው።\n\n## የሥርዓተ-ፆታ ጥቃት የሚያስከትላቸው ጉዳቶች\nሥርዓተ ፆታን መሠረት ያደረገ ጥቃት በርካታ አካላዊ፣ ስነ-ልቦናዊና ማህበራዊ ጉዳቶችን ያስከትላል፡\n\n- አካላዊ ጉዳት፣ የአካል ጉዳተኝነት፣ ሥር የሰደደ የጤና እክል፣ የስነ-ተዋልዶ ጤና ችግሮች፣ ሞት\n- ስነ-ልቦናዊ ችግሮች፣ ጭንቀት፣ ፍርሃት፣ የብቸኝነት ስሜት፣ ድብርት፣ የአልኮል ወይም እፅ ሱስ፣ ራስን ማጥፋት\n- ኢኮኖሚያዊ እና ማህበራዊ ተፅእኖ፣ በማህበራዊ እና ኢኮኖሚያዊ እንቅስቃሴዎች ውስጥ የመሳተፍ አቅም መቀነስ፣ በማህበረሰብ ደረጃ የሚደርስ መገለል፣ የሴቶችን የገቢ ማመንጨት አቅም መጉዳት፣ ለሌሎች የጥቃት ዓይነቶች ተጋላጭነት መጨመር\n- በሴቶች ቤተሰብ እና ጥገኞች ላይ የሚደርስ ተፅእኖ፣ ፍቺ ወይም የተበታተኑ ቤተሰቦች፣ የቤተሰብን ኢኮኖሚያዊ እና ስሜታዊ እድገት ማወክ፣ የስሜት እና የባህሪ መታወክ\n- ስሜታዊ መዘዞች፣ ድብርት፣ ውጥረት፣ ዝቅተኛ በራስ መተማመን\n\n> የዶክተር ማስታወሻ: ጥቃት የደረሰባቸው ወገኖች ሙሉ የህክምና፣ የህግና የስነ-ልቦና ድጋፍ ያስፈልጋቸዋል።\n\n## የሥርዓተ-ፆታ ጥቃት አያያዝ እና መከላከያ መንገዶች\nአፋጣኝ ምላሽ፡ የGBV አያያዝ\n\nጥቃት በሚደርስበት ጊዜ ተጎጂዎችን ለመደገፍ እና ሁኔታውን ለመፍታት አፋጣኝ ጣልቃገብነት አስፈላጊ ነው።\n\n- ደህንነትን እና ጥበቃን መስጠት: ደህንነታቸው የተጠበቁ ቦታዎች፡ (የአደጋ ጊዜ መጠለያዎች እና ማዕከላት ለተጎጂዎች ፈጣን መጠጊያ ይሰጣሉ።)\n- ሁሉን አቀፍ የድጋፍ አገልግሎቶች: ስነ-ልቦናዊ ድጋፍ፡ (ተጎጂዎች ከደረሰባቸው ስነ-ልቦናዊ ቀውስ እንዲያገግሙ የሚረዳ የምክር እና የስነ-ልቦና ህክምና።)\n- የሥርዓተ-ፆታ ጥቃትን መከላከል: የመከላከያ ስልቶች የሚያተኩሩት የጥቃቱን ዋና መንስኤዎች በማስወገድ ጥቃት የማይታገስበትን ማህበረሰብ ለመፍጠር ነው።\n- የረጅም ጊዜ ስልቶች፡ መዋቅራዊ እና ባህላዊ ሁኔታዎችን መለወጥ: የሥርዓተ-ፆታ ጥቃትን የሚያስቀጥሉ ማህበራዊ፣ ባህላዊ እና ኢኮኖሚያዊ ምክንያቶችን ለመፍታት የረጅም ጊዜ ጥረቶች ያስፈልጋሉ።\n\n> የዶክተር ማስታወሻ: እርስዎ ወይም የሚያውቁት ሰው ጥቃት ወይም በደል እያጋጠመዎት ከሆነ ብቻዎን አይደሉም። ደህንነቱ የተጠበቀ እና ሚስጥራዊ የህክምና እና የህግ ድጋፍ አለ። በነጻ የስልክ መስመሮች 952፣ 8335 ወይም 7711 በመደወል አሁኑኑ ያግኙ።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "Gender-based violence (GBV) includes physical, sexual, psychological, and economic harm directed at an individual based on their gender.",
            "questionAm": "በፆታ ላይ የተመሰረተ ጥቃት (GBV) በአንድ ግለሰብ ላይ በፆታው ምክንያት የሚደርስ አካላዊ፣ ወሲባዊ፣ ስነ-ልቦናዊ እና ኢኮኖሚያዊ ጉዳትን ያካትታል።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "GBV encompasses all forms of coercive control, emotional abuse, physical harm, and economic deprivation rooted in unequal gender norms.",
            "explanationAm": "GBV ጫናን፣ ስሜታዊ ጥቃትን፣ አካላዊ ጉዳትን እና የኢኮኖሚ ጥገኝነትን የሚያካትት ሰፊ ማህበራዊና የሰብአዊ መብት ጉዳይ ነው።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "What is a vital immediate step when supporting a survivor who has experienced sexual violence?",
            "questionAm": "ፆታዊ ጥቃት የደረሰበትን ሰው በሚደገፍበት ወቅት ወሳኝ የሆነው አስቸኳይ እርምጃ የትኛው ነው?",
            "optionsEn": [
                "Ensure their safety and seek confidential medical care (including PEP within 72 hours)",
                "Blame them for being in the situation",
                "Disclose their private story to neighborhood groups",
                "Ignore their feelings and tell them to stay silent"
            ],
            "optionsAm": [
                "ደህንነታቸውን ማረጋገጥ እና ሚስጥራዊ የህክምና እርዳታ (በ72 ሰዓታት ውስጥ የPEP ህክምና) ማግኘት",
                "ለደረሰባቸው ሁኔታ እነሱን ተጠያቂ ማድረግ",
                "የግል ታሪካቸውን ለአካባቢው ሰው ማውራት",
                "ስሜታቸውን ችላ ብሎ ዝም እንዲሉ መምከር"
            ],
            "correctIndex": 0,
            "explanationEn": "Immediate safety, non-judgmental empathy, and clinical care—including post-exposure prophylaxis (PEP) within 72 hours—are crucial for survivors.",
            "explanationAm": "አስቸኳይ ደህንነትን መጠበቅ፣ ያለፍርድ ማዳመጥ እና በ72 ሰዓታት ውስጥ የPEP ህክምና ማግኘት ለተጎጂዎች ህይወት አድን ነው።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "What role can men and boys play in preventing gender-based violence in our communities?",
            "questionAm": "ወንዶች በማህበረሰቡ ውስጥ በፆታ ላይ የተመሰረተ ጥቃትን ለመከላከል ምን አይነት አዎንታዊ ሚና መጫወት ይችላሉ?",
            "optionsEn": [
                "Promote respectful relationships, reject violent norms, and speak out against abuse",
                "Remain silent when witnessing harassment",
                "Enforce rigid traditional inequalities",
                "Discourage girls from attending school"
            ],
            "optionsAm": [
                "የተከበረ ግንኙነትን ማበረታታት፣ የጥቃት ባህልን መቃወም እና ድምጽ መሆን",
                "ጥቃት ሲፈጸም እያዩ ዝም ማለት",
                "ጎጂ ልማዳዊ ድርጊቶችን ማበረታታት",
                "ሴቶች ትምህርት እንዳይማሩ መከልከል"
            ],
            "correctIndex": 0,
            "explanationEn": "Engaging men and boys as allies and champions for gender equality creates safer, more supportive communities for everyone.",
            "explanationAm": "ወንዶችን ለፆታ እኩልነት አጋርና ግንባር ቀደም ተሟጋች ማድረግ ለሁሉም ሰው አስተማማኝ ማህበረሰብ ይፈጥራል።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Survivors of GBV are never to blame for the violence committed against them.",
            "questionAm": "በፆታ ላይ የተመሰረተ ጥቃት ሰለባ የሆኑ ሰዎች ለደረሰባቸው ጥቃት ፈጽሞ ተጠያቂ አይደሉም።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Responsibility for violence rests solely on the perpetrator. Blaming survivors causes secondary trauma and deters people from seeking help.",
            "explanationAm": "የጥቃቱ ሙሉ ተጠያቂ አጥፊው ብቻ ነው፤ ተጎጂዎችን ተጠያቂ ማድረግ ተጨማሪ ስነ-ልቦናዊ ጉዳት ያስከትላል።"
        }
    ],
  },
  {
    id: "module-05",
    nameEn: "Sexual and reproductive health (SRH)",
    nameAm: "የሥነ-ተዋልዶ ጤና (SRH)",
    category: "srh",
    imageAsset: "module_05_srh.png",
    readTimeMin: 5,
    authorName: "Reproductive Health Educators Network",
    titleEn: "Sexual and reproductive health (SRH)",
    titleAm: "የሥነ-ተዋልዶ ጤና (SRH)",
    summaryEn: "Sexual and Reproductive Health is a state of physical, mental, and social well-being in all matters relating to the reproductive system, relationships, and fertility.",
    summaryAm: "የሥነ-ተዋልዶ ጤና ከመራቢያ አካላት፣ ከግንኙነቶች እና ከመውለድ ጋር በተያያዙ ጉዳዮች ሁሉ ሙሉ አካላዊ፣ አእምሮአዊ እና ማህበራዊ ደህንነት ነው።",
    doctorNoteEn: "Informed decisions, mutual respect, open communication, and access to healthcare ensure healthy relationships and empowered family planning.",
    doctorNoteAm: "በቂ ግንዛቤ ማግኘት፣ የጋራ መከባበር፣ ግልጽ ውይይት እና የጤና አገልግሎት ማግኘት ለጤናማ ግንኙነትና ለቤተሰብ እቅድ ወሳኝ ናቸው።",
    contentEn: "| Note: Informed decisions, mutual respect, open communication, and access to healthcare ensure healthy relationships and empowered family planning.\n\n## Understanding Sexual & Reproductive Health\nA Holistic View of Wellbeing\n\nSRH is not just about avoiding disease; it is the right to make informed choices about your body, sexuality, and future.\n\n- Physical health: Caring for reproductive organs, preventing infections, and accessing routine checkups.\n- Emotional health: Developing positive self-esteem, healthy body image, and respect in intimate relationships.\n- Social wellbeing: Experiencing equality, free from stigma, coercion, or gender discrimination.\n\n> Clinical Tip: SRH encompasses bodily autonomy, healthy communication, freedom from violence, and equitable healthcare access.\n\n## Anatomy & Reproductive Systems\nHow the Human Body Functions\n\nUnderstanding how female and male reproductive systems work empowers individuals to care for their bodily health.\n\n- Female anatomy: Ovaries produce eggs and hormones (estrogen/progesterone); fallopian tubes guide eggs to the uterus where a baby can develop.\n- Male anatomy: Testicles produce sperm and testosterone; sperm travels through the vas deferens and urethra.\n- Conception: Fertilization occurs when a sperm cell joins with a mature egg, initiating pregnancy.\n\n> Clinical Tip: Familiarity with your reproductive anatomy and menstrual tracking is the foundation of confident self-care.\n\n## Family Planning & Contraceptive Methods\nEmpowering Family and Life Planning\n\nFamily planning allows individuals and couples to decide if and when to have children, promoting maternal and child health.\n\n- Barrier methods: Male and female condoms prevent pregnancy and provide essential protection against STIs and HIV (dual protection).\n- Hormonal methods: Pills, injections, implants, and IUDs offer reliable pregnancy prevention by regulating ovulation and cervical mucus.\n- Permanent methods: Vasectomy and tubal ligation are voluntary surgical procedures for individuals who have completed their family size.\n- Emergency contraception: Can prevent unintended pregnancy when taken within 72 to 120 hours following unprotected intercourse.\n\n> Clinical Tip: Dual protection (using condoms simultaneously with another modern contraceptive) prevents both STIs and unintended pregnancy.\n\n## Consent, Rights & Healthy Relationships\nBuilding Trust and Mutual Respect\n\nHealthy relationships are built on communication, equality, and uncoerced consent.\n\n- What is consent: An active, freely given, reversible, and informed agreement between partners.\n- Bodily autonomy: Everyone has the fundamental right to make decisions regarding their own body and reproductive health.\n- Effective communication: Talking openly with partners about boundaries, health history, and contraception leads to safer relationships.\n\n> Clinical Tip: True consent must be freely given, revocable at any moment, fully conscious, and enthusiastic.",
    contentAm: "| ማስታወሻ: በቂ ግንዛቤ ማግኘት፣ የጋራ መከባበር፣ ግልጽ ውይይት እና የጤና አገልግሎት ማግኘት ለጤናማ ግንኙነትና ለቤተሰብ እቅድ ወሳኝ ናቸው።\n\n## የሥነ-ተዋልዶ ጤና ግንዛቤ\nአጠቃላይ የጤና እና የደህንነት እይታ\n\nየሥነ-ተዋልዶ ጤና በሽታ አለመኖር ብቻ ሳይሆን ስለ ሰውነት፣ ስለ ግንኙነት እና ስለወደፊት ህይወት በመረጃ ላይ የተመሰረተ ውሳኔ የማድረግ መብት ነው።\n\n- አካላዊ ጤና፡ የመራቢያ አካላትን መንከባከብ፣ ኢንፌክሽኖችን መከላከል እና መደበኛ ምርመራ ማድረግ።\n- ስሜታዊ ጤና፡ በራስ መተማመንን መገንባት፣ የሰውነት ገጽታን መውደድ እና በግንኙነት ውስጥ መከባበር።\n- ማህበራዊ ደህንነት፡ ከአድሎ፣ ከማግለልና ከፆታ ልዩነት የጸዳ እኩልነትን መጎናጸፍ።\n\n> የዶክተር ማስታወሻ: የስነ-ተዋልዶ ጤና አካላዊ ደህንነትን፣ ግልጽ ውይይትንና ከማንኛውም ጫና ነፃ መሆንን ያካትታል።\n\n## የሥነ-ተዋልዶ አካላት እና አሰራራቸው\nየሰውነት ተፈጥሯዊ አሰራር\n\nየሴት እና የወንድ የስነ-ተዋልዶ አካላትን አሰራር መረዳት ሰዎች ጤናቸውን በአግባቡ እንዲጠብቁ ያግዛል።\n\n- የሴት ስነ-ተዋልዶ አካላት፡ እንቁላል እና ሆርሞኖችን (ኢስትሮጅን/ፕሮጄስትሮን) ያመነጫሉ፤ ማህፀን ደግሞ ፅንስ የሚያድግበት ነው።\n- የወንድ ስነ-ተዋልዶ አካላት፡ የዘር ፍሬ እና ቴስቶስትሮን ያመነጫሉ፤ ስፐርም በሽንት ቧንቧ በኩል ይጓዛል።\n- ፅንስ መፈጠር፡ የወንድ የዘር ፈሳሽ ከበሰለ እንቁላል ጋር ሲገናኝ እርግዝና ይፈጠራል።\n\n> የዶክተር ማስታወሻ: የሰውነትዎን ተፈጥሯዊ ለውጦችና የወር አበባ ዑደት በሚገባ ማወቅ ለጤና ጥበቃ የመጀመሪያው እርምጃ ነው።\n\n## የቤተሰብ ምጣኔ እና የወሊድ መከላከያ ዘዴዎች\nየህይወት እና የቤተሰብ እቅድን ማሳለጥ\n\nየቤተሰብ ምጣኔ ሰዎች መቼና ስንት ልጆች እንደሚፈልጉ እንዲወስኑ በማድረግ የእናቶችንና የህፃናትን ጤና ይጠብቃል።\n\n- የኮንዶም አጠቃቀም፡ እርግዝናን የሚከላከል ከመሆኑም ባሻገር ከአባላዘር በሽታዎችና ከኤች አይ ቪ ይጠብቃል (ድርብ ጥበቃ)።\n- የሆርሞን ዘዴዎች፡ የሚዋጡ ኪኒኖች፣ የመርፌ መድኃኒቶችና የእጅ ውስጥ መከላከያዎች አስተማማኝ ጥበቃ ይሰጣሉ።\n- ዘላቂ ዘዴዎች፡ የልጅ ፍላጎታቸውን ላጠናቀቁ ሰዎች የሚደረጉ ቀላል የቀዶ ጥገና ዘዴዎች ናቸው።\n- የአስቸኳይ ጊዜ መከላከያ፡ ጥንቃቄ የጎደለው ግንኙነት ከተፈጠረ በኋላ በ 72–120 ሰዓታት ውስጥ ያልተፈለገ እርግዝናን መከላከል ይችላል።\n\n> የዶክተር ማስታወሻ: ኮንዶምን ከሌሎች የእርግዝና መከላከያዎች ጋር አጣምሮ መጠቀም ከኢንፌክሽንም ሆነ ካልተፈለገ እርግዝና ሁነኛ መከላከያ ነው።\n\n## ስምምነት፣ መብቶች እና ጤናማ ግንኙነቶች\nመተማመን እና የጋራ መከባበርን መገንባት\n\nጤናማ ግንኙነቶች የሚገነቡት በግልጽ ውይይት፣ በእኩልነት እና ያለምንም ጫና በሚደረግ የጋራ ስምምነት ነው።\n\n- ስምምነት ማለት፡ ያለ ምንም ማስገደድ፣ በነጻነትና በግልጽ የሚደረግ የሁለትዮሽ ስምምነት ነው።\n- የሰውነት ራስን በራስ የማስተዳደር መብት፡ እያንዳንዱ ሰው በገዛ ሰውነቱ እና በስነ-ተዋልዶ ጤናው ላይ የመወሰን ሙሉ መብት አለው።\n- ግልጽ ውይይት፡ ከአጋር ጋር ስለ ድንበሮች፣ ስለ ጤና ታሪክ እና ስለ መከላከያ ዘዴዎች መወያየት ግንኙነትን ጤናማ ያደርጋል።\n\n> የዶክተር ማስታወሻ: ትክክለኛ ስምምነት በማንኛውም ጊዜ ሊቀለበስ የሚችል፣ ከጫና ነፃና በሙሉ ፈቃደኝነት ላይ የተመሰረተ መሆን አለበት።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "Sexual and Reproductive Health includes physical, emotional, and social well-being, not merely the absence of disease.",
            "questionAm": "የሥነ-ተዋልዶ ጤና የአካል፣ የአእምሮ እና የማህበራዊ ደህንነትን የሚያጠቃልል እንጂ በሽታ አለመኖር ብቻ አይደለም።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "The World Health Organization recognizes SRH as a positive, holistic state of wellbeing that respects individual rights and choices.",
            "explanationAm": "የዓለም ጤና ድርጅት የሥነ-ተዋልዶ ጤናን የግል መብትንና ምርጫን የሚያከብር ሁለንተናዊ ደህንነት እንደሆነ ይገልጻል።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Which family planning method provides 'dual protection' by preventing both unintended pregnancy AND sexually transmitted infections?",
            "questionAm": "ያልተፈለገ እርግዝናን ከመከላከል በተጨማሪ ከአባላዘር በሽታዎች 'ድርብ ጥበቃ' የሚሰጠው የትኛው ዘዴ ነው?",
            "optionsEn": [
                "External or internal condoms",
                "Daily oral contraceptive pills alone",
                "Injectable hormones alone",
                "Intrauterine devices (IUDs) alone"
            ],
            "optionsAm": [
                "የወንድ ወይም የሴት ኮንዶም",
                "የሚዋጡ የወሊድ መከላከያ ኪኒኖች ብቻ",
                "የመርፌ መከላከያዎች ብቻ",
                "የማህፀን ሉፕ ብቻ"
            ],
            "correctIndex": 0,
            "explanationEn": "While hormonal methods prevent pregnancy effectively, only barrier methods like condoms protect against STIs and HIV simultaneously.",
            "explanationAm": "የሆርሞን ዘዴዎች እርግዝናን ብቻ የሚከላከሉ ሲሆን ኮንዶም ግን እርግዝናንና የአባላዘር ኢንፌክሽኖችን በአንድ ላይ ይከላከላል።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Consent in any healthy relationship must be freely given, enthusiastic, informed, and can be changed or withdrawn at any time.",
            "questionAm": "በማንኛውም ጤናማ ግንኙነት ውስጥ ስምምነት በነጻነት፣ በፍላጎትና በግልጽ የሚሰጥ እንዲሁም በማንኛውም ጊዜ ሊለወጥ የሚችል መሆን አለበት።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "True consent requires freedom of choice without pressure or fear. Respecting partner boundaries is fundamental to healthy relationships.",
            "explanationAm": "ትክክለኛ ስምምነት ያለምንም ማስገደድ የሚደረግ ነው፤ የአጋርን ድንበር ማክበር ለጤናማ ግንኙነት መሰረት ነው።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Family planning enables individuals and couples to choose if, when, and how many children to have, supporting maternal and family well-being.",
            "questionAm": "የቤተሰብ ምጣኔ ሰዎች መቼና ስንት ልጆች መውለድ እንዳለባቸው እንዲመርጡ በማድረግ የእናቶችንና የቤተሰብን ደህንነት ያጠናክራል።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Family planning empowers women and families, reduces maternal complications, and supports healthy child development and financial stability.",
            "explanationAm": "የቤተሰብ ምጣኔ ሴቶችን ያበረታል፣ የእናቶች ሞትን ይቀንሳል እንዲሁም ለልጆች ጤናማ እድገት አስተዋጽኦ ያደርጋል።"
        }
    ],
  },
  {
    id: "module-06",
    nameEn: "Mental health & wellbeing",
    nameAm: "የአእምሮ ጤና እና ደህንነት",
    category: "mental_health",
    imageAsset: "module_06_mental_health.jpg",
    readTimeMin: 5,
    authorName: "Dr. Hanna Bekele & Campus Counseling Team",
    titleEn: "Mental health & wellbeing",
    titleAm: "የአእምሮ ጤና እና ደህንነት",
    summaryEn: "Mental health is an essential part of overall health, encompassing emotional, psychological, and social wellbeing. It influences how we think, feel, manage stress, connect with others, and make decisions throughout life.",
    summaryAm: "የአእምሮ ጤና ከአጠቃላይ ጤና ጋር በእጅጉ የተቆራኘ ሲሆን ስሜታዊ፣ ስነ-ልቦናዊ እና ማህበራዊ ደህንነትን ያካትታል። በህይወት ዘመናችን ሁሉ እንዴት እንደምናስብ፣ እንደምንሰማ፣ ውጥረትን እንደምንቆጣጠር፣ ከሌሎች ጋር እንደምንገናኝ እና ውሳኔ እንደምንሰጥ ይወስናል።",
    doctorNoteEn: "Mental health exists on a continuum and can be nurtured and healed—seeking support during tough times is a sign of courage and strength, not weakness.",
    doctorNoteAm: "የአእምሮ ጤና ሊንከባከብ እና ሊድን የሚችል ነው—በአስቸጋሪ ጊዜያት ድጋፍ መፈለግ የጥንካሬ እና የድፍረት ምልክት እንጂ የድክመት ምልክት አይደለም።",
    contentEn: "| Note: Mental health exists on a continuum and can be nurtured and healed—seeking support during tough times is a sign of courage and strength, not weakness.\n\n## Understanding Mental Health & Wellbeing\nMental health includes our emotional, psychological, and social wellbeing. It affects how we handle daily challenges, relate to friends and family, and make healthy lifestyle choices.\n\nGood mental health does not mean feeling happy every moment. It means having the emotional resilience to navigate sadness, anger, stress, and joy in balanced, constructive ways.\n\n- Mental health exists on a dynamic continuum from flourishing to acute distress.\n- Experiencing sadness, grief, or frustration is a natural human reaction to life stressors.\n- Practicing self-compassion, rest, and connection strengthens neurological resilience.\n\n> Clinical Tip: Mental health is just as important as physical health. The mind and body are deeply interconnected: prolonged physical illness impacts emotional health, and chronic stress directly triggers physical ailments.\n\n## Common Challenges in Youth\nYoung people experience intense transitions, biological changes, and social pressures. Common challenges include:\n\n- Academic stress and burnout: Overwhelming anxiety about school grades, examinations, and future expectations.\n- General and social anxiety: Persistent, excessive worry about social situations, fear of judgment, or constant nervousness.\n- Depressive mood and sadness: Ongoing feelings of hopelessness, emptiness, loss of interest in favorite activities, and low energy.\n- Peer pressure and cyberbullying: Pressure to conform to unhealthy behaviors, fear of missing out (FOMO), or online harassment.\n\n> Clinical Tip: Academic and relationship pressures are common. Break challenges into small daily steps and speak openly with peer mentors.\n\n## Positive Coping & Self-Care Strategies\nBuilding daily mental wellness practices helps protect against stress and strengthens emotional resilience:\n\n- Daily physical movement: 30 minutes of walking, jogging, dancing, or sports naturally releases endorphins that boost mood and reduce tension.\n- Restful sleep hygiene: Consistent 7–9 hours of sleep per night stabilizes mood, memory, and cognitive focus.\n- Mindful breathing and relaxation: Deep belly breathing, quiet reflection, and grounding exercises calm the nervous system when overwhelmed.\n- Expressive outlets: Journaling feelings, creating art, music, or prayer and meditation provide safe emotional release.\n- Healthy boundaries: Learning to say 'no' to overwhelming requests and limiting excessive, draining social media use.\n\n> Clinical Tip: Regular physical activity releases endorphins, while consistent sleep schedules directly protect cognitive stamina.\n\n## Recognizing Warning Signs & Seeking Support\nIt is important to recognize when stress or sadness has crossed into a health challenge that needs outside support:\n\n- Prolonged withdrawal: Isolating completely from friends, family, and social activities for weeks.\n- Extreme mood shifts: Sudden, drastic fluctuations in personality, explosive anger, or extreme hopelessness.\n- Changes in sleeping or eating: Severe insomnia, sleeping all day, or major appetite and weight changes.\n- Turning to substances: Relying on alcohol, khat, or drugs to escape difficult feelings.\n- Thoughts of self-harm: Persistent thoughts of wanting to disappear, hurting oneself, or despair.\n\n> Clinical Tip: You never have to carry emotional pain alone. Talking to a verified peer counselor, school counselor, or calling toll-free national health lines (952 or 8335) connects you with compassionate, 100% confidential support.",
    contentAm: "| ማስታወሻ: የአእምሮ ጤና ሊንከባከብ እና ሊድን የሚችል ነው—በአስቸጋሪ ጊዜያት ድጋፍ መፈለግ የጥንካሬ እና የድፍረት ምልክት እንጂ የድክመት ምልክት አይደለም።\n\n## ስለ አእምሮ ጤና እና ደህንነት መረዳት\nየአእምሮ ጤና ስሜታዊ፣ ስነ-ልቦናዊ እና ማህበራዊ ደህንነታችንን ያጠቃልላል። የዕለት ተዕለት ፈተናዎችን እንዴት እንደምንወጣ፣ ከቤተሰብ እና ከጓደኞች ጋር ያለንን ግንኙነት እና ጤናማ የአኗኗር ውሳኔዎችን እንዴት እንደምንወስን ይወስናል።\n\nጥሩ የአእምሮ ጤና ማለት ሁልጊዜ ደስተኛ መሆን ማለት አይደለም። ይልቁንም ሀዘንን፣ ንዴትን፣ ጭንቀትን እና ደስታን ሚዛናዊ በሆነ መንገድ የመቋቋም ስሜታዊ ብርታት ማዳበር ማለት ነው።\n\n- የአእምሮ ጤና እንደየሁኔታው ከጥሩ ስሜት እስከ ከባድ ጭንቀት ድረስ ሊለዋወጥ ይችላል።\n- ሀዘን ወይም ድካም መሰማት ለህይወት ፈተናዎች የሚሰጥ ተፈጥሯዊ ምላሽ ነው።\n- ለራስ እረፍት መስጠትና ከሰዎች ጋር መገናኘት አእምሮን ያበረታታል።\n\n> የዶክተር ማስታወሻ: የአእምሮ ጤና ልክ እንደ አካላዊ ጤና እኩል አስፈላጊ ነው። አእምሮ እና አካል በጥብቅ የተሳሰሩ ናቸው፦ ያልተቋረጠ አካላዊ ህመም ስሜትን ይጎዳል፣ ሥር የሰደደ ውጥረትም በቀጥታ የአካል ህመምን ያስከትላል።\n\n## በወጣቶች ላይ የሚከሰቱ የተለመዱ የአእምሮ ጤና ፈተናዎች\nወጣቶች በህይወት የሽግግር ወቅት፣ በአካላዊ ለውጦች እና በማህበራዊ ጫናዎች ውስጥ ያልፋሉ። የተለመዱ ፈተናዎች የሚከተሉትን ያካትታሉ፦\n\n- የትምህርት ጭንቀት እና ድካም፦ ስለ ውጤት፣ ፈተናዎች እና ስለ ወደፊት ህይወት የሚሰማ ከልክ ያለፈ ፍርሃትና ጭንቀት።\n- አጠቃላይ እና ማህበራዊ ጭንቀት፦ በማህበራዊ ግንኙነቶች ውስጥ የማያቋርጥ ፍርሃት፣ የሌሎችን ትችት መፍራት እና የማያቋርጥ የፍርሃት ስሜት።\n- የድብርት ስሜት እና የከፋ ሀዘን፦ ተስፋ የመቁረጥ፣ የባዶነት ስሜት፣ በሚወዷቸው እንቅስቃሴዎች ላይ ፍላጎት ማጣት እና የጉልበት ማነስ።\n- የእኩዮች ጫና እና የኢንተርኔት ትንኮሳ፦ ወደ ጎጂ ባህሪያት እንዲገቡ የሚደረግ ጫና ወይም በማህበራዊ ሚዲያ የሚደርስ ትንኮሳ።\n\n> የዶክተር ማስታወሻ: የትምህርትና የማህበራዊ ጫናዎች ሲያጋጥሙ ነገሮችን በደረጃ ማከናወንና ከአማካሪዎች ጋር መወያየት መፍትሄ ያመጣል።\n\n## ውጥረትን የመቋቋሚያ እና ራስን የመንከባከቢያ ዘዴዎች\nየዕለት ተዕለት ጤናማ ልምዶችን ማዳበር ከአእምሮ ውጥረት ይጠብቃል እንዲሁም ስሜታዊ ጥንካሬን ይገነባል፦\n\n- የዕለት ተዕለት አካላዊ እንቅስቃሴ፦ በቀን ለ 30 ደቂቃ በእግር መጓዝ፣ ሩጫ ወይም ስፖርት መስራት ስሜትን የሚያነቃቁ ሆርሞኖችን (ኢንዶርፊን) ያመነጫል።\n- በቂ እና ጤናማ እንቅልፍ፦ በቀን ከ 7 እስከ 9 ሰዓታት መተኛት ስሜትን፣ ትውስታን እና ትኩረትን ያረጋጋል።\n- የአተነፋፈስ እና የመረጋጋት ልምምድ፦ በጥልቀት መተንፈስ፣ ጸጥታን መለማመድ እና ማሰላሰል በውጥረት ወቅት የነርቭ ስርዓትን ያረጋጋሉ።\n- ስሜትን የመግለጫ መንገዶች፦ ስሜትን በማስታወሻ ላይ መጻፍ፣ ስነ-ጥበብ፣ ሙዚቃ ወይም ጸሎት ስሜትን ለማስተንፈስ ይረዳሉ።\n- ጤናማ ወሰን ማበጀት፦ አቅም በላይ ለሆኑ ጥያቄዎች 'አይሆንም' ማለት እና አድካሚ የማህበራዊ ሚዲያ አጠቃቀምን መገደብ።\n\n> የዶክተር ማስታወሻ: የአካል ብቃት እንቅስቃሴና በቂ እንቅልፍ ማግኘት ጭንቀትን በመቀነስ የአእምሮ ንቃትን ይጨምራሉ።\n\n## የአእምሮ ጭንቀት ምልክቶችን መገንዘብ እና ድጋፍ መፈለግ\nውጥረት ወይም ሀዘን የባለሙያ ድጋፍ የሚያስፈልገው ደረጃ ላይ መድረሱን ማወቅ አስፈላጊ ነው፦\n\n- ከማህበራዊ ህይወት መራቅ፦ ለሳምንታት ከጓደኞች፣ ከቤተሰብ እና ከማህበራዊ እንቅስቃሴዎች ሙሉ በሙሉ መገለል።\n- ከፍተኛ የስሜት መለዋወጥ፦ ድንገተኛ የባህሪ ለውጥ፣ ያልተለመደ የቁጣ ፍንዳታ ወይም ከፍተኛ የተስፋ መቁረጥ ስሜት።\n- የእንቅልፍ ወይም የምግብ ፍላጎት ለውጥ፦ ከፍተኛ እንቅልፍ ማጣት፣ ቀኑን ሙሉ መተኛት ወይም ከፍተኛ የክብደት ለውጥ።\n- ወደ አደንዛዥ እፆች ማዘንበል፦ ከአስቸጋሪ ስሜቶች ለማምለጥ በአልኮል፣ በጫት ወይም በእፆች ላይ ጥገኛ መሆን።\n- ራስን የመጉዳት ሀሳቦች፦ የመጥፋት፣ ራስን የመጉዳት ወይም የከፋ የተስፋ መቁረጥ ሀሳቦች ማሰላሰል።\n\n> የዶክተር ማስታወሻ: የስሜት ህመምን ብቻዎን መሸከም አይኖርብዎትም። ከተረጋገጡ የወጣቶች አማካሪዎች ጋር መነጋገር ወይም በነፃ የስልክ መስመሮች (952 ወይም 8335) መደወል ፍጹም ሚስጥራዊ እና ሩህሩህ ድጋፍ ይሰጥዎታል።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "Mental health is just as important as physical health, and experiencing emotional struggles is a medical condition, not a sign of personal weakness?",
            "questionAm": "የአእምሮ ጤና ልክ እንደ አካላዊ ጤና እኩል አስፈላጊ ሲሆን የስሜት ቀውስ ማጋጠም የጤና ሁኔታ እንጂ የግል ድክመት አይደለም?",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Mental health is a fundamental component of total health. Seeking support for emotional distress is a responsible, courageous step toward wellbeing.",
            "explanationAm": "የአእምሮ ጤና የአጠቃላይ ጤና መሰረት ነው። በስሜት ቀውስ ወቅት ድጋፍ መፈለግ ለጤና የሚወሰድ ሃላፊነት የተሞላበት የጀግንነት እርምጃ ነው።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Which of the following is a healthy, effective way to manage everyday stress and emotional overwhelm?",
            "questionAm": "የዕለት ተዕለት ውጥረትን እና የስሜት ጫናን ለመቆጣጠር ጤናማ እና ውጤታማ የሆነው መንገድ የትኛው ነው?",
            "optionsEn": [
                "Regular physical exercise, mindful breathing, and getting 7–9 hours of sleep",
                "Isolating yourself in your room and avoiding talking to anyone",
                "Using alcohol or drugs to numb difficult emotions",
                "Skipping meals and staying awake all night"
            ],
            "optionsAm": [
                "መደበኛ የአካል ብቃት እንቅስቃሴ ማድረግ፣ በጥልቀት መተንፈስ እና ከ 7-9 ሰዓት መተኛት",
                "ክፍል ውስጥ ብቻውን ተዘግቶ መቆየት እና ከማንም ጋር አለመነጋገር",
                "ከስሜት ለማምለጥ አልኮል ወይም እፅ መጠቀም",
                "ምግብ አለመብላት እና ሌሊቱን ሙሉ ባለመተኛት ማሳለፍ"
            ],
            "correctIndex": 0,
            "explanationEn": "Physical activity releases mood-lifting endorphins, while adequate sleep and deep breathing reset the autonomic nervous system.",
            "explanationAm": "የአካል ብቃት እንቅስቃሴ ስሜትን የሚያሻሽሉ ሆርሞኖችን ያመነጫል፣ በቂ እንቅልፍ እና ጥልቅ አተነፋፈስም የነርቭ ስርዓትን ያረጋጋሉ።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Does good mental health mean you should feel happy and positive every single moment of your life?",
            "questionAm": "ጥሩ የአእምሮ ጤና ማለት በህይወትዎ ውስጥ በሁሉም ቅጽበት ደስተኛ እና ቀናተኛ መሆን አለብዎት ማለት ነው?",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 1,
            "explanationEn": "Good mental health involves experiencing the full range of human emotions (including sadness, frustration, and grief) and having healthy tools to process them.",
            "explanationAm": "ጥሩ የአእምሮ ጤና ሁሉንም የሰው ልጅ ስሜቶች (ሀዘንን፣ ብስጭትን እና ጭንቀትን ጨምሮ) መለማመድ እና እነሱን ለማስተናገድ ጤናማ ዘዴዎች እንዲኖሩን ማድረግ ነው።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "If you or a friend are feeling overwhelmed by sadness or anxiety for several weeks, what is the best course of action?",
            "questionAm": "እርስዎ ወይም ጓደኛዎ ለሳምንታት በከባድ ሀዘን ወይም ጭንቀት ከተዋጡ የተሻለው እርምጃ ምንድነው?",
            "optionsEn": [
                "Reach out to a trusted counselor, youth mentor, or call toll-free hotlines 952 / 8335",
                "Keep it completely secret and hope it goes away on its own",
                "Criticize the friend for feeling sad",
                "Ignore school and stop eating"
            ],
            "optionsAm": [
                "የሚተማመኑትን አማካሪ፣ የወጣቶች አሰልጣኝ ማነጋገር ወይም በነፃ መስመሮች 952 / 8335 መደወል",
                "ሙሉ በሙሉ በሚስጥር መያዝ እና በራሱ ጊዜ ይጠፋል ብሎ ተስፋ ማድረግ",
                "ጓደኛውን በሀዘኑ ማሾፍ እና መተቸት",
                "ትምህርትን መተው እና ምግብ አለመብላት"
            ],
            "correctIndex": 0,
            "explanationEn": "Early conversations with peer mentors, counselors, or calling national hotlines (952 or 8335) provide confidential, life-saving support.",
            "explanationAm": "ከወጣቶች አማካሪዎች ጋር ቀድሞ መነጋገር ወይም በነፃ የስልክ መስመሮች (952 ወይም 8335) መደወል ሚስጥራዊ እና ህይወት አድን ድጋፍ ይሰጣል።"
        }
    ],
  },
  {
    id: "module-07",
    nameEn: "Human immune virus (HIV)/AIDS",
    nameAm: "የኤችአይቪ/ኤድስ ቫይረስ (HIV/AIDS)",
    category: "hiv",
    imageAsset: "module_07_hiv.png",
    readTimeMin: 4,
    authorName: "University of Gondar Clinical Team",
    titleEn: "Human immune virus (HIV)/AIDS",
    titleAm: "የኤችአይቪ/ኤድስ ቫይረስ (HIV/AIDS)",
    summaryEn: "HIV/AIDS is a virus that weakens the immune system, spreads mainly through unsafe sex, blood, and mother-to-child, but can be prevented with safe practices and managed effectively with early testing and treatment (ART).",
    summaryAm: "የኤችአይቪ/ኤድስ ቫይረስ የበሽታ መከላከያ ሥርዓትን የሚያዳክም ቫይረስ ሲሆን፣ በዋናነት ጥንቃቄ በጎደለው የግብረ-ሥጋ ግንኙነት፣ በደም ንክኪ እና ከእናት ወደ ልጅ ይተላለፋል፤ ነገር ግን በጥንቃቄ እርምጃዎች መከላከል እና ቀደም ብሎ በመመርመርና በህክምና (ART) በሚገባ መቆጣጠር ይቻላል።",
    doctorNoteEn: "HIV can be prevented and managed—practice safe behaviors, get tested early, and start treatment (ART) to live a healthy life and protect others.",
    doctorNoteAm: "ኤችአይቪን መከላከል እና መቆጣጠር ይቻላል—ደህንነታቸው የተጠበቁ ባህሪያትን ይለማመዱ፣ ቀድመው ይመረመሩ፣ እና ጤናማ ሕይወት ለመምራትና ሌሎችን ለመጠበቅ ሕክምና (ART) ይጀምሩ።",
    contentEn: "| Note: HIV can be prevented and managed—practice safe behaviors, get tested early, and start treatment (ART) to live a healthy life and protect others.\n\n## Defination\nWhat is HIV/AIDS and how it affects the immune system\n\nHIV (Human Immunodeficiency Virus) is a virus that attacks the body’s immune system, specifically the CD4 white blood cells (T cells) that fight off infections.\n\n- Without treatment, HIV can gradually destroy CD4 cells over time and advance to AIDS (Acquired Immunodeficiency Syndrome), which is the most advanced clinical stage of HIV infection.\n- With modern antiretroviral therapy (ART), people living with HIV suppress the virus to undetectable levels (Undetectable = Untransmittable or U=U), stay healthy, and live long, normal lives.\n\n> Clinical Tip: HIV targets CD4 cells. With modern Antiretroviral Therapy (ART), individuals maintain strong immune systems and normal lifespans.\n\n## Mode of transmission\nHow the virus spreads and debunking common myths\n\nHIV is transmitted through contact with specific body fluids from someone with a detectable viral load:\n\n- Unprotected sexual intercourse (vaginal or anal sex without condoms).\n- Sharing contaminated needles, syringes, tattoo needles, or sharp piercing instruments.\n- Mother-to-child transmission during pregnancy, childbirth, or breastfeeding (largely preventable through PMTCT care).\n- Transfusion of unscreened blood (extremely rare due to universal laboratory screening).\n- How HIV is NOT transmitted:: HIV cannot survive outside the human body. It is NOT spread through shaking hands, hugging, coughing, sneezing, sharing food or toilets, swimming pools, or mosquito/insect bites.\n\n> Clinical Tip: HIV cannot be transmitted by hugging, shaking hands, sharing cups, swimming, or breathing the same air.\n\n## HIV-Prevention\nProtecting yourself from HIV begins with understanding how the virus is spread. Some of HIV prevention methods are discussed as follows:\n\npre-exposure prophylaxis (PrEP) is HIV medicine taken to prevent the chances of getting HIV infection.. Since PrEP only protects against HIV, condom use is still important for the protection against other STI. It will be provided to people at substantial risk (high risk) of acquiring HIV. This service is available at public health facilities like Health center and Hospital.\n\nPost-exposure prophylaxis (PEP) -Given for people exposed to HIV.: PEP stands for post-exposure prophylaxis. The word “prophylaxis” means to prevent or control the spread of an infection or disease. PEP means taking HIV medicines within 72 hours (3 days) after a possible exposure to HIV to prevent HIV.\n\n- Abstinence from sex (not having sex), before marriage\n- Being faithful (Decide to one sexual partner) after testing.\n- Consistent and correct use of condom every time you have sex.\n- Not sharing sharp objects with other people and Proper use and removal of sharp objects.\n- Provision of anti-HIV treatment for pregnant women living with HIV to avoid transmission to fetus.\n- Pre-Exposure Prophylaxis- Given for people at high risk of acquiring HIV and it is given before exposure to HIV.\n\n> Clinical Tip: Post-Exposure Prophylaxis (PEP) must be initiated within 72 hours of potential exposure to prevent infection.\n\n## HIV testing\nHIV testing services refer to the full range of services that include HIV testing, counseling and linkage to appropriate HIV prevention, treatment and care. The following are HIV testing methods.\n\n- Provider Initiated Testing and Counseling (PITC):: This refers to HIV testing, and counseling recommended by a provider during a visit to a health care facility.\n- Voluntary Counseling and Testing (VCT):: VCT is initiated by clients seeking to know their HIV status.\n\n> Clinical Tip: Testing is voluntary, confidential, and rapid. Knowing your status gives you complete control over your health.\n\n## Treatment for HIV positive client\nPeople with HIV need to start taking special medicine called antiretroviral therapy, or ART, as soon as they can. This medicine helps slow down the HIV virus in their bodies. When someone takes ART, the amount of virus goes down, and their immune system gets stronger.\n\nEveryone, including children, Adolescents and adults, who have HIV should begin this treatment right after they find out they have the virus. Starting treatment early can help people live longer, stay healthier, and reduce the chances of passing HIV to others. It also helps prevent other illnesses and makes life better for those living with HIV.\n\n- ART service is available in public health facilities like Health center and Hospital.\n- Undetectable = Untransmittable (U=U): Individuals with suppressed viral loads cannot sexually transmit HIV.\n- Comprehensive adolescent peer mentorship is available at campus wellness centers.\n\n> Clinical Tip: Strict adherence to daily ART achieves viral suppression, protecting personal longevity and preventing transmission (U=U).",
    contentAm: "| ማስታወሻ: ኤችአይቪን መከላከል እና መቆጣጠር ይቻላል—ደህንነታቸው የተጠበቁ ባህሪያትን ይለማመዱ፣ ቀድመው ይመረመሩ፣ እና ጤናማ ሕይወት ለመምራትና ሌሎችን ለመጠበቅ ሕክምና (ART) ይጀምሩ።\n\n## ትርጓሜ\nኤችአይቪ/ኤድስ ምንድን ነው እና የሰውነትን በሽታ የመከላከል አቅም እንዴት ይጎዳል\n\nኤችአይቪ (የሰውነት በሽታ መከላከያ አቅም ማነስ ቫይረስ) በሰውነታችን ውስጥ ኢንፌክሽኖችን ለመዋጋት የሚረዱትን የሲዲ4 (CD4) ነጭ የደም ሴሎችን የሚያጠቃ ቫይረስ ነው።\n\n- ተገቢው ህክምና ካልተደረገለት ኤችአይቪ የሲዲ4 ሴሎችን ቀስ በቀስ በማውደም ወደ ኤድስ (የተገኘ የበሽታ መከላከያ አቅም ማጣት ደረጃ) ሊሸጋገር ይችላል።\n- በዘመናዊ የፀረ-ኤችአይቪ ህክምና (ART) አማካኝነት ቫይረሱን በደም ውስጥ እንዳይታወቅ በማድረግ ጤናማ እና ረጅም ዕድሜ መኖር ይቻላል (የማይታወቅ = የማይተላለፍ ወይም U=U)።\n\n> የዶክተር ማስታወሻ: ኤች አይ ቪ የሰውነት በሽታ መከላከያ ህዋሳትን የሚያጠቃ ሲሆን በመድኃኒት (ART) በመታገዝ ረጅም እና ጤናማ ህይወት መኖር ይቻላል።\n\n## የመተላለፊያ መንገዶች\nቫይረሱ እንዴት ይተላለፋል እና የተሳሳቱ ግንዛቤዎች ማስተካከያ\n\nኤችአይቪ የሚተላለፈው ቫይረሱ በደሙ ውስጥ ካለ ሰው የሰውነት ፈሳሾች ጋር በሚኖር ቀጥተኛ ንክኪ ነው፦\n\n- ጥንቃቄ የጎደለው የግብረ-ሥጋ ግንኙነት (ያለ ኮንዶም የሚደረግ ግንኙነት)።\n- የተበከሉ መርፌዎችን፣ ምላጮችን እና ስለታም የመበሻ ቁሳቁሶችን በጋራ መጠቀም።\n- ከእናት ወደ ልጅ በእርግዝና፣ በወሊድ ወይም በማጥባት ወቅት (በቅድመ-ወሊድ PMTCT ክትትል ሙሉ በሙሉ መከላከል ይቻላል)።\n- ያልተመረመረ ደም በመውሰድ (በሆስፒታሎች ጥብቅ ምርመራ ምክንያት እጅግ በጣም ያልተለመደ ነው)።\n- ኤችአይቪ በማይተላለፍባቸው መንገዶች፦: ኤችአይቪ ከሰውነት ውጭ ሊቆይ አይችልም። በእጅ መጨባበጥ፣ ማቀፍ፣ ሳል፣ ማስነጠስ፣ መጸዳጃ ቤት ወይም የምግብ ዕቃዎችን በጋራ በመጠቀም እንዲሁም በወባ ትንኝ ንክሻ ፈጽሞ አይተላለፍም።\n\n> የዶክተር ማስታወሻ: ኤች አይ ቪ በመጨባበጥ፣ በአብሮ መብላት ወይም በመተቃቀፍ ፈጽሞ አይተላለፍም።\n\n## የኤችአይቪ መከላከያ መንገዶች\nራስን ከኤችአይቪ መጠበቅ ቫይረሱ እንዴት እንደሚተላለፍ ከመረዳት ይጀምራል። አንዳንድ የኤችአይቪ መከላከያ ዘዴዎች እንደሚከተለው ተብራርተዋል፦\n\nየቅድመ-ተጋላጭነት መከላከያ መድሃኒት (PrEP) የኤችአይቪ ኢንፌክሽን ተጋላጭነትን ለመቀነስ የሚወሰድ መድሃኒት ነው። PrEP የሚከላከለው ከኤችአይቪ ብቻ ስለሆነ፣ ከሌሎች አባለዘር በሽታዎች ለመከላከል የኮንዶም አጠቃቀም አሁንም አስፈላጊ ነው። ለኤችአይቪ ከፍተኛ ተጋላጭ ለሆኑ ሰዎች ይሰጣል። ይህ አገልግሎት በጤና ጣቢያዎችና በሆስፒታሎች ባሉ የመንግስት ጤና ተቋማት ውስጥ ይገኛል።\n\nድህረ-ተጋላጭነት መከላከያ መድሃኒት (PEP) -ለኤችአይቪ ተጋላጭ ለሆኑ ሰዎች የሚሰጥ።: PEP ማለት ከኤችአይቪ ቫይረስ ጋር ንክኪ ከተፈጠረ በኋላ ቫይረሱ በሰውነት ውስጥ እንዳይሰራጭ የሚሰጥ ድንገተኛ መከላከያ ነው። PEP መውሰድ ያለበት ተጋላጭነቱ በተፈጠረ በ72 ሰዓታት (3 ቀናት) ውስጥ ነው።\n\n- ከጋብቻ በፊት ከግብረ-ሥጋ ግንኙነት መታቀብ (ግንኙነት አለማድረግ)\n- ከተመረመሩ በኋላ ለአንድ የፍቅር አጋር ብቻ ታማኝ መሆን።\n- በማንኛውም ጊዜ በሚደረግ የግብረ-ሥጋ ግንኙነት ኮንዶምን ዘወትርና በትክክል መጠቀም።\n- ስለታም ቁሳቁሶችን ከሌሎች ሰዎች ጋር አለመጋራት እንዲሁም በአግባቡ መጠቀምና ማስወገድ።\n- ቫይረሱ ወደ ፅንሱ እንዳይተላለፍ ኤችአይቪ በደማቸው ለሚገኝ ነፍሰጡር እናቶች የፀረ-ኤችአይቪ ህክምና መስጠት።\n- የቅድመ-ተጋላጭነት መከላከያ መድሃኒት (PrEP) - ለኤችአይቪ ከፍተኛ ተጋላጭ ለሆኑ ሰዎች የሚሰጥ ሲሆን ለቫይረሱ ከመጋለጣቸው በፊት ይሰጣል።\n\n> የዶክተር ማስታወሻ: የአደጋ ጊዜ መከላከያ መድኃኒት (PEP) ከተጋለጡበት ጊዜ ጀምሮ በ72 ሰዓታት ውስጥ መወሰድ አለበት።\n\n## የኤችአይቪ ምርመራ\nየኤችአይቪ ምርመራ አገልግሎት የምክር፣ የምርመራ እንዲሁም ከተገቢው የኤችአይቪ መከላከያ፣ ህክምና እና ክብካቤ ጋር የማስተሳሰር ሙሉ አገልግሎትን ያጠቃልላል። የሚከተሉት የኤችአይቪ ምርመራ ዘዴዎች ናቸው።\n\n- በጤና ባለሙያ የሚመከር ምርመራ እና ምክር (PITC)፦: ወደ ጤና ተቋም በሚደረግ ጉብኝት ወቅት በጤና ባለሙያ የሚመከር እና የሚሰጥ የኤችአይቪ ምርመራ እና የምክር አገልግሎት ነው።\n- በፈቃደኝነት ላይ የተመሰረተ የምክር እና ምርመራ አገልግሎት (VCT)፦: ግለሰቦች የኤችአይቪ የጤና ሁኔታቸውን ለማወቅ በራሳቸው ፍላጎት የሚያደርጉት ምርመራ ነው።\n\n> የዶክተር ማስታወሻ: ምርመራ በፈቃደኝነት ላይ የተመሰረተና ሚስጥራዊነቱ የተጠበቀ ነው፤ ሁኔታዎን ቀድመው ማወቅ ህይወትን ያድናል።\n\n## ኤችአይቪ በደማቸው ለሚገኝባቸው የሚሰጥ ህክምና\nኤችአይቪ በደማቸው የሚገኝባቸው ሰዎች የፀረ-ኤችአይቪ መድሃኒት (ART) በተቻለ ፍጥነት መጀመር አለባቸው። ይህ መድሃኒት ቫይረሱ በሰውነታቸው ውስጥ እንዳይባዛ ያደርጋል። አንድ ሰው ART ሲወስድ የቫይረሱ መጠን ይቀንሳል እንዲሁም የበሽታ መከላከል አቅማቸው ይጠነክራል።\n\nህፃናትን፣ ወጣቶችን እና አዋቂዎችን ጨምሮ ቫይረሱ ያለባቸው ሰዎች በሙሉ ውጤቱን ባወቁ ቅጽበት ህክምናውን መጀመር አለባቸው። ህክምናውን ቀድሞ መጀመር ረጅም እድሜ እንዲኖሩ፣ ጤናማ እንዲሆኑ እና ቫይረሱ ወደ ሌሎች እንዳይተላለፍ ይረዳል። ሌሎች ተጓዳኝ በሽታዎችንም ይከላከላል።\n\n- የ ART አገልግሎት እንደ ጤና ጣቢያ እና ሆስፒታል ባሉ የመንግስት ጤና ተቋማት ውስጥ በነጻ ይሰጣል።\n- የቫይረሱ መጠን በሰውነት ውስጥ ሲቀንስ ወደ ሌላ ሰው የመተላለፍ እድሉ ዜሮ ይሆናል (U=U)።\n- የአቻ ለአቻ አማካሪዎች በዩኒቨርሲቲ ክሊኒኮች ውስጥ ቀጣይነት ያለው ድጋፍ ይሰጣሉ።\n\n> የዶክተር ማስታወሻ: መድኃኒትን በአግባቡ መውሰድ የቫይረሱን መጠን በመቀነስ ጤናማና ፍሬያማ ኑሮ ለመኖር ያስችላል።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "HIV infects and destroys cells of human immune system, making it hard to fight other diseases?",
            "questionAm": "ኤችአይቪ የሰውነትን በሽታ የመከላከል አቅም (ሲዲ4 ሴሎችን) በማጥቃት ሌሎች ኢንፌክሽኖችን ለመዋጋት አስቸጋሪ ያደርጋል?",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "HIV targets CD4 white blood cells. Without ART treatment, the body loses its natural defenses against opportunistic infections.",
            "explanationAm": "ኤችአይቪ የሲዲ4 ነጭ የደም ሴሎችን ያጠቃል። ያለ ፀረ-ኤችአይቪ ህክምና ሰውነት ኢንፌክሽኖችን መዋጋት ይሳነዋል።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Which of the following is/are correct about mode of HIV transmission?",
            "questionAm": "ከሚከተሉት ውስጥ ስለ ኤችአይቪ መተላለፊያ መንገዶች ትክክል የሆነው የትኛው ነው?",
            "optionsEn": [
                "Unprotected sexual practice",
                "HIV positive mother to their fetus or child",
                "Eating together",
                "A & B"
            ],
            "optionsAm": [
                "ጥንቃቄ የጎደለው የግብረ-ሥጋ ግንኙነት",
                "ኤችአይቪ በደሟ ያለ እናት ወደ ፅንስ ወይም ህፃን",
                "አብሮ መመገብ",
                "ሀ እና ለ"
            ],
            "correctIndex": 3,
            "explanationEn": "HIV spreads through specific body fluids (unprotected sex and mother-to-child), but cannot be spread through casual contact like sharing food.",
            "explanationAm": "ኤችአይቪ የሚተላለፈው በግብረ-ሥጋ ግንኙነት እና ከእናት ወደ ልጅ ነው፤ ነገር ግን ምግብ በመጋራት ፈጽሞ አይተላለፍም።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Within how many hours must Post-Exposure Prophylaxis (PEP) be started after possible exposure to HIV?",
            "questionAm": "ለኤችአይቪ ከተጋለጡ በኋላ ድንገተኛ መከላከያ መድሃኒት (PEP) በስንት ሰዓታት ውስጥ መጀመር አለበት?",
            "optionsEn": [
                "Within 24 hours only",
                "Within 72 hours (3 days)",
                "Within 1 month",
                "PEP is only taken before exposure"
            ],
            "optionsAm": [
                "በ24 ሰዓታት ውስጥ ብቻ",
                "በ72 ሰዓታት (3 ቀናት) ውስጥ",
                "በ1 ወር ውስጥ",
                "PEP የሚወሰደው ከመጋለጥ በፊት ብቻ ነው"
            ],
            "correctIndex": 1,
            "explanationEn": "PEP is an emergency medication course that must begin strictly within 72 hours of potential exposure to prevent infection.",
            "explanationAm": "PEP ለቫይረሱ ከተጋለጡ በኋላ በ72 ሰዓታት ውስጥ መጀመር ያለበት የድንገተኛ ጊዜ መድሃኒት ነው።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "When a person with HIV takes ART and reaches an undetectable viral load, they cannot transmit the virus sexually (Undetectable = Untransmittable / U=U).",
            "questionAm": "ኤችአይቪ በደማቸው ያለባቸው ሰዎች የ ART ህክምና ወስደው የቫይረሱ መጠን እንዳይታወቅ ሲሆን (Undetectable) ቫይረሱ በግብረ-ሥጋ ግንኙነት አይተላለፍም (U=U)።",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Decades of evidence confirm Undetectable = Untransmittable (U=U). Regular ART adherence keeps people healthy and prevents transmission.",
            "explanationAm": "የተረጋገጠ ሳይንሳዊ ማስረጃ እንደሚያሳየው የማይታወቅ = የማይተላለፍ (U=U) ነው። ART መውሰድ ጤናን ከመጠበቅ ባለፈ ቫይረሱ እንዳይተላለፍ ያደርጋል።"
        }
    ],
  },
  {
    id: "module-08",
    nameEn: "Substance Abuse",
    nameAm: "የዕፅ ሱስ እና አላግባብ መጠቀም",
    category: "substance",
    imageAsset: "module_08_substance_abuse.png",
    readTimeMin: 4,
    authorName: "National Youth Addiction Recovery Network",
    titleEn: "Substance Abuse",
    titleAm: "የዕፅ ሱስ እና አላግባብ መጠቀም",
    summaryEn: "Substance abuse is the harmful use of drugs or alcohol that affects health, behavior, and relationships, leading to physical and mental problems, dependency, and serious life consequences if not addressed early.",
    summaryAm: "የዕፅ ሱስ ማለት ጤናን፣ ባህሪን እና ማህበራዊ ግንኙነቶችን የሚጎዳ ጎጂ የመድሃኒት ወይም የአልኮል አጠቃቀም ሲሆን ወደ አካላዊ እና አእምሯዊ ችግሮች፣ ጥገኝነት እና በወቅቱ ካልተፈታ ወደ ከባድ የህይወት አደጋዎች ይመራል።",
    doctorNoteEn: "Substance abuse is preventable and treatable—recognizing early signs and seeking help can protect your health, relationships, and future.",
    doctorNoteAm: "የዕፅ ሱስ መከላከል እና መታከም የሚችል ነው—ቀደምት ምልክቶችን መገንዘብ እና እርዳታ መፈለግ ጤናዎን፣ ግንኙነትዎን እና የወደፊት ህይወትዎን ሊጠብቅ ይችላል።",
    contentEn: "| Note: Substance abuse is preventable and treatable—recognizing early signs and seeking help can protect your health, relationships, and future.\n\n## Definition of substance abuse\nSubstance abuse refers to the harmful or hazardous use of psychoactive substances, including alcohol and illicit drugs, characterized by a compulsive pattern of consumption. This behavior often leads to significant adverse consequences in various aspects of an individual's life, such as health, relationships, and social responsibilities. It can result in physical and psychological dependence, tolerance, and withdrawal symptoms.\n\nPsychoactive substance is a drug or other substance that affects how the brain works and causes changes in mood, awareness, thoughts, feelings, or behavior. The commonly used psychoactive substances include alcohol, caffeine, nicotine, marijuana, and certain pain medicines.\n\n- Substance use disorder (SUD) is a mental disorder that affects a person's brain and behavior, leading to a person's inability to control their use of substances such as legal or illegal drugs, alcohol, or medications. A substance use disorder involves using too much alcohol, tobacco or other drugs.\n\n> Clinical Tip: Substance use disorder is a treatable medical condition involving neurochemical adaptation, not a moral flaw.\n\n## Types of drugs/Substances\nSubstances act on neurotransmitters and the central nervous system across different categories:\n\n- Depressants: - the most commonly found types of drugs in society are depressants. Alcohol, Sedatives/hypnotics.\n- Stimulants: - Increase energy, alertness, and wakefulness. Such as Nicotine, Cocaine, Amphetamines and Caffeine.\n- Opioids: - These are pain-killing drugs that increase feelings of happiness or euphoria and create a tranquilizing effect. Heroin, morphine, opium, buprenorphine, methadone, pethidine and Cough syrup with codeine.\n- Hallucinogens: - They can also cause a person to perceive time differently, feel detached from their surroundings, or feel deeply insightful.\n\n> Clinical Tip: Combining stimulants (like Khat) with depressants (like alcohol) strains cardiac function and accelerates psychological dependence.\n\n## Effects of substance abuse\nSubstance abuse refers to a pattern of using drugs or alcohol that leads to significant problems or distress in an individual's life. This can manifest in various ways, including:\n\n- Increased risk of disease (Liver diseases, heart diseases, respiratory problems, HIV)\n- Mental health disorder increased risk of anxiety, depression etc.\n- Missing work or school due to substance use.\n- Engaging in dangerous activities while under the influence, such as driving.\n- Experiencing legal issues related to substance use.\n- Strained relationships with family and friends due to ongoing substance use.\n- Substance abuse can involve both illegal drugs (like heroin, cocaine, and methamphetamine) and the misuse of prescription drugs or legal substances.\n\n> Clinical Tip: Tolerance occurs when the brain adapts to regular substance consumption, requiring increasingly larger doses.\n\n## Signs of a Substance Use Problem\nRecognizing early behavioral and physical indicators helps individuals get timely care before severe complications arise:\n\n- Compulsive cravings: Intense urges to consume the substance daily or multiple times a day.\n- Developing tolerance: Needing larger amounts over time to produce the initial desired effect.\n- Withdrawal symptoms: Experiencing restlessness, tremors, sweating, anxiety, or nausea when attempting to stop.\n- Neglecting responsibilities: Falling behind in school performance, missing work shifts, or ignoring family duties.\n- Abandoning interests: Giving up sports, creative hobbies, and social activities once enjoyed.\n- Social withdrawal and secretive behavior: Withdrawing from family gatherings, hiding substance use, or drastic personality shifts.\n\n> Clinical Tip: Substance use disorder is a treatable health condition, not a sign of moral weakness. Youth mentors, counseling facilities, and national toll-free hotlines (952 or 8335) provide confidential, compassionate assistance.",
    contentAm: "| ማስታወሻ: የዕፅ ሱስ መከላከል እና መታከም የሚችል ነው—ቀደምት ምልክቶችን መገንዘብ እና እርዳታ መፈለግ ጤናዎን፣ ግንኙነትዎን እና የወደፊት ህይወትዎን ሊጠብቅ ይችላል።\n\n## የዕፅ ሱስ ምንነት እና ትርጓሜ\nየዕፅ ሱስ ማለት አልኮልን እና ህገ-ወጥ እፆችን ጨምሮ በአእምሮ ላይ ተፅዕኖ የሚያሳድሩ ንጥረ ነገሮችን ከመጠን በላይ እና ጎጂ በሆነ መንገድ በግዴታ የመጠቀም ልምድ ነው። ይህ ባህሪ በግለሰብ ጤና፣ ማህበራዊ ግንኙነት እና ሀላፊነቶች ላይ ከፍተኛ አሉታዊ ተፅዕኖ ያሳድራል። ወደ አካላዊ እና ስነ-ልቦናዊ ጥገኝነት፣ የመላመድ እና መድሃኒቱን ሲያቆሙ ወደሚከሰቱ የህመም ስሜቶች ይመራል።\n\nበአእምሮ ላይ ተፅዕኖ የሚያሳድሩ ንጥረ ነገሮች (ሳይኮአክቲቭ) የአእምሮን አሰራር በመቀየር በስሜት፣ በንቃት፣ በአስተሳሰብ ወይም በባህሪ ላይ ለውጥ የሚያመጡ ናቸው። በብዛት ጥቅም ላይ የሚውሉት አልኮል፣ ካፌይን፣ ኒኮቲን፣ ማሪዋና (ካናቢስ) እና የተወሰኑ የህመም ማስታገሻ መድሃኒቶችን ያካትታሉ።\n\n- የዕፅ አጠቃቀም ችግር (SUD) የአንድን ሰው አእምሮ እና ባህሪ የሚጎዳ የአእምሮ ጤና እክል ሲሆን ይህም ሰውዬው ህጋዊ ወይም ህገ-ወጥ እፆችን፣ አልኮልን ወይም መድሃኒቶችን እንዳይቆጣጠር ያደርገዋል።\n\n> የዶክተር ማስታወሻ: የሱስ ችግር የህክምና እርዳታ የሚያስፈልገው የአእምሮ ጤና ሁኔታ እንጂ የግብረ-ገብነት ድክመት አይደለም።\n\n## የእፅ እና ንጥረ ነገሮች ዓይነቶች\nአደንዛዥ እጾች በአሰራራቸውና በማዕከላዊ የነርቭ ሥርዓት ላይ በሚያሳድሩት ተፅዕኖ በተለያዩ ክፍሎች ይከፈላሉ፡\n\n- አእምሮን የሚያዘገዩ (ዲፕሬሰንትስ)፦ በማህበረሰቡ ውስጥ በብዛት የሚገኙት ዲፕሬሰንትስ ናቸው። አልኮል፣ ማስታገሻዎች እና እንቅልፍ አምጪ መድሃኒቶች።\n- አነቃቂዎች (ስቲሙላንትስ)፦ ጉልበትን፣ ንቃትን እና እንቅልፍ ማጣትን ይጨምራሉ። እንደ ኒኮቲን (ሲጋራ)፣ ኮኬይን፣ አምፌታሚን እና ካፌይን።\n- ኦፒዮይድስ (ህመም ማስታገሻዎች)፦ የደስታ ወይም የርካታ ስሜትን የሚፈጥሩ እና ከፍተኛ የህመም ማስታገሻ ውጤት ያላቸው ናቸው። ሄሮይን፣ ሞርፊን፣ ኦፒየም፣ ሜታዶን እና ኮዲን ያለበት የሳል ሽሮፕ።\n- ቅዠት አምጪዎች (ሃሉሲኖጅንስ)፦ አንድ ሰው ጊዜን በተለየ መንገድ እንዲገነዘብ፣ ከአካባቢው የተነጠለ ስሜት እንዲሰማው ወይም ምናባዊ ነገሮችን እንዲያይ ያደርጋሉ።\n\n> የዶክተር ማስታወሻ: ጫትና አልኮልን አጣምሮ መውሰድ የልብ ምትን በማዛባትና በአእምሮ ላይ ከባድ ጫና በማሳደር ለከፍተኛ ሱስ ያጋልጣል።\n\n## የዕፅ ሱስ የሚያስከትላቸው ጉዳቶች\nየዕፅ ሱስ በአንድ ሰው ህይወት ውስጥ ወደ ከባድ ችግሮች ወይም ጭንቀት የሚመራ የእፅ ወይም የአልኮል አጠቃቀም ልምድ ነው። ይህም በተለያዩ መንገዶች ይገለጻል፦\n\n- ለበሽታዎች የመጋለጥ እድል መጨመር (የጉበት በሽታ፣ የልብ ህመም፣ የመተንፈሻ አካላት ችግር፣ ኤችአይቪ)\n- የአእምሮ ጤና መታወክ፣ ለጭንቀት እና ድብርት የመጋለጥ እድል መጨመር።\n- በእፅ አጠቃቀም ምክንያት ትምህርት ወይም ስራ መቅረት።\n- በእፅ ተፅዕኖ ስር ሆነው አደገኛ እንቅስቃሴዎች ውስጥ መሳተፍ (ለምሳሌ መኪና መንዳት)።\n- ከእፅ አጠቃቀም ጋር የተያያዙ ህጋዊ ችግሮች እና ቅጣቶች ማጋጠም።\n- ከቤተሰብ እና ከጓደኞች ጋር የሚኖር ግንኙነት መበላሸት እና አለመግባባት።\n- የዕፅ ሱስ ህገ-ወጥ እፆችን (እንደ ሄሮይን፣ ኮኬይን) እንዲሁም የታዘዙ መድሃኒቶችን አላግባብ መጠቀምን ያካትታል።\n\n> የዶክተር ማስታወሻ: የመላመድ (Tolerance) ባህሪ ሲከሰት ሰውነታችን ተጨማሪ መጠን እንዲፈልግ ስለሚያደርገው ሱስን ያባብሳል።\n\n## የዕፅ ሱስ ችግር መኖሩን የሚያሳዩ ምልክቶች\nየባህሪ እና የአካላዊ ለውጦችን ቀድሞ መገንዘብ ግለሰቦች ከባድ ችግሮች ከመከሰታቸው በፊት ወቅታዊ እርዳታ እንዲያገኙ ይረዳል፦\n\n- የግዴታ ፍላጎት፦ ንጥረ ነገሩን በየቀኑ ወይም በቀን ውስጥ ብዙ ጊዜ ለመጠቀም የሚሰማ ከፍተኛ ጉጉት።\n- የመላመድ ሁኔታ፦ መጀመሪያ የተገኘውን ስሜት ለማግኘት ከጊዜ ወደ ጊዜ መጠኑን መጨመር ማስፈለግ።\n- መድሃኒቱን ሲያቆሙ የሚከሰት ህመም፦ እፁን ለማቆም ሲሞክሩ መንቀጥቀጥ፣ ላብ፣ ጭንቀት ወይም ማቅለሽለሽ ማጋጠም።\n- ሀላፊነትን መዘንጋት፦ በትምህርት፣ በስራ ወይም በቤተሰብ ውስጥ ያሉ ሀላፊነቶችን መወጣት አለመቻል።\n- ፍላጎቶችን መተው፦ ቀደም ሲል ያስደስቱ የነበሩ ስፖርቶችን፣ የትርፍ ጊዜ ማሳለፊያዎችን እና ማህበራዊ ግንኙነቶችን መተው።\n- ማህበራዊ መገለል እና ድብቅነት፦ ከቤተሰብ መራቅ፣ እፅን በሚስጥር መጠቀም እና ድንገተኛ የስሜት መለዋወጥ ማሳየት።\n\n> የዶክተር ማስታወሻ: የዕፅ አጠቃቀም ችግር የሚታከም የጤና ሁኔታ እንጂ የሞራል ድክመት አይደለም። የወጣቶች አማካሪዎች፣ የጤና ማዕከላት እና ነፃ የስልክ መስመሮች (952 ወይም 8335) ሚስጥራዊ እና ሩህሩህ ድጋፍ ይሰጣሉ።",
    questions: [
        {
            "type": "TRUE_FALSE",
            "questionEn": "Is substance use disorder (SUD) a treatable medical condition affecting the brain and behavior, rather than a failure of willpower or personal morality?",
            "questionAm": "የዕፅ ሱስ ወይም የአደንዛዥ ዕፅ ሱሰኝነት የፈቃድ ደካማነት ወይም የሞራል ውድቀት ሳይሆን ህክምና የሚደረግለት የአዕምሮ እና የባህሪ የህክምና ሁኔታ ነው?",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Substance use disorders alter brain chemistry and neural reward pathways. Recognized by medical authorities worldwide, recovery is achievable through evidence-based treatment, counseling, and social support.",
            "explanationAm": "የዕፅ ሱሰኝነት በአዕምሮ ኬሚስትሪ እና ሽልማት መቀበያ መንገዶች ላይ ለውጥ ያመጣል። በህክምና ባለሙያዎች ዘንድ እውቅና የተሰጠው ሲሆን በህክምና፣ በምክር እና በማህበራዊ ድጋፍ ማገገም ይቻላል።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "Which category of substances slows down central nervous system function, heart rate, and brain activity (such as alcohol and sedatives)?",
            "questionAm": "ማዕከላዊ የነርቭ ሥርዓትን፣ የልብ ምትን እና የአዕምሮ እንቅስቃሴን የሚያዘገየው የዕፅ ክፍል የትኛው ነው (እንደ አልኮል እና ማረጋጊያ መድሃኒቶች)?",
            "optionsEn": [
                "Depressants",
                "Stimulants",
                "Hallucinogens",
                "Vitamins"
            ],
            "optionsAm": [
                "አዘግይ/አረጋጊዎች (Depressants)",
                "አነቃቂዎች (Stimulants)",
                "ቅዠት አምጪዎች (Hallucinogens)",
                "ቫይታሚኖች (Vitamins)"
            ],
            "correctIndex": 0,
            "explanationEn": "Depressants slow down neural messaging and heart rate, leading to reduced alertness and relaxation. In contrast, stimulants speed up the nervous system.",
            "explanationAm": "አዘግይ/አረጋጊዎች የነርቭ መልእክቶችን እና የልብ ምትን በማዘግየት ንቃትን ይቀንሳሉ፤ በተቃራኒው አነቃቂዎች የነርቭ ስርዓትን ያፋጥናሉ።"
        },
        {
            "type": "MULTIPLE_CHOICE",
            "questionEn": "What does developing \"tolerance\" mean when someone regularly consumes drugs or alcohol?",
            "questionAm": "አንድ ሰው አልኮልን ወይም አደንዛዥ ዕፆችን አዘውትሮ ሲጠቀም \"ቶለራንስ (መላመድ)\" ማለት ምን ማለት ነው?",
            "optionsEn": [
                "The body needs increasingly larger amounts over time to produce the initial desired effect",
                "The substance permanently leaves the body after a single use",
                "The person can immediately stop taking the substance with zero symptoms",
                "Having a complete natural immunity to all chemicals"
            ],
            "optionsAm": [
                "የመጀመሪያውን ስሜት ለማግኘት በጊዜ ሂደት መጠኑን በከፍተኛ ሁኔታ መጨመር ማስፈለጉ",
                "ዕፁ ከአንድ አጠቃቀም በኋላ ከሰውነት ሙሉ በሙሉ መወገዱ",
                "ሰውየው ያለ ምንም ምልክት ወዲያውኑ መጠቀም ማቆም መቻሉ",
                "ለማንኛውም ኬሚካል ተፈጥሯዊ የመከላከል አቅም መኖር"
            ],
            "correctIndex": 0,
            "explanationEn": "Tolerance occurs when cells and brain receptors adapt to regular substance exposure, leading people to consume higher doses to feel the original impact.",
            "explanationAm": "መላመድ (Tolerance) የሚከሰተው የአዕምሮ ህዋሳት ከአደንዛዥ ዕፁ ጋር ሲላመዱ ሲሆን ይህም ተጠቃሚው የቀድሞውን ስሜት ለማግኘት መጠኑን እንዲጨምር ያደርገዋል።"
        },
        {
            "type": "TRUE_FALSE",
            "questionEn": "Substance abuse is both preventable and treatable, and free national health hotlines (952 or 8335) provide confidential, judgment-free support?",
            "questionAm": "የአደንዛዥ ዕፅ ሱስ መከላከል እና ማከም የሚቻል ሲሆን ነፃ የጤና ስልክ መስመሮችን (952 ወይም 8335) መደወል ወጣቶችን ከሚስጥራዊ የባለሙያ ድጋፍ ጋር ያገናኛል?",
            "optionsEn": [
                "True",
                "False"
            ],
            "optionsAm": [
                "እውነት",
                "ሐሰት"
            ],
            "correctIndex": 0,
            "explanationEn": "Early intervention saves lives. Confidential health hotlines (952 or 8335) connect youth with empathetic professionals, referrals to youth-friendly centers, and recovery guidance.",
            "explanationAm": "በጊዜ የሚደረግ ድጋፍ ህይወትን ይታደጋል። ነፃ የጤና ስልክ መስመሮች (952 ወይም 8335) ወጣቶችን ከተቆረቋሪ ባለሙያዎች፣ ከወጣቶች ማዕከላት እና ከማገገሚያ መመሪያዎች ጋር ያገናኛሉ።"
        }
    ],
  },
  {
    id: 'template_blank',
    nameEn: 'Blank Health Curriculum Scaffold',
    nameAm: 'ባዶ የጤና ትምህርት ማዕቀፍ',
    category: 'custom',
    imageAsset: 'module_01_puberty.jpg',
    readTimeMin: 4,
    authorName: 'Yegna Health Clinical Team',
    titleEn: 'New Health Curriculum Module',
    titleAm: 'አዲስ የጤና ትምህርት ሞጁል',
    summaryEn: 'A clear, evidence-based health overview for university students and adolescents.',
    summaryAm: 'ለዩኒቨርሲቲ ተማሪዎችና ታዳጊዎች የተዘጋጀ በማስረጃ ላይ የተመሰረተ የጤና ትምህርት።',
    doctorNoteEn: 'Every adolescent develops at their own unique pace—listening to bodily changes and practicing safe self-care ensures healthy transitions.',
    doctorNoteAm: 'እያንዳንዱ ታዳጊ በራሱ የተፈጥሮ ፍጥነት ያድጋል—የሰውነት ለውጦችን ማስተዋልና ራስን መንከባከብ ለጤናማ እድገት ወሳኝ ናቸው።',
    contentEn: `## Section 1: Overview & Biological Foundations\nExplain bodily processes and youth emotional well-being clearly.\n- Core Biological Insight 1\n- Core Biological Insight 2\n> Clinical Tip: Reassuring advice on normal growth and health.\n\n## Section 2: Prevention & Daily Self-Care\nActionable steps students can take in their daily campus lives.\n- Practical Step 1\n- Practical Step 2\n> Clinical Tip: Healthy lifestyle recommendation.`,
    contentAm: `## ክፍል 1፡ መግቢያና አጠቃላይ እይታ\nሳይንሳዊ የጤና መረጃዎችንና መሰረታዊ ነጥቦችን እዚህ ያብራሩ።\n- ዋና የህክምና ነጥብ 1\n- ዋና የህክምና ነጥብ 2\n> የዶክተር ማስታወሻ፡ ለተማሪዎች የሚሰጥ ተግባራዊ ምክር።\n\n## ክፍል 2፡ መከላከያና የዕለት ተዕለት እንክብካቤ\nተማሪዎች በግቢ ቆይታቸው ሊተገብሯቸው የሚገቡ ተግባራዊ እርምጃዎች።\n- ተግባራዊ እርምጃ 1\n- ተግባራዊ እርምጃ 2\n> የዶክተር ማስታወሻ፡ ጤናማ የአኗኗር ዘይቤ ምክር።`,
    questions: [
      {
        type: 'TRUE_FALSE',
        questionEn: 'Adolescent health decisions have a direct impact on lifelong vitality.',
        questionAm: 'በጉርምስና ወቅት የሚደረጉ የጤና ውሳኔዎች ለቀጣይ ህይወት ጤና ወሳኝ ሚና አላቸው።',
        optionsEn: ['True', 'False'],
        optionsAm: ['እውነት', 'ሀሰት'],
        correctIndex: 0,
        explanationEn: 'Healthy routines adopted during youth build lasting protection against chronic illness.',
        explanationAm: 'በወጣትነት የሚዳብሩ ጤናማ ልማዶች በቀጣይ ህይወት በሽታዎችን ለመከላከል ይረዳሉ።',
      },
    ],
  },
];
