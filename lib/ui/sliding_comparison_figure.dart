import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';
import 'span_marker.dart';

/// 同じ水平面をすべる2つの場合。下の距離は上の4倍で、減速の仕方は同じ。
class SlidingComparisonFigure extends StatefulWidget {
  const SlidingComparisonFigure({super.key});

  @override
  State<SlidingComparisonFigure> createState() => _SlidingComparisonFigureState();
}

class _SlidingComparisonFigureState extends State<SlidingComparisonFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    if (figureClockRuns) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      height: 176,
      width: 274,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final progress = playPauseProgress(_controller.value);
          return CustomPaint(
            painter: _SlidingComparisonPainter(
              progress: progress,
              initialSpeedFast: '${labels.initialSpeed} 5.0 m/s',
              initialSpeedSlow: '${labels.initialSpeed} v₀',
            ),
          );
        },
      ),
    );
  }
}

class _SlidingComparisonPainter extends CustomPainter {
  const _SlidingComparisonPainter({
    required this.progress,
    required this.initialSpeedFast,
    required this.initialSpeedSlow,
  });

  /// 0 で出発、1 で遅い方が停止した直後。速い方はその半分で止まっている。
  final double progress;
  final String initialSpeedFast;
  final String initialSpeedSlow;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-12, 0);
    const ink = Color(0xFF37474F);
    const blockColor = Color(0xFF1565C0);
    const origin = 36.0;
    const shortLength = 56.0;
    const longLength = shortLength * 4;

    _case(
      canvas,
      label: initialSpeedFast,
      distance: 'L',
      groundY: 40,
      origin: origin,
      length: shortLength,
      fraction: _stopped(_fraction(progress / 0.5)),
      ink: ink,
      blockColor: blockColor,
    );
    _case(
      canvas,
      label: initialSpeedSlow,
      distance: '4L',
      groundY: 130,
      origin: origin,
      length: longLength,
      fraction: _stopped(_fraction(progress)),
      ink: ink,
      blockColor: blockColor,
    );
  }

  /// 等加速度で止まるまでの進み方。q は 0 が出発、1 が停止。
  double _fraction(double q) {
    final clamped = q.clamp(0.0, 1.0);
    return 2 * clamped - clamped * clamped;
  }

  double _stopped(double fraction) => fraction.clamp(0.0, 1.0);

  void _case(
    Canvas canvas, {
    required String label,
    required String distance,
    required double groundY,
    required double origin,
    required double length,
    required double fraction,
    required Color ink,
    required Color blockColor,
  }) {
    final ground = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(origin - 16, groundY),
      Offset(origin + length + 18, groundY),
      ground,
    );
    _labelLeft(canvas, label, Offset(origin, groundY - 28), blockColor);
    paintSpanMarker(
      canvas: canvas,
      from: Offset(origin, groundY + 22),
      to: Offset(origin + length, groundY + 22),
      label: distance,
      color: ink,
      tick: const Offset(0, -16),
    );

    const blockWidth = 18.0;
    const blockHeight = 14.0;
    final center = Offset(origin + fraction * length, groundY - blockHeight / 2);
    final rect = Rect.fromCenter(center: center, width: blockWidth, height: blockHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()..color = blockColor,
    );
  }

  void _labelLeft(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(0, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _SlidingComparisonPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.initialSpeedFast != initialSpeedFast ||
      oldDelegate.initialSpeedSlow != initialSpeedSlow;
}
