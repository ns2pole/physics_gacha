import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';
import 'span_marker.dart';

/// 地面から 45° で投げ、90 m 先の地面に落ちる。
class LongThrowFigure extends StatelessWidget {
  const LongThrowFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 188,
      width: 230,
      child: CustomPaint(painter: _LongThrowPainter()),
    );
  }
}

class _LongThrowPainter extends CustomPainter {
  const _LongThrowPainter();

  static const _ink = Color(0xFF37474F);
  static const _launch = Offset(36, 128);
  static const _land = Offset(186, 128);
  static const _control = Offset(111, 53);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = _ink;

    canvas.drawLine(const Offset(16, 128), const Offset(214, 128), line);

    final path = Path()
      ..moveTo(_launch.dx, _launch.dy)
      ..quadraticBezierTo(_control.dx, _control.dy, _land.dx, _land.dy);
    canvas.drawPath(path, line);

    canvas.drawCircle(_launch, 6, fill);
    canvas.drawArc(
      Rect.fromCircle(center: _launch, radius: 16),
      0,
      -math.pi / 4,
      false,
      line,
    );
    _label(canvas, '45°', const Offset(76, 118));

    paintSpanMarker(
      canvas: canvas,
      from: const Offset(36, 152),
      to: const Offset(186, 152),
      label: '90 m',
      color: _ink,
    );
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _LongThrowPainter oldDelegate) => false;
}
