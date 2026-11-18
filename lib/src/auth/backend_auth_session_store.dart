import 'package:shared_preferences/shared_preferences.dart';

import 'auth_models.dart';

class BackendAuthSessionStore {
  const BackendAuthSessionStore(this._preferences);

  final SharedPreferences _preferences;

  static const String keyToken = 'backend_auth_token';
  static const String keyUserId = 'backend_auth_user_id';
  static const String keyEmail = 'backend_auth_email';
  static const String keyDisplayName = 'backend_auth_display_name';
  static const String keyRole = 'backend_auth_role';
  static const String keySurveyCompleted = 'backend_auth_survey_completed';

  String? get token => _preferences.getString(keyToken);

  AuthUser? loadUser() {
    final tokenVal = _preferences.getString(keyToken);
    final userId = _preferences.getString(keyUserId);
    final email = _preferences.getString(keyEmail);
    final displayName = _preferences.getString(keyDisplayName) ?? '';
    final role = _preferences.getString(keyRole) ?? 'STUDENT';
    final surveyCompleted = _preferences.getBool(keySurveyCompleted) ?? false;

    if (tokenVal != null && tokenVal.isNotEmpty && userId != null && email != null) {
      return AuthUser(
        id: userId,
        email: email,
        displayName: displayName,
        role: role,
        emailVerified: true,
        hasCompletedSurvey: surveyCompleted,
      );
    }
    return null;
  }

  Future<AuthUser> saveUserFromMap(
    String token,
    Map<String, dynamic> user, {
    String fallbackName = '',
  }) async {
    final id = user['id'] as String;
    final email = user['email'] as String;
    final name = (user['displayName'] as String?) ?? fallbackName;
    final role = (user['role'] as String?) ?? 'STUDENT';
    final surveyCompleted = user['hasCompletedSurvey'] as bool? ?? false;

    await _preferences.setString(keyToken, token);
    await _preferences.setString(keyUserId, id);
    await _preferences.setString(keyEmail, email);
    await _preferences.setString(keyDisplayName, name);
    await _preferences.setString(keyRole, role);
    await _preferences.setBool(keySurveyCompleted, surveyCompleted);

    return AuthUser(
      id: id,
      email: email,
      displayName: name,
      role: role,
      emailVerified: true,
      hasCompletedSurvey: surveyCompleted,
    );
  }

  Future<void> updateProfile({
    String? displayName,
    String? role,
    bool? surveyCompleted,
  }) async {
    if (displayName != null) {
      await _preferences.setString(keyDisplayName, displayName);
    }
    if (role != null) {
      await _preferences.setString(keyRole, role);
    }
    if (surveyCompleted != null) {
      await _preferences.setBool(keySurveyCompleted, surveyCompleted);
    }
  }

  Future<void> clearSession() async {
    await _preferences.remove(keyToken);
    await _preferences.remove(keyUserId);
    await _preferences.remove(keyEmail);
    await _preferences.remove(keyDisplayName);
    await _preferences.remove(keyRole);
    await _preferences.remove(keySurveyCompleted);
  }
}
