import 'day_availability.dart';
import 'mentor.dart';
import 'next_opening_info.dart';

extension MentorScheduleExtension on Mentor {
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
    final startMin =
        startParts.length > 1 ? (int.tryParse(startParts[1]) ?? 30) : 0;
    final endHour = int.tryParse(endParts[0]) ?? 17;
    final endMin =
        endParts.length > 1 ? (int.tryParse(endParts[1]) ?? 30) : 0;

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
      currentMinutes += 30;
    }
    return slots;
  }

  bool isAvailableAt(DateTime time) {
    final day = getDayAvailability(time.weekday);
    if (day == null || !day.isEnabled) return false;

    final startMinTotal = Mentor.parseTimeToMinutes(day.startTime);
    final endMinTotal = Mentor.parseTimeToMinutes(day.endTime);
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

    final today = getDayAvailability(todayWeekday);
    if (today != null && today.isEnabled) {
      final startMin = Mentor.parseTimeToMinutes(today.startTime);
      if (currentMinTotal < startMin) {
        return NextOpeningInfo(
          weekday: todayWeekday,
          daysAhead: 0,
          startTime: today.startTime,
        );
      }
    }

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

  String formatTimeRange(int weekday, bool isAmharic) {
    final day = getDayAvailability(weekday);
    if (day == null || !day.isEnabled) {
      return isAmharic ? 'ዝግ ነው' : 'Closed / Off';
    }
    final start = Mentor.formatTimeString(day.startTime, isAmharic);
    final end = Mentor.formatTimeString(day.endTime, isAmharic);
    return '$start – $end';
  }

  String getCurrentStatusText(bool isAmharic) {
    final now = DateTime.now();
    final today = getDayAvailability(now.weekday);
    if (isCurrentlyAvailableNow && today != null) {
      final end = Mentor.formatTimeString(today.endTime, isAmharic);
      return isAmharic
          ? 'አሁን ክፍት ነው • እስከ $end'
          : 'Available Now • Open until $end';
    }

    final nextOpening = getNextOpeningInfo(now);
    if (nextOpening != null) {
      final dayLabel = nextOpening.localizedDayLabel(isAmharic);
      final startTimeStr =
          Mentor.formatTimeString(nextOpening.startTime, isAmharic);
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
      final startTimeStr =
          Mentor.formatTimeString(nextOpening.startTime, isAmharic);
      if (isAmharic) {
        return '$dayLabel በ$startTimeStr';
      } else {
        return 'Opens $dayLabel $startTimeStr';
      }
    }
    return localizedNextSlot(isAmharic);
  }
}
