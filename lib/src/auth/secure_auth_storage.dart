import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Stores Supabase's persisted session outside ordinary app preferences.
class SecureAuthStorage extends LocalStorage implements GotrueAsyncStorage {
  const SecureAuthStorage({
    FlutterSecureStorage storage = const FlutterSecureStorage(),
  }) : _storage = storage;

  static const _sessionKey = 'SUPABASE_PERSIST_SESSION_KEY';

  final FlutterSecureStorage _storage;

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() => _storage.read(key: _sessionKey);

  @override
  Future<bool> hasAccessToken() async =>
      await _storage.read(key: _sessionKey) != null;

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: _sessionKey, value: persistSessionString);

  @override
  Future<void> removePersistedSession() => _storage.delete(key: _sessionKey);

  @override
  Future<String?> getItem({required String key}) => _storage.read(key: key);

  @override
  Future<void> setItem({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> removeItem({required String key}) => _storage.delete(key: key);
}
