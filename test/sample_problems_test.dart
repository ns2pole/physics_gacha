import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/data/sample_problems.dart';
import 'package:physics_gacha/logic/grading.dart';
import 'package:physics_gacha/logic/problem_pool.dart';
import 'package:physics_gacha/logic/unit_quantity.dart';
import 'package:physics_gacha/models/learning_record.dart';
import 'package:physics_gacha/models/physics_domain.dart';
import 'package:physics_gacha/state/gacha_session.dart';

void main() {
  test('仮の15問は5単元と融合を数値か記号で答える', () {
    expect(sampleProblems, hasLength(15));
    for (final problem in sampleProblems) {
      if (problem.isSymbolOrder) {
        expect(
          orderMatches(problem.symbolOrder, problem.answerDisplay),
          isTrue,
          reason: problem.id,
        );
        continue;
      }
      expect(problem.answerValue.isFinite, isTrue);
      expect(choicesHaveDistinctDimensions(problem.unitChoices), isTrue);
      final grade = gradeAnswer(
        expectedValue: problem.answerValue,
        expectedUnit: problem.answerUnit,
        userExpression: problem.answerDisplay,
        userUnit: problem.answerUnit,
      );
      expect(grade.passed, isTrue, reason: problem.id);
    }

    final domains = sampleProblems.expand((problem) => problem.domains).toSet();
    expect(domains, PhysicsDomain.values.toSet());
    expect(
      sampleProblems.where((problem) => problem.domains.length > 1),
      hasLength(1),
    );
  });

  test('力学だけオンのときは融合が出ない', () {
    final onlyMechanics = eligibleProblems(
      problems: sampleProblems,
      enabled: {PhysicsDomain.mechanics},
      exclusion: ExclusionMode.none,
      histories: {},
    );
    expect(onlyMechanics.map((problem) => problem.id), [
      'sample-mechanics',
      'sample-sliding',
      'sample-spring-pulleys',
      'sample-air-resistance',
      'sample-incline',
    ]);

    final both = eligibleProblems(
      problems: sampleProblems,
      enabled: {PhysicsDomain.mechanics, PhysicsDomain.thermodynamics},
      exclusion: ExclusionMode.none,
      histories: {},
    );
    expect(both.map((problem) => problem.id), contains('sample-fusion'));
    expect(both.map((problem) => problem.id), isNot(contains('sample-waves')));

    expect(
      eligibleProblems(
        problems: sampleProblems,
        enabled: {},
        exclusion: ExclusionMode.none,
        histories: {},
      ),
      isEmpty,
    );
  });

  test('緑の問題は除外され、引き直すと別の問題が出る', () {
    final session = GachaSession(
      random: Random(0),
      exclusion: ExclusionMode.latest1,
      histories: {
        'sample-mechanics': History([
          SlotStatus.solved,
          SlotStatus.empty,
          SlotStatus.empty,
        ]),
      },
    );
    session.ensureCurrent();
    expect(session.current?.id, isNot('sample-mechanics'));

    final first = session.current!.id;
    session.redraw();
    expect(session.current!.id, isNot(first));
  });
}
