import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';
import 'span_marker.dart';

/// 上から見た置く前・置いた後と、止まったあとを横から見た図。
/// 上から見た棒の回転は、本当の 1.0×10⁻³ rad を 15° に誇張している。
/// 止まったとき、大球と小球の中心を結ぶ向きは棒と垂直である。
class CavendishTorsionFigure extends StatelessWidget {
  const CavendishTorsionFigure({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      width: 360,
      height: 348,
      child: CustomPaint(
        painter: _CavendishTorsionPainter(
          before: labels.placedBefore,
          after: labels.placedAfter,
          side: labels.fromSide,
        ),
      ),
    );
  }
}

class _CavendishTorsionPainter extends CustomPainter {
  const _CavendishTorsionPainter({
    required this.before,
    required this.after,
    required this.side,
  });

  final String before;
  final String after;
  final String side;

  static const _ink = Color(0xFF37474F);
  static const _largeFill = Color(0xFFCFD8DC);
  static const _twist = 15 * math.pi / 180;
  static const _smallRadius = 6.0;
  static const _largeRadius = 13.0;

  @override
  void paint(Canvas canvas, Size size) {
    const beforeCenter = Offset(96, 112);
    const afterCenter = Offset(264, 112);
    _caption(canvas, before, const Offset(96, 16));
    _topBefore(canvas, beforeCenter);
    _arrow(canvas, const Offset(158, 112), const Offset(188, 112));
    _caption(canvas, after, const Offset(264, 16));
    _topAfter(canvas, afterCenter);
    _caption(canvas, side, const Offset(180, 198));
    _side(canvas, const Offset(180, 278));
  }

  void _topBefore(Canvas canvas, Offset center) {
    const half = 46.0;
    final leftEnd = center + const Offset(-half, 0);
    final rightEnd = center + const Offset(half, 0);
    _rod(canvas, leftEnd, rightEnd);
    _smallBall(canvas, leftEnd);
    _smallBall(canvas, rightEnd);
    _pivot(canvas, center);
    _label(canvas, '0.40 kg', leftEnd + const Offset(0, -20), size: 12);
    _label(canvas, '0.40 kg', rightEnd + const Offset(0, -20), size: 12);
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
    final bar = Offset(math.cos(-_twist), math.sin(-_twist));
    final leftEnd = center - bar * half;
    final rightEnd = center + bar * half;
    final touch = _smallRadius + _largeRadius - 1;
    final rightLarge = rightEnd + _turned(bar, -math.pi / 2) * touch;
    final leftLarge = leftEnd + _turned(-bar, -math.pi / 2) * touch;
    _dashed(canvas, center + const Offset(-half, 0), center + const Offset(half, 0));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: 16),
      0,
      -_twist,
      false,
      _stroke(1.2),
    );
    _rod(canvas, leftEnd, rightEnd);
    _largeBall(canvas, rightLarge);
    _largeBall(canvas, leftLarge);
    _smallBall(canvas, leftEnd);
    _smallBall(canvas, rightEnd);
    _pivot(canvas, center);
    _label(canvas, '100 kg', rightLarge + const Offset(0, -22), size: 12);
    _label(canvas, '100 kg', leftLarge + const Offset(-18, 18), size: 12);
    _label(canvas, '0.20 m', rightLarge + const Offset(34, 20), size: 12);
    _label(canvas, '1.0×10⁻³ rad', center + const Offset(28, 36), size: 11);
  }

  void _side(Canvas canvas, Offset center) {
    const half = 52.0;
    _ceiling(canvas, center.dx, center.dy - 58);
    _straightWire(canvas, Offset(center.dx, center.dy - 54), center + const Offset(0, -30));
    _helix(canvas, center + const Offset(0, -30), center);
    final leftEnd = center + const Offset(-half, 0);
    final rightEnd = center + const Offset(half, 0);
    _rod(canvas, leftEnd, rightEnd);
    final rightLarge = rightEnd + const Offset(0, 16);
    final leftLarge = leftEnd + const Offset(0, -16);
    _largeBall(canvas, rightLarge);
    _largeBall(canvas, leftLarge);
    _smallBall(canvas, leftEnd);
    _smallBall(canvas, rightEnd);
    _pivot(canvas, center);
  }

  Offset _turned(Offset direction, double angle) {
    final c = math.cos(angle);
    final s = math.sin(angle);
    return Offset(
      direction.dx * c - direction.dy * s,
      direction.dx * s + direction.dy * c,
    );
  }

  void _ceiling(Canvas canvas, double x, double y) {
    canvas.drawLine(Offset(x - 28, y), Offset(x + 28, y), _stroke(2));
  }

  void _straightWire(Canvas canvas, Offset top, Offset bottom) {
    canvas.drawLine(top, bottom, _stroke(1.6));
  }

  void _helix(Canvas canvas, Offset top, Offset bottom) {
    final path = Path();
    const turns = 3;
    for (var i = 0; i <= 36; i++) {
      final t = i / 36;
      final y = top.dy + (bottom.dy - top.dy) * t;
      final x = top.dx + math.sin(t * turns * math.pi * 2) * 4.5;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, _stroke(1.6));
  }

  void _rod(Canvas canvas, Offset from, Offset to) {
    canvas.drawLine(from, to, _stroke(2));
  }

  Paint _stroke(double width) {
    return Paint()
      ..color = _ink
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void _smallBall(Canvas canvas, Offset center) {
    canvas.drawCircle(center, _smallRadius, Paint()..color = _ink);
  }

  void _largeBall(Canvas canvas, Offset center) {
    canvas.drawCircle(center, _largeRadius, Paint()..color = _largeFill);
    canvas.drawCircle(center, _largeRadius, _stroke(1.5));
  }

  void _pivot(Canvas canvas, Offset center) {
    canvas.drawCircle(center, 3.2, Paint()..color = Colors.white);
    canvas.drawCircle(center, 3.2, _stroke(1.4));
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
      final end = math.min(drawn + 4, length);
      canvas.drawLine(from + step * drawn, from + step * end, paint);
      drawn += 7;
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

  void _caption(Canvas canvas, String text, Offset origin) {
    _label(canvas, text, origin, size: 13, bold: true);
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin, {
    double size = 13,
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(
          color: _ink,
          fontSize: size,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _CavendishTorsionPainter oldDelegate) =>
      oldDelegate.before != before ||
      oldDelegate.after != after ||
      oldDelegate.side != side;
}
