import '../clubs/club_models.dart';
import '../discovery/facility_model.dart';
import '../discovery/mentor_model.dart';
import 'club_content_templates.dart';
import 'content_draft_models.dart';
import 'directory_content_templates.dart';
import 'learning_content_templates.dart';

export 'club_content_templates.dart';
export 'content_draft_models.dart';
export 'directory_content_templates.dart';
export 'learning_content_templates.dart';

/// Central access point for bundled starter templates across all domains.
class ContentTemplates {
  ContentTemplates._();

  static const List<ModuleDraft> moduleTemplates =
      LearningContentTemplates.moduleTemplates;

  static const List<QuestionDraft> questionTemplates =
      LearningContentTemplates.questionTemplates;

  static const List<ArticleDraft> articleTemplates =
      LearningContentTemplates.articleTemplates;

  static List<StudentClub> get clubTemplates =>
      ClubContentTemplates.clubTemplates;

  static const List<Facility> facilityTemplates =
      DirectoryContentTemplates.facilityTemplates;

  static const List<Mentor> mentorTemplates =
      DirectoryContentTemplates.mentorTemplates;
}
