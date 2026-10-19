import 'dart:math' as math;

/// 数値電卓が作る式を、数として読む。`3.0×10^5` のように × と指数を受け付ける。
double? tryEvaluate(String source) {
  final text = source.trim();
  if (text.isEmpty) return null;
  final parser = _Parser(text);
  try {
    final value = parser.parseExpression();
    parser.skip();
    if (!parser.isDone || value.isNaN || value.isInfinite) return null;
    return value;
  } on FormatException {
    return null;
  }
}

/// 6 と 6.0、300 と 3.0×10^2 は同じ。6 と 7 は違う。
bool valuesMatch(double expected, double actual) {
  final scale = math.max(expected.abs(), actual.abs());
  final tolerance = math.max(1e-9, scale * 1e-6);
  return (expected - actual).abs() <= tolerance;
}

class _Parser {
  _Parser(this.source);

  final String source;
  int index = 0;

  bool get isDone => index >= source.length;

  double parseExpression() {
    var value = parseTerm();
    while (true) {
      skip();
      if (peek == '+') {
        index++;
        value += parseTerm();
      } else if (peek == '-' || peek == '−') {
        index++;
        value -= parseTerm();
      } else {
        return value;
      }
    }
  }

  double parseTerm() {
    var value = parseFactor();
    while (true) {
      skip();
      final operator = peek;
      if (operator == '×' ||
          operator == '*' ||
          operator == '·' ||
          operator == '/') {
        index++;
        final right = parseFactor();
        if (operator == '/') {
          value /= right;
        } else {
          value *= right;
        }
      } else {
        return value;
      }
    }
  }

  double parseFactor() {
    skip();
    if (peek == '-' || peek == '−') {
      index++;
      return -parseFactor();
    }
    if (source.startsWith('√', index)) {
      index++;
      return math.sqrt(parsePrimary());
    }
    if (source.startsWith('log', index)) {
      index += 3;
      return math.log(parsePrimary()) / math.ln10;
    }
    final base = parsePrimary();
    skip();
    if (peek == '^') {
      index++;
      return math.pow(base, parseFactor()).toDouble();
    }
    return base;
  }

  double parsePrimary() {
    skip();
    if (peek == '(') {
      index++;
      final value = parseExpression();
      skip();
      if (peek != ')') throw const FormatException('括弧が閉じていません');
      index++;
      return value;
    }
    if (source.startsWith('π', index) || source.startsWith('pi', index)) {
      index += source.startsWith('π', index) ? 1 : 2;
      return math.pi;
    }
    if (peek == 'e') {
      index++;
      return math.e;
    }
    return parseNumber();
  }

  double parseNumber() {
    skip();
    final start = index;
    while (!isDone && _isDigit(source.codeUnitAt(index))) {
      index++;
    }
    if (!isDone && peek == '.') {
      index++;
      while (!isDone && _isDigit(source.codeUnitAt(index))) {
        index++;
      }
    }
    if (start == index) throw const FormatException('数値がありません');
    return double.parse(source.substring(start, index));
  }

  String? get peek => isDone ? null : source[index];

  void skip() {
    while (!isDone && source[index].trim().isEmpty) {
      index++;
    }
  }
}

bool _isDigit(int codeUnit) => codeUnit >= 48 && codeUnit <= 57;
