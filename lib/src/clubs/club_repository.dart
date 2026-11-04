import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../admin/content_templates.dart';
import 'club_models.dart';

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
}

class LocalClubRepository implements ClubRepository {
  LocalClubRepository({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;
  static const _clubsStorageKey = 'yegna_student_clubs_v2';
  static const _membershipsStorageKey = 'yegna_club_memberships_v2';

  final List<StudentClub> _inMemoryClubs = [];
  final List<ClubMembership> _inMemoryMemberships = [];
  bool _isLoaded = false;

  Future<SharedPreferences> _getPrefs() async {
    if (_preferences != null) return _preferences!;
    _preferences = await SharedPreferences.getInstance();
    return _preferences!;
  }

  Future<void> _ensureLoaded() async {
    if (_isLoaded) return;
    try {
      final prefs = await _getPrefs();
      final clubsJson = prefs.getString(_clubsStorageKey);
      if (clubsJson != null && clubsJson.isNotEmpty) {
        final decoded = jsonDecode(clubsJson) as List<Object?>;
        _inMemoryClubs.clear();
        for (final item in decoded) {
          if (item is Map<String, Object?>) {
            _inMemoryClubs.add(StudentClub.fromJson(item));
          }
        }
      } else {
        // Pre-seed with authentic youth templates
        _inMemoryClubs.clear();
        _inMemoryClubs.addAll(ContentTemplates.clubTemplates);
        await _persistClubs();
      }

      final membersJson = prefs.getString(_membershipsStorageKey);
      if (membersJson != null && membersJson.isNotEmpty) {
        final decoded = jsonDecode(membersJson) as List<Object?>;
        _inMemoryMemberships.clear();
        for (final item in decoded) {
          if (item is Map<String, Object?>) {
            _inMemoryMemberships.add(ClubMembership.fromJson(item));
          }
        }
      }
    } catch (_) {
      if (_inMemoryClubs.isEmpty) {
        _inMemoryClubs.addAll(ContentTemplates.clubTemplates);
      }
    }
    _isLoaded = true;
  }

  Future<void> _persistClubs() async {
    try {
      final prefs = await _getPrefs();
      final jsonList = _inMemoryClubs.map((c) => c.toJson()).toList();
      await prefs.setString(_clubsStorageKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  Future<void> _persistMemberships() async {
    try {
      final prefs = await _getPrefs();
      final jsonList = _inMemoryMemberships.map((m) => m.toJson()).toList();
      await prefs.setString(_membershipsStorageKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  @override
  Future<List<StudentClub>> getClubs({
    ClubCategory? category,
    String? query,
  }) async {
    await _ensureLoaded();
    var list = _inMemoryClubs.where((c) => c.isActive).toList();

    if (category != null && category != ClubCategory.all) {
      list = list.where((c) => c.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      list = list.where((c) {
        final nameEn = c.nameEn.toLowerCase();
        final nameAm = c.nameAm.toLowerCase();
        final descEn = c.descriptionEn.toLowerCase();
        final descAm = c.descriptionAm.toLowerCase();
        final mentorEn = c.mentorNameEn.toLowerCase();
        final mentorAm = c.mentorNameAm.toLowerCase();
        final tags = c.tags.map((t) => t.toLowerCase()).join(' ');
        return nameEn.contains(q) ||
            nameAm.contains(q) ||
            descEn.contains(q) ||
            descAm.contains(q) ||
            mentorEn.contains(q) ||
            mentorAm.contains(q) ||
            tags.contains(q);
      }).toList();
    }

    return List.unmodifiable(list);
  }

  @override
  Future<StudentClub?> getClubById(String id) async {
    await _ensureLoaded();
    try {
      return _inMemoryClubs.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getJoinedClubIds(String userId) async {
    await _ensureLoaded();
    return _inMemoryMemberships
        .where((m) => m.userId == userId)
        .map((m) => m.clubId)
        .toList();
  }

  @override
  Future<bool> joinClub(
    String clubId,
    String userId, {
    String? userEmail,
    String? userName,
  }) async {
    await _ensureLoaded();
    final clubIndex = _inMemoryClubs.indexWhere((c) => c.id == clubId);
    if (clubIndex == -1) return false;

    final alreadyJoined = _inMemoryMemberships
        .any((m) => m.clubId == clubId && m.userId == userId);
    if (alreadyJoined) return true;

    final targetClub = _inMemoryClubs[clubIndex];
    if (targetClub.isAtCapacity) return false;

    final membership = ClubMembership(
      clubId: clubId,
      userId: userId,
      userEmail: userEmail ?? 'student@yegnahealth.org',
      userName: userName ?? 'Student Member',
      joinedAt: DateTime.now(),
    );
    _inMemoryMemberships.add(membership);

    // Update count
    _inMemoryClubs[clubIndex] = targetClub.copyWith(
      memberCount: targetClub.memberCount + 1,
    );

    await _persistClubs();
    await _persistMemberships();
    return true;
  }

  @override
  Future<bool> leaveClub(String clubId, String userId) async {
    await _ensureLoaded();
    final initialLength = _inMemoryMemberships.length;
    _inMemoryMemberships
        .removeWhere((m) => m.clubId == clubId && m.userId == userId);

    if (_inMemoryMemberships.length != initialLength) {
      final clubIndex = _inMemoryClubs.indexWhere((c) => c.id == clubId);
      if (clubIndex != -1) {
        final current = _inMemoryClubs[clubIndex];
        final newCount = (current.memberCount - 1).clamp(0, 99999);
        _inMemoryClubs[clubIndex] = current.copyWith(memberCount: newCount);
      }
      await _persistClubs();
      await _persistMemberships();
      return true;
    }
    return false;
  }

  @override
  Future<void> saveClub(StudentClub club) async {
    await _ensureLoaded();
    final index = _inMemoryClubs.indexWhere((c) => c.id == club.id);
    if (index >= 0) {
      _inMemoryClubs[index] = club;
    } else {
      _inMemoryClubs.add(club);
    }
    await _persistClubs();
  }

  @override
  Future<void> deleteClub(String clubId) async {
    await _ensureLoaded();
    _inMemoryClubs.removeWhere((c) => c.id == clubId);
    _inMemoryMemberships.removeWhere((m) => m.clubId == clubId);
    await _persistClubs();
    await _persistMemberships();
  }

  @override
  Future<List<ClubMembership>> getClubMembers(String clubId) async {
    await _ensureLoaded();
    return _inMemoryMemberships.where((m) => m.clubId == clubId).toList();
  }
}
