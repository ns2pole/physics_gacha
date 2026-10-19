import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/learning_record.dart';
import '../models/physics_domain.dart';
import 'gacha_session.dart';

class GachaSnapshot {
  const GachaSnapshot({
    required this.enabled,
    required this.exclusion,
    required this.recordMode,
    required this.histories,
  });

  final Set<PhysicsDomain> enabled;
  final ExclusionMode exclusion;
  final AutoRecordMode recordMode;
  final Map<String, History> histories;
}

class GachaStore {
  static const _key = 'physics_gacha.snapshot';

  Future<GachaSnapshot?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return null;
    final json = jsonDecode(raw);
    if (json is! Map<String, dynamic>) return null;
    return _snapshotFromJson(json);
  }

  Future<void> save(GachaSession session) async {
    final prefs = await SharedPreferences.getInstance();
    final snapshot = GachaSnapshot(
      enabled: session.enabled,
      exclusion: session.exclusion,
      recordMode: session.recordMode,
      histories: session.histories,
    );
    await prefs.setString(_key, jsonEncode(_snapshotToJson(snapshot)));
  }
}

Map<String, dynamic> _snapshotToJson(GachaSnapshot snapshot) {
  return {
    'enabled': snapshot.enabled.map((domain) => domain.name).toList(),
    'exclusion': snapshot.exclusion.name,
    'recordMode': snapshot.recordMode.name,
    'histories': {
      for (final entry in snapshot.histories.entries)
        entry.key: entry.value.slots.map((slot) => slot.name).toList(),
    },
  };
}

GachaSnapshot _snapshotFromJson(Map<String, dynamic> json) {
  final enabledNames = json['enabled'];
  final enabled = enabledNames is List
      ? enabledNames
            .whereType<String>()
            .map(_domainByName)
            .whereType<PhysicsDomain>()
            .toSet()
      : PhysicsDomain.values.toSet();
  return GachaSnapshot(
    enabled: enabled,
    exclusion: _enumByName(ExclusionMode.values, json['exclusion'] as String?) ??
        ExclusionMode.latest1,
    recordMode:
        _enumByName(AutoRecordMode.values, json['recordMode'] as String?) ??
        AutoRecordMode.both,
    histories: _historiesFromJson(json['histories']),
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
        _enumByName(SlotStatus.values, name is String ? name : null) ??
            SlotStatus.empty,
    ]);
  }
  return histories;
}

PhysicsDomain? _domainByName(String name) => _enumByName(PhysicsDomain.values, name);

T? _enumByName<T extends Enum>(List<T> values, String? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}
