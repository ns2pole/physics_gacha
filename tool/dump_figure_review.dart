// ignore_for_file: avoid_print
/// 全 ProblemFigure を PNG に書き出す（golden）。
///
/// ```sh
/// flutter test tool/dump_figure_review.dart --update-goldens --timeout 30m
/// ```
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/l10n/app_localizations.dart';
import 'package:physics_gacha/models/physics_problem.dart';
import 'package:physics_gacha/ui/fixed_end_reflection_figure.dart';
import 'package:physics_gacha/ui/free_end_reflection_figure.dart';
import 'package:physics_gacha/ui/problem_figure_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final entries = <(String, Widget)>[
    for (final figure in ProblemFigure.values)
      (figure.name, problemFigureView(figure)),
    ('hint_freeEndReflection', const FreeEndReflectionFigure()),
    ('hint_fixedEndReflection', const FixedEndReflectionFigure()),
  ];

  for (final entry in entries) {
    final name = entry.$1;
    final child = entry.$2;
    testWidgets('dump $name', (tester) async {
      Directory('build/figure_review').createSync(recursive: true);
      await tester.binding.setSurfaceSize(const Size(900, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('ja'),
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
                      child: child,
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
        matchesGoldenFile('../build/figure_review/$name.png'),
      );
      stdout.writeln('ok $name');
    });
  }
}
