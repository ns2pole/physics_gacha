import 'package:flutter/material.dart';

import '../models/learning_record.dart';
import '../models/physics_problem.dart';
import '../state/gacha_session.dart';
import 'background_image.dart';
import 'history_slots.dart';
import 'problem_detail_page.dart';

/// 全問題と、その3枠の履歴。単元では絞らない。除外された問題だけ隠す。
class ProblemListPage extends StatefulWidget {
  const ProblemListPage({
    super.key,
    required this.session,
    required this.onHistoryChanged,
  });

  final GachaSession session;

  /// 履歴か除外を変えたとき。保存とガチャ画面の描き直しに使う。
  final VoidCallback onHistoryChanged;

  @override
  State<ProblemListPage> createState() => _ProblemListPageState();
}

class _ProblemListPageState extends State<ProblemListPage> {
  void _setExclusion(ExclusionMode mode) {
    setState(() => widget.session.setExclusion(mode));
    widget.onHistoryChanged();
  }

  void _cycle(PhysicsProblem problem, int slot) {
    widget.session.cycle(problem, slot);
    setState(() {});
    widget.onHistoryChanged();
  }

  void _openDetail(PhysicsProblem problem, int number) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProblemDetailPage(
          session: widget.session,
          problem: problem,
          number: number,
          onChanged: () {
            setState(() {});
            widget.onHistoryChanged();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final problems = session.problems;
    final visible = <({int number, PhysicsProblem problem})>[];
    for (var i = 0; i < problems.length; i++) {
      final problem = problems[i];
      if (isExcluded(session.historyOf(problem), session.exclusion)) continue;
      visible.add((number: i + 1, problem: problem));
    }
    final remaining = visible.length;
    final total = problems.length;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        foregroundColor: const Color(0xFF1565C0),
        title: const Text('問題一覧'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundImage()),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + kToolbarHeight,
            ),
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
              itemCount: visible.length + (visible.isEmpty ? 2 : 1),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _ExclusionChip(
                    mode: session.exclusion,
                    remaining: remaining,
                    total: total,
                    onChanged: _setExclusion,
                  );
                }
                if (visible.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Text('該当する問題がありません'),
                  );
                }
                final row = visible[index - 1];
                return _ProblemRow(
                  number: row.number,
                  problem: row.problem,
                  history: session.historyOf(row.problem),
                  onCycle: (slot) => _cycle(row.problem, slot),
                  onOpen: () => _openDetail(row.problem, row.number),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ExclusionChip extends StatefulWidget {
  const _ExclusionChip({
    required this.mode,
    required this.remaining,
    required this.total,
    required this.onChanged,
  });

  final ExclusionMode mode;
  final int remaining;
  final int total;
  final ValueChanged<ExclusionMode> onChanged;

  @override
  State<_ExclusionChip> createState() => _ExclusionChipState();
}

class _ExclusionChipState extends State<_ExclusionChip> {
  final _key = GlobalKey();

  Future<void> _openMenu() async {
    final target = _key.currentContext?.findRenderObject() as RenderBox?;
    final overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    if (target == null || overlay == null) return;
    final origin = target.localToGlobal(Offset.zero, ancestor: overlay);
    final selected = await showMenu<ExclusionMode>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(
          origin.dx,
          origin.dy + target.size.height,
          target.size.width,
          0,
        ),
        Offset.zero & overlay.size,
      ),
      items: [
        for (final mode in ExclusionMode.values)
          PopupMenuItem(value: mode, child: Text(mode.label)),
      ],
    );
    if (selected != null) widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final purple = Colors.purple[700];
    final style = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: purple,
    );
    return Material(
      key: _key,
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.purple.shade200),
      ),
      child: InkWell(
        onTap: _openMenu,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.mode == ExclusionMode.none)
                  Text('除外なし', style: style)
                else ...[
                  Text('最新${widget.mode.neededGreens}回が', style: style),
                  const SizedBox(width: 4),
                  const _GreenCheck(),
                  const SizedBox(width: 4),
                  Text('の問題を除く', style: style),
                ],
                const SizedBox(width: 8),
                Text(
                  widget.mode == ExclusionMode.none
                      ? '全${widget.total}問'
                      : '(残 ${widget.remaining}問/${widget.total}問)',
                  style: style.copyWith(color: Colors.purple[600]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GreenCheck extends StatelessWidget {
  const _GreenCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Colors.green,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.check, size: 12, color: Colors.white),
    );
  }
}

class _ProblemRow extends StatelessWidget {
  const _ProblemRow({
    required this.number,
    required this.problem,
    required this.history,
    required this.onCycle,
    required this.onOpen,
  });

  final int number;
  final PhysicsProblem problem;
  final History history;
  final ValueChanged<int> onCycle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'No. $number',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                HistorySlots(
                  problemId: problem.id,
                  history: history,
                  onCycle: onCycle,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  key: ValueKey('detail-${problem.id}'),
                  onPressed: onOpen,
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: const Text('詳細'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                problem.statement,
                style: const TextStyle(fontSize: 15, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
