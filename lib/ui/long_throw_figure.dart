import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_label_style.dart';
import 'span_marker.dart';

/// 地面から 45° で投げ、90 m 先の地面に落ちる。
/// 軌道は点線。着地後 0.5 s 止めてからループする。
class LongThrowFigure extends StatefulWidget {
  const LongThrowFigure({super.key});

  @override
  State<LongThrowFigure> createState() => _LongThrowFigureState();
}

class _LongThrowFigureState extends State<LongThrowFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  /// 飛行 1.5 s + 停止 0.5 s。
  static const _cycle = Duration(milliseconds: 2000);
  static const _motionFrac = 1.5 / 2.0;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(vsync: this, duration: _cycle);
    if (figureClockRuns) {
      _clock.repeat();
    } else {
      _clock.value = 0.35;
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
      height: 282,
      width: 345,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _LongThrowPainter(
              travel: playPauseProgress(
                _clock.value,
                motion: _motionFrac,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LongThrowPainter extends CustomPainter {
  const _LongThrowPainter({required this.travel});

  final double travel;

  static const _ink = Color(0xFF37474F);
  static const _launch = Offset(36, 128);
  static const _land = Offset(186, 128);
  static const _control = Offset(111, 53);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(1.5);
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final soft = Paint()
      ..color = _ink.withValues(alpha: 0.55)
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = _ink;

    canvas.drawLine(const Offset(16, 128), const Offset(214, 128), line);

    _dashedBezier(canvas, soft);

    canvas.drawArc(
      Rect.fromCircle(center: _launch, radius: 16),
      0,
      -math.pi / 4,
      false,
      line,
    );
    // 発射角の二等分線上、弧のすぐ外。
    _label(canvas, '45°', const Offset(52, 114));

    paintSpanMarker(
      canvas: canvas,
      from: const Offset(36, 152),
      to: const Offset(186, 152),
      label: '90 m',
      color: _ink,
    );

    final bob = _pointOnBezier(travel.clamp(0.0, 1.0));
    canvas.drawCircle(bob, 6, fill);
  }

  Offset _pointOnBezier(double t) {
    final u = 1 - t;
    return _launch * (u * u) + _control * (2 * u * t) + _land * (t * t);
  }

  void _dashedBezier(Canvas canvas, Paint paint) {
    const steps = 48;
    const dash = 4.0;
    const gap = 3.5;
    var draw = true;
    var budget = dash;
    Offset? prev;
    for (var i = 0; i <= steps; i++) {
      final p = _pointOnBezier(i / steps);
      if (prev != null) {
        var a = prev;
        var remain = (p - a).distance;
        if (remain > 1e-6) {
          final dir = (p - a) / remain;
          while (remain > 1e-6) {
            final take = math.min(budget, remain);
            final next = a + dir * take;
            if (draw) {
              canvas.drawLine(a, next, paint);
            }
            a = next;
            remain -= take;
            budget -= take;
            if (budget <= 1e-6) {
              draw = !draw;
              budget = draw ? dash : gap;
            }
          }
        }
      }
      prev = p;
    }
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _LongThrowPainter oldDelegate) =>
      oldDelegate.travel != travel;
}
