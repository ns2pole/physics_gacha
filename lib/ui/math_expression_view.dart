import 'package:flutter/material.dart';

/// 入力文字列を、指数を上付きにした数式として描く。
/// [cursor] があるときは、そこを打っている塊を青く塗る。
class MathExpressionView extends StatelessWidget {
  const MathExpressionView({
    super.key,
    required this.expression,
    this.cursor,
    this.style = const TextStyle(
      fontSize: 28,
      color: Colors.black87,
      height: 1,
    ),
  });

  final String expression;
  final int? cursor;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final nodes = _parse(expression);
    if (nodes.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [for (final node in nodes) _view(node)],
    );
  }

  Widget _view(_MathNode node) {
    return switch (node) {
      _MathText() => _Token(
        text: node.text,
        style: style,
        focused: _covers(node.start, node.end),
      ),
      _MathPower() => Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _Token(
            text: node.base,
            style: style,
            focused: _covers(node.baseStart, node.baseEnd),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: (style.fontSize ?? 28) * 0.48),
            child: _Token(
              text: node.exponent.isEmpty ? '□' : node.exponent,
              style: style.copyWith(fontSize: (style.fontSize ?? 28) * 0.62),
              focused: node.exponent.isEmpty
                  ? cursor == node.exponentStart
                  : _covers(node.exponentStart, node.exponentEnd),
              hole: node.exponent.isEmpty,
            ),
          ),
        ],
      ),
    };
  }

  bool _covers(int start, int end) {
    final index = cursor;
    if (index == null) return false;
    return index > start && index <= end;
  }
}

class _Token extends StatelessWidget {
  const _Token({
    required this.text,
    required this.style,
    required this.focused,
    this.hole = false,
  });

  final String text;
  final TextStyle style;
  final bool focused;
  final bool hole;

  @override
  Widget build(BuildContext context) {
    final color = hole
        ? (focused ? Colors.blue.shade700 : Colors.grey.shade500)
        : style.color;
    return DecoratedBox(
      decoration: focused ? _focusDecoration : const BoxDecoration(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
        child: Text(text, style: style.copyWith(color: color, height: 1)),
      ),
    );
  }
}

const _focusDecoration = BoxDecoration(
  color: Color(0x332196F3),
  borderRadius: BorderRadius.all(Radius.circular(4)),
);

sealed class _MathNode {}

class _MathText extends _MathNode {
  _MathText(this.text, this.start, this.end);

  final String text;
  final int start;
  final int end;
}

class _MathPower extends _MathNode {
  _MathPower({
    required this.base,
    required this.baseStart,
    required this.baseEnd,
    required this.exponent,
    required this.exponentStart,
    required this.exponentEnd,
  });

  final String base;
  final int baseStart;
  final int baseEnd;
  final String exponent;
  final int exponentStart;
  final int exponentEnd;
}

List<_MathNode> _parse(String text) {
  final nodes = <_MathNode>[];
  var i = 0;
  while (i < text.length) {
    if (_isNumberChar(text[i])) {
      final baseStart = i;
      i = _readNumber(text, i);
      final base = text.substring(baseStart, i);
      if (i < text.length && text[i] == '^') {
        i++;
        final exponentStart = i;
        i = _readExponent(text, i);
        nodes.add(
          _MathPower(
            base: base,
            baseStart: baseStart,
            baseEnd: baseStart + base.length,
            exponent: text.substring(exponentStart, i),
            exponentStart: exponentStart,
            exponentEnd: i,
          ),
        );
      } else {
        nodes.add(_MathText(base, baseStart, i));
      }
      continue;
    }
    if (text[i] == '×') {
      nodes.add(_MathText('×', i, i + 1));
      i++;
      continue;
    }
    final start = i;
    while (i < text.length &&
        !_isNumberChar(text[i]) &&
        text[i] != '×' &&
        text[i] != '^') {
      i++;
    }
    if (i == start) {
      nodes.add(_MathText(text[i], i, i + 1));
      i++;
      continue;
    }
    nodes.add(_MathText(text.substring(start, i), start, i));
  }
  return nodes;
}

int _readNumber(String text, int i) {
  while (i < text.length && _isNumberChar(text[i])) {
    i++;
  }
  return i;
}

int _readExponent(String text, int i) {
  final start = i;
  if (i < text.length && (text[i] == '-' || text[i] == '−')) i++;
  var digits = false;
  var dot = false;
  while (i < text.length) {
    final char = text[i];
    if (_isDigit(char)) {
      digits = true;
      i++;
    } else if (char == '.' && !dot) {
      dot = true;
      i++;
    } else {
      break;
    }
  }
  if (!digits) return start;
  return i;
}

bool _isNumberChar(String char) => _isDigit(char) || char == '.';

bool _isDigit(String char) {
  if (char.isEmpty) return false;
  final code = char.codeUnitAt(0);
  return code >= 48 && code <= 57;
}
