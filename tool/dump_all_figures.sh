#!/bin/zsh
set -euo pipefail
cd "$(dirname "$0")/.."
rm -rf build/figure_review
mkdir -p build/figure_review

NAMES=(
  stackedBlocks seriesCircuit openPipe slidingComparison resistorCurrent
  springPulleys compressedSpring acResistor inclinePull batteryResistor
  seriesCurrent parallelCurrent bridgeVoltageDrop isothermalGas isobaricGas
  isochoricGas adiabaticGas connectedVessels diatomicVessels
  verticalSpringOscillation simplePendulum keplerOrbits beats seriesSprings
  parallelSprings resonanceColumn chargedCapacitor parallelPlateCapacitor
  dielectricCapacitor metalInsertCapacitor parallelCapacitors freeFallSpeed
  freeFallTime longThrow heatDrop evacuatedCylinder geostationarySatellite
  moonOrbit sunOrbit cavendishTorsion dopplerWall singleSlit diffractionGrating
  toothbrushString stringFundamental conicalPendulum twoSpeakers soundSpeedColumn
  verticalSpringRelease tensionCart horizontalSpringRelease pendulumBottomSpeed
  blockEndLift diskHoleCenter cutSheetCenter slideTipHeight floatingWood
  kineticFrictionSlide staticFrictionHold turntableSpring elevatorScale
  nailPendulum underwaterScale pendulumBottomTension stairPressure fujiPressure
  syringePiston waterDepthPressure invertedColumn saltWaterPressure heliumBag
  nichromeWire copperWire currentLoop rcDecay solenoidCoil lorentzBar aluminumCube
  hint_freeEndReflection hint_fixedEndReflection
)

# 初回コンパイル
FIGURE_NAME=stackedBlocks flutter test tool/dump_one_figure.dart --timeout 90s

for name in "${NAMES[@]}"; do
  if [[ -f "build/figure_review/${name}.png" ]]; then
    echo "skip $name"
    continue
  fi
  echo "=== $name ==="
  # 固まったら 50 秒で殺して次へ
  FIGURE_NAME="$name" flutter test tool/dump_one_figure.dart --timeout 50s --no-pub \
    || echo "TIMEOUT_OR_FAIL $name" | tee -a build/figure_review/_dump.log
done

echo "count=$(ls build/figure_review/*.png 2>/dev/null | wc -l | tr -d ' ')"
