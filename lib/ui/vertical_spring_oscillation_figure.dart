import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';

/// 天井からつるした鉛直ばねの単振動。おもりが釣り合いの上下に動く。
class VerticalSpringOscillationFigure extends StatefulWidget {
  const VerticalSpringOscillationFigure({super.key});

  @override
  State<VerticalSpringOscillationFigure> createState() =>
      _VerticalSpringOscillationFigureState();
}

class _VerticalSpringOscillationFigureState
    extends State<VerticalSpringOscillationFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (figureClockRuns) {
      _clock.repeat();
    } else {
      _clock.value = 0.25;
    }
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 162,
      width: 158,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _VerticalSpringOscillationPainter(phase: _clock.value),
          );
        },
      ),
    );
  }
}

class _VerticalSpringOscillationPainter extends CustomPainter {
  const _VerticalSpringOscillationPainter({required this.phase});

  final double phase;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-28, -6);
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const cx = 90.0;
    const ceiling = 22.0;
    const restTop = 108.0;
    const amplitude = 16.0;
    const massW = 44.0;
    const massH = 36.0;
    final massTop = restTop + amplitude * math.sin(phase * 2 * math.pi);

    canvas.drawLine(
      const Offset(36, ceiling),
      const Offset(144, ceiling),
      line,
    );
    for (var x = 44.0; x < 144; x += 12) {
      canvas.drawLine(Offset(x, ceiling), Offset(x - 8, ceiling - 8), line);
    }

    _spring(canvas, const Offset(cx, ceiling), Offset(cx, massTop), line);
    final mass = Rect.fromLTWH(cx - massW / 2, massTop, massW, massH);
    canvas.drawRect(mass, line);
    _label(canvas, '1.0 kg', mass.center);
    _label(canvas, '4.0 N/m', const Offset(148, 70));
  }

  void _spring(Canvas canvas, Offset a, Offset b, Paint paint) {
    final delta = b - a;
    final length = delta.distance;
    if (length < 1) return;
    final dir = delta / length;
    final normal = Offset(-dir.dy, dir.dx);
    const turns = 8;
    const amp = 9.0;
    const steps = 48;
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
        style: const TextStyle(color: _ink, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _VerticalSpringOscillationPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
