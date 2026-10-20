import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import '../services/auth/cloud_sync_merge.dart';
import 'gacha_session.dart';

class GachaSnapshot {
  const GachaSnapshot({
    required this.enabled,
    required this.exclusion,
    required this.recordMode,
    required this.histories,
    required this.settingsLastUpdated,
    required this.historyUpdated,
  });

  final Set<PhysicsDomain> enabled;
  final ExclusionMode exclusion;
  final AutoRecordMode recordMode;
  final Map<String, History> histories;
  final DateTime settingsLastUpdated;
  final Map<String, DateTime> historyUpdated;

  GachaSnapshot copyWith({
    Set<PhysicsDomain>? enabled,
    ExclusionMode? exclusion,
    AutoRecordMode? recordMode,
    Map<String, History>? histories,
    DateTime? settingsLastUpdated,
    Map<String, DateTime>? historyUpdated,
  }) {
    return GachaSnapshot(
      enabled: enabled ?? this.enabled,
      exclusion: exclusion ?? this.exclusion,
      recordMode: recordMode ?? this.recordMode,
      histories: histories ?? this.histories,
      settingsLastUpdated: settingsLastUpdated ?? this.settingsLastUpdated,
      historyUpdated: historyUpdated ?? this.historyUpdated,
    );
  }
}

class GachaStore {
  static const _key = 'physics_gacha.snapshot';
  static const lastUserIdKey = 'physicsgacha/last_user_id';

  Future<GachaSnapshot?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) return null;
    return snapshotFromJson(json);
  }

  Future<void> saveSnapshot(GachaSnapshot snapshot) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(snapshotToJson(snapshot)));
  }

  Future<void> save(GachaSession session) async {
    final previous = await load();
    final now = DateTime.now();
    final settingsChanged = previous == null ||
        !_sameSettings(previous, session.enabled, session.exclusion, session.recordMode);

    final historyUpdated = Map<String, DateTime>.from(
      previous?.historyUpdated ?? const {},
    );
    for (final entry in session.histories.entries) {
      final prevHistory = previous?.histories[entry.key];
      if (prevHistory == null ||
          !_sameSlots(prevHistory.slots, entry.value.slots)) {
        historyUpdated[entry.key] = now;
      } else {
        historyUpdated.putIfAbsent(
          entry.key,
          () => previous?.historyUpdated[entry.key] ?? now,
        );
      }
    }

    final snapshot = GachaSnapshot(
      enabled: session.enabled,
      exclusion: session.exclusion,
      recordMode: session.recordMode,
      histories: session.histories,
      settingsLastUpdated: settingsChanged
          ? now
          : previous.settingsLastUpdated,
      historyUpdated: historyUpdated,
    );
    await saveSnapshot(snapshot);
  }

  Future<void> clearSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<String?> loadLastUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(lastUserIdKey);
  }

  Future<void> saveLastUserId(String? uid) async {
    final prefs = await SharedPreferences.getInstance();
    if (uid == null || uid.isEmpty) {
      await prefs.remove(lastUserIdKey);
      return;
    }
    await prefs.setString(lastUserIdKey, uid);
  }
}

Map<String, dynamic> snapshotToJson(GachaSnapshot snapshot) {
  return {
    'enabled': snapshot.enabled.map((domain) => domain.name).toList(),
    'exclusion': snapshot.exclusion.name,
    'recordMode': snapshot.recordMode.name,
    'histories': {
      for (final entry in snapshot.histories.entries)
        entry.key: entry.value.slots.map((slot) => slot.name).toList(),
    },
    'settingsLastUpdated': snapshot.settingsLastUpdated.toIso8601String(),
    'historyUpdated': {
      for (final entry in snapshot.historyUpdated.entries)
        entry.key: entry.value.toIso8601String(),
    },
  };
}

GachaSnapshot snapshotFromJson(Map<String, dynamic> json) {
  final enabledNames = json['enabled'];
  final enabled = enabledNames is List
      ? enabledNames
          .whereType<String>()
          .map(domainByName)
          .whereType<PhysicsDomain>()
          .toSet()
      : PhysicsDomain.values.toSet();
  final histories = _historiesFromJson(json['histories']);
  final now = DateTime.now();
  final settingsLastUpdated =
      parseTimestamp(json['settingsLastUpdated']) ?? now;
  final historyUpdated = <String, DateTime>{};
  final rawUpdated = json['historyUpdated'];
  if (rawUpdated is Map) {
    for (final entry in rawUpdated.entries) {
      if (entry.key is! String) continue;
      final parsed = parseTimestamp(entry.value);
      if (parsed != null) historyUpdated[entry.key as String] = parsed;
    }
  }
  for (final id in histories.keys) {
    historyUpdated.putIfAbsent(id, () => settingsLastUpdated);
  }
  return GachaSnapshot(
    enabled: enabled,
    exclusion: enumByName(ExclusionMode.values, json['exclusion'] as String?) ??
        ExclusionMode.latest1,
    recordMode:
        enumByName(AutoRecordMode.values, json['recordMode'] as String?) ??
            AutoRecordMode.both,
    histories: histories,
    settingsLastUpdated: settingsLastUpdated,
    historyUpdated: historyUpdated,
  );
}

Map<String, History> _historiesFromJson(Object? raw) {
  if (raw is! Map) return {};
  final histories = <String, History>{};
  for (final entry in raw.entries) {
    final slots = entry.value;
    if (entry.key is! String || slots is! List || slots.length != History.length) {
      continue;
    }
    histories[entry.key as String] = History([
      for (final name in slots)
        enumByName(SlotStatus.values, name is String ? name : null) ??
            SlotStatus.empty,
    ]);
  }
  return histories;
}

bool _sameSettings(
  GachaSnapshot previous,
  Set<PhysicsDomain> enabled,
  ExclusionMode exclusion,
  AutoRecordMode recordMode,
) {
  if (previous.exclusion != exclusion) return false;
  if (previous.recordMode != recordMode) return false;
  if (previous.enabled.length != enabled.length) return false;
  return previous.enabled.containsAll(enabled);
}

bool _sameSlots(List<SlotStatus> a, List<SlotStatus> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
