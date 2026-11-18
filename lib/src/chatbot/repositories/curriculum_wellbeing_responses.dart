import '../chatbot_models.dart';

ChatMessage buildGbvResponse(String messageId, bool isAmharic) {
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
        : const ['Emergency hotlines', 'Mental health support', 'Youth friendly clinics'],
  );
}

ChatMessage buildHepatitisResponse(String messageId, bool isAmharic) {
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
        : const ['HIV vs Hepatitis difference', 'Where to get vaccinated', 'STI prevention'],
  );
}

ChatMessage buildSubstanceAbuseResponse(String messageId, bool isAmharic) {
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
        : const ['Mental health support', 'Free youth helpline', 'Reproductive health'],
  );
}

ChatMessage buildMentalHealthResponse(String messageId, bool isAmharic) {
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

ChatMessage buildClinicsResponse(String messageId, bool isAmharic) {
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
        : const ['HIV rapid testing', 'STI symptoms', 'Emergency contraception'],
  );
}

ChatMessage buildGreetingResponse(String messageId, bool isAmharic) {
  return ChatMessage(
    id: messageId,
    text: isAmharic
        ? 'ሰላም! እኔ የየኛ ጤና ረዳት ነኝ። በምን ልርዳዎት?\n\n'
            'የሚከተሉትን ርዕሶች መጠየቅ ይችላሉ፡\n'
            '• የጉርምስና ወቅት ለውጦች እና ንጽህና\n'
            '• የኤችአይቪ እና የአባላዘር በሽታዎች መከላከያና ምርመራ\n'
            '• የስነ-ተዋልዶ ጤና እና የቤተሰብ ምጣኔ ዘዴዎች\n'
            '• ሄፓታይተስ ቢ እና ሲ መረጃ\n'
            '• በአዲስ አበባ ያሉ የወጣቶች ክሊኒኮች አድራሻ'
        : 'Hello! I am your Yegna Health Assistant. How can I help you today?\n\n'
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

ChatMessage buildOutOfScopeResponse(String messageId, bool isAmharic) {
  return ChatMessage(
    id: messageId,
    text: isAmharic
        ? 'እኔ የተዘጋጀሁት ለየኛ ጤና (Yegna Health) የጤና፣ የስነ-ተዋልዶ እና የወጣቶች ደህንነት ረዳት ሆኜ ብቻ ነው። ከጤና፣ ከጉርምስና፣ ከስነ-ተዋልዶ እና ከአእምሮ ደህንነት ውጭ ያሉ አጠቃላይ የትምህርት ወይም ሌሎች ጉዳዮችን (እንደ ፊዚክስ፣ ሂሳብ፣ ቴክኖሎጂ ወዘተ) መመለስ አልችልም።\n\n'
            'ስለ ጤናዎ፣ ስለ ጉርምስና ለውጦች፣ ስለ ኤችአይቪ/አባላዘር በሽታዎች ወይም በአቅራቢያዎ ስላሉ ክሊኒኮች ማንኛውንም ጥያቄ በደስታ መጠየቅ ይችላሉ!'
        : 'I am designed specifically as a health, reproductive, and youth wellbeing guide for Yegna Health. I can only assist with questions regarding adolescent health, sexual & reproductive health, puberty, mental wellbeing, or youth clinic services.\n\n'
            'Please feel free to ask me any question about your health and wellbeing!',
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
