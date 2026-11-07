import 'package:flutter/material.dart';

import '../integrations/ai_chat/physics_ai_chat_launcher.dart';
import '../l10n/app_localizations.dart';
import '../models/physics_problem.dart';
import '../state/gacha_session.dart';
import '../utils/l10n_utils.dart';
import 'ac_resistor_figure.dart';
import 'battery_resistor_figure.dart';
import 'beats_figure.dart';
import 'bridge_voltage_drop_figure.dart';
import 'capacitor_plate_figure.dart';
import 'cavendish_torsion_figure.dart';
import 'charged_capacitor_figure.dart';
import 'background_image.dart';
import 'filter_bar.dart';
import 'compressed_spring_figure.dart';
import 'free_fall_figure.dart';
import 'geostationary_satellite_figure.dart';
import 'evacuated_cylinder_figure.dart';
import 'heat_drop_figure.dart';
import 'connected_vessels_figure.dart';
import 'fixed_end_reflection_figure.dart';
import 'free_end_reflection_figure.dart';
import 'gas_cylinder_figure.dart';
import 'history_slots.dart';
import 'incline_pull_figure.dart';
import 'kepler_orbits_figure.dart';
import 'long_throw_figure.dart';
import 'moon_orbit_figure.dart';
import 'problem_figure_view.dart';
import 'sun_orbit_figure.dart';
import 'math_expression_view.dart';
import 'open_pipe_figure.dart';
import 'parallel_capacitors_figure.dart';
import 'parallel_current_figure.dart';
import 'parallel_springs_figure.dart';
import 'resonance_column_figure.dart';
import 'resistor_current_figure.dart';
import 'series_circuit_figure.dart';
import 'series_current_figure.dart';
import 'series_springs_figure.dart';
import 'simple_pendulum_figure.dart';
import 'sliding_comparison_figure.dart';
import 'spring_pulleys_figure.dart';
import 'stacked_blocks_figure.dart';
import 'unit_expression_view.dart';
import 'vertical_spring_oscillation_figure.dart';

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
    final l10n = AppLocalizations.of(context)!;
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: ElevatedButton(
              onPressed: () {
                PhysicsAiChatLauncher.open(
                  context: context,
                  problem: problem,
                  hintShown: true,
                  answerShown: true,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1565C0),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                side: const BorderSide(color: Color(0xFF1565C0)),
                shape: const StadiumBorder(),
              ),
              child: Text(l10n.askAi),
            ),
          ),
        ],
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
              DomainTintCard(
                domains: problem.domains,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (problem.figure != null) ...[
                        Center(child: _figure(problem.figure!)),
                        const SizedBox(height: 6),
                      ],
                      Text(
                        problem.getLocalizedStatement(context),
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              HistorySlots(
                problemId: problem.id,
                history: widget.session.historyOf(problem),
                onCycle: _cycle,
              ),
              const SizedBox(height: 16),
              _Heading(l10n.answerLabel),
              const SizedBox(height: 8),
              _AnswerValue(problem: problem),
              _Section(
                title: l10n.hint,
                body: problem.getLocalizedHint(context),
                figure: switch (problem.hintReveal) {
                  HintReveal.freeEndReflection =>
                    const FreeEndReflectionFigure(),
                  HintReveal.fixedEndReflection =>
                    const FixedEndReflectionFigure(),
                  HintReveal.message || HintReveal.groupUpperBlocks => null,
                },
              ),
              _Section(
                title: l10n.approach,
                body: problem.getLocalizedApproach(context),
              ),
              _Section(
                title: l10n.firstStep,
                body: problem.getLocalizedFirstStep(context),
              ),
              _Section(
                title: l10n.explanation,
                body: problem.getLocalizedExplanation(context),
                figure: problem.explanationFigure == null
                    ? null
                    : _figure(problem.explanationFigure!),
              ),
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
      ProblemFigure.batteryResistor => const BatteryResistorFigure(),
      ProblemFigure.seriesCurrent => const SeriesCurrentFigure(),
      ProblemFigure.parallelCurrent => const ParallelCurrentFigure(),
      ProblemFigure.bridgeVoltageDrop => const BridgeVoltageDropFigure(),
      ProblemFigure.isothermalGas => const GasCylinderFigure(
        process: GasCylinderProcess.isothermal,
      ),
      ProblemFigure.isobaricGas => const GasCylinderFigure(
        process: GasCylinderProcess.isobaric,
      ),
      ProblemFigure.isochoricGas => const GasCylinderFigure(
        process: GasCylinderProcess.isochoric,
      ),
      ProblemFigure.adiabaticGas => const GasCylinderFigure(
        process: GasCylinderProcess.adiabatic,
      ),
      ProblemFigure.connectedVessels => const ConnectedVesselsFigure(),
      ProblemFigure.diatomicVessels => const ConnectedVesselsFigure(
        leftInside: '0.20 mol',
        leftBelow: '293 K',
        rightInside: '0.10 mol',
        rightBelow: '353 K',
      ),
      ProblemFigure.verticalSpringOscillation =>
        const VerticalSpringOscillationFigure(),
      ProblemFigure.simplePendulum => const SimplePendulumFigure(),
      ProblemFigure.keplerOrbits => const KeplerOrbitsFigure(),
      ProblemFigure.beats => const BeatsFigure(),
      ProblemFigure.seriesSprings => const SeriesSpringsFigure(),
      ProblemFigure.parallelSprings => const ParallelSpringsFigure(),
      ProblemFigure.resonanceColumn => const ResonanceColumnFigure(),
      ProblemFigure.chargedCapacitor => const ChargedCapacitorFigure(),
      ProblemFigure.parallelPlateCapacitor => const CapacitorPlateFigure(
        kind: CapacitorPlateKind.vacuum,
      ),
      ProblemFigure.dielectricCapacitor => const CapacitorPlateFigure(
        kind: CapacitorPlateKind.paper,
      ),
      ProblemFigure.metalInsertCapacitor => const CapacitorPlateFigure(
        kind: CapacitorPlateKind.metal,
      ),
      ProblemFigure.parallelCapacitors => const ParallelCapacitorsFigure(),
      ProblemFigure.freeFallSpeed => const FreeFallFigure(
        heightLabel: '0.90 m',
      ),
      ProblemFigure.freeFallTime => const FreeFallFigure(heightLabel: '4.9 m'),
      ProblemFigure.longThrow => const LongThrowFigure(),
      ProblemFigure.heatDrop => const HeatDropFigure(),
      ProblemFigure.evacuatedCylinder => const EvacuatedCylinderFigure(),
      ProblemFigure.geostationarySatellite =>
        const GeostationarySatelliteFigure(),
      ProblemFigure.moonOrbit => const MoonOrbitFigure(),
      ProblemFigure.sunOrbit => const SunOrbitFigure(),
      ProblemFigure.cavendishTorsion => const CavendishTorsionFigure(),
      _ => problemFigureView(figure),
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
    final value = _ValueText(
      text: problem.getLocalizedAnswerDisplay(context),
      style: style,
    );
    final unit = problem.getLocalizedAnswerUnitLabel(context);
    if (unit.isEmpty) return value;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        value,
        const SizedBox(width: 6),
        _UnitText(unit: unit, style: style),
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
