import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/models/learning_record.dart';

void main() {
  test('不正解は赤、直して正解すると次の空枠が緑', () {
    final wrong = autoRecord(
      history: History.empty(),
      mode: AutoRecordMode.both,
      correct: false,
      alreadyRecorded: null,
    );
    expect(wrong.history.slots, [
      SlotStatus.failed,
      SlotStatus.empty,
      SlotStatus.empty,
    ]);

    final fixed = autoRecord(
      history: wrong.history,
      mode: AutoRecordMode.both,
      correct: true,
      alreadyRecorded: wrong.alreadyRecorded,
    );
    expect(fixed.history.slots, [
      SlotStatus.failed,
      SlotStatus.solved,
      SlotStatus.empty,
    ]);
  });

  test('同じ正誤は重ねず、3枠のあとは上書きしない', () {
    final first = autoRecord(
      history: History.empty(),
      mode: AutoRecordMode.both,
      correct: false,
      alreadyRecorded: null,
    );
    final again = autoRecord(
      history: first.history,
      mode: AutoRecordMode.both,
      correct: false,
      alreadyRecorded: first.alreadyRecorded,
    );
    expect(again.wrote, isFalse);
    expect(again.history.slots.first, SlotStatus.failed);

    final history = History([
      SlotStatus.solved,
      SlotStatus.solved,
      SlotStatus.failed,
    ]);
    final full = autoRecord(
      history: history,
      mode: AutoRecordMode.both,
      correct: true,
      alreadyRecorded: null,
    );
    expect(full.wrote, isFalse);
    expect(full.history.slots, history.slots);
  });

  test('自動登録の3モード', () {
    final correctOnly = autoRecord(
      history: History.empty(),
      mode: AutoRecordMode.correctOnly,
      correct: false,
      alreadyRecorded: null,
    );
    expect(correctOnly.wrote, isFalse);

    final recorded = autoRecord(
      history: History.empty(),
      mode: AutoRecordMode.correctOnly,
      correct: true,
      alreadyRecorded: null,
    );
    expect(recorded.history.slots.first, SlotStatus.solved);

    final off = autoRecord(
      history: History.empty(),
      mode: AutoRecordMode.off,
      correct: true,
      alreadyRecorded: null,
    );
    expect(off.wrote, isFalse);
  });

  test('理解済みは手で入れる。空にすると右も空になる', () {
    final solved = cycleSlot(History.empty(), 0)!;
    expect(solved.slots.first, SlotStatus.solved);
    final understood = cycleSlot(solved, 0)!;
    expect(understood.slots.first, SlotStatus.understood);
    expect(cycleSlot(History.empty(), 1), isNull);

    final cleared = understood.write(0, SlotStatus.empty);
    expect(cleared.slots, [
      SlotStatus.empty,
      SlotStatus.empty,
      SlotStatus.empty,
    ]);
  });

  test('除外は右端からの緑の連続', () {
    final one = History([
      SlotStatus.failed,
      SlotStatus.empty,
      SlotStatus.solved,
    ]);
    expect(isExcluded(one, ExclusionMode.latest1), isTrue);
    expect(isExcluded(one, ExclusionMode.latest2), isFalse);

    final two = History([
      SlotStatus.solved,
      SlotStatus.solved,
      SlotStatus.empty,
    ]);
    expect(isExcluded(two, ExclusionMode.latest2), isTrue);

    final broken = History([
      SlotStatus.solved,
      SlotStatus.understood,
      SlotStatus.solved,
    ]);
    expect(isExcluded(broken, ExclusionMode.latest2), isFalse);
    expect(isExcluded(broken, ExclusionMode.latest1), isTrue);

    final three = History([
      SlotStatus.solved,
      SlotStatus.solved,
      SlotStatus.solved,
    ]);
    expect(isExcluded(three, ExclusionMode.latest3), isTrue);
    expect(isExcluded(three, ExclusionMode.none), isFalse);
  });
}
