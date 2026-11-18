import 'package:flutter/material.dart';

class MentorDockButton extends StatelessWidget {
  const MentorDockButton({
    required this.bgColor,
    required this.tooltip,
    required this.onTap,
    required this.icon,
    this.borderColor,
    this.boxShadow,
    super.key,
  });

  final Color bgColor;
  final String tooltip;
  final VoidCallback onTap;
  final Widget icon;
  final Color? borderColor;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Tooltip(
          message: tooltip,
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: borderColor != null
                  ? Border.all(color: borderColor!, width: 1.1)
                  : null,
              boxShadow: boxShadow,
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }
}
