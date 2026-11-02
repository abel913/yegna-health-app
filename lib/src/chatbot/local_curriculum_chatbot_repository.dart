import 'dart:math' as math;

import 'chatbot_models.dart';
import 'chatbot_repository.dart';

/// Intelligent on-device educational knowledge engine grounded in Yegna Health's
/// 8 learning modules and verified Ethiopian youth healthcare clinic directory.
class LocalCurriculumChatbotRepository implements ChatbotRepository {
  const LocalCurriculumChatbotRepository();

  static const _hotline952En = EmergencyHotlineAction(
    name: 'National Health Emergency Line',
    number: '952',
    description:
        'Ministry of Health 24/7 free line for acute health emergencies',
  );

  static const _hotline8335En = EmergencyHotlineAction(
    name: 'National Youth & Mental Health Line',
    number: '8335',
    description: 'Confidential counseling for reproductive health and distress',
  );

  static const _hotline952Am = EmergencyHotlineAction(
    name: 'ብሔራዊ የጤና ድንገተኛ አደጋ መስመር',
    number: '952',
    description: 'የጤና ጥበቃ ሚኒስቴር 24/7 ነፃ የድንገተኛ የጤና አገልግሎት',
  );

  static const _hotline8335Am = EmergencyHotlineAction(
    name: 'ብሔራዊ የወጣቶች እና የአእምሮ ጤና መስመር',
    number: '8335',
    description: 'ሚስጥራዊ የስነ-ተዋልዶ እና የአእምሮ ጤና የምክር አገልግሎት',
  );

