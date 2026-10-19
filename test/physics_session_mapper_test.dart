import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/data/sample_problems.dart';
import 'package:physics_gacha/integrations/ai_chat/physics_session_mapper.dart';
import 'package:physics_gacha/models/physics_domain.dart';
import 'package:physics_gacha/models/physics_problem.dart';

void main() {
  test('statement / theme / explanation を載せ、flags を渡す', () {
    final problem = sampleProblems.firstWhere((p) => p.id == 'sample-mechanics');
    final payload = PhysicsSessionMapper.fromProblem(
      problem: problem,
      hintShown: true,
      answerShown: false,
    );

    expect(payload.contentId, 'sample-mechanics');
    expect(payload.title, 'AIに聞く');
    expect(payload.questionText, problem.statement.trim());
    expect(payload.category, '運動方程式（ニュートン第2法則）');
    expect(payload.referenceAnswer, '40');
    expect(payload.referenceSolution, problem.explanation.trim());
    expect(payload.hintShown, isTrue);
    expect(payload.answerShown, isFalse);
    expect(payload.level, isNull);
  });

  test('空の explanation は referenceSolution を省略する', () {
    const problem = PhysicsProblem(
      id: 'empty-explanation',
      theme: 'テストテーマ',
      domains: {PhysicsDomain.mechanics},
      statement: '問う量だけ。',
      answerValue: 1,
      answerUnit: 'N',
      answerDisplay: '1',
      unitChoices: ['N'],
      hint: 'h',
      approach: 'a',
      firstStep: 'f',
      explanation: '   ',
    );

    final payload = PhysicsSessionMapper.fromProblem(
      problem: problem,
      hintShown: false,
      answerShown: true,
    );

    expect(payload.category, 'テストテーマ');
    expect(payload.referenceSolution, isNull);
    expect(payload.referenceAnswer, '1');
    expect(payload.answerShown, isTrue);
  });

  test('長い explanation は上限で切る', () {
    final long = 'あ' * (PhysicsSessionMapper.maxReferenceSolutionLength + 10);
    final problem = PhysicsProblem(
      id: 'long',
      theme: 't',
      domains: {PhysicsDomain.waves},
      statement: 's',
      answerValue: 1,
      answerUnit: '',
      answerDisplay: '1',
      unitChoices: const [],
      hint: 'h',
      approach: 'a',
      firstStep: 'f',
      explanation: long,
    );

    final payload = PhysicsSessionMapper.fromProblem(
      problem: problem,
      hintShown: false,
      answerShown: false,
    );

    expect(
      payload.referenceSolution!.length,
      PhysicsSessionMapper.maxReferenceSolutionLength,
    );
  });
}
