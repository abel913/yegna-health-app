import 'dart:convert';

import 'learning_models.dart';

/// Browser cache for public learning content.
///
/// Browser entries remain available for the lifetime of the tab. Authentication
/// sessions use secure storage independently from this disposable content cache.
class LearningCache {
  LearningCache({
    // Accepted for constructor compatibility with the native implementation;
    // browser entries stay in memory and do not access a filesystem.
    Object? directoryProvider,
    DateTime Function()? clock,
    int maxSizeBytes = 50 * 1024 * 1024,
  })  : _clock = clock ?? DateTime.now,
        _maxSizeBytes = maxSizeBytes;

  static const maxSizeBytes = 50 * 1024 * 1024;
  static const ttl = Duration(days: 7);

  final DateTime Function() _clock;
  final int _maxSizeBytes;
  final Map<String, _CacheEntry> _entries = {};

  Future<CachedValue<T>?> read<T>(
    String key,
    T Function(Object? value) decode,
  ) async {
    final entry = _entries[key];
    if (entry == null) return null;
    entry.accessedAt = _clock();
    try {
      return CachedValue(
        value: decode(jsonDecode(jsonEncode(entry.value))),
        isStale: _clock().difference(entry.fetchedAt) > ttl,
        fetchedAt: entry.fetchedAt,
      );
    } on FormatException {
      _entries.remove(key);
      return null;
    } on TypeError {
      _entries.remove(key);
      return null;
    }
  }

  Future<void> write(String key, Object? value) async {
    final now = _clock();
    _entries[key] = _CacheEntry(
      value: jsonDecode(jsonEncode(value)),
      fetchedAt: now,
      accessedAt: now,
    );
    _enforceSizeLimit();
  }

  Future<void> remove(String key) async {
    _entries.remove(key);
  }

  void _enforceSizeLimit() {
    var totalBytes = _entries.values.fold<int>(
      0,
      (total, entry) => total + utf8.encode(jsonEncode(entry.value)).length,
    );
    final oldestFirst = _entries.entries.toList()
      ..sort((left, right) =>
          left.value.accessedAt.compareTo(right.value.accessedAt));
    for (final item in oldestFirst) {
      if (totalBytes <= _maxSizeBytes) break;
      totalBytes -= utf8.encode(jsonEncode(item.value.value)).length;
      _entries.remove(item.key);
    }
  }
}

class _CacheEntry {
  _CacheEntry({
    required this.value,
    required this.fetchedAt,
    required this.accessedAt,
  });

  final Object? value;
  final DateTime fetchedAt;
  DateTime accessedAt;
}
