import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreSettingsService {
  FirestoreSettingsService._();

  static const gachaTypePhysics = 'physics';

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static CollectionReference _gachaTypes(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('settings')
        .doc('gacha_settings')
        .collection('gacha_types');
  }

  static Future<bool> savePhysicsGachaSettings({
    required String userId,
    required Map<String, dynamic> settings,
  }) async {
    try {
      await _gachaTypes(userId).doc(gachaTypePhysics).set({
        'gachaType': gachaTypePhysics,
        'settings': settings,
        'lastUpdated':
            settings['lastUpdated'] ?? DateTime.now().toIso8601String(),
      }, SetOptions(merge: true));
      return true;
    } catch (e) {
      debugPrint('Firestore settings save failed: $e');
      return false;
    }
  }

  /// Returns the inner `settings` map with lastUpdated normalized to ISO string.
  static Future<Map<String, dynamic>?> getPhysicsGachaSettings({
    required String userId,
  }) async {
    try {
      final doc = await _gachaTypes(userId).doc(gachaTypePhysics).get();
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;

      var lastUpdated = data['lastUpdated'];
      if (lastUpdated is Timestamp) {
        lastUpdated = lastUpdated.toDate().toIso8601String();
      }

      final settings = data['settings'];
      if (settings is! Map) {
        return {
          'lastUpdated': ?lastUpdated,
        };
      }
      final map = Map<String, dynamic>.from(settings);
      map['lastUpdated'] = lastUpdated ?? map['lastUpdated'];
      if (map['lastUpdated'] is Timestamp) {
        map['lastUpdated'] =
            (map['lastUpdated'] as Timestamp).toDate().toIso8601String();
      }
      return map;
    } catch (e) {
      debugPrint('Firestore settings get failed: $e');
      return null;
    }
  }
}
