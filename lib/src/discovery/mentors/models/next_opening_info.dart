class NextOpeningInfo {
  const NextOpeningInfo({
    required this.weekday,
    required this.daysAhead,
    required this.startTime,
  });

  final int weekday;
  final int daysAhead;
  final String startTime;

  String localizedDayLabel(bool isAmharic) {
    if (daysAhead == 0) return isAmharic ? 'ዛሬ' : 'Today';
    if (daysAhead == 1) return isAmharic ? 'ነገ' : 'Tomorrow';
    switch (weekday) {
      case 1:
        return isAmharic ? 'ሰኞ' : 'Monday';
      case 2:
        return isAmharic ? 'ማክሰኞ' : 'Tuesday';
      case 3:
        return isAmharic ? 'ረቡዕ' : 'Wednesday';
      case 4:
        return isAmharic ? 'ሐሙስ' : 'Thursday';
      case 5:
        return isAmharic ? 'አርብ' : 'Friday';
      case 6:
        return isAmharic ? 'ቅዳሜ' : 'Saturday';
      case 7:
        return isAmharic ? 'እሑድ' : 'Sunday';
      default:
        return '';
    }
  }
}
