import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 天井から 49 N/m と 98 N/m のばねを直列につるし、下端に 1.0 kg のおもりを静止させる。
class SeriesSpringsFigure extends StatelessWidget {
  const SeriesSpringsFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 200,
      width: 176,
      child: CustomPaint(painter: _SeriesSpringsPainter()),
    );
  }
}

class _SeriesSpringsPainter extends CustomPainter {
  const _SeriesSpringsPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const cx = 62.0;
    const ceiling = 16.0;

    canvas.drawLine(
      const Offset(16, ceiling),
      const Offset(108, ceiling),
      line,
    );
    for (var x = 24.0; x < 108; x += 12) {
      canvas.drawLine(Offset(x, ceiling), Offset(x - 8, ceiling - 8), line);
    }

    const joint = Offset(cx, 84);
    _spring(canvas, const Offset(cx, ceiling), joint, line);
    _spring(canvas, joint, const Offset(cx, 152), line);
    canvas.drawCircle(joint, 2.4, Paint()..color = _ink);

    final mass = Rect.fromLTWH(cx - 26, 152, 52, 34);
    canvas.drawRect(mass, line);
    _label(canvas, '49 N/m', const Offset(128, 47));
    _label(canvas, '98 N/m', const Offset(128, 121));
    _label(canvas, '1.0 kg', mass.center);
  }

  void _spring(Canvas canvas, Offset a, Offset b, Paint paint) {
    final delta = b - a;
    final length = delta.distance;
    if (length < 1) return;
    final dir = delta / length;
    final normal = Offset(-dir.dy, dir.dx);
    const turns = 6;
    const amp = 8.0;
    const steps = 36;
    final path = Path()..moveTo(a.dx, a.dy);
    for (var i = 1; i <= steps; i++) {
      final t = i / steps;
      final along = a + dir * (length * t);
      final wave = math.sin(t * turns * 2 * math.pi);
      path.lineTo(
        along.dx + normal.dx * amp * wave,
        along.dy + normal.dy * amp * wave,
      );
    }
    canvas.drawPath(path, paint);
  }

  void _label(Canvas canvas, String text, Offset origin) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SeriesSpringsPainter oldDelegate) => false;
}
