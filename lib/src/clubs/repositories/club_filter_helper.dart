import '../club_models.dart';

class ClubFilterHelper {
  static List<StudentClub> filter(
    List<StudentClub> input, {
    ClubCategory? category,
    String? query,
  }) {
    var result = List<StudentClub>.from(input);

    if (category != null && category != ClubCategory.all) {
      result = result.where((c) => c.category == category).toList();
    }

    if (query != null && query.trim().isNotEmpty) {
      final clean = query.trim().toLowerCase();
      result = result.where((c) {
        final matchEn = c.nameEn.toLowerCase().contains(clean) ||
            c.descriptionEn.toLowerCase().contains(clean) ||
            c.meetingLocationEn.toLowerCase().contains(clean);
        final matchAm = c.nameAm.contains(clean) ||
            c.descriptionAm.contains(clean) ||
            c.meetingLocationAm.contains(clean);
        return matchEn || matchAm;
      }).toList();
    }

    return result;
  }
}
