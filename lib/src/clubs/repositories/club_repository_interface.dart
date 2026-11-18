import '../club_models.dart';

abstract class ClubRepository {
  Future<List<StudentClub>> getClubs({
    ClubCategory? category,
    String? query,
  });

  Future<StudentClub?> getClubById(String id);

  Future<List<String>> getJoinedClubIds(String userId);

  Future<bool> joinClub(
    String clubId,
    String userId, {
    String? userEmail,
    String? userName,
  });

  Future<bool> leaveClub(String clubId, String userId);

  Future<void> saveClub(StudentClub club);

  Future<void> deleteClub(String clubId);

  Future<List<ClubMembership>> getClubMembers(String clubId);

  Future<List<ClubMembership>> getAllMemberships();

  Future<bool> removeMember(String clubId, String userId);

  Future<bool> updateMemberRole(String clubId, String userId, String newRole);

  Future<void> toggleClubActive(String clubId);
}
