import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'physics_ai_chat_config.dart';

class PhysicsAiChatClientFactory {
  const PhysicsAiChatClientFactory._();

  static AiChatClient createDefault() {
    final config = PhysicsAiChatConfig.apiConfigFromEnvironment();
    if (!config.isConfigured) {
      return const StubAiChatClient();
    }

    return HttpAiChatClient(
      config: config,
      headersProvider: authHeaders,
    );
  }

  static Future<Map<String, String>> authHeaders() async {
    if (Firebase.apps.isEmpty) {
      return const {};
    }

    final token = await FirebaseAuth.instance.currentUser?.getIdToken();
    final appCheckToken = await FirebaseAppCheck.instance.getToken();
    return {
      if (token != null) 'Authorization': 'Bearer $token',
      if (appCheckToken != null)
        'X-Firebase-AppCheck': appCheckToken,
    };
  }
}
