import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.isBusy,
    required this.label,
    required this.onSubmit,
    super.key,
  });

  final bool isBusy;
  final String label;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x350284C7),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: isBusy ? null : onSubmit,
        child: isBusy
            ? const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }
}
