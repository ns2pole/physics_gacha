import 'package:flutter/material.dart';

/// 床に立てたばねの上におもりを載せ、ばねを縮めた図。
class CompressedSpringFigure extends StatelessWidget {
  const CompressedSpringFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 168,
      width: 160,
      child: CustomPaint(painter: _CompressedSpringPainter()),
    );
  }
}

class _CompressedSpringPainter extends CustomPainter {
  const _CompressedSpringPainter();

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    const center = 80.0;
    const floor = 148.0;
    canvas.drawLine(const Offset(28, floor), const Offset(132, floor), line);
    canvas.drawLine(const Offset(36, floor), const Offset(28, floor + 8), line);
    canvas.drawLine(const Offset(52, floor), const Offset(44, floor + 8), line);
    canvas.drawLine(const Offset(68, floor), const Offset(60, floor + 8), line);
    canvas.drawLine(const Offset(84, floor), const Offset(76, floor + 8), line);
    canvas.drawLine(const Offset(100, floor), const Offset(92, floor + 8), line);
    canvas.drawLine(const Offset(116, floor), const Offset(108, floor + 8), line);

    final spring = Path()..moveTo(center, 92);
    const turns = 6;
    const left = 68.0;
    const right = 92.0;
    for (var i = 0; i < turns; i++) {
      final y = 92.0 + i * 8;
      final next = y + 8;
      if (i.isEven) {
        spring.lineTo(right, (y + next) / 2);
        spring.lineTo(center, next);
      } else {
        spring.lineTo(left, (y + next) / 2);
        spring.lineTo(center, next);
      }
    }
    canvas.drawPath(spring, line);

    final mass = Rect.fromLTWH(center - 22, 36, 44, 44);
    canvas.drawRect(mass, line);
    canvas.drawLine(Offset(center, mass.bottom), const Offset(center, 92), line);
  }

  @override
  bool shouldRepaint(covariant _CompressedSpringPainter oldDelegate) => false;
}
