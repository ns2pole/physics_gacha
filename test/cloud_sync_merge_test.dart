import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/models/learning_record.dart';
import 'package:physics_gacha/models/physics_domain.dart';
import 'package:physics_gacha/services/auth/cloud_sync_merge.dart';
import 'package:physics_gacha/state/gacha_store.dart';

void main() {
  group('mergeSettingsMaps', () {
    test('newer local wins', () {
      final merged = mergeSettingsMaps(
        local: {
          'enabled': ['mechanics'],
          'lastUpdated': '2026-01-02T00:00:00.000Z',
        },
        cloud: {
          'enabled': ['waves'],
          'lastUpdated': '2026-01-01T00:00:00.000Z',
        },
      );
      expect(merged['enabled'], ['mechanics']);
    });

    test('equal timestamp prefers cloud', () {
      const stamp = '2026-01-01T00:00:00.000Z';
      final merged = mergeSettingsMaps(
        local: {'enabled': ['mechanics'], 'lastUpdated': stamp},
        cloud: {'enabled': ['waves'], 'lastUpdated': stamp},
      );
      expect(merged['enabled'], ['waves']);
    });
  });

  group('mergeLearningHistory', () {
    test('equal timestamp prefers local', () {
      final stamp = DateTime.parse('2026-01-01T00:00:00.000Z');
      final local = History([
        SlotStatus.solved,
        SlotStatus.empty,
        SlotStatus.empty,
      ]);
      final cloud = History([
        SlotStatus.failed,
        SlotStatus.empty,
        SlotStatus.empty,
      ]);
      final merged = mergeLearningHistory(
        problemId: 'p1',
        local: local,
        localUpdated: stamp,
        cloud: cloud,
        cloudUpdated: stamp,
      );
      expect(merged.history.slots.first, SlotStatus.solved);
    });

    test('cleared local can win when not older', () {
      final stamp = DateTime.parse('2026-01-02T00:00:00.000Z');
      final older = DateTime.parse('2026-01-01T00:00:00.000Z');
      final merged = mergeLearningHistory(
        problemId: 'p1',
        local: History.empty(),
        localUpdated: stamp,
        cloud: History([
          SlotStatus.solved,
          SlotStatus.solved,
          SlotStatus.solved,
        ]),
        cloudUpdated: older,
      );
      expect(merged.history.slots.every((s) => s == SlotStatus.empty), isTrue);
    });
  });

  group('mergeSnapshots', () {
    test('merges domains and histories', () {
      final older = DateTime.parse('2026-01-01T00:00:00.000Z');
      final newer = DateTime.parse('2026-01-03T00:00:00.000Z');
      final local = GachaSnapshot(
        enabled: {PhysicsDomain.mechanics},
        exclusion: ExclusionMode.latest1,
        recordMode: AutoRecordMode.both,
        histories: {
          'a': History([SlotStatus.solved, SlotStatus.empty, SlotStatus.empty]),
        },
        settingsLastUpdated: newer,
        historyUpdated: {'a': newer},
      );
      final cloud = GachaSnapshot(
        enabled: {PhysicsDomain.waves},
        exclusion: ExclusionMode.latest3,
        recordMode: AutoRecordMode.off,
        histories: {
          'a': History([SlotStatus.failed, SlotStatus.empty, SlotStatus.empty]),
          'b': History([
            SlotStatus.understood,
            SlotStatus.empty,
            SlotStatus.empty,
          ]),
        },
        settingsLastUpdated: older,
        historyUpdated: {
          'a': older,
          'b': newer,
        },
      );

      final merged = mergeSnapshots(local: local, cloud: cloud);
      expect(merged.enabled, {PhysicsDomain.mechanics});
      expect(merged.exclusion, ExclusionMode.latest1);
      expect(merged.histories['a']!.slots.first, SlotStatus.solved);
      expect(merged.histories['b']!.slots.first, SlotStatus.understood);
    });
  });

  group('snapshot json round-trip', () {
    test('keeps timestamps', () {
      final stamp = DateTime.parse('2026-01-01T12:00:00.000Z');
      final snapshot = GachaSnapshot(
        enabled: {PhysicsDomain.thermodynamics},
        exclusion: ExclusionMode.none,
        recordMode: AutoRecordMode.correctOnly,
        histories: {
          'q1': History([
            SlotStatus.solved,
            SlotStatus.understood,
            SlotStatus.empty,
          ]),
        },
        settingsLastUpdated: stamp,
        historyUpdated: {'q1': stamp},
      );
      final restored = snapshotFromJson(snapshotToJson(snapshot));
      expect(restored.enabled, snapshot.enabled);
      expect(restored.exclusion, snapshot.exclusion);
      expect(restored.recordMode, snapshot.recordMode);
      expect(restored.histories['q1']!.slots, snapshot.histories['q1']!.slots);
      expect(restored.settingsLastUpdated.toUtc(), stamp.toUtc());
      expect(restored.historyUpdated['q1']!.toUtc(), stamp.toUtc());
    });
  });
}
