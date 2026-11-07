// 問題配列から一覧PDFを書く。
//
//   tool/export_problem_catalog.sh
//
// 出力は build/problem_catalog.pdf。
// 並びは力学、熱力学、波動、電磁気、原子。番号は表示番号のまま。
// 単元の中は、単元マスター（2026年1月）の章順。単元が終わると改ページする。
// 文字は tool/fonts/catalog.ttf。別の .ttf は CATALOG_FONT、
// 出力先は CATALOG_OUT で変えられる。
// catalog.ttf に無い字は、あれば Arial Unicode で補う。
// ignore_for_file: avoid_print

import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vector_math/vector_math_64.dart' hide Colors;
import 'package:physics_gacha/data/sample_problems.dart';
import 'package:physics_gacha/l10n/app_localizations.dart';
import 'package:physics_gacha/models/physics_domain.dart';
import 'package:physics_gacha/models/physics_problem.dart';
import 'package:physics_gacha/ui/fixed_end_reflection_figure.dart';
import 'package:physics_gacha/ui/free_end_reflection_figure.dart';
import 'package:physics_gacha/ui/problem_figure_view.dart';
import 'package:physics_gacha/utils/figure_label_style.dart';

const _fontCandidates = ['tool/fonts/catalog.ttf'];

void main() {
  late pw.Font font;
  late List<pw.Font> fontFallback;
  late List<int> fontBytes;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    figureLabelFontFamily = 'Catalog';
    fontBytes = _readFont();
    final data = ByteData.sublistView(Uint8List.fromList(fontBytes));
    final loader = FontLoader('Catalog')..addFont(Future.value(data));
    await loader.load();
    font = pw.Font.ttf(data);
    fontFallback = _fallbackFonts();
  });

  testWidgets('問題一覧PDFを書く', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 1400));
    final images = <int, Uint8List>{};
    for (var i = 0; i < sampleProblems.length; i++) {
      final figure = _catalogFigure(sampleProblems[i]);
      if (figure == null) continue;
      images[i] = await _capture(tester, figure);
      print('図 ${i + 1}/${sampleProblems.length}');
    }

    print('PDFを書いています');
    final outPath =
        Platform.environment['CATALOG_OUT'] ?? 'build/problem_catalog.pdf';
    final file = File(outPath);
    file.parent.createSync(recursive: true);
    // save() は別 isolate に逃す。ファイルの非同期書き込みも、
    // flutter test の偽の非同期では完了しない。どちらも同期で書く。
    final stream = PdfStream();
    await _document(font, fontFallback, images).write(stream);
    file.writeAsBytesSync(stream.output(), flush: true);
    print(file.absolute.path);
  }, timeout: const Timeout(Duration(minutes: 5)));
}

List<int> _readFont() {
  final fromEnv = Platform.environment['CATALOG_FONT'];
  final paths = [
    if (fromEnv != null && fromEnv.isNotEmpty) fromEnv,
    ..._fontCandidates,
  ];
  for (final path in paths) {
    final file = File(path);
    if (file.existsSync()) return file.readAsBytesSync();
  }
  throw StateError(
    '日本語フォントが見つからない。CATALOG_FONT に .ttf のパスを指定する。'
    '探した場所: ${paths.join(', ')}',
  );
}

List<pw.Font> _fallbackFonts() {
  const paths = ['/Library/Fonts/Arial Unicode.ttf'];
  final fonts = <pw.Font>[];
  for (final path in paths) {
    final file = File(path);
    if (!file.existsSync()) continue;
    fonts.add(pw.Font.ttf(ByteData.sublistView(file.readAsBytesSync())));
  }
  return fonts;
}

Widget? _catalogFigure(PhysicsProblem problem) {
  final figure = problem.figure;
  if (figure != null) return problemFigureView(figure);
  return switch (problem.hintReveal) {
    HintReveal.freeEndReflection => const FreeEndReflectionFigure(),
    HintReveal.fixedEndReflection => const FixedEndReflectionFigure(),
    HintReveal.message || HintReveal.groupUpperBlocks => null,
  };
}

