import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/logic/grading.dart';

void main() {
  test('並びは空白や読点を無視して比べる', () {
    expect(
      orderMatches('X線、紫外線、可視光、赤外線、電波', 'X線 紫外線 可視光 赤外線 電波'),
      isTrue,
    );
    expect(
      orderMatches('X線、紫外線、可視光、赤外線、電波', 'X線、紫外線、可視光、赤外線、電波'),
      isTrue,
    );
    expect(
      orderMatches('X線、紫外線、可視光、赤外線、電波', '紫外線、X線、可視光、赤外線、電波'),
      isFalse,
    );
  });

  test('数値と単位の両方が合って初めて正解', () {
    final both = gradeAnswer(
      expectedValue: 40,
      expectedUnit: 'N',
      userExpression: '40',
      userUnit: 'N',
    );
    expect(both.passed, isTrue);

    final valueOnly = gradeAnswer(
      expectedValue: 40,
      expectedUnit: 'N',
      userExpression: '40',
      userUnit: 'J',
    );
    expect(valueOnly.valueCorrect, isTrue);
    expect(valueOnly.unitCorrect, isFalse);
    expect(valueOnly.passed, isFalse);

    final unitOnly = gradeAnswer(
      expectedValue: 40,
      expectedUnit: 'N',
      userExpression: '41',
      userUnit: 'kg m/s^2',
    );
    expect(unitOnly.valueCorrect, isFalse);
    expect(unitOnly.unitCorrect, isTrue);
  });

  test('換算すると同じ物理量なら正解', () {
    final grade = gradeAnswer(
      expectedValue: 0.4,
      expectedUnit: 'm',
      userExpression: '40',
      userUnit: 'cm',
    );
    expect(grade.passed, isTrue);
  });

  test('μC と mC は C と同じ電荷', () {
    final micro = gradeAnswer(
      expectedValue: 1.8e-2,
      expectedUnit: 'C',
      userExpression: '18000',
      userUnit: 'μC',
    );
    expect(micro.passed, isTrue);

    final pico = gradeAnswer(
      expectedValue: 8.85e-11,
      expectedUnit: 'F',
      userExpression: '88.5',
      userUnit: 'pF',
    );
    expect(pico.passed, isTrue);

    final nano = gradeAnswer(
      expectedValue: 1.77e-9,
      expectedUnit: 'F',
      userExpression: '1.77',
      userUnit: 'nF',
    );
    expect(nano.passed, isTrue);

    final metalGap = gradeAnswer(
      expectedValue: 1.77e-10,
      expectedUnit: 'F',
      userExpression: '177',
      userUnit: 'pF',
    );
    expect(metalGap.passed, isTrue);

    final milli = gradeAnswer(
      expectedValue: 1.8e-2,
      expectedUnit: 'C',
      userExpression: '18',
      userUnit: 'mC',
    );
    expect(milli.passed, isTrue);
  });

  test('空欄が正解なのは無次元だけ', () {
    final count = gradeAnswer(
      expectedValue: 4.0e5,
      expectedUnit: '',
      userExpression: '4.0×10^5',
      userUnit: '',
    );
    expect(count.passed, isTrue);

    final missingUnit = gradeAnswer(
      expectedValue: 40,
      expectedUnit: 'N',
      userExpression: '40',
      userUnit: '',
    );
    expect(missingUnit.unitCorrect, isFalse);
    expect(missingUnit.passed, isFalse);
  });
}
