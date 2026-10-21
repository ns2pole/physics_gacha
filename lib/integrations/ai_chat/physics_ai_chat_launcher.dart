import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter/material.dart';

import '../../models/physics_problem.dart';
import 'physics_ai_chat_client_factory.dart';
import 'physics_ai_chat_ports.dart';
import 'physics_session_mapper.dart';

class PhysicsAiChatLauncher {
  const PhysicsAiChatLauncher._();

  static Future<void> open({
    required BuildContext context,
    required PhysicsProblem problem,
    required bool hintShown,
    required bool answerShown,
    AiChatClient? client,
  }) {
    final session = PhysicsSessionMapper.fromProblem(
      context: context,
      problem: problem,
      hintShown: hintShown,
      answerShown: answerShown,
    );

    return AiChatKit.showSession(
      context: context,
      session: session,
      client: client ?? PhysicsAiChatClientFactory.createDefault(),
      host: const PhysicsAiChatPorts(),
    );
  }
}
