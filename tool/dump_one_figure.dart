// ignore_for_file: avoid_print
/// 環境変数 FIGURE_NAME の1図だけ PNG にする。
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/l10n/app_localizations.dart';
import 'package:physics_gacha/models/physics_problem.dart';
import 'package:physics_gacha/ui/fixed_end_reflection_figure.dart';
import 'package:physics_gacha/ui/free_end_reflection_figure.dart';
import 'package:physics_gacha/ui/problem_figure_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final name = Platform.environment['FIGURE_NAME'] ?? '';
  testWidgets('dump $name', (tester) async {
    expect(name, isNotEmpty);
    final log = File('build/figure_review/_dump.log');
    log.parent.createSync(recursive: true);
    void say(String m) {
      log.writeAsStringSync('$m\n', mode: FileMode.append);
      stdout.writeln(m);
    }

    say('start $name');
    final child = _widgetFor(name);
    await tester.binding.setSurfaceSize(const Size(900, 1100));
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          backgroundColor: Colors.white,
          body: TickerMode(
            enabled: false,
            child: Center(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  key: key,
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
      ),
    );
    await tester.pump();
    say('pumped $name');

    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = boundary.toImageSync(pixelRatio: 1.5);
    say('imaged $name ${image.width}x${image.height}');
    final data = await tester.runAsync(
      () => image.toByteData(format: ui.ImageByteFormat.png),
    );
    if (data == null) {
      fail('toByteData returned null for $name');
    }
    await File('build/figure_review/$name.png').writeAsBytes(
      data.buffer.asUint8List(),
    );
    image.dispose();
    say('ok $name');
  }, timeout: const Timeout(Duration(seconds: 60)));
}

Widget _widgetFor(String name) {
  if (name == 'hint_freeEndReflection') {
    return const FreeEndReflectionFigure();
  }
  if (name == 'hint_fixedEndReflection') {
    return const FixedEndReflectionFigure();
  }
  return problemFigureView(
    ProblemFigure.values.firstWhere((f) => f.name == name),
  );
}
