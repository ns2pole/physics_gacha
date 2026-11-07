import '../models/physics_domain.dart';
import '../models/physics_problem.dart';

const noteArticleProblems = <PhysicsProblem>[
  PhysicsProblem(
    id: '12398171-259c-413a-ac28-a86b2cb81ff2',
    theme: 'ドップラー効果（観測者と波源が動く場合）',
    title: '反射音から壁の速さ',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.dopplerWall,
    statement:
        '図のように、静止した音源が 3405 Hz の音を出し、遠ざかる壁で反射した音は 3395 Hz だった。'
        '壁の速さを m/s で答えよ。\n'
        '※音速を 340 m/s とする。音源も観測者も静止している。',
    answerValue: 0.50,
    answerUnit: 'm/s',
    answerDisplay: '0.50',
    unitChoices: [],
    unitObvious: true,
    hint: '壁は、来る音にとっては動く観測者であり、跳ね返すときは動く音源でもある。',
    approach: 'ドップラー効果を、壁へ向かうときと壁から戻るときの2回使う。',
    firstStep: '3395 = 3405 × (340 − u) / (340 + u) である。',
    explanation:
        '静止した観測者へ、速さ u で遠ざかる壁が音を返すとき、'
        '周波数は f\' = f (v − u) / (v + u) になる。'
        '3395 = 3405 × (340 − u) / (340 + u)。'
        '3395 × (340 + u) = 3405 × (340 − u)。'
        'u × (3395 + 3405) = 340 × (3405 − 3395)。'
        'u × 6800 = 340 × 10 = 3400。'
        'u = 3400 / 6800 = 0.50 m/s。',
  ),
  PhysicsProblem(
    id: '0527566c-8c16-4294-a46c-a1acd1030f51',
    theme: '単スリットの暗線',
    title: '単スリットの最初の暗線',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.singleSlit,
    statement:
        '図のように、幅 0.10 mm の単スリットに波長 600 nm の光を垂直に入射し、'
        '0.50 m 先のスクリーンで最初の暗線を見た。'
        '中央の明線からその暗線までの距離を mm で答えよ。\n'
        '※角は小さく、sin θ = tan θ = θ とみなしてよい。',
    answerValue: 3.0,
    answerUnit: 'mm',
    answerDisplay: '3.0',
    unitChoices: [],
    unitObvious: true,
    hint: 'スリットの端と端で、スクリーン上の暗い点までの道の長さが半波長ずれる。',
    approach: '単スリットの最初の暗線は、幅 d と波長 λ で sin θ = λ / d になる。',
    firstStep: 'sin θ = 600×10⁻⁹ / (0.10×10⁻³) である。',
    explanation:
        '単スリットの最初の暗線は sin θ = λ / d である。'
        'd = 0.10×10⁻³ = 1.0×10⁻⁴ m、λ = 600×10⁻⁹ = 6.0×10⁻⁷ m。'
        'sin θ = 6.0×10⁻⁷ / 1.0×10⁻⁴ = 6.0×10⁻³。'
        '角が小さいので θ = 6.0×10⁻³。'
        'スクリーン上の距離は x = L θ = 0.50 × 6.0×10⁻³ = 3.0×10⁻³ m = 3.0 mm。',
  ),
  PhysicsProblem(
    id: '6a8376a3-ce81-44e9-bc20-f12f357ee369',
    theme: '回折格子の光路差と位相',
    title: '回折格子の1次の明線',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.diffractionGrating,
    statement:
        '図のように、格子定数 1.0×10⁻⁶ m の回折格子に波長 600 nm の光を垂直に入射し、'
        '1.0 m 先のスクリーンで1次の明線を見た。'
        '中央の明線からその明線までの距離を cm で答えよ。\n'
        '※π = 3.14 は使わない。sin θ から tan θ を出す。',
    answerValue: 75,
    answerUnit: 'cm',
    answerDisplay: '75',
    unitChoices: [],
    unitObvious: true,
    hint: '隣り合うすき間を通った光の道の差が、波長1つ分のところに明線ができる。',
    approach: '回折格子の1次の明線は d sin θ = λ である。',
    firstStep: '1.0×10⁻⁶ × sin θ = 600×10⁻⁹ である。',
    explanation:
        '回折格子の1次の明線は d sin θ = λ である。'
        'sin θ = 600×10⁻⁹ / 1.0×10⁻⁶ = 0.60。'
        'cos θ = √(1 − 0.60²) = √(1 − 0.36) = √0.64 = 0.80。'
        'tan θ = 0.60 / 0.80 = 0.75。'
        'スクリーン上の距離は x = L tan θ = 1.0 × 0.75 = 0.75 m = 75 cm。',
  ),
  PhysicsProblem(
    id: '66546af1-dd8b-42fd-826e-208119255735',
    theme: '共振する弦の張力',
    title: '共振させるおもりの質量',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.toothbrushString,
    statement:
        '図のように、線密度 1.0×10⁻³ kg/m の弦を 0.50 m 張り、70 Hz で揺らして基本振動させた。'
        '弦の端からつるすおもりの質量を g で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。弦の質量以外は無視できる。',
    answerValue: 500,
    answerUnit: 'g',
    answerDisplay: '500',
    unitChoices: [],
    unitObvious: true,
    hint: '両端が動かない基本振動では、弦の長さが半波長になっている。',
    approach: '両端固定の基本振動は f = (1 / 2L) √(T / ρ) である。',
    firstStep: '70 = (1 / (2 × 0.50)) × √(T / 1.0×10⁻³) である。',
    explanation:
        '両端固定の基本振動は f = (1 / 2L) √(T / ρ) である。'
        'T = 4 ρ f² L²。'
        'f² = 70² = 4900。L² = 0.25。'
        'T = 4 × 1.0×10⁻³ × 4900 × 0.25 = 4.9 N。'
        'おもりの質量は M = T / g = 4.9 / 9.8 = 0.50 kg = 500 g。',
  ),
  PhysicsProblem(
    id: 'a0c33208-8b92-4fb2-8bab-b4b7bb4190d2',
    theme: '弦を伝わる波（両側固定端）',
    title: '糸を弾いた基本振動',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.stringFundamental,
    statement:
        '図のように、線密度 0.40 g/m の糸を 50 cm 張り、200 g のおもりで引いて弾いた。'
        '基本振動の周波数を Hz で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 70,
    answerUnit: 'Hz',
    answerDisplay: '70',
    unitChoices: [],
    unitObvious: true,
    hint: '糸の両端は動かない。いちばん低い音では、糸の長さが半波長になる。',
    approach: '両端固定の基本振動は f = (1 / 2L) √(T / ρ) である。',
    firstStep: 'T = 0.200 × 9.8 である。',
    explanation:
        '両端固定の基本振動は f = (1 / 2L) √(T / ρ) である。'
        'T = 0.200 × 9.8 = 1.96 N。'
        'ρ = 0.40 g/m = 4.0×10⁻⁴ kg/m。L = 0.50 m。'
        'T / ρ = 1.96 / 4.0×10⁻⁴ = 4900。'
        '√(T / ρ) = 70 m/s。'
        'f = 70 / (2 × 0.50) = 70 / 1.0 = 70 Hz。',
  ),
  PhysicsProblem(
    id: '9754d70d-66f6-4c2d-b2fc-2e47ff967a8e',
    theme: '等速円運動の周期',
    title: '円錐振り子の周期',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.conicalPendulum,
    statement:
        '図のように、長さ 2.0 m の糸の先のおもりが、鉛直との角 60° を保って水平にまわっている。'
        '周期を s で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s²、π = 3.14、√(1.0/9.8) = 0.319 とする。',
    answerValue: 2.0,
    answerUnit: 's',
    answerDisplay: '2.0',
    unitChoices: [],
    unitObvious: true,
    hint: '糸の鉛直からの傾きが一定なら、おもりは水平面内を等速でまわっている。',
    approach: '等速円運動の周期は、半径 r と向心加速度から T = 2π √(r / (g tan θ)) になる。',
    firstStep: 'T = 2 × 3.14 × √(2.0 × cos 60° / 9.8) である。',
    explanation:
        '円錐振り子の周期は T = 2π √(L cos θ / g) である。'
        'cos 60° = 1/2。'
        'L cos θ / g = 2.0 × 0.50 / 9.8 = 1.0 / 9.8。'
        '√(L cos θ / g) = 0.319。'
        'T = 6.28 × 0.319 = 2.0 s。',
  ),
  PhysicsProblem(
    id: '385afc33-7632-45e7-b510-6a09360679d3',
    theme: '二つの音源の経路差',
    title: '小さく聞こえる最も低い周波数',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.twoSpeakers,
    statement:
        '図のように、同じ位相で鳴る二つのスピーカーから、ある点までの距離が 2.0 m と 2.5 m である。'
        'その点で弱めあう最も低い周波数を Hz で答えよ。\n'
        '※音速を 340 m/s とする。',
    answerValue: 340,
    answerUnit: 'Hz',
    answerDisplay: '340',
    unitChoices: [],
    unitObvious: true,
    hint: '二つの道の長さの差が、半波長の奇数倍のとき、音は弱くなる。',
    approach: '同位相の二つの音源の最初の弱めあいは、経路差が λ / 2 のときである。',
    firstStep: '2.5 − 2.0 = λ / 2 である。',
    explanation:
        '同位相の二つの音が最初に弱めあう条件は、経路差 Δ = λ / 2 である。'
        'Δ = 2.5 − 2.0 = 0.50 m。'
        'λ = 2 × 0.50 = 1.0 m。'
        'f = v / λ = 340 / 1.0 = 340 Hz。',
  ),
  PhysicsProblem(
    id: 'd2bd1250-0b63-4c72-80cb-836221903063',
    theme: '音速の温度係数',
    title: '音速の温度係数',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.soundSpeedColumn,
    statement:
        '図のように、500 Hz の音叉で閉管を共鳴させると、水面から腹までの長さは '
        '空気の温度 10℃ で 16.0 cm、40℃ で 16.9 cm だった。'
        '温度が 1℃ 上がったときの音速の増え方を m/s で答えよ。\n'
        '※開口端補正は温度によらない。基本振動とする。',
    answerValue: 0.60,
    answerUnit: 'm/s',
    answerDisplay: '0.60',
    unitChoices: [],
    unitObvious: true,
    hint: '閉管の基本振動では、補正を含めた長さが波長の4分の1である。二つの温度の差を見る。',
    approach: '閉管の基本振動は v = 4 f (L + Δ) である。補正 Δ は差をとると消える。',
    firstStep: 'v₂ − v₁ = 4 × 500 × (0.169 − 0.160) である。',
    explanation:
        '閉管の基本振動は v = 4 f (L + Δ) である。'
        '開口端補正 Δ が温度で変わらなければ、v₂ − v₁ = 4 f (L₂ − L₁)。'
        'L₂ − L₁ = 0.169 − 0.160 = 0.0090 m。'
        'v₂ − v₁ = 4 × 500 × 0.0090 = 18 m/s。'
        '温度差は 40 − 10 = 30℃。'
        '1℃ あたりの増え方は 18 / 30 = 0.60 m/s。',
  ),
  PhysicsProblem(
    id: 'c903ff0f-db40-4916-8ed4-5c4a656dc9f1',
    theme: '単振動の力学的エネルギー',
    title: '鉛直ばねが自然長を通る速さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.verticalSpringRelease,
    statement:
        '図のように、ばね定数 29.4 N/m の軽いばねを鉛直につるし、下端に 100 g のおもりをつけて、'
        '自然長から 0.20 m 引き下げて静かに放した。自然長を通るときの速さを m/s で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 2.8,
    answerUnit: 'm/s',
    answerDisplay: '2.8',
    unitChoices: [],
    unitObvious: true,
    hint: '手を放した点と自然長では、ばねのエネルギーと、おもりの高さと速さが入れ替わる。',
    approach: '力学的エネルギー保存を、放した点と自然長のあいだで使う。',
    firstStep: '(1/2) × 29.4 × (0.20)² = (1/2) × 0.100 × v² + 0.100 × 9.8 × 0.20 である。',
    explanation:
        '力学的エネルギーは保存する。自然長を高さの基準にすると、'
        '放した点では (1/2) k x² − m g x、自然長では (1/2) m v² である。'
        '(1/2) × 29.4 × 0.040 = 0.588。'
        'm g x = 0.100 × 9.8 × 0.20 = 0.196。'
        '(1/2) m v² = 0.588 − 0.196 = 0.392。'
        'v² = 0.784 / 0.100 = 7.84。'
        'v = 2.8 m/s。',
  ),
  PhysicsProblem(
    id: '7da18bc0-3810-4a32-8930-0e17ba16efce',
    theme: '仕事とエネルギー',
    title: '台上の物体の速さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.tensionCart,
    statement:
        '図のように、滑らかな台上の 200 g の物体と、滑車を通した 200 g のおもりをつなぎ、'
        '静かに放して 0.80 m 進んだ。台上の物体の速さを m/s で答えよ。\n'
        '※台は固定されており、重力加速度の大きさを 9.8 m/s² とする。糸も滑車も軽く、摩擦はない。',
    answerValue: 2.8,
    answerUnit: 'm/s',
    answerDisplay: '2.8',
    unitChoices: [],
    unitObvious: true,
    hint: '動くあいだに仕事をするのは、下がるおもりに働く重力だけである。',
    approach: '仕事とエネルギーの関係を、二つの物体をまとめて使う。',
    firstStep: '0.200 × 9.8 × 0.80 = (1/2) × (0.200 + 0.200) × v² である。',
    explanation:
        '重力がおもりにした仕事は、二つの物体の運動エネルギーになる。'
        'W = 0.200 × 9.8 × 0.80 = 1.568 J。'
        '(1/2) × 0.400 × v² = 1.568。'
        '0.200 × v² = 1.568。'
        'v² = 7.84。'
        'v = 2.8 m/s。',
  ),
  PhysicsProblem(
    id: '19776c8b-24cd-4aaf-95ab-5a5097ed7055',
    theme: 'ばねの弾性エネルギー',
    title: '水平なばねを放した速さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.horizontalSpringRelease,
    statement:
        '図のように、滑らかな水平面上で、ばね定数 4.0 N/m の軽いばねを 0.30 m 縮め、'
        '40 g の物体を静かに放した。ばねが自然長に戻ったときの速さを m/s で答えよ。\n'
        '※台は固定されている。',
    answerValue: 3.0,
    answerUnit: 'm/s',
    answerDisplay: '3.0',
    unitChoices: [],
    unitObvious: true,
    hint: '水平で摩擦がないので、速さが変わる原因はばねの縮みだけである。',
    approach: 'ばねの弾性エネルギーが、物体の運動エネルギーに変わる。',
    firstStep: '(1/2) × 4.0 × (0.30)² = (1/2) × 0.040 × v² である。',
    explanation:
        '弾性エネルギーは (1/2) k x²、運動エネルギーは (1/2) m v² である。'
        '(1/2) × 4.0 × 0.090 = (1/2) × 0.040 × v²。'
        '0.180 = 0.020 v²。'
        'v² = 9.0。'
        'v = 3.0 m/s。',
  ),
  PhysicsProblem(
    id: '80b5bc83-b93e-402a-b658-be4cc879795a',
    theme: '振り子の最下点の速さ',
    title: '振り子の最下点の速さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.pendulumBottomSpeed,
    statement:
        '図のように、長さ 0.20 m の振り子を鉛直から 60° まで上げて静かに放した。'
        '最下点の速さを m/s で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。糸の質量と摩擦は無視できる。',
    answerValue: 1.4,
    answerUnit: 'm/s',
    answerDisplay: '1.4',
    unitChoices: [],
    unitObvious: true,
    hint: '糸はおもりの運動に垂直なので、仕事をしない。高さが速さに変わる。',
    approach: '力学的エネルギー保存を、放した点と最下点のあいだで使う。',
    firstStep: '0.20 × (1 − cos 60°) × 9.8 = (1/2) v² である。',
    explanation:
        '力学的エネルギーは保存する。最下点を高さの基準にすると、'
        '放した点の高さは L (1 − cos 60°) である。'
        'cos 60° = 1/2。高さは 0.20 × 0.50 = 0.10 m。'
        'm g h = (1/2) m v² なので v² = 2 × 9.8 × 0.10 = 1.96。'
        'v = 1.4 m/s。',
  ),
  PhysicsProblem(
    id: 'd09b53dc-125f-4a38-8908-9911d635cb8e',
    theme: '力のモーメントのつり合い',
    title: 'ブロックの端を持ち上げる力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.blockEndLift,
    statement:
        '図のように、質量 200 g の一様なブロックの一端を床につけたまま、'
        'もう一端を鉛直に持ち上げて静止させた。持ち上げる力の大きさを N で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 0.98,
    answerUnit: 'N',
    answerDisplay: '0.98',
    unitChoices: [],
    unitObvious: true,
    hint: '床につけた端を軸にすると、その端の力はモーメントを持たない。',
    approach: '力のモーメントのつり合いを、床につけた端のまわりで使う。',
    firstStep: 'F × L = 0.200 × 9.8 × (L / 2) である。',
    explanation:
        '床側の端のまわりで、モーメントはつり合う。'
        '重力は中央に働き、持ち上げる力は反対の端に働く。'
        'F L = m g (L / 2)。'
        'F = m g / 2 = 0.200 × 9.8 / 2 = 1.96 / 2 = 0.98 N。',
  ),
  PhysicsProblem(
    id: 'b5640d96-7b77-4993-ac9a-b8969461b744',
    theme: '重心の定義 [m]',
    title: 'くり抜いた円盤の重心',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.diskHoleCenter,
    statement:
        '図のように、半径 10.2 cm の一様な円盤から、半径がその半分の円をくり抜いた。'
        '穴の中心は、もとの円の中心から半径の半分だけずれている。'
        '残った板の重心は、もとの中心から穴と反対側へ何 cm ずれるか。',
    answerValue: 1.7,
    answerUnit: 'cm',
    answerDisplay: '1.7',
    unitChoices: [],
    unitObvious: true,
    hint: 'もとの円盤は、残った板とくり抜いた円を合わせたものだと見る。',
    approach: '重心の定義を、もとの円盤・残った板・くり抜いた円で使う。',
    firstStep: '3x/4 + (−5.1) × (1/4) = 0 である。',
    explanation:
        '重心は、質量で重みをつけた位置の平均である。'
        'もとの円盤は、残った板とくり抜いた円を合わせたものなので、'
        'その重心はもとの中心にある。'
        'もとの中心を原点、穴と反対向き（左向き）を正とすると、'
        '穴の中心は −5.1 cm である。'
        '穴の面積はもとの 1/4 なので、質量の比は残った板 : 穴 = 3 : 1。'
        '残った板の重心を x とすると、3x/4 + (−5.1) × (1/4) = 0。'
        '3x/4 = 5.1/4。x = 5.1/3 = 1.7 cm。',
  ),
  PhysicsProblem(
    id: 'e5bc3b07-2a24-49d0-9cf3-f6e03c9b6c8f',
    theme: '切り取った板の重心',
    title: '切り抜いた下敷きの横位置',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.cutSheetCenter,
    explanationFigure: ProblemFigure.cutSheetExplain,
    statement:
        '図のように、横 24 cm、縦 16 cm の一様な長方形から、'
        '右上の横 12 cm、縦 8.0 cm を切り抜いた。'
        '残った板の重心の、左端からの距離を cm で答えよ。',
    answerValue: 10,
    answerUnit: 'cm',
    answerDisplay: '10',
    unitChoices: [],
    unitObvious: true,
    hint: '残った板を、左半分と右下の二つの長方形に分ける。',
    approach: '重心の定義を、分けた二つの領域の面積の重みで使う。',
    firstStep: '(2/3) × 6 + (1/3) × 18 = 10 である。',
    explanation:
        '左端を x = 0 とする。残った板は、左半分（横 12 cm・縦 16 cm）と、'
        '右下（横 12 cm・縦 8.0 cm）に分けられる。'
        '面積の比は 192 : 96 = 2 : 1 なので、重みは 2/3 と 1/3 である。'
        '左半分の重心は x = 12/2 = 6 cm。'
        '右下の重心は x = 12 + 12/2 = 18 cm。'
        '残った板の重心は (2/3) × 6 + (1/3) × 18 = 4 + 6 = 10 cm。',
  ),
  PhysicsProblem(
    id: 'fccf9e77-372c-4c34-b17d-9cafc2d339b5',
    theme: '滑りと傾きの境',
    title: '滑るか傾くかの境の高さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.slideTipHeight,
    statement:
        '図のように、幅 6.0 cm の一様なブロックを水平な床の上に置き、側面を水平に押す。'
        '動摩擦係数は 0.20 で、最大静止摩擦係数も同じとする。'
        '押す位置がこの高さより上なら傾き、下なら滑る。境の高さを cm で答えよ。',
    answerValue: 15,
    answerUnit: 'cm',
    answerDisplay: '15',
    unitChoices: [],
    unitObvious: true,
    hint: '滑り出す直前は、床の摩擦力が最大静止摩擦に等しい。下の端を軸にすると傾き始める。',
    approach: '滑る条件は最大静止摩擦、傾く条件は下端のまわりのモーメントのつり合いである。',
    firstStep: 'h = 6.0 / (2 × 0.20) である。',
    explanation:
        '滑り出す力は F = μ m g。'
        '下端のまわりで、この力のモーメント F h が、重力のモーメント m g (b / 2) とつり合う高さが境である。'
        'μ m g h = m g (b / 2)。'
        'h = b / (2μ) = 6.0 / (2 × 0.20) = 6.0 / 0.40 = 15 cm。',
  ),
  PhysicsProblem(
    id: 'b7c1e735-bbda-461c-a72e-eff2609a5ab1',
    theme: '浮力（アルキメデスの原理）',
    title: '食塩水に沈む長さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.floatingWood,
    statement:
        '図のように、長さ 20 cm、質量 31.4 g、半径 1.0 cm の一様な円柱を、'
        '密度 1.25 g/cm³ の食塩水に鉛直に浮かべた。液面の下に沈む長さを cm で答えよ。\n'
        '※π = 3.14 とする。',
    answerValue: 8.0,
    answerUnit: 'cm',
    answerDisplay: '8.0',
    unitChoices: [],
    unitObvious: true,
    hint: '浮かんで静止しているので、円柱の重さと、沈んだ部分が押しのける食塩水の重さが等しい。',
    approach: '浮力は、押しのけた流体の重さに等しい。',
    firstStep: '31.4 = 1.25 × (3.14 × 1.0² × l) である。',
    explanation:
        '浮かんで静止するとき、質量は押しのけた食塩水の質量に等しい。'
        '断面積は π r² = 3.14 × 1.0 = 3.14 cm²。'
        '31.4 = 1.25 × 3.14 × l。'
        '3.925 × l = 31.4。'
        'l = 31.4 / 3.925 = 8.0 cm。',
  ),
  PhysicsProblem(
    id: '760c69d1-1a7e-41f8-b18f-8b7ac39735a4',
    theme: '地上の重力加速度 [m/s^2]',
    title: '地球半径だけ離れた点の重力加速度',
    domains: {PhysicsDomain.mechanics},
    statement:
        '地球を半径 6.4×10⁶ m の球とする。地表から地球の半径だけ離れた点での'
        '重力加速度の大きさを m/s² で答えよ。\n'
        '※地表での重力加速度の大きさを 9.8 m/s² とする。地球の自転は考えない。',
    answerValue: 2.45,
    answerUnit: 'm/s^2',
    answerDisplay: '2.45',
    unitChoices: [],
    unitObvious: true,
    hint: '地表から離れると、地球の中心からの距離が半径より長くなる。',
    approach: '地表の重力加速度は g = GM / R² で、高さ h では距離が R + h になる。',
    firstStep: 'g\' = 9.8 × (6.4×10⁶)² / (6.4×10⁶ + 6.4×10⁶)² である。',
    explanation:
        '重力加速度は中心からの距離の2乗に反比例する。'
        'g\' = g / (1 + h / R)²。'
        'h = R なので 1 + h / R = 2。'
        '(1 + h / R)² = 4。'
        'g\' = 9.8 / 4 = 2.45 m/s²。',
  ),
  PhysicsProblem(
    id: '3161b116-b09a-4d0b-b92d-44cd0d46a4a4',
    theme: '動摩擦力',
    title: '動摩擦係数',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.kineticFrictionSlide,
    statement:
        '図のように、400 g の物体を糸でばねはかりにつなぎ、水平な床の上を一定の速さで引いた。'
        'ばねはかりの読みは 0.98 N だった。動摩擦係数を答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 0.25,
    answerUnit: '1',
    answerDisplay: '0.25',
    unitChoices: [],
    unitObvious: true,
    hint: '一定の速さなので、水平方向では引く力と動摩擦力がつり合っている。',
    approach: '動摩擦力は f = μ N で、水平な床では垂直抗力が重さに等しい。',
    firstStep: '0.98 = μ × 0.400 × 9.8 である。',
    explanation:
        '一定の速さなので、引く力と動摩擦力はつり合う。'
        'f = μ m g。'
        'μ = 0.98 / (0.400 × 9.8) = 0.98 / 3.92 = 0.25。',
  ),
  PhysicsProblem(
    id: 'b29b25dc-cde4-4e27-ade8-bfb66af29ad3',
    theme: '最大静止摩擦力',
    title: '静止摩擦係数',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.staticFrictionHold,
    statement:
        '図のように、水平な床の上の 400 g の物体を糸でばねはかりにつなぎ、水平にゆっくり引いた。'
        '動き出す瞬間の読みは 1.96 N だった。静止摩擦係数を答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 0.50,
    answerUnit: '1',
    answerDisplay: '0.50',
    unitChoices: [],
    unitObvious: true,
    hint: '動き出す瞬間は、引く力が最大静止摩擦力に達している。',
    approach: '最大静止摩擦力は f = μ N で、水平な床では垂直抗力が重さに等しい。',
    firstStep: '1.96 = μ × 0.400 × 9.8 である。',
    explanation:
        '動き出す瞬間の力は、最大静止摩擦力に等しい。'
        'f = μ m g。'
        'μ = 1.96 / (0.400 × 9.8) = 1.96 / 3.92 = 0.50。',
  ),
  PhysicsProblem(
    id: 'b775e759-f47a-40ad-9506-762bd7e1b158',
    theme: '遠心力',
    title: '回転台のばねの読み',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.turntableSpring,
    statement:
        '図のように、回転台の中心から 0.20 m の位置に、100 g のおもりをばねでつなぎ、'
        '台といっしょに周期 0.628 s でまわした。おもりは台の上で静止している。'
        'ばねの読みを N で答えよ。\n'
        '※π = 3.14 とする。台の上でおもりは動かない。',
    answerValue: 2.0,
    answerUnit: 'N',
    answerDisplay: '2.0',
    unitChoices: [],
    unitObvious: true,
    hint: '台といっしょにまわる人から見ると、おもりは止まっていて、外向きの力とばねがつり合う。',
    approach: '遠心力は m ω² r で、回転台に対して静止しているときはばねの力とつり合う。',
    firstStep: 'F = 0.100 × (2 × 3.14 / 0.628)² × 0.20 である。',
    explanation:
        '遠心力は F = m ω² r である。'
        'ω = 2π / T = 6.28 / 0.628 = 10 rad/s。'
        'ω² = 100。'
        'F = 0.100 × 100 × 0.20 = 2.0 N。',
  ),
  PhysicsProblem(
    id: '04aa630e-a4c3-46ee-918c-531536db9665',
    theme: '加速系で現れる慣性力',
    title: '上昇するエレベーターのばねの読み',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.elevatorScale,
    statement:
        '図のように、上向きに 1.0 m/s² で加速するエレベーターの中で、'
        '200 g のおもりをばねはかりにつるした。ばねはかりの読みを N で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 2.16,
    answerUnit: 'N',
    answerDisplay: '2.16',
    unitChoices: [],
    unitObvious: true,
    hint: 'エレベーターの中では、おもりは止まって見える。上に加速しているぶん、下向きの力が増える。',
    approach: '加速する箱の中では、慣性力 −m a が現れる。',
    firstStep: 'F − 0.200 × 9.8 − 0.200 × 1.0 = 0 である。',
    explanation:
        'エレベーターとともに上向きの加速度 a で動く系では、下向きに慣性力 m a が働く。'
        'おもりは静止して見えるので、ばねの力は重さと慣性力の和になる。'
        'F = m (g + a) = 0.200 × (9.8 + 1.0) = 0.200 × 10.8 = 2.16 N。',
  ),
  PhysicsProblem(
    id: 'dc2ea26c-266e-4441-96b7-a9a514e3b799',
    theme: '地上重力による位置エネルギー',
    title: '釘の向こうで上がる高さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.nailPendulum,
    statement:
        '図のように、振り子を最下点より 12 cm 高い位置から静かに放した。'
        '最下点の真下ではない位置に釘があり、糸は途中から釘にかかる。'
        '釘にかかったあと、おもりが最下点から上がる高さを cm で答えよ。\n'
        '※糸はたるまず、釘はエネルギーを奪わない。',
    answerValue: 12,
    answerUnit: 'cm',
    answerDisplay: '12',
    unitChoices: [],
    unitObvious: true,
    hint: '釘は糸の向きを変えるだけで、おもりの速さに沿った力を加えない。',
    approach: '地上重力による位置エネルギーと運動エネルギーの和は保存する。',
    firstStep: 'm g h = m g h\' である。',
    explanation:
        '釘が仕事をしないので、力学的エネルギーは保存する。'
        '放した点では速さは 0 で、高さは最下点から 12 cm である。'
        '反対側で速さが再び 0 になる高さを h\' とすると、m g × 12 = m g h\'。'
        'h\' = 12 cm。',
  ),
  PhysicsProblem(
    id: '264dc236-782b-4ba0-9d39-13c94f7ea889',
    theme: '水中で減る張力',
    title: '飽和食塩水中で減るばねはかりの読み',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.underwaterScale,
    statement:
        '図のように、質量 100 g、体積 40 cm³ の物体をばねはかりにつるし、飽和食塩水へ沈めた。'
        'ばねはかりの読みは、空気中より何 g 減るか。\n'
        '※飽和食塩水の密度を 1.20 g/cm³ とする。物体はすべて液中にあり、空気の浮力は無視する。',
    answerValue: 48,
    answerUnit: 'g',
    answerDisplay: '48',
    unitChoices: [],
    unitObvious: true,
    hint: '液中では、物体が押しのけた飽和食塩水の重さだけ上向きの力が加わる。',
    approach: '浮力は押しのけた飽和食塩水の重さに等しく、ばねの読みはその分だけ減る。',
    firstStep: 'Δm = 1.20 × 40 である。',
    explanation:
        '浮力は、押しのけた飽和食塩水の重さに等しい。'
        '押しのけた飽和食塩水の質量は 1.20 × 40 = 48 g。'
        'ばねの読みの減りは、この質量に相当する 48 g である。',
  ),
  PhysicsProblem(
    id: 'fb52940c-6b53-4c80-a4a3-639e2aa650ef',
    theme: '振り子の最下点の張力',
    title: '振り子の最下点の張力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.pendulumBottomTension,
    statement:
        '図のように、100 g のおもりを鉛直から 60° まで上げて静かに放した。'
        '最下点での糸の張力を N で答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。糸の質量と摩擦は無視できる。',
    answerValue: 1.96,
    answerUnit: 'N',
    answerDisplay: '1.96',
    unitChoices: [],
    unitObvious: true,
    hint: '最下点では、張力と重さの差が、円運動の向心力になっている。',
    approach: '力学的エネルギー保存で速さを出し、最下点の運動方程式で張力を出す。',
    firstStep: 'T − 0.100 × 9.8 = 0.100 × v² / L である。',
    explanation:
        '最下点を高さの基準にすると、放した点の高さは L (1 − cos 60°) = L / 2。'
        'v² = 2 g (L / 2) = g L。'
        '最下点では、上向きを正として T − m g = m v² / L。'
        'm v² / L = m g。'
        'T = 2 m g = 2 × 0.100 × 9.8 = 1.96 N。',
  ),
  PhysicsProblem(
    id: 'a9200667-eb7b-4eb0-8b3b-ecf7e4adfc0b',
    theme: '流体中の圧力',
    title: '1階と2階の気圧差',
    domains: {PhysicsDomain.mechanics},
    statement:
        '1階と2階の高さの差は 5.0 m である。気圧の差を hPa で答えよ。\n'
        '※空気の密度を 1.0 kg/m³、重力加速度の大きさを 9.8 m/s² とする。'
        'この高さのあいだで密度は一定とみなす。',
    answerValue: 0.49,
    answerUnit: 'hPa',
    answerDisplay: '0.49',
    unitChoices: [],
    unitObvious: true,
    hint: '高さの差が小さいので、間の空気を密度一定の流体として見る。',
    approach: '密度一定の流体では、高さの差 Δh による圧力差は ρ g Δh である。',
    firstStep: 'Δp = 1.0 × 9.8 × 5.0 である。',
    explanation:
        '密度一定の流体の圧力差は Δp = ρ g Δh である。'
        'Δp = 1.0 × 9.8 × 5.0 = 49 Pa。'
        '1 hPa = 100 Pa なので、49 Pa = 0.49 hPa。',
  ),
  PhysicsProblem(
    id: '5c3c97ec-01f2-4eb6-a717-6099182aa327',
    theme: '高さによる気圧',
    title: '富士山頂の気圧',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.fujiPressure,
    statement:
        '図のように、標高 0 m で気圧 1013 hPa、気温 15℃ とする。'
        '気温は高さとともに一定の割合で下がり、空気を理想気体とみなす。'
        '標高 3000 m の気圧を hPa で答えよ。\n'
        '※0℃ を 273 K、空気のモル質量を 29 g/mol、'
        '重力加速度の大きさを 9.8 m/s²、気体定数を 8.31 J/(mol·K) とする。'
        '(T / T₀)^(M g / (k R)) = 0.80 として計算してよい。',
    answerValue: 810.4,
    answerUnit: 'hPa',
    answerDisplay: '810.4',
    unitChoices: [],
    unitObvious: true,
    hint: '上へ行くほど気温が下がり、同じ厚さの空気の重さも変わる。地表の気圧に、温度の比の累乗をかける。',
    approach: '気温が一定の割合で下がるとき、気圧は p = p₀ (T / T₀)^(M g / (k R)) である。',
    firstStep: 'p = 1013 × 0.80 である。',
    explanation:
        '気温が高さとともに一定の割合 k で下がるとき、'
        'p = p₀ (T / T₀)^(M g / (k R)) である。'
        '※より (T / T₀)^(M g / (k R)) = 0.80。'
        'p = 1013 × 0.80 = 810.4 hPa。',
  ),
  PhysicsProblem(
    id: '6ede92dc-5a1f-45dd-8bd5-aad99c9ea5da',
    theme: '圧力の定義 [Pa]',
    title: '注射器を引く力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.syringePiston,
    statement:
        '図のように、半径 1.0 cm の注射器のピストンを、中を真空に近いところまで引く。'
        '外の気圧がピストンを押す力の大きさを N で答えよ。\n'
        '※気圧を 1.0×10⁵ Pa、π = 3.14 とする。',
    answerValue: 31.4,
    answerUnit: 'N',
    answerDisplay: '31.4',
    unitChoices: [],
    unitObvious: true,
    hint: 'ピストンの内側に押す空気がなければ、外の気圧が面を押す力だけが残る。',
    approach: '圧力の定義 p = F / S から、力は F = p S である。',
    firstStep: 'F = 1.0×10⁵ × 3.14 × (1.0×10⁻²)² である。',
    explanation:
        '力は F = p S である。'
        '半径は 1.0×10⁻² m。S = π r² = 3.14 × 1.0×10⁻⁴ = 3.14×10⁻⁴ m²。'
        'F = 1.0×10⁵ × 3.14×10⁻⁴ = 31.4 N。',
  ),
  PhysicsProblem(
    id: 'b2264701-1475-4352-a05d-e5271f77caff',
    theme: '開いた水面下の圧力',
    title: '水深 50 cm の圧力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.waterDepthPressure,
    statement:
        '図のように、大気に開いた水面から 50 cm の深さの圧力を hPa で答えよ。\n'
        '※水面の気圧を 1013 hPa、水の密度を 1000 kg/m³、'
        '重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 1062,
    answerUnit: 'hPa',
    answerDisplay: '1062',
    unitChoices: [],
    unitObvious: true,
    hint: '開いた水面の下では、大気の圧力に、その深さの水の重さによる圧力が加わる。',
    approach: '開いた水面下の圧力は p = p₀ + ρ g h である。',
    firstStep: 'p = 1013 + 1000 × 9.8 × 0.50 / 100 である。',
    explanation:
        '開いた水面下の圧力は p = p₀ + ρ g h である。'
        'ρ g h = 1000 × 9.8 × 0.50 = 4900 Pa = 49 hPa。'
        'p = 1013 + 49 = 1062 hPa。',
  ),
  PhysicsProblem(
    id: 'cc8cd992-df30-4283-b758-2c7bba07336a',
    theme: '閉じた水柱の上端の圧力',
    title: '逆さ容器の上端の圧力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.invertedColumn,
    statement:
        '図のように、水を満たして逆さにした容器の口は、開いた水面より 3.0 cm 下にあり、'
        '容器の中の水面は口より 28 cm 上にある。閉じた上端の圧力を hPa で答えよ。\n'
        '※開いた水面の気圧を 1013 hPa、水の密度を 1000 kg/m³、'
        '重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 988.5,
    answerUnit: 'hPa',
    answerDisplay: '988.5',
    unitChoices: [],
    unitObvious: true,
    hint: '口は開いた水の中にある。閉じた上端は、その口より高いところにある。',
    approach: '同じ水の中で高さが上がると、圧力は ρ g h だけ下がる。',
    firstStep: 'p = 1013 − 1000 × 9.8 × 0.25 / 100 である。',
    explanation:
        '閉じた上端は、開いた水面より 28 − 3.0 = 25 cm 高い。'
        '圧力は p = p₀ − ρ g h である。'
        'ρ g h = 1000 × 9.8 × 0.25 = 2450 Pa = 24.5 hPa。'
        'p = 1013 − 24.5 = 988.5 hPa。',
  ),
  PhysicsProblem(
    id: 'ebf0977f-94f9-4e30-8415-95fe3b05b3c2',
    theme: '食塩水中の圧力',
    title: '食塩水 50 cm の圧力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.saltWaterPressure,
    statement:
        '図のように、大気に開いた食塩水の水面から 50 cm の深さの圧力を hPa で答えよ。\n'
        '※水面の気圧を 1013 hPa、食塩水の密度を 1.20 g/cm³、'
        '重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 1071.8,
    answerUnit: 'hPa',
    answerDisplay: '1071.8',
    unitChoices: [],
    unitObvious: true,
    hint: '食塩水は水より密度が大きい。深さの圧力は、その密度で水の重さを見る。',
    approach: '開いた液面の下の圧力は p = p₀ + ρ g h である。',
    firstStep: 'p = 1013 + 1200 × 9.8 × 0.50 / 100 である。',
    explanation:
        '開いた液面の下の圧力は p = p₀ + ρ g h である。'
        '密度は 1.20 g/cm³ = 1200 kg/m³。'
        'ρ g h = 1200 × 9.8 × 0.50 = 5880 Pa = 58.8 hPa。'
        'p = 1013 + 58.8 = 1071.8 hPa。',
  ),
  PhysicsProblem(
    id: '185ad466-4a2a-474a-97d8-e2635c9da116',
    theme: 'ヘリウムが持ち上げる質量',
    title: 'ヘリウム袋が持ち上げる質量',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.heliumBag,
    statement:
        '図のように、質量 1.0 g の袋に、27℃、1.0×10⁵ Pa のヘリウムを 2.493 L 入れた。'
        'この袋が、自分の質量のほかに持ち上げられる質量を g で答えよ。\n'
        '※空気とヘリウムを理想気体とし、モル質量を 29 g/mol と 4.0 g/mol、'
        '気体定数を 8.31 J/(mol·K) とする。'
        '袋の体積は中の気体の体積に等しい。',
    answerValue: 1.5,
    answerUnit: 'g',
    answerDisplay: '1.5',
    unitChoices: [],
    unitObvious: true,
    hint: '袋が押しのける空気の重さから、中のヘリウムの重さと袋の重さを引いた分が、余って持ち上げられる。',
    approach: '浮力は押しのけた空気の重さである。物質量は理想気体の状態方程式で出す。',
    firstStep: '1.0×10⁵ × 2.493×10⁻³ = n × 8.31 × 300 である。',
    explanation:
        '理想気体の状態方程式は p V = n R T である。'
        'T = 27 + 273 = 300 K。'
        'n = 1.0×10⁵ × 2.493×10⁻³ / (8.31 × 300)。'
        '8.31 × 300 = 2493。'
        'p V = 249.3。'
        'n = 249.3 / 2493 = 0.100 mol。'
        '空気の質量は 0.100 × 29 = 2.9 g。'
        'ヘリウムの質量は 0.100 × 4.0 = 0.40 g。'
        '持ち上げられる質量は 2.9 − 0.40 − 1.0 = 1.5 g。',
  ),
  PhysicsProblem(
    id: '6302cba4-20d1-418d-bcd4-8bc9139112ef',
    theme: '導体の電気抵抗',
    title: 'ニクロム線 0.785 m の抵抗',
    domains: {PhysicsDomain.electromagnetism},
    statement:
        '直径 0.50 mm、長さ 0.785 m のニクロム線の抵抗を Ω で答えよ。\n'
        '※抵抗率を 1.0×10⁻⁶ Ω·m、π = 3.14 とする。',
    answerValue: 4.0,
    answerUnit: 'Ω',
    answerDisplay: '4.0',
    unitChoices: [],
    unitObvious: true,
    hint: '同じ材料でも、細く長いほど抵抗は大きくなる。断面は円である。',
    approach: '導体の電気抵抗は R = ρ L / S である。',
    firstStep: 'R = 1.0×10⁻⁶ × 0.785 / (3.14 × (0.25×10⁻³)²) である。',
    explanation:
        '導体の電気抵抗は R = ρ L / S である。'
        '半径は 0.25×10⁻³ m。'
        'S = 3.14 × (0.25×10⁻³)² = 3.14 × 6.25×10⁻⁸ = 1.9625×10⁻⁷ m²。'
        'ρ L = 1.0×10⁻⁶ × 0.785 = 7.85×10⁻⁷。'
        'R = 7.85×10⁻⁷ / 1.9625×10⁻⁷ = 4.0 Ω。',
  ),
  PhysicsProblem(
    id: '3ea78b46-ce98-4631-8e40-d6adaffd4c92',
    theme: '抵抗率の温度依存性',
    title: '50℃の銅線の抵抗',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.copperWire,
    statement:
        '図のように、断面積 1.0×10⁻⁸ m²、長さ 10 m の銅線の、50℃ での抵抗を Ω で答えよ。\n'
        '※0℃ の抵抗率を 1.0×10⁻⁸ Ω·m、温度係数を 0.0040 /℃ とする。',
    answerValue: 12.0,
    answerUnit: 'Ω',
    answerDisplay: '12.0',
    unitChoices: [],
    unitObvious: true,
    hint: '金属は温めると抵抗率が上がる。まず 50℃ の抵抗率にしてから、長さと断面積で抵抗にする。',
    approach: '抵抗率は ρ = ρ₀ (1 + α t) で、抵抗は R = ρ L / S である。',
    firstStep: 'ρ = 1.0×10⁻⁸ × (1 + 0.0040 × 50) である。',
    explanation:
        '抵抗率は ρ = ρ₀ (1 + α t) である。'
        'ρ = 1.0×10⁻⁸ × (1 + 0.20) = 1.0×10⁻⁸ × 1.20 = 1.20×10⁻⁸ Ω·m。'
        'R = 1.20×10⁻⁸ × 10 / 1.0×10⁻⁸ = 1.20×10⁻⁷ / 1.0×10⁻⁸ = 12.0 Ω。',
  ),
  PhysicsProblem(
    id: 'fec7eb08-b848-4ce9-86f1-bfcf489ed905',
    theme: '円形電流が作る軸上の磁場',
    title: '円形コイル中心の磁場',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.currentLoop,
    statement:
        '図のように、半径 6.28 cm の円形コイルを 100 回巻き、1.0 A の電流を流した。'
        '中心の磁束密度の大きさを mT で答えよ。\n'
        '※真空の透磁率を 4π×10⁻⁷ H/m、π = 3.14 とする。',
    answerValue: 1.0,
    answerUnit: 'mT',
    answerDisplay: '1.0',
    unitChoices: [],
    unitObvious: true,
    hint: '円い導線の中心では、どの部分が作る磁場も同じ向きに重なる。巻き数だけ倍になる。',
    approach: '円形電流が中心に作る磁束密度は B = μ₀ N I / (2 r) である。',
    firstStep: 'B = (4 × 3.14 × 10⁻⁷ × 100 × 1.0) / (2 × 0.0628) である。',
    explanation:
        '円形電流が中心に作る磁束密度は B = μ₀ N I / (2 r) である。'
        'μ₀ = 4 × 3.14 × 10⁻⁷ = 1.256×10⁻⁶ H/m。'
        '分子は 1.256×10⁻⁶ × 100 × 1.0 = 1.256×10⁻⁴。'
        '分母は 2 × 0.0628 = 0.1256。'
        'B = 1.256×10⁻⁴ / 0.1256 = 1.0×10⁻³ T = 1.0 mT。',
  ),
  PhysicsProblem(
    id: '4f720ff4-0c1b-47ff-baa6-70195e82f7bb',
    theme: 'RC回路の方程式の解',
    title: '抵抗の電圧が半分になる時刻',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.rcDecay,
    statement:
        '図のように、3.0 V に充電した 5000 μF のコンデンサーを、2000 Ω の抵抗で放電する。'
        '抵抗にかかる電圧が 1.5 V になる時刻を s で答えよ。\n'
        '※ln 2 = 0.693 とする。放電開始を t = 0 とする。',
    answerValue: 6.93,
    answerUnit: 's',
    answerDisplay: '6.93',
    unitChoices: [],
    unitObvious: true,
    hint: '放電では、抵抗の電圧は最初の電圧から、ある時間の定数で減っていく。半分は特別な割合である。',
    approach: 'RC 放電の解は V = V₀ e^(−t / RC) である。',
    firstStep: '1.5 = 3.0 × e^(−t / (2000 × 5000×10⁻⁶)) である。',
    explanation:
        'RC 放電の電圧は V = V₀ e^(−t / RC) である。'
        'V = V₀ / 2 のとき、t = RC ln 2。'
        'C = 5000×10⁻⁶ = 5.0×10⁻³ F。'
        'RC = 2000 × 5.0×10⁻³ = 10 s。'
        't = 10 × 0.693 = 6.93 s。',
  ),
  PhysicsProblem(
    id: '8b3abed0-2226-49ed-9b04-7c3d63852077',
    theme: 'ソレノイドコイルの自己インダクタンス',
    title: 'ソレノイドの自己インダクタンス',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.solenoidCoil,
    statement:
        '図のように、長さ 0.314 m の筒に導線を 100 回巻く。'
        '筒の半径は 1.0 cm である。自己インダクタンスを μH で答えよ。\n'
        '※真空の透磁率を 1.256×10⁻⁶ H/m、π = 3.14 とする。',
    answerValue: 12.56,
    answerUnit: 'μH',
    answerDisplay: '12.56',
    unitChoices: [],
    unitObvious: true,
    hint: '長いコイルの中の磁場は、単位長さあたりの巻き数と電流で決まる。インダクタンスは、その磁束が電流に比例する係数である。',
    approach: 'ソレノイドの自己インダクタンスは L = μ₀ n² S ℓ である。',
    firstStep: 'L = 1.256×10⁻⁶ × (100 / 0.314)² × 3.14 × (1.0×10⁻²)² × 0.314 である。',
    explanation:
        'ソレノイドの自己インダクタンスは L = μ₀ N² S / ℓ である。'
        'S = 3.14 × (1.0×10⁻²)² = 3.14 × 1.0×10⁻⁴ = 3.14×10⁻⁴ m²。'
        'N² S / ℓ = 10000 × 3.14×10⁻⁴ / 0.314 = 3.14 / 0.314 = 10。'
        'L = 1.256×10⁻⁶ × 10 = 1.256×10⁻⁵ H = 12.56 μH。',
  ),
  PhysicsProblem(
    id: 'cbde552e-65b9-4102-a827-92de2ea4d513',
    theme: '電流が磁場から受ける力',
    title: 'アルミ棒が受ける力',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.lorentzBar,
    statement:
        '図のように、磁束密度 0.20 T の一様な磁場に垂直な、長さ 2.0 cm のアルミ棒に、'
        '1.0 A の電流を磁場とも棒とも垂直に流す。棒が受ける力の大きさを N で答えよ。',
    answerValue: 4.0e-3,
    answerUnit: 'N',
    answerDisplay: '4.0×10^-3',
    unitChoices: [],
    unitObvious: true,
    hint: '電流の向きと磁場の向きが垂直なら、力は両方に垂直で、電流と長さと磁束密度の積になる。',
    approach: '電流が磁場から受ける力の大きさは F = I B L である。',
    firstStep: 'F = 1.0 × 0.20 × 0.020 である。',
    explanation:
        '電流と磁場が垂直なとき、力の大きさは F = I B L である。'
        'L = 2.0 cm = 0.020 m。'
        'F = 1.0 × 0.20 × 0.020 = 4.0×10^-3 N。',
  ),
  PhysicsProblem(
    id: 'd9ed9c59-ef5b-4880-b07d-320542a4c373',
    theme: '金属結晶の原子半径',
    title: 'アルミニウムの原子半径',
    domains: {PhysicsDomain.atom},
    figure: ProblemFigure.aluminumCube,
    statement:
        '図のように、一辺 3.0 cm の立方体のアルミニウムの質量は 78.0 g である。'
        '原子を球とみなし、球の占める割合を 0.74 とする。原子半径を pm で答えよ。\n'
        '※原子量を 27、アボガドロ定数を 6.02×10²³ /mol、π = 3.14 とする。'
        '1.40³ = 2.744 として計算してよい。',
    answerValue: 140,
    answerUnit: 'pm',
    answerDisplay: '140',
    unitChoices: [],
    unitObvious: true,
    hint: '立方体の体積を原子の個数で割ると、原子1個あたりの場所の体積になる。そのうち 0.74 が球である。',
    approach: '原子半径は、原子1個の球の体積 (4/3) π r³ から出す。',
    firstStep: '(4/3) × 3.14 × r³ = 0.74 × (3.0×10⁻²)³ / ((78.0 / 27) × 6.02×10²³) である。',
    explanation:
        '原子1個の球の体積は (4/3) π r³ で、これは原子1個あたりの体積の 0.74 倍である。'
        '立方体の体積は (3.0×10⁻²)³ = 2.70×10⁻⁵ m³。'
        '物質量は 78.0 / 27 = 2.888... mol。'
        '原子数は 2.888... × 6.02×10²³ = 1.739×10²⁴。'
        '原子1個あたりの体積は 2.70×10⁻⁵ / 1.739×10²⁴ = 1.553×10⁻²⁹ m³。'
        '球の体積は 0.74 × 1.553×10⁻²⁹ = 1.149×10⁻²⁹ m³。'
        '(4/3) π = 4.187。'
        'r³ = 1.149×10⁻²⁹ / 4.187 = 2.744×10⁻³⁰。'
        '※より r = 1.40×10⁻¹⁰ m = 140 pm。',
  ),
];
