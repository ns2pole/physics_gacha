import 'package:ai_chat_kit/ai_chat_kit.dart';

class PhysicsAiChatConfig {
  const PhysicsAiChatConfig._();

  static const defaultEndpoint = String.fromEnvironment(
    'AI_CHAT_ENDPOINT',
    defaultValue: '',
  );

  static const installationIdStorageKey = 'physicsgacha/ai_chat_installation_id';

  static AiChatApiConfig apiConfigFromEnvironment() {
    final value = defaultEndpoint.trim();
    final endpoint = value.isEmpty ? null : Uri.parse(value);
    return AiChatApiConfig(
      endpoint: endpoint,
      installationIdStorageKey: installationIdStorageKey,
    );
  }
}
