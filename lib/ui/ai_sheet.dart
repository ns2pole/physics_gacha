import 'package:flutter/material.dart';

import '../integrations/ai_chat/physics_ai_chat_launcher.dart';
import '../models/physics_problem.dart';

/// 互換用。本体は [PhysicsAiChatLauncher]。
Future<void> showAiSheet(
  BuildContext context,
  PhysicsProblem problem, {
  bool hintShown = false,
  bool answerShown = false,
}) {
  return PhysicsAiChatLauncher.open(
    context: context,
    problem: problem,
    hintShown: hintShown,
    answerShown: answerShown,
  );
}
