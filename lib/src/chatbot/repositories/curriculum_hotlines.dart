import '../chatbot_models.dart';

const hotline952En = EmergencyHotlineAction(
  name: 'National Health Emergency Line',
  number: '952',
  description: 'Ministry of Health 24/7 free line for acute health emergencies',
);

const hotline8335En = EmergencyHotlineAction(
  name: 'National Youth & Mental Health Line',
  number: '8335',
  description: 'Confidential counseling for reproductive health and distress',
);

const hotline952Am = EmergencyHotlineAction(
  name: 'ብሔራዊ የጤና ድንገተኛ አደጋ መስመር',
  number: '952',
  description: 'የጤና ጥበቃ ሚኒስቴር 24/7 ነፃ የድንገተኛ የጤና አገልግሎት',
);

const hotline8335Am = EmergencyHotlineAction(
  name: 'ብሔራዊ የወጣቶች እና የአእምሮ ጤና መስመር',
  number: '8335',
  description: 'ሚስጥራዊ የስነ-ተዋልዶ እና የአእምሮ ጤና የምክር አገልግሎት',
);

bool isGreetingQuery(String query) {
  const greetingWords = [
    'hi',
    'hello',
    'hey',
    'greetings',
    'good morning',
    'good afternoon',
    'good evening',
    'start',
    'help',
    'how are you',
    'ሰላም',
    'እንደምን',
    'ጤና ይስጥልኝ',
    'እንደምናት',
    'እንዴት ነህ',
    'እንዴት ነሽ',
    'እርዳኝ',
  ];
  return greetingWords.any((g) =>
      query == g ||
      query.startsWith('$g ') ||
      query.endsWith(' $g') ||
      query.contains(' $g '));
}

bool isEmergencyQuery(String query) {
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

bool matchesQuery(String query, List<String> keywords) {
  return keywords.any((k) => query.contains(k));
}
