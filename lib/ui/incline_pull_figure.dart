import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';

/// 30° のあらい斜面を、斜面に沿った糸で引き上げる図。
/// 一定の速さで上がって止まり、はじめへ戻る。
class InclinePullFigure extends StatefulWidget {
  const InclinePullFigure({super.key});

  @override
  State<InclinePullFigure> createState() => _InclinePullFigureState();
}

class _InclinePullFigureState extends State<InclinePullFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
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
      height: 164,
      width: 220,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _InclinePullPainter(
              smallMass: labels.smallMass,
              string: labels.string,
              travel: playPauseProgress(_clock.value),
            ),
          );
        },
      ),
    );
  }
}

class _InclinePullPainter extends CustomPainter {
  const _InclinePullPainter({
    required this.smallMass,
    required this.string,
    required this.travel,
  });

  final String smallMass;
  final String string;
  final double travel;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-28, 0);
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const origin = Offset(36, 146);
    const angle = -math.pi / 6;
    const slopeLength = 228.0;
    final along = Offset(math.cos(angle), math.sin(angle));
    final outward = Offset(math.sin(angle), -math.cos(angle));

    canvas.drawLine(origin, origin + along * slopeLength, line);
    for (var distance = 52.0; distance < slopeLength - 8; distance += 16) {
      if (distance > 88 && distance < 132) continue;
      final base = origin + along * distance;
      canvas.drawLine(base, base - outward * 8, line);
    }
    _dashed(canvas, origin, origin + const Offset(132, 0), line);
    canvas.drawArc(
      Rect.fromCircle(center: origin, radius: 34),
      0,
      angle,
      false,
      line,
    );
    final mark = origin + Offset(math.cos(angle / 2), math.sin(angle / 2)) * 58;
    _label(canvas, '30°', mark + const Offset(6, -12));

    final blockDistance = 70.0 + 90.0 * travel;
    final block = origin + along * blockDistance;
    canvas.save();
    canvas.translate(block.dx, block.dy);
    canvas.rotate(angle);
    canvas.drawRect(const Rect.fromLTWH(-18, -34, 36, 34), line);
    canvas.drawLine(const Offset(18, -17), const Offset(72, -17), line);
    canvas.restore();

    _label(canvas, smallMass, block + outward * 48);
    _label(canvas, string, block + along * 48 + outward * 34);
  }

  void _dashed(Canvas canvas, Offset from, Offset to, Paint paint) {
    final delta = to - from;
    final length = delta.distance;
    if (length == 0) return;
    final step = delta / length;
    const dash = 5.0;
    const gap = 4.0;
    var drawn = 0.0;
    while (drawn < length) {
      final end = math.min(drawn + dash, length);
      canvas.drawLine(from + step * drawn, from + step * end, paint);
      drawn += dash + gap;
    }
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: _ink, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _InclinePullPainter oldDelegate) =>
      oldDelegate.smallMass != smallMass ||
      oldDelegate.string != string ||
      oldDelegate.travel != travel;
}
