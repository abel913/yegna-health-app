import 'package:flutter/foundation.dart';

/// Represents a single hotline callout attached to an emergency message.
@immutable
class EmergencyHotlineAction {
  const EmergencyHotlineAction({
    required this.name,
    required this.number,
    required this.description,
  });

  final String name;
  final String number;
  final String description;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmergencyHotlineAction &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          number == other.number &&
          description == other.description;

  @override
  int get hashCode => Object.hash(name, number, description);
}

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
