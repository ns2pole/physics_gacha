import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import 'span_marker.dart';

/// 自然長から床へ押しつけ、手をはなしたあとおもりがばねを離れて上がる。
class CompressedSpringFigure extends StatefulWidget {
  const CompressedSpringFigure({super.key});

  @override
  State<CompressedSpringFigure> createState() => _CompressedSpringFigureState();
}

class _CompressedSpringFigureState extends State<CompressedSpringFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3400),
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
      height: 220 - _CompressedSpringPainter.topCrop - 6,
      width: 248,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _CompressedSpringPainter(
              motion: playPauseProgress(_clock.value),
            ),
          );
        },
      ),
    );
  }
}

class _CompressedSpringPainter extends CustomPainter {
  const _CompressedSpringPainter({required this.motion});

  /// 0→1 が動き。自然長、押しつけ、手をはなす、最高点。
  final double motion;

  static const _ink = Color(0xFF37474F);
  static const _center = 140.0;
  static const _floor = 198.0;

  /// 最高点より上の、描かない余白。
  static const topCrop = 48.0;
  static const _massH = 34.0;
  static const _massW = 44.0;
  static const _naturalTop = 102.0;
  static const _compressedTop = 130.0;
  static const _peakTop = 60.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(-16, -topCrop);
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(88, _floor), const Offset(192, _floor), line);
    for (var x = 96.0; x <= 184; x += 16) {
      canvas.drawLine(Offset(x, _floor), Offset(x - 8, _floor + 8), line);
    }

    final massTop = _massTop(motion);
    final naturalBottom = _naturalTop + _massH;
    final contacting = massTop + _massH >= naturalBottom - 0.5;
    final springTop = contacting ? massTop + _massH : naturalBottom;

    _spring(canvas, line, springTop);
    canvas.drawRect(
      Rect.fromLTWH(_center - _massW / 2, massTop, _massW, _massH),
      line,
    );

    paintSpanMarker(
      canvas: canvas,
      from: Offset(40, naturalBottom),
      to: const Offset(40, _compressedTop + _massH),
      label: '0.20 m',
      color: _ink,
      tick: const Offset(16, 0),
    );
    paintSpanMarker(
      canvas: canvas,
      from: const Offset(240, _peakTop + _massH),
      to: const Offset(240, _compressedTop + _massH),
      label: '0.50 m',
      color: _ink,
      tick: const Offset(-16, 0),
    );
    canvas.restore();
  }

  double _massTop(double m) {
    if (m < 0.16) return _naturalTop;
    if (m < 0.40) {
      final u = (m - 0.16) / 0.24;
      return _naturalTop + (_compressedTop - _naturalTop) * u * u;
    }
    if (m < 0.50) return _compressedTop;
    final u = ((m - 0.50) / 0.50).clamp(0.0, 1.0);
    final rise = 2 * u - u * u;
    return _compressedTop + (_peakTop - _compressedTop) * rise;
  }

  void _spring(Canvas canvas, Paint line, double top) {
    final height = (_floor - top).clamp(16.0, 90.0);
    const turns = 6;
    final step = height / turns;
    final spring = Path()..moveTo(_center, top);
    const left = 128.0;
    const right = 152.0;
    for (var i = 0; i < turns; i++) {
      final y = top + i * step;
      final next = y + step;
      if (i.isEven) {
        spring.lineTo(right, (y + next) / 2);
        spring.lineTo(_center, next);
      } else {
        spring.lineTo(left, (y + next) / 2);
        spring.lineTo(_center, next);
      }
    }
    canvas.drawPath(spring, line);
  }

  @override
  bool shouldRepaint(covariant _CompressedSpringPainter oldDelegate) =>
      oldDelegate.motion != motion;
}
