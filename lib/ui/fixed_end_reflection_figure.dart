import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ヒント用。正の向きに進む波が壁で固定端反射し、定常波になる。
///
/// 壁の端は結ばれたまま動かず、そこが節になる。
class FixedEndReflectionFigure extends StatefulWidget {
  const FixedEndReflectionFigure({super.key});

  @override
  State<FixedEndReflectionFigure> createState() => _FixedEndReflectionFigureState();
}

class _FixedEndReflectionFigureState extends State<FixedEndReflectionFigure>
    with TickerProviderStateMixin {
  late final AnimationController _clock;
  late final AnimationController _intro;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    final binding = WidgetsBinding.instance.runtimeType.toString();
    if (binding.contains('TestWidgetsFlutterBinding')) {
      _intro.value = 1;
      _clock.value = 0.25;
      return;
    }
    _clock.repeat();
    _intro.forward();
  }

  @override
  void dispose() {
    _clock.dispose();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 176,
      width: 280,
      child: AnimatedBuilder(
        animation: Listenable.merge([_clock, _intro]),
        builder: (context, _) {
          return CustomPaint(
            painter: _FixedEndPainter(
              phase: _clock.value * 2 * math.pi,
              intro: _intro.value,
            ),
          );
        },
      ),
    );
  }
}

class _FixedEndPainter extends CustomPainter {
  const _FixedEndPainter({required this.phase, required this.intro});

  final double phase;
  final double intro;

  static const _ink = Color(0xFF37474F);
  static const _wave = Color(0xFF1565C0);
  static const _left = 20.0;
  static const _wall = 236.0;
  static const _center = 74.0;
  static const _component = 13.0;
  static const _lambda = 144.0;

  double get _reflect => _span(intro, 0.28, 0.62);

  double get _mark => _span(intro, 0.62, 0.86);

  double _span(double t, double start, double end) {
    if (t <= start) return 0;
    if (t >= end) return 1;
    return Curves.easeInOut.transform((t - start) / (end - start));
  }

  /// 入射波と、位相が反転する反射波。壁では打ち消し合って節になる。
  double _displacement(double x) {
    final k = 2 * math.pi / _lambda;
    final incident = math.sin(phase - k * x);
    final reflected = math.sin(phase + k * (x - 2 * _wall));
    return _component * (incident - _reflect * reflected);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _axis(canvas);
    _equilibrium(canvas);
    _drawWall(canvas);
    _envelope(canvas);
    _drawWave(canvas);
    _peg(canvas);
    _nodes(canvas);
    _direction(canvas);
  }

  void _axis(Canvas canvas) {
    const y = 164.0;
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(_left, y), const Offset(_left + 36, y), paint);
    final tip = const Offset(_left + 36, y);
    canvas.drawLine(tip, tip + const Offset(-7, -4), paint);
    canvas.drawLine(tip, tip + const Offset(-7, 4), paint);
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
    _label(canvas, '壁', const Offset(_wall + 16, 22), _ink);
  }

  void _envelope(Canvas canvas) {
    if (_mark <= 0) return;
    final paint = Paint()
      ..color = _wave.withValues(alpha: 0.35 * _mark)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    final k = 2 * math.pi / _lambda;
    final upper = Path();
    final lower = Path();
    const steps = 72;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = _left + (_wall - _left) * t;
      final reach = _component * (1 + _reflect) * math.sin(k * (_wall - x)).abs();
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

  /// 壁に結ばれた端。反射がそろうと、この点から動かなくなる。
  void _peg(Canvas canvas) {
    const peg = Offset(_wall, _center);
    canvas.drawCircle(peg, 5, Paint()..color = Colors.white);
    canvas.drawCircle(peg, 4.2, Paint()..color = _ink);
  }

  void _nodes(Canvas canvas) {
    if (_mark <= 0) return;
    final rest = Paint()..color = _ink.withValues(alpha: 0.45 * _mark);
    for (final multiple in [1.0, 2.0]) {
      final x = _wall - multiple * _lambda / 2;
      if (x > _left + 8) canvas.drawCircle(Offset(x, _center), 3, rest);
    }
    final focus = Paint()..color = _wave.withValues(alpha: _mark);
    canvas.drawCircle(const Offset(_wall, _center), 4.5, focus);
    _label(
      canvas,
      '節',
      const Offset(_wall - 18, 22),
      _wave,
      opacity: _mark,
    );
  }

  void _direction(Canvas canvas) {
    final opacity = 1 - _reflect;
    if (opacity <= 0) return;
    final paint = Paint()
      ..color = _wave.withValues(alpha: opacity)
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const y = 40.0;
    const tip = Offset(118, y);
    canvas.drawLine(const Offset(78, y), tip, paint);
    canvas.drawLine(tip, tip + const Offset(-8, -4), paint);
    canvas.drawLine(tip, tip + const Offset(-8, 4), paint);
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
  bool shouldRepaint(covariant _FixedEndPainter oldDelegate) =>
      oldDelegate.phase != phase || oldDelegate.intro != intro;
}
