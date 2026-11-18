import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    required this.validator,
    this.keyboardType,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: Color(0xFF08264A),
      ),
      decoration: InputDecoration(
        isDense: true,
        labelText: label,
        labelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF475569),
        ),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, size: 20, color: const Color(0xFF0284C7))
            : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.75),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha: 0.90),
            width: 1.2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFBAE6FD),
            width: 1.2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFF0284C7),
            width: 2.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFDC2626),
            width: 1.2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: Color(0xFFDC2626),
            width: 2.0,
          ),
        ),
      ),
      keyboardType: keyboardType,
      autofillHints: autofillHints,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      validator: validator,
      enabled: enabled,
    );
  }
}
