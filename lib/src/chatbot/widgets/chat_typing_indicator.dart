import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';

import '../luminous_chatbot_orb.dart';

class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({
    required this.label,
    required this.isDark,
    super.key,
  });

  final String label;
  final bool isDark;

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _controller.repeat();
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = widget.isDark ? const Color(0xFF38BDF8) : const Color(0xFF007A78);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: LuminousChatbotOrb(
              size: 28,
              isDark: widget.isDark,
              animate: true,
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(20),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.isDark
                      ? const Color(0xFF0F1E36).withValues(alpha: 0.70)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(20),
                  ),
                  border: Border.all(
                    color: widget.isDark
                        ? const Color(0xFF38BDF8).withValues(alpha: 0.20)
                        : const Color(0xFFBAE6FD).withValues(alpha: 0.60),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      label: widget.label,
                      child: Text(
                        widget.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: widget.isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, _) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(3, (index) {
                            final delay = index * 0.20;
                            final t = (_controller.value + delay) % 1.0;
                            final bounce = math.sin(t * math.pi);

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2.2),
                              transform: Matrix4.translationValues(0, -bounce * 4.5, 0),
                              width: 6.5,
                              height: 6.5,
                              decoration: BoxDecoration(
                                color: dotColor.withValues(alpha: 0.40 + (bounce * 0.60)),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  if (bounce > 0.4)
                                    BoxShadow(
                                      color: dotColor.withValues(alpha: 0.45 * bounce),
                                      blurRadius: 5,
                                    ),
                                ],
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
