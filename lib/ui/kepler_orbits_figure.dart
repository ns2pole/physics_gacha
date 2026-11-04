import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';

/// 太陽のまわりの二つの円軌道。半径の比は見やすさのためで、値はラベルに任せる。
/// 内側は 4 秒、外側は 32 秒で一周する。内側の一周ごとに戻さず、
/// 両方が同時に元へ戻る 192 秒（約 3 分）でループする。
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
      duration: const Duration(seconds: 192),
    );
    if (figureClockRuns) {
      _clock.repeat();
    } else {
      _clock.value = 0.0025;
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
            painter: _KeplerOrbitsPainter(sun: labels.sun, phase: _clock.value),
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
    // phase が 0 から 1 までで内側は 48 周、外側は 6 周。どちらも整数周なので継ぎ目で飛ばない。
    const innerTurns = 48.0;
    const outerTurns = 6.0;
    final innerAngle = -math.pi / 2 + 2 * math.pi * phase * innerTurns;
    final outerAngle = -math.pi / 2 + 2 * math.pi * phase * outerTurns;

    canvas.drawCircle(center, 7, Paint()..color = _ink);
    canvas.drawCircle(center, inner, wire);
    canvas.drawCircle(center, outer, wire);
    canvas.drawCircle(
      _onOrbit(center, inner, innerAngle),
      4,
      Paint()..color = _ink,
    );
    canvas.drawCircle(
      _onOrbit(center, outer, outerAngle),
      4,
      Paint()..color = _ink,
    );

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
  bool shouldRepaint(covariant _KeplerOrbitsPainter oldDelegate) =>
      oldDelegate.sun != sun || oldDelegate.phase != phase;
}
