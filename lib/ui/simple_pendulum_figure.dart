import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import 'span_marker.dart';

/// 微小な振れの単振り子。鉛直線の左右に小さく揺れる。
class SimplePendulumFigure extends StatefulWidget {
  const SimplePendulumFigure({super.key});

  @override
  State<SimplePendulumFigure> createState() => _SimplePendulumFigureState();
}

class _SimplePendulumFigureState extends State<SimplePendulumFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (figureClockRuns) {
      _clock.repeat();
    } else {
      _clock.value = 0.18;
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
      height: 168,
      width: 200,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _SimplePendulumPainter(phase: _clock.value),
          );
        },
      ),
    );
  }
}

class _SimplePendulumPainter extends CustomPainter {
  const _SimplePendulumPainter({required this.phase});

  final double phase;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const pivot = Offset(88, 18);
    const length = 118.0;
    const bobR = 14.0;
    final angle = 0.18 * math.sin(phase * 2 * math.pi);
    final bob = Offset(
      pivot.dx + length * math.sin(angle),
      pivot.dy + length * math.cos(angle),
    );
    final restBottom = Offset(pivot.dx, pivot.dy + length);

    canvas.drawLine(const Offset(58, 18), const Offset(118, 18), line);
    for (var x = 66.0; x < 118; x += 10) {
      canvas.drawLine(Offset(x, 18), Offset(x - 7, 10), line);
    }
    canvas.drawCircle(pivot, 3.2, Paint()..color = _ink);
    // 静止位置の鉛直（点線）。寸法 2.45 m はここ。
    _dashed(canvas, pivot, restBottom, line);
    canvas.drawLine(pivot, bob, line);
    canvas.drawCircle(bob, bobR, line);

    paintSpanMarker(
      canvas: canvas,
      from: Offset(pivot.dx + 28, pivot.dy),
      to: Offset(restBottom.dx + 28, restBottom.dy),
      label: '2.45 m',
      color: _ink,
      tick: const Offset(14, 0),
      guide: 20,
    );
  }

  void _dashed(Canvas canvas, Offset from, Offset to, Paint source) {
    final paint = Paint()
      ..color = source.color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final delta = to - from;
    final length = delta.distance;
    if (length == 0) return;
    final step = delta / length;
    const dash = 4.0;
    const gap = 4.0;
    var drawn = 0.0;
    while (drawn < length) {
      final end = math.min(drawn + dash, length);
      canvas.drawLine(from + step * drawn, from + step * end, paint);
      drawn += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _SimplePendulumPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
