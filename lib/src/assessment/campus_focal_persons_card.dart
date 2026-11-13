import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusFocalPerson {
  const CampusFocalPerson({
    required this.campusEn,
    required this.campusAm,
    required this.nameEn,
    required this.nameAm,
    required this.roleEn,
    required this.roleAm,
    required this.phone,
  });

  final String campusEn;
  final String campusAm;
  final String nameEn;
  final String nameAm;
  final String roleEn;
  final String roleAm;
  final String phone;
}

const List<CampusFocalPerson> kUogCampusFocalPersons = [
  CampusFocalPerson(
    campusEn: 'Atse Fasil Campus',
    campusAm: 'አጼ ፋሲል ግቢ',
    nameEn: 'Mr. Mengistu Aragie',
    nameAm: 'አቶ መንግስቱ አራጌ',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918780432',
  ),
  CampusFocalPerson(
    campusEn: 'Atse Fasil Campus',
    campusAm: 'አጼ ፋሲል ግቢ',
    nameEn: 'Sr. Assegedech Birhanu',
    nameAm: 'ሲ/ር አሰገደች ብርሃኑ',
    roleEn: 'Clinical Focal Nurse',
    roleAm: 'ክሊኒካል ነርስ',
    phone: '+251918775510',
  ),
  CampusFocalPerson(
    campusEn: 'Atse Tewodros Campus',
    campusAm: 'አጼ ቴዎድሮስ ግቢ',
    nameEn: 'Dr. Tadele Melese',
    nameAm: 'ዶ/ር ታደለ መለሰ',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918768912',
  ),
  CampusFocalPerson(
    campusEn: 'Atse Tewodros Campus',
    campusAm: 'አጼ ቴዎድሮስ ግቢ',
    nameEn: 'Sr. Zewditu Kebede',
    nameAm: 'ሲ/ር ዘውዲቱ ከበደ',
    roleEn: 'Clinical Counselor',
    roleAm: 'ክሊኒካል አማካሪ',
    phone: '+251918712345',
  ),
  CampusFocalPerson(
    campusEn: 'CMHS / Health College',
    campusAm: 'የጤና ሳይንስ ኮሌጅ ግቢ',
    nameEn: 'Dr. Wubet Worku',
    nameAm: 'ዶ/ር ውበት ወርቁ',
    roleEn: 'SRH Clinical Lead',
    roleAm: 'የስነ-ተዋልዶ ጤና መሪ',
    phone: '+251918701234',
  ),
  CampusFocalPerson(
    campusEn: 'CMHS / Health College',
    campusAm: 'የጤና ሳይንስ ኮሌጅ ግቢ',
    nameEn: 'Sr. Emebet Kassahun',
    nameAm: 'ሲ/ር እመቤት ካሳሁን',
    roleEn: 'Youth Friendly Clinic Lead',
    roleAm: 'የወጣቶች ክሊኒክ ኃላፊ',
    phone: '+251918705678',
  ),
  CampusFocalPerson(
    campusEn: 'Maraki Campus',
    campusAm: 'ማራኪ ግቢ',
    nameEn: 'Mr. Solomon Amsalu',
    nameAm: 'አቶ ሰለሞን አምሳሉ',
    roleEn: 'Campus Coordinator',
    roleAm: 'የግቢው አስተባባሪ',
    phone: '+251918734567',
  ),
  CampusFocalPerson(
    campusEn: 'Maraki Campus',
    campusAm: 'ማራኪ ግቢ',
    nameEn: 'Sr. Bethlehem Tadesse',
    nameAm: 'ሲ/ር ቤተልሔም ታደሰ',
    roleEn: 'Counselor',
    roleAm: 'አማካሪ',
    phone: '+251918745678',
  ),
  CampusFocalPerson(
    campusEn: 'Teda Campus',
    campusAm: 'ተዳ ግቢ',
    nameEn: 'Mr. Hailemariam Getachew',
    nameAm: 'አቶ ኃይለማሪያም ጌታቸው',
    roleEn: 'Campus Lead',
    roleAm: 'የግቢው ኃላፊ',
    phone: '+251918756789',
  ),
  CampusFocalPerson(
    campusEn: 'Central Directorate (Gender & Inclusion)',
    campusAm: 'የጾታ እና አካታችነት ዳይሬክቶሬት',
    nameEn: 'Mrs. Selamawit Alemayehu',
    nameAm: 'ወ/ሮ ሰላማዊት አለማየሁ',
    roleEn: 'Director',
    roleAm: 'ዳይሬክተር',
    phone: '+251918700112',
  ),
];

class CampusFocalPersonsCard extends StatelessWidget {
  const CampusFocalPersonsCard({
    super.key,
    this.isAmharic = false,
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
                isAmharic
                    ? 'ስልክ መደወል አልተቻለም: $phone'
                    : 'Could not launch dialer for: $phone',
              ),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAmharic
                  ? 'ስልክ ቁጥር: $phone'
                  : 'Phone: $phone',
            ),
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
          Row(
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
          ),
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
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  '$campus • $role',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontSize: 11,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.tonalIcon(
                      onPressed: () => _makeCall(context, person.phone),
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
            },
          ),
        ],
      ),
    );
  }
}
