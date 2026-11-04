import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';

/// 地球のまわりを月が円運動する。北極側から見た図。
class MoonOrbitFigure extends StatefulWidget {
  const MoonOrbitFigure({super.key});

  @override
  State<MoonOrbitFigure> createState() => _MoonOrbitFigureState();
}

class _MoonOrbitFigureState extends State<MoonOrbitFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
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
            painter: _MoonOrbitPainter(
              earth: labels.earth,
              moon: labels.moon,
              phase: _clock.value,
            ),
          );
        },
      ),
    );
  }
}

class _MoonOrbitPainter extends CustomPainter {
  const _MoonOrbitPainter({
    required this.earth,
    required this.moon,
    required this.phase,
  });

  final String earth;
  final String moon;
  final double phase;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const center = Offset(115, 108);
    const earthR = 26.0;
    const orbitR = 74.0;
    const moonR = 9.0;
    final angle = -math.pi / 2 + phase * 2 * math.pi;
    final moonCenter = Offset(
      center.dx + orbitR * math.cos(angle),
      center.dy + orbitR * math.sin(angle),
    );
    final outward = (moonCenter - center) / orbitR;

    canvas.drawCircle(center, orbitR, line);
    _globe(canvas, center, earthR);
    canvas.drawLine(center, moonCenter - outward * (moonR + 2), line);
    _crescent(canvas, moonCenter, moonR);

    _label(canvas, earth, center + const Offset(0, earthR + 14));
    _label(canvas, moon, moonCenter + outward * 20);
  }

  void _globe(Canvas canvas, Offset center, double radius) {
    canvas.save();
    canvas.clipPath(
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
    );
    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF7EC4E4));
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

  void _crescent(Canvas canvas, Offset center, double radius) {
    final disk = Path()..addOval(Rect.fromCircle(center: center, radius: radius));
    final cut = Path()
      ..addOval(
        Rect.fromCircle(center: center + Offset(radius * 0.42, -radius * 0.08), radius: radius * 0.86),
      );
    canvas.drawPath(
      Path.combine(PathOperation.difference, disk, cut),
      Paint()..color = const Color(0xFFF2D056),
    );
  }

  void _label(Canvas canvas, String text, Offset center) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: figureLabelStyle(color: _ink)),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _MoonOrbitPainter oldDelegate) =>
      oldDelegate.earth != earth ||
      oldDelegate.moon != moon ||
      oldDelegate.phase != phase;
}
