import '../models/physics_domain.dart';
import '../models/physics_problem.dart';
import 'note_article_problems.dart';

/// 出題する問題。表示番号は並びの順。
const sampleProblems = <PhysicsProblem>[
  PhysicsProblem(
    id: 'sample-mechanics',
    theme: '運動方程式（ニュートン第2法則）',
    title: '物体Bが物体Cから受ける力',
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
    title: '直列回路で電源が供給する電力',
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
    title: '腹が3個ある閉管の長さ',
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
    title: '熱を加え仕事をしたあとの内部エネルギー',
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
    title: '半減期のあとに残る原子核の個数',
    domains: {PhysicsDomain.atom},
    statement:
        '半減期が 8.0 日の放射性原子核がある。はじめの個数が 3.2×10⁶ 個であったとき、'
        '24 日後に残っている原子核の個数を答えよ。',
    answerValue: 4.0e5,
    answerUnit: '個',
    answerDisplay: '4.0×10^5',
    unitChoices: [],
    unitObvious: true,
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
    title: '落下した物体が水に与える熱量',
    domains: {PhysicsDomain.mechanics, PhysicsDomain.thermodynamics},
    figure: ProblemFigure.heatDrop,
    statement:
        '図のように、断熱容器の中にある水に、質量 0.50 kg の物体を高さ 2.0 m から落とした。'
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
    title: '4倍の距離をすべって止まる初速',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.slidingComparison,
    statement:
        'ある水平面上で物体に 5.0 m/s の初速を与えてすべらせたところ、'
        '距離 L だけすべって停止した。同じ水平面上において、'
        'この4倍の距離を滑らせるためには物体にどれだけの初速を与えればよいか。',
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
    title: '抵抗を通過した自由電子の個数',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.resistorCurrent,
    statement:
        '抵抗に 1.6×10³ mA の電流が流れている。'
        '5 秒間に抵抗のある断面を通過した自由電子の個数を答えよ。\n'
        '※電気素量を 1.6×10⁻¹⁹ C とする。',
    answerValue: 5.0e19,
    answerUnit: '個',
    answerDisplay: '5.0×10^19',
    unitChoices: [],
    unitObvious: true,
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
    title: '自由端反射で壁に最も近い節',
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
    title: '固定端反射で壁に最も近い節',
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
    title: '電磁波を波長の短い順に並べる',
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
    title: '両端におもりをつるしたばねののび',
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
    title: '上昇するおもりへの空気抵抗の仕事',
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
    title: '交流電源につないだ抵抗の消費電力',
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
    title: '斜面を一定の速さで引き上げる張力',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.inclinePull,
    statement:
        '図のように、水平から 30° 傾いたあらい斜面上で、質量 10 kg の小物体に'
        '軽くて伸び縮みしない糸を取りつけ、小物体を一定の速さで引き上げた。'
        'このとき、糸の張力の大きさを求めよ。\n'
        '※重力加速度の大きさを 9.8 m/s²、小物体と斜面との間の動摩擦係数を 1/√3、'
        '√3 = 1.73 とする。',
    answerValue: 98,
    answerUnit: 'N',
    answerDisplay: '98',
    unitChoices: ['N', 'J', 'W', 'kg'],
    hint: '一定の速さなので加速度は 0 である。引き上げているので、動摩擦力は斜面を下る向きにはたらく。',
    approach: '斜面に垂直な向きと、斜面に沿った向きで、力のつりあいを書く。',
    firstStep: '斜面に垂直な向きでは、垂直抗力を N とすると N − 10 × 9.8 × cos 30° = 0 である。',
    explanation:
        '斜面を上る向きを正とする。一定の速さなので加速度は 0 である。'
        '斜面に垂直な向きのつりあいから、垂直抗力は N = mg cos 30°。'
        '動摩擦力の大きさは f = μN で、向きは斜面を下る向きである。'
        '斜面に沿ったつりあいは T − mg sin 30° − f = 0。'
        'したがって T = mg sin 30° + μ mg cos 30° = mg (sin 30° + μ cos 30°)。'
        'sin 30° = 1/2、cos 30° = √3/2、μ = 1/√3 なので、'
        'μ cos 30° = (1/√3) × (√3/2) = 1/2。'
        'T = mg (1/2 + 1/2) = mg = 10 × 9.8 = 98 N。',
  ),
  PhysicsProblem(
    id: 'a3ed863f-73f0-4ba2-977a-268f464df3ad',
    theme: '電気抵抗の定義（オームの法則）',
    title: '電池につないだ抵抗に流れる電流',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.batteryResistor,
    statement:
        '図のように、9.0 V の電池に 100 Ω の抵抗をつないだ。'
        '抵抗に流れる電流の大きさを答えよ。',
    answerValue: 0.09,
    answerUnit: 'A',
    answerDisplay: '0.09',
    unitChoices: ['A', 'V', 'W', 'C'],
    hint: '抵抗は一つで、両端の電圧と抵抗値が出ている。電流は、その二つで決まる。',
    approach: 'オームの法則 V = RI を使う。',
    firstStep: '9.0 = 100 I である。',
    explanation:
        'オームの法則は V = RI である。'
        '抵抗は一つで、電池の電圧がそのまま両端にかかるので、9.0 = 100 I。'
        'I = 9.0 / 100 = 0.09 A。',
  ),
  PhysicsProblem(
    id: 'b6cb0c9c-869b-44b0-a121-e28b7bca1597',
    theme: '合成抵抗',
    title: '直列につないだ二つの抵抗の電流',
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
    title: '並列につないだ二つの抵抗の電流',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.parallelCurrent,
    statement:
        '図のように、3.0 V の電池に 100 Ω の抵抗と 150 Ω の抵抗を並列につないだ。'
        '点Pに流れる電流の大きさを答えよ。',
    answerValue: 0.05,
    answerUnit: 'A',
    answerDisplay: '0.05',
    unitChoices: ['A', 'V', 'W', 'C'],
    hint: '点Pは、電流が二つの抵抗に分かれる前の導線にある。二つの抵抗は、どちらも電池の電圧をそのまま受けている。',
    approach: '並列の合成抵抗を求め、オームの法則 V = RI を使う。',
    firstStep: '1/R = 1/100 + 1/150 である。',
    explanation:
        '並列の合成抵抗は 1/R = 1/R1 + 1/R2 である。'
        '1/R = 1/100 + 1/150 = 3/300 + 2/300 = 5/300 = 1/60。R = 60 Ω。'
        '点Pでは、この合成抵抗に電池の電圧がかかる。'
        'オームの法則は V = RI なので、3.0 = 60 I。'
        'I = 3.0 / 60 = 0.05 A。',
  ),
  PhysicsProblem(
    id: '5adf49b5-0a92-439b-9f65-88ad58a94bc3',
    theme: 'ブリッジ形回路の電圧降下',
    title: '点Aと点Bの間の電圧降下',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.bridgeVoltageDrop,
    statement: '図のように、点Aと点Bの間の電圧降下の大きさを答えよ。',
    answerValue: 2.4,
    answerUnit: 'V',
    answerDisplay: '2.4',
    unitChoices: ['V', 'A', 'W', 'C'],
    hint: '点Aと点Bは、左上の抵抗の両端にある。電池の両極をつなぐ上側の通り道を見る。',
    approach: 'オームの法則 V = RI を使う。',
    firstStep: '上側の通り道では 6.0 = (4.0 + 6.0) I である。',
    explanation:
        'オームの法則は V = RI である。'
        '左上の 4.0 Ω と右上の 6.0 Ω は直列で、両端の電圧は電池の 6.0 V なので、'
        '6.0 = (4.0 + 6.0) I。'
        'I = 6.0 / 10 = 0.60 A。点Aと点Bの間の電圧降下は V = 4.0 × 0.60 = 2.4 V。',
  ),
  PhysicsProblem(
    id: '059e9128-3c09-4e75-9a6b-8c401a807e7c',
    theme: '等温変化（ボイルの法則）',
    title: '温度を保って体積を変えたあとの圧力',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.isothermalGas,
    statement:
        '図のように、温度を 293 K に保ったまま、圧力 1013 hPa、体積 2.0×10⁻³ m³ の'
        '理想気体の体積を 4.0×10⁻³ m³ にした。このときの圧力を答えよ。',
    answerValue: 506.5,
    answerUnit: 'hPa',
    answerDisplay: '506.5',
    unitChoices: ['hPa', 'J', 'N', 'W'],
    hint: '温度が変わっていない。圧力と体積の積が保たれる。',
    approach: 'ボイルの法則 PV = 一定 を使う。',
    firstStep: '1013 × 2.0×10⁻³ = P × 4.0×10⁻³ である。',
    explanation:
        '等温変化ではボイルの法則 PV = 一定である。'
        '1013 × 2.0×10⁻³ = P × 4.0×10⁻³。'
        'P = 1013 × 2.0×10⁻³ / 4.0×10⁻³ = 506.5 hPa。',
  ),
  PhysicsProblem(
    id: '62dce096-726f-4a28-8139-de3eff094793',
    theme: '等圧変化（シャルルの法則）',
    title: '圧力を保って温度を変えたあとの体積',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.isobaricGas,
    statement:
        '図のように、圧力を 1013 hPa に保ったまま、温度 300 K、体積 2.0×10⁻³ m³ の'
        '理想気体を 360 K にした。このときの体積を答えよ。',
    answerValue: 2.4e-3,
    answerUnit: 'm^3',
    answerDisplay: '2.4×10^-3',
    unitChoices: [],
    hint: '圧力が変わっていない。体積と絶対温度の比が保たれる。',
    approach: 'シャルルの法則 V/T = 一定 を使う。',
    firstStep: '2.0×10⁻³ / 300 = V / 360 である。',
    explanation:
        '等圧変化ではシャルルの法則 V/T = 一定である。'
        '2.0×10⁻³ / 300 = V / 360。'
        'V = 2.0×10⁻³ × 360 / 300 = 2.4×10⁻³ m³。',
  ),
  PhysicsProblem(
    id: 'bf43572d-42ac-4b81-9dce-85c4a71ee6d7',
    theme: '等積変化',
    title: '体積を保って温度を変えたあとの圧力',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.isochoricGas,
    statement:
        '図のように、体積を 2.0×10⁻³ m³ に保ったまま、温度 27℃、圧力 1013 hPa の'
        '理想気体を −3℃ にした。このときの圧力を答えよ。\n'
        '※0℃ = 273 K とする。',
    answerValue: 911.7,
    answerUnit: 'hPa',
    answerDisplay: '911.7',
    unitChoices: ['hPa', 'J', 'N', 'W'],
    hint: '体積が変わっていない。圧力と絶対温度の比が保たれる。℃のままでは比にできない。',
    approach: 'ゲイリュサックの法則 P/T = 一定 を使う。',
    firstStep: '1013 / 300 = P / 270 である。',
    explanation:
        '等積変化ではゲイリュサックの法則 P/T = 一定である。'
        '27℃ は 27 + 273 = 300 K、−3℃ は −3 + 273 = 270 K。'
        '1013 / 300 = P / 270。'
        'P = 1013 × 270 / 300 = 1013 × 0.90 = 911.7 hPa。',
  ),
  PhysicsProblem(
    id: '2eef6ac4-67da-439f-b4fa-d6436a743eb8',
    theme: '断熱変化（ポアソンの式）',
    title: '熱の出入りなく圧縮したあとの温度',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.adiabaticGas,
    statement:
        '図のように、外部と熱の出入りがないように、温度 27℃、体積 5.0×10⁻³ m³ の'
        '空気を、体積 1.0×10⁻³ m³ まで圧縮した。このときの温度を K で答えよ。\n'
        '※0℃ = 273 K、γ = 1.4、5^{0.4} = 1.9 とする。',
    answerValue: 570,
    answerUnit: 'K',
    answerDisplay: '570',
    unitChoices: [],
    unitObvious: true,
    hint: '外部との熱の出入りがない。体積の比と、はじめの絶対温度を見る。',
    approach: 'ポアソンの式 T V^{γ−1} = 一定 を使う。',
    firstStep: 'T × (1.0×10⁻³)^{0.4} = 300 × (5.0×10⁻³)^{0.4} である。',
    explanation:
        '断熱変化ではポアソンの式 T V^{γ−1} = 一定である。γ = 1.4 なので γ−1 = 0.4。'
        '27℃ は 27 + 273 = 300 K。'
        '体積の比は 5.0×10⁻³ / 1.0×10⁻³ = 5。'
        'T × (1.0×10⁻³)^{0.4} = 300 × (5.0×10⁻³)^{0.4}。'
        'T = 300 × 5^{0.4}。'
        '5^{0.4} = 1.9 なので、T = 300 × 1.9 = 570 K。',
  ),
  PhysicsProblem(
    id: '6dbf478a-bb30-40a4-bacb-c7c1ddd5b550',
    theme: '気体の内部エネルギー',
    title: '仕切りを開いたあとの気体の圧力',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.connectedVessels,
    statement:
        '図のように、コックで仕切られた二つの容器に単原子分子の理想気体が入っている。'
        'コックを開いて十分に時間がたったとき、気体の圧力を答えよ。\n'
        '※容器の外への熱の出入りはなく、容器の体積は変わらないものとする。',
    answerValue: 1316.9,
    answerUnit: 'hPa',
    answerDisplay: '1316.9',
    unitChoices: ['hPa', 'J', 'N', 'W'],
    hint: 'コックを開くあいだ、気体はつりあっていない。外への仕事も熱の出入りもない。',
    approach: '単原子理想気体の内部エネルギー U = (3/2) pV が、全体で保存されることを使う。',
    firstStep: '(3/2)×1519.5×3.0×10⁻³ + (3/2)×1013×2.0×10⁻³ = (3/2) P × 5.0×10⁻³ である。',
    explanation:
        '単原子理想気体の内部エネルギーは U = (3/2) nRT = (3/2) pV である。'
        'コックを開くあいだ、外への熱の出入りはなく、容器の体積は変わらないので外への仕事もない。'
        'したがって内部エネルギーの和は変わらない。'
        '(3/2)×1519.5×3.0×10⁻³ + (3/2)×1013×2.0×10⁻³ = (3/2) P × 5.0×10⁻³。'
        '1519.5×3.0 + 1013×2.0 = P × 5.0。'
        '4558.5 + 2026 = 5.0 P。'
        'P = 6584.5 / 5.0 = 1316.9 hPa。',
  ),
  PhysicsProblem(
    id: 'c6d333a8-fdff-45e6-ae3d-d576394a8f58',
    theme: '2原子理想気体のモル比熱',
    title: '仕切りを開いたあとの気体の温度',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.diatomicVessels,
    statement:
        '図のように、コックで仕切られた二つの容器に2原子分子の理想気体が入っている。'
        'コックを開いて十分に時間がたったとき、気体の温度を答えよ。\n'
        '※容器の外への熱の出入りはなく、容器の体積は変わらないものとする。',
    answerValue: 313,
    answerUnit: 'K',
    answerDisplay: '313',
    unitChoices: ['K', 'hPa', 'J', 'mol'],
    hint: 'コックを開くあいだ、気体はつりあっていない。外への仕事も熱の出入りもなく、物質の量は保たれる。',
    approach: '2原子理想気体の内部エネルギー U = (5/2) nRT が、全体で保存されることを使う。',
    firstStep: '(5/2)×0.20×R×293 + (5/2)×0.10×R×353 = (5/2)×(0.20+0.10)×R×T である。',
    explanation:
        '2原子理想気体の定積モル比熱は C_V = (5/2) R なので、内部エネルギーは U = n C_V T = (5/2) nRT である。'
        'コックを開くあいだ、外への熱の出入りはなく、容器の体積は変わらないので外への仕事もない。'
        'したがって内部エネルギーの和は変わらない。物質量の和も変わらない。'
        '(5/2)×0.20×R×293 + (5/2)×0.10×R×353 = (5/2)×(0.20+0.10)×R×T。'
        '0.20×293 + 0.10×353 = 0.30 T。'
        '58.6 + 35.3 = 0.30 T。'
        'T = 93.9 / 0.30 = 313 K。',
  ),
  PhysicsProblem(
    id: '680f161b-8039-4d8b-97ac-54d641bf875e',
    theme: '鉛直ばねの単振動の周期',
    title: 'つるしたばねの振動の周期',
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
    title: '小さく振った振り子の周期',
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
    title: '太陽から遠い天体の公転周期',
    domains: {PhysicsDomain.mechanics},
    statement:
        '太陽のまわりをまわる二つの天体がある。'
        '太陽からの距離が 1.0×10⁸ km の天体の公転周期は 1 年である。'
        '太陽からの距離が 4.0×10⁸ km の天体の公転周期を年で答えよ。',
    answerValue: 8,
    answerUnit: '年',
    answerDisplay: '8',
    unitChoices: [],
    unitObvious: true,
    hint: '近い方の距離と周期、遠い方の距離が出ている。周期の比は距離の比で決まる。',
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
    title: '二つの音叉の音の強さの繰り返し',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.beats,
    statement:
        '図のように、左右の音叉を同時に鳴らしたところ、そのあいだで'
        '音の強さが強くなったり弱くなったりを繰り返した。'
        'この繰り返しの周期を答えよ。',
    answerValue: 0.25,
    answerUnit: 's',
    answerDisplay: '0.25',
    unitChoices: ['s', 'Hz', 'm', 'N'],
    hint: '二つの音叉の振動数がわずかに違っている。音の強さが繰り返す間隔は、その差で決まる。',
    approach: 'うなりの周期 T = 1/|f1 − f2| を使う。',
    firstStep: 'T = 1/|104 − 100| である。',
    explanation:
        'うなりの回数は |f1 − f2| である。周期はその逆数なので T = 1/|f1 − f2|。'
        'T = 1/|104 − 100| = 1/4 = 0.25 s。',
  ),
  PhysicsProblem(
    id: 'ab68af64-b6f1-4a0b-b27d-9c8da85c2075',
    theme: '直列の合成ばね',
    title: '直列につないだばね全体ののび',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.seriesSprings,
    statement:
        '図のように、天井から二つのばねを直列につなぎ、下端におもりをつるして静止させた。'
        'ばね全体の自然長からののびを答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 0.30,
    answerUnit: 'm',
    answerDisplay: '0.30',
    unitChoices: ['m', 's', 'N', 'J'],
    hint: '二つのばねは一本の通り道になっている。全体ののびは、それぞれののびを合わせたものになる。',
    approach: '直列の合成ばね定数 1/k = 1/k1 + 1/k2 を使う。',
    firstStep: '1/k = 1/49 + 1/98 である。',
    explanation:
        '直列の合成ばね定数は 1/k = 1/k1 + 1/k2 である。'
        '1/k = 1/49 + 1/98 = 2/98 + 1/98 = 3/98 なので、k = 98/3 N/m。'
        'おもりは静止しているので mg = kx。'
        '1.0 × 9.8 = (98/3) x。x = 9.8 × 3 / 98 = 0.30 m。',
  ),
  PhysicsProblem(
    id: '355ab9b8-5510-4ab9-be24-4ffb0e0d3d2a',
    theme: '並列の合成ばね',
    title: '並列につないだばねののび',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.parallelSprings,
    statement:
        '図のように、天井から二つのばねを並列につなぎ、下端におもりをつるして静止させた。'
        'ばねの自然長からののびを答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とする。',
    answerValue: 0.10,
    answerUnit: 'm',
    answerDisplay: '0.10',
    unitChoices: ['m', 's', 'N', 'J'],
    hint: '二つのばねは、のびが同じになるようにつながっている。おもりの重力は、二つのばねが分けて支えている。',
    approach: '並列の合成ばね定数 k = k1 + k2 を使う。',
    firstStep: 'k = 49 + 147 である。',
    explanation:
        '並列の合成ばね定数は k = k1 + k2 である。'
        'k = 49 + 147 = 196 N/m。'
        'おもりは静止しているので mg = kx。'
        '2.0 × 9.8 = 196 x。x = 19.6 / 196 = 0.10 m。',
  ),
  PhysicsProblem(
    id: '16e3da14-71f7-4691-9997-ee15a8209c5e',
    theme: '開口端補正のある閉管の共鳴',
    title: '共鳴した気柱から音の速さ',
    domains: {PhysicsDomain.waves},
    figure: ProblemFigure.resonanceColumn,
    statement:
        '図のように、円筒の上端近くで振動数 430 Hz の音叉を鳴らしながら、'
        '円筒の水面の位置を徐々に変えたところ、上端から水面までの距離が '
        '18.5 cm のときと 58.5 cm のときに共鳴し、そのあいだでは共鳴しなかった。'
        'この事実から音速を理論的に計算せよ。',
    answerValue: 344,
    answerUnit: 'm/s',
    answerDisplay: '344',
    unitChoices: [],
    hint: '共鳴した長さが2つあり、そのあいだには共鳴がない。水面と、筒の上端の少し外を見る。',
    approach: '閉管の共鳴を使う。隣り合う共鳴長の差は λ/2 で、開口端補正は差をとると消える。',
    firstStep: '58.5 cm − 18.5 cm = λ/2 である。',
    explanation:
        '閉管の共鳴では、水面が節、腹が開口端の外側にある。開口端補正を Δ とすると、'
        'l + Δ = (2n − 1)λ/4 である。'
        '隣り合う共鳴では差をとると Δ が消え、'
        'λ/2 = 58.5 cm − 18.5 cm = 40.0 cm = 0.400 m となる。λ = 0.800 m。'
        '音の速さは V = fλ = 430 × 0.800 = 344 m/s。',
  ),
  PhysicsProblem(
    id: '6970d4b5-abcd-4825-a0fd-fc210892bc2f',
    theme: '理想気体の状態方程式',
    title: '1 m³の空気の質量',
    domains: {PhysicsDomain.thermodynamics},
    statement:
        '酸素と窒素の物質量の比が 1:3 の空気がある。'
        '温度 300 K、圧力 997.2 hPa のとき、空気 1.0 m³ の質量を答えよ。\n'
        '※理想気体とみなし、酸素の分子量を 32、窒素の分子量を 28、'
        '気体定数を R = 8.31 J/(mol·K)、997.2 hPa = 9.972×10⁴ Pa とする。',
    answerValue: 1.16,
    answerUnit: 'kg',
    answerDisplay: '1.16',
    unitChoices: ['kg', 'mol', 'hPa', 'J'],
    hint: '圧力も体積も温度も決まっていて、変化の前後はない。酸素と窒素の割合は、1 mol の質量を決める。',
    approach: '理想気体の状態方程式 PV = nRT を使う。',
    firstStep: '9.972×10⁴ × 1.0 = n × 8.31 × 300 である。',
    explanation:
        '理想気体の状態方程式は PV = nRT である。'
        '質量 m と物質量 n は、モル質量 M を用いて m = nM で結ばれる。'
        '酸素と窒素の物質量の比は 1:3 なので、'
        'M = (1×32 + 3×28)/(1+3) = 116/4 = 29 g/mol = 2.9×10⁻² kg/mol。'
        '9.972×10⁴ × 1.0 = n × 8.31 × 300。'
        '8.31 × 300 = 2493。'
        'n = 9.972×10⁴ / 2493 = 40 mol。'
        'm = 40 × 2.9×10⁻² = 1.16 kg。',
  ),
  PhysicsProblem(
    id: '3f04e9ee-5b10-44b3-959a-8066a139be9d',
    theme: '等加速度運動の速度',
    title: '落とした物体の地面での速さ',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.freeFallSpeed,
    statement:
        '図のように、高さ 0.90 m から物体を静かに放した。地面に達する直前の速さを答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とし、空気抵抗は無視する。',
    answerValue: 4.2,
    answerUnit: 'm/s',
    answerDisplay: '4.2',
    unitChoices: [],
    hint: '放した瞬間の速さは 0 で、落ちる距離が分かっている。落下中の加速度の大きさは変わらない。',
    approach: '等加速度運動の速度の式 v² − v₀² = 2ax を使う。',
    firstStep: 'v² − 0 = 2 × 9.8 × 0.90 である。',
    explanation:
        '下向きを正とする。初速 0 の等加速度運動では v² − v₀² = 2ax である。'
        'a = 9.8 m/s²、x = 0.90 m、v₀ = 0 なので、'
        'v² − 0 = 2 × 9.8 × 0.90。'
        'v² = 17.64。v = 4.2 m/s。',
  ),
  PhysicsProblem(
    id: '3587cf2f-0e4c-44bf-a255-4413086cf0c9',
    theme: '等加速度運動の位置',
    title: '落とした物体が地面に達する時間',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.freeFallTime,
    statement:
        '図のように、高さ 4.9 m から物体を静かに放した。地面に達するまでの時間を答えよ。\n'
        '※重力加速度の大きさを 9.8 m/s² とし、空気抵抗は無視する。',
    answerValue: 1,
    answerUnit: 's',
    answerDisplay: '1.0',
    unitChoices: ['s', 'm', 'm/s', 'm/s^2'],
    hint: '放した瞬間の速さは 0 で、落ちる距離が分かっている。求めるのは、地面に達するまでの時間である。',
    approach: '等加速度運動の位置の式 x = v₀t + (1/2)at² を使う。',
    firstStep: '4.9 = 0 × t + (1/2) × 9.8 × t² である。',
    explanation:
        '下向きを正とする。等加速度運動の位置は x = v₀t + (1/2)at² である。'
        'x = 4.9 m、v₀ = 0、a = 9.8 m/s² なので、'
        '4.9 = 0 × t + (1/2) × 9.8 × t²。'
        '4.9 = 4.9 t²。t² = 1.0。t = 1.0 s。',
  ),
  PhysicsProblem(
    id: '03565785-cd7a-4353-bd44-ff3879ea6935',
    theme: '万有引力による重力場',
    title: '静止衛星高度',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.geostationarySatellite,
    statement:
        '図のように、地球の赤道上空を、地球の自転と同じ角速度で円運動する衛星がある。'
        '地表からの高度を答えよ。\n'
        '※地球の半径を 6.4×10⁶ m、地表での重力加速度の大きさを 10 m/s²、'
        '地球の自転の角速度を 8.0×10⁻⁵ rad/s とする。',
    answerValue: 3.36e7,
    answerUnit: 'm',
    answerDisplay: '3.36×10^7',
    unitChoices: ['m', 's', 'm/s', 'm/s^2'],
    hint: '地球の自転と同じ角速度でまわり続けている。地表の重力加速度と、地球の半径が与えられている。',
    approach: '万有引力による重力場 GM/r² が、向心加速度 rω² に等しいことを使う。',
    firstStep: '10 × (6.4×10⁶)² / r² = r × (8.0×10⁻⁵)² である。',
    explanation:
        '万有引力による重力場は GM/r² である。'
        '地表面では r = R で、この大きさが g なので GM = g R²。'
        '静止衛星では、この重力場が向心加速度 rω² に等しい。'
        'g R² / r² = r ω²。'
        'r³ = g R² / ω² = 10 × (6.4×10⁶)² / (8.0×10⁻⁵)²。'
        '(6.4×10⁶)² = 4.096×10¹³、(8.0×10⁻⁵)² = 6.4×10⁻⁹。'
        'r³ = 10 × 4.096×10¹³ / 6.4×10⁻⁹ = 6.4×10²²。'
        '6.4×10²² = 64×10²¹ = (4.0×10⁷)³ なので、r = 4.0×10⁷ m。'
        '地表からの高度は h = r − R = 4.0×10⁷ − 6.4×10⁶ = 3.36×10⁷ m。',
  ),
  PhysicsProblem(
    id: 'ad238071-a49c-4825-99a7-29c217b9fd0c',
    theme: '静電容量の定義 [F]',
    title: 'コンデンサーに蓄えられる電荷',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.chargedCapacitor,
    statement: '図のコンデンサーに蓄えられる電荷を答えよ。',
    answerValue: 1.8e-2,
    answerUnit: 'C',
    answerDisplay: '1.8×10^-2',
    unitChoices: ['C', 'V', 'A', 'J'],
    hint: '容量と、かけた電圧が出ている。蓄えられる電荷は、その二つで決まる。',
    approach: '静電容量の定義 Q = CV を使う。',
    firstStep: 'Q = 1000×10⁻⁶ × 18 である。',
    explanation:
        '静電容量の定義は C = Q/V、すなわち Q = CV である。'
        '1000 μF = 1000×10⁻⁶ F = 1.0×10⁻³ F。'
        'Q = 1.0×10⁻³ × 18 = 1.8×10⁻² C。',
  ),
  PhysicsProblem(
    id: '990f59e0-b900-4224-8c81-42e9d3e147c7',
    theme: '平行板コンデンサーの電気容量',
    title: '真空の平行板コンデンサーの電気容量',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.parallelPlateCapacitor,
    statement:
        '図のように、正方形の極板を 2 枚平行に置いた。'
        '極板の間は真空である。この電気容量を答えよ。\n'
        '※真空の誘電率を 8.85×10⁻¹² F/m とする。',
    answerValue: 8.85e-11,
    answerUnit: 'F',
    answerDisplay: '8.85×10^-11',
    unitChoices: ['F', 'C', 'V', 'm'],
    hint: '極板の面積と、間隔が出ている。間は真空で、誘電率が与えられている。',
    approach: '平行板コンデンサーの電気容量 C = ε₀ S / d を使う。',
    firstStep: 'C = 8.85×10⁻¹² × (0.10)² / 1.0×10⁻³ である。',
    explanation:
        '平行板コンデンサーの電気容量は C = ε₀ S / d である。'
        '極板は一辺 10 cm = 0.10 m の正方形なので、S = 0.10 × 0.10 = 1.0×10⁻² m²。'
        '間隔は 1 mm = 1.0×10⁻³ m。'
        'C = 8.85×10⁻¹² × 1.0×10⁻² / 1.0×10⁻³ = 8.85×10⁻¹¹ F。',
  ),
  PhysicsProblem(
    id: 'f5c795da-e888-4d9a-bb13-03b190638904',
    theme: '誘電率と比誘電率',
    title: '紙を挟んだコンデンサーの電気容量',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.dielectricCapacitor,
    statement:
        '図のように、正方形の極板の間を紙が満たしている。この電気容量を答えよ。\n'
        '※真空の誘電率を 8.85×10⁻¹² F/m とする。',
    answerValue: 1.77e-9,
    answerUnit: 'F',
    answerDisplay: '1.77×10^-9',
    unitChoices: ['F', 'C', 'V', 'm'],
    hint: '間を紙が満たしていて、その比誘電率が出ている。極板の面積と、紙の厚さもある。',
    approach: '誘電率と比誘電率の関係から、C = ε_r ε₀ S / d を使う。',
    firstStep: 'C = 2.0 × 8.85×10⁻¹² × (0.10)² / 1.0×10⁻⁴ である。',
    explanation:
        '誘電率と比誘電率の関係は ε = ε_r ε₀ である。'
        '紙が極板の間を満たすとき、電気容量は C = ε S / d = ε_r ε₀ S / d である。'
        '極板は一辺 10 cm = 0.10 m の正方形なので、S = 0.10 × 0.10 = 1.0×10⁻² m²。'
        '紙の厚さは 0.1 mm = 1.0×10⁻⁴ m で、これが間隔 d である。'
        'C = 2.0 × 8.85×10⁻¹² × 1.0×10⁻² / 1.0×10⁻⁴ = 1.77×10⁻⁹ F。',
  ),
  PhysicsProblem(
    id: '2c769ccf-20fe-4de8-a0dc-f98eb5d7e824',
    theme: 'コンデンサーの合成容量',
    title: '金属板を挟んだコンデンサーの電気容量',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.metalInsertCapacitor,
    statement:
        '図のように、正方形の極板の間に、極板と同じ大きさの金属板を極板と平行に挟んだ。'
        '隙間は真空である。この電気容量を答えよ。\n'
        '※真空の誘電率を 8.85×10⁻¹² F/m とする。',
    answerValue: 1.77e-10,
    answerUnit: 'F',
    answerDisplay: '1.77×10^-10',
    unitChoices: ['F', 'C', 'V', 'm'],
    hint: '間の金属板が、隙間を二つに分けている。金属の中には電場ができない。極板の面積と、二つの間隔が出ている。',
    approach: 'コンデンサーの直列合成 1/C = 1/C₁ + 1/C₂ を使う。',
    firstStep: '1/C = (2.0×10⁻⁴ + 3.0×10⁻⁴) / (8.85×10⁻¹² × (0.10)²) である。',
    explanation:
        '直列につないだコンデンサーの合成容量は 1/C = 1/C₁ + 1/C₂ である。'
        '極板の間の金属板は、隙間を二つの平行板コンデンサーに分ける。'
        '金属の中には電場ができないので、この二つは直列になる。'
        'したがって 1/C = (d₁ + d₂) / (ε₀ S) である。'
        '極板は一辺 10 cm = 0.10 m の正方形なので、S = 0.10 × 0.10 = 1.0×10⁻² m²。'
        'd₁ = 0.2 mm = 2.0×10⁻⁴ m、d₂ = 0.3 mm = 3.0×10⁻⁴ m で、d₁ + d₂ = 5.0×10⁻⁴ m。'
        'C = 8.85×10⁻¹² × 1.0×10⁻² / 5.0×10⁻⁴ = 1.77×10⁻¹⁰ F。',
  ),
  PhysicsProblem(
    id: 'ee55e3b5-6de2-4c75-8536-e772727beff3',
    theme: '並列の合成容量',
    title: '並列につないだコンデンサーの電気容量',
    domains: {PhysicsDomain.electromagnetism},
    figure: ProblemFigure.parallelCapacitors,
    statement: '図のように、三つのコンデンサーを並列につないだ。この電気容量を答えよ。',
    answerValue: 100,
    answerUnit: 'μF',
    answerDisplay: '100',
    unitChoices: ['μF', 'C', 'V', 'A'],
    hint: '三つのコンデンサーは、同じ二つの導線のあいだにつながっている。かかる電圧は、どれも同じになる。',
    approach: '並列の合成容量 C = C₁ + C₂ + C₃ を使う。',
    firstStep: 'C = 10 + 22 + 68 である。',
    explanation:
        '並列につないだコンデンサーの合成容量は C = C₁ + C₂ + C₃ である。'
        '三つのコンデンサーは、両端がそれぞれつながっているので並列である。'
        'C = 10 + 22 + 68 = 100 μF。',
  ),
  PhysicsProblem(
    id: 'ea751b97-55c2-4363-a575-5d8fdc5cc9a7',
    theme: '万有引力定数 [N·m^2/kg^2]',
    title: '万有引力定数の測定',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.cavendishTorsion,
    statement:
        '図のように、棒の中央を針金で水平につるした。'
        '大球を置くと、棒は回って止まった。万有引力定数を答えよ。\n'
        '※針金のねじり定数を 6.7×10⁻⁵ N·m/rad とする。'
        'ねじり定数は、針金を 1 rad ねじったときに戻そうとする力のモーメントである。'
        '止まったときの針金のねじれ角を θ = 1.0×10⁻³ rad とする。'
        '止まったとき、大球と小球の中心を結ぶ向きは棒と垂直である。'
        '球の大きさは、中心のあいだの距離に比べて無視できる。',
    answerValue: 6.7e-11,
    answerUnit: 'N m^2/kg^2',
    answerDisplay: '6.7×10^-11',
    unitChoices: [],
    hint: '大球を置いたあと、棒は回って止まっている。針金のねじれと、大球と小球の位置を、棒の中央のまわりで見る。',
    approach: '力のモーメントのつり合いと、万有引力の法則を使う。',
    firstStep: 'κθ = (GMm / r²) × L である。',
    explanation:
        '万有引力の大きさは F = GMm / r² である。'
        '置いたあとでは、大球と小球の中心を結ぶ向きは棒と垂直である。'
        '棒の両端でこの向きは互いに逆で、棒を回す向きは同じになる。'
        '棒の長さを L とすると、中央のまわりの力のモーメントは 2 × F × (L/2) = FL である。'
        '止まった位置では、このモーメントと、針金が戻すモーメント κθ が釣り合う。'
        'κθ = FL = GMmL / r²。したがって G = κθ r² / (MmL)。'
        'κ = 6.7×10⁻⁵ N·m/rad、θ = 1.0×10⁻³ rad、r = 0.20 m、'
        'M = 100 kg、m = 0.40 kg、L = 1.0 m を入れる。'
        'r² = (0.20)² = 0.040。'
        '分子は 6.7×10⁻⁵ × 1.0×10⁻³ × 0.040 = 2.68×10⁻⁹。'
        '分母は 100 × 0.40 × 1.0 = 40。'
        'G = 2.68×10⁻⁹ / 40 = 6.7×10⁻¹¹ N·m²/kg²。',
  ),
  PhysicsProblem(
    id: '4dc4c30e-cd7d-4453-abc4-4f653c9076f3',
    theme: '公転周期から軌道半径',
    title: '地球から月までの距離',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.moonOrbit,
    statement:
        '図のように、月は地球のまわりを円運動している。'
        '地球の中心から月までの距離を答えよ。\n'
        '※地球の半径を 6.4×10⁶ m、地表での重力加速度の大きさを 9.8 m/s²、'
        '月の公転周期を 27.3 日、1日を 8.64×10⁴ s、π = 3.14、'
        '∛(5.66×10²⁵) = 3.84×10⁸ とする。'
        '月の質量は地球に比べて無視できる。',
    answerValue: 3.84e8,
    answerUnit: 'm',
    answerDisplay: '3.84×10^8',
    unitChoices: ['m', 's', 'm/s', 'm/s^2'],
    hint: '月は地球のまわりを、与えられた周期でまわり続けている。地表の重力加速度と、地球の半径も与えられている。',
    approach: 'ケプラー第3法則 T² = 4π² a³ / GM を使う。GM は地表の重力加速度から出す。',
    firstStep: '(27.3 × 8.64×10⁴)² = 4 × (3.14)² × a³ / (9.8 × (6.4×10⁶)²) である。',
    explanation:
        'ケプラー第3法則は T² = 4π² a³ / GM である。'
        '地表では重力加速度の大きさが g = GM / R² なので、GM = g R²。'
        'したがって T² = 4π² a³ / (g R²)。'
        'a³ = g R² T² / (4π²)。'
        'T = 27.3 × 8.64×10⁴ = 2.35872×10⁶ s。'
        'R² = (6.4×10⁶)² = 4.096×10¹³。'
        'g R² = 9.8 × 4.096×10¹³ = 4.01408×10¹⁴。'
        'T² = (2.35872×10⁶)² = 5.56356×10¹²。'
        'g R² T² = 4.01408×10¹⁴ × 5.56356×10¹² = 2.23325×10²⁷。'
        '4π² = 4 × (3.14)² = 4 × 9.8596 = 39.4384。'
        'a³ = 2.23325×10²⁷ / 39.4384 = 5.66×10²⁵。'
        '∛(5.66×10²⁵) = 3.84×10⁸ なので、a = 3.84×10⁸ m。',
  ),
  PhysicsProblem(
    id: '1de21279-b406-41f8-a86d-4da5a47293f9',
    theme: '斜方投射の飛距離',
    title: '遠投の初速',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.longThrow,
    statement:
        '図のように、地面から 45° の向きにボールを投げたところ、'
        '90 m 先の地面に落ちた。投げ出したときの速さを、時速の km で答えよ。\n'
        '※重力加速度の大きさを 10 m/s² とし、空気抵抗は無視する。',
    answerValue: 108,
    answerUnit: 'km/h',
    answerDisplay: '108',
    unitChoices: [],
    unitObvious: true,
    hint: '投げた場所と落ちた場所は、同じ地面の上にある。地面との角度は 45° である。',
    approach: '斜方投射の飛距離 R = v₀² sin 2θ / g を使う。',
    firstStep: '90 = v₀² × sin 90° / 10 である。',
    explanation:
        '斜方投射で、投げ出した高さと落ちた高さが同じときの飛距離は '
        'R = v₀² sin 2θ / g である。'
        'θ = 45° なので 2θ = 90°、sin 90° = 1。'
        '90 = v₀² × 1 / 10。'
        'v₀² = 900。v₀ = 30 m/s。'
        '時速は 30 × 3.6 = 108 km/h。',
  ),
  PhysicsProblem(
    id: '2984b8a0-e30c-4106-8dbe-4d790b4bde61',
    theme: '軌道半径と公転周期から中心の質量',
    title: '太陽の質量',
    domains: {PhysicsDomain.mechanics},
    figure: ProblemFigure.sunOrbit,
    statement:
        '図のように、地球は太陽のまわりを円運動している。太陽の質量を答えよ。\n'
        '※地球の公転半径を 1.50×10¹¹ m、公転周期を 365.6 日、1日を 8.64×10⁴ s、'
        '万有引力定数を 6.67×10⁻¹¹ N·m²/kg²、π = 3.14 とする。'
        '地球の質量は太陽に比べて無視できる。',
    answerValue: 2.0e30,
    answerUnit: 'kg',
    answerDisplay: '2.0×10^30',
    unitChoices: ['kg', 'm', 's', 'N'],
    hint: '地球は太陽のまわりを、与えられた半径と周期でまわり続けている。万有引力定数も与えられている。',
    approach: 'ケプラー第3法則 T² = 4π² a³ / GM を使う。',
    firstStep:
        '(365.6 × 8.64×10⁴)² = 4 × (3.14)² × (1.50×10¹¹)³ / (6.67×10⁻¹¹ × M) である。',
    explanation:
        'ケプラー第3法則は T² = 4π² a³ / GM である。'
        '地球の質量を無視すると、M は太陽の質量である。'
        'M = 4π² a³ / (G T²)。'
        'T = 365.6 × 8.64×10⁴ = 3.158784×10⁷ s。'
        'T² = (3.158784×10⁷)² = 9.97791×10¹⁴。'
        'a³ = (1.50×10¹¹)³ = 3.375×10³³。'
        '4π² = 4 × (3.14)² = 4 × 9.8596 = 39.4384。'
        '4π² a³ = 39.4384 × 3.375×10³³ = 1.33105×10³⁵。'
        'G T² = 6.67×10⁻¹¹ × 9.97791×10¹⁴ = 6.65527×10⁴。'
        'M = 1.33105×10³⁵ / 6.65527×10⁴ = 2.0×10³⁰ kg。',
  ),
  PhysicsProblem(
    id: '960df344-a24b-4174-821c-9ddbcdce5631',
    theme: '理想気体の状態方程式',
    title: '空気を抜いたあとの秤の減り',
    domains: {PhysicsDomain.thermodynamics},
    figure: ProblemFigure.evacuatedCylinder,
    statement:
        '図のように、円柱の容器に入った乾燥空気をほぼ真空になるまで抜いた。'
        '秤の示す値は何 g 減るか。\n'
        '※理想気体とみなし、乾燥空気のモル質量を 29 g/mol、'
        '気体定数を R = 8.31 J/(mol·K)、π = 3.14、0℃ = 273 K、'
        'はじめの気圧を 1.0×10⁵ Pa とする。容器の外側の体積は変わらない。',
    answerValue: 2.90,
    answerUnit: 'g',
    answerDisplay: '2.90',
    unitChoices: ['g', 'mol', 'hPa', 'J'],
    hint:
        '容器の外側は変わっていない。秤が減るのは、中から出ていった空気の分である。'
        '温度と容積は、抜く前後で同じである。',
    approach: '理想気体の状態方程式 pV = nRT を、抜く前と抜いたあとに使う。',
    firstStep: '1.0×10⁵ × V = Δn × 8.31 × 300 である。',
    explanation:
        '理想気体の状態方程式は pV = nRT である。'
        'ほぼ真空まで抜くので、出ていく物質量ははじめの物質量に等しい。'
        'Δn = p V / (R T)。秤の減りは Δm = Δn M である。'
        '容器の外側の体積は変わらないので、浮力は変わらない。'
        '27℃ は 27 + 273 = 300 K。'
        '円柱の容積は V = π r² h = 3.14 × (0.050)² × 0.318。'
        '(0.050)² = 0.0025。'
        'V = 3.14 × 0.0025 × 0.318 = 2.4963×10⁻³ m³。'
        'Δm = 1.0×10⁵ × 2.4963×10⁻³ × 29 / (8.31 × 300)'
        ' = 7240.77 / 2493 = 2.90 g。',
  ),
  ...noteArticleProblems,
];
