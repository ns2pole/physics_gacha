import 'package:flutter/material.dart';

/// 9.0 V の電池に 18 Ω の抵抗をつないだ回路。
class BatteryResistorFigure extends StatelessWidget {
  const BatteryResistorFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 136,
      width: 220,
      child: CustomPaint(painter: _BatteryResistorPainter()),
    );
  }
}

class _BatteryResistorPainter extends CustomPainter {
  const _BatteryResistorPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-40, 0);
    const ink = Color(0xFF37474F);
    final wire = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = 48.0;
    const right = 252.0;
    const top = 44.0;
    const bottom = 96.0;
    const center = (left + right) / 2;
    final resistor = Rect.fromCenter(
      center: const Offset(center, top),
      width: 72,
      height: 24,
    );

    canvas.drawLine(const Offset(left, top), Offset(resistor.left, top), wire);
    canvas.drawLine(
      Offset(resistor.right, top),
      const Offset(right, top),
      wire,
    );
    canvas.drawLine(
      const Offset(right, top),
      const Offset(right, bottom),
      wire,
    );
    canvas.drawLine(const Offset(left, top), const Offset(left, bottom), wire);

    const positive = center - 4.5;
    const negative = center + 4.5;
    canvas.drawLine(
      const Offset(left, bottom),
      const Offset(positive, bottom),
      wire,
    );
    canvas.drawLine(
      const Offset(negative, bottom),
      const Offset(right, bottom),
      wire,
    );
    canvas.drawLine(
      const Offset(positive, bottom - 14),
      const Offset(positive, bottom + 14),
      wire,
    );
    canvas.drawLine(
      const Offset(negative, bottom - 7),
      const Offset(negative, bottom + 7),
      Paint()
        ..color = ink
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    canvas.drawRect(resistor, wire);
    _label(canvas, '18 Ω', Offset(center, resistor.top - 14), ink);
    _label(canvas, '9.0 V', const Offset(center, bottom + 28), ink);
  }

  void _label(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _BatteryResistorPainter oldDelegate) => false;
}
