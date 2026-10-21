import 'package:flutter/material.dart';

import '../models/physics_problem.dart';
import 'ac_resistor_figure.dart';
import 'battery_resistor_figure.dart';
import 'beats_figure.dart';
import 'bridge_voltage_drop_figure.dart';
import 'compressed_spring_figure.dart';
import 'connected_vessels_figure.dart';
import 'gas_cylinder_figure.dart';
import 'incline_pull_figure.dart';
import 'kepler_orbits_figure.dart';
import 'open_pipe_figure.dart';
import 'parallel_current_figure.dart';
import 'resistor_current_figure.dart';
import 'series_circuit_figure.dart';
import 'series_current_figure.dart';
import 'simple_pendulum_figure.dart';
import 'sliding_comparison_figure.dart';
import 'spring_pulleys_figure.dart';
import 'stacked_blocks_figure.dart';
import 'vertical_spring_oscillation_figure.dart';

/// 問題文の先頭から見せる図。ヒント用の図は含めない。
Widget problemFigureView(ProblemFigure figure) {
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
      leftInside: '2.0 mol',
      leftBelow: '300 K',
      rightInside: '1.0 mol',
      rightBelow: '900 K',
    ),
    ProblemFigure.verticalSpringOscillation =>
      const VerticalSpringOscillationFigure(),
    ProblemFigure.simplePendulum => const SimplePendulumFigure(),
    ProblemFigure.keplerOrbits => const KeplerOrbitsFigure(),
    ProblemFigure.beats => const BeatsFigure(),
  };
}
