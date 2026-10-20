import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Per-uid preference for whether Firestore cloud sync is active.
class CloudSyncPreferenceService {
  CloudSyncPreferenceService._();

  static const String _keyPrefix = 'physicsgacha/cloud_sync_enabled/';

  static final ValueNotifier<String?> _activeUserId = ValueNotifier(null);
  static final ValueNotifier<bool> _enabled = ValueNotifier(false);

  static ValueListenable<String?> get activeUserIdListenable => _activeUserId;
  static ValueListenable<bool> get enabledListenable => _enabled;

  static String _keyForUser(String uid) => '$_keyPrefix$uid';

  static Future<bool> isEnabledForUser(String? uid) async {
    if (uid == null || uid.isEmpty) return false;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyForUser(uid)) == true;
  }

  static Future<bool> isEnabledForCurrentUser() async {
    return isEnabledForUser(_activeUserId.value);
  }

  static Future<void> refreshForUser(String? uid) async {
    _activeUserId.value = uid;
    if (uid == null || uid.isEmpty) {
      _enabled.value = false;
      return;
    }
    _enabled.value = await isEnabledForUser(uid);
  }

  static Future<void> setEnabled(String uid, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyForUser(uid), value);
    if (_activeUserId.value == uid) {
      _enabled.value = value;
    }
  }

  static Future<void> removeForUser(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyForUser(uid));
    if (_activeUserId.value == uid) {
      _enabled.value = false;
    }
  }
}
