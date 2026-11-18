enum FacilityType {
  publicHealthCenter,
  campusClinic,
  youthCenter,
}

enum FacilityCategory {
  clinical,
  counseling,
  academic,
  studentAffairs,
  sportsDining,
  accessibility;

  static FacilityCategory fromString(String? val) {
    if (val == null) return FacilityCategory.clinical;
    switch (val.toLowerCase().trim()) {
      case 'counseling':
        return FacilityCategory.counseling;
      case 'academic':
        return FacilityCategory.academic;
      case 'student_affairs':
      case 'studentaffairs':
        return FacilityCategory.studentAffairs;
      case 'sports_dining':
      case 'sportsdining':
      case 'sports':
        return FacilityCategory.sportsDining;
      case 'accessibility':
        return FacilityCategory.accessibility;
      case 'clinical':
      default:
        return FacilityCategory.clinical;
    }
  }

  String toDbString() {
    switch (this) {
      case FacilityCategory.clinical:
        return 'clinical';
      case FacilityCategory.counseling:
        return 'counseling';
      case FacilityCategory.academic:
        return 'academic';
      case FacilityCategory.studentAffairs:
        return 'student_affairs';
      case FacilityCategory.sportsDining:
        return 'sports_dining';
      case FacilityCategory.accessibility:
        return 'accessibility';
    }
  }
}

enum FacilityFilterCategory {
  all,
  nearby,
  campus,
  srhVct,
  mentalHealth,
  clinical,
  counseling,
  academic,
  studentAffairs,
  sportsDining,
  accessibility,
}