Future<Uint8List> _capture(WidgetTester tester, Widget figure) async {
  await tester.pumpWidget(
    MaterialApp(
      locale: const Locale('ja'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: RepaintBoundary(
            key: const Key('catalog-shot'),
            child: ColoredBox(color: Colors.white, child: figure),
          ),
        ),
      ),
    ),
  );
  final shot = tester.element(find.byKey(const Key('catalog-shot')));
  await tester.runAsync(() async {
    for (final image in tester.widgetList<Image>(find.byType(Image))) {
      await precacheImage(image.image, shot);
    }
  });
  await tester.pump();
  final boundary = tester.renderObject(
    find.byKey(const Key('catalog-shot')),
  ) as RenderRepaintBoundary;
  late Uint8List png;
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 2);
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    png = data!.buffer.asUint8List();
  });
  return png;
}

pw.Document _document(
  pw.Font font,
  List<pw.Font> fontFallback,
  Map<int, Uint8List> images,
) {
  final theme = pw.ThemeData.withFont(
    base: font,
    bold: font,
    fontFallback: fontFallback,
  );
  final doc = pw.Document(theme: theme);
  const body = pw.TextStyle(fontSize: 10.5, lineSpacing: 3, wordSpacing: 0);
  const label = pw.TextStyle(fontSize: 10.5, color: PdfColors.blueGrey800);
  const title = pw.TextStyle(fontSize: 14, wordSpacing: 0);
  const meta = pw.TextStyle(
    fontSize: 9,
    color: PdfColors.grey700,
    wordSpacing: 0,
  );
  const indexStyle = pw.TextStyle(fontSize: 9, lineSpacing: 2, wordSpacing: 0);
  const indexAnswer = pw.TextStyle(
    fontSize: 9,
    lineSpacing: 2,
    wordSpacing: 0,
    color: PdfColors.red,
  );
  const answerStyle = pw.TextStyle(
    fontSize: 12,
    wordSpacing: 0,
    color: PdfColors.red,
  );

  final grouped = _groupedProblems();
  const section = pw.TextStyle(fontSize: 12, wordSpacing: 0);

  pw.MultiPage pages({
    required String headerLabel,
    required List<pw.Widget> Function(pw.Context context) build,
  }) {
    return pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      maxPages: 80,
      margin: const pw.EdgeInsets.fromLTRB(40, 36, 40, 40),
      header: (context) => pw.Container(
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Text('$headerLabel  ${context.pageNumber}', style: meta),
      ),
      build: build,
    );
  }

  doc.addPage(
    pages(
      headerLabel: '問題一覧',
      build: (context) => [
        pw.Text('問題一覧', style: title, lineSplitter: _splitLine),
        pw.SizedBox(height: 4),
        pw.Text(
          '${sampleProblems.length}問。番号はアプリの表示番号。単元ごとにまとめている。',
          style: meta,
          lineSplitter: _splitLine,
        ),
        pw.SizedBox(height: 6),
        for (final domain in PhysicsDomain.values)
          if (grouped[domain]!.isNotEmpty) ...[
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
              child: pw.Text(
                _sectionName(domain),
                style: section,
                lineSplitter: _splitLine,
              ),
            ),
            for (final item in grouped[domain]!)
              _indexRow(item, indexStyle, indexAnswer),
          ],
      ],
    ),
  );

  for (final domain in PhysicsDomain.values) {
    final items = grouped[domain]!;
    if (items.isEmpty) continue;
    final name = _sectionName(domain);
    doc.addPage(
      pages(
        headerLabel: name,
        build: (context) => [
          pw.Text(name, style: title, lineSplitter: _splitLine),
          pw.SizedBox(height: 2),
          pw.Text('${items.length}問', style: meta, lineSplitter: _splitLine),
          pw.SizedBox(height: 6),
          for (final item in items)
            ..._problemBlock(
              number: item.number,
              problem: item.problem,
              png: images[item.index],
              title: title,
              meta: meta,
              label: label,
              body: body,
              answerStyle: answerStyle,
            ),
        ],
      ),
    );
  }
  return doc;
}

