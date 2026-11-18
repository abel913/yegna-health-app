import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../content/content_templates.dart';
import '../club_models.dart';
import 'club_repository_interface.dart';
import 'local_club_membership_mixin.dart';
import 'local_club_seeder.dart';

class LocalClubRepository with LocalClubMembershipMixin implements ClubRepository {
  LocalClubRepository({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;
  static const _clubsStorageKey = 'yegna_student_clubs_v2';
  static const _membershipsStorageKey = 'yegna_club_memberships_v2';

  final List<StudentClub> _inMemoryClubs = [];
  final List<ClubMembership> _inMemoryMemberships = [];
  bool _isLoaded = false;

  @override
  List<StudentClub> get inMemoryClubs => _inMemoryClubs;

  @override
  List<ClubMembership> get inMemoryMemberships => _inMemoryMemberships;

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
        _inMemoryClubs.clear();
        _inMemoryClubs.addAll(ContentTemplates.clubTemplates);
        await persistClubs();
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
      } else {
        _inMemoryMemberships.clear();
        _inMemoryMemberships.addAll(LocalClubSeeder.initialMemberships);
        for (var i = 0; i < _inMemoryClubs.length; i++) {
          final cid = _inMemoryClubs[i].id;
          final count = _inMemoryMemberships.where((m) => m.clubId == cid).length;
          if (count > 0) {
            _inMemoryClubs[i] = _inMemoryClubs[i].copyWith(memberCount: count);
          }
        }
        await persistMemberships();
        await persistClubs();
      }
    } catch (_) {
      if (_inMemoryClubs.isEmpty) {
        _inMemoryClubs.addAll(ContentTemplates.clubTemplates);
      }
    }
    _isLoaded = true;
  }

  @override
  Future<void> persistClubs() async {
    try {
      final prefs = await _getPrefs();
      final jsonList = _inMemoryClubs.map((c) => c.toJson()).toList();
      await prefs.setString(_clubsStorageKey, jsonEncode(jsonList));
    } catch (_) {}
  }

  @override
  Future<void> persistMemberships() async {
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
        final content = '${c.nameEn} ${c.nameAm} ${c.descriptionEn} ${c.descriptionAm} ${c.mentorNameEn} ${c.mentorNameAm} ${c.tags.join(" ")}'.toLowerCase();
        return content.contains(q);
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
    return _inMemoryMemberships.where((m) => m.userId == userId).map((m) => m.clubId).toList();
  }

  @override
  Future<bool> joinClub(String clubId, String userId, {String? userEmail, String? userName}) async {
    await _ensureLoaded();
    return handleJoinClub(clubId, userId, userEmail: userEmail, userName: userName);
  }

  @override
  Future<bool> leaveClub(String clubId, String userId) async {
    await _ensureLoaded();
    return handleLeaveClub(clubId, userId);
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
    await persistClubs();
  }

  @override
  Future<void> deleteClub(String clubId) async {
    await _ensureLoaded();
    _inMemoryClubs.removeWhere((c) => c.id == clubId);
    _inMemoryMemberships.removeWhere((m) => m.clubId == clubId);
    await persistClubs();
    await persistMemberships();
  }

  @override
  Future<List<ClubMembership>> getClubMembers(String clubId) async {
    await _ensureLoaded();
    return _inMemoryMemberships.where((m) => m.clubId == clubId).toList();
  }

  @override
  Future<List<ClubMembership>> getAllMemberships() async {
    await _ensureLoaded();
    return List.unmodifiable(_inMemoryMemberships);
  }

  @override
  Future<bool> removeMember(String clubId, String userId) => leaveClub(clubId, userId);

  @override
  Future<bool> updateMemberRole(String clubId, String userId, String newRole) async {
    await _ensureLoaded();
    final index = _inMemoryMemberships.indexWhere((m) => m.clubId == clubId && m.userId == userId);
    if (index >= 0) {
      _inMemoryMemberships[index] = _inMemoryMemberships[index].copyWith(role: newRole);
      await persistMemberships();
      return true;
    }
    return false;
  }

  @override
  Future<void> toggleClubActive(String clubId) async {
    await _ensureLoaded();
    final index = _inMemoryClubs.indexWhere((c) => c.id == clubId);
    if (index >= 0) {
      final current = _inMemoryClubs[index];
      _inMemoryClubs[index] = current.copyWith(isActive: !current.isActive);
      await persistClubs();
    }
  }
}
