import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// 1枠の状態。左が古い3枠で1問の履歴になる。
enum SlotStatus { empty, solved, understood, failed }

/// 電卓の判定を履歴へ書くかどうか。
enum AutoRecordMode { both, correctOnly, off }

/// 右端から数えた緑の連続で、ガチャから外す。
enum ExclusionMode { none, latest1, latest2, latest3 }

extension SlotStatusLabel on SlotStatus {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      SlotStatus.empty => l10n.slotEmpty,
      SlotStatus.solved => l10n.slotSolved,
      SlotStatus.understood => l10n.slotUnderstood,
      SlotStatus.failed => l10n.slotFailed,
    };
  }
}

extension AutoRecordModeLabel on AutoRecordMode {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      AutoRecordMode.both => l10n.autoRecordBoth,
      AutoRecordMode.correctOnly => l10n.autoRecordCorrectOnly,
      AutoRecordMode.off => l10n.autoRecordOff,
    };
  }
}

extension ExclusionModeLabel on ExclusionMode {
  String label(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return switch (this) {
      ExclusionMode.none => l10n.exclusionModeNone,
      ExclusionMode.latest1 => l10n.exclusionModeLatest1,
      ExclusionMode.latest2 => l10n.exclusionModeLatest2,
      ExclusionMode.latest3 => l10n.exclusionModeLatest3,
    };
  }

  int get neededGreens => switch (this) {
    ExclusionMode.none => 0,
    ExclusionMode.latest1 => 1,
    ExclusionMode.latest2 => 2,
    ExclusionMode.latest3 => 3,
  };
}

class History {
  History(List<SlotStatus> slots) : slots = List.unmodifiable(slots) {
    if (slots.length != length) {
      throw ArgumentError('履歴は3枠です。');
    }
  }

  static const length = 3;

  factory History.empty() => History(List.filled(length, SlotStatus.empty));

  final List<SlotStatus> slots;

  int? get firstEmpty {
    final index = slots.indexOf(SlotStatus.empty);
    return index < 0 ? null : index;
  }

  History write(int index, SlotStatus status) {
    final next = [...slots];
    next[index] = status;
    if (status == SlotStatus.empty) {
      for (var i = index + 1; i < next.length; i++) {
        next[i] = SlotStatus.empty;
      }
    }
    return History(next);
  }
}

/// タップで空 → 解決済み → 理解済み → 失敗 → 空。
/// 左が空のまま、その右だけは埋めない。空にした枠より右も空にする。
History? cycleSlot(History history, int index) {
  if (index < 0 || index >= History.length) return null;
  const order = [
    SlotStatus.empty,
    SlotStatus.solved,
    SlotStatus.understood,
    SlotStatus.failed,
  ];
  final current = history.slots[index];
  final next = order[(order.indexOf(current) + 1) % order.length];
  if (next != SlotStatus.empty) {
    for (var i = 0; i < index; i++) {
      if (history.slots[i] == SlotStatus.empty) return null;
    }
  }
  return history.write(index, next);
}

class AutoRecordResult {
  const AutoRecordResult({
    required this.history,
    required this.wrote,
    required this.alreadyRecorded,
  });

  final History history;
  final bool wrote;

  /// この表示中に自動で書いた最新の正誤。書いていなければ null。
  final bool? alreadyRecorded;
}

/// 同じ表示中に、同じ正誤は重ねない。3枠が埋まったら上書きしない。
AutoRecordResult autoRecord({
  required History history,
  required AutoRecordMode mode,
  required bool correct,
  required bool? alreadyRecorded,
}) {
  if (mode == AutoRecordMode.off) {
    return AutoRecordResult(
      history: history,
      wrote: false,
      alreadyRecorded: alreadyRecorded,
    );
  }
  if (mode == AutoRecordMode.correctOnly && !correct) {
    return AutoRecordResult(
      history: history,
      wrote: false,
      alreadyRecorded: alreadyRecorded,
    );
  }
  if (alreadyRecorded != null && alreadyRecorded == correct) {
    return AutoRecordResult(
      history: history,
      wrote: false,
      alreadyRecorded: alreadyRecorded,
    );
  }
  final index = history.firstEmpty;
  if (index == null) {
    return AutoRecordResult(
      history: history,
      wrote: false,
      alreadyRecorded: alreadyRecorded,
    );
  }
  return AutoRecordResult(
    history: history.write(
      index,
      correct ? SlotStatus.solved : SlotStatus.failed,
    ),
    wrote: true,
    alreadyRecorded: correct,
  );
}

/// 右端から緑を数える。空枠は飛ばす。理解済みと失敗は連続を止める。
bool isExcluded(History history, ExclusionMode mode) {
  final needed = mode.neededGreens;
  if (needed == 0) return false;
  var count = 0;
  for (final slot in history.slots.reversed) {
    if (slot == SlotStatus.empty) continue;
    if (slot == SlotStatus.solved) {
      count++;
      if (count >= needed) return true;
      continue;
    }
    return false;
  }
  return false;
}
