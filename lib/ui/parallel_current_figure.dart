import 'package:flutter/material.dart';

/// 6.0 V の電池に 3.0 Ω と 6.0 Ω を並列につないだ回路。
///
/// 1本の抵抗と下辺中央の電池、という単ループに、横枝の抵抗を1本足して
/// ループを1つ増やしたもの。電池の極板は縦。
class ParallelCurrentFigure extends StatelessWidget {
  const ParallelCurrentFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      width: 220,
      child: CustomPaint(painter: _ParallelCurrentPainter()),
    );
  }
}

class _ParallelCurrentPainter extends CustomPainter {
  const _ParallelCurrentPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-40, -8);
    const ink = Color(0xFF37474F);
    final wire = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = 48.0;
    const right = 252.0;
    const top = 52.0;
    const mid = 116.0;
    const bottom = 172.0;
    const center = (left + right) / 2;
    final upper = Rect.fromCenter(
      center: const Offset(center, top),
      width: 72,
      height: 24,
    );
    final lower = Rect.fromCenter(
      center: const Offset(center, mid),
      width: 72,
      height: 24,
    );

    canvas.drawLine(const Offset(left, top), Offset(upper.left, top), wire);
    canvas.drawLine(Offset(upper.right, top), const Offset(right, top), wire);
    canvas.drawLine(const Offset(left, mid), Offset(lower.left, mid), wire);
    canvas.drawLine(Offset(lower.right, mid), const Offset(right, mid), wire);
    canvas.drawLine(const Offset(left, top), const Offset(left, bottom), wire);
    canvas.drawLine(const Offset(right, top), const Offset(right, bottom), wire);

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

    canvas.drawRect(upper, wire);
    canvas.drawRect(lower, wire);
    _label(canvas, '3.0 Ω', Offset(center, upper.top - 14), ink);
    _label(canvas, '6.0 Ω', Offset(center, lower.top - 14), ink);
    _label(canvas, '6.0 V', const Offset(center, bottom + 22), ink);
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
  bool shouldRepaint(covariant _ParallelCurrentPainter oldDelegate) => false;
}
