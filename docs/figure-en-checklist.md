# 図の英語ラベルチェックリスト

端末が英語のとき、図上の文言が英語になっているかを見る。
問題文の翻訳（`i18n-checklist.md`）とは別。`FigureLabels` / `app_en.arb` 経由のものと、
コードに直書きした日本語が残っていないかを確認する。

レビュー用PDF: `build/figure_en_labels.pdf`（`flutter test tool/dump_figure_en_review.dart --update-goldens`）

## 判定

- ○: 英語（または数字・記号のみで言語なし）
- ×: 漢字・かななど日本語が残っている
- ×→○: 直して確認済
- 空欄: 未確認（目視）

## ソース上の直書き（対応済）

- `keplerOrbits` / `soundSpeedColumn` / `verticalSpringRelease` / `horizontalSpringRelease` / `syringePiston` / `currentLoop` / `solenoidCoil` — FigureLabels + ARB に移行（×→○）


## 表

| figure | 英語 | メモ |
| --- | --- | --- |
| `stackedBlocks` |  |  |
| `seriesCircuit` |  |  |
| `openPipe` |  |  |
| `slidingComparison` |  |  |
| `resistorCurrent` |  |  |
| `springPulleys` |  |  |
| `compressedSpring` |  |  |
| `acResistor` |  |  |
| `inclinePull` |  |  |
| `batteryResistor` |  |  |
| `seriesCurrent` |  |  |
| `parallelCurrent` |  |  |
| `bridgeVoltageDrop` |  |  |
| `isothermalGas` |  |  |
| `isobaricGas` |  |  |
| `isochoricGas` |  |  |
| `adiabaticGas` |  |  |
| `connectedVessels` |  |  |
| `diatomicVessels` |  |  |
| `verticalSpringOscillation` |  |  |
| `simplePendulum` |  |  |
| `keplerOrbits` | ×→○ | `1 yr`（FigureLabels） |
| `beats` |  |  |
| `seriesSprings` |  |  |
| `parallelSprings` |  |  |
| `resonanceColumn` |  |  |
| `chargedCapacitor` |  |  |
| `parallelPlateCapacitor` |  |  |
| `dielectricCapacitor` |  |  |
| `metalInsertCapacitor` |  |  |
| `parallelCapacitors` |  |  |
| `freeFallSpeed` |  |  |
| `freeFallTime` |  |  |
| `longThrow` |  |  |
| `heatDrop` |  |  |
| `evacuatedCylinder` |  |  |
| `geostationarySatellite` |  |  |
| `moonOrbit` |  |  |
| `sunOrbit` |  |  |
| `cavendishTorsion` |  |  |
| `dopplerWall` |  |  |
| `singleSlit` |  |  |
| `diffractionGrating` |  |  |
| `toothbrushString` |  |  |
| `stringFundamental` |  |  |
| `conicalPendulum` |  |  |
| `twoSpeakers` |  |  |
| `soundSpeedColumn` | ×→○ | Air temp via FigureLabels |
| `verticalSpringRelease` | ×→○ | Natural length |
| `tensionCart` |  |  |
| `horizontalSpringRelease` | ×→○ | Natural length |
| `pendulumBottomSpeed` |  |  |
| `blockEndLift` |  |  |
| `diskHoleCenter` |  |  |
| `cutSheetCenter` |  |  |
| `slideTipHeight` |  |  |
| `floatingWood` |  |  |
| `kineticFrictionSlide` |  |  |
| `staticFrictionHold` |  |  |
| `turntableSpring` |  |  |
| `elevatorScale` |  |  |
| `nailPendulum` |  |  |
| `underwaterScale` |  |  |
| `pendulumBottomTension` |  |  |
| `stairPressure` |  |  |
| `fujiPressure` |  |  |
| `syringePiston` | ×→○ | diameter 2.0 cm |
| `waterDepthPressure` |  |  |
| `invertedColumn` |  |  |
| `saltWaterPressure` |  |  |
| `heliumBag` |  |  |
| `nichromeWire` |  |  |
| `copperWire` |  |  |
| `currentLoop` | ×→○ | 100 turns |
| `rcDecay` |  |  |
| `solenoidCoil` | ×→○ | Current I / 100 turns |
| `lorentzBar` |  |  |
| `aluminumCube` |  |  |
| `hint_freeEndReflection` |  |  |
| `hint_fixedEndReflection` |  |  |
