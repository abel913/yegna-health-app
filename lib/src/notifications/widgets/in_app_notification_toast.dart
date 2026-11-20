import 'dart:async';
import 'package:flutter/material.dart';

import '../notification_models.dart';
import '../notification_type_visuals.dart';

/// Floating in-app frosted glass heads-up banner toast for urgent bulletins.
class InAppNotificationToast extends StatefulWidget {
  const InAppNotificationToast({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
    this.isAmharic = false,
    this.duration = const Duration(seconds: 4),
    super.key,
  });

  final InAppNotification notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;
  final bool isAmharic;
  final Duration duration;

  @override
  State<InAppNotificationToast> createState() => _InAppNotificationToastState();
}

class _InAppNotificationToastState extends State<InAppNotificationToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<Offset> _offsetAnim;
  late final Animation<double> _fadeAnim;
  Timer? _dismissTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _offsetAnim = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
    _dismissTimer = Timer(widget.duration, _hide);
  }

  void _hide() {
    if (!mounted) return;
    _animController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUrgent = widget.notification.priority == NotificationPriority.urgent;
    final title = widget.notification.localizedTitle(widget.isAmharic);
    final message = widget.notification.localizedMessage(widget.isAmharic);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: SlideTransition(
        position: _offsetAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.primaryDelta != null && details.primaryDelta! < -4) {
                _hide();
              }
            },
            onTap: () {
              _hide();
              widget.onTap();
            },
            child: Material(
              color: Colors.transparent,
              elevation: 12,
              shadowColor: Colors.black.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? (isUrgent
                          ? const Color(0xFF450A0A).withValues(alpha: 0.92)
                          : const Color(0xFF0F172A).withValues(alpha: 0.95))
                      : (isUrgent
                          ? const Color(0xFFFFF1F2).withValues(alpha: 0.96)
                          : Colors.white.withValues(alpha: 0.96)),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: isUrgent
                        ? const Color(0xFFEF4444)
                        : (isDark
                            ? const Color(0xFF38BDF8).withValues(alpha: 0.35)
                            : const Color(0xFF6366F1).withValues(alpha: 0.35)),
                    width: isUrgent ? 1.6 : 1.2,
                  ),
                ),
                child: Row(
                  children: [
                    _buildIconBadge(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              if (isUrgent) ...[
                                const Icon(Icons.local_fire_department_rounded,
                                    size: 14, color: Color(0xFFEF4444)),
                                const SizedBox(width: 4),
                              ],
                              Expanded(
                                child: Text(
                                  title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF08264A),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF6366F1)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge() {
    final typeIcon = widget.notification.type.icon;
    final iconGradient = widget.notification.type.gradient;

    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        gradient: iconGradient,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(typeIcon, color: Colors.white, size: 19),
    );
  }
}
