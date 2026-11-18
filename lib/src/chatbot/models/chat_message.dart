import 'package:flutter/foundation.dart';

import 'emergency_hotline_action.dart';

/// A message in the Yegna Health Assistant conversation thread.
@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isEmergency = false,
    this.emergencyHotlines = const [],
    this.suggestedPrompts = const [],
  });

  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isEmergency;
  final List<EmergencyHotlineAction> emergencyHotlines;
  final List<String> suggestedPrompts;

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isEmergency,
    List<EmergencyHotlineAction>? emergencyHotlines,
    List<String>? suggestedPrompts,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isEmergency: isEmergency ?? this.isEmergency,
      emergencyHotlines: emergencyHotlines ?? this.emergencyHotlines,
      suggestedPrompts: suggestedPrompts ?? this.suggestedPrompts,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'isEmergency': isEmergency,
        'emergencyHotlines': emergencyHotlines.map((e) => e.toJson()).toList(),
        'suggestedPrompts': suggestedPrompts,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? '',
      text: json['text'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      isEmergency: json['isEmergency'] as bool? ?? false,
      emergencyHotlines: (json['emergencyHotlines'] as List<dynamic>?)
              ?.map((e) =>
                  EmergencyHotlineAction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      suggestedPrompts: (json['suggestedPrompts'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          text == other.text &&
          isUser == other.isUser &&
          isEmergency == other.isEmergency;

  @override
  int get hashCode => Object.hash(id, text, isUser, isEmergency);
}
