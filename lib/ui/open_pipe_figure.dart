import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_labels.dart';

/// 両端が開いた管と、腹が 3 個の定在波。腹だけが上下する。
class OpenPipeFigure extends StatefulWidget {
  const OpenPipeFigure({super.key});

  @override
  State<OpenPipeFigure> createState() => _OpenPipeFigureState();
}

class _OpenPipeFigureState extends State<OpenPipeFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    final binding = WidgetsBinding.instance.runtimeType.toString();
    if (!binding.contains('TestWidgetsFlutterBinding')) {
      _controller.repeat();
    }
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
      height: 152,
      width: 230,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _OpenPipePainter(
              phase: _controller.value * 2 * math.pi,
              antinode: labels.antinode,
              openPipe: labels.openPipe,
            ),
          );
        },
      ),
    );
  }
}

class _OpenPipePainter extends CustomPainter {
  const _OpenPipePainter({
    required this.phase,
    required this.antinode,
    required this.openPipe,
  });

  final double phase;
  final String antinode;
  final String openPipe;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-25, -4);
    const ink = Color(0xFF37474F);
    const waveColor = Color(0xFF1565C0);
    final wall = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = 40.0;
    const right = 240.0;
    const top = 48.0;
    const bottom = 104.0;
    const center = (top + bottom) / 2;
    const amplitude = 20.0;
    final swing = math.cos(phase);

    _lengthMarker(canvas, 16, left, right, ink);
    canvas.drawLine(const Offset(left, top), const Offset(right, top), wall);
    canvas.drawLine(const Offset(left, bottom), const Offset(right, bottom), wall);

    final wave = Path();
    const steps = 48;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps;
      final x = left + (right - left) * t;
      final y = center - amplitude * math.cos(2 * math.pi * t) * swing;
      if (i == 0) {
        wave.moveTo(x, y);
      } else {
        wave.lineTo(x, y);
      }
    }
    canvas.drawPath(
      wave,
      Paint()
        ..color = waveColor
        ..strokeWidth = 1.8
        ..style = PaintingStyle.stroke,
    );

    _label(canvas, antinode, const Offset(left, top - 14), waveColor);
    _label(canvas, antinode, Offset((left + right) / 2, bottom + 14), waveColor);
    _label(canvas, antinode, const Offset(right, top - 14), waveColor);
    _label(
      canvas,
      openPipe,
      Offset((left + right) / 2, bottom + 40),
      ink,
      weight: FontWeight.w500,
    );
  }

  void _lengthMarker(Canvas canvas, double y, double left, double right, Color color) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final mid = (left + right) / 2;
    canvas.drawLine(Offset(left, y), Offset(mid - 28, y), paint);
    canvas.drawLine(Offset(mid + 28, y), Offset(right, y), paint);
    _arrowHead(canvas, Offset(left, y), paint, outward: true);
    _arrowHead(canvas, Offset(right, y), paint, outward: false);
    _label(canvas, '90 cm', Offset(mid, y), color, weight: FontWeight.w500);
  }

  void _arrowHead(Canvas canvas, Offset tip, Paint paint, {required bool outward}) {
    final wing = outward ? 7.0 : -7.0;
    canvas.drawLine(tip, Offset(tip.dx + wing, tip.dy - 4), paint);
    canvas.drawLine(tip, Offset(tip.dx + wing, tip.dy + 4), paint);
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin,
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
    painter.paint(canvas, origin - Offset(painter.width / 2, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _OpenPipePainter oldDelegate) =>
      oldDelegate.phase != phase ||
      oldDelegate.antinode != antinode ||
      oldDelegate.openPipe != openPipe;
}
