import 'package:flutter/material.dart';

import 'mixed_text_math.dart';
import 'mixed_text_math_pipeline.dart';

/// AIチャット吹き出し用。`$...$` / TeX を [MixedTextMath] で描く。
Widget buildAiChatMathText(String text) {
  final processed = preprocessAiChatMathText(text);
  return MixedTextMath(
    processed,
    forceTex: false,
    labelStyle: const TextStyle(fontSize: 16, height: 1.45),
    mathStyle: const TextStyle(fontSize: 18),
    displayInlineFractions: true,
    plainTextOnMathError: true,
  );
}

final _boldMarkdown = RegExp(r'\*\*(.+?)\*\*');

/// アシスタント返信用。数式がなければ太字だけ処理して [Text]。
Widget buildAiChatAssistantMathText(String text) {
  final processed = preprocessAiChatMathText(text);
  if (!shouldRenderWithMixedTextMath(processed)) {
    return _buildBoldAwareText(processed);
  }
  final cleaned = processed.replaceAllMapped(
    _boldMarkdown,
    (m) => m.group(1)!,
  );
  return buildAiChatMathText(cleaned);
}

Widget _buildBoldAwareText(String text) {
  const style = TextStyle(fontSize: 16, height: 1.45);
  if (!_boldMarkdown.hasMatch(text)) {
    return Text(text, softWrap: true, style: style);
  }

  final spans = <InlineSpan>[];
  var cursor = 0;
  for (final match in _boldMarkdown.allMatches(text)) {
    if (match.start > cursor) {
      spans.add(TextSpan(text: text.substring(cursor, match.start)));
    }
    spans.add(
      TextSpan(
        text: match.group(1),
        style: style.copyWith(fontWeight: FontWeight.w700),
      ),
    );
    cursor = match.end;
  }
  if (cursor < text.length) {
    spans.add(TextSpan(text: text.substring(cursor)));
  }
  return Text.rich(TextSpan(style: style, children: spans), softWrap: true);
}
