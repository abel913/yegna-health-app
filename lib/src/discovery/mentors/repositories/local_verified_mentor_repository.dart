import '../models/mentor.dart';
import 'mentor_repository.dart';
import 'verified_mentors_data.dart';

class LocalVerifiedMentorRepository implements MentorRepository {
  const LocalVerifiedMentorRepository();

  @override
  Future<List<Mentor>> getMentors({
    String? query,
    MentorTopic? topic,
    String? language,
    bool? onlineOnly,
    String? campus,
  }) async {
    var result = List<Mentor>.from(verifiedMentors);

    if (onlineOnly == true) {
      result = result.where((m) => m.isCurrentlyAvailableNow).toList();
    }

    if (topic != null && topic != MentorTopic.all) {
      result = result.where((m) => m.topics.contains(topic)).toList();
    }

    if (language != null && language.isNotEmpty && language != 'All') {
      result = result.where((m) => m.languages.contains(language)).toList();
    }

    if (campus != null &&
        campus.isNotEmpty &&
        campus != 'all' &&
        campus != 'Central Directorate / All Campuses') {
      final target = campus.toLowerCase();
      result = result.where((m) {
        final c = m.campus.toLowerCase();
        return c.contains(target) || target.contains(c);
      }).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((m) {
        final matchEn = m.nameEn.toLowerCase().contains(clean) ||
            m.organizationEn.toLowerCase().contains(clean) ||
            m.bioEn.toLowerCase().contains(clean) ||
            m.telegramHandle.toLowerCase().contains(clean) ||
            m.phoneNumber.contains(clean) ||
            m.displayPhoneNumber.contains(clean) ||
            m.campus.toLowerCase().contains(clean) ||
            m.languages.any((l) => l.toLowerCase().contains(clean));
        final matchAm = m.nameAm.contains(clean) ||
            m.organizationAm.contains(clean) ||
            m.bioAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }
}
