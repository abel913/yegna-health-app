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
