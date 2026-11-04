import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 1000 μF のコンデンサーに 18 V の電池をつないだ回路。
class ChargedCapacitorFigure extends StatelessWidget {
  const ChargedCapacitorFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 150,
      width: 200,
      child: CustomPaint(painter: _ChargedCapacitorPainter()),
    );
  }
}

class _ChargedCapacitorPainter extends CustomPainter {
  const _ChargedCapacitorPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const left = 24.0;
    const right = 176.0;
    const top = 52.0;
    const bottom = 104.0;
    const center = (left + right) / 2;
    const plateGap = 7.0;
    const plateHalf = 20.0;

    canvas.drawLine(
      const Offset(left, top),
      const Offset(center - plateGap, top),
      wire,
    );
    canvas.drawLine(
      const Offset(center + plateGap, top),
      const Offset(right, top),
      wire,
    );
    canvas.drawLine(
      const Offset(right, top),
      const Offset(right, bottom),
      wire,
    );
    canvas.drawLine(const Offset(left, top), const Offset(left, bottom), wire);

    final plates = Paint()
      ..color = _ink
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      const Offset(center - plateGap, top - plateHalf),
      const Offset(center - plateGap, top + plateHalf),
      plates,
    );
    canvas.drawLine(
      const Offset(center + plateGap, top - plateHalf),
      const Offset(center + plateGap, top + plateHalf),
      plates,
    );

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
        ..color = _ink
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    _label(canvas, '1000 μF', const Offset(center, top - plateHalf - 14));
    _label(canvas, '18 V', const Offset(center, bottom + 28));
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink, height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _ChargedCapacitorPainter oldDelegate) => false;
}
