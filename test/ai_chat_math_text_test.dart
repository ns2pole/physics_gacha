import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/ui/math/ai_chat_math_text.dart';
import 'package:physics_gacha/ui/math/mixed_text_math_pipeline.dart';

void main() {
  test('inline dollar math is detected for MixedTextMath', () {
    const text = r'圧力は $P = \rho g h$ である。';
    final processed = preprocessAiChatMathText(text);
    expect(shouldRenderWithMixedTextMath(processed), isTrue);
  });

  testWidgets('assistant renderer builds MixedTextMath for dollar math', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: buildAiChatAssistantMathText(r'圧力は $P = \rho g h$ である。'),
        ),
      ),
    );
    expect(find.textContaining(r'$P = \rho g h$'), findsNothing);
  });
}
