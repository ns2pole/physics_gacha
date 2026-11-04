import 'package:flutter/material.dart';

import '../models/physics_problem.dart';
import 'ac_resistor_figure.dart';
import 'battery_resistor_figure.dart';
import 'beats_figure.dart';
import 'bridge_voltage_drop_figure.dart';
import 'capacitor_plate_figure.dart';
import 'cavendish_torsion_figure.dart';
import 'charged_capacitor_figure.dart';
import 'compressed_spring_figure.dart';
import 'free_fall_figure.dart';
import 'geostationary_satellite_figure.dart';
import 'evacuated_cylinder_figure.dart';
import 'heat_drop_figure.dart';
import 'connected_vessels_figure.dart';
import 'gas_cylinder_figure.dart';
import 'incline_pull_figure.dart';
import 'kepler_orbits_figure.dart';
import 'long_throw_figure.dart';
import 'moon_orbit_figure.dart';
import 'sun_orbit_figure.dart';
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
import 'note_article_figures.dart';
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
    ProblemFigure.freeFallSpeed => const FreeFallFigure(heightLabel: '0.90 m'),
    ProblemFigure.freeFallTime => const FreeFallFigure(heightLabel: '4.9 m'),
    ProblemFigure.longThrow => const LongThrowFigure(),
    ProblemFigure.heatDrop => const HeatDropFigure(),
    ProblemFigure.evacuatedCylinder => const EvacuatedCylinderFigure(),
    ProblemFigure.geostationarySatellite =>
      const GeostationarySatelliteFigure(),
    ProblemFigure.moonOrbit => const MoonOrbitFigure(),
    ProblemFigure.sunOrbit => const SunOrbitFigure(),
    ProblemFigure.cavendishTorsion => const CavendishTorsionFigure(),
    _ => noteArticleFigure(figure),
  };
}
