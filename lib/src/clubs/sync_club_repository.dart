import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import 'club_models.dart';
import 'club_repository.dart';
import 'repositories/club_filter_helper.dart';
import 'repositories/sync_club_cache_helper.dart';

/// Offline-first club repository that combines local member rosters
/// with remote club directory synchronization.
class SyncClubRepository extends ChangeNotifier implements ClubRepository {
  SyncClubRepository({
    required OfflineSyncStore store,
    required LocalClubRepository localRepository,
    ApiClient? apiClient,
    Future<String?> Function()? authTokenProvider,
  })  : _store = store,
        _local = localRepository,
        _apiClient = apiClient,
        _authTokenProvider = authTokenProvider;

  final OfflineSyncStore _store;
  final LocalClubRepository _local;
  final ApiClient? _apiClient;
  final Future<String?> Function()? _authTokenProvider;

  Future<String?> _getAuthToken() async {
    if (_authTokenProvider != null) {
      try {
        final t = await _authTokenProvider();
        if (t != null && t.isNotEmpty) return t;
      } catch (_) {}
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('backend_auth_token');
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<StudentClub>> getClubs({
    ClubCategory? category,
    String? query,
  }) async {
    List<StudentClub>? cached = await _store.getCachedClubs();

    if (cached == null && !(await _store.hasSynced('clubs'))) {
      cached = await _local.getClubs();
      if (cached.isNotEmpty) {
        unawaited(_store.saveClubs(cached));
      }
    }
    cached ??= [];

    if (_apiClient != null) {
      unawaited(_revalidateInBackground());
    }

    return ClubFilterHelper.filter(cached, category: category, query: query);
  }

  Future<List<StudentClub>> refreshClubs({
    ClubCategory? category,
    String? query,
  }) async {
    final client = _apiClient;
    if (client != null) {
      try {
        final remoteList = await client.fetchClubs();
        if (remoteList != null) {
          final clubs =
              remoteList.map(OfflineSyncStore.clubFromBackendMap).toList();
          await _store.saveClubs(clubs);
          for (final club in clubs) {
            await _local.saveClub(club);
          }
          notifyListeners();
          return ClubFilterHelper.filter(clubs, category: category, query: query);
        }
      } catch (_) {}
    }
    return getClubs(category: category, query: query);
  }

  @override
  Future<StudentClub?> getClubById(String id) async {
    final all = await getClubs();
    try {
      return all.firstWhere((c) => c.id == id);
    } catch (_) {
      return _local.getClubById(id);
    }
  }

  @override
  Future<List<String>> getJoinedClubIds(String userId) =>
      _local.getJoinedClubIds(userId);

  @override
  Future<bool> joinClub(
    String clubId,
    String userId, {
    String? userEmail,
    String? userName,
  }) async {
    final localExisting = await _local.getClubById(clubId);
    if (localExisting == null) {
      final cached = await _store.getCachedClubs();
      final fromCache = cached?.cast<StudentClub?>().firstWhere(
            (c) => c != null && c.id == clubId,
            orElse: () => null,
          );
      if (fromCache != null) {
        await _local.saveClub(fromCache);
      }
    }

    final success = await _local.joinClub(
      clubId,
      userId,
      userEmail: userEmail,
      userName: userName,
    );

    if (success) {
      await SyncClubCacheHelper.updateClubInCache(_store, _local, clubId);
    }

    if (success && _apiClient != null) {
      unawaited(() async {
        final token = await _getAuthToken();
        await _apiClient.joinClub(clubId, token: token);
      }());
    }

    return success;
  }

  @override
  Future<bool> leaveClub(String clubId, String userId) async {
    final success = await _local.leaveClub(clubId, userId);
    if (success) {
      await SyncClubCacheHelper.updateClubInCache(_store, _local, clubId);
    }

    if (success && _apiClient != null) {
      unawaited(() async {
        final token = await _getAuthToken();
        await _apiClient.leaveClub(clubId, token: token);
      }());
    }

    return success;
  }

  @override
  Future<void> saveClub(StudentClub club) async {
    await _local.saveClub(club);
    final all = await _local.getClubs();
    await _store.saveClubs(all);
  }

  @override
  Future<void> deleteClub(String clubId) async {
    await _local.deleteClub(clubId);
    final all = await _local.getClubs();
    await _store.saveClubs(all);
  }

  @override
  Future<List<ClubMembership>> getClubMembers(String clubId) =>
      _local.getClubMembers(clubId);

  @override
  Future<List<ClubMembership>> getAllMemberships() =>
      _local.getAllMemberships();

  @override
  Future<bool> removeMember(String clubId, String userId) =>
      _local.removeMember(clubId, userId);

  @override
  Future<bool> updateMemberRole(
          String clubId, String userId, String newRole) =>
      _local.updateMemberRole(clubId, userId, newRole);

  @override
  Future<void> toggleClubActive(String clubId) =>
      _local.toggleClubActive(clubId);

  Future<void> _revalidateInBackground() async {
    try {
      final remoteList = await _apiClient?.fetchClubs();
      if (remoteList != null) {
        final clubs =
            remoteList.map(OfflineSyncStore.clubFromBackendMap).toList();
        await _store.saveClubs(clubs);
        for (final club in clubs) {
          await _local.saveClub(club);
        }
        notifyListeners();
      }
    } catch (_) {}
  }
}
