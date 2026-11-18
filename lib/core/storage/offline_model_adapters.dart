import '../../src/clubs/club_models.dart';
import '../../src/discovery/facility_model.dart';
import '../../src/discovery/mentor_model.dart';
import 'club_offline_adapter.dart';
import 'facility_offline_adapter.dart';
import 'mentor_offline_adapter.dart';

export 'club_offline_adapter.dart';
export 'facility_offline_adapter.dart';
export 'mentor_offline_adapter.dart';

/// Centralized adapters delegating to modular domain adapters.
class OfflineModelAdapters {
  static Map<String, dynamic> facilityToMap(Facility f) =>
      FacilityOfflineAdapter.toMap(f);
  static Facility facilityFromMap(Map<String, dynamic> map) =>
      FacilityOfflineAdapter.fromMap(map);

  static Map<String, dynamic> mentorToMap(Mentor m) =>
      MentorOfflineAdapter.toMap(m);
  static Mentor mentorFromMap(Map<String, dynamic> map) =>
      MentorOfflineAdapter.fromMap(map);

  static StudentClub clubFromBackendMap(Map<String, dynamic> map) =>
      ClubOfflineAdapter.fromBackendMap(map);
}
