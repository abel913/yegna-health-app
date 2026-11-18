import 'package:flutter/material.dart';

import '../chatbot_models.dart';

class ChatHotlinesCard extends StatelessWidget {
  const ChatHotlinesCard({
    required this.hotlines,
    required this.onCallPhone,
    super.key,
  });

  final List<EmergencyHotlineAction> hotlines;
  final ValueChanged<String> onCallPhone;

  @override
  Widget build(BuildContext context) {
    if (hotlines.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: hotlines.map((hotline) {
          return ElevatedButton.icon(
            onPressed: () => onCallPhone(hotline.number),
            icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
            label: Text(
              '${hotline.name} (${hotline.number})',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
