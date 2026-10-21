import 'physics_domain.dart';

/// 仮の問題のうち、図が必要なものだけを描く。
enum ProblemFigure {
  stackedBlocks,
  seriesCircuit,
  openPipe,
  slidingComparison,
  resistorCurrent,
  springPulleys,
  compressedSpring,
  acResistor,
  inclinePull,
  batteryResistor,
  seriesCurrent,
  parallelCurrent,
  bridgeVoltageDrop,
  isothermalGas,
  isobaricGas,
  isochoricGas,
  adiabaticGas,
  connectedVessels,
  diatomicVessels,
  verticalSpringOscillation,
  simplePendulum,
  keplerOrbits,
  beats,
}

/// ヒントボタンで、灰色の問題カードの中に足すもの。
///
/// 問題ごとに選ぶ。新しい出し方はここに足し、カード側の描画とセットで実装する。
enum HintReveal {
  /// [PhysicsProblem.hint] の文章だけを出す。
  message,

  /// 積み重なった物体AとBをひとまとめにするアニメと、ヒントの文章を出す。
  groupUpperBlocks,

  /// 自由端反射のアニメと、ヒントの文章を出す。図はヒントを開くまで出さない。
  freeEndReflection,

  /// 固定端反射のアニメと、ヒントの文章を出す。図はヒントを開くまで出さない。
  fixedEndReflection,
}

/// 単位の入れ方。解答の書き方で切り替える。
enum UnitInputKind { base, choices, omitted }

class PhysicsProblem {
  const PhysicsProblem({
    required this.id,
    required this.theme,
    required this.domains,
    required this.statement,
    required this.answerValue,
    required this.answerUnit,
    required this.answerDisplay,
    required this.unitChoices,
    required this.hint,
    required this.approach,
    required this.firstStep,
    required this.explanation,
    this.figure,
    this.hintReveal = HintReveal.message,
    this.symbolChoices = const [],
    this.symbolOrder = '',
    this.unitObvious = false,
  });

  final String id;

  /// この問題が練習するテーマ。下敷きの項目名と揃える。問題文には出さない。
  final String theme;

  final Set<PhysicsDomain> domains;
  final String statement;
  final ProblemFigure? figure;

  /// 採点に使う数値。
  final double answerValue;

  /// 空文字は無次元。空白・`^`・`/` を含むときは組み立て電卓。
  final String answerUnit;

  /// 不正解のとき、および答えを見るときに見せる数値の表示。
  final String answerDisplay;

  /// 短い単位のときだけ使う候補。組み立て電卓の問題では空。
  final List<String> unitChoices;

  final String hint;

  /// ヒントボタンを押したときの出し方。省略すると文章だけが出る。
  final HintReveal hintReveal;

  final String approach;
  final String firstStep;
  final String explanation;

  /// 左から並べる問題の候補。空なら数値問題。
  final List<String> symbolChoices;

  /// 正しい並び。[answerDisplay] と同じでよい。空白・読点は採点時に無視する。
  final String symbolOrder;

  /// 単位が問題文から自明なとき、数値だけで確定する。
  final bool unitObvious;

  bool get isSymbolOrder => symbolChoices.isNotEmpty;

  bool get isDimensionless => answerUnit.trim().isEmpty;

  UnitInputKind get unitInputKind {
    if (unitObvious) return UnitInputKind.omitted;
    final unit = answerUnit.trim();
    if (unit.contains(' ') || unit.contains('^') || unit.contains('/')) {
      return UnitInputKind.base;
    }
    return UnitInputKind.choices;
  }

  String get answerUnitLabel {
    if (isSymbolOrder) return '';
    return isDimensionless ? '無次元' : answerUnit;
  }
}
