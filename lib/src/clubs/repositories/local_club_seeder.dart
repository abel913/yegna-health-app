import '../club_models.dart';

/// Pre-seeded youth enrollments for local testing and offline readiness.
class LocalClubSeeder {
  static List<ClubMembership> get initialMemberships => [
        ClubMembership(
          clubId: 'template_mental_health',
          userId: 'student_usr_02',
          userEmail: 'student1@aau.edu.et',
          userName: 'Bethlehem T.',
          role: 'lead',
          joinedAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
        ClubMembership(
          clubId: 'template_mental_health',
          userId: 'student_usr_03',
          userEmail: 'natnael.k@gmail.com',
          userName: 'Natnael K.',
          role: 'member',
          joinedAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        ClubMembership(
          clubId: 'template_girls_hygiene',
          userId: 'student_usr_02',
          userEmail: 'student1@aau.edu.et',
          userName: 'Bethlehem T.',
          role: 'member',
          joinedAt: DateTime.now().subtract(const Duration(days: 8)),
        ),
        ClubMembership(
          clubId: 'template_anti_substance',
          userId: 'student_usr_03',
          userEmail: 'natnael.k@gmail.com',
          userName: 'Natnael K.',
          role: 'member',
          joinedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        ClubMembership(
          clubId: 'template_srh_wellness',
          userId: 'student_usr_02',
          userEmail: 'student1@aau.edu.et',
          userName: 'Bethlehem T.',
          role: 'member',
          joinedAt: DateTime.now().subtract(const Duration(days: 6)),
        ),
      ];
}
