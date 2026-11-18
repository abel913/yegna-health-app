import 'package:flutter/material.dart';

class ChatAmbientCanvas extends StatelessWidget {
  const ChatAmbientCanvas({
    required this.child,
    required this.isDark,
    super.key,
  });

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? const [Color(0xFF060B18), Color(0xFF0A1329), Color(0xFF0E1B38)]
              : const [Color(0xFFEAF5FD), Color(0xFFF0F8FF), Color(0xFFE0F2FE)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [const Color(0xFF00F2FE).withValues(alpha: 0.18), Colors.transparent]
                      : [const Color(0xFFBAE6FD).withValues(alpha: 0.55), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            top: 260,
            left: -60,
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [const Color(0xFF8B5CF6).withValues(alpha: 0.16), Colors.transparent]
                      : [Colors.white.withValues(alpha: 0.65), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: 40,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: isDark
                      ? [const Color(0xFF0284C7).withValues(alpha: 0.20), Colors.transparent]
                      : [const Color(0xFFBAE6FD).withValues(alpha: 0.45), Colors.transparent],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