/// 融合問題は、単元の並びで先に来る方に一度だけ置く。
Map<PhysicsDomain, List<_CatalogItem>> _groupedProblems() {
  final grouped = {
    for (final domain in PhysicsDomain.values) domain: <_CatalogItem>[],
  };
  for (var i = 0; i < sampleProblems.length; i++) {
    final problem = sampleProblems[i];
    grouped[_primaryDomain(problem)]!.add(_CatalogItem(i, problem));
  }
  for (final items in grouped.values) {
    items.sort((a, b) {
      final byTopic = _topicRank(a.problem.theme).compareTo(
        _topicRank(b.problem.theme),
      );
      if (byTopic != 0) return byTopic;
      return a.index.compareTo(b.index);
    });
  }
  return grouped;
}

/// 単元マスター（2026年1月時点）の章番号を 100 倍した位置。
/// 表に無い項目は、入る章のあいだに置いている。
const _topicRanks = <String, int>{
  // 力学。表は 1 モーメントから始まる。力とエネルギーはそれより前。
  '運動方程式（ニュートン第2法則）': 10,
  '力のつり合い': 20,
  '仕事とエネルギー': 30,
  '熱量': 40,
  // 3 水平投射、4 斜方投射より前に、自由落下を置く。
  '等加速度運動の位置': 250,
  '等加速度運動の速度': 260,
  '斜方投射の飛距離': 270,
  // 単振動。ばねの静的な関係を、振動の前に置く。万有引力・ケプラーより前。
  'フックの法則': 900,
  '直列の合成ばね': 910,
  '並列の合成ばね': 920,
  '鉛直ばねの単振動の周期': 930,
  '単振り子の周期': 940,
  // 10 万有引力の法則、11 ケプラーの法則。
  '万有引力による重力場': 1000,
  '万有引力定数 [N·m^2/kg^2]': 1010,
  'ケプラー第3法則': 1100,
  '公転周期から軌道半径': 1110,
  '軌道半径と公転周期から中心の質量': 1120,
  // 熱力学。14 状態方程式、16 熱力学第一法則、17 定圧、18 定積、19 等温、20 断熱。
  '理想気体の状態方程式': 1400,
  '熱力学第1法則': 1600,
  '気体の内部エネルギー': 1610,
  '2原子理想気体のモル比熱': 1620,
  '等圧変化（シャルルの法則）': 1700,
  '等積変化': 1800,
  '等温変化（ボイルの法則）': 1900,
  '断熱変化（ポアソンの式）': 2000,
  // 波動。21 正弦波の近くに反射、23 ドップラーの前に音波、24 屈折の前に光の種類。
  '自由端反射の節': 2110,
  '固定端反射の節': 2120,
  '気柱の振動（閉管の共鳴）': 2250,
  '開口端補正のある閉管の共鳴': 2260,
  'うなり': 2280,
  '電磁波の波長の順': 2350,
  // 電磁気。35 平行板の前に容量の定義、36 接続、39 電流、40 オーム、
  // 41 電力量、42 抵抗の接続、45 キルヒホッフ、57 実効値。
  '静電容量の定義 [F]': 3490,
  '平行板コンデンサーの電気容量': 3500,
  '誘電率と比誘電率': 3520,
  'コンデンサーの合成容量': 3600,
  '並列の合成容量': 3610,
  '電流の定義 [A]': 3900,
  '電気抵抗の定義（オームの法則）': 4000,
  '電力 [W]': 4100,
  '合成抵抗': 4200,
  '並列の合成抵抗': 4210,
  'ブリッジ形回路の電圧降下': 4500,
  '電流・電圧の実効値の定義': 5700,
  // 原子。72 半減期。
  '放射性崩壊と半減期': 7200,
  '金属結晶の原子半径': 7300,
  '力のモーメントのつり合い': 15,
  '重心の定義 [m]': 16,
  '切り取った板の重心': 17,
  '滑りと傾きの境': 18,
  '動摩擦力': 45,
  '最大静止摩擦力': 46,
  '浮力（アルキメデスの原理）': 47,
  '水中で減る張力': 48,
  'ヘリウムが持ち上げる質量': 49,
  '遠心力': 70,
  '加速系で現れる慣性力': 75,
  '地上重力による位置エネルギー': 80,
  '等速円運動の周期': 800,
  '単振動の力学的エネルギー': 950,
  'ばねの弾性エネルギー': 955,
  '振り子の最下点の速さ': 960,
  '振り子の最下点の張力': 965,
  '地上の重力加速度 [m/s^2]': 1020,
  '高さによる気圧': 1030,
  '流体中の圧力': 480,
  '圧力の定義 [Pa]': 490,
  '開いた水面下の圧力': 500,
  '閉じた水柱の上端の圧力': 510,
  '食塩水中の圧力': 520,
  '弦を伝わる波（両側固定端）': 2130,
  '共振する弦の張力': 2140,
  '音速の温度係数': 2270,
  'ドップラー効果（観測者と波源が動く場合）': 2290,
  '二つの音源の経路差': 2295,
  '単スリットの暗線': 2360,
  '回折格子の光路差と位相': 2370,
  '導体の電気抵抗': 4020,
  '抵抗率の温度依存性': 4030,
  '円形電流が作る軸上の磁場': 5300,
  'ソレノイドコイルの自己インダクタンス': 5400,
  '電流が磁場から受ける力': 5500,
  'RC回路の方程式の解': 5600,
};

