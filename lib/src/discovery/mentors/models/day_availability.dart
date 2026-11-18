class DayAvailability {
  const DayAvailability({
    required this.dayKey,
    required this.isEnabled,
    this.startTime = '08:30',
    this.endTime = '17:30',
  });

  final String dayKey;
  final bool isEnabled;
  final String startTime;
  final String endTime;

  Map<String, dynamic> toJson() => {
        'dayKey': dayKey,
        'isEnabled': isEnabled,
        'startTime': startTime,
        'endTime': endTime,
      };

  factory DayAvailability.fromJson(Map<String, dynamic> json) {
    return DayAvailability(
      dayKey: (json['dayKey'] ?? json['day'] ?? 'monday')
          .toString()
          .toLowerCase(),
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
