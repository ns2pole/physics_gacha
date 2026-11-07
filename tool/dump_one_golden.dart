import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/l10n/app_localizations.dart';
import 'package:physics_gacha/ui/stacked_blocks_figure.dart';

void main() {
  testWidgets('golden stacked', (tester) async {
    final out = Directory('build/figure_review')..createSync(recursive: true);
    await tester.binding.setSurfaceSize(const Size(400, 400));
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: TickerMode(
            enabled: false,
            child: Center(child: StackedBlocksFigure()),
          ),
        ),
      ),
    );
    await tester.pump();
    await expectLater(
      find.byType(StackedBlocksFigure),
      matchesGoldenFile('../build/figure_review/stackedBlocks.png'),
    );
    stdout.writeln('ok golden ${out.path}');
  });
}
