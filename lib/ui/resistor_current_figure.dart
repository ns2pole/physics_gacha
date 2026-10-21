import 'package:flutter/material.dart';

/// 抵抗 1 個の回路。電流の矢印は左辺、電流の値はループ内の矢印の右に置く。
class ResistorCurrentFigure extends StatelessWidget {
  const ResistorCurrentFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 130,
      width: 248,
      child: CustomPaint(painter: _ResistorCurrentPainter()),
    );
  }
}

class _ResistorCurrentPainter extends CustomPainter {
  const _ResistorCurrentPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-24, -8);
    const ink = Color(0xFF37474F);
    final wire = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = 36.0;
    const right = 264.0;
    const top = 28.0;
    const bottom = 116.0;
    const center = (left + right) / 2;
    final resistor = Rect.fromLTWH(center - 44, top - 12, 88, 24);

    canvas.drawLine(const Offset(left, top), Offset(resistor.left, top), wire);
    canvas.drawLine(Offset(resistor.right, top), const Offset(right, top), wire);
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

    canvas.drawRect(resistor, wire);

    const arrowY = (top + bottom) / 2;
    _arrowHeadUp(canvas, const Offset(left, arrowY), ink);
    _labelInside(
      canvas,
      '1.6×10³ mA',
      const Offset(left + 16, arrowY),
      ink,
    );
  }

  void _arrowHeadUp(Canvas canvas, Offset center, Color color) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(center.dx, center.dy - 7)
      ..lineTo(center.dx - 4.5, center.dy + 5)
      ..lineTo(center.dx + 4.5, center.dy + 5)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _labelInside(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(0, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _ResistorCurrentPainter oldDelegate) => false;
}
