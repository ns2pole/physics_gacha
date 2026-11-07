# 図ラベル被りチェックリスト

数値・単位ラベルが線・球・棒などの描画に被っていないかを見る。

## やり方（2026-11-05 実施）

1. `flutter test tool/dump_figure_review.dart --update-goldens` で全図を PNG 化（`build/figure_review/`、80枚）
2. 各 PNG を目視（ラベル位置のバウンディングと図形の重なり）
3. 被りはコードで座標を直して、該当図を再ダンプ

※ テスト環境のフォント都合で CJK／一部記号が□化することがある。□の位置をラベル領域として判定した。実機フォントでは字形は違うが、占める場所は同じ。

## 文字サイズ・太さ

- `figureLabelStyle` 既定: **15 / w500**（No.12・13 の見え方に揃える）
- `noteText` 既定: **15 / w500**
- 圧力計ラベル: **15 / w500**
- 寸法矢印（`paintSpanMarker`）も同じ既定

## 判定

- ○: 数値が見える。線や塗りに被っていない（おもり中央の質量表示など、塗り上の意図的な文字は ○）
- △: やや近い／要様子見
- ×: 被って読めない → 直す（直したものはメモに「修正済」）
- －: 描画数値なし（画像アセットのみ）

## 表（PNG 目視）

| figure | 被り | メモ |
| --- | --- | --- |
| `acResistor` | ○ | |
| `adiabaticGas` | ○ | |
| `aluminumCube` | ○ | |
| `batteryResistor` | ○ | |
| `beats` | ○ | |
| `blockEndLift` | ○ | 厚みあり・浅い角・力は端の上 |
| `bridgeVoltageDrop` | △ | 抵抗ラベルが配線に近い |
| `cavendishTorsion` | ×→○ | 斜め図 100 kg・俯瞰 rad・0.40 kg を外へ（修正済） |
| `chargedCapacitor` | ○ | |
| `compressedSpring` | △ | 要再確認 |
| `conicalPendulum` | △ | 紐に近い |
| `connectedVessels` | △ | 配管付近が近い。要再確認 |
| `copperWire` | ○ | |
| `currentLoop` | ×→○ | 6.28 cm を楕円下の寸法線の下へ（修正済） |
| `cutSheetCenter` | ○ | |
| `diatomicVessels` | ○ | 球内ラベルは意図的 |
| `dielectricCapacitor` | △ | ハッチ付近 |
| `diffractionGrating` | ○ | |
| `diskHoleCenter` | ○ | 寸法を円の下へ移済 |
| `dopplerWall` | － | 画像のみ |
| `elevatorScale` | △ | 鉛直線付近。要再確認 |
| `evacuatedCylinder` | △ | 寸法と壁が近い |
| `floatingWood` | ○ | |
| `freeFallSpeed` | ○ | |
| `freeFallTime` | ○ | |
| `fujiPressure` | ×→○ | 頂点ゲージを斜面右外・数値を盤上へ（修正済） |
| `geostationarySatellite` | ×→○ | 地球ラベルを円外へ（修正済） |
| `heatDrop` | ×→○ | 水ラベルを寸法矢印の右へ（修正済） |
| `heliumBag` | ×→○ | He を袋の左外へ（修正済） |
| `hint_fixedEndReflection` | ○ | |
| `hint_freeEndReflection` | △ | 波形に近い |
| `horizontalSpringRelease` | － | 画像のみ |
| `inclinePull` | ×→○ | 質量・糸ラベルを斜面外へ（修正済） |
| `invertedColumn` | △ | 壁付近。要再確認 |
| `isobaricGas` | ×→○ | 圧力計数値を盤の下へ・温度を重り上へ（修正済） |
| `isochoricGas` | ×→○ | 圧力計数値を盤の下へ・体積を下へ（修正済） |
| `isothermalGas` | ×→○ | 同上 |
| `keplerOrbits` | ×→○ | 寸法・周期ラベルを線から離し幅拡大（修正済） |
| `kineticFrictionSlide` | － | 画像のみ |
| `longThrow` | ×→○ | 45° を軌道から離した（修正済） |
| `lorentzBar` | △ | 寸法付近。要再確認 |
| `metalInsertCapacitor` | ○ | |
| `moonOrbit` | ×→○ | 地球ラベルを円外へ（修正済） |
| `nailPendulum` | △ | 軌道付近。要再確認 |
| `nichromeWire` | ○ | |
| `openPipe` | ○ | |
| `parallelCapacitors` | ○ | |
| `parallelCurrent` | ○ | |
| `parallelPlateCapacitor` | ○ | |
| `parallelSprings` | ×→○ | k をばねの外へ（修正済） |
| `pendulumBottomSpeed` | ○ | |
| `pendulumBottomTension` | △ | おもり付近 |
| `rcDecay` | － | 画像のみ |
| `resistorCurrent` | ○ | |
| `resonanceColumn` | ○ | |
| `saltWaterPressure` | △ | 寸法付近。要再確認 |
| `seriesCircuit` | ○ | |
| `seriesCurrent` | ○ | |
| `seriesSprings` | ○ | 質量はおもり内（意図的） |
| `simplePendulum` | ×→○ | 2.45 m を紐の外・おもり右へ（修正済） |
| `singleSlit` | － | 画像のみ |
| `slideTipHeight` | ○ | 幅は床下、μは地面右下 |
| `slidingComparison` | ○ | |
| `solenoidCoil` | △ | コイル端付近。要再確認 |
| `soundSpeedColumn` | － | 画像のみ |
| `springPulleys` | ○ | 質量はおもり内 |
| `stackedBlocks` | ○ | 質量はブロック内（意図的） |
| `stairPressure` | ×→○ | ゲージを段から離し数値を盤の横へ（修正済） |
| `staticFrictionHold` | － | 画像のみ |
| `stringFundamental` | △ | おもり付近。要再確認 |
| `sunOrbit` | ×→○ | 太陽ラベルを円の外下へ（修正済） |
| `syringePiston` | △ | 壁付近。要再確認 |
| `tensionCart` | － | 画像のみ |
| `toothbrushString` | △ | おもり枠付近。要再確認 |
| `turntableSpring` | ×→○ | 半径寸法を円の外へ（修正済） |
| `twoSpeakers` | ○ | |
| `underwaterScale` | － | 画像のみ |
| `verticalSpringOscillation` | △ | ばね付近。要再確認 |
| `verticalSpringRelease` | － | 画像のみ |
| `waterDepthPressure` | △ | 寸法付近。要再確認 |

## 再ダンプ

```sh
flutter test tool/dump_figure_review.dart --update-goldens --timeout 30m
# → build/figure_review/*.png
```
