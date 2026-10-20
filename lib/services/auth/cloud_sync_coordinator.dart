import 'package:flutter/foundation.dart';

import '../../models/learning_record.dart';
import '../../models/physics_domain.dart';
import '../../state/gacha_session.dart';
import '../../state/gacha_store.dart';
import 'cloud_sync_merge.dart';
import 'cloud_sync_preference_service.dart';
import 'firebase_auth_service.dart';
import 'firestore_learning_service.dart';
import 'firestore_settings_service.dart';

/// Bridges [GachaStore] and Firestore when cloud sync is ON for the current uid.
class CloudSyncCoordinator {
  CloudSyncCoordinator({GachaStore? store}) : _store = store ?? GachaStore();

  final GachaStore _store;

  Future<void> refreshAuthAndMaybeSwitch() async {
    final uid = FirebaseAuthService.userId;
    await CloudSyncPreferenceService.refreshForUser(uid);
    if (uid == null) return;

    final last = await _store.loadLastUserId();
    if (last != null && last.isNotEmpty && last != uid) {
      await _store.clearSnapshot();
    }
    await _store.saveLastUserId(uid);
  }

  Future<void> pushAfterLocalSave() async {
    final uid = FirebaseAuthService.userId;
    if (uid == null) return;
    if (!await CloudSyncPreferenceService.isEnabledForUser(uid)) return;
    final snapshot = await _store.load();
    if (snapshot == null) return;
    await _pushSnapshot(uid, snapshot);
  }

  Future<GachaSnapshot?> pullMergeAndSave() async {
    final uid = FirebaseAuthService.userId;
    if (uid == null) return null;
    if (!await CloudSyncPreferenceService.isEnabledForUser(uid)) return null;

    await refreshAuthAndMaybeSwitch();

    final local = await _store.load() ??
        GachaSnapshot(
          enabled: PhysicsDomain.values.toSet(),
          exclusion: ExclusionMode.latest1,
          recordMode: AutoRecordMode.both,
          histories: const {},
          settingsLastUpdated: DateTime.fromMillisecondsSinceEpoch(0),
          historyUpdated: const {},
        );

    final cloud = await _loadCloudSnapshot(uid);
    final merged = mergeSnapshots(local: local, cloud: cloud);
    await _store.saveSnapshot(merged);
    await _pushSnapshot(uid, merged);
    return merged;
  }

  Future<void> setSyncEnabled(bool enabled) async {
    final uid = FirebaseAuthService.userId;
    if (uid == null) return;
    await CloudSyncPreferenceService.setEnabled(uid, enabled);
    if (enabled) {
      await pullMergeAndSave();
    }
  }

  GachaSession sessionFromSnapshot(GachaSnapshot snapshot) {
    return GachaSession(
      enabled: snapshot.enabled,
      exclusion: snapshot.exclusion,
      recordMode: AutoRecordMode.both,
      histories: snapshot.histories,
    );
  }

  Future<GachaSnapshot> _loadCloudSnapshot(String uid) async {
    final settings = await FirestoreSettingsService.getPhysicsGachaSettings(
      userId: uid,
    );
    final records = await FirestoreLearningService.getAllLearningRecords(
      userId: uid,
    );

    final enabledNames = settings?['enabled'];
    final enabled = enabledNames is List
        ? enabledNames
            .whereType<String>()
            .map(domainByName)
            .whereType<PhysicsDomain>()
            .toSet()
        : PhysicsDomain.values.toSet();

    final histories = <String, History>{};
    final historyUpdated = <String, DateTime>{};
    for (final entry in records.entries) {
      final history = historyFromFirestore(entry.value['history']);
      if (history == null) continue;
      histories[entry.key] = history;
      historyUpdated[entry.key] =
          parseTimestamp(entry.value['lastUpdated']) ?? DateTime.now();
    }

    return GachaSnapshot(
      enabled: enabled.isEmpty ? PhysicsDomain.values.toSet() : enabled,
      exclusion: enumByName(
            ExclusionMode.values,
            settings?['exclusion'] as String?,
          ) ??
          ExclusionMode.latest1,
      recordMode: enumByName(
            AutoRecordMode.values,
            settings?['recordMode'] as String?,
          ) ??
          AutoRecordMode.both,
      histories: histories,
      settingsLastUpdated:
          parseTimestamp(settings?['lastUpdated']) ??
              DateTime.fromMillisecondsSinceEpoch(0),
      historyUpdated: historyUpdated,
    );
  }

  Future<void> _pushSnapshot(String uid, GachaSnapshot snapshot) async {
    try {
      await FirestoreSettingsService.savePhysicsGachaSettings(
        userId: uid,
        settings: {
          'enabled': snapshot.enabled.map((d) => d.name).toList(),
          'exclusion': snapshot.exclusion.name,
          'recordMode': snapshot.recordMode.name,
          'lastUpdated': snapshot.settingsLastUpdated.toIso8601String(),
        },
      );

      for (final entry in snapshot.histories.entries) {
        final updated = snapshot.historyUpdated[entry.key] ??
            snapshot.settingsLastUpdated;
        await FirestoreLearningService.saveLearningRecord(
          userId: uid,
          problemId: entry.key,
          data: {
            'latestStatus': latestStatusOf(entry.value),
            'history': historyToFirestore(entry.value, updated),
            'lastUpdated': updated.toIso8601String(),
          },
        );
      }
    } catch (e) {
      debugPrint('Cloud sync push failed: $e');
    }
  }
}
