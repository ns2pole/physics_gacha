import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/main.dart';
import 'package:physics_gacha/ui/fixed_end_reflection_figure.dart';
import 'package:physics_gacha/ui/free_end_reflection_figure.dart';
import 'package:physics_gacha/ui/stacked_blocks_figure.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('1問と答えを見るが出る', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    final title = tester.widget<Text>(find.text('物理ガチャ'));
    expect(title.style?.fontWeight, FontWeight.bold);
    expect(title.style?.fontSize, 26);
    final width = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(
      (tester.getCenter(find.text('物理ガチャ')).dx - width / 2).abs(),
      lessThan(24),
    );
    expect(
      tester.getCenter(find.text('問題一覧')).dx,
      greaterThan(tester.getCenter(find.text('物理ガチャ')).dx),
    );
    expect(tester.widget<Text>(find.text('問題一覧')).style?.fontSize, 16);
    expect(
      tester.getRect(find.widgetWithText(OutlinedButton, '問題一覧')).right,
      closeTo(tester.getRect(find.widgetWithText(InkWell, 'ガチャを回す')).right, 1),
    );
    expect(find.byIcon(Icons.settings), findsNothing);
    expect(find.text('ガチャを回す'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('ガチャを回す')).dy,
      greaterThan(tester.getTopLeft(find.text('物理ガチャ')).dy),
    );
    final appBar = tester.widget<AppBar>(find.byType(AppBar));
    expect(appBar.backgroundColor, Colors.transparent);
    expect(appBar.forceMaterialTransparency, isTrue);
    await tester.ensureVisible(find.text('答えを見る', skipOffstage: false));
    expect(find.text('答えを見る'), findsOneWidget);
    expect(find.text('ヒント'), findsOneWidget);
    expect(
      tester.getCenter(find.text('ヒント')).dx,
      lessThan(tester.getCenter(find.text('答えを見る')).dx),
    );
    expect(find.text('AIに聞く'), findsOneWidget);
    expect(find.text('問題一覧'), findsOneWidget);
    expect(find.byIcon(Icons.circle), findsNothing);
    expect(find.text('各枠の難易度を選択してください'), findsNothing);
  });

  testWidgets('単元の5つは1行に並ぶ', (tester) async {
    tester.view.physicalSize = const Size(360, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    final chips = ['力学', '熱力学', '波動', '電磁気学', '原子'];
    expect(find.byType(FilterChip), findsNothing);
    final top = tester.getTopLeft(find.text(chips.first)).dy;
    for (final label in chips.skip(1)) {
      expect(tester.getTopLeft(find.text(label)).dy, top);
    }
    expect(top, greaterThan(tester.getTopLeft(find.text('フィルタ設定')).dy));
    expect(top, lessThan(tester.getTopLeft(find.text('ならガチャから外す')).dy));
  });

  testWidgets('除外は青いフィルタから選ぶ', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    expect(find.text('フィルタ設定'), findsOneWidget);
    expect(find.text('ならガチャから外す'), findsOneWidget);
    expect(find.text('(残 15問/15問)'), findsOneWidget);

    await tester.tap(find.text('フィルタ設定'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('除外なし').last);
    await tester.pumpAndSettle();

    expect(find.text('ならガチャから外す'), findsNothing);
    expect(find.text('除外なし 全15問'), findsOneWidget);
  });

  testWidgets('詳細で問題と答えと解説が見える', (tester) async {
    await _openProblemList(tester);

    expect(find.text('No. 1'), findsOneWidget);
    expect(find.text('の問題を除く'), findsOneWidget);
    expect(find.text('(残 15問/15問)'), findsOneWidget);
    expect(find.text('出題'), findsNothing);
    expect(find.text('力学'), findsNothing);
    expect(find.widgetWithText(ElevatedButton, '詳細'), findsWidgets);

    await tester.scrollUntilVisible(find.text('No. 6'), 400);
    expect(find.text('No. 6'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('detail-sample-electromagnetism')),
      -400,
    );
    await tester.tap(
      find.byKey(const ValueKey('detail-sample-electromagnetism')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('電圧 12 V'), findsOneWidget);
    expect(find.text('12'), findsOneWidget);
    expect(find.text('W'), findsOneWidget);
    expect(
      find.text('直列なので、電流の通り道は一本になる。', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('合成抵抗を求め、電力の式 P = V²/R を使う。', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text('合成抵抗は R = 4.0 + 8.0 = 12 Ω である。', skipOffstage: false),
      findsOneWidget,
    );
    expect(
      find.text(
        '直列なので合成抵抗は R = 4.0 + 8.0 = 12 Ω。電源が供給する電力は P = V²/R = 12²/12 = 144/12 = 12 W。',
        skipOffstage: false,
      ),
      findsOneWidget,
    );
    expect(find.text('出題'), findsNothing);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('問題一覧'), findsOneWidget);
    expect(
      find.text('直列なので合成抵抗は R = 4.0 + 8.0 = 12 Ω。電源が供給する電力は P = V²/R = 12²/12 = 144/12 = 12 W。'),
      findsNothing,
    );
  });

  testWidgets('除外された問題は番号を残して隠す', (tester) async {
    await _openProblemList(tester);

    await tester.tap(find.byKey(const ValueKey('history-sample-mechanics-0')));
    await tester.pumpAndSettle();

    expect(find.text('No. 1'), findsNothing);
    expect(find.text('No. 2'), findsOneWidget);
    expect(find.text('(残 14問/15問)'), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('ならガチャから外す'), findsOneWidget);
    expect(find.text('除外なし 全15問'), findsNothing);
    expect(find.text('(残 14問/15問)'), findsOneWidget);
  });

  testWidgets('左が空の枠は進まず、単元オフでも一覧は全問', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('原子'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('問題一覧'));
    await tester.pumpAndSettle();

    expect(find.text('(残 15問/15問)'), findsOneWidget);
    final second = find.byKey(const ValueKey('history-sample-mechanics-1'));
    await tester.tap(second);
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: second, matching: find.byIcon(Icons.circle_outlined)),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.check_circle), findsNothing);
  });

  testWidgets('数値電卓は中央表示で、桁と×と10^だけ', (tester) async {
    await _showMechanics(tester);
    await _tapVisible(tester, find.byTooltip('電卓'));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.backspace_outlined), findsOneWidget);
    expect(find.text('AC'), findsOneWidget);
    expect(tester.widget<Text>(find.text('AC')).style?.color, Colors.white);
    final acButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'AC'),
    );
    expect(
      acButton.style?.backgroundColor?.resolve({}),
      const Color(0xFFD32F2F),
    );
    expect(find.text('×'), findsNothing);
    expect(find.text('×10^□'), findsNothing);
    expect(find.text('×10'), findsOneWidget);
    final powerHole = tester.widget<Text>(find.text('□'));
    expect(
      powerHole.style?.fontSize,
      lessThan(tester.widget<Text>(find.text('×10')).style!.fontSize!),
    );
    expect(
      tester.getCenter(find.text('AC')).dx,
      greaterThan(tester.getCenter(find.text('9')).dx),
    );
    expect(
      tester.getCenter(find.text('AC')).dy,
      lessThan(tester.getCenter(find.byIcon(Icons.backspace_outlined)).dy),
    );
    expect(
      tester.getSize(find.widgetWithText(FilledButton, '単位へ')).height,
      greaterThan(
        tester.getSize(find.widgetWithText(OutlinedButton, '1')).height * 1.8,
      ),
    );
    expect(find.text('π'), findsNothing);
    expect(find.text('log'), findsNothing);
    expect(find.text('e'), findsNothing);

    for (final label in ['4', '.', '0']) {
      await _tapVisible(tester, find.text(label));
    }
    await _tapVisible(tester, find.widgetWithText(OutlinedButton, '×10'));
    await _tapVisible(tester, find.text('5'));
    await tester.pumpAndSettle();

    expect(find.text('4.0'), findsOneWidget);
    expect(find.text('10'), findsOneWidget);
    expect(_superscript('5'), findsOneWidget);
    expect(_focused(_superscript('5')), findsOneWidget);

    await _tapVisible(tester, find.byIcon(Icons.backspace_outlined));
    await tester.pumpAndSettle();
    expect(_superscript('5'), findsNothing);
    expect(_focused(find.text('□')), findsOneWidget);

    await _tapVisible(tester, find.text('AC'));
    await tester.pumpAndSettle();
    expect(find.text('4.0'), findsNothing);
    expect(find.text('10'), findsNothing);
    expect(_focused(find.text('□')), findsNothing);
  });

  testWidgets('正解は送った解答を中央に出し、丸は画面幅の0.75', (tester) async {
    await _showMechanics(tester);

    await _submit(tester, value: '40', unit: 'N');

    expect(find.text('数値 正解　単位 正解'), findsNothing);
    expect(find.text('40 N'), findsOneWidget);
    _expectMark(tester, fraction: 0.75);
  });

  testWidgets('単位だけ違うときは単位だけ赤で出す', (tester) async {
    await _showMechanics(tester);

    await _submit(tester, value: '40', unit: 'Pa');

    expect(find.text('40 Pa'), findsOneWidget);
    final correction = tester.widget<Text>(find.text('N'));
    expect(correction.style?.color, const Color(0xFFD32F2F));
    expect(correction.style?.fontSize, 40);
    _expectMark(tester, fraction: 0.5);
  });

  testWidgets('数値だけ違うときは数値だけ赤で出す', (tester) async {
    await _showMechanics(tester);

    await _submit(tester, value: '30', unit: 'N');

    expect(find.text('30 N'), findsOneWidget);
    final correction = tester.widget<Text>(find.text('40'));
    expect(correction.style?.color, const Color(0xFFD32F2F));
    expect(find.text('40 N'), findsNothing);
    _expectMark(tester, fraction: 0.5);
  });

  testWidgets('数値も単位も違うときは両方を赤で出す', (tester) async {
    await _showMechanics(tester);

    await _submit(tester, value: '30', unit: 'Pa');

    expect(find.text('30 Pa'), findsOneWidget);
    final correction = tester.widget<Text>(find.text('40 N'));
    expect(correction.style?.color, const Color(0xFFD32F2F));
    expect(
      correction.style?.fontSize,
      tester.widget<Text>(find.text('30 Pa')).style?.fontSize,
    );
    _expectMark(tester, fraction: 0.5);
  });

  testWidgets('選んだ m^-1 は右肩に -1', (tester) async {
    await _showMechanics(tester);
    await _tapVisible(tester, find.byTooltip('電卓'));
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.text('4'));
    await _tapVisible(tester, find.text('単位へ'));
    await tester.pumpAndSettle();

    expect(find.text('m^-1'), findsNothing);
    await _tapVisible(tester, find.widgetWithText(ElevatedButton, 'm'));
    await tester.pumpAndSettle();

    expect(find.text('m^-1'), findsNothing);
    expect(find.text('/'), findsNothing);
    expect(_unitGlyph('4', 26), findsOneWidget);
    expect(_unitGlyph('m', 26), findsOneWidget);
    expect(_unitGlyph('-1', 26 * 0.62), findsOneWidget);
  });

  testWidgets('ヒントは問題カードの中に出て、力学は図も動く', (tester) async {
    await _showMechanics(tester);

    const hintText = '上の二つの物体をひとまとめにして、上向きに加速していることに注目する。';
    final statement = find.textContaining('図のように鉛直上向きに外力を加えたところ');
    final card = find.ancestor(of: statement, matching: find.byType(Card));
    expect(
      find.descendant(of: card, matching: find.text(hintText)),
      findsNothing,
    );
    expect(
      tester
          .widget<StackedBlocksFigure>(find.byType(StackedBlocksFigure))
          .groupProgress,
      0,
    );

    await _tapVisible(tester, find.text('ヒント'));
    await tester.pumpAndSettle();

    expect(find.text('ヒントを隠す'), findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text(hintText)),
      findsOneWidget,
    );
    expect(
      tester
          .widget<StackedBlocksFigure>(find.byType(StackedBlocksFigure))
          .groupProgress,
      1,
    );

    await _tapVisible(tester, find.text('ヒントを隠す'));
    await tester.pumpAndSettle();

    expect(find.text('ヒント'), findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text(hintText)),
      findsNothing,
    );
    expect(
      tester
          .widget<StackedBlocksFigure>(find.byType(StackedBlocksFigure))
          .groupProgress,
      0,
    );
  });

  testWidgets('文章だけのヒントも同じカードに出る', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    for (final label in ['力学', '波動', '電磁気学', '原子']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }

    const hintText = '入ってきた熱と、外へした仕事の差が、内部エネルギーの変化になる。';
    final statement = find.textContaining('内部エネルギーが');
    final card = find.ancestor(of: statement, matching: find.byType(Card));
    expect(statement, findsOneWidget);
    expect(
      find.descendant(of: card, matching: find.text(hintText)),
      findsNothing,
    );

    await _tapVisible(tester, find.text('ヒント'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: card, matching: find.text(hintText)),
      findsOneWidget,
    );
    expect(find.byType(StackedBlocksFigure), findsNothing);
  });

  testWidgets('自由端の図はヒントを押すと出て、隠すと消える', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    for (final label in ['力学', '熱力学', '電磁気学', '原子']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    for (var i = 0; i < 12; i++) {
      if (find.textContaining('自由端反射').evaluate().isNotEmpty) break;
      await tester.tap(find.widgetWithText(InkWell, 'ガチャを回す'));
      await tester.pumpAndSettle();
    }

    final statement = find.textContaining('自由端反射');
    expect(statement, findsOneWidget);
    expect(find.byType(FreeEndReflectionFigure), findsNothing);
    final card = find.ancestor(of: statement, matching: find.byType(Card));

    await _tapVisible(tester, find.text('ヒント'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: card, matching: find.byType(FreeEndReflectionFigure)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: card,
        matching: find.text('壁は自由端なので腹になる。変位が動かない点は、腹から波長の4分の1だけ離れている。'),
      ),
      findsOneWidget,
    );

    await _tapVisible(tester, find.text('ヒントを隠す'));
    await tester.pumpAndSettle();
    expect(find.byType(FreeEndReflectionFigure), findsNothing);

    await tester.tap(find.text('問題一覧'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('detail-sample-free-end')),
      400,
    );
    await _tapVisible(tester, find.byKey(const ValueKey('detail-sample-free-end')));
    await tester.pumpAndSettle();
    expect(find.byType(FreeEndReflectionFigure), findsOneWidget);
  });

  testWidgets('固定端の図はヒントを押すと出て、隠すと消える', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    for (final label in ['力学', '熱力学', '電磁気学', '原子']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    for (var i = 0; i < 12; i++) {
      if (find.textContaining('固定端反射').evaluate().isNotEmpty) break;
      await tester.tap(find.widgetWithText(InkWell, 'ガチャを回す'));
      await tester.pumpAndSettle();
    }

    final statement = find.textContaining('固定端反射');
    expect(statement, findsOneWidget);
    expect(find.byType(FixedEndReflectionFigure), findsNothing);
    final card = find.ancestor(of: statement, matching: find.byType(Card));

    await _tapVisible(tester, find.text('ヒント'));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: card, matching: find.byType(FixedEndReflectionFigure)),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: card,
        matching: find.text('壁は固定端なので節になる。変位が動かない点のうち、壁にもっとも近いのは壁自身である。'),
      ),
      findsOneWidget,
    );

    await _tapVisible(tester, find.text('ヒントを隠す'));
    await tester.pumpAndSettle();
    expect(find.byType(FixedEndReflectionFigure), findsNothing);

    await tester.tap(find.text('問題一覧'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('detail-sample-fixed-end')),
      400,
    );
    await _tapVisible(tester, find.byKey(const ValueKey('detail-sample-fixed-end')));
    await tester.pumpAndSettle();
    expect(find.byType(FixedEndReflectionFigure), findsOneWidget);
  });

  testWidgets('波長の順は記号を並べて答え、解説も出る', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const PhysicsGachaApp());
    await tester.pumpAndSettle();

    for (final label in ['力学', '熱力学', '電磁気学', '原子']) {
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
    }
    for (var i = 0; i < 16; i++) {
      if (find.textContaining('波長の短い順').evaluate().isNotEmpty) break;
      await tester.tap(find.widgetWithText(InkWell, 'ガチャを回す'));
      await tester.pumpAndSettle();
    }
    expect(find.textContaining('波長の短い順'), findsOneWidget);

    await _tapVisible(tester, find.text('答えを見る'));
    await tester.pumpAndSettle();
    expect(find.text('答え　オ イ エ ア ウ'), findsOneWidget);
    expect(find.text('無次元'), findsNothing);
    expect(
      find.text('波長の短い順は、X線、紫外線、可視光、赤外線、電波である。記号ではオ イ エ ア ウ。'),
      findsOneWidget,
    );

    await _tapVisible(tester, find.text('答えを隠す'));
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.byTooltip('電卓'));
    await tester.pumpAndSettle();
    for (final symbol in ['オ', 'イ', 'エ', 'ア', 'ウ']) {
      await _tapVisible(tester, find.widgetWithText(OutlinedButton, symbol));
    }
    await _tapVisible(tester, find.text('確定'));
    await tester.pumpAndSettle();

    expect(find.text('オ イ エ ア ウ'), findsOneWidget);
    _expectMark(tester, fraction: 0.75);
  });
}

