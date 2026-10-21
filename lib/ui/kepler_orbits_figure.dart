import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';

/// 太陽のまわりの二つの円軌道。半径の比は見やすさのためで、値はラベルに任せる。
/// 内側は 1 年、外側は 8 年で一周する。
class KeplerOrbitsFigure extends StatefulWidget {
  const KeplerOrbitsFigure({super.key});

  @override
  State<KeplerOrbitsFigure> createState() => _KeplerOrbitsFigureState();
}

class _KeplerOrbitsFigureState extends State<KeplerOrbitsFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    if (figureClockRuns) {
      _clock.repeat();
    } else {
      _clock.value = 0.12;
    }
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
      height: 200,
      width: 250,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _KeplerOrbitsPainter(
              sun: labels.sun,
              phase: _clock.value,
            ),
          );
        },
      ),
    );
  }
}

class _KeplerOrbitsPainter extends CustomPainter {
  const _KeplerOrbitsPainter({required this.sun, required this.phase});

  final String sun;
  final double phase;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-28, -8);
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const center = Offset(118, 98);
    const inner = 38.0;
    const outer = 78.0;
    final innerAngle = -math.pi / 2 + 2 * math.pi * phase;
    final outerAngle = -math.pi / 2 + 2 * math.pi * phase / 8;

    canvas.drawCircle(center, 7, Paint()..color = _ink);
    canvas.drawCircle(center, inner, wire);
    canvas.drawCircle(center, outer, wire);
    canvas.drawCircle(_onOrbit(center, inner, innerAngle), 4, Paint()..color = _ink);
    canvas.drawCircle(_onOrbit(center, outer, outerAngle), 4, Paint()..color = _ink);

    _label(canvas, sun, Offset(center.dx, center.dy + 18));
    _label(
      canvas,
      '1.0×10⁸ km',
      Offset(center.dx + inner + 52, center.dy - 10),
    );
    _label(canvas, '1 年', Offset(center.dx + inner + 52, center.dy + 8));
    _label(canvas, '4.0×10⁸ km', Offset(center.dx, center.dy + outer + 16));
  }

  Offset _onOrbit(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
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
  bool shouldRepaint(covariant _KeplerOrbitsPainter oldDelegate) =>
      oldDelegate.sun != sun || oldDelegate.phase != phase;
}
