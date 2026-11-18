import '../models/mentor.dart';

abstract class MentorRepository {
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
    String? campus,
  });
}

class UnconfiguredMentorRepository implements MentorRepository {
  const UnconfiguredMentorRepository();

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
    String? campus,
  }) async =>
      const [];
}
