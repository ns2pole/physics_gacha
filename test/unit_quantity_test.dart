import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/logic/unit_quantity.dart';

void main() {
  test('N と kg m/s^2 は同じ単位', () {
    final newton = parseUnit('N')!;
    final composed = parseUnit('kg m/s^2')!;
    expect(newton.dimensions, composed.dimensions);
    expect(newton.scale, composed.scale);
  });

  test('40 cm と 0.4 m は同じ物理量', () {
    expect(
      samePhysicalQuantity(
        leftValue: 40,
        leftUnit: parseUnit('cm')!,
        rightValue: 0.4,
        rightUnit: parseUnit('m')!,
      ),
      isTrue,
    );
  });

  test('空欄は無次元', () {
    expect(parseUnit('')!.isDimensionless, isTrue);
    expect(parseUnit('無次元')!.isDimensionless, isTrue);
  });

  test('同じ次元の候補は並べない', () {
    expect(choicesHaveDistinctDimensions(['N', 'J', 'W', 'Pa']), isTrue);
    expect(choicesHaveDistinctDimensions(['cm', 'm']), isFalse);
    expect(choicesHaveDistinctDimensions(['J', 'N m']), isFalse);
  });
}
