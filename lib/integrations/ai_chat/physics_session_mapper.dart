import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../models/physics_problem.dart';
import '../../utils/l10n_utils.dart';

class PhysicsSessionMapper {
  const PhysicsSessionMapper._();

  static const maxReferenceSolutionLength = 6000;

  static AiChatSessionPayload fromProblem({
    required PhysicsProblem problem,
    required bool hintShown,
    required bool answerShown,
    BuildContext? context,
  }) {
    final l10n = context != null
        ? AppLocalizations.of(context)!
        : appL10nWithoutContext();

    final explanation = (context != null
            ? problem.getLocalizedExplanation(context)
            : problem.explanation)
        .trim();
    final referenceSolution = explanation.isEmpty
        ? null
        : _truncate(explanation, maxReferenceSolutionLength);

    final answer = (context != null
            ? problem.getLocalizedAnswerDisplay(context)
            : problem.answerDisplay)
        .trim();
    final referenceAnswer = answer.isEmpty ? null : answer;

    final theme = (context != null
            ? problem.getLocalizedTheme(context)
            : problem.theme)
        .trim();

    final question = (context != null
            ? problem.getLocalizedStatement(context)
            : problem.statement)
        .trim();

    return AiChatSessionPayload(
      contentId: problem.id,
      title: l10n.askAi,
      questionText: question,
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
