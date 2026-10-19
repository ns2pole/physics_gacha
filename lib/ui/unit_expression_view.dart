import 'package:flutter/material.dart';

/// `m^-1` を m の右肩に `-1`、`m/s^2` を m と s の右肩に `-2` として描く。
/// スラッシュは出さない。冪のない単一記号はそのままの文字にする。
class UnitExpressionView extends StatelessWidget {
  const UnitExpressionView({
    super.key,
    required this.unit,
    this.style = const TextStyle(fontSize: 26, color: Colors.black87),
  });

  final String unit;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final layout = _parseUnitLayout(unit);
    if (layout == null || layout.isPlain) {
      return Text(unit, style: style);
    }

    final fontSize = style.fontSize ?? 26;
    final base = style.copyWith(height: 1);
    final children = <Widget>[];
    for (var i = 0; i < layout.factors.length; i++) {
      if (i > 0) children.add(SizedBox(width: fontSize * 0.18));
      children.add(_factor(layout.factors[i], base, fontSize));
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: children,
    );
  }

  Widget _factor(_Factor factor, TextStyle base, double fontSize) {
    if (factor.power == 1) return Text(factor.symbol, style: base);
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(factor.symbol, style: base),
        Padding(
          padding: EdgeInsets.only(bottom: fontSize * 0.48),
          child: Text(
            '${factor.power}',
            style: base.copyWith(fontSize: fontSize * 0.62),
          ),
        ),
      ],
    );
  }
}

/// 数値のうしろに付いた単位を、右肩の冪として描く必要があるか。
bool unitNeedsTypesetting(String unit) {
  final layout = _parseUnitLayout(unit);
  return layout != null && !layout.isPlain;
}

class _Factor {
  const _Factor(this.symbol, this.power);

  final String symbol;
  final int power;
}

class _UnitLayout {
  const _UnitLayout(this.factors);

  final List<_Factor> factors;

  bool get isPlain => factors.length == 1 && factors.single.power == 1;
}

final _tokenPattern = RegExp(r'^([A-Za-zµΩ]+)(?:\^(-?\d+))?$');

_UnitLayout? _parseUnitLayout(String source) {
  final raw = source.trim();
  if (raw.isEmpty) return null;

  final factors = <_Factor>[];
  var denominator = false;

  for (final chunk in raw.split(RegExp(r'\s+'))) {
    final pieces = chunk.split('/');
    for (var i = 0; i < pieces.length; i++) {
      if (i > 0) denominator = true;
      final piece = pieces[i];
      if (piece.isEmpty) continue;
      final match = _tokenPattern.firstMatch(piece);
      if (match == null) return null;
      final symbol = match.group(1)!;
      final written = int.tryParse(match.group(2) ?? '1');
      if (written == null || written == 0) return null;
      final power = denominator ? -written.abs() : written;
      factors.add(_Factor(symbol, power));
    }
  }

  if (factors.isEmpty) return null;
  return _UnitLayout(factors);
}
