import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'learning_models.dart';

class LearningCache {
  LearningCache({
    Future<Directory> Function()? directoryProvider,
    DateTime Function()? clock,
    int maxSizeBytes = 50 * 1024 * 1024,
  })  : _directoryProvider =
            directoryProvider ?? getApplicationSupportDirectory,
        _clock = clock ?? DateTime.now,
        _maxSizeBytes = maxSizeBytes;

  static const maxSizeBytes = 50 * 1024 * 1024;
  static const ttl = Duration(days: 7);
  final Future<Directory> Function() _directoryProvider;
  final DateTime Function() _clock;
  final int _maxSizeBytes;

  Future<CachedValue<T>?> read<T>(
    String key,
    T Function(Object? value) decode,
  ) async {
    final file = await _fileFor(key);
    if (!await file.exists()) return null;
    try {
      final envelope =
          jsonDecode(await file.readAsString()) as Map<String, Object?>;
      final fetchedAt = DateTime.parse(envelope['fetchedAt']! as String);
      envelope['accessedAt'] = _clock().toIso8601String();
      await file.writeAsString(jsonEncode(envelope), flush: true);
      return CachedValue(
        value: decode(envelope['value']),
        isStale: _clock().difference(fetchedAt) > ttl,
        fetchedAt: fetchedAt,
      );
    } on FormatException {
      await file.delete();
      return null;
    } on TypeError {
      await file.delete();
      return null;
    }
  }

  Future<void> write(String key, Object? value) async {
    final file = await _fileFor(key);
    final now = _clock().toIso8601String();
    await file.writeAsString(
      jsonEncode({'fetchedAt': now, 'accessedAt': now, 'value': value}),
      flush: true,
    );
    await _enforceSizeLimit();
  }

  Future<void> remove(String key) async {
    final file = await _fileFor(key);
    if (await file.exists()) await file.delete();
  }

  Future<File> _fileFor(String key) async {
    if (!RegExp(r'^[a-zA-Z0-9_-]{1,100}$').hasMatch(key)) {
      throw ArgumentError.value(key, 'key', 'Unsupported cache key.');
    }
    final directory = await _directoryProvider();
    final cacheDirectory =
        Directory('${directory.path}${Platform.pathSeparator}learning_cache');
    if (!await cacheDirectory.exists()) {
      await cacheDirectory.create(recursive: true);
    }
    return File('${cacheDirectory.path}${Platform.pathSeparator}$key.json');
  }

  Future<void> _enforceSizeLimit() async {
    final directory = await _directoryProvider();
    final cacheDirectory =
        Directory('${directory.path}${Platform.pathSeparator}learning_cache');
    final files = await cacheDirectory
        .list()
        .where((entry) => entry is File && entry.path.endsWith('.json'))
        .cast<File>()
        .toList();
    var totalBytes = 0;
    final accessTimes = <File, DateTime>{};
    for (final file in files) {
      totalBytes += await file.length();
      try {
        final envelope =
            jsonDecode(await file.readAsString()) as Map<String, Object?>;
        accessTimes[file] = DateTime.parse(envelope['accessedAt']! as String);
      } on Object {
        accessTimes[file] = DateTime.fromMillisecondsSinceEpoch(0);
      }
    }
    final oldestFirst = accessTimes.keys.toList()
      ..sort(
          (left, right) => accessTimes[left]!.compareTo(accessTimes[right]!));
    for (final file in oldestFirst) {
      if (totalBytes <= _maxSizeBytes) break;
      totalBytes -= await file.length();
      await file.delete();
    }
  }
}
