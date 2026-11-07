// ignore_for_file: avoid_print
/// ラベル近い（overlap △）図だけ PNG 化する。CJK フォントを載せる。
///
/// ```sh
/// flutter test tool/dump_suspicious_figures.dart --update-goldens --timeout 30m
/// ```
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/l10n/app_localizations.dart';
import 'package:physics_gacha/models/physics_problem.dart';
import 'package:physics_gacha/ui/free_end_reflection_figure.dart';
import 'package:physics_gacha/ui/problem_figure_view.dart';
import 'package:physics_gacha/utils/figure_label_style.dart';

const _entries = <(String, String)>[
  ('9', 'hint_freeEndReflection'),
  ('13', 'compressedSpring'),
  ('19', 'bridgeVoltageDrop'),
  ('24', 'connectedVessels'),
  ('26', 'verticalSpringOscillation'),
  ('39', 'dielectricCapacitor'),
  ('46', 'evacuatedCylinder'),
  ('50', 'toothbrushString'),
  ('51', 'stringFundamental'),
  ('52', 'conicalPendulum'),
  ('68', 'elevatorScale'),
  ('69', 'nailPendulum'),
  ('71', 'pendulumBottomTension'),
  ('74', 'syringePiston'),
  ('75', 'waterDepthPressure'),
  ('76', 'invertedColumn'),
  ('77', 'saltWaterPressure'),
  ('83', 'solenoidCoil'),
  ('84', 'lorentzBar'),
];

const _fontFamily = 'DumpReview';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    figureLabelFontFamily = _fontFamily;
    final bytes = _readFont();
    final data = ByteData.sublistView(Uint8List.fromList(bytes));
    await (FontLoader(_fontFamily)..addFont(Future.value(data))).load();
  });

  tearDownAll(() {
    figureLabelFontFamily = null;
  });

  for (final entry in _entries) {
    final no = entry.$1;
    final name = entry.$2;
    testWidgets('dump No.$no $name', (tester) async {
      Directory('build/figure_review').createSync(recursive: true);
      await tester.binding.setSurfaceSize(const Size(900, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
          theme: ThemeData(
            fontFamily: _fontFamily,
            textTheme: const TextTheme(
              bodyMedium: TextStyle(fontFamily: _fontFamily),
            ),
          ),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            backgroundColor: Colors.white,
            body: TickerMode(
              enabled: false,
              child: Center(
                child: SingleChildScrollView(
                  child: ColoredBox(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No.$no  $name',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _widgetFor(name),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      await expectLater(
        find.byType(ColoredBox).last,
        matchesGoldenFile('../build/figure_review/suspicious_$name.png'),
      );
      stdout.writeln('ok No.$no $name');
    });
  }
}

List<int> _readFont() {
  const paths = [
    '/Library/Fonts/Arial Unicode.ttf',
    '/System/Library/Fonts/ヒラギノ角ゴシック W3.ttc',
  ];
  for (final path in paths) {
    final file = File(path);
    if (file.existsSync()) return file.readAsBytesSync();
  }
  throw StateError('日本語フォントが見つからない: ${paths.join(', ')}');
}

Widget _widgetFor(String name) {
  if (name == 'hint_freeEndReflection') {
    return const FreeEndReflectionFigure();
  }
  return problemFigureView(
    ProblemFigure.values.firstWhere((f) => f.name == name),
  );
}
