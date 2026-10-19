import 'dart:math' as math;

import 'numeric_value.dart';

/// 単位を SI の次元と倍率にそろえる。N と kg m/s^2 は同じになる。
class ParsedUnit {
  const ParsedUnit(this.dimensions, this.scale);

  static const dimensionless = ParsedUnit(Dimensions.zero, 1);

  final Dimensions dimensions;

  /// 入力した数値に掛けると SI になる。cm なら 0.01。
  final double scale;

  bool get isDimensionless => dimensions == Dimensions.zero && scale == 1;

  ParsedUnit divide(ParsedUnit other) {
    return ParsedUnit(
      dimensions.subtract(other.dimensions),
      scale / other.scale,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ParsedUnit &&
      dimensions == other.dimensions &&
      scale == other.scale;

  @override
  int get hashCode => Object.hash(dimensions, scale);
}

class Dimensions {
  const Dimensions({this.kg = 0, this.m = 0, this.s = 0, this.a = 0});

  static const zero = Dimensions();

  final int kg;
  final int m;
  final int s;
  final int a;

  Dimensions add(Dimensions other) => Dimensions(
    kg: kg + other.kg,
    m: m + other.m,
    s: s + other.s,
    a: a + other.a,
  );

  Dimensions subtract(Dimensions other) => Dimensions(
    kg: kg - other.kg,
    m: m - other.m,
    s: s - other.s,
    a: a - other.a,
  );

  Dimensions times(int factor) => Dimensions(
    kg: kg * factor,
    m: m * factor,
    s: s * factor,
    a: a * factor,
  );

  @override
  bool operator ==(Object other) =>
      other is Dimensions &&
      kg == other.kg &&
      m == other.m &&
      s == other.s &&
      a == other.a;

  @override
  int get hashCode => Object.hash(kg, m, s, a);
}

class _NamedUnit {
  const _NamedUnit(this.scale, this.dimensions);
  final double scale;
  final Dimensions dimensions;
}

const _named = <String, _NamedUnit>{
  'g': _NamedUnit(1e-3, Dimensions(kg: 1)),
  'm': _NamedUnit(1, Dimensions(m: 1)),
  's': _NamedUnit(1, Dimensions(s: 1)),
  'A': _NamedUnit(1, Dimensions(a: 1)),
  'N': _NamedUnit(1, Dimensions(kg: 1, m: 1, s: -2)),
  'J': _NamedUnit(1, Dimensions(kg: 1, m: 2, s: -2)),
  'W': _NamedUnit(1, Dimensions(kg: 1, m: 2, s: -3)),
  'Pa': _NamedUnit(1, Dimensions(kg: 1, m: -1, s: -2)),
  'Hz': _NamedUnit(1, Dimensions(s: -1)),
  'V': _NamedUnit(1, Dimensions(kg: 1, m: 2, s: -3, a: -1)),
  'C': _NamedUnit(1, Dimensions(s: 1, a: 1)),
};

const _prefixes = <String, double>{
  'da': 1e1,
  'k': 1e3,
  'h': 1e2,
  'd': 1e-1,
  'c': 1e-2,
  'm': 1e-3,
  'u': 1e-6,
  'µ': 1e-6,
  'n': 1e-9,
};

ParsedUnit? parseUnit(String source) {
  final text = source.trim();
  if (text.isEmpty || text == '無次元' || text == '1') {
    return ParsedUnit.dimensionless;
  }
  final sides = text.split('/');
  if (sides.length > 2) return null;
  final numerator = _parseProduct(sides[0]);
  if (numerator == null) return null;
  if (sides.length == 1) return numerator;
  final denominator = _parseProduct(sides[1]);
  if (denominator == null) return null;
  return numerator.divide(denominator);
}

/// 候補ボタンに、次元が同じ単位が二つないこと。cm と m、J と N m を防ぐ。
bool choicesHaveDistinctDimensions(List<String> choices) {
  final parsed = <ParsedUnit>[];
  for (final choice in choices) {
    final unit = parseUnit(choice);
    if (unit == null) return false;
    parsed.add(unit);
  }
  for (var i = 0; i < parsed.length; i++) {
    for (var j = i + 1; j < parsed.length; j++) {
      if (parsed[i].dimensions == parsed[j].dimensions) return false;
    }
  }
  return true;
}

bool samePhysicalQuantity({
  required double leftValue,
  required ParsedUnit leftUnit,
  required double rightValue,
  required ParsedUnit rightUnit,
}) {
  if (leftUnit.dimensions != rightUnit.dimensions) return false;
  return valuesMatch(leftValue * leftUnit.scale, rightValue * rightUnit.scale);
}

ParsedUnit? _parseProduct(String source) {
  final tokens = source.trim().split(RegExp(r'\s+')).where((t) => t.isNotEmpty);
  var result = ParsedUnit.dimensionless;
  var any = false;
  for (final token in tokens) {
    final part = _parseToken(token);
    if (part == null) return null;
    result = ParsedUnit(
      result.dimensions.add(part.dimensions),
      result.scale * part.scale,
    );
    any = true;
  }
  return any ? result : null;
}

ParsedUnit? _parseToken(String token) {
  final match = RegExp(r'^([A-Za-zµ]+|Ω)(?:\^(-?\d+))?$').firstMatch(token);
  if (match == null) return null;
  final symbol = match.group(1)!;
  final exponent = int.tryParse(match.group(2) ?? '1');
  if (exponent == null) return null;
  final named = _lookup(symbol);
  if (named == null) return null;
  return ParsedUnit(
    named.dimensions.times(exponent),
    math.pow(named.scale, exponent).toDouble(),
  );
}

_NamedUnit? _lookup(String symbol) {
  final exact = _named[symbol];
  if (exact != null) return exact;
  final prefixKeys = _prefixes.keys.toList()
    ..sort((a, b) => b.length.compareTo(a.length));
  for (final prefix in prefixKeys) {
    if (!symbol.startsWith(prefix) || symbol.length == prefix.length) continue;
    final base = _named[symbol.substring(prefix.length)];
    if (base == null) continue;
    return _NamedUnit(_prefixes[prefix]! * base.scale, base.dimensions);
  }
  return null;
}
