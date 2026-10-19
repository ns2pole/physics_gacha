import 'package:flutter/material.dart';

/// 12 V の電源に 4.0 Ω と 8.0 Ω を直列につないだ回路。
/// 電源は下辺の中央に置き、回路全体を左右対称にする。
class SeriesCircuitFigure extends StatelessWidget {
  const SeriesCircuitFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 136,
      width: 300,
      child: CustomPaint(painter: _SeriesCircuitPainter()),
    );
  }
}

class _SeriesCircuitPainter extends CustomPainter {
  const _SeriesCircuitPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const ink = Color(0xFF37474F);
    final wire = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = 18.0;
    const right = 282.0;
    const top = 44.0;
    const bottom = 96.0;
    const center = (left + right) / 2;

    const resistors = [
      (Rect.fromLTWH(72, 32, 64, 24), '4.0 Ω'),
      (Rect.fromLTWH(164, 32, 64, 24), '8.0 Ω'),
    ];
    canvas.drawLine(const Offset(left, top), Offset(resistors[0].$1.left, top), wire);
    canvas.drawLine(Offset(resistors[0].$1.right, top), Offset(resistors[1].$1.left, top), wire);
    canvas.drawLine(Offset(resistors[1].$1.right, top), const Offset(right, top), wire);
    canvas.drawLine(const Offset(right, top), const Offset(right, bottom), wire);
    canvas.drawLine(const Offset(left, top), const Offset(left, bottom), wire);
    const positive = center - 4.5;
    const negative = center + 4.5;
    canvas.drawLine(const Offset(left, bottom), const Offset(positive, bottom), wire);
    canvas.drawLine(const Offset(negative, bottom), const Offset(right, bottom), wire);

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

    for (final (rect, label) in resistors) {
      canvas.drawRect(rect, wire);
      _label(canvas, label, Offset(rect.center.dx, rect.top - 14), ink);
    }
    _label(canvas, '12 V', const Offset(center, bottom + 28), ink);
  }

  void _label(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