int _topicRank(String theme) {
  final rank = _topicRanks[theme];
  if (rank == null) throw StateError('一覧の順番に無い: $theme');
  return rank;
}

PhysicsDomain _primaryDomain(PhysicsProblem problem) {
  for (final domain in PhysicsDomain.values) {
    if (problem.domains.contains(domain)) return domain;
  }
  throw StateError('単元がない: ${problem.theme}');
}

String _sectionName(PhysicsDomain domain) => switch (domain) {
  PhysicsDomain.mechanics => '力学',
  PhysicsDomain.thermodynamics => '熱力学',
  PhysicsDomain.waves => '波動',
  PhysicsDomain.electromagnetism => '電磁気',
  PhysicsDomain.atom => '原子',
};

class _CatalogItem {
  const _CatalogItem(this.index, this.problem);

  final int index;
  final PhysicsProblem problem;

  int get number => index + 1;
}

pw.Widget _indexRow(
  _CatalogItem item,
  pw.TextStyle indexStyle,
  pw.TextStyle indexAnswer,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 3),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 28,
          child: pw.Text(
            '${item.number}',
            style: indexStyle,
            lineSplitter: _splitLine,
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            _pdfText(item.problem.title),
            style: indexStyle,
            lineSplitter: _splitLine,
          ),
        ),
        pw.SizedBox(
          width: 168,
          child: pw.Text(
            _pdfText(_answer(item.problem)),
            style: indexAnswer,
            textAlign: pw.TextAlign.right,
            lineSplitter: _splitLine,
          ),
        ),
      ],
    ),
  );
}

List<pw.Widget> _problemBlock({
  required int number,
  required PhysicsProblem problem,
  required Uint8List? png,
  required pw.TextStyle title,
  required pw.TextStyle meta,
  required pw.TextStyle label,
  required pw.TextStyle body,
  required pw.TextStyle answerStyle,
}) {
  return [
    pw.Divider(color: PdfColors.grey400, height: 16),
    pw.Text(
      'No. $number  ${_pdfText(problem.title)}',
      style: title,
      lineSplitter: _splitLine,
    ),
    pw.SizedBox(height: 2),
    pw.Text(_domains(problem), style: meta, lineSplitter: _splitLine),
    pw.SizedBox(height: 6),
    if (png == null) ...[
      _framed(
        labelText: '問題',
        text: problem.statement,
        label: label,
        body: body,
      ),
      pw.SizedBox(height: 8),
      pw.Text(
        '答え  ${_pdfText(_answer(problem))}',
        style: answerStyle,
        lineSplitter: _splitLine,
      ),
      pw.SizedBox(height: 8),
      _framed(
        labelText: '解説',
        text: problem.explanation,
        label: label,
        body: body,
      ),
    ] else
      _BesideFigure(
        png: png,
        statement: problem.statement,
        answer: _answer(problem),
        explanation: problem.explanation,
        label: label,
        body: body,
        answerStyle: answerStyle,
      ),
    pw.SizedBox(height: 8),
  ];
}

