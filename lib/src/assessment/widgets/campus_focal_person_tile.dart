import 'package:flutter/material.dart';

import '../campus_focal_person_model.dart';

/// Interactive tile displaying a single campus focal person with direct phone dial action.
class CampusFocalPersonTile extends StatelessWidget {
  const CampusFocalPersonTile({
    required this.person,
    required this.isAmharic,
    required this.onCall,
    super.key,
  });

  final CampusFocalPerson person;
  final bool isAmharic;
  final void Function(String phone) onCall;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = isAmharic ? person.nameAm : person.nameEn;
    final campus = isAmharic ? person.campusAm : person.campusEn;
    final role = isAmharic ? person.roleAm : person.roleEn;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Text(
              person.nameEn.split(' ').last.substring(0, 1),
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$campus • $role',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonalIcon(
            onPressed: () => onCall(person.phone),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.phone_rounded, size: 13),
            label: Text(
              isAmharic ? 'ደውል' : 'Call',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
