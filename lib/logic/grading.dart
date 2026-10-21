import 'numeric_value.dart';
import 'unit_quantity.dart';

class AnswerGrade {
  const AnswerGrade({required this.valueCorrect, required this.unitCorrect});

  final bool valueCorrect;
  final bool unitCorrect;

  bool get passed => valueCorrect && unitCorrect;
}

/// 数値と単位を別々に見る。40 cm と 0.4 m のように物理量として同じときは、両方正解にする。
AnswerGrade gradeAnswer({
  required double expectedValue,
  required String expectedUnit,
  required String userExpression,
  required String userUnit,
}) {
  final userValue = tryEvaluate(userExpression);
  final expected = parseUnit(expectedUnit);
  final actual = parseUnit(userUnit);
  if (expected == null) {
    return const AnswerGrade(valueCorrect: false, unitCorrect: false);
  }

  final valueMatchesNumber =
      userValue != null && valuesMatch(userValue, expectedValue);
  final unitMatchesExactly =
      actual != null &&
      actual.dimensions == expected.dimensions &&
      valuesMatch(actual.scale, expected.scale);
  final quantityMatches =
      userValue != null &&
      actual != null &&
      samePhysicalQuantity(
        leftValue: userValue,
        leftUnit: actual,
        rightValue: expectedValue,
        rightUnit: expected,
      );

  if (quantityMatches && !valueMatchesNumber) {
    return const AnswerGrade(valueCorrect: true, unitCorrect: true);
  }
  return AnswerGrade(
    valueCorrect: valueMatchesNumber,
    unitCorrect: unitMatchesExactly,
  );
}

/// 並べた解答。空白や読点の有無は無視する。
bool orderMatches(String expected, String actual) {
  final left = _compactOrder(expected);
  final right = _compactOrder(actual);
  return left.isNotEmpty && left == right;
}

String _compactOrder(String text) => text.replaceAll(RegExp(r'[\s、,，・]'), '');