pw.Widget _framed({
  required String? labelText,
  required String text,
  required pw.TextStyle label,
  required pw.TextStyle body,
}) {
  return pw.Container(
    width: double.infinity,
    padding: const pw.EdgeInsets.fromLTRB(8, 6, 8, 7),
    decoration: pw.BoxDecoration(
      border: pw.Border.all(color: PdfColors.grey600, width: 0.8),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          pw.Text(labelText, style: label),
          pw.SizedBox(height: 3),
        ],
        pw.Text(_pdfText(text), style: body, lineSplitter: _splitLine),
      ],
    ),
  );
}

const _besideGap = 8.0;
const _framePadH = 16.0;

/// 図を左1/3に置き、問題・答え・解説を右2/3から回り込ませる。
class _BesideFigure extends pw.Widget {
  _BesideFigure({
    required Uint8List png,
    required this.statement,
    required this.answer,
    required this.explanation,
    required this.label,
    required this.body,
    required this.answerStyle,
  }) : _image = pw.Image(pw.MemoryImage(png), fit: pw.BoxFit.contain);

  final String statement;
  final String answer;
  final String explanation;
  final pw.TextStyle label;
  final pw.TextStyle body;
  final pw.TextStyle answerStyle;
  final pw.Image _image;
  final _paint = <pw.Widget>[];

