import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';

/// 太陽のまわりを地球が円運動する。北極側から見た図。
class SunOrbitFigure extends StatefulWidget {
  const SunOrbitFigure({super.key});

  @override
  State<SunOrbitFigure> createState() => _SunOrbitFigureState();
}

class _SunOrbitFigureState extends State<SunOrbitFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    if (figureClockRuns) _clock.repeat();
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      height: 210,
      width: 230,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _SunOrbitPainter(
              sun: labels.sun,
              earth: labels.earth,
              phase: _clock.value,
            ),
          );
        },
      ),
    );
  }
}

class _SunOrbitPainter extends CustomPainter {
  const _SunOrbitPainter({
    required this.sun,
    required this.earth,
    required this.phase,
  });

  final String sun;
  final String earth;
  final double phase;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = _ink;

    const center = Offset(115, 108);
    const sunR = 22.0;
    const orbitR = 74.0;
    final angle = -math.pi / 2 + phase * 2 * math.pi;
    final earthCenter = Offset(
      center.dx + orbitR * math.cos(angle),
      center.dy + orbitR * math.sin(angle),
    );

    canvas.drawCircle(center, orbitR, line);
    canvas.drawLine(center, earthCenter, line);
    canvas.drawCircle(center, sunR, line);
    canvas.drawCircle(center, 2.4, fill);
    canvas.drawCircle(earthCenter, 5.5, fill);

    _label(canvas, sun, center + const Offset(0, sunR + 14));
    final outward = (earthCenter - center) / orbitR;
    _label(canvas, earth, earthCenter + outward * 16);
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: figureLabelStyle(color: _ink)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SunOrbitPainter oldDelegate) =>
      oldDelegate.sun != sun ||
      oldDelegate.earth != earth ||
      oldDelegate.phase != phase;
}
