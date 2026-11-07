import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import 'span_marker.dart';

/// 高さ [heightLabel] から静かに放した物体が、地面まで落ちて少し止まる。
class FreeFallFigure extends StatefulWidget {
  const FreeFallFigure({super.key, required this.heightLabel});

  final String heightLabel;

  @override
  State<FreeFallFigure> createState() => _FreeFallFigureState();
}

class _FreeFallFigureState extends State<FreeFallFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
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
    return SizedBox(
      height: 168,
      width: 196,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _FreeFallPainter(
              heightLabel: widget.heightLabel,
              travel: playPauseProgress(_clock.value),
            ),
          );
        },
      ),
    );
  }
}

class _FreeFallPainter extends CustomPainter {
  const _FreeFallPainter({required this.heightLabel, required this.travel});

  final String heightLabel;
  final double travel;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const groundY = 146.0;
    const startTop = 16.0;
    const objectSize = 18.0;
    const objectX = 48.0;
    final drop = groundY - objectSize - startTop;
    final top = startTop + drop * travel;

    canvas.drawLine(
      const Offset(24, groundY),
      const Offset(118, groundY),
      line,
    );
    for (var x = 30.0; x < 114; x += 12) {
      canvas.drawLine(Offset(x, groundY), Offset(x - 6, groundY + 8), line);
    }

    const bracketX = 96.0;
    final startBottom = startTop + objectSize;
    paintSpanMarker(
      canvas: canvas,
      from: Offset(bracketX, startBottom),
      to: const Offset(bracketX, groundY),
      label: heightLabel,
      color: _ink,
      tick: const Offset(16, 0),
      guide: 22,
    );

    canvas.drawRect(Rect.fromLTWH(objectX, top, objectSize, objectSize), line);
  }

  @override
  bool shouldRepaint(covariant _FreeFallPainter oldDelegate) =>
      oldDelegate.heightLabel != heightLabel || oldDelegate.travel != travel;
}