  @override
  void layout(
    pw.Context context,
    pw.BoxConstraints constraints, {
    bool parentUsesSize = false,
  }) {
    _paint.clear();
    final maxW = constraints.maxWidth;
    final leftW = (maxW - _besideGap) / 3;
    final rightW = maxW - leftW - _besideGap;
    _image.layout(
      context,
      pw.BoxConstraints(maxWidth: leftW, maxHeight: constraints.maxHeight),
    );
    final imageH = _image.box!.height;
    final font = pw.Theme.of(context).defaultTextStyle.font!.getFont(context);
    final side = <pw.Widget>[];
    final below = <pw.Widget>[];
    var sideUsed = 0.0;
    var beside = true;

    bool fits(double height) {
      final gap = side.isEmpty ? 0.0 : _besideGap;
      return sideUsed + gap + height <= imageH + 0.5;
    }

    void addSide(pw.Widget widget) {
      if (side.isNotEmpty) sideUsed += _besideGap;
      side.add(widget);
      sideUsed += widget.box!.height;
    }

    void addBelow(pw.Widget widget) {
      below.add(widget);
      beside = false;
    }

    pw.Widget framed(String? labelText, String text) {
      return _framed(
        labelText: labelText,
        text: text,
        label: label,
        body: body,
      );
    }

    void layoutAt(pw.Widget widget, double width) {
      widget.layout(
        context,
        pw.BoxConstraints.tightFor(width: width),
        parentUsesSize: true,
      );
    }

    /// 右列に収まれば true。はみ出すときは図の高さで切って残りを下に置く。
    bool placeText({
      required String? labelText,
      required String text,
      required bool allowSplit,
    }) {
      if (!beside) {
        final widget = framed(labelText, text);
        layoutAt(widget, maxW);
        addBelow(widget);
        return false;
      }
      final whole = framed(labelText, text);
      layoutAt(whole, rightW);
      final gap = side.isEmpty ? 0.0 : _besideGap;
      final overflow = sideUsed + gap + whole.box!.height - imageH;
      if (overflow <= 0.5 || overflow <= 40) {
        addSide(whole);
        return true;
      }
      if (!allowSplit) {
        final widget = framed(labelText, text);
        layoutAt(widget, maxW);
        addBelow(widget);
        return false;
      }
      final room = imageH - sideUsed - (side.isEmpty ? 0.0 : _besideGap);
      final guess = math.max(1, (room / 11).ceil());
      final inner = rightW - _framePadH;
      for (var lines = guess; lines >= 1; lines--) {
        final cut = _cutLines(text, inner, lines, font, body.fontSize ?? 10.5);
        if (cut.lines.isEmpty) continue;
        final head = framed(labelText, cut.lines.join('\n'));
        layoutAt(head, rightW);
        if (!fits(head.box!.height)) continue;
        addSide(head);
        if (cut.rest.trim().isEmpty) return true;
        final tail = framed(null, cut.rest);
        layoutAt(tail, maxW);
        addBelow(tail);
        return false;
      }
      final widget = framed(labelText, text);
      layoutAt(widget, maxW);
      addBelow(widget);
      return false;
    }

    bool placeAnswer() {
      pw.Widget answerWidget() {
        return pw.Text(
          '答え  ${_pdfText(answer)}',
          style: answerStyle,
          lineSplitter: _splitLine,
        );
      }

      if (!beside) {
        final widget = answerWidget();
        layoutAt(widget, maxW);
        addBelow(widget);
        return false;
      }
      final besideAnswer = answerWidget();
      layoutAt(besideAnswer, rightW);
      if (fits(besideAnswer.box!.height)) {
        addSide(besideAnswer);
        return true;
      }
      final widget = answerWidget();
      layoutAt(widget, maxW);
      addBelow(widget);
      return false;
    }

    final problemBeside = placeText(
      labelText: '問題',
      text: statement,
      allowSplit: true,
    );
    if (problemBeside) {
      final answerBeside = placeAnswer();
      placeText(labelText: '解説', text: explanation, allowSplit: answerBeside);
    } else {
      placeAnswer();
      placeText(labelText: '解説', text: explanation, allowSplit: false);
    }

    final blockH = math.max(imageH, sideUsed);
    var belowH = 0.0;
    for (var i = 0; i < below.length; i++) {
      if (i > 0) belowH += _besideGap;
      belowH += below[i].box!.height;
    }
    final beforeBelow = below.isEmpty ? 0.0 : _besideGap;
    final totalH = blockH + beforeBelow + belowH;
    box = PdfRect(0, 0, maxW, totalH);

    final imgW = _image.box!.width;
    final imgH = _image.box!.height;
    _image.box = PdfRect(
      math.max(0, (leftW - imgW) / 2),
      totalH - imgH,
      imgW,
      imgH,
    );
    _paint.add(_image);

    var y = 0.0;
    for (var i = 0; i < side.length; i++) {
      final widget = side[i];
      final h = widget.box!.height;
      widget.box = PdfRect(
        leftW + _besideGap,
        totalH - y - h,
        widget.box!.width,
        h,
      );
      y += h;
      if (i != side.length - 1) y += _besideGap;
      _paint.add(widget);
    }

    y = blockH + beforeBelow;
    for (var i = 0; i < below.length; i++) {
      final widget = below[i];
      final h = widget.box!.height;
      widget.box = PdfRect(0, totalH - y - h, widget.box!.width, h);
      y += h;
      if (i != below.length - 1) y += _besideGap;
      _paint.add(widget);
    }
  }

  @override
  void paint(pw.Context context) {
    super.paint(context);
    final mat = Matrix4.identity();
    mat.translateByDouble(box!.left, box!.bottom, 0, 1);
    context.canvas
      ..saveContext()
      ..setTransform(mat);
    for (final widget in _paint) {
      widget.paint(context);
    }
    context.canvas.restoreContext();
  }
}

class _LineCut {
  const _LineCut(this.lines, this.rest);

  final List<String> lines;
  final String rest;
}

