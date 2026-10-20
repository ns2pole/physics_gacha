import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreLearningService {
  FirestoreLearningService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference _records(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('learning_records');
  }

  static String sanitizeProblemId(String problemId) =>
      problemId.replaceAll('/', '_');

  static Future<bool> saveLearningRecord({
    required String userId,
    required String problemId,
    required Map<String, dynamic> data,
  }) async {
    try {
      await _records(userId).doc(sanitizeProblemId(problemId)).set({
        'problemId': problemId,
        'latestStatus': data['latestStatus'],
        'history': data['history'],
        'lastUpdated': data['lastUpdated'] ?? DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('Firestore learning save failed: $e');
      return false;
    }
  }

  static Future<Map<String, Map<String, dynamic>>> getAllLearningRecords({
    required String userId,
  }) async {
    final snapshot = await _records(userId).get();
    final records = <String, Map<String, dynamic>>{};
    for (final doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;
      final normalized = Map<String, dynamic>.from(data);
      _normalizeTimestamps(normalized);
      final problemId = normalized['problemId'] as String? ?? doc.id;
      records[problemId] = normalized;
    }
    return records;
  }

  static void _normalizeTimestamps(Map<String, dynamic> data) {
    final lastUpdated = data['lastUpdated'];
    if (lastUpdated is Timestamp) {
      data['lastUpdated'] = lastUpdated.toDate().toIso8601String();
    }
    final history = data['history'];
    if (history is! List) return;
    data['history'] = history.map((item) {
      if (item is! Map) return item;
      final converted = Map<String, dynamic>.from(item);
      final time = converted['time'];
      if (time is Timestamp) {
        converted['time'] = time.toDate().toIso8601String();
      }
      return converted;
    }).toList();
  }
}
