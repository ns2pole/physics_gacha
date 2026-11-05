import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';
import 'span_marker.dart';

/// 斜め上から見たキャベンディッシュのねじり秤。
/// 棒の回転は、本当の 1.0×10⁻³ rad を見やすい角度に誇張している。
/// 止まったとき、大球と小球の中心を結ぶ向きは棒と垂直である。
class CavendishTorsionFigure extends StatelessWidget {
  const CavendishTorsionFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 340,
      height: 280,
      child: CustomPaint(painter: _CavendishTorsionPainter()),
    );
  }
}

class _CavendishTorsionPainter extends CustomPainter {
  const _CavendishTorsionPainter();

  static const _ink = Color(0xFF37474F);
  static const _largeFill = Color(0xFFCFD8DC);
  // 真上ではなく斜め上からの見え方。奥行きで少しつぶす。
  static const _depth = 0.42;
  static const _half = 1.0;
  // 置く前の棒の向き（ワールド xy）。見た目の斜め感用。
  static const _baseAngle = -0.38;
  // ねじれは実際より大きく見せる。
  static const _twist = 0.48;
  static const _smallR = 7.0;
  static const _largeR = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    const pivot3 = Offset(0, 0);
    const scale = 92.0;
    final origin = Offset(size.width * 0.48, size.height * 0.58);

    Offset map(Offset p, {double z = 0}) {
      // x: 左右、y: 奥行き、z: 上。
      return Offset(
        origin.dx + scale * (p.dx + _depth * p.dy),
        origin.dy + scale * (0.55 * p.dy - z),
      );
    }

    final base = Offset(math.cos(_baseAngle), math.sin(_baseAngle));
    final twisted = Offset(
      math.cos(_baseAngle + _twist),
      math.sin(_baseAngle + _twist),
    );
    final left0 = pivot3 - base * _half;
    final right0 = pivot3 + base * _half;
    final left = pivot3 - twisted * _half;
    final right = pivot3 + twisted * _half;

    // 大球は棒と垂直。両端で回す向きが同じになるよう、逆向きに置く。
    final normal = Offset(-twisted.dy, twisted.dx);
    const gap = 0.42; // 見た目の 0.20 m 相当
    final rightLarge = right + normal * gap;
    final leftLarge = left - normal * gap;

    // 天井と針金
    final pivot = map(pivot3);
    final ceilingY = pivot.dy - 108;
    _ceiling(canvas, pivot.dx, ceilingY);
    canvas.drawLine(
      Offset(pivot.dx, ceilingY),
      pivot,
      _stroke(1.5),
    );

    // 置く前の棒（破線）と小球の位置
    _dashed(canvas, map(left0), map(right0));
    _dashedCircle(canvas, map(left0), _smallR);
    _dashedCircle(canvas, map(right0), _smallR);

    // ねじれ角
    _angleArc(canvas, pivot, map(right0) - pivot, map(right) - pivot);
    _angleArc(canvas, pivot, map(left0) - pivot, map(left) - pivot);
    _label(
      canvas,
      '1.0×10⁻³ rad',
      pivot + const Offset(56, -18),
      size: 12,
    );

    // 置いたあとの棒と球
    _rod(canvas, map(left), map(right));
    _largeBall(canvas, map(rightLarge));
    _largeBall(canvas, map(leftLarge));
    _smallBall(canvas, map(left));
    _smallBall(canvas, map(right));
    _pivot(canvas, pivot);

    // 引力の向き（棒と垂直）
    _forceArrow(canvas, map(right), map(rightLarge));
    _forceArrow(canvas, map(left), map(leftLarge));

    // 数値
    _label(canvas, '0.40 kg', map(left) + const Offset(-28, -18), size: 12);
    _label(canvas, '0.40 kg', map(right) + const Offset(28, -18), size: 12);
    _label(canvas, '100 kg', map(leftLarge) + const Offset(-36, 8), size: 12);
    _label(canvas, '100 kg', map(rightLarge) + const Offset(36, 8), size: 12);

