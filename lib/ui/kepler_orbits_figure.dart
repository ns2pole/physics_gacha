import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';

/// 太陽のまわりの二つの円軌道。半径の比はラベルどおり 1:4。
/// 内側は 4 秒、外側は 32 秒で一周する。内側の一周ごとに戻さず、
/// 両方が同時に元へ戻る 192 秒（約 3 分）でループする。
class KeplerOrbitsFigure extends StatefulWidget {
  const KeplerOrbitsFigure({super.key});

  @override
  State<KeplerOrbitsFigure> createState() => _KeplerOrbitsFigureState();
}

class _KeplerOrbitsFigureState extends State<KeplerOrbitsFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 192),
    );
    if (figureClockRuns) {
      _clock.repeat();
    } else {
      _clock.value = 0.0025;
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
      height: 240,
      width: 300,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _KeplerOrbitsPainter(sun: labels.sun, phase: _clock.value),
          );
        },
      ),
    );
  }
}

class _KeplerOrbitsPainter extends CustomPainter {
  const _KeplerOrbitsPainter({required this.sun, required this.phase});

  final String sun;
  final double phase;

  static const _ink = Color(0xFF37474F);
  static const _sun = Color(0xFFFF9800);

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final sunFill = Paint()..color = _sun;
    final radiusLine = Paint()
      ..color = _ink.withValues(alpha: 0.45)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    // キャンバス中央寄り。外側軌道の左右余白が揃う位置。
    const center = Offset(150, 112);
    const sunR = 4.0;
    const inner = 24.0;
    const outer = 96.0;
    // phase が 0 から 1 までで内側は 48 周、外側は 6 周。どちらも整数周なので継ぎ目で飛ばない。
    // 周期比 8 は、半径比 4 のケプラー第3法則 T² ∝ a³ に合う。
    const innerTurns = 48.0;
    const outerTurns = 6.0;
    final innerAngle = -math.pi / 2 + 2 * math.pi * phase * innerTurns;
    final outerAngle = -math.pi / 2 + 2 * math.pi * phase * outerTurns;

    canvas.drawCircle(center, outer, wire);
    canvas.drawCircle(center, inner, wire);
    canvas.drawLine(center + const Offset(sunR, 0), center + const Offset(outer, 0), radiusLine);

    canvas.drawCircle(center, sunR, sunFill);
    _label(canvas, sun, center + const Offset(0, 14), color: _sun);

    canvas.drawCircle(
      _onOrbit(center, inner, innerAngle),
      4,
      Paint()..color = _ink,
    );
    canvas.drawCircle(
      _onOrbit(center, outer, outerAngle),
      4,
      Paint()..color = _ink,
    );

    // 半径線の上側に内側、下側に外側の距離。周期は内側軌道のすぐ右外。
    _label(
      canvas,
      '1.0×10⁸ km',
      Offset(center.dx + inner * 0.55, center.dy - 12),
    );
    _label(canvas, '1 年', Offset(center.dx + inner + 22, center.dy - 12));
    _label(
      canvas,
      '4.0×10⁸ km',
      Offset(center.dx + (inner + outer) * 0.5, center.dy + 12),
    );
  }

  Offset _onOrbit(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin, {
    Color color = _ink,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: color),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _KeplerOrbitsPainter oldDelegate) =>
      oldDelegate.sun != sun || oldDelegate.phase != phase;
}
