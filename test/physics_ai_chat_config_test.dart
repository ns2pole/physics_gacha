import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/integrations/ai_chat/physics_ai_chat_config.dart';

void main() {
  test('endpoint 未設定なら isConfigured は false', () {
    final config = PhysicsAiChatConfig.apiConfigFromEnvironment();
    expect(config.isConfigured, isFalse);
    expect(config.endpoint, isNull);
    expect(
      config.installationIdStorageKey,
      PhysicsAiChatConfig.installationIdStorageKey,
    );
    expect(
      PhysicsAiChatConfig.installationIdStorageKey,
      'physicsgacha/ai_chat_installation_id',
    );
  });
}
