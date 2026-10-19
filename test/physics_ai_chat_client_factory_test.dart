import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/integrations/ai_chat/physics_ai_chat_client_factory.dart';

void main() {
  test('endpoint 未設定なら StubAiChatClient', () {
    final client = PhysicsAiChatClientFactory.createDefault();
    expect(client, isA<StubAiChatClient>());
  });
}
