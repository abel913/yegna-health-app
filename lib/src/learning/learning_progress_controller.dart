import 'package:flutter/foundation.dart';

import '../auth/auth_controller.dart';
import 'progress_repository.dart';

class LearningProgressController extends ChangeNotifier {
  LearningProgressController({
    required LearningProgressStore repository,
    required AuthController authController,
  })  : _repository = repository,
        _authController = authController {
    _authController.addListener(_handleAuthChange);
    _refresh();
  }

  final LearningProgressStore _repository;
  final AuthController _authController;
  LearningProgress? _progress;
  Object? _loadError;
  bool _isLoading = true;
  bool _isBusy = false;
  bool _disposed = false;
  String? _loadedUserId;

  LearningProgress? get progress => _progress;
  Object? get loadError => _loadError;
  bool get isLoading => _isLoading;
  bool get isBusy => _isBusy;
  bool get syncEnabled => _progress?.syncEnabled ?? false;
  bool get isAuthenticated => _authController.isAuthenticated;
  String? get _userId => isAuthenticated ? _authController.user?.id : null;

  Future<void> refresh() => _refresh();

  Future<bool> setSyncEnabled(bool enabled) async {
    final userId = _userId;
    if (userId == null) return false;
    _isBusy = true;
    notifyListeners();
    try {
      await _repository.setSyncEnabled(userId, enabled);
      await _refresh();
      return true;
    } on Object catch (error) {
      await _refresh();
      _loadError = error;
      return false;
    } finally {
      _isBusy = false;
      if (!_disposed) notifyListeners();
    }
  }

  Future<bool> markArticleComplete(String articleId, String locale) async {
    try {
      await _repository.markArticleCompleted(
        userId: _userId,
        articleId: articleId,
        locale: locale,
        syncEnabled: syncEnabled,
      );
      await _refresh();
      return true;
    } on Object catch (error) {
      _loadError = error;
      notifyListeners();
      return false;
    }
  }

  Future<void> recordAttempt({
    required String requestId,
    required String versionId,
    required String locale,
    required int score,
    required int totalQuestions,
  }) async {
    await _repository.recordAttempt(
      userId: _userId,
      requestId: requestId,
      versionId: versionId,
      locale: locale,
      score: score,
      totalQuestions: totalQuestions,
    );
    await _refresh();
  }

  Future<bool> clearSyncedHistory() async {
    final userId = _userId;
    if (userId == null) return false;
    _isBusy = true;
    notifyListeners();
    try {
      await _repository.clearSynchronizedHistory(userId);
      await _refresh();
      return true;
    } on Object catch (error) {
      _loadError = error;
      return false;
    } finally {
      _isBusy = false;
      if (!_disposed) notifyListeners();
    }
  }

  void _handleAuthChange() {
    final userId = _userId;
    if (userId != _loadedUserId) _refresh();
  }

  Future<void> _refresh() async {
    final userId = _userId;
    _loadedUserId = userId;
    _isLoading = true;
    _loadError = null;
    if (!_disposed) notifyListeners();
    try {
      _progress = await _repository.load(userId);
    } on Object catch (error) {
      _loadError = error;
    } finally {
      _isLoading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _authController.removeListener(_handleAuthChange);
    super.dispose();
  }
}