  @override
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  }) async {
    // Artificial small delay for organic conversational feel
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final normalized = query.trim().toLowerCase();
    final isAmharic = languageCode.toLowerCase().startsWith('am');
    final messageId =
        'msg_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}';

    // 1. Crisis & Emergency Detection
    if (_isEmergencyQuery(normalized)) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? 'አስቸኳይ እርዳታ ይፈልጋሉ? እባክዎ ብቻዎን አይሁኑ። ነፃ፣ ሚስጥራዊ እና ፈጣን እርዳታ ለማግኘት ከታች ባሉት መስመሮች አሁኑኑ ይደውሉ፡'
            : 'If you are experiencing acute danger, abuse, severe pain, or emotional distress, immediate help is available. Please reach out to these free, confidential national helplines right now:',
        isUser: false,
        timestamp: DateTime.now(),
        isEmergency: true,
        emergencyHotlines: isAmharic
            ? const [_hotline952Am, _hotline8335Am]
            : const [_hotline952En, _hotline8335En],
        suggestedPrompts: isAmharic
            ? const ['የወጣቶች ክሊኒኮች የት ይገኛሉ?', 'ስለ ጾታዊ ጥቃት ድጋፍ']
            : const ['Where are youth clinics?', 'GBV survivor support'],
      );
    }

    // 2. HIV / AIDS
    if (_matches(normalized, [
      'hiv',
      'aids',
      'art',
      'antiretroviral',
      'vct',
      'pitc',
      'pep',
      'prep',
      'window period',
      'ኤችአይቪ',
      'ኤድስ',
      'መድሃኒት',
      'ምርመራ',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **ኤችአይቪ ምንድን ነው?** ኤችአይቪ የሰውነትን በሽታ የመከላከል አቅም የሚያጠቃ ቫይረስ ነው።\n\n'
                '• **መተላለፊያ መንገዶች፡** ጥንቃቄ በጎደለው የግብረ-ሥጋ ግንኙነት፣ በቫይረሱ ከተበከለ ደም ወይም ስለታም መርፌዎች፣ እና ከእናት ወደ ልጅ (በእርግዝና ወይም በወሊድ ጊዜ)።\n\n'
                '• **መከላከያ መንገዶች፡** ታማኝነት፣ ሁልጊዜ ኮንዶም በአግባቡ መጠቀም፣ ንጹህ መርፌዎችን መጠቀም፣ እና አደጋ ሲያጋጥም በ72 ሰዓታት ውስጥ ድንገተኛ መከላከያ (PEP) መውሰድ።\n\n'
                '• **ምርመራ እና ህክምና፡** በሁሉም የመንግስት ጤና ጣቢያዎችና ሆስፒታሎች ነፃ ሚስጥራዊ ምርመራ (VCT) እና የኤአርቲ (ART) መድሃኒት ይሰጣል።'
            : '• **What is HIV?** Human Immunodeficiency Virus attacks the immune system, specifically CD4 white blood cells.\n\n'
                '• **Transmission:** Unprotected sexual intercourse, sharing unsterilized needles/sharp instruments, and from mother to child during pregnancy or childbirth.\n\n'
                '• **Prevention:** Consistent & correct condom use, mutual fidelity with an uninfected partner, using sterile medical equipment, and taking PEP (Post-Exposure Prophylaxis) within 72 hours of potential exposure.\n\n'
                '• **Testing & Treatment:** Confidential testing (VCT and PITC) and lifelong Antiretroviral Therapy (ART) are freely available across public health centers and hospitals.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const [
                'የአባላዘር በሽታዎች ምልክቶች',
                'ኮንዶም እንዴት መጠቀም ይቻላል?',
                'የምርመራ ክሊኒኮች'
              ]
            : const [
                'STI symptoms and signs',
                'How to use a condom',
                'Where to get tested'
              ],
      );
    }

    // 3. STIs (Sexually Transmitted Infections)
    if (_matches(normalized, [
      'sti',
      'std',
      'discharge',
      'syphilis',
      'gonorrhea',
      'chlamydia',
      'ulcer',
      'itching',
      'genital',
      'አባላዘር',
      'ፈሳሽ',
      'ቁስል',
      'ማሳከክ',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **የአባላዘር በሽታዎች ምልክቶች፡** ከተለመደው የተለየ የብልት ፈሳሽ (ቀለም፣ ሽታ)፣ በሽንት ጊዜ የማቃጠል ስሜት፣ የብልት አካባቢ ማሳከክ ወይም ቁስለት።\n\n'
                '• **ወርቃማው የህክምና ህግ፡** ሁለቱም አጋሮች በአንድ ጊዜ መታከም አለባቸው (በሽታው እንዳይመላለስ)። ህክምናው ሙሉ በሙሉ እስኪያልቅ ድረስ የግብረ-ሥጋ ግንኙነትን ማቆም ያስፈልጋል።\n\n'
                '• **መከላከያ፡** የወንድ ወይም የሴት ኮንዶምን በአግባቡ መጠቀም እና ከታመነ አጋር ጋር ብቻ መወሰን።'
            : '• **Common Signs of STIs:** Unusual genital discharge (yellowish, foul-smelling), burning sensation during urination, itching, blisters, or genital sores.\n\n'
                '• **Golden Treatment Rule:** Both sexual partners MUST receive treatment simultaneously to avoid passing infections back and forth ("ping-pong" reinfection). Abstain until medication is complete and symptoms are resolved.\n\n'
                '• **Dual Protection:** External or internal condoms are the only contraceptive method that prevents both STIs and unintended pregnancy.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የኤችአይቪ መከላከያ ዘዴዎች', 'የቤተሰብ ምጣኔ አማራጮች', 'የቅርብ ክሊኒኮች']
            : const [
                'HIV prevention methods',
                'Family planning options',
                'Nearby youth clinics'
              ],
      );
    }

    // 4. Puberty & Adolescence
    if (_matches(normalized, [
      'puberty',
      'period',
      'menstruation',
      'wet dream',
      'voice',
      'breast',
      'body hair',
      'acne',
      'pimple',
      'hygiene',
      'ጉርምስና',
      'የወር አበባ',
      'ድምፅ',
      'ብጉር',
      'ንጽህና',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **የጉርምስና ወቅት ምንድን ነው?** ከልጅነት ወደ አዋቂነት የሚደረግ ተፈጥሯዊ የዕድገት ሽግግር ሲሆን አብዛኛውን ጊዜ ከ9 እስከ 14 ዓመት ባለው ዕድሜ ውስጥ ይከሰታል።\n\n'
                '• **በሴቶች ላይ የሚታዩ ለውጦች፡** የጡት ማደግ፣ የዳሌ መስፋት፣ በብልትና በብብት አካባቢ ፀጉር መብቀል፣ እና የወር አበባ (Menarche) መጀመር።\n\n'
                '• **በወንዶች ላይ የሚታዩ ለውጦች፡** የድምፅ መጎርነን፣ የፊትና የሰውነት ፀጉር ማደግ፣ የወንድ የዘር ፍሬ እድገት፣ እና በእንቅልፍ ወቅት የሚከሰት ተፈጥሯዊ የዘር ፈሳሽ መፍሰስ (Wet dream)።\n\n'
                '• **የንጽህና አጠባበቅ፡** በየቀኑ በንጹህ ውሃና ሳሙና መታጠብ፤ የወር አበባ ንጽህና መጠበቂያዎችን በየ 4–6 ሰዓታት መቀየር።'
            : '• **What is Puberty?** The natural biological transition from childhood to adulthood, usually beginning between ages 9 and 14.\n\n'
                '• **Female Milestones:** Breast budding, widening hips, underarm/pubic hair growth, and the start of monthly menstruation.\n\n'
                '• **Male Milestones:** Deepening voice, facial and body hair growth, testicle development, and involuntary nocturnal emissions ("wet dreams"), which are completely normal.\n\n'
                '• **Adolescent Hygiene:** Daily washing with clean water and mild soap to manage active sweat glands, washing the face twice daily for acne, and changing menstrual pads every 4–6 hours.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የወር አበባ ንጽህና አጠባበቅ', 'የሥነ-ተዋልዶ ጤና ግንዛቤ', 'የጉርምስና ፈተና ውሰድ']
            : const [
                'Menstrual hygiene tips',
                'Sexual & reproductive health',
                'Take Puberty Quiz'
              ],
      );
    }

    // 5. Sexual & Reproductive Health (SRH), Contraception & Consent
    if (_matches(normalized, [
      'srh',
      'contracept',
      'pregnant',
      'pregnancy',
      'condom',
      'family planning',
      'pill',
      'injection',
      'implant',
      'iud',
      'emergency contraception',
      'consent',
      'እርግዝና',
      'ኮንዶም',
      'የቤተሰብ ምጣኔ',
      'ኪኒን',
      'መርፌ',
      'ስምምነት',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **የሥነ-ተዋልዶ ጤና (SRH)፡** የአካል፣ የአእምሮ እና የማህበራዊ ደህንነትን የሚያጠቃልል የተሟላ ጤናማ ሁኔታ ነው።\n\n'
                '• **የወሊድ መከላከያ ዘዴዎች፡**\n'
                '  - *ኮንዶም፡* ያልተፈለገ እርግዝናንና የአባላዘር በሽታዎችን በአንድ ጊዜ የሚከላከል (ድርብ ጥበቃ)።\n'
                '  - *የሆርሞን ዘዴዎች፡* የዕለት ኪኒኖች፣ የመርፌ መከላከያዎች፣ እና የሚቀበሩ ኢምፕላንቶች።\n'
                '  - *የአስቸኳይ ጊዜ መከላከያ፡* ጥንቃቄ የጎደለው ግንኙነት ከተፈጠረ በኋላ በ 72–120 ሰዓታት ውስጥ መወሰድ አለበት።\n\n'
                '• **ስምምነት (Consent)፡** በማንኛውም ግንኙነት ውስጥ ስምምነት በነጻነት፣ ያለምንም ማስገደድ የሚሰጥ እና በማንኛውም ጊዜ ሊነሳ የሚችል መሆን አለበት።'
            : '• **Sexual & Reproductive Health (SRH):** A state of complete physical, mental, and social well-being in all matters relating to the reproductive system.\n\n'
                '• **Family Planning Methods:**\n'
                '  - *Condoms:* Provide vital "dual protection" against both unintended pregnancy and STIs/HIV.\n'
                '  - *Hormonal Methods:* Daily oral pills, 3-month injections, and implants regulating ovulation.\n'
                '  - *Emergency Contraception:* Must be taken within 72 to 120 hours following unprotected sex.\n\n'
                '• **Consent & Autonomy:** True consent is freely given, informed, enthusiastic, and can be withdrawn at any time without fear or pressure.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const [
                'የኤችአይቪ ምርመራ የት ይገኛል?',
                'የአባላዘር በሽታዎች መከላከያ',
                'የወጣቶች ክሊኒኮች'
              ]
            : const [
                'Where to get HIV test?',
                'STI prevention rules',
                'Find youth clinics'
              ],
      );
    }

    // 6. Gender-Based Violence (GBV)
    if (_matches(normalized, [
      'gbv',
      'violence',
      'abuse',
      'domestic',
      'assault',
      'forced marriage',
      'fgm',
      'circumcision',
      'coercion',
      'ጥቃት',
      'የቤት ውስጥ',
      'ያለዕድሜ ጋብቻ',
      'ግርዛት',
      'ማስገደድ',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **ጾታን መሰረት ያደረገ ጥቃት (GBV)፡** በጾታ እኩልነት እጦት እና በስልጣን አለመመጣጠን ሳቢያ በአንድ ሰው ላይ የሚደርስ አካላዊ፣ ስነ-ልቦናዊ፣ ጾታዊ ወይም ኢኮኖሚያዊ ጉዳት ነው።\n\n'
                '• **ዋና ዋና የጥቃት አይነቶች፡** የቤት ውስጥ ጥቃት፣ የግብረ-ሥጋ ጥቃት፣ የገንዘብ ቁጥጥር፣ እና ጎጂ ልማዳዊ ድርጊቶች (የሴት ልጅ ግርዛት እና ያለዕድሜ ጋብቻ)።\n\n'
                '• **የድጋፍ አገልግሎቶች፡** ጥቃት የደረሰባቸው ሰዎች ህክምና፣ የስነ-ልቦና ምክር እና የህግ ድጋፍ የማግኘት ሙሉ መብት አላቸው።\n\n'
                '• **ነፃ የእርዳታ መስመሮች፡** በ 952 ወይም 8335 ይደውሉ።'
            : '• **What is GBV?** Harmful acts directed against an individual based on gender inequality, abuse of power, and harmful societal norms.\n\n'
                '• **Categories:** Physical violence, emotional/psychological abuse, sexual violence and exploitation, economic deprivation, and harmful practices like female genital mutilation (FGM) and child/forced marriage.\n\n'
                '• **Support & Healing:** Survivors are never to blame. Prompt medical evaluation within 72 hours allows for emergency contraception and HIV PEP, alongside psychosocial and legal counseling.\n\n'
                '• **Confidential Hotlines:** Free support is available via 952 and 8335.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የድንገተኛ እርዳታ መስመሮች', 'የስነ-ልቦና ድጋፍ ማግኘት', 'የወጣቶች ክሊኒኮች']
            : const [
                'Emergency hotlines',
                'Mental health support',
                'Youth friendly clinics'
              ],
      );
    }

    // 7. Hepatitis B & C
    if (_matches(normalized, [
      'hepatitis',
      'liver',
      'jaundice',
      'yellow eyes',
      'hep b',
      'hep c',
      'ሄፓታይተስ',
      'ጉበት',
      'ቢጫ',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **ሄፓታይተስ ምንድን ነው?** የጉበትን ጤና የሚያጠቃ እና የሚያቆስል የቫይረስ በሽታ ነው። በብዛት የሚታወቁት ሄፓታይተስ ቢ እና ሲ ናቸው።\n\n'
                '• **መተላለፊያ መንገዶች፡** በበከለ ደም፣ ያልተጸዱ ስለታም መርፌዎች፣ ንቅሳት ወይም የባህል ህክምና መገልገያዎች፣ እና ጥንቃቄ በሌለው የግብረ-ሥጋ ግንኙነት።\n\n'
                '• **ምልክቶች፡** የድካም ስሜት፣ የሽንት ቀለም ማጨለም፣ የሆድ ህመም፣ እና የአይንና የቆዳ ቢጫ መሆን (Jaundice)።\n\n'
                '• **መከላከያ፡** የሄፓታይተስ ቢ ክትባት መውሰድ፣ ስለታም ነገሮችን በጋራ አለመጠቀም፣ እና ኮንዶም መጠቀም።'
            : '• **What is Viral Hepatitis?** An inflammation of the liver caused by viral infections, primarily Hepatitis B (HBV) and Hepatitis C (HCV).\n\n'
                '• **Transmission:** Exposure to infected blood, unsterilized injection needles, tattooing tools, and unprotected sexual activity.\n\n'
                '• **Signs:** Chronic fatigue, dark urine, abdominal discomfort, and yellowing of the eyes/skin (jaundice).\n\n'
                '• **Prevention:** Safe, effective Hepatitis B vaccination, avoiding shared razors/needles, and practicing safer sex with condoms.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የኤችአይቪ እና ሄፓታይተስ ልዩነት', 'የክሊኒክ ምርመራ ቦታዎች', 'የአባላዘር በሽታዎች']
            : const [
                'HIV vs Hepatitis difference',
                'Where to get vaccinated',
                'STI prevention'
              ],
      );
    }

    // 8. Substance Abuse & Addiction
    if (_matches(normalized, [
      'substance',
      'drug',
      'alcohol',
      'addiction',
      'khat',
      'chat',
      'smoke',
      'smoking',
      'tobacco',
      'shisha',
      'ሱስ',
      'አልኮል',
      'ጫት',
      'ሲጋራ',
      'ዕፅ',
      'ሺሻ',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **የአደንዛዥ እጾችና ሱስ ተጽእኖ፡** አልኮል፣ ጫት፣ ሲጋራ እና ሌሎች አደንዛዥ እጾች የአእምሮና የሰውነት ጤናን ይጎዳሉ፤ ለድብርትና ለከፍተኛ ሱስ ያጋልጣሉ።\n\n'
                '• **ተያያዥ አደጋዎች፡** የአእምሮ ማስተዋል መቀነስ ጥንቃቄ የጎደለው የግብረ-ሥጋ ግንኙነት እንዲፈጠርና ለኤችአይቪ/አባላዘር በሽታዎች ተጋላጭነትን ይጨምራል።\n\n'
                '• **ድጋፍ ማግኘት፡** ሱስ ሊታከም የሚችል ሲሆን በነፃ የምክር አገልግሎት ለማግኘት በ 8335 መደወል ይቻላል።'
            : '• **Impact of Substance Abuse:** Misuse of alcohol, khat, tobacco, shisha, prescription pills, or illicit drugs alters brain chemistry, judgment, and emotional stability.\n\n'
                '• **Health Risks:** Impaired judgment sharply increases the likelihood of unprotected sexual encounters, STI/HIV transmission, academic struggle, and physical dependence.\n\n'
                '• **Recovery:** Addiction is treatable. Compassionate, non-judgmental counseling is available via the 8335 Youth Line.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የአእምሮ ጤና ድጋፍ', 'የወጣቶች ነፃ የስልክ መስመር', 'የስነ-ተዋልዶ ጤና']
            : const [
                'Mental health support',
                'Free youth helpline',
                'Reproductive health'
              ],
      );
    }

    // 9. Mental Health & Distress
    if (_matches(normalized, [
      'mental',
      'stress',
      'depress',
      'anxiety',
      'sad',
      'worry',
      'fear',
      'lonely',
      'አእምሮ',
      'ጭንቀት',
      'ድብርት',
      'ፍርሃት',
      'ብቸኝነት',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? '• **የአእምሮ ጤና ደህንነት፡** በጉርምስናና በወጣትነት ወቅት የስሜት መለዋወጥ፣ ጭንቀትና ፍርሃት ማጋጠሙ የተለመደ ነው።\n\n'
                '• **ስሜትን ማረጋጋት፡** ከታመነ ጓደኛ ወይም አማካሪ ጋር መነጋገር፣ በቂ እንቅልፍ ማግኘት፣ እና የእረፍት ጊዜያትን መውሰድ።\n\n'
                '• **የባለሙያ ድጋፍ፡** ከፍተኛ ጭንቀት ወይም ድብርት ከተሰማዎት በ 8335 ደውለው ሚስጥራዊ የስነ-ልቦና ባለሙያ ማናገር ይችላሉ።'
            : '• **Adolescent Mental Health:** Experiencing emotional turbulence, social stress, or academic pressure during youth is common.\n\n'
                '• **Self-Care Practices:** Maintain regular sleep routines, practice deep breathing exercises, exercise regularly, and speak openly with trusted friends or mentors.\n\n'
                '• **Professional Counseling:** Whenever feelings of hopelessness persist, free confidential guidance is available through the 8335 National Youth & Mental Health Line.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የወጣቶች ነፃ መስመር 8335', 'የጉርምስና ስሜቶች', 'የየኛ አማካሪዎች']
            : ['Call 8335 Helpline', 'Puberty emotions', 'Yegna Mentors'],
      );
    }

    // 10. Youth Clinics & Testing Facilities
    if (_matches(normalized, [
      'clinic',
      'hospital',
      'facility',
      'center',
      'fgae',
      'where can i',
      'test location',
      'address',
      'addis',
      'ክሊኒክ',
      'ሆስፒታል',
      'ተቋም',
      'የምርመራ ቦታ',
      'አድራሻ',
      'አዲስ አበባ',
    ])) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? 'በአዲስ አበባ ውስጥ ያሉ ዋና ዋና የወጣቶች ተስማሚ የጤና ተቋማት፡\n\n'
                '1. **FGAE የወጣቶች ማዕከል (ሳርቤት)፡** የስነ-ተዋልዶ፣ የኤችአይቪ/አባላዘር ምርመራ እና የወሊድ መከላከያ (ከሰኞ–ቅዳሜ)።\n'
                '2. **የሰላም ልጆች መንደር ክሊኒክ (ኮተቤ)፡** የታዳጊዎች ጤና እና የምክር አገልግሎት።\n'
                '3. **የአዲስ አበባ ዩኒቨርሲቲ የተማሪዎች ክሊኒክ (6 ኪሎ)፡** ለተማሪዎች ነፃ አገልግሎት።\n'
                '4. **ቅዱስ ጳውሎስ ሚሊኒየም ሆስፒታል የወጣቶች ክሊኒክ (ስዊስ)፡** ልዩ የስነ-ተዋልዶ እና የስነ-ልቦና ህክምና።\n'
                '5. **ALERT የወጣቶች ማዕከል (ዛንዚባር/ጦር ኃይሎች)፡** የቆዳ፣ አባላዘር እና አጠቃላይ ጤና።\n\n'
                'በመተግበሪያው ላይ የ **"Facilities"** ገጽን በመክፈት ካርታውንና የቅርብ ርቀትን መመልከት ይችላሉ።'
            : 'Verified youth-friendly healthcare clinics in Addis Ababa:\n\n'
                '1. **FGAE Youth Center (Sarbet):** Confidential SRH, HIV/STI rapid testing, and family planning (Mon–Sat).\n'
                '2. **Selam Children\'s Village Clinic (Kotebe):** Adolescent health services and counseling.\n'
                '3. **AAU Student Health Center (6 Kilo):** Free student health services.\n'
                '4. **St. Paul\'s Millennium Medical College Youth Clinic (Swis):** Specialized adolescent care.\n'
                '5. **ALERT Youth Friendly Center (Zanzibar / Tor Hailoch):** Dermatology, STI screening, and youth counseling.\n\n'
                'Tap the **"Facilities"** tab in the bottom bar to view live GPS distances and turn-by-turn directions.',
        isUser: false,
        timestamp: DateTime.now(),
        suggestedPrompts: isAmharic
            ? const ['የኤችአይቪ ምርመራ', 'የአባላዘር በሽታዎች', 'የአስቸኳይ ጊዜ መከላከያ']
            : const [
                'HIV rapid testing',
                'STI symptoms',
                'Emergency contraception'
              ],
      );
    }

    // 11. General / Welcome Exploration
    return ChatMessage(
      id: messageId,
      text: isAmharic
          ? 'እኔ የየኛ ጤና ረዳት ነኝ። በምን ልርዳዎት?\n\n'
              'የሚከተሉትን ርዕሶች መጠየቅ ይችላሉ፡\n'
              '• የጉርምስና ወቅት ለውጦች እና ንጽህና\n'
              '• የኤችአይቪ እና የአባላዘር በሽታዎች መከላከያና ምርመራ\n'
              '• የስነ-ተዋልዶ ጤና እና የቤተሰብ ምጣኔ ዘዴዎች\n'
              '• ሄፓታይተስ ቢ እና ሲ መረጃ\n'
              '• በአዲስ አበባ ያሉ የወጣቶች ክሊኒኮች አድራሻ'
          : 'I am your Yegna Health Assistant. How can I help you today?\n\n'
              'You can ask me about:\n'
              '• Puberty changes and adolescent hygiene\n'
              '• HIV/AIDS & STI prevention, symptoms, and testing\n'
              '• Reproductive health, consent, and family planning methods\n'
              '• Viral Hepatitis transmission and liver health\n'
              '• Verified youth-friendly health clinics in Addis Ababa',
      isUser: false,
      timestamp: DateTime.now(),
      suggestedPrompts: isAmharic
          ? const [
              'ኤችአይቪን እንዴት መከላከል ይቻላል?',
              'የጉርምስና ተፈጥሯዊ ለውጦች',
              'የምርመራ ክሊኒኮች የት ይገኛሉ?',
              'የአስቸኳይ ጊዜ የወሊድ መከላከያ'
            ]
          : const [
              'How to prevent HIV?',
              'Normal puberty changes',
              'Where can I get tested?',
              'Emergency contraception'
            ],
    );
  }

  bool _isEmergencyQuery(String query) {
    if (query.contains('emergency contraception') ||
        query.contains('የአስቸኳይ ጊዜ የወሊድ') ||
        query.contains('የአስቸኳይ ጊዜ መከላከያ')) {
      return false;
    }

    const emergencyKeywords = [
      'suicide',
      'suicidal',
      'suicid',
      'kill myself',
      'end my life',
      'raped',
      'rape',
      'assault',
      'assaulted',
      'bleeding heavily',
      'acute emergency',
      'hurt myself',
      'beaten',
      'እራሴን',
      'መግደል',
      'ድብደባ',
      'አስገድዶ',
      'ጥቃት',
      'ከፍተኛ ደም',
    ];
    return emergencyKeywords.any((k) => query.contains(k));
  }

  bool _matches(String query, List<String> keywords) {
    return keywords.any((k) => query.contains(k));
  }
}
