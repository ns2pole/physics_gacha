import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 30° のあらい斜面を、斜面に沿った糸で引き上げる図。
class InclinePullFigure extends StatelessWidget {
  const InclinePullFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      width: 280,
      child: CustomPaint(painter: _InclinePullPainter()),
    );
  }
}

class _InclinePullPainter extends CustomPainter {
  const _InclinePullPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const origin = Offset(36, 146);
    const angle = -math.pi / 6;
    const slopeLength = 228.0;
    final along = Offset(math.cos(angle), math.sin(angle));
    final outward = Offset(math.sin(angle), -math.cos(angle));

    canvas.drawLine(origin, origin + along * slopeLength, line);
    for (var distance = 52.0; distance < slopeLength - 8; distance += 16) {
      if (distance > 88 && distance < 132) continue;
      final base = origin + along * distance;
      canvas.drawLine(base, base - outward * 8, line);
    }
    _dashed(canvas, origin, origin + const Offset(132, 0), line);
    canvas.drawArc(
      Rect.fromCircle(center: origin, radius: 34),
      0,
      angle,
      false,
      line,
    );
    final mark = origin + Offset(math.cos(angle / 2), math.sin(angle / 2)) * 58;
    _label(canvas, '30°', mark + const Offset(6, -12));

    const blockDistance = 112.0;
    final block = origin + along * blockDistance;
    canvas.save();
    canvas.translate(block.dx, block.dy);
    canvas.rotate(angle);
    canvas.drawRect(const Rect.fromLTWH(-18, -34, 36, 34), line);
    canvas.drawLine(const Offset(18, -17), const Offset(72, -17), line);
    canvas.restore();

    _label(canvas, '小物体', block + outward * 48);
    _label(canvas, '糸', block + along * 48 + outward * 34);
  }

  void _dashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final delta = to - from;
    final length = delta.distance;
    if (length == 0) return;
    final step = delta / length;
    const dash = 5.0;
    const gap = 4.0;
    var drawn = 0.0;
    while (drawn < length) {
      final end = math.min(drawn + dash, length);
      canvas.drawLine(from + step * drawn, from + step * end, paint);
      drawn += dash + gap;
    }
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: _ink, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _InclinePullPainter oldDelegate) => false;
}
