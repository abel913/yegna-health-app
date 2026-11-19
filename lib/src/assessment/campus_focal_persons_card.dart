import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'campus_focal_person_model.dart';
import 'widgets/campus_focal_person_tile.dart';

export 'campus_focal_person_model.dart' show CampusFocalPerson, kUogCampusFocalPersons;

/// University of Gondar campus-level student clinic focal persons contact card.
class CampusFocalPersonsCard extends StatelessWidget {
  const CampusFocalPersonsCard({
    required this.isAmharic,
    super.key,
  });

  final bool isAmharic;

  Future<void> _makeCall(BuildContext context, String phone) async {
    final uri = Uri.parse('tel:$phone');
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isAmharic ? 'ስልክ መደወል አልተቻለም: $phone' : 'Could not launch dialer for: $phone',
              ),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isAmharic ? 'ስልክ ቁጥር: $phone' : 'Phone: $phone'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(theme),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kUogCampusFocalPersons.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final person = kUogCampusFocalPersons[index];
              return CampusFocalPersonTile(
                person: person,
                isAmharic: isAmharic,
                onCall: (phone) => _makeCall(context, phone),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F766E).withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.verified_user_rounded,
            color: Color(0xFF0F766E),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isAmharic
                    ? 'የጎንደር ዩኒቨርሲቲ የተማሪዎች ድጋፍ አስተባባሪዎች'
                    : 'University of Gondar Campus Focal Persons',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                isAmharic
                    ? 'ከዩኦጂ የጾታዊና ስነ-ተዋልዶ ጤና መጠይቅ የተረጋገጡ የስልክ አድራሻዎች'
                    : 'Official contact directory from Page 8 of UoG Self-Assessment',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
