import '../models/physics_domain.dart';
import '../models/physics_problem.dart';

/// 出題する問題。表示番号は並びの順。
const sampleProblems = <PhysicsProblem>[
  PhysicsProblem(
    id: 'sample-mechanics',
    theme: '運動方程式（ニュートン第2法則）',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.stackedBlocks,
    statement:
        '図のように鉛直上向きに外力を加えたところ、'
        '全体が一体となって鉛直上向きに大きさ 0.20 m/s² の加速度で運動した。'
        '物体Bが物体Cから受ける力の大きさを答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 40,
    answerUnit: 'N',
    answerDisplay: '40',
    unitChoices: ['Pa', 'kg', 's', 'm^-1', 'J^-1', 'W^-1', 'N'],
    hint: '上の二つの物体をひとまとめにして、上向きに加速していることに注目する。',
    hintReveal: HintReveal.groupUpperBlocks,
    approach: '物体Aと物体Bを一体とみなし、運動方程式を使う。',
    firstStep: '上向きを正とすると、4.0 a = N − 4.0 × 9.8 である。',
    explanation:
        '上向きを正とする。AとBを一体とみなすと質量は 1.0 + 3.0 = 4.0 kg で、'
        'Cから受ける力の大きさを N とする。'
        '運動方程式は N − 4.0 × 9.8 = 4.0 × 0.20。'
        'N = 4.0 × 9.8 + 4.0 × 0.20 = 39.2 + 0.80 = 40 N。',
  ),
  PhysicsProblem(
    id: 'sample-electromagnetism',
    theme: '電力 [W]',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.seriesCircuit,
    statement:
        '電圧 12 V の電源に 4.0 Ω の抵抗と 8.0 Ω の抵抗を直列につないだ。'
        'このとき電源が供給する電力を答えよ。',
    answerValue: 12,
    answerUnit: 'W',
    answerDisplay: '12',
    unitChoices: ['Pa', 'kg', 'J', 'W', 's', 'm^-1', 'N'],
    hint: '直列なので、電流の通り道は一本になる。',
    approach: '合成抵抗を求め、電力の式 P = V²/R を使う。',
    firstStep: '合成抵抗は R = 4.0 + 8.0 = 12 Ω である。',
    explanation:
        '直列なので合成抵抗は R = 4.0 + 8.0 = 12 Ω。'
        '電源が供給する電力は P = V²/R = 12²/12 = 144/12 = 12 W。',
  ),
  PhysicsProblem(
    id: 'sample-waves',
    theme: '気柱の振動（閉管の共鳴）',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.openPipe,
    statement:
        '長さ 90 cm の開管と長さ L の閉管がある。同じ振動数の音波を送り込み、'
        'それぞれが共鳴して管内に腹を 3 個もつ定在波が生じているとき、'
        '閉管の長さ L を答えよ。\n'
        '※開口端に生じる腹も管内に生じる腹として数えるものとし、また、'
        '開口端補正は無視できるものとする。',
    answerValue: 112.5,
    answerUnit: 'cm',
    answerDisplay: '112.5',
    unitChoices: ['cm', 's', 'g', '1'],
    hint: '腹の個数から、管の中に波が何個分入っているかを考える。',
    approach: '開管は両端が腹、閉管は閉端が節になる。腹の間隔は λ/2 なので、波長をそろえて L を求める。',
    firstStep: '開管では両端と中央が腹なので、腹の間隔が2つ分あり、90 cm = λ である。',
    explanation:
        '隣り合う腹の間隔は λ/2 である。'
        '開管は両端が腹で、腹が3個なら中央も腹になる。間隔が2つあるので 90 cm = 2 × (λ/2) = λ。λ = 90 cm。'
        '閉管は閉端が節、開口端が腹である。節から腹までは λ/4、その後の腹と腹の間隔は λ/2。'
        '腹が3個なら、閉端から開口端まで λ/4 + λ/2 + λ/2 = 5λ/4。'
        'L = 5 × 90 / 4 = 112.5 cm。',
  ),
  PhysicsProblem(
    id: 'sample-thermodynamics',
    theme: '熱力学第1法則',
    domains: {PhysicsDomain.thermodynamics},
    statement:
        '内部エネルギーが 2.4×10² J の気体に 1.5×10² J の熱を加えたところ、'
        '外部に 50 J の仕事をした。仕事をした後の気体の内部エネルギーを答えよ。',
    answerValue: 340,
    answerUnit: 'J',
    answerDisplay: '340',
    unitChoices: ['kg', 'J', 'W', 'm^-1', 's^-1', 'Pa', 'N'],
    hint: '入ってきた熱と、外へした仕事の差が、内部エネルギーの変化になる。',
    approach: '熱力学第1法則 ΔU = Q − W を使う。W は気体が外部にした仕事である。',
    firstStep: 'ΔU = 1.5×10² − 50 である。',
    explanation:
        '熱力学第1法則は ΔU = Q − W で、W は気体が外部にした仕事である。'
        'ΔU = 1.5×10² − 50 = 100 J。'
        '仕事をした後の内部エネルギーは 2.4×10² + ΔU = 240 + 100 = 340 J。',
  ),
  PhysicsProblem(
    id: 'sample-atom',
    theme: '放射性崩壊と半減期',
    domains: {PhysicsDomain.atom},
    statement:
        '半減期が 8.0 日の放射性原子核がある。はじめの個数が 3.2×10⁶ 個であったとき、'
        '24 日後に残っている原子核の個数を答えよ。',
    answerValue: 4.0e5,
    answerUnit: '1',
    answerDisplay: '4.0×10^5',
    unitChoices: ['m', 'm^-1', 's', 's^-1', 'kg', 'kg^-1', '1'],
    hint: '半減期が何回分だけ進んだかを、先に数える。',
    approach: '放射性崩壊では、半減期ごとに個数は半分になる。',
    firstStep: '経過時間は半減期 3 回分で、24 / 8.0 = 3 である。',
    explanation:
        '残る個数は N = N₀ × (1/2)^(t/T) である。'
        't/T = 24 / 8.0 = 3 なので、N = 3.2×10⁶ × (1/2)³ = 3.2×10⁶ / 8 = 4.0×10⁵ 個。',
  ),
  PhysicsProblem(
    id: 'sample-fusion',
    theme: '熱量',
    domains: {PhysicsDomain.mechanics, PhysicsDomain.thermodynamics},
    statement:
        '断熱容器の中にある水に、質量 0.50 kg の物体を高さ 2.0 m から落とした。'
        '物体の力学的エネルギーはすべて熱として水に移り、水の温度上昇に使われた。'
        '水が受け取った熱量を答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とし、'
        '空気の抵抗や容器への熱の移動は無視できるものとする。',
    answerValue: 9.8,
    answerUnit: 'J',
    answerDisplay: '9.8',
    unitChoices: ['kg', 'J', 'W', 'm^-1', 's^-1', 'Pa', 'N'],
    hint: '落下のあいだに失うエネルギーが、水の受け取る熱になる。',
    approach: '失った位置エネルギーを、熱力学でいう熱量とみなす。',
    firstStep: '失う力学的エネルギーは mgh である。',
    explanation:
        '空気抵抗も容器への熱の移動もないので、物体が失った力学的エネルギーが水の受け取る熱量 Q に等しい。'
        '失うのは位置エネルギーだから、Q = mgh = 0.50 × 9.8 × 2.0 = 9.8 J。',
  ),
  PhysicsProblem(
    id: 'sample-sliding',
    theme: '仕事とエネルギー',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.slidingComparison,
    statement:
        'ある水平面上で物体に 5.0 m/s の速さを与えてすべらせたところ、'
        '距離 L だけすべって停止した。また、同じ水平面上において、'
        'この物体に速さ v₀ を与えてすべらせたところ、'
        '水平面上を 4L だけすべって停止した。v₀ を答えよ。',
    answerValue: 10,
    answerUnit: 'm/s',
    answerDisplay: '10',
    unitChoices: [],
    hint: '止まったとき、運動エネルギーは動摩擦力のした仕事で失われている。',
    approach: '仕事とエネルギーの関係 (1/2) m v² = f x を、2つのすべりに使う。',
    firstStep: '(1/2) m × 5.0² = f L、(1/2) m v₀² = f × 4L である。',
    explanation:
        '動摩擦力の大きさ f は同じである。止まったとき運動エネルギーは 0 なので、'
        '仕事とエネルギーの関係から (1/2) m v² = f x となる。'
        '(1/2) m × 5.0² = f L、(1/2) m v₀² = f × 4L。'
        '辺々を割ると v₀² / 5.0² = 4L / L = 4。'
        'v₀ = 5.0 × 2 = 10 m/s。',
  ),
  PhysicsProblem(
    id: 'sample-electrons',
    theme: '電流の定義 [A]',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.resistorCurrent,
    statement:
        '抵抗に 1.6×10³ mA の電流が流れている。'
        '5 秒間に抵抗のある断面を通過した自由電子の個数を答えよ。\n'
        '※電気素量を 1.6×10⁻¹⁹ C とする。',
    answerValue: 5.0e19,
    answerUnit: '1',
    answerDisplay: '5.0×10^19',
    unitChoices: ['m', 'm^-1', 's', 's^-1', 'kg', 'kg^-1', '1'],
    hint: '電流は、1秒あたりにその断面を通過する電気量である。',
    approach: '5秒間の電気量を求め、電気素量で割って個数にする。',
    firstStep: '1.6×10³ mA = 1.6 A なので、Q = 1.6 × 5 である。',
    explanation:
        '電流の定義は I = Q/t なので、通過した電気量は Q = It である。'
        '1.6×10³ mA = 1.6 A。Q = 1.6 × 5 = 8.0 C。'
        '電気素量を e とすると、個数は n = Q/e = 8.0 / (1.6×10⁻¹⁹) = 5.0×10¹⁹ 個。',
  ),
  PhysicsProblem(
    id: 'sample-free-end',
    theme: '自由端反射の節',
    domains: {PhysicsDomain.waves},
    hintReveal: HintReveal.freeEndReflection,
    statement:
        '振幅 3.0 cm、振動数 5.0 Hz の正弦波が、速さ 0.60 m/s で x 軸上を正の向きに進行し、'
        'x = 20 cm にある壁で自由端反射されている。x 軸上に生じている合成波について、'
        '変位が時間的に変化しない点のうち、壁にもっとも近いものの x 座標を答えよ。',
    answerValue: 17,
    answerUnit: 'cm',
    answerDisplay: '17',
    unitChoices: ['cm', 's', 'g', '1'],
    hint: '壁は自由端なので腹になる。変位が動かない点は、腹から波長の4分の1だけ離れている。',
    approach: '波長を求め、自由端の壁を腹とみなして、最も近い節の位置を求める。',
    firstStep: 'λ = 0.60 / 5.0 = 0.12 m = 12 cm である。',
    explanation:
        '波長は λ = v/f = 0.60 / 5.0 = 0.12 m = 12 cm。'
        '自由端反射なので、壁 x = 20 cm は腹である。'
        '定常波では腹と隣の節の間隔は λ/4 なので、壁にもっとも近い節は'
        'x = 20 − 12/4 = 20 − 3.0 = 17 cm。振幅は節の位置には使わない。',
  ),
  PhysicsProblem(
    id: 'sample-fixed-end',
    theme: '固定端反射の節',
    domains: {PhysicsDomain.waves},
    hintReveal: HintReveal.fixedEndReflection,
    statement:
        '振幅 3.0 cm、振動数 5.0 Hz の正弦波が、速さ 0.60 m/s で x 軸上を正の向きに進行し、'
        'x = 20 cm にある壁で固定端反射されている。x 軸上に生じている合成波について、'
        '変位が時間的に変化しない点のうち、壁にもっとも近いものの x 座標を答えよ。',
    answerValue: 20,
    answerUnit: 'cm',
    answerDisplay: '20',
    unitChoices: ['cm', 's', 'g', '1'],
    hint: '壁は固定端なので節になる。変位が動かない点のうち、壁にもっとも近いのは壁自身である。',
    approach: '波長を求め、固定端の壁を節とみなす。動かない点のうち壁に最も近いのは、壁自身である。',
    firstStep: 'λ = 0.60 / 5.0 = 0.12 m = 12 cm である。',
    explanation:
        '波長は λ = v/f = 0.60 / 5.0 = 0.12 m = 12 cm。'
        '固定端反射なので、壁では媒質が動けず、x = 20 cm は節である。'
        '変位が時間的に変化しない点は節なので、壁にもっとも近いのはこの点で x = 20 cm。'
        '次の節は腹をはさんで λ/2 = 6.0 cm 手前、x = 14 cm にある。',
  ),
  PhysicsProblem(
    id: 'sample-spectrum',
    theme: '電磁波の波長の順',
    domains: {PhysicsDomain.waves},
    statement:
        '赤外線、紫外線、電波、可視光、X線について、'
        '波長の短い順に左から並べよ。',
    answerValue: 0,
    answerUnit: '',
    answerDisplay: 'X線、紫外線、可視光、赤外線、電波',
    unitChoices: [],
    symbolChoices: ['赤外線', '紫外線', '電波', '可視光', 'X線'],
    symbolOrder: 'X線、紫外線、可視光、赤外線、電波',
    hint: '目に見える光を真ん中に置く。X線はそれより短く、電波はもっとも長い。',
    approach: '電磁波を、波長の短いものから長いものへ並べる。',
    firstStep: 'いちばん波長が短いのはX線である。',
    explanation: '波長の短い順は、X線、紫外線、可視光、赤外線、電波である。',
  ),
  PhysicsProblem(
    id: 'sample-spring-pulleys',
    theme: 'フックの法則',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.springPulleys,
    statement:
        '図のように水平に置かれたばね定数 196 N/m の軽いばねの両端に、'
        '滑車を通してそれぞれ 4.0 kg のおもりをつるし、静止させた。'
        'ばねの自然長からののびを答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とし、滑車はなめらかであるとする。',
    answerValue: 20,
    answerUnit: 'cm',
    answerDisplay: '20',
    unitChoices: ['cm', 's', 'g', 'N'],
    hint: '止まっているおもりでは、糸の張力と重力がつりあっている。',
    approach: '張力を求め、それがばねを引く力と等しいことを使う。',
    firstStep: '張力は T = 4.0 × 9.8 である。',
    explanation:
        'おもりは静止している。上向きを正とすると、運動方程式は T − mg = 0。'
        'T = 4.0 × 9.8 = 39.2 N。'
        'この張力がばねを引くので、フックの法則は kx = T。'
        '196 x = 39.2。x = 0.20 m = 20 cm。',
  ),
  PhysicsProblem(
    id: 'sample-air-resistance',
    theme: '仕事とエネルギー',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.compressedSpring,
    statement:
        '図のように質量の無視できるばねがついた質量 2.0 kg のおもりを、'
        'ばねを下に向けて床に押しつけ、ばねを自然長から 0.20 m 縮めて手をはなすと、'
        '空気抵抗を受けながら上昇し、手をはなした位置から 0.50 m 上がって落ちてきた。'
        '空気抵抗がおもりにした仕事を答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s²、ばね定数を 980 N/m とする。',
    answerValue: -9.8,
    answerUnit: 'J',
    answerDisplay: '-9.8',
    unitChoices: ['J', 'N', 'W', 'm'],
    hint: '最高点では速さは 0 である。減った力学的エネルギーが、空気抵抗の仕事になる。',
    approach: '手をはなした位置を高さの基準にし、弾性エネルギーと最高点の位置エネルギーを比べる。',
    firstStep: 'はじめの弾性エネルギーは (1/2) × 980 × 0.20² である。',
    explanation:
        '手をはなした位置を位置エネルギーの基準にする。直後の速さは 0 なので、'
        '力学的エネルギーは弾性エネルギーだけである。'
        'E_i = (1/2) k x² = (1/2)×980×0.20² = 19.6 J。'
        '最高点では速さが 0、高さは 0.50 m なので、E_f = mgh = 2.0×9.8×0.50 = 9.8 J。'
        '空気抵抗がした仕事を W とすると E_i + W = E_f。'
        'W = 9.8 − 19.6 = −9.8 J。',
  ),
  PhysicsProblem(
    id: 'sample-ac-power',
    theme: '電流・電圧の実効値の定義',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.acResistor,
    statement:
        '図のように、電圧の実効値が 240 V の交流電源に 10 kΩ の抵抗をつないだとき、'
        '抵抗で消費される電力を答えよ。',
    answerValue: 5.76,
    answerUnit: 'W',
    answerDisplay: '5.76',
    unitChoices: ['W', 'J', 'V', 'A'],
    hint: '電圧は正弦波で、実効値は振幅を √2 で割った値である。消費電力は、瞬間の電力を1周期で平均した値である。',
    approach: '振幅を V₀ = 240√2 とし、瞬間の電力 vi を1周期で積分して平均する。',
    firstStep: '電圧は v = 240√2 sin ωt、電流は i = v/R である。',
    explanation:
        '実効値が 240 V なので、正弦波の振幅は V₀ = 240√2 V である。'
        '抵抗では電流も同位相で、v = V₀ sin ωt、i = (V₀/R) sin ωt。'
        '瞬間の電力は p = vi = (V₀²/R) sin² ωt。'
        '1周期 T の平均は P = (1/T) ∫₀ᵀ p dt = (V₀²/R) × (1/T) ∫₀ᵀ sin² ωt dt。'
        'sin² ωt = (1 − cos 2ωt)/2 なので、cos の項は1周期で消え、∫₀ᵀ sin² ωt dt = T/2。'
        'したがって P = V₀²/(2R)。V₀² = (240√2)² = 2×240² を入れると P = 240²/R。'
        '10 kΩ = 1.0×10⁴ Ω なので、P = 240²/(1.0×10⁴) = 57600/10000 = 5.76 W。',
  ),
  PhysicsProblem(
    id: 'sample-incline',
    theme: '力のつり合い',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.inclinePull,
    statement:
        '図のように、水平から 30° 傾いたあらい斜面上で、質量 10 kg の小物体に'
        '軽くて伸び縮みしない糸を取りつけ、小物体を一定の速さで引き上げた。'
        'このとき、糸の張力の大きさを求めよ。\n'
        '※重力加速度の大きさを 9.8 m/s²、小物体と斜面との間の動摩擦係数を 0.50、'
        '√3 = 1.73 とする。',
    answerValue: 91.385,
    answerUnit: 'N',
    answerDisplay: '91.385',
    unitChoices: ['N', 'J', 'W', 'kg'],
    hint: '一定の速さなので加速度は 0 である。引き上げているので、動摩擦力は斜面を下る向きにはたらく。',
    approach: '斜面に垂直な向きと、斜面に沿った向きで、力のつりあいを書く。',
    firstStep: '斜面に垂直な向きでは、垂直抗力を N とすると N − 10 × 9.8 × cos 30° = 0 である。',
    explanation:
        '斜面を上る向きを正とする。一定の速さなので加速度は 0 である。'
        '斜面に垂直な向きのつりあいから、垂直抗力は N = mg cos 30°。'
        '動摩擦力の大きさは f = μN で、向きは斜面を下る向きである。'
        '斜面に沿ったつりあいは T − mg sin 30° − f = 0。'
        'sin 30° = 1/2、cos 30° = √3/2 = 1.73/2 = 0.865。'
        'mg sin 30° = 10 × 9.8 × 1/2 = 49 N。'
        'N = 10 × 9.8 × 0.865 = 84.77 N。f = 0.50 × 84.77 = 42.385 N。'
        'T = 49 + 42.385 = 91.385 N。',
  ),
  PhysicsProblem(
    id: 'a3ed863f-73f0-4ba2-977a-268f464df3ad',
    theme: '電気抵抗の定義（オームの法則）',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.batteryResistor,
    statement:
        '図のように、9.0 V の電池に 18 Ω の抵抗をつないだ。'
        '抵抗に流れる電流の大きさを答えよ。',
    answerValue: 0.5,
    answerUnit: 'A',
    answerDisplay: '0.50',
    unitChoices: ['A', 'V', 'W', 'C'],
    hint: '抵抗は一つで、両端の電圧と抵抗値が出ている。電流は、その二つで決まる。',
    approach: 'オームの法則 V = RI を使う。',
    firstStep: '9.0 = 18 I である。',
    explanation:
        'オームの法則は V = RI である。'
        '抵抗は一つで、電池の電圧がそのまま両端にかかるので、9.0 = 18 I。'
        'I = 9.0 / 18 = 0.50 A。',
  ),
  PhysicsProblem(
    id: 'b6cb0c9c-869b-44b0-a121-e28b7bca1597',
    theme: '合成抵抗',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.seriesCurrent,
    statement:
        '図のように、8.0 V の電池に 2.0 Ω の抵抗と 6.0 Ω の抵抗を直列につないだ。'
        '回路に流れる電流の大きさを答えよ。',
    answerValue: 1,
    answerUnit: 'A',
    answerDisplay: '1.0',
    unitChoices: ['A', 'V', 'W', 'C'],
    hint: '二つの抵抗が一本の通り道になっている。電流は、まとめた抵抗と電池の電圧で決まる。',
    approach: '直列の合成抵抗を求め、オームの法則 V = RI を使う。',
    firstStep: '合成抵抗は R = 2.0 + 6.0 = 8.0 Ω である。',
    explanation:
        '直列の合成抵抗は、各抵抗の和である。'
        'R = 2.0 + 6.0 = 8.0 Ω。'
        'オームの法則は V = RI なので、8.0 = 8.0 I。'
        'I = 8.0 / 8.0 = 1.0 A。',
  ),
  PhysicsProblem(
    id: '4f9096d1-35ee-49ee-b4c9-48041c56cdee',
    theme: '並列の合成抵抗',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.parallelCurrent,
    statement:
        '図のように、6.0 V の電池に 3.0 Ω の抵抗と 6.0 Ω の抵抗を並列につないだ。'
        '電流が分岐する手前の導線に流れる電流の大きさを答えよ。',
    answerValue: 3,
    answerUnit: 'A',
    answerDisplay: '3.0',
    unitChoices: ['A', 'V', 'W', 'C'],
    hint: '二つの抵抗は、どちらも電池の電圧をそのまま受けている。分岐の手前の電流は、その二つの通り道をまとめた抵抗で決まる。',
    approach: '並列の合成抵抗を求め、オームの法則 V = RI を使う。',
    firstStep: '1/R = 1/3.0 + 1/6.0 である。',
    explanation:
        '並列の合成抵抗は 1/R = 1/R1 + 1/R2 である。'
        '1/R = 1/3.0 + 1/6.0 = 2/6.0 + 1/6.0 = 1/2.0。R = 2.0 Ω。'
        '分岐の手前では、この合成抵抗に電池の電圧がかかる。'
        'オームの法則は V = RI なので、6.0 = 2.0 I。'
        'I = 6.0 / 2.0 = 3.0 A。',
  ),
  PhysicsProblem(
    id: '5adf49b5-0a92-439b-9f65-88ad58a94bc3',
    theme: 'ブリッジ形回路の電圧降下',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.bridgeVoltageDrop,
    statement:
        '図のように、左上の抵抗での電圧降下の大きさを答えよ。',
    answerValue: 2,
    answerUnit: 'V',
    answerDisplay: '2.0',
    unitChoices: ['V', 'A', 'W', 'C'],
    hint: '左上と左下は一本の通り道で、その両端は電池である。電流はその通り道で決まり、電圧降下は左上だけを見る。',
    approach: 'オームの法則 V = RI を使う。',
    firstStep: '左の通り道では 6.0 = (4.0 + 8.0) I である。',
    explanation:
        'オームの法則は V = RI である。'
        '左上の 4.0 Ω と左下の 8.0 Ω は直列で、両端の電圧は電池の 6.0 V なので、'
        '6.0 = (4.0 + 8.0) I。'
        'I = 6.0 / 12 = 0.50 A。左上の電圧降下は V = 4.0 × 0.50 = 2.0 V。',
  ),
  PhysicsProblem(
    id: '059e9128-3c09-4e75-9a6b-8c401a807e7c',
    theme: '等温変化（ボイルの法則）',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.isothermalGas,
    statement:
        '図のように、温度を 300 K に保ったまま、圧力 2.0×10⁵ Pa、体積 4.0×10⁻³ m³ の'
        '理想気体の体積を 8.0×10⁻³ m³ にした。このときの圧力を答えよ。',
    answerValue: 1.0e5,
    answerUnit: 'Pa',
    answerDisplay: '1.0×10^5',
    unitChoices: ['Pa', 'J', 'N', 'W'],
    hint: '温度が変わっていない。圧力と体積の積が保たれる。',
    approach: 'ボイルの法則 PV = 一定 を使う。',
    firstStep: '2.0×10⁵ × 4.0×10⁻³ = P × 8.0×10⁻³ である。',
    explanation:
        '等温変化ではボイルの法則 PV = 一定である。'
        '2.0×10⁵ × 4.0×10⁻³ = P × 8.0×10⁻³。'
        'P = 2.0×10⁵ × 4.0×10⁻³ / 8.0×10⁻³ = 1.0×10⁵ Pa。',
  ),
  PhysicsProblem(
    id: '62dce096-726f-4a28-8139-de3eff094793',
    theme: '等圧変化（シャルルの法則）',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.isobaricGas,
    statement:
        '図のように、圧力を 1.0×10⁵ Pa に保ったまま、温度 300 K、体積 2.0×10⁻³ m³ の'
        '理想気体を 450 K にした。このときの体積を答えよ。',
    answerValue: 3.0e-3,
    answerUnit: 'm^3',
    answerDisplay: '3.0×10^-3',
    unitChoices: [],
    hint: '圧力が変わっていない。体積と絶対温度の比が保たれる。',
    approach: 'シャルルの法則 V/T = 一定 を使う。',
    firstStep: '2.0×10⁻³ / 300 = V / 450 である。',
    explanation:
        '等圧変化ではシャルルの法則 V/T = 一定である。'
        '2.0×10⁻³ / 300 = V / 450。'
        'V = 2.0×10⁻³ × 450 / 300 = 3.0×10⁻³ m³。',
  ),
  PhysicsProblem(
    id: 'bf43572d-42ac-4b81-9dce-85c4a71ee6d7',
    theme: '等積変化',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.isochoricGas,
    statement:
        '図のように、体積を 2.0×10⁻³ m³ に保ったまま、温度 300 K、圧力 1.5×10⁵ Pa の'
        '理想気体を 600 K にした。このときの圧力を答えよ。',
    answerValue: 3.0e5,
    answerUnit: 'Pa',
    answerDisplay: '3.0×10^5',
    unitChoices: ['Pa', 'J', 'N', 'W'],
    hint: '体積が変わっていない。圧力と絶対温度の比が保たれる。',
    approach: 'ゲイリュサックの法則 P/T = 一定 を使う。',
    firstStep: '1.5×10⁵ / 300 = P / 600 である。',
    explanation:
        '等積変化ではゲイリュサックの法則 P/T = 一定である。'
        '1.5×10⁵ / 300 = P / 600。'
        'P = 1.5×10⁵ × 600 / 300 = 3.0×10⁵ Pa。',
  ),
  PhysicsProblem(
    id: '2eef6ac4-67da-439f-b4fa-d6436a743eb8',
    theme: '断熱変化（ポアソンの式）',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.adiabaticGas,
    statement:
        '図のように、外部と熱の出入りがないように、圧力 1.0×10⁵ Pa、体積 8.0×10⁻³ m³ の'
        '単原子理想気体を、体積 1.0×10⁻³ m³ まで圧縮した。このときの圧力を答えよ。\n'
        '※γ = 5/3 とする。',
    answerValue: 3.2e6,
    answerUnit: 'Pa',
    answerDisplay: '3.2×10^6',
    unitChoices: ['Pa', 'J', 'N', 'W'],
    hint: '外部との熱の出入りがない。圧力と体積は、温度が一定のときの積とは違う形で結ばれる。',
    approach: 'ポアソンの式 P V^γ = 一定 を使う。',
    firstStep: '1.0×10⁵ × (8.0×10⁻³)^{5/3} = P × (1.0×10⁻³)^{5/3} である。',
    explanation:
        '断熱変化ではポアソンの式 P V^γ = 一定である。γ = 5/3。'
        '1.0×10⁵ × (8.0×10⁻³)^{5/3} = P × (1.0×10⁻³)^{5/3}。'
        '体積の比は 8.0×10⁻³ / 1.0×10⁻³ = 8.0。'
        '8.0^{5/3} = (8.0^{1/3})^5 = 2.0^5 = 32。'
        'P = 1.0×10⁵ × 32 = 3.2×10⁶ Pa。',
  ),
  PhysicsProblem(
    id: '6dbf478a-bb30-40a4-bacb-c7c1ddd5b550',
    theme: '気体の内部エネルギー',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.connectedVessels,
    statement:
        '図のように、コックで仕切られた二つの容器に単原子分子の理想気体が入っている。'
        'コックを開いて十分に時間がたったとき、気体の圧力を答えよ。\n'
        '※容器の外への熱の出入りはなく、容器の体積は変わらないものとする。',
    answerValue: 1.6e5,
    answerUnit: 'Pa',
    answerDisplay: '1.6×10^5',
    unitChoices: ['Pa', 'J', 'N', 'W'],
    hint: 'コックを開くあいだ、気体はつりあっていない。外への仕事も熱の出入りもない。',
    approach: '単原子理想気体の内部エネルギー U = (3/2) pV が、全体で保存されることを使う。',
    firstStep: '(3/2)×2.0×10⁵×3.0×10⁻³ + (3/2)×1.0×10⁵×2.0×10⁻³ = (3/2) P × 5.0×10⁻³ である。',
    explanation:
        '単原子理想気体の内部エネルギーは U = (3/2) nRT = (3/2) pV である。'
        'コックを開くあいだ、外への熱の出入りはなく、容器の体積は変わらないので外への仕事もない。'
        'したがって内部エネルギーの和は変わらない。'
        '(3/2)×2.0×10⁵×3.0×10⁻³ + (3/2)×1.0×10⁵×2.0×10⁻³ = (3/2) P × 5.0×10⁻³。'
        '2.0×10⁵×3.0×10⁻³ + 1.0×10⁵×2.0×10⁻³ = P × 5.0×10⁻³。'
        '6.0×10² + 2.0×10² = 5.0×10⁻³ P。'
        'P = 8.0×10² / 5.0×10⁻³ = 1.6×10⁵ Pa。',
  ),
  PhysicsProblem(
    id: 'c6d333a8-fdff-45e6-ae3d-d576394a8f58',
    theme: '2原子理想気体のモル比熱',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.diatomicVessels,
    statement:
        '図のように、コックで仕切られた二つの容器に2原子分子の理想気体が入っている。'
        'コックを開いて十分に時間がたったとき、気体の温度を答えよ。\n'
        '※容器の外への熱の出入りはなく、容器の体積は変わらないものとする。',
    answerValue: 500,
    answerUnit: 'K',
    answerDisplay: '500',
    unitChoices: ['K', 'Pa', 'J', 'mol'],
    hint: 'コックを開くあいだ、気体はつりあっていない。外への仕事も熱の出入りもなく、物質の量は保たれる。',
    approach: '2原子理想気体の内部エネルギー U = (5/2) nRT が、全体で保存されることを使う。',
    firstStep: '(5/2)×2.0×R×300 + (5/2)×1.0×R×900 = (5/2)×(2.0+1.0)×R×T である。',
    explanation:
        '2原子理想気体の定積モル比熱は C_V = (5/2) R なので、内部エネルギーは U = n C_V T = (5/2) nRT である。'
        'コックを開くあいだ、外への熱の出入りはなく、容器の体積は変わらないので外への仕事もない。'
        'したがって内部エネルギーの和は変わらない。物質量の和も変わらない。'
        '(5/2)×2.0×R×300 + (5/2)×1.0×R×900 = (5/2)×(2.0+1.0)×R×T。'
        '2.0×300 + 1.0×900 = 3.0 T。'
        '600 + 900 = 3.0 T。'
        'T = 1500 / 3.0 = 500 K。',
  ),
  PhysicsProblem(
    id: '680f161b-8039-4d8b-97ac-54d641bf875e',
    theme: '鉛直ばねの単振動の周期',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.verticalSpringOscillation,
    statement:
        '図のように天井からばねにおもりをつるし、静かに手をはなしたところ、'
        'おもりは鉛直方向に振動した。この振動の周期を答えよ。\n'
        '※π = 3.14 とする。',
    answerValue: 3.14,
    answerUnit: 's',
    answerDisplay: '3.14',
    unitChoices: ['s', 'Hz', 'm', 'N'],
    hint: 'おもりには重力もばねの力もはたらく。釣り合いの位置からのずれだけを見る。',
    approach: '運動方程式を釣り合いの位置のまわりで書き、周期 T = 2π √(m/k) を使う。',
    firstStep: 'T = 2π √(1.0 / 4.0) である。',
    explanation:
        '鉛直下向きを正とする。自然長からののびを x とすると、運動方程式は mẍ = mg − kx。'
        '釣り合いでは 0 = mg − kδ なので、δ = mg/k。'
        'y = x − δ とおくと ẍ = ÿ より mÿ = −ky。ÿ = −(k/m) y。'
        '角振動数は ω = √(k/m) なので、周期は T = 2π/ω = 2π √(m/k)。'
        'T = 2 × 3.14 × √(1.0/4.0) = 6.28 × 0.50 = 3.14 s。',
  ),
  PhysicsProblem(
    id: '63f5a83f-3152-4583-8c46-67bc2e33d8bc',
    theme: '単振り子の周期',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.simplePendulum,
    statement:
        '図のように糸の先に小物体をつけ、鉛直面内で小さく振った。'
        'この振動の周期を答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s²、π = 3.14 とする。',
    answerValue: 3.14,
    answerUnit: 's',
    answerDisplay: '3.14',
    unitChoices: ['s', 'Hz', 'm', 'N'],
    hint: '振れが小さい。糸に沿った向きではなく、弧に沿ったずれを見る。',
    approach: '運動方程式を微小な角で近似し、周期 T = 2π √(L/g) を使う。',
    firstStep: 'T = 2π √(2.45 / 9.8) である。',
    explanation:
        '鉛直面内の振れ角を θ とする。接線方向の運動方程式は m L θ̈ = −mg sin θ。'
        '振れが小さいので sin θ ≈ θ。θ̈ = −(g/L) θ。'
        '角振動数は ω = √(g/L) なので、周期は T = 2π/ω = 2π √(L/g)。'
        'T = 2 × 3.14 × √(2.45/9.8) = 6.28 × √0.25 = 6.28 × 0.50 = 3.14 s。',
  ),
  PhysicsProblem(
    id: '11cf8d71-4c2b-45ed-bb3e-3718131609c2',
    theme: 'ケプラー第3法則',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.keplerOrbits,
    statement:
        '図のように太陽のまわりをまわる二つの天体がある。'
        '太陽からの距離が 4.0×10⁸ km の天体の公転周期を答えよ。',
    answerValue: 8,
    answerUnit: '年',
    answerDisplay: '8',
    unitChoices: [],
    unitObvious: true,
    hint: '二つの軌道の、太陽からの距離と、一方の周期が出ている。',
    approach: 'ケプラー第3法則 T² ∝ a³ を使う。',
    firstStep: '(T / 1)² = (4.0×10⁸ / 1.0×10⁸)³ である。',
    explanation:
        'ケプラー第3法則は T² / a³ = 一定である。'
        '(T / 1)² = (4.0×10⁸ / 1.0×10⁸)³ = 4.0³ = 64。'
        'T = 8 年。',
  ),
  PhysicsProblem(
    id: '94b33f1d-6d59-425c-9481-9b73a8686890',
    theme: 'うなり',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.beats,
    statement:
        '図のように、左右の音叉を同時に鳴らしたところ、そのあいだで'
        '音の強さが強くなったり弱くなったりを繰り返した。'
        'この繰り返しの周期を答えよ。',
    answerValue: 0.5,
    answerUnit: 's',
    answerDisplay: '0.5',
    unitChoices: ['s', 'Hz', 'm', 'N'],
    hint: '二つの音叉の振動数がわずかに違っている。音の強さが繰り返す間隔は、その差で決まる。',
    approach: 'うなりの周期 T = 1/|f1 − f2| を使う。',
    firstStep: 'T = 1/|442 − 440| である。',
    explanation:
        'うなりの回数は |f1 − f2| である。周期はその逆数なので T = 1/|f1 − f2|。'
        'T = 1/|442 − 440| = 1/2 = 0.5 s。',
  ),
];
