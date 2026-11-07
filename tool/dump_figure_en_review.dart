// ignore_for_file: avoid_print
/// 英語 locale で全図を PNG 化する（図ラベルの英語対応レビュー用）。
///
/// ```sh
/// flutter test tool/dump_figure_en_review.dart --update-goldens --timeout 30m
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
import 'package:physics_gacha/ui/fixed_end_reflection_figure.dart';
import 'package:physics_gacha/ui/free_end_reflection_figure.dart';
import 'package:physics_gacha/ui/problem_figure_view.dart';
import 'package:physics_gacha/utils/figure_label_style.dart';

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

  final entries = <(String, Widget)>[
    for (final figure in ProblemFigure.values)
      (figure.name, problemFigureView(figure)),
    ('hint_freeEndReflection', const FreeEndReflectionFigure()),
    ('hint_fixedEndReflection', const FixedEndReflectionFigure()),
  ];

  for (final entry in entries) {
    final name = entry.$1;
    final child = entry.$2;
    testWidgets('dump en $name', (tester) async {
      Directory('build/figure_en_review').createSync(recursive: true);
      await tester.binding.setSurfaceSize(const Size(900, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          theme: ThemeData(fontFamily: _fontFamily),
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
                            'EN  $name',
                            style: const TextStyle(
                              fontFamily: _fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          child,
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
        matchesGoldenFile('../build/figure_en_review/$name.png'),
      );
      stdout.writeln('ok en $name');
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
  throw StateError('フォントが見つからない: ${paths.join(', ')}');
}
