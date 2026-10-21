import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_labels.dart';

/// 短い水平ばねの両端から紐が出て、滑車の外側を通っておもりをつるす。
class SpringPulleysFigure extends StatelessWidget {
  const SpringPulleysFigure({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      height: 152,
      width: 264,
      child: CustomPaint(painter: _SpringPulleysPainter(spring: labels.spring)),
    );
  }
}

class _SpringPulleysPainter extends CustomPainter {
  const _SpringPulleysPainter({required this.spring});

  final String spring;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-8, 0);
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const leftPulley = Offset(52, 58);
    const rightPulley = Offset(228, 58);
    const radius = 14.0;
    const springY = 44.0;
    const springLeft = 112.0;
    const springRight = 168.0;
    const massTop = 108.0;
    const massWidth = 44.0;
    const massHeight = 36.0;

    _spring(canvas, springLeft, springRight, springY);
    _label(canvas, spring, const Offset(140, 18), _ink);

    canvas.drawCircle(leftPulley, radius, line);
    canvas.drawCircle(rightPulley, radius, line);
    canvas.drawCircle(leftPulley, 2.2, Paint()..color = _ink);
    canvas.drawCircle(rightPulley, 2.2, Paint()..color = _ink);

    final leftTop = Offset(leftPulley.dx, leftPulley.dy - radius);
    final leftOuter = Offset(leftPulley.dx - radius, leftPulley.dy);
    final rightTop = Offset(rightPulley.dx, rightPulley.dy - radius);
    final rightOuter = Offset(rightPulley.dx + radius, rightPulley.dy);

    canvas.drawLine(const Offset(springLeft, springY), leftTop, line);
    canvas.drawArc(
      Rect.fromCircle(center: leftPulley, radius: radius),
      -math.pi / 2,
      -math.pi / 2,
      false,
      line,
    );
    canvas.drawLine(const Offset(springRight, springY), rightTop, line);
    canvas.drawArc(
      Rect.fromCircle(center: rightPulley, radius: radius),
      -math.pi / 2,
      math.pi / 2,
      false,
      line,
    );

    final leftMass = Rect.fromLTWH(
      leftOuter.dx - massWidth / 2,
      massTop,
      massWidth,
      massHeight,
    );
    final rightMass = Rect.fromLTWH(
      rightOuter.dx - massWidth / 2,
      massTop,
      massWidth,
      massHeight,
    );
    canvas.drawLine(leftOuter, Offset(leftMass.center.dx, leftMass.top), line);
    canvas.drawLine(
      rightOuter,
      Offset(rightMass.center.dx, rightMass.top),
      line,
    );
    canvas.drawRect(leftMass, line);
    canvas.drawRect(rightMass, line);
    _label(canvas, '4.0 kg', leftMass.center, _ink, weight: FontWeight.w500);
    _label(canvas, '4.0 kg', rightMass.center, _ink, weight: FontWeight.w500);
  }

  void _spring(Canvas canvas, double left, double right, double y) {
    final path = Path();
    const turns = 6;
    const amplitude = 8.0;
    const steps = 48;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = left + (right - left) * t;
      final wave = math.sin(t * turns * 2 * math.pi);
      final point = Offset(x, y + amplitude * wave);
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _ink
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke,
    );
  }

  void _label(
    Canvas canvas,
    String text,
    Offset center,
    Color color, {
    FontWeight weight = FontWeight.w600,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: weight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _SpringPulleysPainter oldDelegate) =>
      oldDelegate.spring != spring;
}
