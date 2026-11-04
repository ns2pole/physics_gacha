import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 10 μF、22 μF、68 μF のコンデンサーを並列につないだ回路。
class ParallelCapacitorsFigure extends StatelessWidget {
  const ParallelCapacitorsFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 224,
      width: 220,
      child: CustomPaint(painter: _ParallelCapacitorsPainter()),
    );
  }
}

class _ParallelCapacitorsPainter extends CustomPainter {
  const _ParallelCapacitorsPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final plates = Paint()
      ..color = _ink
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const left = 36.0;
    const right = 184.0;
    const center = (left + right) / 2;
    const plateGap = 7.0;
    const plateHalf = 15.0;
    const rows = [52.0, 124.0, 196.0];
    const labels = ['10 μF', '22 μF', '68 μF'];

    canvas.drawLine(Offset(left, rows.first), Offset(left, rows.last), wire);
    canvas.drawLine(Offset(right, rows.first), Offset(right, rows.last), wire);

    for (var i = 0; i < rows.length; i++) {
      final y = rows[i];
      canvas.drawLine(Offset(left, y), Offset(center - plateGap, y), wire);
      canvas.drawLine(Offset(center + plateGap, y), Offset(right, y), wire);
      canvas.drawLine(
        Offset(center - plateGap, y - plateHalf),
        Offset(center - plateGap, y + plateHalf),
        plates,
      );
      canvas.drawLine(
        Offset(center + plateGap, y - plateHalf),
        Offset(center + plateGap, y + plateHalf),
        plates,
      );
      _label(canvas, labels[i], Offset(center, y - plateHalf - 13));
    }
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
  bool shouldRepaint(covariant _ParallelCapacitorsPainter oldDelegate) => false;
}