_LineCut _cutLines(
  String text,
  double maxWidth,
  int maxLines,
  PdfFont font,
  double fontSize,
) {
  final lines = <String>[];
  var rest = text;
  while (lines.length < maxLines && rest.isNotEmpty) {
    final next = _nextLine(rest, maxWidth, font, fontSize);
    if (next.$2 == rest) break;
    lines.add(next.$1);
    rest = next.$2;
  }
  return _LineCut(lines, rest);
}

(String, String) _nextLine(
  String text,
  double maxWidth,
  PdfFont font,
  double fontSize,
) {
  if (text.startsWith('\n')) return ('', text.substring(1));
  final breakAt = text.indexOf('\n');
  final para = breakAt == -1 ? text : text.substring(0, breakAt);
  final words = _splitLine(para);
  final line = StringBuffer();
  var width = 0.0;
  var used = 0;
  for (final word in words) {
    if (line.isEmpty && word == ' ') {
      used += word.length;
      continue;
    }
    final wordWidth = _textWidth(word, font, fontSize);
    if (line.isNotEmpty && width + wordWidth > maxWidth + 0.1) break;
    line.write(word);
    width += wordWidth;
    used += word.length;
  }
  if (line.isEmpty && words.isNotEmpty) {
    line.write(words.first);
    used = words.first.length;
  }
  if (used >= para.length) {
    final rest = breakAt == -1 ? '' : text.substring(breakAt + 1);
    return (line.toString(), rest);
  }
  return (line.toString(), text.substring(used));
}

double _textWidth(String text, PdfFont font, double fontSize) {
  if (text.isEmpty) return 0;
  return (font.stringMetrics(text) * fontSize).advanceWidth;
}

String _answer(PhysicsProblem problem) {
  if (problem.isSymbolOrder) return problem.symbolOrder;
  if (problem.isDimensionless) return '${problem.answerDisplay}（無次元）';
  final unit = problem.answerUnit.trim();
  // '1' は無次元キーだが、答えに付けると数値に見えるので出さない。
  if (unit.isEmpty || unit == '1') return problem.answerDisplay;
  return '${problem.answerDisplay} $unit';
}

String _domains(PhysicsProblem problem) {
  return [
    for (final domain in PhysicsDomain.values)
      if (problem.domains.contains(domain)) _sectionName(domain),
  ].join('・');
}

/// 日本語は空白で区切られないので、漢字・仮名は1文字ずつ折り返す。
/// 数式は途中で割れないよう、まとめて1語にする。空白そのものの幅は残す。
List<String> _splitLine(String line) {
  final words = <String>[];
  final buf = StringBuffer();
  void flush() {
    if (buf.isEmpty) return;
    words.add(buf.toString());
    buf.clear();
  }

  for (final rune in line.runes) {
    if (rune == 0x20 || rune == 0x3000) {
      flush();
      words.add(String.fromCharCode(rune));
      continue;
    }
    if (_sticksToPrevious(rune)) {
      if (buf.isNotEmpty) {
        buf.writeCharCode(rune);
      } else if (words.isNotEmpty) {
        words[words.length - 1] = '${words.last}${String.fromCharCode(rune)}';
      } else {
        words.add(String.fromCharCode(rune));
      }
      continue;
    }
    if (_isIdeograph(rune)) {
      flush();
      words.add(String.fromCharCode(rune));
      continue;
    }
    buf.writeCharCode(rune);
  }
  flush();
  return words;
}

bool _isIdeograph(int rune) {
  if (rune >= 0x3000 && rune <= 0x30FF) return true;
  if (rune >= 0x4E00 && rune <= 0x9FFF) return true;
  if (rune >= 0xFF00 && rune <= 0xFFEF) return true;
  return false;
}

bool _sticksToPrevious(int rune) => '、。，．）】」』'.runes.contains(rune);

/// 一覧フォントに字形がない文字だけ、読める形に替える。
String _pdfText(String input) =>
    input.replaceAll('ᵀ', 'T').replaceAll('三', '3');
