import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/integrations/ai_chat/physics_ai_chat_ports.dart';

void main() {
  test('スターターはヒント・方針・最初の一手', () {
    const ports = PhysicsAiChatPorts();
    final replies = ports.starterQuickReplies('any-id');
    expect(replies, isNotNull);
    expect(replies!.map((r) => r.label).toList(), [
      'ヒントを教えて',
      '方針だけ教えて',
      '最初の一手だけ教えて',
    ]);
  });

  testWidgets('課金 UI は出さない', (tester) async {
    const ports = PhysicsAiChatPorts();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final offer = ports.buildUpgradeOffer(
              context,
              limitInfo: const AiChatRateLimitInfo(
                message: 'limit',
                tier: 'free',
                usageLimit: 15,
              ),
              isRestoring: false,
              onPurchase: () {},
              onRestore: () {},
            );
            expect(offer, isNull);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
