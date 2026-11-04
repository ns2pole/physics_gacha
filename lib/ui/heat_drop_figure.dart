import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';
import 'span_marker.dart';

/// 高さ 2.0 m から、断熱容器の水へ 0.50 kg の物体が落ちる。
class HeatDropFigure extends StatefulWidget {
  const HeatDropFigure({super.key});

  @override
  State<HeatDropFigure> createState() => _HeatDropFigureState();
}

class _HeatDropFigureState extends State<HeatDropFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
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
      height: 190,
      width: 240,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _HeatDropPainter(
              water: labels.water,
              insulated: labels.insulated,
              travel: playPauseProgress(_clock.value),
            ),
          );
        },
      ),
    );
  }
}

class _HeatDropPainter extends CustomPainter {
  const _HeatDropPainter({
    required this.water,
    required this.insulated,
    required this.travel,
  });

  final String water;
  final String insulated;
  final double travel;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const objectSize = 16.0;
    const startTop = 14.0;
    const objectX = 78.0;
    const waterY = 124.0;
    final endTop = waterY - objectSize;
    final top = startTop + (endTop - startTop) * travel;

    const outer = Rect.fromLTWH(52, 110, 92, 58);
    final inner = outer.deflate(5);
    canvas.drawRect(outer, line);
    canvas.drawRect(inner, line);
    canvas.drawLine(
      Offset(inner.left, waterY),
      Offset(inner.right, waterY),
      line,
    );
    for (var y = waterY + 9; y < inner.bottom - 3; y += 8) {
      canvas.drawLine(
        Offset(inner.left + 4, y),
        Offset(inner.right - 4, y),
        line,
      );
    }
    _label(canvas, water, Offset(inner.center.dx, waterY + 16));
    _label(canvas, insulated, Offset(outer.center.dx, outer.bottom + 12));

    const bracketX = 164.0;
    final startBottom = startTop + objectSize;
    paintSpanMarker(
      canvas: canvas,
      from: Offset(bracketX, startBottom),
      to: const Offset(bracketX, waterY),
      label: '2.0 m',
      color: _ink,
      tick: const Offset(16, 0),
    );
    _label(canvas, '0.50 kg', const Offset(32, startTop + objectSize / 2));

    canvas.drawRect(Rect.fromLTWH(objectX, top, objectSize, objectSize), line);
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _HeatDropPainter oldDelegate) =>
      oldDelegate.water != water ||
      oldDelegate.insulated != insulated ||
      oldDelegate.travel != travel;
}
