import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 実効値 240 V の交流電源に 10 kΩ の抵抗をつないだ回路。
class AcResistorFigure extends StatelessWidget {
  const AcResistorFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 180,
      width: 200,
      child: CustomPaint(painter: _AcResistorPainter()),
    );
  }
}

class _AcResistorPainter extends CustomPainter {
  const _AcResistorPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-20, -6);
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = 28.0;
    const right = 212.0;
    const top = 52.0;
    const bottom = 142.0;
    const center = (left + right) / 2;
    final resistor = Rect.fromCenter(
      center: const Offset(center, top),
      width: 72,
      height: 28,
    );

    canvas.drawLine(const Offset(left, top), Offset(resistor.left, top), wire);
    canvas.drawLine(Offset(resistor.right, top), const Offset(right, top), wire);
    canvas.drawLine(const Offset(left, top), const Offset(left, bottom), wire);
    canvas.drawLine(const Offset(right, top), const Offset(right, bottom), wire);
    canvas.drawLine(const Offset(left, bottom), Offset(center - 18, bottom), wire);
    canvas.drawLine(Offset(center + 18, bottom), const Offset(right, bottom), wire);
    canvas.drawRect(resistor, wire);
    _label(canvas, '10 kΩ', Offset(center, resistor.top - 16));

    canvas.drawCircle(const Offset(center, bottom), 18, wire);
    final sine = Path();
    const steps = 24;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = center - 12 + 24 * t;
      final y = bottom - 7 * math.sin(t * 2 * math.pi);
      if (i == 0) {
        sine.moveTo(x, y);
      } else {
        sine.lineTo(x, y);
      }
    }
    canvas.drawPath(sine, wire);
    _label(canvas, '240 V', const Offset(center, bottom + 30));
  }

  void _label(Canvas canvas, String text, Offset origin) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: _ink, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _AcResistorPainter oldDelegate) => false;
}
