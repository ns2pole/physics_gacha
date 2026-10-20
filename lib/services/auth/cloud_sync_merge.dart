import '../../models/learning_record.dart';
import '../../models/physics_domain.dart';
import '../../state/gacha_store.dart';

DateTime? parseTimestamp(Object? raw) {
  if (raw is DateTime) return raw;
  if (raw is! String || raw.isEmpty) return null;
  return DateTime.tryParse(raw);
}

/// Settings: equal timestamp → cloud wins (微積と同じ).
Map<String, dynamic> mergeSettingsMaps({
  required Map<String, dynamic> local,
  required Map<String, dynamic> cloud,
}) {
  final localUpdated = parseTimestamp(local['lastUpdated']);
  final cloudUpdated = parseTimestamp(cloud['lastUpdated']);
  if (localUpdated != null && cloudUpdated != null) {
    return localUpdated.isAfter(cloudUpdated) ? local : cloud;
  }
  if (localUpdated != null) return local;
  return cloud;
}

bool isClearedLearningHistory(List<SlotStatus> slots) {
  return slots.every((slot) => slot == SlotStatus.empty);
}

/// Learning: equal timestamp → local wins (微積と同じ).
HistoryMergeResult mergeLearningHistory({
  required String problemId,
  required History? local,
  required DateTime? localUpdated,
  required History? cloud,
  required DateTime? cloudUpdated,
}) {
  if (local == null && cloud == null) {
    return HistoryMergeResult(
      problemId: problemId,
      history: History.empty(),
      lastUpdated: DateTime.now(),
    );
  }
  if (local == null) {
    return HistoryMergeResult(
      problemId: problemId,
      history: cloud!,
      lastUpdated: cloudUpdated ?? DateTime.now(),
    );
  }
  if (cloud == null) {
    return HistoryMergeResult(
      problemId: problemId,
      history: local,
      lastUpdated: localUpdated ?? DateTime.now(),
    );
  }

  if (isClearedLearningHistory(local.slots) &&
      (cloudUpdated == null ||
          (localUpdated != null && !localUpdated.isBefore(cloudUpdated)))) {
    return HistoryMergeResult(
      problemId: problemId,
      history: local,
      lastUpdated: localUpdated ?? DateTime.now(),
    );
  }
  if (isClearedLearningHistory(cloud.slots) &&
      (localUpdated == null ||
          (cloudUpdated != null && !cloudUpdated.isBefore(localUpdated)))) {
    return HistoryMergeResult(
      problemId: problemId,
      history: cloud,
      lastUpdated: cloudUpdated ?? DateTime.now(),
    );
  }

  final localIsCurrent = cloudUpdated == null ||
      (localUpdated != null && !localUpdated.isBefore(cloudUpdated));
  return HistoryMergeResult(
    problemId: problemId,
    history: localIsCurrent ? local : cloud,
    lastUpdated: localIsCurrent
        ? (localUpdated ?? DateTime.now())
        : cloudUpdated,
  );
}

class HistoryMergeResult {
  const HistoryMergeResult({
    required this.problemId,
    required this.history,
    required this.lastUpdated,
  });

  final String problemId;
  final History history;
  final DateTime lastUpdated;
}

GachaSnapshot mergeSnapshots({
  required GachaSnapshot local,
  required GachaSnapshot cloud,
}) {
  final mergedSettings = mergeSettingsMaps(
    local: {
      'enabled': local.enabled.map((d) => d.name).toList(),
      'exclusion': local.exclusion.name,
      'recordMode': local.recordMode.name,
      'lastUpdated': local.settingsLastUpdated.toIso8601String(),
    },
    cloud: {
      'enabled': cloud.enabled.map((d) => d.name).toList(),
      'exclusion': cloud.exclusion.name,
      'recordMode': cloud.recordMode.name,
      'lastUpdated': cloud.settingsLastUpdated.toIso8601String(),
    },
  );

  final enabledNames = mergedSettings['enabled'];
  final enabled = enabledNames is List
      ? enabledNames
          .whereType<String>()
          .map(domainByName)
          .whereType<PhysicsDomain>()
          .toSet()
      : PhysicsDomain.values.toSet();

  final ids = {...local.histories.keys, ...cloud.histories.keys};
  final histories = <String, History>{};
  final historyUpdated = <String, DateTime>{};
  for (final id in ids) {
    final result = mergeLearningHistory(
      problemId: id,
      local: local.histories[id],
      localUpdated: local.historyUpdated[id],
      cloud: cloud.histories[id],
      cloudUpdated: cloud.historyUpdated[id],
    );
    histories[id] = result.history;
    historyUpdated[id] = result.lastUpdated;
  }

  return GachaSnapshot(
    enabled: enabled,
    exclusion: enumByName(
          ExclusionMode.values,
          mergedSettings['exclusion'] as String?,
        ) ??
        ExclusionMode.latest1,
    recordMode: enumByName(
          AutoRecordMode.values,
          mergedSettings['recordMode'] as String?,
        ) ??
        AutoRecordMode.both,
    histories: histories,
    settingsLastUpdated:
        parseTimestamp(mergedSettings['lastUpdated']) ?? DateTime.now(),
    historyUpdated: historyUpdated,
  );
}

PhysicsDomain? domainByName(String name) =>
    enumByName(PhysicsDomain.values, name);

T? enumByName<T extends Enum>(List<T> values, String? name) {
  for (final value in values) {
    if (value.name == name) return value;
  }
  return null;
}

String latestStatusOf(History history) {
  for (var i = history.slots.length - 1; i >= 0; i--) {
    final slot = history.slots[i];
    if (slot != SlotStatus.empty) return slot.name;
  }
  return SlotStatus.empty.name;
}

List<Map<String, dynamic>> historyToFirestore(
  History history,
  DateTime lastUpdated,
) {
  return [
    for (final slot in history.slots)
      {
        'status': slot.name,
        'time': lastUpdated.toIso8601String(),
      },
  ];
}

History? historyFromFirestore(Object? raw) {
  if (raw is! List || raw.length != History.length) return null;
  final slots = <SlotStatus>[];
  for (final item in raw) {
    if (item is Map) {
      final status = item['status'];
      slots.add(
        enumByName(SlotStatus.values, status is String ? status : null) ??
            SlotStatus.empty,
      );
    } else if (item is String) {
      slots.add(enumByName(SlotStatus.values, item) ?? SlotStatus.empty);
    } else {
      slots.add(SlotStatus.empty);
    }
  }
  return History(slots);
}
