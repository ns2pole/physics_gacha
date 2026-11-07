import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/data/sample_problems.dart';
import 'package:physics_gacha/logic/grading.dart';
import 'package:physics_gacha/logic/problem_pool.dart';
import 'package:physics_gacha/logic/unit_quantity.dart';
import 'package:physics_gacha/models/learning_record.dart';
import 'package:physics_gacha/models/physics_domain.dart';
import 'package:physics_gacha/models/physics_problem.dart';
import 'package:physics_gacha/state/gacha_session.dart';

void main() {
  test('問題は5単元と融合を数値か並びで答える', () {
    expect(sampleProblems, hasLength(85));
    for (final problem in sampleProblems) {
      expect(problem.title.trim(), isNotEmpty, reason: problem.id);
      if (problem.isSymbolOrder) {
        expect(
          orderMatches(problem.symbolOrder, problem.answerDisplay),
          isTrue,
          reason: problem.id,
        );
        continue;
      }
      expect(problem.answerValue.isFinite, isTrue);
      if (problem.unitObvious) {
        expect(problem.unitChoices, isEmpty, reason: problem.id);
      }
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

    final kepler = sampleProblems.singleWhere(
      (problem) => problem.id == '11cf8d71-4c2b-45ed-bb3e-3718131609c2',
    );
    expect(kepler.unitObvious, isTrue);
    expect(kepler.unitInputKind, UnitInputKind.omitted);
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
      '680f161b-8039-4d8b-97ac-54d641bf875e',
      '63f5a83f-3152-4583-8c46-67bc2e33d8bc',
      '11cf8d71-4c2b-45ed-bb3e-3718131609c2',
      'ab68af64-b6f1-4a0b-b27d-9c8da85c2075',
      '355ab9b8-5510-4ab9-be24-4ffb0e0d3d2a',
      '3f04e9ee-5b10-44b3-959a-8066a139be9d',
      '3587cf2f-0e4c-44bf-a255-4413086cf0c9',
      '03565785-cd7a-4353-bd44-ff3879ea6935',
      'ea751b97-55c2-4363-a575-5d8fdc5cc9a7',
      '1de21279-b406-41f8-a86d-4da5a47293f9',
      '9754d70d-66f6-4c2d-b2fc-2e47ff967a8e',
      'c903ff0f-db40-4916-8ed4-5c4a656dc9f1',
      '7da18bc0-3810-4a32-8930-0e17ba16efce',
      '19776c8b-24cd-4aaf-95ab-5a5097ed7055',
      '80b5bc83-b93e-402a-b658-be4cc879795a',
      'd09b53dc-125f-4a38-8908-9911d635cb8e',
      'b5640d96-7b77-4993-ac9a-b8969461b744',
      'e5bc3b07-2a24-49d0-9cf3-f6e03c9b6c8f',
      'fccf9e77-372c-4c34-b17d-9cafc2d339b5',
      'b7c1e735-bbda-461c-a72e-eff2609a5ab1',
      '760c69d1-1a7e-41f8-b18f-8b7ac39735a4',
      '3161b116-b09a-4d0b-b92d-44cd0d46a4a4',
      'b29b25dc-cde4-4e27-ade8-bfb66af29ad3',
      'b775e759-f47a-40ad-9506-762bd7e1b158',
      '04aa630e-a4c3-46ee-918c-531536db9665',
      'dc2ea26c-266e-4441-96b7-a9a514e3b799',
      '264dc236-782b-4ba0-9d39-13c94f7ea889',
      'fb52940c-6b53-4c80-a4a3-639e2aa650ef',
      'a9200667-eb7b-4eb0-8b3b-ecf7e4adfc0b',
      '6ede92dc-5a1f-45dd-8bd5-aad99c9ea5da',
      'b2264701-1475-4352-a05d-e5271f77caff',
      'ebf0977f-94f9-4e30-8415-95fe3b05b3c2',
      'cc8cd992-df30-4283-b758-2c7bba07336a',
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
