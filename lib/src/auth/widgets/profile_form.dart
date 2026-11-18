import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../auth_models.dart';
import '../auth_validation.dart';
import 'auth_notice.dart';

class ProfileForm extends StatelessWidget {
  const ProfileForm({
    required this.formKey,
    required this.displayNameController,
    required this.isBusy,
    required this.saved,
    required this.onSave,
    super.key,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController displayNameController;
  final bool isBusy;
  final bool saved;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            controller: displayNameController,
            textCapitalization: TextCapitalization.words,
            style: const TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF08264A),
            ),
            decoration: InputDecoration(
              labelText: l10n.displayNameLabel,
              prefixIcon: const Icon(
                Icons.badge_outlined,
                size: 20,
                color: Color(0xFF0284C7),
              ),
              filled: true,
              fillColor: Colors.white.withValues(alpha: 0.68),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Colors.white.withValues(alpha: 0.90),
                  width: 1.2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFFBAE6FD), width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(color: Color(0xFF0284C7), width: 2.0),
              ),
            ),
            validator: (value) {
              final issue = AuthValidation.displayName(value ?? '');
              if (issue == AuthIssue.displayNameRequired) {
                return l10n.errorDisplayNameRequired;
              }
              if (issue == AuthIssue.displayNameTooLong) {
                return l10n.errorDisplayNameTooLong;
              }
              return null;
            },
          ),
        ),
        if (saved) ...[
          const SizedBox(height: 12),
          AuthNotice(
            icon: Icons.check_circle_outline,
            text: l10n.profileSaved,
          ),
        ],
        const SizedBox(height: 18),
        Container(
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x350284C7),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: isBusy ? null : onSave,
            child: isBusy
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    l10n.saveProfile,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
