import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';

/// 左の音叉（440 Hz）から右へ、右の音叉（442 Hz）から左へ進む波の包絡線。
///
/// 山そのものは 440 Hz なので描かず、振幅の範囲だけを塗る。
/// 1 秒で平均の波長ひとつ分、低い方の音叉へずれる。各点の振幅は 0.5 s ごとに最大になる。
class BeatsFigure extends StatefulWidget {
  const BeatsFigure({super.key});

  @override
  State<BeatsFigure> createState() => _BeatsFigureState();
}

class _BeatsFigureState extends State<BeatsFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
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
    return SizedBox(
      height: 156,
      width: 300,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _BeatsPainter(phase: _clock.value),
          );
        },
      ),
    );
  }
}

class _BeatsPainter extends CustomPainter {
  const _BeatsPainter({required this.phase});

  /// 0 から 1 が、物理の 1 秒。
  final double phase;

  static const _ink = Color(0xFF37474F);
  static const _wave = Color(0xFF1565C0);
  static const _wavelengths = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    const centerY = 74.0;
    const amplitude = 26.0;
    const waveLeft = 78.0;
    const waveRight = 222.0;
    const leftFork = 40.0;
    const rightFork = 260.0;

    final axis = Paint()
      ..color = _ink.withValues(alpha: 0.35)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      const Offset(waveLeft, centerY),
      const Offset(waveRight, centerY),
      axis,
    );

    const steps = 96;
    final upper = <Offset>[];
    final lower = <Offset>[];
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = waveLeft + (waveRight - waveLeft) * t;
      final env = amplitude *
          math.cos(2 * math.pi * (phase + _wavelengths * t)).abs();
      upper.add(Offset(x, centerY - env));
      lower.add(Offset(x, centerY + env));
    }

    final fill = Path()..moveTo(upper.first.dx, upper.first.dy);
    for (final point in upper.skip(1)) {
      fill.lineTo(point.dx, point.dy);
    }
    for (final point in lower.reversed) {
      fill.lineTo(point.dx, point.dy);
    }
    fill.close();
    canvas.drawPath(fill, Paint()..color = _wave.withValues(alpha: 0.18));

    final stroke = Paint()
      ..color = _wave
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(_through(upper), stroke);
    canvas.drawPath(_through(lower), stroke);

    final ink = Paint()
      ..color = _ink
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    _fork(canvas, leftFork, ink);
    _fork(canvas, rightFork, ink);
    _arrow(
      canvas,
      const Offset(56, centerY),
      const Offset(74, centerY),
      stroke,
    );
    _arrow(
      canvas,
      const Offset(244, centerY),
      const Offset(226, centerY),
      stroke,
    );
    _label(canvas, '440 Hz', const Offset(leftFork, 128));
    _label(canvas, '442 Hz', const Offset(rightFork, 128));
  }

  Path _through(List<Offset> points) {
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final point in points.skip(1)) {
      path.lineTo(point.dx, point.dy);
    }
    return path;
  }

  void _fork(Canvas canvas, double cx, Paint paint) {
    const prong = 9.0;
    const top = 42.0;
    const bend = 82.0;
    final u = Path()
      ..moveTo(cx - prong, top)
      ..lineTo(cx - prong, bend - 12)
      ..quadraticBezierTo(cx - prong, bend, cx, bend)
      ..quadraticBezierTo(cx + prong, bend, cx + prong, bend - 12)
      ..lineTo(cx + prong, top);
    canvas.drawPath(u, paint);
    canvas.drawLine(Offset(cx, bend), Offset(cx, bend + 22), paint);
  }

  void _arrow(Canvas canvas, Offset from, Offset to, Paint source) {
    final paint = Paint()
      ..color = source.color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to, paint);
    final delta = to - from;
    final u = delta / delta.distance;
    final n = Offset(-u.dy, u.dx);
    const head = 7.0;
    canvas.drawLine(to, to - u * head + n * 3.4, paint);
    canvas.drawLine(to, to - u * head - n * 3.4, paint);
  }

  void _label(Canvas canvas, String text, Offset origin) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: _ink,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _BeatsPainter oldDelegate) =>
      oldDelegate.phase != phase;
}
