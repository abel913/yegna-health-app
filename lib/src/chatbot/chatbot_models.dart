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

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'description': description,
      };

  factory EmergencyHotlineAction.fromJson(Map<String, dynamic> json) {
    return EmergencyHotlineAction(
      name: json['name'] as String? ?? '',
      number: json['number'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );
  }

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

/// Represents a distinct conversation session in chat history (like ChatGPT).
@immutable
class ChatConversation {
  const ChatConversation({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    this.messages = const [],
  });

  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<ChatMessage> messages;

  /// Returns the snippet of the latest query or response.
  String get previewText {
    for (int i = messages.length - 1; i >= 0; i--) {
      final text = messages[i].text.trim();
      if (text.isNotEmpty) {
        return text;
      }
    }
    return '';
  }

  ChatConversation copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<ChatMessage>? messages,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatConversation.fromJson(Map<String, dynamic> json) {
    return ChatConversation(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String) ?? DateTime.now()
          : DateTime.now(),
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatConversation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          updatedAt == other.updatedAt;

  @override
  int get hashCode => Object.hash(id, title, updatedAt);
}
