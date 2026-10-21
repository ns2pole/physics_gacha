import 'package:flutter/material.dart';

import '../models/learning_record.dart';

/// 3枠の履歴。空は灰の輪郭、正解は緑、理解は橙、失敗は赤。
class HistorySlots extends StatelessWidget {
  const HistorySlots({
    super.key,
    required this.problemId,
    required this.history,
    required this.onCycle,
    this.iconSize = 22,
  });

  final String problemId;
  final History history;
  final ValueChanged<int> onCycle;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final tap = iconSize + 10;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < history.slots.length; i++)
          IconButton(
            key: ValueKey('history-$problemId-$i'),
            tooltip: history.slots[i].label(context),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: tap, minHeight: tap),
            onPressed: () => onCycle(i),
            icon: Icon(
              _icon(history.slots[i]),
              size: iconSize,
              color: _color(history.slots[i]),
            ),
          ),
      ],
    );
  }

  IconData _icon(SlotStatus status) => switch (status) {
    SlotStatus.solved => Icons.check_circle,
    SlotStatus.understood => Icons.lightbulb,
    SlotStatus.failed => Icons.cancel,
    SlotStatus.empty => Icons.circle_outlined,
  };

  Color _color(SlotStatus status) => switch (status) {
    SlotStatus.solved => Colors.green,
    SlotStatus.understood => Colors.orange,
    SlotStatus.failed => Colors.red,
    SlotStatus.empty => Colors.grey,
  };
}