Future<void> _showMechanics(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const PhysicsGachaApp());
  await tester.pumpAndSettle();

  for (final label in ['熱力学', '波動', '電磁気学', '原子']) {
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }
  for (var i = 0; i < 24; i++) {
    if (find.textContaining('図のように鉛直上向きに外力を加えたところ').evaluate().isNotEmpty) {
      break;
    }
    await tester.tap(find.widgetWithText(InkWell, 'ガチャを回す'));
    await tester.pumpAndSettle();
  }
  expect(find.textContaining('図のように鉛直上向きに外力を加えたところ'), findsOneWidget);
}

Future<void> _openProblemList(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  await tester.pumpWidget(const PhysicsGachaApp());
  await tester.pumpAndSettle();
  await tester.tap(find.text('問題一覧'));
  await tester.pumpAndSettle();
}

Future<void> _submit(
  WidgetTester tester, {
  required String value,
  required String unit,
}) async {
  await _tapVisible(tester, find.byTooltip('電卓'));
  await tester.pumpAndSettle();
  for (final digit in value.split('')) {
    await _tapVisible(tester, find.text(digit));
  }
  await _tapVisible(tester, find.text('単位へ'));
  await tester.pumpAndSettle();
  await _tapVisible(tester, find.text(unit));
  await _tapVisible(tester, find.text('確定'));
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pump();
}

Finder _unitGlyph(String text, double fontSize) {
  return find.byWidgetPredicate((widget) {
    return widget is Text &&
        widget.data == text &&
        widget.style?.fontSize == fontSize;
  });
}

Finder _superscript(String text) {
  return find.byWidgetPredicate((widget) {
    return widget is Text &&
        widget.data == text &&
        (widget.style?.fontSize ?? 99) < 22;
  });
}

Finder _focused(Finder finder) {
  return find.ancestor(
    of: finder,
    matching: find.byWidgetPredicate((widget) {
      if (widget is! DecoratedBox) return false;
      final decoration = widget.decoration;
      return decoration is BoxDecoration &&
          decoration.color == const Color(0x332196F3);
    }),
  );
}

void _expectMark(WidgetTester tester, {required double fraction}) {
  final width = tester.view.physicalSize.width / tester.view.devicePixelRatio;
  expect(
    find.byWidgetPredicate(
      (widget) =>
          widget is CustomPaint && widget.size == Size.square(width * fraction),
    ),
    findsOneWidget,
  );
}
