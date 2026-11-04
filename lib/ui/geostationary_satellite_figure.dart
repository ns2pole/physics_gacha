import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';

/// 地球と静止衛星が、同じ角速度で一周する。北極側から見た図。
class GeostationarySatelliteFigure extends StatefulWidget {
  const GeostationarySatelliteFigure({super.key});

  @override
  State<GeostationarySatelliteFigure> createState() =>
      _GeostationarySatelliteFigureState();
}

class _GeostationarySatelliteFigureState
    extends State<GeostationarySatelliteFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
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
      height: 210,
      width: 230,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          return CustomPaint(
            painter: _GeostationaryPainter(
              earth: labels.earth,
              satellite: labels.satellite,
              phase: _clock.value,
            ),
          );
        },
      ),
    );
  }
}

class _GeostationaryPainter extends CustomPainter {
  const _GeostationaryPainter({
    required this.earth,
    required this.satellite,
    required this.phase,
  });

  final String earth;
  final String satellite;
  final double phase;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = _ink;

    const center = Offset(115, 105);
    const earthR = 20.0;
    const orbitR = 80.0;
    final angle = -math.pi / 2 + phase * 2 * math.pi;
    final ground = _onCircle(center, earthR, angle);
    final craft = _onCircle(center, orbitR, angle);

    _globe(canvas, center, earthR);
    canvas.drawCircle(center, orbitR, line);
    canvas.drawLine(ground, craft, line);
    canvas.drawCircle(craft, 4.2, fill);

    _label(canvas, earth, center + const Offset(0, earthR + 16));
    final outward = (craft - center) / orbitR;
    _label(canvas, satellite, craft + outward * 16);
  }

  void _globe(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(
      center,
      radius,
      Paint()..color = const Color(0xFF7EC4E4),
    );
    final land = Paint()..color = const Color(0xFFB5D07A);
    canvas.drawPath(_blob(center, radius, const [
      Offset(-0.15, -0.88),
      Offset(-0.82, -0.55),
      Offset(-0.78, -0.05),
      Offset(-0.28, 0.08),
      Offset(0.08, -0.22),
      Offset(0.18, -0.62),
    ]), land);
    canvas.drawPath(_blob(center, radius, const [
      Offset(-0.58, 0.18),
      Offset(-0.72, 0.55),
      Offset(-0.28, 0.82),
      Offset(0.02, 0.48),
      Offset(-0.18, 0.18),
    ]), land);
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(radius * 0.22, radius * 0.52),
        width: radius * 0.42,
        height: radius * 0.28,
      ),
      land,
    );
    canvas.drawPath(_blob(center, radius, const [
      Offset(0.42, -0.62),
      Offset(0.82, -0.25),
      Offset(0.68, 0.38),
      Offset(0.38, 0.12),
      Offset(0.32, -0.28),
    ]), land);
    canvas.restore();
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF4E8EAB)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4,
    );
  }

  Path _blob(Offset center, double radius, List<Offset> points) {
    final path = Path()..moveTo(
      center.dx + points.first.dx * radius,
      center.dy + points.first.dy * radius,
    );
    for (var i = 0; i < points.length; i++) {
      final a = points[i];
      final b = points[(i + 1) % points.length];
      final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
      path.quadraticBezierTo(
        center.dx + a.dx * radius,
        center.dy + a.dy * radius,
        center.dx + mid.dx * radius,
        center.dy + mid.dy * radius,
      );
    }
    path.close();
    return path;
  }

  Offset _onCircle(Offset center, double radius, double angle) {
    return Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );
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
  bool shouldRepaint(covariant _GeostationaryPainter oldDelegate) =>
      oldDelegate.earth != earth ||
      oldDelegate.satellite != satellite ||
      oldDelegate.phase != phase;
}
