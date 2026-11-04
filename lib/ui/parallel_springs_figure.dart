import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 天井から 49 N/m と 147 N/m のばねを並列につるし、下の棒に 2.0 kg のおもりを静止させる。
class ParallelSpringsFigure extends StatelessWidget {
  const ParallelSpringsFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 188,
      width: 248,
      child: CustomPaint(painter: _ParallelSpringsPainter()),
    );
  }
}

class _ParallelSpringsPainter extends CustomPainter {
  const _ParallelSpringsPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const ceiling = 16.0;
    const left = Offset(86, ceiling);
    const right = Offset(158, ceiling);
    const bottom = 108.0;

    canvas.drawLine(
      const Offset(48, ceiling),
      const Offset(196, ceiling),
      line,
    );
    for (var x = 56.0; x < 196; x += 12) {
      canvas.drawLine(Offset(x, ceiling), Offset(x - 8, ceiling - 8), line);
    }

    _spring(canvas, left, const Offset(86, bottom), line);
    _spring(canvas, right, const Offset(158, bottom), line);
    canvas.drawLine(const Offset(74, bottom), const Offset(170, bottom), line);
    canvas.drawLine(const Offset(122, bottom), const Offset(122, 120), line);

    final mass = Rect.fromLTWH(94, 120, 56, 34);
    canvas.drawRect(mass, line);
    _label(canvas, '49 N/m', const Offset(42, 62));
    _label(canvas, '147 N/m', const Offset(206, 62));
    _label(canvas, '2.0 kg', mass.center);
  }

  void _spring(Canvas canvas, Offset a, Offset b, Paint paint) {
    final delta = b - a;
    final length = delta.distance;
    if (length < 1) return;
    final dir = delta / length;
    final normal = Offset(-dir.dy, dir.dx);
    const turns = 7;
    const amp = 8.0;
    const steps = 42;
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
  bool shouldRepaint(covariant _ParallelSpringsPainter oldDelegate) => false;
}
