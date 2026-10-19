import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/ui/unit_expression_view.dart';

void main() {
  testWidgets('m/s^2 はスラッシュを出さず s の右肩に -2', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: UnitExpressionView(unit: 'm/s^2')),
      ),
    );

    expect(find.text('m/s^2'), findsNothing);
    expect(find.text('/'), findsNothing);
    expect(find.text('^'), findsNothing);
    expect(find.text('m'), findsOneWidget);
    final base = tester.widget<Text>(find.text('s'));
    final exponent = tester.widget<Text>(find.text('-2'));
    expect(exponent.style?.fontSize, lessThan(base.style!.fontSize!));
  });

  testWidgets('m^-1 は右肩に -1', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              UnitExpressionView(unit: 'm^-1'),
              UnitExpressionView(unit: 'kg m s^-2'),
              UnitExpressionView(unit: 'N'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('m^-1'), findsNothing);
    expect(find.text('/'), findsNothing);
    expect(find.text('1'), findsNothing);
    expect(find.text('kg'), findsOneWidget);
    expect(find.text('N'), findsOneWidget);
    expect(find.text('-1'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('-1')).style?.fontSize,
      lessThan(26),
    );
    expect(
      tester.widget<Text>(find.text('-2')).style?.fontSize,
      lessThan(26),
    );
  });
}
