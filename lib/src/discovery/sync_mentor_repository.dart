import 'dart:async';

import '../sync/api_client.dart';
import '../sync/offline_sync_store.dart';
import 'mentor_model.dart';
import 'mentor_repository.dart';

/// Offline-first mentor repository that immediately serves from persistent cache
/// or bundled verified mentors, while revalidating against the Node.js backend.
class SyncMentorRepository implements MentorRepository {
  SyncMentorRepository({
    required OfflineSyncStore store,
    ApiClient? apiClient,
    MentorRepository fallback = const LocalVerifiedMentorRepository(),
  })  : _store = store,
        _apiClient = apiClient,
        _fallback = fallback;

  final OfflineSyncStore _store;
  final ApiClient? _apiClient;
  final MentorRepository _fallback;

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
  }) async {
    // 1. Retrieve from local persistent cache
    List<Mentor>? cached = await _store.getCachedMentors();

    // 2. If no cache yet, fall back to bundled verified mentors and seed cache
    if (cached == null || cached.isEmpty) {
      cached = await _fallback.getMentors();
      if (cached.isNotEmpty) {
        unawaited(_store.saveMentors(cached));
      }
    }

    // 3. Stale-While-Revalidate: Trigger background fetch if client is available
    if (_apiClient != null) {
      unawaited(_revalidateInBackground());
    }

    // 4. Apply filtering
    var result = List<Mentor>.from(cached);

    if (onlineOnly == true) {
      result = result.where((m) => m.isOnline).toList();
    }

    if (topic != null && topic != MentorTopic.all) {
      result = result.where((m) => m.topics.contains(topic)).toList();
    }

    if (language != null && language.isNotEmpty && language != 'All') {
      result = result.where((m) => m.languages.contains(language)).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((m) {
        final matchEn = m.nameEn.toLowerCase().contains(clean) ||
            m.titleEn.toLowerCase().contains(clean) ||
            m.organizationEn.toLowerCase().contains(clean) ||
            m.topics.any((t) => t.name.toLowerCase().contains(clean));
        final matchAm = m.nameAm.contains(clean) ||
            m.titleAm.contains(clean) ||
            m.organizationAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }

  /// Silently fetches fresh mentors from backend and updates local cache.
  Future<void> _revalidateInBackground() async {
    try {
      final remoteList = await _apiClient?.fetchMentors();
      if (remoteList != null && remoteList.isNotEmpty) {
        final mentors =
            remoteList.map(OfflineSyncStore.mentorFromMap).toList();
        await _store.saveMentors(mentors);
      }
    } catch (_) {
      // Offline or network error: silently ignored in background
    }
  }
}
