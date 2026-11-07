import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';
import 'span_marker.dart';

/// 真上から見た置く前・置いた後と、やや斜め上から見た図。
/// 棒の回転は、本当の 1.0×10⁻³ rad を見やすい角度に誇張している。
/// 止まったとき、大球と小球の中心を結ぶ向きは棒と垂直である。
class CavendishTorsionFigure extends StatelessWidget {
  const CavendishTorsionFigure({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      width: 360,
      height: 470,
      child: CustomPaint(
        painter: _CavendishTorsionPainter(
          before: labels.placedBefore,
          after: labels.placedAfter,
          angled: labels.fromSide,
        ),
      ),
    );
  }
}

class _CavendishTorsionPainter extends CustomPainter {
  const _CavendishTorsionPainter({
    required this.before,
    required this.after,
    required this.angled,
  });

  final String before;
  final String after;
  final String angled;

  static const _ink = Color(0xFF37474F);
  static const _largeFill = Color(0xFFCFD8DC);
  static const _topTwist = 15 * math.pi / 180;
  // 真上は小球を小さめにし、大球と重ねない。
  static const _topSmallR = 4.0;
  static const _topLargeR = 13.0;

  // 斜め図: 真上ではなく奥行きで少しつぶす。
  static const _depth = 0.42;
  static const _half = 1.0;
  static const _baseAngle = -0.38;
  // 誇張ねじれ。大きすぎると大球に食い込むので半分程度。
  static const _twist = 0.24;
  static const _smallR = 7.0;
  static const _largeR = 28.0;

  @override
  void paint(Canvas canvas, Size size) {
    const beforeCenter = Offset(96, 112);
    const afterCenter = Offset(264, 112);
    _caption(canvas, before, const Offset(96, 16));
    _topBefore(canvas, beforeCenter);
    _arrow(canvas, const Offset(158, 112), const Offset(188, 112));
    _caption(canvas, after, const Offset(264, 16));
    _topAfter(canvas, afterCenter);

    _caption(canvas, angled, const Offset(180, 240));
    canvas.save();
    canvas.translate(10, 218);
    _angled(canvas, const Size(340, 250));
    canvas.restore();
  }

  void _topBefore(Canvas canvas, Offset center) {
    const half = 46.0;
    final leftEnd = center + const Offset(-half, 0);
    final rightEnd = center + const Offset(half, 0);
    _rod(canvas, leftEnd, rightEnd);
    _smallBall(canvas, leftEnd, _topSmallR);
    _smallBall(canvas, rightEnd, _topSmallR);
    _pivot(canvas, center);
    _label(canvas, '0.40 kg', leftEnd + const Offset(0, -28));
    _label(canvas, '0.40 kg', rightEnd + const Offset(0, -28));
    paintSpanMarker(
      canvas: canvas,
      from: leftEnd + const Offset(0, 26),
      to: rightEnd + const Offset(0, 26),
      label: '1.0 m',
      color: _ink,
    );
  }

