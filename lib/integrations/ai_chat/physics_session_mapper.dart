import 'package:ai_chat_kit/ai_chat_kit.dart';

import '../../models/physics_problem.dart';

class PhysicsSessionMapper {
  const PhysicsSessionMapper._();

  static const maxReferenceSolutionLength = 6000;

  static AiChatSessionPayload fromProblem({
    required PhysicsProblem problem,
    required bool hintShown,
    required bool answerShown,
  }) {
    final explanation = problem.explanation.trim();
    final referenceSolution = explanation.isEmpty
        ? null
        : _truncate(explanation, maxReferenceSolutionLength);

    final answer = problem.answerDisplay.trim();
    final referenceAnswer = answer.isEmpty ? null : answer;

    final theme = problem.theme.trim();

    return AiChatSessionPayload(
      contentId: problem.id,
      title: 'AIに聞く',
      questionText: problem.statement.trim(),
      category: theme.isEmpty ? null : theme,
      referenceAnswer: referenceAnswer,
      referenceSolution: referenceSolution,
      hintShown: hintShown,
      answerShown: answerShown,
    );
  }

  static String _truncate(String value, int maxLength) {
    if (value.length <= maxLength) return value;
    return value.substring(0, maxLength);
  }
}
