import '../../sync/offline_sync_store.dart';
import '../club_models.dart';
import '../repositories/local_club_repository.dart';

class SyncClubCacheHelper {
  static Future<void> updateClubInCache(
    OfflineSyncStore store,
    LocalClubRepository local,
    String clubId,
  ) async {
    final updated = await local.getClubById(clubId);
    if (updated != null) {
      final cached = await store.getCachedClubs();
      if (cached != null) {
        final list = List<StudentClub>.from(cached);
        final idx = list.indexWhere((c) => c.id == clubId);
        if (idx >= 0) {
          list[idx] = updated;
        } else {
          list.add(updated);
        }
        await store.saveClubs(list);
      }
    }
  }
}
