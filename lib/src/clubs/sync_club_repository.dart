import 'dart:async';
import 'package:flutter/foundation.dart';

import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import 'club_models.dart';
import 'club_repository.dart';

/// Offline-first club repository that combines local member rosters
/// with remote club directory synchronization.
class SyncClubRepository extends ChangeNotifier implements ClubRepository {
  SyncClubRepository({
    required OfflineSyncStore store,
    required LocalClubRepository localRepository,
    ApiClient? apiClient,
  })  : _store = store,
        _local = localRepository,
        _apiClient = apiClient;

  final OfflineSyncStore _store;
  final LocalClubRepository _local;
  final ApiClient? _apiClient;

  @override
  Future<List<StudentClub>> getClubs({
    ClubCategory? category,
    String? query,
  }) async {
    // 1. Check offline persistent cache
    List<StudentClub>? cached = await _store.getCachedClubs();

    // 2. If no cache yet and has never synced from backend, fall back to local seed repository
    if (cached == null && !(await _store.hasSynced('clubs'))) {
      cached = await _local.getClubs();
      if (cached.isNotEmpty) {
        unawaited(_store.saveClubs(cached));
      }
    }
    cached ??= [];

    // 3. Stale-While-Revalidate: Trigger background fetch
    if (_apiClient != null) {
      unawaited(_revalidateInBackground());
    }

    // 4. Apply filtering
    return _filterClubs(cached, category: category, query: query);
  }

  /// Forces an immediate network fetch from the backend and updates the cache.
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
          return _filterClubs(clubs, category: category, query: query);
        }
      } catch (_) {
        // Fall back to cache on network error
      }
    }
    return getClubs(category: category, query: query);
  }

  List<StudentClub> _filterClubs(
    List<StudentClub> input, {
    ClubCategory? category,
    String? query,
  }) {
    var result = List<StudentClub>.from(input);

    if (category != null && category != ClubCategory.all) {
      result = result.where((c) => c.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((c) {
        final matchEn = c.nameEn.toLowerCase().contains(clean) ||
            c.descriptionEn.toLowerCase().contains(clean) ||
            c.meetingLocationEn.toLowerCase().contains(clean);
        final matchAm = c.nameAm.contains(clean) ||
            c.descriptionAm.contains(clean) ||
            c.meetingLocationAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
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
  Future<List<String>> getJoinedClubIds(String userId) {
    return _local.getJoinedClubIds(userId);
  }

  @override
  Future<bool> joinClub(
    String clubId,
    String userId, {
    String? userEmail,
    String? userName,
  }) async {
    // 1. Ensure target club exists in local repository before joining
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

    // 2. Always persist locally first so student membership works offline
    final success = await _local.joinClub(
      clubId,
      userId,
      userEmail: userEmail,
      userName: userName,
    );

    // 3. Keep offline store cache in sync with updated member count
    if (success) {
      final updated = await _local.getClubById(clubId);
      if (updated != null) {
        final cached = await _store.getCachedClubs();
        if (cached != null) {
          final list = List<StudentClub>.from(cached);
          final idx = list.indexWhere((c) => c.id == clubId);
          if (idx >= 0) {
            list[idx] = updated;
          } else {
            list.add(updated);
          }
          await _store.saveClubs(list);
        }
      }
    }

    // 4. If online, asynchronously notify backend
    if (success && _apiClient != null) {
      unawaited(_apiClient.joinClub(clubId));
    }

    return success;
  }

  @override
  Future<bool> leaveClub(String clubId, String userId) async {
    final success = await _local.leaveClub(clubId, userId);
    if (success) {
      final updated = await _local.getClubById(clubId);
      if (updated != null) {
        final cached = await _store.getCachedClubs();
        if (cached != null) {
          final list = List<StudentClub>.from(cached);
          final idx = list.indexWhere((c) => c.id == clubId);
          if (idx >= 0) {
            list[idx] = updated;
            await _store.saveClubs(list);
          }
        }
      }
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
  Future<List<ClubMembership>> getClubMembers(String clubId) {
    return _local.getClubMembers(clubId);
  }

  @override
  Future<List<ClubMembership>> getAllMemberships() {
    return _local.getAllMemberships();
  }

  @override
  Future<bool> removeMember(String clubId, String userId) {
    return _local.removeMember(clubId, userId);
  }

  @override
  Future<bool> updateMemberRole(String clubId, String userId, String newRole) {
    return _local.updateMemberRole(clubId, userId, newRole);
  }

  @override
  Future<void> toggleClubActive(String clubId) {
    return _local.toggleClubActive(clubId);
  }

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