  void _topAfter(Canvas canvas, Offset center) {
    const half = 46.0;
    final bar = Offset(math.cos(-_topTwist), math.sin(-_topTwist));
    final leftEnd = center - bar * half;
    final rightEnd = center + bar * half;
    // 小球と大球のあいだにすき間を残す。
    final gap = _topSmallR + _topLargeR + 4;
    final rightLarge = rightEnd + _turned(bar, -math.pi / 2) * gap;
    final leftLarge = leftEnd + _turned(-bar, -math.pi / 2) * gap;
    _dashed(canvas, center + const Offset(-half, 0), center + const Offset(half, 0));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 16),
      0,
      -_topTwist,
      false,
      _stroke(1.2),
    );
    _rod(canvas, leftEnd, rightEnd);
    _largeBall(canvas, rightLarge, _topLargeR);
    _largeBall(canvas, leftLarge, _topLargeR);
    _smallBall(canvas, leftEnd, _topSmallR);
    _smallBall(canvas, rightEnd, _topSmallR);
    _pivot(canvas, center);
    _label(canvas, '100 kg', rightLarge + const Offset(0, -26));
    _label(canvas, '100 kg', leftLarge + const Offset(-28, 22));
    _label(canvas, '0.20 m', rightLarge + const Offset(38, 24));
    // ねじれ角は置いた後パネルの下・中央寄せ（大球の外）。
    _label(canvas, '1.0×10⁻³ rad', center + const Offset(-10, 92));
  }

  void _angled(Canvas canvas, Size size) {
    const pivot3 = Offset(0, 0);
    const scale = 84.0;
    final origin = Offset(size.width * 0.48, size.height * 0.58);

    Offset map(Offset p, {double z = 0}) {
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

    final normal = Offset(-twisted.dy, twisted.dx);
    const gap = 0.42;
    final rightLarge = right + normal * gap;
    final leftLarge = left - normal * gap;

    final pivot = map(pivot3);
    final ceilingY = pivot.dy - 96;
    _ceiling(canvas, pivot.dx, ceilingY);
    canvas.drawLine(
      Offset(pivot.dx, ceilingY),
      pivot,
      _stroke(1.5),
    );

    // 置く前の小球（点線）と、その中心同士を結ぶ棒。ねじれ角はここに出す。
    final beforeLeft = map(left0);
    final beforeRight = map(right0);
    _dashedCircle(canvas, beforeLeft, _smallR);
    _dashedCircle(canvas, beforeRight, _smallR);
    _dashed(canvas, beforeLeft, beforeRight);
    _dashedOrbitArc(canvas, map, pivot3, left0, left);
    _dashedOrbitArc(canvas, map, pivot3, right0, right);

    _rod(canvas, map(left), map(right));
    // 右: 大球が手前。左: 大球のあとに小球を重ねて手前にする。
    _smallBall(canvas, map(right), _smallR);
    _largeBall(canvas, map(rightLarge), _largeR);
    _largeBall(canvas, map(leftLarge), _largeR);
    _smallBall(canvas, map(left), _smallR);
    _pivot(canvas, pivot);

    // 置く前の棒と置いたあとの棒のあいだの角 = 1.0×10⁻³ rad（誇張）。
    final a0 = math.atan2(beforeRight.dy - pivot.dy, beforeRight.dx - pivot.dx);
    final a1 = math.atan2(map(right).dy - pivot.dy, map(right).dx - pivot.dx);
    var sweep = a1 - a0;
    while (sweep > math.pi) {
      sweep -= 2 * math.pi;
    }
    while (sweep < -math.pi) {
      sweep += 2 * math.pi;
    }
    const arcR = 26.0;
    canvas.drawArc(
      Rect.fromCircle(center: pivot, radius: arcR),
      a0,
      sweep,
      false,
      _stroke(1.3),
    );
    // 弧のすぐ上（吊り線の右・球の外）。
    _label(canvas, '1.0×10⁻³ rad', pivot + const Offset(56, -38));

    // 左小球を最後にもう一度（手前を確定）。
    _smallBall(canvas, map(left), _smallR);
  }

  Offset _turned(Offset direction, double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Offset(
      direction.dx * c - direction.dy * s,
      direction.dx * s + direction.dy * c,
    );
  }

  Offset _unit(Offset v) {
    final d = v.distance;
    if (d < 1e-6) return Offset.zero;
    return v / d;
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

  void _smallBall(
    Canvas canvas,
    Offset center,
    double radius, {
    Color fill = Colors.white,
  }) {
    canvas.drawCircle(center, radius, Paint()..color = fill);
    canvas.drawCircle(center, radius, _stroke(1.6));
  }

  void _largeBall(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, Paint()..color = _largeFill);
    canvas.drawCircle(center, radius, _stroke(1.6));
  }

  void _pivot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 3.4, Paint()..color = Colors.white);
    canvas.drawCircle(center, 3.4, _stroke(1.4));
  }

  /// ねじれの前後で、小球の中心が描く円弧を点線で書く。
  void _dashedOrbitArc(
    Canvas canvas,
    Offset Function(Offset p, {double z}) map,
    Offset pivot3,
    Offset from3,
    Offset to3,
  ) {
    final a0 = math.atan2(from3.dy - pivot3.dy, from3.dx - pivot3.dx);
    final a1 = math.atan2(to3.dy - pivot3.dy, to3.dx - pivot3.dx);
    var sweep = a1 - a0;
    while (sweep > math.pi) {
      sweep -= 2 * math.pi;
    }
    while (sweep < -math.pi) {
      sweep += 2 * math.pi;
    }
    final radius = (from3 - pivot3).distance;
    const steps = 24;
    final points = <Offset>[
      for (var i = 0; i <= steps; i++)
        map(
          Offset(
            pivot3.dx + radius * math.cos(a0 + sweep * i / steps),
            pivot3.dy + radius * math.sin(a0 + sweep * i / steps),
          ),
        ),
    ];
    final paint = Paint()
      ..color = _ink.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;
    var draw = true;
    var budget = 5.0;
    for (var i = 0; i < points.length - 1; i++) {
      var a = points[i];
      final b = points[i + 1];
      var remain = (b - a).distance;
      if (remain < 1e-6) continue;
      final dir = (b - a) / remain;
      while (remain > 1e-6) {
        final take = math.min(budget, remain);
        final next = a + dir * take;
        if (draw) {
          canvas.drawLine(a, next, paint);
        }
        a = next;
        remain -= take;
        budget -= take;
        if (budget <= 1e-6) {
          draw = !draw;
          budget = draw ? 5.0 : 4.0;
        }
      }
    }
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

  void _arrow(Canvas canvas, Offset from, Offset to) {
    canvas.drawLine(from, to - const Offset(8, 0), _stroke(1.4));
    final head = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(to.dx - 9, to.dy - 5)
      ..lineTo(to.dx - 9, to.dy + 5)
      ..close();
    canvas.drawPath(head, Paint()..color = _ink);
  }

  Paint _stroke(double width) {
    return Paint()
      ..color = _ink
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void _caption(Canvas canvas, String text, Offset origin) {
    _label(canvas, text, origin, size: 15, bold: true);
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin, {
    double size = 15,
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(
          color: _ink,
          fontSize: size,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _CavendishTorsionPainter oldDelegate) =>
      oldDelegate.before != before ||
      oldDelegate.after != after ||
      oldDelegate.angled != angled;
}
