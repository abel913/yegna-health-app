import 'dart:async';

import 'package:flutter/foundation.dart';

import 'auth_models.dart';
import 'auth_repository.dart';
import 'auth_validation.dart';

class AuthController extends ChangeNotifier {
  AuthController(this._repository) : _snapshot = _repository.snapshot {
    _subscription = _repository.authChanges.listen(
      (snapshot) {
        _snapshot = snapshot;
        _streamIssue = null;
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _streamIssue = AuthIssue.networkUnavailable;
        notifyListeners();
      },
    );
  }

  final AuthRepository _repository;
  late final StreamSubscription<AuthSnapshot> _subscription;
  AuthSnapshot _snapshot;
  bool _isBusy = false;
  AuthIssue? _issue;
  AuthIssue? _streamIssue;
  String? _verificationEmail;
  bool _disposed = false;

  bool get isConfigured => _repository.isConfigured;
  bool get isBusy => _isBusy;
  AuthIssue? get issue => _issue ?? _streamIssue;
  String? get verificationEmail => _verificationEmail;
  AuthSnapshot get snapshot => _snapshot;
  AuthUser? get user => _snapshot.user;
  bool get isAuthenticated => user?.emailVerified == true;
  bool get recoveryRequested => _snapshot.passwordRecovery;

  Future<RegistrationOutcome?> register({
    required String email,
    required String password,
    required String confirmation,
    required String displayName,
  }) async {
    final validationIssue = AuthValidation.email(email) ??
        AuthValidation.password(password) ??
        AuthValidation.passwordConfirmation(password, confirmation) ??
        AuthValidation.displayName(displayName);
    if (validationIssue != null) {
      _issue = validationIssue;
      notifyListeners();
      return null;
    }
    RegistrationOutcome? outcome;
    await _run(() async {
      outcome = await _repository.register(
        email: email.trim(),
        password: password,
        displayName: displayName.trim(),
      );
      if (outcome == RegistrationOutcome.verificationPending) {
        _verificationEmail = email.trim();
      }
    });
    return _issue == null ? outcome : null;
  }

  Future<bool> signIn({required String email, required String password}) async {
    final validationIssue = AuthValidation.email(email) ??
        (password.isEmpty ? AuthIssue.passwordRequired : null);
    if (validationIssue != null) {
      _issue = validationIssue;
      notifyListeners();
      return false;
    }
    await _run(
        () => _repository.signIn(email: email.trim(), password: password));
    return _issue == null;
  }

  void signInDirectly({
    required String id,
    required String email,
    required String displayName,
  }) {
    _snapshot = AuthSnapshot(
      user: AuthUser(
        id: id,
        email: email,
        displayName: displayName,
        emailVerified: true,
      ),
    );
    _issue = null;
    _streamIssue = null;
    notifyListeners();
  }

  Future<bool> requestPasswordRecovery(String email) async {
    final validationIssue = AuthValidation.email(email);
    if (validationIssue != null) {
      _issue = validationIssue;
      notifyListeners();
      return false;
    }
    await _run(() => _repository.sendPasswordRecovery(email.trim()));
    return _issue == null;
  }

  Future<bool> completePasswordRecovery({
    required String password,
    required String confirmation,
  }) async {
    final validationIssue = AuthValidation.password(password) ??
        AuthValidation.passwordConfirmation(password, confirmation);
    if (validationIssue != null) {
      _issue = validationIssue;
      notifyListeners();
      return false;
    }
    await _run(() => _repository.updatePassword(password));
    return _issue == null;
  }

  Future<bool> updateDisplayName(String displayName) async {
    final validationIssue = AuthValidation.displayName(displayName);
    if (validationIssue != null) {
      _issue = validationIssue;
      notifyListeners();
      return false;
    }
    if (!isAuthenticated) {
      _issue = AuthIssue.sessionUnavailable;
      notifyListeners();
      return false;
    }
    await _run(() => _repository.updateDisplayName(displayName.trim()));
    return _issue == null;
  }

  Future<bool> signOut() async {
    await _run(_repository.signOut);
    return _issue == null;
  }

  Future<void> _run(Future<void> Function() action) async {
    if (!isConfigured) {
      _issue = AuthIssue.configurationMissing;
      notifyListeners();
      return;
    }
    _isBusy = true;
    _issue = null;
    notifyListeners();
    try {
      await action();
    } on AuthFailure catch (failure) {
      _issue = failure.issue;
    } catch (_) {
      _issue = AuthIssue.unexpected;
    } finally {
      _isBusy = false;
      if (!_disposed) notifyListeners();
    }
  }

  void clearIssue() {
    _issue = null;
    _streamIssue = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    unawaited(_subscription.cancel());
    unawaited(_repository.dispose());
    super.dispose();
  }
}
