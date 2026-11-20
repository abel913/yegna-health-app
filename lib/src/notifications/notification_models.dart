/// Categorized types of in-app notifications.
enum NotificationType {
  welcome,
  account,
  learning,
  healthTip,
  system,
  club,
  alert,
  facility,
}

/// Priority tier determining presentation prominence and toast behavior.
enum NotificationPriority {
  normal,
  high,
  urgent,
}

/// Represents an individual in-app notification with metadata, read state,
/// bilingual content, priority level, and optional deep-link payload.
class InAppNotification {
  const InAppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.priority = NotificationPriority.normal,
    this.routePayload,
    this.actionLabel,
    this.actionLabelAm,
    this.campus,
    this.isPinned = false,
    this.titleAm,
    this.messageAm,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final NotificationPriority priority;
  final String? routePayload;
  final String? actionLabel;
  final String? actionLabelAm;
  final String? campus;
  final bool isPinned;
  final String? titleAm;
  final String? messageAm;

  String localizedTitle(bool isAmharic) {
    if (isAmharic && titleAm != null && titleAm!.trim().isNotEmpty) {
      return titleAm!;
    }
    return title;
  }

  String localizedMessage(bool isAmharic) {
    if (isAmharic && messageAm != null && messageAm!.trim().isNotEmpty) {
      return messageAm!;
    }
    return message;
  }

  String? localizedActionLabel(bool isAmharic) {
    if (isAmharic && actionLabelAm != null && actionLabelAm!.trim().isNotEmpty) {
      return actionLabelAm;
    }
    return actionLabel;
  }

  InAppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    NotificationPriority? priority,
    String? routePayload,
    String? actionLabel,
    String? actionLabelAm,
    String? campus,
    bool? isPinned,
    String? titleAm,
    String? messageAm,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      priority: priority ?? this.priority,
      routePayload: routePayload ?? this.routePayload,
      actionLabel: actionLabel ?? this.actionLabel,
      actionLabelAm: actionLabelAm ?? this.actionLabelAm,
      campus: campus ?? this.campus,
      isPinned: isPinned ?? this.isPinned,
      titleAm: titleAm ?? this.titleAm,
      messageAm: messageAm ?? this.messageAm,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'isRead': isRead,
      'priority': priority.name,
      if (routePayload != null) 'routePayload': routePayload,
      if (actionLabel != null) 'actionLabel': actionLabel,
      if (actionLabelAm != null) 'actionLabelAm': actionLabelAm,
      if (campus != null) 'campus': campus,
      'isPinned': isPinned,
      if (titleAm != null) 'titleAm': titleAm,
      if (messageAm != null) 'messageAm': messageAm,
    };
  }

  factory InAppNotification.fromJson(Map<String, dynamic> json) {
    return InAppNotification(
      id: json['id'] as String? ??
          'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title'] as String? ?? json['titleEn'] as String? ?? '',
      message: json['message'] as String? ?? json['messageEn'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      isRead: json['isRead'] as bool? ?? false,
      priority: NotificationPriority.values.firstWhere(
        (p) => p.name == json['priority'],
        orElse: () => NotificationPriority.normal,
      ),
      routePayload: json['routePayload'] as String?,
      actionLabel: json['actionLabel'] as String? ?? json['actionLabelEn'] as String?,
      actionLabelAm: json['actionLabelAm'] as String?,
      campus: json['campus'] as String? ?? json['targetCampus'] as String?,
      isPinned: json['isPinned'] as bool? ?? false,
      titleAm: json['titleAm'] as String?,
      messageAm: json['messageAm'] as String?,
    );
  }
}
