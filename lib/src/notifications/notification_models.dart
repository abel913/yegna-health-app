/// Categorized types of in-app notifications.
enum NotificationType {
  welcome,
  account,
  learning,
  healthTip,
  system,
}

/// Represents an individual in-app notification with metadata, read state,
/// and optional navigation payload.
class InAppNotification {
  const InAppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.routePayload,
  });

  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;
  final String? routePayload;

  InAppNotification copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationType? type,
    bool? isRead,
    String? routePayload,
  }) {
    return InAppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      isRead: isRead ?? this.isRead,
      routePayload: routePayload ?? this.routePayload,
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
      if (routePayload != null) 'routePayload': routePayload,
    };
  }

  factory InAppNotification.fromJson(Map<String, dynamic> json) {
    return InAppNotification(
      id: json['id'] as String? ??
          'notif_${DateTime.now().millisecondsSinceEpoch}',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      type: NotificationType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      isRead: json['isRead'] as bool? ?? false,
      routePayload: json['routePayload'] as String?,
    );
  }
}
