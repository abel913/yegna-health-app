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

export const CURRICULUM_TEMPLATES: CurriculumTemplate[] = [
  {
    id: 'template_puberty',
    nameEn: 'Adolescent Health & Puberty',
    nameAm: 'የጉርምስና ወቅትና የአካል ለውጦች',
    category: 'puberty',
    imageAsset: 'assets/images/learning/module_01_puberty.jpg',
    readTimeMin: 4,
    authorName: 'Dr. Hanna Bekele, Adolescent Specialist',
    titleEn: 'Adolescent health & puberty',
    titleAm: 'የጉርምስና ወቅትና አካላዊ ለውጦች',
    summaryEn:
      'Puberty is a natural transition from childhood into adulthood, characterized by physical, hormonal, and emotional changes that shape personal growth and health.',
    summaryAm:
      'የጉርምስና ወቅት ከልጅነት ወደ አዋቂነት የሚደረግ ተፈጥሯዊ ሽግግር ሲሆን አካላዊ፣ ሆርሞናዊና ስሜታዊ ለውጦች የሚከሰቱበት የህይወት ምዕራፍ ነው።',
    doctorNoteEn:
      'Every adolescent experiences puberty at their own unique pace—practicing good hygiene, understanding bodily changes, and embracing self-confidence helps ensure a healthy transition.',
    doctorNoteAm:
      'እያንዳንዱ ታዳጊ በራሱ ተፈጥሯዊ ፍጥነት ያድጋል፤ ንፅህናን መጠበቅ፣ የአካል ለውጦችን መረዳትና በራስ መተማመንን ማዳበር ጤናማ ሽግግርን ያረጋግጣል።',
    contentEn: `## Understanding Puberty & Adolescence
Puberty is triggered by hormonal signals sent from the brain to the reproductive glands. It marks the commencement of sexual maturation and adult physiological capability.
- Biological variation: Onset ranges between ages 9–14 for girls and 10–15 for boys.
- Hormonal drivers: Estrogen and testosterone govern physical transitions.
- Individual timeline: Fast growth spurts or gradual transitions are equally healthy and normal.
> Clinical Tip: Never compare your growth rate with classmates; genetics dictate your timeline.

## Physical Changes in Females & Males
Both sexes experience marked physical transformations tailored for adulthood.
- Female development: Breast development, widening of hips, and onset of menarche (menstruation).
- Male development: Deepening of voice, enlargement of larynx (Adam's apple), and facial hair emergence.
- Shared changes: Underarm and pubic hair growth, active sweat glands, and oil production leading to acne.
> Clinical Tip: Wash your face twice daily with mild soap to manage skin oil balance.

## Emotional & Psychological Growth
Brain remodeling during adolescence causes shifts in emotions, independence, and social dynamics.
- Mood fluctuations: Shifting hormone levels can lead to temporary emotional sensitivity.
- Identity formation: Seeking greater autonomy and defining personal values.
- Peer belonging: Increased desire for meaningful friendship connections.
> Clinical Tip: Speaking with a trusted campus mentor helps process new feelings without judgment.

## Hygiene & Self-Care Best Practices
Daily personal care routines prevent infections and foster physical comfort and dignity.
- Daily bathing: Regular washing prevents body odor from active apocrine sweat glands.
- Menstrual hygiene: Change pads every 4 to 6 hours and wash hands thoroughly.
- Sleep & Nutrition: 8–9 hours of sleep paired with balanced Ethiopian grains, legumes, and water.
> Clinical Tip: Carry personal hygiene essentials discreetly in your backpack for campus comfort.`,
    contentAm: `## የጉርምስና ወቅትና ሽግግርን መረዳት
የጉርምስና ወቅት ከአንጎል ወደ ተዋልዶ አካላት በሚተላለፉ የሆርሞን መልዕክቶች የሚቀሰቀስ ተፈጥሯዊ ሂደት ነው።
- ተፈጥሯዊ ልዩነት፡ በሴቶች ከ9–14 ዓመት፣ በወንዶች ከ10–15 ዓመት ዕድሜ ውስጥ ይጀምራል።
- የሆርሞኖች ሚና፡ ኢስትሮጅን እና ቴስቶስትሮን ዋና ዋና ለውጦችን ይመራሉ።
- የግል የእድገት ፍጥነት፡ ፈጣን ወይም ረጋ ያለ እድገት ሁለቱም ፍጹም ጤናማ ናቸው።
> የዶክተር ማስታወሻ፡ የእድገትዎን ፍጥነት ከጓደኞችዎ ጋር አያወዳድሩ፤ የተፈጥሮ ዘረመል የራሱን ጊዜ ይከተላል።

## በሴቶችና በወንዶች ላይ የሚታዩ አካላዊ ለውጦች
ሁለቱም ጾታዎች ወደ አዋቂነት የሚያሸጋግሯቸውን ልዩ ልዩ አካላዊ ለውጦች ያስተናግዳሉ።
- በሴቶች ላይ፡ የጡት ማደግ፣ የዳሌ መስፋት እና የወር አበባ መጀመር።
- በወንዶች ላይ፡ የድምፅ መጎርነን፣ የጉሮሮ አጥንት መጉላትና የፊት ጸጉር ማደግ።
- በሁለቱም ላይ፡ የብብትና የብልት አካባቢ ጸጉር፣ የላብ እጢዎች መጎልበትና አልፎ አልፎ የፊት ብጉር።
> የዶክተር ማስታወሻ፡ ፊትዎን በቀን ሁለት ጊዜ ለስላሳ ሳሙና መታጠብ የቆዳ ቅባትን ለመቆጣጠር ይረዳል።

## ስሜታዊና ማህበራዊ ለውጦች
በጉርምስና ወቅት በአንጎል ውስጥ የሚከሰቱ እድገቶች ለስሜት መዋዠቅና ለራስ ማንነት ፍለጋ በር ይከፍታሉ።
- የስሜት መለዋወጥ፡ የሆርሞኖች መብዛት ጊዜያዊ የቁጣ ወይም የደስታ ስሜትን ሊፈጥር ይችላል።
- ነፃነትን መፈለግ፡ የራስን ውሳኔ የመወሰንና ማንነትን የመገንባት ፍላጎት ይጨምራል።
- ማህበራዊ ግንኙነት፡ ከእኩዮችና ከጓደኞች ጋር የመቀራረብ ፍላጎት ማደግ።
> የዶክተር ማስታወሻ፡ የሚሰማዎትን ስሜት ከግቢው አቻ አማካሪዎች ጋር መጋራት የአእምሮ እረፍት ይሰጣል።

## የንፅህናና የራስ እንክብካቤ መመሪያዎች
ዕለታዊ የንፅህና ልማዶች ከኢንፌክሽን ከመጠበቃቸውም በላይ በራስ መተማመንን ያጎለብታሉ።
- የሰውነት ንፅህና፡ አዘውትሮ መታጠብ የላብ ሽታ እንዳይፈጠር ይከላከላል።
- የወር አበባ ንፅህና፡ ሞዴስን በየ4 እስከ 6 ሰዓቱ መቀየርና እጅን በሳሙና መታጠብ።
- እንቅልፍና አመጋገብ፡ ቢያንስ ከ8-9 ሰዓት እንቅልፍ መተኛትና በቂ ውሃ መጠጣት።
> የዶክተር ማስታወሻ፡ ለግል ንፅህና የሚያስፈልጉ ነገሮችን በቦርሳዎ ይዘው መንቀሳቀስ በግቢ ቆይታዎ ምቾት ይሰጥዎታል።`,
  },
  {
    id: 'template_srh',
    nameEn: 'Sexual & Reproductive Health Foundations',
    nameAm: 'የሥነ-ተዋልዶ ጤና መሰረታዊ መመሪያ',
    category: 'srh',
    imageAsset: 'assets/images/learning/module_05_srh.png',
    readTimeMin: 4,
    authorName: 'National Adolescent Health Coalition',
    titleEn: 'Sexual & Reproductive Health Foundations',
    titleAm: 'የሥነ-ተዋልዶ ጤና መሰረታዊ እውቀቶች',
    summaryEn:
      'Essential clinical insights on reproductive biology, fertility awareness, informed decision-making, and respecting bodily boundaries.',
    summaryAm:
      'ስለ ተዋልዶ አካላት ተግባር፣ ስለ ማዳበሪያ ዑደት፣ ስለ ወጣቶች ውሳኔ አሰጣጥና ስለ ሰውነት ወሰን የተሟላ የህክምና ትምህርት።',
    doctorNoteEn:
      'Knowledge of your reproductive anatomy empowers you to protect your long-term health and make confident, healthy decisions about your future.',
    doctorNoteAm:
      'የራስን የሥነ-ተዋልዶ ጤና በሚገባ ማወቅ የረጅም ጊዜ ደህንነትን ለመጠበቅና የተሟላ በራስ መተማመን እንዲኖርዎት ያደርጋል።',
    contentEn: `## Reproductive Anatomy & Physiology
Understanding the biological systems responsible for human reproduction is key to body literacy.
- Female internal & external organs: Ovaries, fallopian tubes, uterus, cervix, and vaginal canal.
- Male reproductive system: Testes, scrotum, vas deferens, prostate, and urethra.
- Biological purpose: Gamete generation and hormone production essential for vitality.
> Clinical Tip: Familiarizing yourself with clinical anatomy dispels harmful myths and anxiety.

## The Menstrual Cycle & Fertility
The menstrual cycle is an intricate hormonal monthly cycle reflecting reproductive wellness.
- Phase 1: Follicular phase and follicle stimulation (Days 1–13).
- Phase 2: Ovulation, the release of a mature ovum from an ovary (typically Day 14).
- Phase 3: Luteal phase and shedding of uterine endometrium when fertilization does not occur.
> Clinical Tip: Tracking your cycle using a calendar helps anticipate physical needs and symptom timing.

## Bodily Autonomy & Informed Decisions
Every young person possesses absolute ownership of their personal physical boundaries.
- Informed decision: Making health choices free from coercion, peer pressure, or shame.
- Clear communication: Expressing boundaries clearly and respecting the limits of others.
- Future readiness: Aligning personal health decisions with academic and life ambitions.
> Clinical Tip: Never compromise your personal values under social or partner expectations.

## University Campus Support & Counseling
Accessible youth-friendly clinics offer confidential answers and clinical guidance.
- Campus focal centers: Certified counselors available across UoG student clinics.
- Free resources: Educational booklets, sanitary pads, and confidential wellness checks.
- Professional ethics: Medical records and peer consultations are strictly confidential.
> Clinical Tip: Visit your campus health officer whenever you have unanswered personal health questions.`,
    contentAm: `## የሥነ-ተዋልዶ አካላት ተግባርና አወቃቀር
የተዋልዶ አካላትን ጤናማ አሰራር መረዳት ለግል ጤና አጠባበቅ ወሳኝ መሰረት ነው።
- የሴቶች ተዋልዶ አካላት፡ ማህፀን፣ የማህፀን ቱቦዎች፣ እንቁላል ማመንጫ እና የውጪው የብልት አካል።
- የወንዶች ተዋልዶ አካላት፡ የዘር ፍሬ (testes)፣ የዘር ማስተላለፊያ ቱቦና የፕሮስቴት እጢ።
- የተፈጥሮ ሚና፡ ሆርሞኖችን ማመንጨትና የወደፊት ጤናማ ህይወትን ማረጋገጥ።
> የዶክተር ማስታወሻ፡ ሳይንሳዊ የህክምና እውቀት ማግኘት የተሳሳቱ አመለካከቶችን ለማስወገድ ይረዳል።

## የወር አበባ ዑደትና ተፈጥሯዊ ለውጦች
የወር አበባ ዑደት በሆርሞኖች ቁጥጥር ስር የሚገኝ ወርሃዊ ተፈጥሯዊ ሂደት ነው።
- የመጀመሪያ ደረጃ፡ የእንቁላል ማደግና መዘጋጀት (ከቀን 1–13)።
- ሁለተኛ ደረጃ፡ እንቁላል መውጣት (Ovulation - አብዛኛውን ጊዜ በ14ኛው ቀን)።
- ሦስተኛ ደረጃ፡ ያልተዳቀለ እንቁላል ከማህፀን ግድግዳ ጋር በደም መልክ መውጣት።
> የዶክተር ማስታወሻ፡ የወር አበባ የሚመጣበትን ቀን በማስታወሻ መመዝገብ ለቅድመ ዝግጅት ይጠቅማል።

## የሰውነት ወሰንና ነፃ ምርጫ
እያንዳንዱ ወጣት በራሱ አካል ላይ ሙሉ መብትና የመወሰን ስልጣን አለው።
- በራስ መተማመን፡ ከእኩዮች ጫና ነፃ ሆኖ ትክክለኛ ውሳኔዎችን መወሰን።
- ወሰንን ማሳወቅ፡ ለግል ደህንነትዎ የማይመቹ ሁኔታዎችን በግልጽ "አይሆንም" ማለት።
- የትምህርት ግቦች፡ ለወደፊት ህይወትዎና ለትምህርትዎ ቅድሚያ መስጠት።
> የዶክተር ማስታወሻ፡ በማንኛውም ማህበራዊ ጫና ምክንያት የግል እሴቶችዎን አሳልፈው አይስጡ።

## የግቢ የጤና ክሊኒኮችና የምክር አገልግሎት
በዩኒቨርሲቲው ግቢ ውስጥ ወጣቶችን ያማከሉ ሚስጥራዊ የጤና አገልግሎቶች አሉ።
- የአቻ አማካሪዎች፡ በሁሉም የጎንደር ዩኒቨርሲቲ ግቢዎች ያሉ የጤና ረዳቶች።
- ነፃ አገልግሎቶች፡ የጤና ትምህርት፣ የሴቶች ንፅህና መጠበቂያ እና የጤና ምርመራ።
- ሚስጥራዊነት፡ ማንኛውም የሚሰጥ የምክር አገልግሎት 100% በሚስጥር የተጠበቀ ነው።
> የዶክተር ማስታወሻ፡ ጥያቄ ሲኖርዎት ወደ ግቢው ክሊኒክ ጎራ ብለው ባለሙያዎችን ያማክሩ።`,
  },
  {
    id: 'template_sti',
    nameEn: 'STI Prevention & Clinic Testing',
    nameAm: 'የአባላዘር በሽታዎች መከላከያና ምርመራ',
    category: 'sti',
    imageAsset: 'assets/images/learning/module_02_sti.png',
    readTimeMin: 4,
    authorName: 'Dr. Hanna Bekele & Youth Clinical Team',
    titleEn: 'Sexually Transmitted Infections & Prevention',
    titleAm: 'የአባላዘር በሽታዎች መከላከያና ግንዛቤ',
    summaryEn:
      'Youth-friendly clinical guidance on recognizing STI transmission routes, identifying common symptoms, prevention methods, and early testing.',
    summaryAm:
      'የአባላዘር በሽታዎች መተላለፊያ መንገዶች፣ የተለመዱ ምልክቶች፣ የመከላከያ ዘዴዎችና ቀድሞ የመመርመር አስፈላጊነት።',
    doctorNoteEn:
      'Most STIs are easily curable when diagnosed early. Campus health clinics provide free, private, and stigma-free screening for all students.',
    doctorNoteAm:
      'አብዛኛዎቹ የአባላዘር በሽታዎች ቀድመው ከታወቁ ሙሉ በሙሉ ይድናሉ። በግቢው ክሊኒኮች ነፃና ሚስጥራዊ ምርመራ ማግኘት ይቻላል።',
    contentEn: `## What Are Sexually Transmitted Infections?
STIs are bacterial, viral, or parasitic infections primarily transmitted through sexual contact or intimate fluid exposure.
- Bacterial STIs: Chlamydia, Gonorrhea, and Syphilis (curable with prescribed antibiotics).
- Viral STIs: HPV, Herpes (HSV), Hepatitis B, and HIV (manageable with modern clinical treatments).
- Asymptomatic transmission: Many individuals experience zero visible symptoms while carrying the infection.
> Clinical Tip: You cannot determine if someone carries an STI purely by physical appearance.

## Recognizing Common Warning Symptoms
Knowing early physical indicators prompts timely clinical care before complications arise.
- Abnormal discharge: Unusual color, odor, or consistency from genital areas.
- Pain & burning: Discomfort during urination or pelvic heaviness.
- Skin manifestations: Sores, blisters, warts, or itching in genital or groin zones.
> Clinical Tip: Never attempt self-medication; consult a doctor for laboratory-verified diagnosis.

## Effective Barrier Protection & Prevention
Barrier protection drastically reduces contact with infectious bodily secretions.
- Consistent protection: Correct usage of latex or polyurethane male/female condoms.
- Abstinence: Choosing abstinence completely eliminates sexual transmission risks.
- Avoiding shared needles: Never share unsterilized needles or sharp instruments.
> Clinical Tip: Store barrier products in cool, dry places away from direct sunlight and friction.

## Free & Confidential Testing at University Clinics
Screening is quick, painless, and completely confidential under student medical ethics.
- Rapid tests: Accurate, high-sensitivity tests available with results within minutes.
- Non-judgmental environment: Healthcare providers offer compassionate, confidential counseling.
- Partner treatment: Treating both partners prevents repetitive re-infection cycles.
> Clinical Tip: Routine screening is a standard marker of personal responsibility and health maturity.`,
    contentAm: `## የአባላዘር በሽታዎች ምንድን ናቸው?
የአባላዘር በሽታዎች በግብረ-ስጋ ግንኙነት ወይም በሰውነት ፈሳሾች ንክኪ የሚተላለፉ ባክቴሪያዊ፣ ቫይረሳዊ ወይም ጥገኛ ተውሳኮች ናቸው።
- በባክቴሪያ የሚመጡ፡ ጨብጥ፣ ቂጥኝ እና ክላሚዲያ (በህክምና የታዘዘ መድኃኒት በመውሰድ ሙሉ በሙሉ የሚድኑ)።
- በቫይረስ የሚመጡ፡ የብልት ኪንታሮት (HPV)፣ ሄርፒስ እና ኤች.አይ.ቪ።
- ምልክት አለማሳየት፡ ብዙ ሰዎች ኢንፌክሽኑ ኖሯቸው ምንም ዓይነት ውጫዊ ምልክት ላያሳዩ ይችላሉ።
> የዶክተር ማስታወሻ፡ አንድ ሰው ላይ በሽታው መኖሩን በውጫዊ ቁመና ማወቅ አይቻልም፤ ምርመራ ብቻ ያረጋግጣል።

## ዋና ዋና የሚታዩ ምልክቶች
ምልክቶችን ቀድሞ ማወቅ ኢንፌክሽኑ ወደ ከፋ ጉዳት ሳይደርስ በቶሎ ለመታከም ይረዳል።
- ያልተለመደ ፈሳሽ፡ የፈሳሽ ቀለም፣ ሽታ ወይም መጠን መቀየር።
- የማቃጠል ስሜት፡ ሽንት በሚሸኑበት ወቅት ህመም ወይም ማቃጠል።
- ቁስለትና ሽፍታ፡ በብልት ወይም በጉሮሮ አካባቢ የሚታዩ ቁስሎች፣ አረፋዎች ወይም ማሳከክ።
> የዶክተር ማስታወሻ፡ ያለ ሀኪም ትዕዛዝ መድኃኒት አይውሰዱ፤ የላቦራቶሪ ምርመራ ተደርጎ ትክክለኛ ህክምና ማግኘት አለበት።

## አስተማማኝ የመከላከያ ዘዴዎች
ትክክለኛ የመከላከያ እርምጃዎችን መውሰድ ተጋላጭነትን በከፍተኛ ደረጃ ይቀንሳል።
- ኮንዶምን በአግባቡ መጠቀም፡ ጥንቃቄ በተሞላበት መልኩ ኮንዶምን መጠቀም።
- መታቀብ፡ ጥንቃቄ የጎደለው ግንኙነት ከመፈፀም መታቀብ ፍጹም አስተማማኝ መከላከያ ነው።
- ስለታም ነገሮችን አለመጋራት፡ መርፌዎችንና ምላጮችን በጋራ አለመጠቀም።
> የዶክተር ማስታወሻ፡ መከላከያዎችን ከቀጥታ የፀሐይ ብርሃንና ከሙቀት ርቆ ባለ ቦታ ያስቀምጡ።

## በግቢ ክሊኒኮች የሚሰጥ ነፃ ምርመራ
የግቢው ጤና ጣቢያዎች ፈጣን፣ ጥራት ያለውና ሚስጥራዊ ምርመራ ያቀርባሉ።
- ፈጣን ውጤት፡ በጥቂት ደቂቃዎች ውስጥ ትክክለኛ ውጤት የሚያሳዩ የምርመራ መሳሪያዎች።
- ሚስጥራዊነት የተጠበቀ፡ ያለ ፍርሀት የምክርና የህክምና አገልግሎት ማግኘት ይቻላል።
- ሁለቱንም ማከም፡ ኢንፌክሽን ከተገኘ አጋርንም አብሮ ማከም ተመልሶ እንዳይመጣ ያደርጋል።
> የዶክተር ማስታወሻ፡ መመርመር የንቃትና የጤና ጥንቃቄ መገለጫ እንጂ የሚያሳፍር ነገር አይደለም።`,
  },
  {
    id: 'template_hiv',
    nameEn: 'HIV & AIDS Prevention & Awareness',
    nameAm: 'የኤች.አይ.ቪ/ኤድስ መከላከያና ግንዛቤ',
    category: 'hiv',
    imageAsset: 'assets/images/learning/module_07_hiv.png',
    readTimeMin: 4,
    authorName: 'National Youth Health Coalition',
    titleEn: 'HIV & AIDS Prevention and Modern Care',
    titleAm: 'የኤች.አይ.ቪ/ኤድስ መከላከያና ዘመናዊ ህክምና',
    summaryEn:
      'Comprehensive facts on HIV transmission, effective prevention methods (PEP & PrEP), fighting social stigma, and living healthy with treatment.',
    summaryAm:
      'ስለ ኤች.አይ.ቪ መተላለፊያ መንገዶች፣ የመከላከያ ዘዴዎች (PEP እና PrEP)፣ ማህበራዊ መገለልን ስለማስወገድና ስለ ዘመናዊ ህክምና የተሟላ መረጃ።',
    doctorNoteEn:
      'With modern antiretroviral therapy (ART), people living with HIV live long, healthy, and fulfilling lives. Undetectable equals Untransmittable (U=U).',
    doctorNoteAm:
      'በዘመናዊ የፀረ-ኤች.አይ.ቪ መድኃኒቶች (ART) ታማሚዎች ረጅም፣ ጤናማና ፍሬያማ ህይወት መምራት ይችላሉ። የቫይረሱ መጠን ሲቀንስ ቫይረሱ አይተላለፍም (U=U)።',
    contentEn: `## How HIV Spreads & How It Does NOT
HIV is transmitted only through specific bodily fluids under defined circumstances.
- Routes of transmission: Unprotected sexual exposure, sharing contaminated needles, and mother-to-child during birth or breastfeeding.
- Fluids involved: Blood, semen, vaginal fluids, and breast milk.
- Safe interactions: Hugging, sharing food, handshakes, sharing utensils, or toilet seats CANNOT transmit HIV.
> Clinical Tip: Mosquitoes and casual social contact never transmit HIV.

## Modern Prevention Methods: PEP & PrEP
Medical advancements provide powerful prophylactic options for youth.
- PrEP (Pre-Exposure Prophylaxis): Daily medication preventing HIV acquisition for individuals at higher risk.
- PEP (Post-Exposure Prophylaxis): Emergency 28-day antiretroviral course taken within 72 hours of potential exposure.
- Standard barrier protection: High-grade latex male and female condoms remain vital.
> Clinical Tip: In case of accidental exposure, report to a campus clinic within 72 hours for PEP access.

## Stigma Reduction & Social Support
Compassion, dignity, and scientific facts break destructive social isolation.
- Debunking stigma: HIV is a manageable chronic health condition, not a moral failure.
- Student community: Offering empathy and non-discriminatory companionship to peers living with HIV.
- Confidential status: Personal health records are legally guarded under strict medical privacy.
> Clinical Tip: Words matter—use supportive, medically accurate language when discussing health status.

## Living Long & Thriving on Treatment
Antiretroviral therapy (ART) suppresses the virus to undetectable laboratory levels.
- Viral suppression: Daily adherence prevents disease progression and preserves immunity.
- U=U Consensus: When viral load is undetectable, the virus cannot be sexually transmitted.
- Healthy lifestyle: Nutritious meals, regular physical exercise, and stress management ensure vitality.
> Clinical Tip: Consistent daily medication timing achieves optimal viral suppression.`,
    contentAm: `## ኤች.አይ.ቪ የሚተላለፍባቸውና የማይተላለፍባቸው መንገዶች
ኤች.አይ.ቪ የሚተላለፈው በልዩ የሰውነት ፈሳሾች አማካኝነት ብቻ ነው።
- መተላለፊያ መንገዶች፡ ጥንቃቄ የጎደለው ግንኙነት፣ በደምና በደም ውጤቶች፣ እና ከእናት ወደ ልጅ በወሊድ ወቅት።
- ፈሳሾች፡ ደም፣ የወንድ የዘር ፈሳሽ፣ የሴት ብልት ፈሳሽ እና የእናት ጡት ወተት።
- የማይተላለፍባቸው፡ አብሮ በመብላት፣ እጅ በመጨባበጥ፣ በማቀፍ፣ መፀዳጃ ቤት በጋራ በመጠቀም አይተላለፍም።
> የዶክተር ማስታወሻ፡ የወባ ትንኞችም ሆኑ ማህበራዊ ግንኙነቶች ኤች.አይ.ቪን በጭራሽ አያስተላልፉም።

## ዘመናዊ የመከላከያ መንገዶች፡ PEP እና PrEP
በሳይንሱ እድገት ምክንያት አስቀድሞ መከላከል የሚያስችሉ ዘመናዊ መድኃኒቶች አሉ።
- PrEP (ቅድመ-ተጋላጭነት መከላከያ)፡ ተጋላጭነት ከመፈጠሩ በፊት የሚወሰድ አስተማማኝ የመከላከያ መድኃኒት።
- PEP (ድህረ-ተጋላጭነት አስቸኳይ ህክምና)፡ ተጋላጭነት በተፈጠረ በ72 ሰዓታት ውስጥ የሚጀመር የአስቸኳይ ጊዜ ህክምና።
- መከላከያዎችን መጠቀም፡ ኮንዶምን በአግባቡ መጠቀም ቫይረሱን ለመከላከል ከፍተኛ ሚና አለው።
> የዶክተር ማስታወሻ፡ ድንገተኛ አደጋ ካጋጠመዎት በ72 ሰዓታት ውስጥ ወደ ክሊኒክ በመሄድ የPEP ህክምና ያግኙ።

## ማህበራዊ መገለልን ማስወገድና ድጋፍ
የተሳሳቱ አመለካከቶችን በማስወገድ በቫይረሱ ለተያዙ ወገኖች ፍቅርና ድጋፍ መስጠት ይገባል።
- መገለልን ማስወገድ፡ ኤች.አይ.ቪ ልክ እንደሌሎች በሽታዎች በመድኃኒት የሚቆጣጠሩት የጤና ጉዳይ ነው።
- የእኩዮች ሚና፡ በቫይረሱ ለተያዙ የዩኒቨርሲቲ ተማሪዎች ፍቅርና ማህበራዊ ድጋፍ መስጠት።
- ሚስጥራዊነት፡ የግል የጤና መረጃ በህግ የተጠበቀና ሚስጥራዊ ነው።
> የዶክተር ማስታወሻ፡ አድልዎና መገለል የህክምና ምርመራ እንዳይደረግ የሚያደርጉ ዋና እንቅፋቶች ናቸው።

## በህክምና ረጅም እና ጤናማ ህይወት መምራት
የፀረ-ኤች.አይ.ቪ (ART) መድኃኒቶች ቫይረሱ በሰውነት ውስጥ እንዳይባዛ በማድረግ በሽታ የመከላከል አቅምን ያጠናክራሉ።
- መድኃኒትን በአግባቡ መውሰድ፡ የሰውነትን በሽታ የመከላከል አቅም ወደ ነበረበት ይመልሳል።
- U=U (ያልታየ = አይተላለፍም)፡ የቫይረሱ መጠን በደም ውስጥ እጅግ ሲቀንስ ቫይረሱ ወደ ሌላ ሰው አይተላለፍም።
- ጤናማ የአኗኗር ዘይቤ፡ የተመጣጠነ ምግብ መመገብ፣ የአካል ብቃት እንቅስቃሴና እረፍት ማድረግ።
> የዶክተር ማስታወሻ፡ መድኃኒትን በሰዓቱ አዘውትሮ መውሰድ ረጅም እና ጤናማ ህይወትን ያረጋግጣል።`,
  },
  {
    id: 'template_mental_health',
    nameEn: 'Mental Health & Stress Relief',
    nameAm: 'የአእምሮ ጤናና የጭንቀት አያያዝ',
    category: 'mental_health',
    imageAsset: 'assets/images/learning/module_06_mental_health.jpg',
    readTimeMin: 4,
    authorName: 'UoG Student Counseling Directorate',
    titleEn: 'Mental Health & Stress Management for Students',
    titleAm: 'የአእምሮ ጤና አጠባበቅና የጭንቀት አያያዝ',
    summaryEn:
      'Practical techniques for navigating academic pressure, recognizing anxiety and depression, developing resilience, and accessing peer counseling.',
    summaryAm:
      'የትምህርት ጫናን የመቋቋም ዘዴዎች፣ የድብርትና የጭንቀት ምልክቶች፣ የአእምሮ ጥንካሬን ማሳደግና የምክር አገልግሎት ማግኘት።',
    doctorNoteEn:
      'Taking care of your mental well-being is just as critical as caring for your physical body. Asking for guidance is a sign of courage and strength.',
    doctorNoteAm:
      'የአእምሮ ጤናን መንከባከብ ከአካላዊ ጤና ባልተናነሰ ደረጃ ወሳኝ ነው። የምክር አገልግሎት መጠየቅ የጥንካሬና የብልህነት መገለጫ ነው።',
    contentEn: `## Understanding Student Stress & Burnout
University life introduces new academic challenges, deadlines, and social transitions that cause stress.
- Normal vs toxic stress: Moderate stress motivates focus; continuous acute stress overwhelms mental clarity.
- Physiological responses: Tension headaches, fatigue, sleep disruptions, and racing thoughts.
- Root causes: Examination periods, financial constraints, and homesickness.
> Clinical Tip: Recognize stress signals early so you can reset before academic burnout sets in.

## Spotting Anxiety & Depressive Symptoms
Distinguishing temporary bad days from clinical emotional conditions.
- Generalized Anxiety: Persistent, uncontrollable worry that disrupts daily concentration.
- Signs of Depression: Persistent sadness, loss of interest in hobbies, withdrawal from friends, or appetite changes.
- Destructive coping: Avoid resorting to stimulants, khat, or alcohol to numb mental pain.
> Clinical Tip: If feelings of deep sadness persist for more than two consecutive weeks, consult a counselor.

## Practical Stress Management Habits
Evidence-based lifestyle practices restore emotional equilibrium.
- Mindful breathing: Inhale deeply for 4 counts, hold for 4, exhale slowly for 6 to calm the nervous system.
- Balanced daily routine: Dedicate fixed intervals for study, physical movement, and relaxation.
- Social connection: Sharing worries with empathetic friends lightens the emotional load.
> Clinical Tip: Take a 10-minute fresh air walk across your campus green areas between study blocks.

## Free Campus Psychological Services
University counselors offer confidential, stigma-free emotional guidance.
- Campus focal persons: Dedicated psychology professionals available on every campus.
- Peer mentor support: Connect with trained student mentors who understand campus realities.
- Zero stigma: Consultations are completely private and never shared with faculty or peers.
> Clinical Tip: You never have to suffer in silence—support is available right inside your university campus.`,
    contentAm: `## የተማሪዎች ጭንቀትና ድካምን መረዳት
የዩኒቨርሲቲ ህይወት በርካታ አዳዲስ የትምህርት ፈተናዎች፣ የጊዜ ጫናዎችና ማህበራዊ ለውጦች የሚገጥሙበት ወቅት ነው።
- ጤናማና ጎጂ ጭንቀት፡ መጠነኛ ጭንቀት ለትምህርት ያነሳሳል፤ ከልክ ያለፈ ተከታታይ ጭንቀት ግን አእምሮን ያደክማል።
- አካላዊ ምልክቶች፡ የራስ ምታት፣ አጠቃላይ የድካም ስሜት፣ የእንቅልፍ መዛባትና የልብ ምት መጨመር።
- መንስኤዎች፡ የፈተና ወቅት፣ የገንዘብ እጥረትና ቤተሰብን መናፈቅ።
> የዶክተር ማስታወሻ፡ የጭንቀት ምልክቶች ሲሰሙዎት ገና ከመጀመሪያው እረፍት በመውሰድ አእምሮዎን ያድሱ።

## የጭንቀትና የድብርት ምልክቶች
ጊዜያዊ የድካም ስሜትንና ህክምና የሚያስፈልገውን የድብርት ስሜት መለየት አስፈላጊ ነው።
- ከልክ ያለፈ ስጋት፡ ያልተረጋጋ ስሜትና ለነገሮች ያለማቋረጥ መጨነቅ።
- የድብርት ምልክቶች፡ ለሳምንታት የሚቆይ የሀዘን ስሜት፣ ከጓደኞች መራቅ፣ የምግብ ፍላጎት መቀነስና የትምህርት ፍላጎት ማጣት።
- የተሳሳቱ መፍትሄዎች፡ ጭንቀትን ለማስወገድ ጫት፣ ሲጋራ ወይም አልኮል መጠቀም ችግሩን ያባብሰዋል እንጂ አይፈታውም።
> የዶክተር ማስታወሻ፡ ጥልቅ የሀዘን ስሜት ከሁለት ሳምንት በላይ ከቆየ የግቢውን አማካሪዎች ማናገር ተገቢ ነው።

## ጭንቀትን የመቆጣጠሪያ ቀላል ዘዴዎች
ሳይንሳዊ በሆነ መንገድ የተረጋገጡ የአኗኗር ልማዶች የአእምሮ ሰላምን ለመመለስ ይረዳሉ።
- አተነፋፈስን ማስተካከል፡ በጥልቀት አየር መማግና ቀስ ብሎ ማስወጣት የነርቭ ስርዓትን ያረጋጋል።
- የጊዜ ሰሌዳ ማውጣት፡ ለጥናት፣ ለእረፍትና ለእንቅልፍ በቂ ጊዜ መመደብ።
- ከጓደኞች ጋር ማውራት፡ የውስጥን ስሜት ለታመነ ጓደኛ ማጋራት ሸክምን ያቀላል።
> የዶክተር ማስታወሻ፡ በጥናት መካከል ለ10 ደቂቃ በእግር መጓዝና ንጹህ አየር መውሰድ አእምሮን ያነቃቃል።

## በግቢው ውስጥ ያሉ ነፃ የምክር አገልግሎቶች
የዩኒቨርሲቲው የስነ-ልቦና ባለሙያዎች ሚስጥራዊና ነፃ ድጋፍ ያቀርባሉ።
- የካምፓስ የምክር ማዕከላት፡ በሁሉም ግቢዎች ያሉ የባለሙያ ድጋፍ መስጫ ቢሮዎች።
- የአቻ አማካሪዎች፡ የተማሪዎችን ህይወት የሚረዱ የሰለጠኑ አቻ ተማሪዎች።
- ሚስጥራዊነት፡ ማንኛውም ንግግር ሙሉ በሙሉ በሚስጥር የተያዘ ነው።
> የዶክተር ማስታወሻ፡ ብቻዎን አይጨነቁ፤ በግቢው ውስጥ እርስዎን ለማዳመጥ የተዘጋጁ ባለሙያዎች አሉ።`,
  },
  {
    id: 'template_gbv',
    nameEn: 'GBV Prevention & Safe Spaces',
    nameAm: 'ጾታዊ ጥቃት መከላከልና የደህንነት መመሪያ',
    category: 'gbv',
    imageAsset: 'assets/images/learning/module_04_gbv.png',
    readTimeMin: 4,
    authorName: 'Directorate of Gender & Social Inclusion',
    titleEn: 'Gender-Based Violence Prevention & Student Rights',
    titleAm: 'ጾታዊ ጥቃትን መከላከልና የተማሪዎች መብት',
    summaryEn:
      'Understanding affirmative consent, recognizing coercion and harassment, active bystander intervention, and accessing emergency campus protection.',
    summaryAm:
      'ስለ ፍቃደኝነት፣ ስለ ወከባና ጥቃት ዓይነቶች፣ ስለ እኩዮች ጣልቃ ገብነትና ስለ አስቸኳይ ጊዜ የዩኒቨርሲቲ የጥበቃ አገልግሎት።',
    doctorNoteEn:
      'Everyone has the fundamental right to study in a secure, dignified university environment free from harassment or intimidation. Zero tolerance for violence.',
    doctorNoteAm:
      'ማንኛውም ተማሪ ከማንኛውም ወከባና ጥቃት ነፃ በሆነ ሰላማዊ የትምህርት ገበታ ላይ የመማር ሙሉ ሰብዓዊ መብት አለው። ጥቃትን በጭራሽ አንታገስም።',
    contentEn: `## Defining Gender-Based Violence & Harassment
Gender-based violence comprises acts that inflict physical, sexual, or psychological harm based on gender.
- Forms of harassment: Unwanted touching, persistent unwelcome verbal advances, threats, or stalking.
- Power imbalances: Misuse of academic, economic, or social seniority to intimidate students.
- Digital harassment: Non-consensual sharing of intimate images or cyberbullying.
> Clinical Tip: Harassment is NEVER the survivor's fault, regardless of setting or attire.

## Affirmative & Enthusiastic Consent
Consent is the active, voluntary, and unambiguous agreement to participate in an activity.
- Freely given: Decisions must never be pressured through manipulation or fear.
- Reversible: Consent can be withdrawn at any time without penalty or aggression.
- Clear & sober: Intoxication, sleeping, or incapacitation invalidates consent.
> Clinical Tip: Silence or absence of resistance never implies consent; only explicit consent counts.

## Active Bystander Intervention
Peers possess tremendous power to prevent unsafe situations on campus.
- Direct intervention: Step in calmly and ask if the individual needs help or a way out.
- Distraction tactic: Create a neutral diversion (e.g., asking for directions or inviting them over).
- Delegation: Call upon campus security, proctors, or focal leaders immediately.
> Clinical Tip: Intervene safely without escalating danger to yourself or others.

## Confidential Emergency Help & Focal Directory
Immediate medical, psychological, and legal protections are available on every campus.
- Medical prophylaxis: Emergency contraception and PEP available within 72 hours at campus clinics.
- Gender Directorate: Official reporting channels guaranteeing confidentiality and protection from retaliation.
- Legal advocacy: Free assistance through university human rights and security channels.
> Clinical Tip: Your dignity and safety are safeguاردed—never hesitate to reach out for protection.`,
    contentAm: `## ጾታዊ ጥቃትና ወከባን መረዳት
ጾታዊ ጥቃት በጾታ ምክንያት የሚፈፀም አካላዊ፣ ስነ-ልቦናዊ ወይም ጾታዊ ጉዳት የሚያደርስ ማንኛውም ድርጊት ነው።
- የወከባ ዓይነቶች፡ ያልተፈለገ ንክኪ፣ አላስፈላጊ የቃላት ትንኮሳ፣ ማስፈራራት ወይም መከታተል።
- የስልጣን ተዋረድ፡ የትምህርት፣ የገንዘብ ወይም የማህበራዊ የበላይነትን ተጠቅሞ ተማሪዎችን ማስገደድ።
- የቴክኖሎጂ ወከባ፡ ፎቶዎችን ያለፈቃድ ማሰራጨት ወይም በማህበራዊ ሚዲያ ማዋረድ።
> የዶክተር ማስታወሻ፡ ጥቃት በማንኛውም ሁኔታ የተጠቃሚው ጥፋት አይደለም፤ ጥፋቱ የፈፃሚው ብቻ ነው።

## የተሟላ ፈቃደኝነት (Consent)
ፈቃደኝነት ማለት በነፃነት፣ በግልጽ እና በደስታ የሚሰጥ የጋራ ስምምነት ነው።
- በነፃ ፍላጎት፡ ያለምንም ማስፈራሪያ፣ ማታለል ወይም ጫና የሚደረግ ምርጫ።
- መሻር የሚችል፡ በማንኛውም ቅጽበት ፈቃደኝነትን ማቆም ይቻላል።
- በንቃት ላይ የተመሰረተ፡ በስካር ወይም በእንቅልፍ ውስጥ የሚደረግ ነገር ፈቃደኝነት አይባልም።
> የዶክተር ማስታወሻ፡ ዝምታ ማለት ፈቃደኝነት ማለት አይደለም፤ ግልጽና አዎንታዊ ስምምነት ብቻ ይቆጠራል።

## የእኩዮች ንቁ ጣልቃ ገብነት
ተማሪዎች አጠገባቸው አደገኛ ሁኔታ ሲፈጠር አደጋውን የማስቆም ትልቅ ኃይል አላቸው።
- ቀጥተኛ ድጋፍ፡ በሰላማዊ መንገድ ጣልቃ በመግባት የተቸገረውን ሰው እርዳታ ይፈልግ እንደሆነ መጠየቅ።
- ትኩረት ማስቀየስ፡ ሆን ብሎ ሌላ ነገር በመጠየቅ ወይም በመጥራት አደጋውን ማቋረጥ።
- እርዳታ መጥራት፡ ለግቢው ጥበቃ፣ ለፕሮክተሮች ወይም ለክፍል ተጠሪዎች ማሳወቅ።
> የዶክተር ማስታወሻ፡ ጣልቃ ሲገቡ የራስዎን ደህንነት በጠበቀ መልኩ በጥንቃቄ ይሁን።

## የአስቸኳይ ጊዜ የጥበቃና የምክር አድራሻዎች
በሁሉም የጎንደር ዩኒቨርሲቲ ግቢዎች የህክምና፣ የስነ-ልቦናና የህግ ድጋፍ የሚሰጡ ቢሮዎች አሉ።
- አስቸኳይ የህክምና እርዳታ፡ ድንገተኛ የእርግዝና መከላከያና የPEP መድኃኒት በ72 ሰዓታት ውስጥ ማግኘት።
- የሥርዓተ-ጾታ ዳይሬክቶሬት፡ ሚስጥራዊነት የተጠበቀ ሪፖርት ማድረጊያና የፍትህ ማግኛ ማዕከል ነው።
- የህግ ጥበቃ፡ በዩኒቨርሲቲው የህግ ክሊኒክ በኩል የሚሰጥ ነፃ የህግ ድጋፍ።
> የዶክተር ማስታወሻ፡ ደህንነትዎ የተጠበቀ ነው፤ ችግር ሲያጋጥምዎ በፍጹም ሳያመነቱ ድጋፍ ይጠይቁ።`,
  },
  {
    id: 'template_hepatitis',
    nameEn: 'Viral Hepatitis & Liver Health',
    nameAm: 'የጉበት ቫይረስ መከላከያና ግንዛቤ',
    category: 'hepatitis',
    imageAsset: 'assets/images/learning/module_03_hepatitis.png',
    readTimeMin: 4,
    authorName: 'Gondar Public Health Officers',
    titleEn: 'Viral Hepatitis Prevention and Liver Care',
    titleAm: 'የጉበት ቫይረስ መከላከያና የጉበት ጤና',
    summaryEn:
      'Understanding Hepatitis A, B, and C, modes of transmission, vaccination benefits, maintaining liver health, and campus screening.',
    summaryAm:
      'ስለ ሄፓታይተስ ኤ፣ ቢ እና ሲ ቫይረሶች፣ የመተላለፊያ መንገዶች፣ የክትባት አስፈላጊነትና የጉበት ጤናን የመጠበቂያ ዘዴዎች።',
    doctorNoteEn:
      'Hepatitis B is highly vaccine-preventable. A full vaccination series provides lifelong protection against chronic liver disease.',
    doctorNoteAm:
      'የሄፓታይተስ ቢ ቫይረስ በክትባት ሙሉ በሙሉ መከላከል ይቻላል። ክትባቱን መውሰድ የረጅም ጊዜ የጉበት ጤናን ያረጋግጣል።',
    contentEn: `## The Liver & Viral Hepatitis Types
The liver performs hundreds of essential metabolic and detoxification functions in your body.
- Hepatitis A: Water and food-borne virus transmitted via fecal-oral contamination.
- Hepatitis B & C: Blood and bodily fluid transmitted viruses that can cause chronic infection.
- The silent virus: Many individuals carry viral hepatitis for years without noticeable symptoms.
> Clinical Tip: Protecting your liver ensures sustained metabolic energy and vitality.

## Transmission Risks in Student Settings
Knowing transmission vectors safeguards personal health in shared dorm environments.
- High-risk items: Sharing toothbrushes, razors, cuticle trimmers, or needles.
- Body art risks: Getting tattoos or ear/body piercings using unsterilized needles.
- Sexual contact: Hepatitis B is easily transmitted through unprotected intimate fluids.
> Clinical Tip: Always demand single-use, sterile needles for any medical or personal piercing.

## Recognizing Early Warning Indicators
When symptoms present, recognizing them prompts immediate medical diagnosis.
- Jaundice: Yellowing of the whites of the eyes and skin.
- Digestive signs: Dark brownish urine, pale-colored stools, and chronic nausea.
- Systemic fatigue: Unexplained severe lethargy, muscle aches, and right-side abdominal pain.
> Clinical Tip: Dark-colored tea-like urine warrants a prompt visit to the clinic laboratory.

## Prevention, Vaccination & Screening
Modern medical tools make hepatitis prevention straightforward.
- Hepatitis B Vaccine: A safe, highly effective 3-dose series conferring lifelong defense.
- Hygiene discipline: Thoroughly wash hands before eating and avoid unboiled communal water.
- Clinical screening: Blood tests detect surface antigens (HBsAg) with high precision.
> Clinical Tip: Request a Hepatitis B screening and vaccination at your university hospital.`,
    contentAm: `## የጉበት ተግባርና የቫይረስ ዓይነቶች
ጉበት በሰውነታችን ውስጥ በርካታ ጠቃሚ ተግባራትንና መርዛማ ነገሮችን የማጣራት ስራ ያከናውናል።
- ሄፓታይተስ ኤ፡ በተበከለ ምግብና ውሃ አማካኝነት የሚተላለፍ የቫይረስ ዓይነት ነው።
- ሄፓታይተስ ቢ እና ሲ፡ በደም፣ በንቅሳትና በሰውነት ፈሳሾች ንክኪ የሚተላለፉ አደገኛ ቫይረሶች ናቸው።
- ድምፅ አልባ ኢንፌክሽን፡ ቫይረሱ በሰውነት ውስጥ እያለ ለረጅም ጊዜ ምንም ምልክት ላያሳይ ይችላል።
> የዶክተር ማስታወሻ፡ ጉበትዎን መንከባከብ አጠቃላይ የሰውነትዎን ጤና ለመጠበቅ ወሳኝ ነው።

## በተማሪዎች አካባቢ ያሉ የመተላለፊያ መንገዶች
በጋራ የመኖሪያ ክፍሎች ውስጥ ጥንቃቄ ማድረግ የቫይረሱን ስርጭት ለመግታት ይረዳል።
- በጋራ መጠቀም፡ ምላጭን፣ የጥርስ ብሩሽንና ሌሎች ስለታም ነገሮችን በጋራ መጠቀም ቫይረሱን ያስተላልፋል።
- ንቅሳትና ጆሮ መበሳት፡ ባልጸዱና ባልተቀቀሉ መርፌዎች ንቅሳት መነቀስ ከፍተኛ ተጋላጭነት አለው።
- ጥንቃቄ የጎደለው ግንኙነት፡ ሄፓታይተስ ቢ በፈሳሾች አማካኝነት በቀላሉ ይተላለፋል።
> የዶክተር ማስታወሻ፡ ለማንኛውም ህክምናም ሆነ ጆሮ ለመበሳት አዲስና ያልተከፈተ መርፌ ብቻ ይጠቀሙ።

## የሚታዩ የህመም ምልክቶች
ምልክቶችን ቀድሞ ማወቅ በቶሎ ህክምና ለማግኘት ያስችላል።
- የአይንና የቆዳ ቢጫ መሆን (Jaundice)፡ የአይን ነጩ ክፍል ቢጫ ቀለም ሲይዝ።
- የሽንት ቀለም መቀየር፡ የሻይ ቀለም የመሰለ ጥቁር ሽንት መሽናት።
- ድካምና ማቅለሽለሽ፡ ከፍተኛ የሆነ የድካም ስሜት፣ የምግብ ፍላጎት መቀነስና የቀኝ ሆድ ህመም።
> የዶክተር ማስታወሻ፡ የሽንት ቀለም ወደ ጥቁርነት ከተቀየረ ወደ ክሊኒክ ሄደው የደም ምርመራ ያድርጉ።

## መከላከያ ዘዴዎችና ክትባት
በቀላል ጥንቃቄዎችና በክትባት ቫይረሱን ሙሉ በሙሉ መከላከል ይቻላል።
- የሄፓታይተስ ቢ ክትባት፡ የረጅም ጊዜ አስተማማኝ መከላከያ የሚሰጥ 3 ዙር ክትባት።
- የግል ንፅህና፡ ምግብ ከመመገብ በፊት እጅን በሚገባ መታጠብና ንጹህ ውሃ መጠጣት።
- የደም ምርመራ፡ በደም ምርመራ አማካኝነት ቫይረሱ በሰውነት ውስጥ መኖሩን በደቂቃዎች ውስጥ ማወቅ።
> የዶክተር ማስታወሻ፡ በዩኒቨርሲቲው ክሊኒክ በመሄድ የሄፓታይተስ ቢ ምርመራና ክትባት ይውሰዱ።`,
  },
  {
    id: 'template_substance',
    nameEn: 'Substance Abuse & Addiction Prevention',
    nameAm: 'የሱስ መከላከልና የአዕምሮ ጤና',
    category: 'substance',
    imageAsset: 'assets/images/learning/module_08_substance_abuse.png',
    readTimeMin: 4,
    authorName: 'Adolescent Substance Intervention Taskforce',
    titleEn: 'Substance Abuse Prevention and Healthy Choices',
    titleAm: 'የሱስ መከላከልና ጤናማ ውሳኔዎች',
    summaryEn:
      'Understanding the physical and psychological toll of common substances (Khat, alcohol, shisha, tobacco), resistance strategies, and rehabilitation support.',
    summaryAm:
      'ስለ ጫት፣ አልኮል፣ ሺሻና ሲጋራ ጉዳቶች፣ ሱስን ስለመከላከል ዘዴዎችና ስለ ማገገሚያ ድጋፍ የተሟላ ትምህርት።',
    doctorNoteEn:
      'The adolescent brain is still maturing, making it exceptionally vulnerable to substance dependency. Choosing substance-free habits safeguards your academic future.',
    doctorNoteAm:
      'የወጣቶች አእምሮ በከፍተኛ የእድገት ሂደት ላይ ያለ በመሆኑ ለሱስ ተጋላጭ ነው። ከሱስ የራቀ ህይወት መምራት የትምህርት ስኬትዎን ያረጋግጣል።',
    contentEn: `## Common Substances & Their Mechanisms
Substances alter neurochemical dopamine pathways, driving rapid psychological dependence.
- Khat (Catha edulis): Contains cathinone, causing initial alertness followed by insomnia, anxiety, and oral health damage.
- Alcohol: Depressant impairing judgment, motor coordination, and reproductive health safety.
- Nicotine & Shisha: Highly addictive toxins causing cardiovascular strain and chronic lung damage.
> Clinical Tip: "Just trying once" frequently triggers neurochemical cycles of craving.

## Health, Financial & Academic Impacts
The ripple effects of substance misuse disrupt student success across multiple domains.
- Cognitive performance: Impaired memory retention, poor exam results, and chronic absenteeism.
- Financial strain: Diverting limited living stipends to sustain repetitive substance consumption.
- Mental consequences: Escalated depression, psychosis risks, and social alienation.
> Clinical Tip: Assess your peer circles—friends should inspire academic growth, not substance use.

## Peer Pressure Resistance Techniques
Saying "no" with confidence is a hallmark of emotional maturity and personal boundary strength.
- Direct refusal: A firm, polite "No thanks, I don't use khat/alcohol."
- Healthy substitute: Suggesting alternative recreational activities like campus sports or cafes.
- Exit strategy: Leaving environments where peer pressure becomes overwhelming.
> Clinical Tip: True friends will always respect your personal health boundaries and decisions.

## Free Counseling & Addiction Recovery
Breaking free from substance dependency is achievable with clinical guidance.
- Campus support: Dedicated university counselors offering compassionate, non-judgmental guidance.
- Peer recovery mentors: Confidential assistance from students who have walked the path to recovery.
- Rebuilding vitality: Restoring sleep, nutritional nourishment, and athletic routines.
> Clinical Tip: Seeking help for addiction is a sign of determination, not defeat. Reach out today.`,
    contentAm: `## የተለመዱ ሱሶችና በሰውነት ላይ ያላቸው ተፅዕኖ
አደንዛዥ እጾች በአንጎል ውስጥ ያሉትን የኬሚካል መልዕክቶች በማዛባት ፈጣን የስነ-ልቦና ጥገኝነት ያስከትላሉ።
- ጫት፡ ጊዜያዊ ንቃትን ቢፈጥርም የእንቅልፍ ማጣት፣ ጭንቀት፣ የሆድ ድርቀትና የጥርስ ጉዳት ያስከትላል።
- አልኮል፡ የሰውን የማሰብና የማመዛዘን አቅም በማዛባት ለተለያዩ አደጋዎች ያጋልጣል።
- ሲጋራና ሺሻ፡ ሳንባንና የልብ ቧንቧዎችን በከፍተኛ ሁኔታ የሚጎዱ መርዛማ ንጥረ ነገሮች አሏቸው።
> የዶክተር ማስታወሻ፡ "ለሙከራ ብቻ" ተብሎ የሚጀመር ነገር በቀላሉ ወደ ሱስ ሊያመራ ይችላል።

## በጤና፣ በትምህርትና በኢኮኖሚ ላይ የሚያስከትሉት ጉዳት
ሱስ የተማሪዎችን የትምህርት ህይወትና የወደፊት ተስፋ የሚያጨልም አደገኛ ነገር ነው።
- በትምህርት ላይ፡ የማስታወስ አቅምን መቀነስ፣ የፈተና ውጤት መውደቅና ከክፍል መቅረት።
- በኢኮኖሚ ላይ፡ ለትምህርትና ለምግብ የሚሆንን ገንዘብ ላልተገባ ነገር ማባከን።
- በአእምሮ ጤና ላይ፡ ለድብርት፣ ለከፍተኛ ጭንቀትና ከሰው ጋር ለመጣላት ማጋለጥ።
> የዶክተር ማስታወሻ፡ ጓደኞችዎ ለትምህርት ስኬት የሚያበረታቱ እንጂ ወደ ሱስ የሚጋብዙ ሊሆኑ አይገባም።

## የእኩዮችን ጫና የመቋቋሚያ ዘዴዎች
አላስፈላጊ ጫና ሲገጥም በራስ መተማመን "አይሆንም" ማለት ብስለት ነው።
- በግልጽ መናገር፡ "አመሰግናለሁ እኔ አልጠቀምም" በማለት አቋምን በጨዋነት ማሳወቅ።
- አማራጭ ማቅረብ፡ ወደ ስፖርት ሜዳ መሄድ ወይም ሌላ ጤናማ መዝናኛን መምረጥ።
- ከአካባቢው መራቅ፡ ጫናው የበረታ ከሆነ ሁኔታውን ትቶ በሰላም መውጣት።
> የዶክተር ማስታወሻ፡ እውነተኛ ጓደኞች የራስዎን ጤናማ ውሳኔ ያከብሩልዎታል እንጂ አያስገድዱዎትም።

## ነፃ የምክርና የማገገሚያ አገልግሎቶች
ከማንኛውም ሱስ ውስጥ በባለሙያዎች ድጋፍ ሙሉ በሙሉ መላቀቅ ይቻላል።
- የግቢ የምክር አገልግሎት፡ በዩኒቨርሲቲው ውስጥ ያሉ የስነ-ልቦና ባለሙያዎች ሚስጥራዊ ድጋፍ ይሰጣሉ።
- የአቻ ድጋፍ፡ ከሱስ ያገገሙ ተማሪዎችን ልምድ ማካፈልና እርስ በእርስ መደጋገፍ።
- ጤናማ ህይወትን መመለስ፡ የተመጣጠነ ምግብ መመገብ፣ ስፖርት መስራትና በቂ እረፍት ማድረግ።
> የዶክተር ማስታወሻ፡ እርዳታ መጠየቅ የድል አድራጊነት የመጀመሪያ እርምጃ ነው። ዛሬውኑ ያማክሩ።`,
  },
  {
    id: 'template_blank',
    nameEn: 'Blank Medical Curriculum Scaffold',
    nameAm: 'ባዶ የህክምና ትምህርት አብነት',
    category: 'srh',
    imageAsset: 'assets/images/learning/module_05_srh.png',
    readTimeMin: 4,
    authorName: 'Adolescent Clinical Specialist',
    titleEn: 'Enter Module Title Here',
    titleAm: 'የሞጁሉን ርዕስ እዚህ ያስገቡ',
    summaryEn: 'Enter a clear, engaging 1-2 sentence overview of this health topic for youth.',
    summaryAm: 'ስለዚህ የጤና ትምህርት ግልጽና አጭር የሆነ ባለ 1-2 ዓረፍተ ነገር ማጠቃለያ እዚህ ይጻፉ።',
    doctorNoteEn:
      'Enter the key clinical takeaway for students here. This appears prominently in the Doctor Note callout.',
    doctorNoteAm:
      'ተማሪዎች ሊረዱት የሚገባውን ቁልፍ የህክምና ማስታወሻ እዚህ ያስገቡ። በዶክተር ማስታወሻ ሳጥን ውስጥ ጎልቶ ይታያል።',
    contentEn: `## Section 1: Introduction & Overview
Provide evidence-based health guidance and core concepts here.
- Key Clinical Point 1
- Key Clinical Point 2
- Key Clinical Point 3
> Clinical Tip: Practical health action or advice for students.

## Section 2: Physiological & Emotional Aspects
Explain bodily processes and youth emotional well-being clearly.
- Core Biological Insight 1
- Core Biological Insight 2
> Clinical Tip: Reassuring advice on normal growth and health.

## Section 3: Prevention & Daily Self-Care
Actionable steps students can take in their daily campus lives.
- Practical Step 1
- Practical Step 2
- Practical Step 3
> Clinical Tip: Healthy lifestyle recommendation.

## Section 4: Campus Health Resources & Help
Where students can access clinical testing, counseling, or supplies.
- University Health Clinic details
- Confidential focal persons contact
- Peer counselor availability
> Clinical Tip: Confidential support is always available on campus.`,
    contentAm: `## ክፍል 1፡ መግቢያና አጠቃላይ እይታ
ሳይንሳዊ የጤና መረጃዎችንና መሰረታዊ ነጥቦችን እዚህ ያብራሩ።
- ዋና የህክምና ነጥብ 1
- ዋና የህክምና ነጥብ 2
- ዋና የህክምና ነጥብ 3
> የዶክተር ማስታወሻ፡ ለተማሪዎች የሚሰጥ ተግባራዊ ምክር።

## ክፍል 2፡ አካላዊና ስሜታዊ ገጽታዎች
የአካል ለውጦችንና ስሜታዊ ጤናን በግልጽ ያብራሩ።
- ቁልፍ የጤና መረጃ 1
- ቁልፍ የጤና መረጃ 2
> የዶክተር ማስታወሻ፡ ስለ ጤናማ እድገት የሚያረጋግጥ መልዕክት።

## ክፍል 3፡ መከላከያና የዕለት ተዕለት እንክብካቤ
ተማሪዎች በግቢ ቆይታቸው ሊተገብሯቸው የሚገቡ ተግባራዊ እርምጃዎች።
- ተግባራዊ እርምጃ 1
- ተግባራዊ እርምጃ 2
- ተግባራዊ እርምጃ 3
> የዶክተር ማስታወሻ፡ ጤናማ የአኗኗር ዘይቤ ምክር።

## ክፍል 4፡ የግቢ የጤና አገልግሎቶችና ድጋፍ
ተማሪዎች የህክምና፣ የምክር ወይም ሌሎች አገልግሎቶችን የሚያገኙበት መንገድ።
- የግቢ ክሊኒክ መረጃዎች
- ሚስጥራዊ የባለሙያዎች አድራሻ
- የአቻ አማካሪዎች ድጋፍ
> የዶክተር ማስታወሻ፡ በግቢው ውስጥ ምንጊዜም ሚስጥራዊ ድጋፍ ማግኘት ይቻላል።`,
  },
];
