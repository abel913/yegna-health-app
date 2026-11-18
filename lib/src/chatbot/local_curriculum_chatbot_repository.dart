import 'dart:math' as math;

import 'chatbot_models.dart';
import 'chatbot_repository.dart';
import 'repositories/curriculum_hotlines.dart';
import 'repositories/curriculum_medical_responses.dart';
import 'repositories/curriculum_wellbeing_responses.dart';

/// Intelligent on-device educational knowledge engine grounded in Yegna Health's
/// 8 learning modules and verified Ethiopian youth healthcare clinic directory.
class LocalCurriculumChatbotRepository implements ChatbotRepository {
  const LocalCurriculumChatbotRepository();

  @override
  Future<ChatMessage> sendMessage(
    String query, {
    required String languageCode,
    List<ChatMessage> history = const [],
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));

    final normalized = query.trim().toLowerCase();
    final isAmharic = languageCode.toLowerCase().startsWith('am');
    final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}_${math.Random().nextInt(9999)}';

    // 1. Crisis & Emergency Detection
    if (isEmergencyQuery(normalized)) {
      return ChatMessage(
        id: messageId,
        text: isAmharic
            ? 'አስቸኳይ እርዳታ ይፈልጋሉ? እባክዎ ብቻዎን አይሁኑ። ነፃ፣ ሚስጥራዊ እና ፈጣን እርዳታ ለማግኘት ከታች ባሉት መስመሮች አሁኑኑ ይደውሉ፡'
            : 'If you are experiencing acute danger, abuse, severe pain, or emotional distress, immediate help is available. Please reach out to these free, confidential national helplines right now:',
        isUser: false,
        timestamp: DateTime.now(),
        isEmergency: true,
        emergencyHotlines: isAmharic ? const [hotline952Am, hotline8335Am] : const [hotline952En, hotline8335En],
        suggestedPrompts: isAmharic
            ? const ['የወጣቶች ክሊኒኮች የት ይገኛሉ?', 'ስለ ጾታዊ ጥቃት ድጋፍ']
            : const ['Where are youth clinics?', 'GBV survivor support'],
      );
    }

    // 2. HIV / AIDS
    if (matchesQuery(normalized, [
      'hiv', 'aids', 'art', 'antiretroviral', 'vct', 'pitc', 'pep', 'prep', 'window period',
      'ኤችአይቪ', 'ኤድስ', 'መድሃኒት', 'ምርመራ',
    ])) {
      return buildHivResponse(messageId, isAmharic);
    }

    // 3. STIs
    if (matchesQuery(normalized, [
      'sti', 'std', 'discharge', 'syphilis', 'gonorrhea', 'chlamydia', 'ulcer', 'itching', 'genital',
      'አባላዘር', 'ፈሳሽ', 'ቁስል', 'ማሳከክ',
    ])) {
      return buildStiResponse(messageId, isAmharic);
    }

    // 4. Puberty & Adolescence
    if (matchesQuery(normalized, [
      'puberty', 'period', 'menstruation', 'wet dream', 'voice', 'breast', 'body hair', 'acne', 'pimple', 'hygiene',
      'ጉርምስና', 'የወር አበባ', 'ድምፅ', 'ብጉር', 'ንጽህና',
    ])) {
      return buildPubertyResponse(messageId, isAmharic);
    }

    // 5. SRH & Contraception
    if (matchesQuery(normalized, [
      'srh', 'contracept', 'pregnant', 'pregnancy', 'condom', 'family planning', 'pill', 'injection', 'implant',
      'iud', 'emergency contraception', 'consent', 'እርግዝና', 'ኮንዶም', 'የቤተሰብ ምጣኔ', 'ኪኒን', 'መርፌ', 'ስምምነት',
    ])) {
      return buildSrhResponse(messageId, isAmharic);
    }

    // 6. GBV
    if (matchesQuery(normalized, [
      'gbv', 'violence', 'abuse', 'domestic', 'assault', 'forced marriage', 'fgm', 'circumcision', 'coercion',
      'ጥቃት', 'የቤት ውስጥ', 'ያለዕድሜ ጋብቻ', 'ግርዛት', 'ማስገደድ',
    ])) {
      return buildGbvResponse(messageId, isAmharic);
    }

    // 7. Hepatitis B & C
    if (matchesQuery(normalized, [
      'hepatitis', 'liver', 'jaundice', 'yellow eyes', 'hep b', 'hep c', 'ሄፓታይተስ', 'ጉበት', 'ቢጫ',
    ])) {
      return buildHepatitisResponse(messageId, isAmharic);
    }

    // 8. Substance Abuse & Addiction
    if (matchesQuery(normalized, [
      'substance', 'drug', 'alcohol', 'addiction', 'khat', 'chat', 'smoke', 'smoking', 'tobacco', 'shisha',
      'ሱስ', 'አልኮል', 'ጫት', 'ሲጋራ', 'ዕፅ', 'ሺሻ',
    ])) {
      return buildSubstanceAbuseResponse(messageId, isAmharic);
    }

    // 9. Mental Health & Distress
    if (matchesQuery(normalized, [
      'mental', 'stress', 'depress', 'anxiety', 'sad', 'worry', 'fear', 'lonely',
      'አእምሮ', 'ጭንቀት', 'ድብርት', 'ፍርሃት', 'ብቸኝነት',
    ])) {
      return buildMentalHealthResponse(messageId, isAmharic);
    }

    // 10. Youth Clinics & Testing Facilities
    if (matchesQuery(normalized, [
      'clinic', 'hospital', 'facility', 'center', 'fgae', 'where can i', 'test location', 'address', 'addis',
      'ክሊኒክ', 'ሆስፒታል', 'ተቋም', 'የምርመራ ቦታ', 'አድራሻ', 'አዲስ አበባ',
    ])) {
      return buildClinicsResponse(messageId, isAmharic);
    }

    // 11. Greetings
    if (isGreetingQuery(normalized)) {
      return buildGreetingResponse(messageId, isAmharic);
    }

    // 12. Non-Health Refusal & Redirection
    return buildOutOfScopeResponse(messageId, isAmharic);
  }
}
