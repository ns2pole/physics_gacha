import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/logic/numeric_value.dart';

void main() {
  test('近い数値は同じ答えになる', () {
    expect(valuesMatch(6, tryEvaluate('6')!), isTrue);
    expect(valuesMatch(6, tryEvaluate('6.0')!), isTrue);
    expect(valuesMatch(300, tryEvaluate('3.0×10^2')!), isTrue);
    expect(valuesMatch(6, tryEvaluate('√36')!), isTrue);
    expect(valuesMatch(6, tryEvaluate('7')!), isFalse);
  });

  test('定数と対数を読める', () {
    expect(valuesMatch(3.141592653589793, tryEvaluate('π')!), isTrue);
    expect(valuesMatch(2, tryEvaluate('log(100)')!), isTrue);
    expect(tryEvaluate(''), isNull);
    expect(tryEvaluate('abc'), isNull);
  });
}
