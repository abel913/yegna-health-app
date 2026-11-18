class MentorTimeUtils {
  const MentorTimeUtils._();

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
}
