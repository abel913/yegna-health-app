import '../models/assessment_models.dart';

abstract interface class AssessmentRepository {
  Future<List<AssessmentSummary>> assessments(String locale);
  Future<CachedValue<Assessment>?> assessment(String versionId, String locale);
  Future<List<PendingAssessmentSubmission>> pendingSubmissions();
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  });
  Future<AssessmentSubmission?> retryPending(String requestId);
}

class AssessmentSubmission {
  const AssessmentSubmission.completed(this.result, {required this.requestId})
      : isPending = false;
  const AssessmentSubmission.pending({required this.requestId})
      : result = null,
        isPending = true;

  final String requestId;
  final AssessmentResult? result;
  final bool isPending;
}

class AssessmentRejected implements Exception {
  const AssessmentRejected();
}

class AssessmentUnavailable implements Exception {
  const AssessmentUnavailable();
}

class UnconfiguredAssessmentRepository implements AssessmentRepository {
  const UnconfiguredAssessmentRepository();

  @override
  Future<List<AssessmentSummary>> assessments(String locale) async =>
      throw const AssessmentUnavailable();

  @override
  Future<CachedValue<Assessment>?> assessment(
          String versionId, String locale) async =>
      throw const AssessmentUnavailable();

  @override
  Future<List<PendingAssessmentSubmission>> pendingSubmissions() async =>
      const [];

  @override
  Future<AssessmentSubmission> submit({
    required Assessment assessment,
    required Map<String, String> selectedOptions,
    required bool syncProgress,
  }) async =>
      throw const AssessmentRejected();

  @override
  Future<AssessmentSubmission?> retryPending(String requestId) async => null;
}
