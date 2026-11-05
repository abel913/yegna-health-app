import 'dart:async';

import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import 'club_models.dart';
import 'club_repository.dart';

/// Offline-first club repository that combines local member rosters
/// with remote club directory synchronization.
class SyncClubRepository implements ClubRepository {
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

    // 2. If no cache yet, fall back to local seed repository
    if (cached == null || cached.isEmpty) {
      cached = await _local.getClubs();
      if (cached.isNotEmpty) {
        unawaited(_store.saveClubs(cached));
      }
    }

    // 3. Stale-While-Revalidate: Trigger background fetch
    if (_apiClient != null) {
      unawaited(_revalidateInBackground());
    }

    // 4. Apply filtering
    var result = List<StudentClub>.from(cached);

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
    // Always persist locally first so student membership works offline
    final success = await _local.joinClub(
      clubId,
      userId,
      userEmail: userEmail,
      userName: userName,
    );

    // If online, asynchronously notify backend
    if (success && _apiClient != null) {
      unawaited(_apiClient.joinClub(clubId));
    }

    return success;
  }

  @override
  Future<bool> leaveClub(String clubId, String userId) {
    return _local.leaveClub(clubId, userId);
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

  Future<void> _revalidateInBackground() async {
    try {
      final remoteList = await _apiClient?.fetchClubs();
      if (remoteList != null && remoteList.isNotEmpty) {
        final clubs =
            remoteList.map(OfflineSyncStore.clubFromBackendMap).toList();
        await _store.saveClubs(clubs);
      }
    } catch (_) {}
  }
}
