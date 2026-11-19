import 'dart:convert';
import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/assessment_models.dart';

class AssessmentSubmissionStorage {
  const AssessmentSubmissionStorage({
    FlutterSecureStorage? secureStorage,
  }) : _storage = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<List<PendingAssessmentSubmission>> readPending(String userId) async {
    final raw = await _storage.read(key: 'learning.pending.$userId');
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List<Object?>)
          .map((item) => PendingAssessmentSubmission.fromJson(
              (item! as Map<Object?, Object?>).cast<String, Object?>()))
          .toList();
    } on Object {
      await _storage.delete(key: 'learning.pending.$userId');
      return [];
    }
  }

  Future<void> savePending(
    String userId,
    PendingAssessmentSubmission submission,
  ) async {
    final pending = await readPending(userId);
    pending.removeWhere((item) => item.requestId == submission.requestId);
    pending.add(submission);
    await _storage.write(
      key: 'learning.pending.$userId',
      value: jsonEncode(pending.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> removePending(String userId, String requestId) async {
    final pending = await readPending(userId);
    pending.removeWhere((item) => item.requestId == requestId);
    if (pending.isEmpty) {
      await _storage.delete(key: 'learning.pending.$userId');
    } else {
      await _storage.write(
        key: 'learning.pending.$userId',
        value: jsonEncode(pending.map((item) => item.toJson()).toList()),
      );
    }
  }

  static String newUuid() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex =
        bytes.map((byte) => byte.toRadixString(16).padLeft(2, '0')).join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
