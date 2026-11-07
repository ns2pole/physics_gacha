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
      width: 340,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _KeplerOrbitsPainter(
              sun: labels.sun,
              oneYear: labels.oneYear,
              phase: _clock.value,
            ),
          );
        },
      ),
    );
  }
}

class _KeplerOrbitsPainter extends CustomPainter {
  const _KeplerOrbitsPainter({
    required this.sun,
    required this.oneYear,
    required this.phase,
  });

  final String sun;
  final String oneYear;
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
    // 左に内側半径の寸法を置くので、中心を少し右へ。
    const center = Offset(168, 112);
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
    canvas.drawLine(
      center + const Offset(sunR, 0),
      center + const Offset(outer, 0),
      radiusLine,
    );

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

    // 内側半径は左サイドの寸法線。外側は右の半径線の下。
    _leftRadiusSpan(
      canvas,
      from: center + const Offset(-inner, 0),
      to: center + const Offset(-sunR, 0),
      label: '1.0×10⁸ km',
    );
    _label(canvas, oneYear, Offset(center.dx + inner + 30, center.dy - 22));
    _label(
      canvas,
      '4.0×10⁸ km',
      Offset(center.dx + (inner + outer) * 0.5, center.dy + 18),
    );
  }

  Offset _onOrbit(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
  }

  /// 左向きの短い半径。数値は線のさらに左へ出して被らないようにする。
  void _leftRadiusSpan(
    Canvas canvas, {
    required Offset from,
    required Offset to,
    required String label,
  }) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final delta = to - from;
    final length = delta.distance;
    if (length < 1) return;
    final along = delta / length;
    final across = Offset(-along.dy, along.dx);
    canvas.drawLine(from, to, paint);
    const head = 6.0;
    const wing = 3.5;
    canvas.drawLine(from, from + along * head + across * wing, paint);
    canvas.drawLine(from, from + along * head - across * wing, paint);
    canvas.drawLine(to, to - along * head + across * wing, paint);
    canvas.drawLine(to, to - along * head - across * wing, paint);

    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: figureLabelStyle(color: _ink, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final left = math.min(from.dx, to.dx);
    painter.paint(
      canvas,
      Offset(left - painter.width - 6, (from.dy + to.dy) / 2 - painter.height / 2),
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
      oldDelegate.sun != sun ||
      oldDelegate.oneYear != oneYear ||
      oldDelegate.phase != phase;
}
