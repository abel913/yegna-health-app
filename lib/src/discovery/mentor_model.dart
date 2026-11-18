import 'package:flutter/material.dart';

enum MentorTopic {
  all,
  mentalHealth,
  srhGuidance,
  puberty,
  substanceAbuse,
}

class DayAvailability {
  const DayAvailability({
    required this.dayKey,
    required this.isEnabled,
    this.startTime = '08:30',
    this.endTime = '17:30',
  });

  final String dayKey; // 'monday', 'tuesday', etc.
  final bool isEnabled;
  final String startTime; // '08:30' (24-hour HH:mm)
  final String endTime; // '17:30'

  Map<String, dynamic> toJson() => {
        'dayKey': dayKey,
        'isEnabled': isEnabled,
        'startTime': startTime,
        'endTime': endTime,
      };

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(
      dayKey: (json['dayKey'] ?? json['day'] ?? 'monday').toString().toLowerCase(),
      isEnabled: json['isEnabled'] == true || json['enabled'] == true,
      startTime: (json['startTime'] ?? json['start'] ?? '08:30').toString(),
      endTime: (json['endTime'] ?? json['end'] ?? '17:30').toString(),
    );
  }

  DayAvailability copyWith({
    String? dayKey,
    bool? isEnabled,
    String? startTime,
    String? endTime,
  }) {
    return DayAvailability(
      dayKey: dayKey ?? this.dayKey,
      isEnabled: isEnabled ?? this.isEnabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}

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

class Mentor {
  const Mentor({
    required this.id,
    required this.nameEn,
    required this.nameAm,
    required this.titleEn,
    required this.titleAm,
    required this.organizationEn,
    required this.organizationAm,
    required this.bioEn,
    required this.bioAm,
    required this.isVerified,
    required this.isOnline,
    required this.nextAvailableSlotEn,
    required this.nextAvailableSlotAm,
    required this.languages,
    required this.topics,
    required this.sessionsCount,
    required this.experienceYears,
    required this.initials,
    required this.avatarColor,
    this.phoneNumber = '+251911234567',
    this.displayPhoneNumber = '+251 91 123 4567',
    this.telegramHandle = 'yegna_youth_support',
    this.whatsapp,
    this.email,
    this.campus = 'Atse Fasil Campus',
    this.workingHoursEn = 'Mon – Fri: 8:30 AM – 5:30 PM',
    this.workingHoursAm = 'ከሰኞ – ዓርብ፡ 2:30 – 11:30',
    this.safeguardingPolicyEn =
        'Strictly confidential peer counseling. Peer mentors follow certified national child and youth protection safeguarding guidelines. All conversations remain private and non-judgmental.',
    this.safeguardingPolicyAm =
        'በጥብቅ ሚስጥራዊ የአቻ ምክክር። አቻ አማካሪዎች የተረጋገጡ ብሔራዊ የህፃናትና ወጣቶች ጥበቃ መመሪያዎችን ይከተላሉ። ሁሉም ውይይቶች ሚስጥራዊ እና ከፍረጃ ነፃ ናቸው።',
    this.weeklySchedule,
  });

  final String id;
  final String nameEn;
  final String nameAm;
  final String titleEn;
  final String titleAm;
  final String organizationEn;
  final String organizationAm;
  final String bioEn;
  final String bioAm;
  final bool isVerified;
  final bool isOnline;
  final String nextAvailableSlotEn;
  final String nextAvailableSlotAm;
  final List<String> languages;
  final List<MentorTopic> topics;
  final int sessionsCount;
  final int experienceYears;
  final String initials;
  final Color avatarColor;
  final String phoneNumber;
  final String displayPhoneNumber;
  final String telegramHandle;
  final String? whatsapp;
  final String? email;
  final String campus;
  final String workingHoursEn;
  final String workingHoursAm;
  final String safeguardingPolicyEn;
  final String safeguardingPolicyAm;
  final Map<String, DayAvailability>? weeklySchedule;

  String get cleanTelegramHandle => telegramHandle.replaceAll('@', '').trim();
  String get cleanWhatsapp => (whatsapp ?? '').trim();
  bool get hasWhatsapp => whatsapp != null && cleanWhatsapp.isNotEmpty;
  bool get hasEmail => email != null && email!.trim().isNotEmpty;

  String localizedCampus(bool isAmharic) {
    if (!isAmharic) return campus;
    if (campus.contains('Atse Fasil') || campus.contains('ፋሲል')) {
      return 'አጼ ፋሲል ግቢ';
    }
    if (campus.contains('Atse Tewodros') || campus.contains('ቴዎድሮስ')) {
      return 'አጼ ቴዎድሮስ ግቢ';
    }
    if (campus.contains('CMHS') || campus.contains('Health') || campus.contains('ጤና')) {
      return 'የጤና ሳይንስ ኮሌጅ ግቢ';
    }
    if (campus.contains('Maraki') || campus.contains('ማራኪ')) {
      return 'ማራኪ ግቢ';
    }
    if (campus.contains('Teda') || campus.contains('ተዳ')) {
      return 'ተዳ ግቢ';
    }
    if (campus.contains('Central') || campus.contains('All') || campus.contains('ማዕከላዊ')) {
      return 'ማዕከላዊ ዳይሬክቶሬት / ሁሉም ግቢዎች';
    }
    return campus;
  }

  String localizedName(bool isAmharic) => isAmharic ? nameAm : nameEn;
  String localizedTitle(bool isAmharic) => isAmharic ? titleAm : titleEn;
  String localizedOrg(bool isAmharic) =>
      isAmharic ? organizationAm : organizationEn;
  String localizedBio(bool isAmharic) => isAmharic ? bioAm : bioEn;
  String localizedNextSlot(bool isAmharic) =>
      isAmharic ? nextAvailableSlotAm : nextAvailableSlotEn;
  String localizedPolicy(bool isAmharic) =>
      isAmharic ? safeguardingPolicyAm : safeguardingPolicyEn;
  String localizedWorkingHours(bool isAmharic) =>
      isAmharic ? workingHoursAm : workingHoursEn;

  DayAvailability? getDayAvailability(int weekday) {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    if (weekday < 1 || weekday > 7) return null;
    final key = days[weekday - 1];
    if (weeklySchedule != null && weeklySchedule!.containsKey(key)) {
      return weeklySchedule![key];
    }
    // Default fallback: Mon–Fri enabled 08:30–17:30, Sat/Sun disabled
    final isDefaultWorkday = weekday >= 1 && weekday <= 5;
    return DayAvailability(
      dayKey: key,
      isEnabled: isDefaultWorkday,
      startTime: '08:30',
      endTime: '17:30',
    );
  }

  bool isDayActive(int weekday) {
    final day = getDayAvailability(weekday);
    return day?.isEnabled ?? false;
  }

  List<String> getAvailableSlotsForDate(DateTime date) {
    final day = getDayAvailability(date.weekday);
    if (day == null || !day.isEnabled) return const [];

    final startParts = day.startTime.split(':');
    final endParts = day.endTime.split(':');
    final startHour = int.tryParse(startParts[0]) ?? 8;
    final startMin = startParts.length > 1 ? (int.tryParse(startParts[1]) ?? 30) : 0;
    final endHour = int.tryParse(endParts[0]) ?? 17;
    final endMin = endParts.length > 1 ? (int.tryParse(endParts[1]) ?? 30) : 0;

    int currentMinutes = startHour * 60 + startMin;
    final endMinutes = endHour * 60 + endMin;
    final slots = <String>[];

    while (currentMinutes < endMinutes) {
      final h = currentMinutes ~/ 60;
      final m = currentMinutes % 60;
      final ampm = h >= 12 ? 'PM' : 'AM';
      final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
      final minuteStr = m.toString().padLeft(2, '0');
      slots.add('$hour12:$minuteStr $ampm');
      currentMinutes += 30; // 30-min consultation slots
    }
    return slots;
  }

  static int parseTimeToMinutes(String timeStr) {
    final clean = timeStr.trim().toUpperCase();
    final isPM = clean.contains('PM');
    final isAM = clean.contains('AM');
    final digits = clean.replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = digits.split(':');
    if (parts.isEmpty) return 0;
    int hour = int.tryParse(parts[0]) ?? 0;
    final min = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;

    if (isPM && hour < 12) hour += 12;
    if (isAM && hour == 12) hour = 0;

    return hour * 60 + min;
  }

  bool isAvailableAt(DateTime time) {
    final day = getDayAvailability(time.weekday);
    if (day == null || !day.isEnabled) return false;

    final startMinTotal = parseTimeToMinutes(day.startTime);
    final endMinTotal = parseTimeToMinutes(day.endTime);
    final currentMinTotal = time.hour * 60 + time.minute;

    return currentMinTotal >= startMinTotal && currentMinTotal <= endMinTotal;
  }

  bool get isCurrentlyAvailableNow {
    return isAvailableAt(DateTime.now());
  }

  NextOpeningInfo? getNextOpeningInfo([DateTime? referenceTime]) {
    final now = referenceTime ?? DateTime.now();
    final todayWeekday = now.weekday;
    final currentMinTotal = now.hour * 60 + now.minute;

    // 1. Check if opens later today
    final today = getDayAvailability(todayWeekday);
    if (today != null && today.isEnabled) {
      final startMin = parseTimeToMinutes(today.startTime);
      if (currentMinTotal < startMin) {
        return NextOpeningInfo(
          weekday: todayWeekday,
          daysAhead: 0,
          startTime: today.startTime,
        );
      }
    }

    // 2. Scan the next 7 days for the first active window
    for (int offset = 1; offset <= 7; offset++) {
      int nextWeekday = (todayWeekday - 1 + offset) % 7 + 1;
      final nextDay = getDayAvailability(nextWeekday);
      if (nextDay != null && nextDay.isEnabled) {
        return NextOpeningInfo(
          weekday: nextWeekday,
          daysAhead: offset,
          startTime: nextDay.startTime,
        );
      }
    }
    return null;
  }

  static String formatTimeString(String timeStr, bool isAmharic) {
    final clean = timeStr.trim().toUpperCase();
    final isPM = clean.contains('PM');
    final isAM = clean.contains('AM');
    final digits = clean.replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = digits.split(':');
    int hour = int.tryParse(parts[0]) ?? 8;
    final min = parts.length > 1 ? (int.tryParse(parts[1]) ?? 0) : 0;
    final minStr = min.toString().padLeft(2, '0');

    if (isPM && hour < 12) hour += 12;
    if (isAM && hour == 12) hour = 0;

    if (isAmharic) {
      int ethHour = (hour - 6) % 12;
      if (ethHour <= 0) ethHour += 12;
      return '$ethHour:$minStr';
    } else {
      final ampm = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$hour12:$minStr $ampm';
    }
  }

  String formatTimeRange(int weekday, bool isAmharic) {
    final day = getDayAvailability(weekday);
    if (day == null || !day.isEnabled) {
      return isAmharic ? 'ዝግ ነው' : 'Closed / Off';
    }
    final start = formatTimeString(day.startTime, isAmharic);
    final end = formatTimeString(day.endTime, isAmharic);
    return '$start – $end';
  }

  String getCurrentStatusText(bool isAmharic) {
    final now = DateTime.now();
    final today = getDayAvailability(now.weekday);
    if (isCurrentlyAvailableNow && today != null) {
      final end = formatTimeString(today.endTime, isAmharic);
      return isAmharic
          ? 'አሁን ክፍት ነው • እስከ $end'
          : 'Available Now • Open until $end';
    }

    final nextOpening = getNextOpeningInfo(now);
    if (nextOpening != null) {
      final dayLabel = nextOpening.localizedDayLabel(isAmharic);
      final startTimeStr = formatTimeString(nextOpening.startTime, isAmharic);
      if (isAmharic) {
        return 'ዝግ ነው • $dayLabel በ$startTimeStr ይከፈታል';
      } else {
        return 'Closed • Opens $dayLabel at $startTimeStr';
      }
    }

    return isAmharic ? 'በአሁኑ ሰዓት ዝግ ነው' : 'Currently Offline / Closed';
  }

  String getDynamicNextSlotText(bool isAmharic) {
    if (isCurrentlyAvailableNow) {
      return isAmharic ? 'አሁን ይገኛሉ' : 'Available Now';
    }
    final nextOpening = getNextOpeningInfo();
    if (nextOpening != null) {
      final dayLabel = nextOpening.localizedDayLabel(isAmharic);
      final startTimeStr = formatTimeString(nextOpening.startTime, isAmharic);
      if (isAmharic) {
        return '$dayLabel በ$startTimeStr';
      } else {
        return 'Opens $dayLabel $startTimeStr';
      }
    }
    return localizedNextSlot(isAmharic);
  }

  Mentor copyWith({
    String? id,
    String? nameEn,
    String? nameAm,
    String? titleEn,
    String? titleAm,
    String? organizationEn,
    String? organizationAm,
    String? bioEn,
    String? bioAm,
    bool? isVerified,
    bool? isOnline,
    String? nextAvailableSlotEn,
    String? nextAvailableSlotAm,
    List<String>? languages,
    List<MentorTopic>? topics,
    int? sessionsCount,
    int? experienceYears,
    String? initials,
    Color? avatarColor,
    String? phoneNumber,
    String? displayPhoneNumber,
    String? telegramHandle,
    String? whatsapp,
    String? email,
    String? campus,
    String? workingHoursEn,
    String? workingHoursAm,
    String? safeguardingPolicyEn,
    String? safeguardingPolicyAm,
    Map<String, DayAvailability>? weeklySchedule,
  }) {
    return Mentor(
      id: id ?? this.id,
      nameEn: nameEn ?? this.nameEn,
      nameAm: nameAm ?? this.nameAm,
      titleEn: titleEn ?? this.titleEn,
      titleAm: titleAm ?? this.titleAm,
      organizationEn: organizationEn ?? this.organizationEn,
      organizationAm: organizationAm ?? this.organizationAm,
      bioEn: bioEn ?? this.bioEn,
      bioAm: bioAm ?? this.bioAm,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      nextAvailableSlotEn: nextAvailableSlotEn ?? this.nextAvailableSlotEn,
      nextAvailableSlotAm: nextAvailableSlotAm ?? this.nextAvailableSlotAm,
      languages: languages ?? this.languages,
      topics: topics ?? this.topics,
      sessionsCount: sessionsCount ?? this.sessionsCount,
      experienceYears: experienceYears ?? this.experienceYears,
      initials: initials ?? this.initials,
      avatarColor: avatarColor ?? this.avatarColor,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayPhoneNumber: displayPhoneNumber ?? this.displayPhoneNumber,
      telegramHandle: telegramHandle ?? this.telegramHandle,
      whatsapp: whatsapp ?? this.whatsapp,
      email: email ?? this.email,
      campus: campus ?? this.campus,
      workingHoursEn: workingHoursEn ?? this.workingHoursEn,
      workingHoursAm: workingHoursAm ?? this.workingHoursAm,
      safeguardingPolicyEn: safeguardingPolicyEn ?? this.safeguardingPolicyEn,
      safeguardingPolicyAm: safeguardingPolicyAm ?? this.safeguardingPolicyAm,
      weeklySchedule: weeklySchedule ?? this.weeklySchedule,
    );
  }
}
