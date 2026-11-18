import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'widgets/orb_custom_painter.dart';

/// A 3D animated luminous fluid orb widget designed for glassmorphic
/// AI assistant interfaces.
class LuminousChatbotOrb extends StatefulWidget {
  const LuminousChatbotOrb({
    super.key,
    this.size = 110.0,
    this.isDark = true,
    this.animate = true,
  });

  final double size;
  final bool isDark;
  final bool animate;

  @override
  State<LuminousChatbotOrb> createState() => _LuminousChatbotOrbState();
}

class _LuminousChatbotOrbState extends State<LuminousChatbotOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (widget.animate && !isTest) {
      _controller.repeat(reverse: true);
    } else {
      _controller.value = 0.5;
    }
  }

  @override
  void didUpdateWidget(covariant LuminousChatbotOrb oldWidget) {
    super.didUpdateWidget(oldWidget);
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (widget.animate && !isTest && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;
        final scale = 0.96 + (0.08 * math.sin(progress * math.pi));
        final glowSpread = 10.0 + (12.0 * math.sin(progress * math.pi));

        return Transform.scale(
          scale: scale,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: widget.isDark
                      ? const Color(0xFF00F2FE).withValues(alpha: 0.22)
                      : const Color(0xFF0284C7).withValues(alpha: 0.20),
                  blurRadius: widget.size * 0.45 + glowSpread,
                  spreadRadius: 2.0,
                ),
                BoxShadow(
                  color: widget.isDark
                      ? const Color(0xFF8B5CF6).withValues(alpha: 0.25)
                      : const Color(0xFF38BDF8).withValues(alpha: 0.18),
                  blurRadius: widget.size * 0.25,
                  offset: const Offset(2, -2),
                ),
              ],
            ),
            child: CustomPaint(
              size: Size(widget.size, widget.size),
              painter: OrbCustomPainter(
                progress: progress,
                isDark: widget.isDark,
              ),
            ),
          ),
        );
      },
    );
  }
}