    paintSpanMarker(
      canvas: canvas,
      from: map(left) + const Offset(0, 36),
      to: map(right) + const Offset(0, 36),
      label: '1.0 m',
      color: _ink,
    );

    // 大球–小球の間隔（右端側）
    final midGap = Offset(
      (map(right).dx + map(rightLarge).dx) / 2,
      (map(right).dy + map(rightLarge).dy) / 2,
    );
    _label(canvas, '0.20 m', midGap + const Offset(22, 22), size: 12);
  }

  void _ceiling(Canvas canvas, double x, double y) {
    canvas.drawLine(Offset(x - 34, y), Offset(x + 34, y), _stroke(2));
    for (var i = -28.0; i <= 28; i += 10) {
      canvas.drawLine(
        Offset(x + i, y),
        Offset(x + i - 8, y - 8),
        _stroke(1.3),
      );
    }
  }

  void _rod(Canvas canvas, Offset from, Offset to) {
    canvas.drawLine(from, to, _stroke(2.2));
  }

  void _smallBall(Canvas canvas, Offset center) {
    canvas.drawCircle(center, _smallR, Paint()..color = Colors.white);
    canvas.drawCircle(center, _smallR, _stroke(1.6));
  }

  void _largeBall(Canvas canvas, Offset center) {
    canvas.drawCircle(center, _largeR, Paint()..color = _largeFill);
    canvas.drawCircle(center, _largeR, _stroke(1.6));
  }

  void _pivot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 3.4, Paint()..color = Colors.white);
    canvas.drawCircle(center, 3.4, _stroke(1.4));
  }

  void _forceArrow(Canvas canvas, Offset from, Offset toward) {
    final delta = toward - from;
    final length = delta.distance;
    if (length < 1) return;
    final dir = delta / length;
    // 小球の縁から大球の手前まで。
    final start = from + dir * (_smallR + 2);
    final end = from + dir * (length - _largeR - 4);
    if ((end - start).distance < 8) return;
    canvas.drawLine(start, end, _stroke(1.6));
    final across = Offset(-dir.dy, dir.dx);
    final head = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo((end - dir * 8 + across * 4).dx, (end - dir * 8 + across * 4).dy)
      ..lineTo((end - dir * 8 - across * 4).dx, (end - dir * 8 - across * 4).dy)
      ..close();
    canvas.drawPath(head, Paint()..color = _ink);
  }

  void _angleArc(Canvas canvas, Offset center, Offset fromVec, Offset toVec) {
    final a0 = math.atan2(fromVec.dy, fromVec.dx);
    final a1 = math.atan2(toVec.dy, toVec.dx);
    var sweep = a1 - a0;
    while (sweep > math.pi) {
      sweep -= 2 * math.pi;
    }
    while (sweep < -math.pi) {
      sweep += 2 * math.pi;
    }
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 22),
      a0,
      sweep,
      false,
      _stroke(1.2),
    );
  }

  void _dashed(Canvas canvas, Offset from, Offset to) {
    final paint = Paint()
      ..color = _ink.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    final delta = to - from;
    final length = delta.distance;
    if (length < 1) return;
    final step = delta / length;
    var drawn = 0.0;
    while (drawn < length) {
      final end = math.min(drawn + 5, length);
      canvas.drawLine(from + step * drawn, from + step * end, paint);
      drawn += 9;
    }
  }

  void _dashedCircle(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = _ink.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    const dashes = 18;
    for (var i = 0; i < dashes; i += 2) {
      final a0 = 2 * math.pi * i / dashes;
      final a1 = 2 * math.pi * (i + 1) / dashes;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        a0,
        a1 - a0,
        false,
        paint,
      );
    }
  }

  Paint _stroke(double width) {
    return Paint()
      ..color = _ink
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin, {
    double size = 13,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink, fontSize: size),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CavendishTorsionPainter oldDelegate) => false;
}
