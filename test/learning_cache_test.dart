import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:yegna_health_app/src/learning/learning_cache.dart';

void main() {
  test('cache returns an offline copy and marks it stale after seven days',
      () async {
    final directory =
        await Directory.systemTemp.createTemp('yegna-learning-cache-');
    addTearDown(() => directory.delete(recursive: true));
    var now = DateTime.utc(2026, 1, 1);
    final cache = LearningCache(
      directoryProvider: () async => directory,
      clock: () => now,
    );

    await cache.write('article_en_one', {'title': 'Saved article'});
    final fresh = await cache.read<Map<String, Object?>>(
      'article_en_one',
      (value) => (value! as Map<Object?, Object?>).cast<String, Object?>(),
    );
    expect(fresh?.isStale, isFalse);

    now = now.add(const Duration(days: 8));
    final stale = await cache.read<Map<String, Object?>>(
      'article_en_one',
      (value) => (value! as Map<Object?, Object?>).cast<String, Object?>(),
    );
    expect(stale?.isStale, isTrue);
    expect(stale?.value['title'], 'Saved article');
  });

  test('cache evicts least recently used files after reaching its size cap',
      () async {
    final directory =
        await Directory.systemTemp.createTemp('yegna-learning-cache-');
    addTearDown(() => directory.delete(recursive: true));
    final cache = LearningCache(
      directoryProvider: () async => directory,
      maxSizeBytes: 500,
    );
    await cache.write('article_en_first', {'body': 'a' * 100});
    await cache.write('article_en_second', {'body': 'b' * 100});
    await cache.write('article_en_third', {'body': 'c' * 100});

    final first =
        await cache.read<Object?>('article_en_first', (value) => value);
    final third =
        await cache.read<Object?>('article_en_third', (value) => value);
    expect(first, isNull);
    expect(third, isNotNull);
  });
}
