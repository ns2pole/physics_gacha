import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 水平なばねの両端から、滑車ごしにおもりをつるした図。
class SpringPulleysFigure extends StatelessWidget {
  const SpringPulleysFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 168,
      width: 280,
      child: CustomPaint(painter: _SpringPulleysPainter()),
    );
  }
}

class _SpringPulleysPainter extends CustomPainter {
  const _SpringPulleysPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const leftPulley = Offset(52, 48);
    const rightPulley = Offset(228, 48);
    const radius = 12.0;
    const massTop = 108.0;
    const massWidth = 44.0;
    const massHeight = 36.0;

    _spring(canvas, leftPulley.dx + radius, rightPulley.dx - radius, leftPulley.dy);
    _label(canvas, 'ばね', Offset((leftPulley.dx + rightPulley.dx) / 2, 16), _ink);

    canvas.drawCircle(leftPulley, radius, line);
    canvas.drawCircle(rightPulley, radius, line);
    canvas.drawCircle(leftPulley, 2, Paint()..color = _ink);
    canvas.drawCircle(rightPulley, 2, Paint()..color = _ink);

    final leftMass = Rect.fromLTWH(
      leftPulley.dx - massWidth / 2,
      massTop,
      massWidth,
      massHeight,
    );
    final rightMass = Rect.fromLTWH(
      rightPulley.dx - massWidth / 2,
      massTop,
      massWidth,
      massHeight,
    );
    canvas.drawLine(Offset(leftPulley.dx, leftPulley.dy + radius), Offset(leftMass.center.dx, leftMass.top), line);
    canvas.drawLine(Offset(rightPulley.dx, rightPulley.dy + radius), Offset(rightMass.center.dx, rightMass.top), line);
    canvas.drawRect(leftMass, line);
    canvas.drawRect(rightMass, line);
    _label(canvas, '4.0 kg', leftMass.center, _ink, weight: FontWeight.w500);
    _label(canvas, '4.0 kg', rightMass.center, _ink, weight: FontWeight.w500);
  }

  void _spring(Canvas canvas, double left, double right, double y) {
    final path = Path();
    const turns = 10;
    const amplitude = 9.0;
    const steps = 80;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = left + (right - left) * t;
      final wave = math.sin(t * turns * 2 * math.pi);
      final point = Offset(x, y + amplitude * wave);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _ink
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  void _label(
    Canvas canvas,
    String text,
    Offset center,
    Color color, {
    FontWeight weight = FontWeight.w600,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _SpringPulleysPainter oldDelegate) => false;
}
