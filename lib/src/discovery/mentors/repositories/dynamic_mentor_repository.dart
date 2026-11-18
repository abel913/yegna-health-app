import '../models/mentor.dart';
import 'local_verified_mentor_repository.dart';
import 'mentor_repository.dart';

class DynamicMentorRepository implements MentorRepository {
  const DynamicMentorRepository({
    this.customMentorsProvider,
    this.fallback = const LocalVerifiedMentorRepository(),
  });

  final Future<List<Mentor>> Function()? customMentorsProvider;
  final MentorRepository fallback;

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
    String? campus,
  }) async {
    final base = await fallback.getMentors(
      query: query,
      topic: topic,
      language: language,
      onlineOnly: onlineOnly,
      campus: campus,
    );
    if (fallback is UnconfiguredMentorRepository) {
      return base;
    }
    if (customMentorsProvider == null) return base;
    try {
      final custom = await customMentorsProvider!();
      final ids = base.map((m) => m.id).toSet();
      var extras = custom.where((m) => !ids.contains(m.id)).toList();
      if (campus != null &&
          campus.isNotEmpty &&
          campus != 'all' &&
          campus != 'Central Directorate / All Campuses') {
        final target = campus.toLowerCase();
        extras = extras.where((m) {
          final c = m.campus.toLowerCase();
          return c.contains(target) || target.contains(c);
        }).toList();
      }
      return [...base, ...extras];
    } catch (_) {
      return base;
    }
  }
}
