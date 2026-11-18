import '../club_models.dart';

mixin LocalClubMembershipMixin {
  List<ClubMembership> get inMemoryMemberships;
  List<StudentClub> get inMemoryClubs;
  Future<void> persistClubs();
  Future<void> persistMemberships();

  Future<bool> handleJoinClub(
    String clubId,
    String userId, {
    String? userEmail,
    String? userName,
  }) async {
    var clubIndex = inMemoryClubs.indexWhere((c) => c.id == clubId);

    if (clubIndex == -1) {
      final placeholder = StudentClub(
        id: clubId,
        nameEn: 'Student Club',
        nameAm: 'የተማሪዎች ክበብ',
        descriptionEn: 'Youth health engagement club',
        descriptionAm: 'የወጣቶች ጤና ክበብ',
        category: ClubCategory.srhWellness,
        meetingScheduleEn: 'Weekly',
        meetingScheduleAm: 'በየሳምንቱ',
        meetingLocationEn: 'Campus Hall',
        meetingLocationAm: 'የግቢው አዳራሽ',
        mentorNameEn: 'Certified Peer Counselor',
        mentorNameAm: 'የተረጋገጠ አቻ አማካሪ',
        createdAt: DateTime.now(),
      );
      inMemoryClubs.add(placeholder);
      await persistClubs();
      clubIndex = inMemoryClubs.length - 1;
    }

    final alreadyJoined =
        inMemoryMemberships.any((m) => m.clubId == clubId && m.userId == userId);
    if (alreadyJoined) return true;

    final targetClub = inMemoryClubs[clubIndex];
    if (targetClub.isAtCapacity) return false;

    final membership = ClubMembership(
      clubId: clubId,
      userId: userId,
      userEmail: userEmail ?? 'student@yegnahealth.org',
      userName: userName ?? 'Student Member',
      joinedAt: DateTime.now(),
    );
    inMemoryMemberships.add(membership);
    inMemoryClubs[clubIndex] = targetClub.copyWith(
      memberCount: targetClub.memberCount + 1,
    );

    await persistClubs();
    await persistMemberships();
    return true;
  }

  Future<bool> handleLeaveClub(String clubId, String userId) async {
    final initialLength = inMemoryMemberships.length;
    inMemoryMemberships.removeWhere((m) => m.clubId == clubId && m.userId == userId);

    if (inMemoryMemberships.length != initialLength) {
      final clubIndex = inMemoryClubs.indexWhere((c) => c.id == clubId);
      if (clubIndex != -1) {
        final current = inMemoryClubs[clubIndex];
        final newCount = (current.memberCount - 1).clamp(0, 99999);
        inMemoryClubs[clubIndex] = current.copyWith(memberCount: newCount);
      }
      await persistClubs();
      await persistMemberships();
      return true;
    }
    return false;
  }
}
