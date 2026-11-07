import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

import 'package:flutter/scheduler.dart';

import '../utils/figure_clock.dart';

/// 左 100 Hz（右向き）と右 104 Hz（左向き）の合成を、位置 x に対して描く。
///
/// y = sin(2π·100 t − k1 x) + sin(2π·104 t + k2 x)。
/// アニメは t だけを進める。実時間の 1/50（以前の 1/10 のさらに 1/5）。
class BeatsFigure extends StatefulWidget {
  const BeatsFigure({super.key});

  @override
  State<BeatsFigure> createState() => _BeatsFigureState();
}

class _BeatsFigureState extends State<BeatsFigure>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  var _micros = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() => _micros = elapsed.inMicroseconds);
    });
    if (figureClockRuns) {
      _ticker.start();
    } else {
      _micros = 24500;
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      width: 320,
      child: CustomPaint(painter: _BeatsPainter(seconds: _micros / 1e6)),
    );
  }
}

class _BeatsPainter extends CustomPainter {
  const _BeatsPainter({required this.seconds});

  /// 画面上の時刻。物理の時刻はこれの 1/50。
  final double seconds;

  static const _ink = Color(0xFF37474F);
  static const _wave = Color(0xFF1565C0);
  static const _center = 68.0;
  static const _component = 12.0;
  static const _waveLeft = 64.0;
  static const _waveRight = 256.0;
  static const _playback = 50.0;
  static const _f1 = 100.0;
  static const _f2 = 104.0;
  static const _fBar = (_f1 + _f2) / 2;

  /// 音叉のあいだを、平均の波長 2 個分とする。
  static const _lambda = (_waveRight - _waveLeft) / 2;

  double get _physicsT => seconds / _playback;

  double get _kBar => 2 * math.pi / _lambda;

  double _s(double x) => x - _waveLeft;

  double _sum(double x) {
    final s = _s(x);
    final t = _physicsT;
    final k1 = _kBar * _f1 / _fBar;
    final k2 = _kBar * _f2 / _fBar;
    return math.sin(2 * math.pi * _f1 * t - k1 * s) +
        math.sin(2 * math.pi * _f2 * t + k2 * s);
  }

  /// |2 cos((ω1−ω2)t/2 − k̄x)|。合成の絶対値はこの中に収まる。
  double _reach(double x) {
    final slow = math.pi * (_f1 - _f2) * _physicsT - _kBar * _s(x);
    return (2 * _component * math.cos(slow)).abs();
  }

  @override
  void paint(Canvas canvas, Size size) {
    _equilibrium(canvas);
    _envelope(canvas);
    _trace(canvas);

    final ink = Paint()
      ..color = _ink
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    _fork(canvas, 32, ink);
    _fork(canvas, 288, ink);
    _point(canvas);
    _label(canvas, '100 Hz', const Offset(32, 142));
    _label(canvas, '104 Hz', const Offset(288, 142));
  }

  /// 波長1個分の位置。t = 0 では腹。
  static const _mark = _waveLeft + _lambda;

  void _point(Canvas canvas) {
    final y = _center - _component * _sum(_mark);
    final center = Offset(_mark, y);
    canvas.drawCircle(center, 5.5, Paint()..color = const Color(0xFFD32F2F));
    canvas.drawCircle(
      center,
      5.5,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  void _equilibrium(Canvas canvas) {
    _dashed(
      canvas,
      const Offset(_waveLeft, _center),
      const Offset(_waveRight, _center),
      Paint()
        ..color = _ink.withValues(alpha: 0.35)
        ..strokeWidth = 1,
    );
  }

  void _envelope(Canvas canvas) {
    final paint = Paint()
      ..color = _wave.withValues(alpha: 0.45)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final upper = Path();
    final lower = Path();
    const steps = 160;
    for (var i = 0; i <= steps; i++) {
      final u = i / steps;
      final x = _waveLeft + (_waveRight - _waveLeft) * u;
      final reach = _reach(x);
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
    canvas.drawPath(upper, paint);
    canvas.drawPath(lower, paint);
  }

  void _trace(Canvas canvas) {
    final path = Path();
    const steps = 160;
    for (var i = 0; i <= steps; i++) {
      final u = i / steps;
      final x = _waveLeft + (_waveRight - _waveLeft) * u;
      final y = _center - _component * _sum(x);
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
        ..strokeWidth = 2.2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
  }

  void _fork(Canvas canvas, double cx, Paint paint) {
    const prong = 9.0;
    const top = 40.0;
    const bend = 80.0;
    final u = Path()
      ..moveTo(cx - prong, top)
      ..lineTo(cx - prong, bend - 12)
      ..quadraticBezierTo(cx - prong, bend, cx, bend)
      ..quadraticBezierTo(cx + prong, bend, cx + prong, bend - 12)
      ..lineTo(cx + prong, top);
    canvas.drawPath(u, paint);
    canvas.drawLine(Offset(cx, bend), Offset(cx, bend + 22), paint);
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

  void _label(Canvas canvas, String text, Offset origin) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink, fontWeight: FontWeight.w600),
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
      oldDelegate.seconds != seconds;
}
