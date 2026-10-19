import 'package:flutter/material.dart';

import '../models/physics_problem.dart';
import '../state/gacha_session.dart';
import 'ac_resistor_figure.dart';
import 'background_image.dart';
import 'compressed_spring_figure.dart';
import 'fixed_end_reflection_figure.dart';
import 'free_end_reflection_figure.dart';
import 'history_slots.dart';
import 'incline_pull_figure.dart';
import 'math_expression_view.dart';
import 'open_pipe_figure.dart';
import 'resistor_current_figure.dart';
import 'series_circuit_figure.dart';
import 'sliding_comparison_figure.dart';
import 'spring_pulleys_figure.dart';
import 'stacked_blocks_figure.dart';
import 'unit_expression_view.dart';

/// 問題文、図、履歴、解説。ガチャへ戻すボタンは置かない。
class ProblemDetailPage extends StatefulWidget {
  const ProblemDetailPage({
    super.key,
    required this.session,
    required this.problem,
    required this.number,
    required this.onChanged,
  });

  final GachaSession session;
  final PhysicsProblem problem;
  final int number;
  final VoidCallback onChanged;

  @override
  State<ProblemDetailPage> createState() => _ProblemDetailPageState();
}

class _ProblemDetailPageState extends State<ProblemDetailPage> {
  void _cycle(int slot) {
    widget.session.cycle(widget.problem, slot);
    setState(() {});
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final problem = widget.problem;
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
        title: Text('No. ${widget.number}'),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: BackgroundImage()),
          ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.paddingOf(context).top + kToolbarHeight + 12,
              16,
              32,
            ),
            children: [
              if (problem.figure != null) ...[
                Center(child: _figure(problem.figure!)),
                const SizedBox(height: 6),
              ],
              Text(
                problem.statement,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 8),
              HistorySlots(
                problemId: problem.id,
                history: widget.session.historyOf(problem),
                onCycle: _cycle,
              ),
              const SizedBox(height: 16),
              const _Heading('答え'),
              const SizedBox(height: 8),
              _AnswerValue(problem: problem),
              _Section(
                title: 'ヒント',
                body: problem.hint,
                figure: switch (problem.hintReveal) {
                  HintReveal.freeEndReflection => const FreeEndReflectionFigure(),
                  HintReveal.fixedEndReflection => const FixedEndReflectionFigure(),
                  HintReveal.message || HintReveal.groupUpperBlocks => null,
                },
              ),
              _Section(title: '方針', body: problem.approach),
              _Section(title: '最初の一手', body: problem.firstStep),
              _Section(title: '解説', body: problem.explanation),
            ],
          ),
        ],
      ),
    );
  }

  Widget _figure(ProblemFigure figure) {
    return switch (figure) {
      ProblemFigure.stackedBlocks => const StackedBlocksFigure(),
      ProblemFigure.seriesCircuit => const SeriesCircuitFigure(),
      ProblemFigure.openPipe => const OpenPipeFigure(),
      ProblemFigure.slidingComparison => const SlidingComparisonFigure(),
      ProblemFigure.resistorCurrent => const ResistorCurrentFigure(),
      ProblemFigure.springPulleys => const SpringPulleysFigure(),
      ProblemFigure.compressedSpring => const CompressedSpringFigure(),
      ProblemFigure.acResistor => const AcResistorFigure(),
      ProblemFigure.inclinePull => const InclinePullFigure(),
    };
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body, this.figure});

  final String title;
  final String body;
  final Widget? figure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Heading(title),
          if (figure != null) ...[
            const SizedBox(height: 8),
            Center(child: figure),
          ],
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 16, height: 1.5)),
        ],
      ),
    );
  }
}

class _AnswerValue extends StatelessWidget {
  const _AnswerValue({required this.problem});

  final PhysicsProblem problem;

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(fontSize: 22, fontWeight: FontWeight.w600);
    final value = _ValueText(text: problem.answerDisplay, style: style);
    if (problem.answerUnitLabel.isEmpty) return value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        value,
        const SizedBox(width: 6),
        _UnitText(unit: problem.answerUnitLabel, style: style),
      ],
    );
  }
}

class _ValueText extends StatelessWidget {
  const _ValueText({required this.text, required this.style});

  final String text;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (text.contains('^')) {
      return MathExpressionView(expression: text, style: style);
    }
    return Text(text, style: style);
  }
}

class _UnitText extends StatelessWidget {
  const _UnitText({required this.unit, required this.style});

  final String unit;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    if (unitNeedsTypesetting(unit)) {
      return UnitExpressionView(unit: unit, style: style);
    }
    return Text(unit, style: style);
  }
}
