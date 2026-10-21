/// English overlay for a [PhysicsProblem]. Japanese remains the source of truth.
class ProblemTranslation {
  const ProblemTranslation({
    this.theme,
    this.statement,
    this.hint,
    this.approach,
    this.firstStep,
    this.explanation,
    this.answerDisplay,
    this.symbolChoices,
    this.symbolOrder,
  });

  final String? theme;
  final String? statement;
  final String? hint;
  final String? approach;
  final String? firstStep;
  final String? explanation;
  final String? answerDisplay;
  final List<String>? symbolChoices;
  final String? symbolOrder;
}
