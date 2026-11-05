import 'dart:async';
import 'package:flutter/foundation.dart';

import 'api_client.dart';
import 'offline_sync_store.dart';

enum SyncStatus {
  idle,
  syncing,
  synced,
  offline,
  error,
}

/// Orchestrates background synchronization and cache revalidation between
/// the Node.js backend and local persistent storage.
class SyncManager extends ChangeNotifier {
  SyncManager({
    required ApiClient apiClient,
    required OfflineSyncStore store,
  })  : _apiClient = apiClient,
        _store = store;

  final ApiClient _apiClient;
  final OfflineSyncStore _store;

  SyncStatus _status = SyncStatus.idle;
  SyncStatus get status => _status;

  DateTime? _lastSyncedAt;
  DateTime? get lastSyncedAt => _lastSyncedAt;

  String? _lastErrorMessage;
  String? get lastErrorMessage => _lastErrorMessage;

  bool get isSyncing => _status == SyncStatus.syncing;
  bool get isOffline => _status == SyncStatus.offline;

  /// Loads the last sync timestamp on startup.
  Future<void> init() async {
    _lastSyncedAt = await _store.getLastSyncTime();
    notifyListeners();
  }

  /// Concurrently synchronizes all remote datasets with local offline storage.
  /// Uses a Stale-While-Revalidate pattern: UI continues reading from cache,
  /// and when fresh remote data arrives, cache is updated and UI notified.
  Future<bool> syncAll({bool force = false}) async {
    if (_status == SyncStatus.syncing) return false;

    _status = SyncStatus.syncing;
    _lastErrorMessage = null;
    notifyListeners();

    try {
      // Run concurrent requests for facilities, mentors, modules, quizzes, and clubs
      final results = await Future.wait([
        _syncFacilities(),
        _syncMentors(),
        _syncModules(),
        _syncQuizzes(),
        _syncClubs(),
      ]).timeout(const Duration(seconds: 10));

      final anySuccess = results.any((success) => success == true);

      if (anySuccess) {
        _status = SyncStatus.synced;
        _lastSyncedAt = DateTime.now();
        notifyListeners();
        return true;
      } else {
        // If all requests failed, we are offline
        _status = SyncStatus.offline;
        notifyListeners();
        return false;
      }
    } on TimeoutException {
      _status = SyncStatus.offline;
      _lastErrorMessage = 'Connection timed out. Offline mode active.';
      notifyListeners();
      return false;
    } catch (e) {
      _status = SyncStatus.offline;
      _lastErrorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> _syncFacilities() async {
    try {
      final remoteList = await _apiClient.fetchFacilities();
      if (remoteList != null && remoteList.isNotEmpty) {
        final facilities =
            remoteList.map(OfflineSyncStore.facilityFromMap).toList();
        await _store.saveFacilities(facilities);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _syncMentors() async {
    try {
      final remoteList = await _apiClient.fetchMentors();
      if (remoteList != null && remoteList.isNotEmpty) {
        final mentors =
            remoteList.map(OfflineSyncStore.mentorFromMap).toList();
        await _store.saveMentors(mentors);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _syncModules() async {
    try {
      final remoteList = await _apiClient.fetchModules();
      if (remoteList != null && remoteList.isNotEmpty) {
        await _store.saveModules(remoteList);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _syncQuizzes() async {
    try {
      final remoteList = await _apiClient.fetchQuizzes();
      if (remoteList != null && remoteList.isNotEmpty) {
        await _store.saveQuizzes(remoteList);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _syncClubs() async {
    try {
      final remoteList = await _apiClient.fetchClubs();
      if (remoteList != null && remoteList.isNotEmpty) {
        final clubs =
            remoteList.map(OfflineSyncStore.clubFromBackendMap).toList();
        await _store.saveClubs(clubs);
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
