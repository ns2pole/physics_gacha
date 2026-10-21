import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';

/// ヒント用。壁で自由端反射した定常波。
///
/// 壁は腹のまま大きく揺れ、壁から波長の4分の1だけ手前の点は動かない。
class FreeEndReflectionFigure extends StatefulWidget {
  const FreeEndReflectionFigure({super.key});

  @override
  State<FreeEndReflectionFigure> createState() => _FreeEndReflectionFigureState();
}

class _FreeEndReflectionFigureState extends State<FreeEndReflectionFigure>
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
    final labels = FigureLabels.of(context);
    return SizedBox(
      height: 170,
      width: 320,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _FreeEndPainter(
              phase: _clock.value * 2 * math.pi,
              wall: labels.wall,
              antinode: labels.antinode,
              node: labels.node,
            ),
          );
        },
      ),
    );
  }
}

class _FreeEndPainter extends CustomPainter {
  const _FreeEndPainter({
    required this.phase,
    required this.wall,
    required this.antinode,
    required this.node,
  });

  final double phase;
  final String wall;
  final String antinode;
  final String node;

  static const _ink = Color(0xFF37474F);
  static const _wave = Color(0xFF1565C0);
  /// 左端が x = 0。波長 12 cm を 144 px とし、壁 x = 20 cm まで描く。
  static const _left = 28.0;
  static const _wall = _left + 240.0;
  static const _center = 74.0;
  static const _component = 13.0;
  static const _lambda = 144.0;

  /// 入射波と、位相が反転しない反射波。壁では足し合わさって腹になる。
  double _displacement(double x) {
    final k = 2 * math.pi / _lambda;
    final incident = math.sin(phase - k * x);
    final reflected = math.sin(phase + k * (x - 2 * _wall));
    return _component * (incident + reflected);
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(0, -6);
    _axis(canvas);
    _equilibrium(canvas);
    _drawWall(canvas);
    _envelope(canvas);
    _drawWave(canvas);
    _ring(canvas);
    _nodes(canvas);
  }

  void _axis(Canvas canvas) {
    const y = 164.0;
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(_left, y - 5), Offset(_left, y + 5), paint);
    canvas.drawLine(const Offset(_left, y), const Offset(_left + 36, y), paint);
    final tip = const Offset(_left + 36, y);
    canvas.drawLine(tip, tip + const Offset(-7, -4), paint);
    canvas.drawLine(tip, tip + const Offset(-7, 4), paint);
    _label(canvas, '0', const Offset(_left, y - 14), _ink, weight: FontWeight.w500);
    _label(canvas, 'x', const Offset(_left + 48, y), _ink, weight: FontWeight.w500);
  }

  void _equilibrium(Canvas canvas) {
    _dashed(
      canvas,
      const Offset(_left, _center),
      const Offset(_wall, _center),
      Paint()
        ..color = _ink.withValues(alpha: 0.35)
        ..strokeWidth = 1,
    );
  }

  void _drawWall(Canvas canvas) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.square;
    canvas.drawLine(
      const Offset(_wall, 36),
      const Offset(_wall, 118),
      paint,
    );
    final hatch = Paint()
      ..color = _ink
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < 7; i++) {
      final y = 40.0 + i * 12;
      canvas.drawLine(Offset(_wall, y), Offset(_wall + 9, y + 7), hatch);
    }
    _label(canvas, wall, const Offset(_wall + 16, 22), _ink);
    _label(canvas, antinode, const Offset(_wall - 18, 22), _wave);
  }

  void _envelope(Canvas canvas) {
    final paint = Paint()
      ..color = _wave.withValues(alpha: 0.35)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final k = 2 * math.pi / _lambda;
    final upper = Path();
    final lower = Path();
    const steps = 72;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = _left + (_wall - _left) * t;
      final reach = 2 * _component * math.cos(k * (_wall - x)).abs();
      final top = Offset(x, _center - reach);
      final bottom = Offset(x, _center + reach);
      if (i == 0) {
        upper.moveTo(top.dx, top.dy);
        lower.moveTo(bottom.dx, bottom.dy);
      } else {
        upper.lineTo(top.dx, top.dy);
        lower.lineTo(bottom.dx, bottom.dy);
      }
    }
    _dashedPath(canvas, upper, paint);
    _dashedPath(canvas, lower, paint);
  }

  void _drawWave(Canvas canvas) {
    final path = Path();
    const steps = 80;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = _left + (_wall - _left) * t;
      final y = _center - _displacement(x);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _wave
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _ring(Canvas canvas) {
    final end = Offset(_wall, _center - _displacement(_wall));
    canvas.drawCircle(end, 5, Paint()..color = Colors.white);
    canvas.drawCircle(
      end,
      5,
      Paint()
        ..color = _wave
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _nodes(Canvas canvas) {
    final nearest = _wall - _lambda / 4;
    final rest = Paint()..color = _ink.withValues(alpha: 0.45);
    for (final multiple in [3.0, 5.0]) {
      final x = _wall - multiple * _lambda / 4;
      if (x > _left + 8) canvas.drawCircle(Offset(x, _center), 3, rest);
    }
    canvas.drawCircle(Offset(nearest, _center), 4.5, Paint()..color = _wave);
    _label(canvas, node, Offset(nearest, _center + 28), _wave);
  }

  void _dashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    const dash = 4.0;
    const gap = 3.0;
    final delta = to - from;
    final length = delta.distance;
    if (length == 0) return;
    final step = delta / length;
    var drawn = 0.0;
    while (drawn < length) {
      final end = math.min(drawn + dash, length);
      canvas.drawLine(from + step * drawn, from + step * end, paint);
      drawn += dash + gap;
    }
  }

  void _dashedPath(Canvas canvas, Path path, Paint paint) {
    for (final metric in path.computeMetrics()) {
      var drawn = 0.0;
      while (drawn < metric.length) {
        final end = math.min(drawn + 4, metric.length);
        canvas.drawPath(metric.extractPath(drawn, end), paint);
        drawn += 7;
      }
    }
  }

  void _label(
    Canvas canvas,
    String text,
    Offset center,
    Color color, {
    double opacity = 1,
    FontWeight weight = FontWeight.w600,
    double size = 13,
  }) {
    if (opacity <= 0) return;
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withValues(alpha: opacity),
          fontSize: size,
          fontWeight: weight,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _FreeEndPainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.wall != wall ||
      oldDelegate.antinode != antinode ||
      oldDelegate.node != node;
}
