import 'package:flutter/material.dart';

import '../logic/problem_pool.dart';
import '../models/learning_record.dart';
import '../l10n/app_localizations.dart';
import '../utils/l10n_utils.dart';
import '../models/physics_domain.dart';
import '../models/physics_problem.dart';
import '../state/gacha_session.dart';
import 'background_image.dart';
import 'filter_bar.dart';
import 'fixed_end_reflection_figure.dart';
import 'free_end_reflection_figure.dart';
import 'history_slots.dart';
import 'problem_detail_page.dart';
import 'problem_figure_view.dart';

/// 全問題と、その3枠の履歴。単元と除外で絞る。
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

  void _setDomain(PhysicsDomain domain, bool selected) {
    final next = {...widget.session.enabled};
    selected ? next.add(domain) : next.remove(domain);
    setState(() => widget.session.setEnabled(next));
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
    var domainTotal = 0;
    for (var i = 0; i < problems.length; i++) {
      final problem = problems[i];
      if (!acceptsDomains(problem, session.enabled)) continue;
      domainTotal += 1;
      if (isExcluded(session.historyOf(problem), session.exclusion)) continue;
      visible.add((number: i + 1, problem: problem));
    }
    final remaining = visible.length;
    final total = domainTotal;

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
        title: Text(AppLocalizations.of(context)!.problemList),
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
                  return ExclusionFilterCard(
                    mode: session.exclusion,
                    remaining: remaining,
                    total: total,
                    enabled: session.enabled,
                    onDomain: _setDomain,
                    onChanged: _setExclusion,
                  );
                }
                if (visible.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Text(AppLocalizations.of(context)!.noMatchingProblems),
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
    return DomainTintCard(
      domains: problem.domains,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 8, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'No. $number(${joinedDomainLabels(context, problem.domains)})',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 1.15,
                          ),
                        ),
                        Text(
                          problem.getLocalizedTheme(context),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            height: 1.15,
                            color: Color(0xFF546E7A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  HistorySlots(
                    problemId: problem.id,
                    history: history,
                    onCycle: onCycle,
                    iconSize: 33,
                  ),
                  ElevatedButton.icon(
                    key: ValueKey('detail-${problem.id}'),
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new, size: 16),
                    label: Text(AppLocalizations.of(context)!.detail),
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
              _ProblemStatement(
                text: problem.getLocalizedStatement(context),
                figure: _listFigure(problem),
              ),
            ],
          ),
        ),
    );
  }
}

/// 問題文の図。無いときは、自由端・固定端のヒントアニメを一覧にも出す。
Widget? _listFigure(PhysicsProblem problem) {
  final figure = problem.figure;
  if (figure != null) return problemFigureView(figure);
  return switch (problem.hintReveal) {
    HintReveal.freeEndReflection => const FreeEndReflectionFigure(),
    HintReveal.fixedEndReflection => const FixedEndReflectionFigure(),
    HintReveal.message || HintReveal.groupUpperBlocks => null,
  };
}

/// 図はカード幅の半分で中央に置く。高さは図の比率のまま、収まるだけ低くする。
/// 問題文はその下から書く。
class _ProblemStatement extends StatelessWidget {
  const _ProblemStatement({required this.text, this.figure});

  final String text;
  final Widget? figure;

  static const _style = TextStyle(fontSize: 15, height: 1.5);

  @override
  Widget build(BuildContext context) {
    final figure = this.figure;
    if (figure == null) {
      return Text(text, style: _style);
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SizedBox(
                width: constraints.maxWidth / 2,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: figure,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(text, style: _style),
          ],
        );
      },
    );
  }
}
