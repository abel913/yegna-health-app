import '../chatbot_models.dart';

ChatMessage buildHivResponse(String messageId, bool isAmharic) {
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
        ? const ['የአባላዘር በሽታዎች ምልክቶች', 'ኮንዶም እንዴት መጠቀም ይቻላል?', 'የምርመራ ክሊኒኮች']
        : const ['STI symptoms and signs', 'How to use a condom', 'Where to get tested'],
  );
}

ChatMessage buildStiResponse(String messageId, bool isAmharic) {
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
        : const ['HIV prevention methods', 'Family planning options', 'Nearby youth clinics'],
  );
}

ChatMessage buildPubertyResponse(String messageId, bool isAmharic) {
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
        : const ['Menstrual hygiene tips', 'Sexual & reproductive health', 'Take Puberty Quiz'],
  );
}

ChatMessage buildSrhResponse(String messageId, bool isAmharic) {
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
        ? const ['የኤችአይቪ ምርመራ የት ይገኛል?', 'የአባላዘር በሽታዎች መከላከያ', 'የወጣቶች ክሊኒኮች']
        : const ['Where to get HIV test?', 'STI prevention rules', 'Find youth clinics'],
  );
}
