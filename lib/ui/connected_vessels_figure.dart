import 'package:flutter/material.dart';

/// コックで仕切った二つの容器。既定は圧力を聞く単原子の問題。
class ConnectedVesselsFigure extends StatelessWidget {
  const ConnectedVesselsFigure({
    super.key,
    this.leftInside = '2.0×10⁵ Pa',
    this.leftBelow = '3.0×10⁻³ m³',
    this.rightInside = '1.0×10⁵ Pa',
    this.rightBelow = '2.0×10⁻³ m³',
  });

  final String leftInside;
  final String leftBelow;
  final String rightInside;
  final String rightBelow;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 146,
      width: 272,
      child: CustomPaint(
        painter: _ConnectedVesselsPainter(
          leftInside: leftInside,
          leftBelow: leftBelow,
          rightInside: rightInside,
          rightBelow: rightBelow,
        ),
      ),
    );
  }
}

class _ConnectedVesselsPainter extends CustomPainter {
  const _ConnectedVesselsPainter({
    required this.leftInside,
    required this.leftBelow,
    required this.rightInside,
    required this.rightBelow,
  });

  final String leftInside;
  final String leftBelow;
  final String rightInside;
  final String rightBelow;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-18, -18);
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = Offset(86, 78);
    const right = Offset(214, 78);
    const radius = 52.0;

    canvas.drawCircle(left, radius, wire);
    canvas.drawCircle(right, radius, wire);

    const tubeTop = 72.0;
    const tubeBottom = 84.0;
    canvas.drawLine(
      Offset(left.dx + radius, tubeTop),
      Offset(right.dx - radius, tubeTop),
      wire,
    );
    canvas.drawLine(
      Offset(left.dx + radius, tubeBottom),
      Offset(right.dx - radius, tubeBottom),
      wire,
    );

    const cock = Offset(150, 78);
    canvas.drawRect(Rect.fromCenter(center: cock, width: 16, height: 22), wire);
    canvas.drawLine(const Offset(150, 67), const Offset(150, 52), wire);
    canvas.drawLine(const Offset(142, 52), const Offset(158, 52), wire);

    _label(canvas, 'A', Offset(left.dx, left.dy - 28));
    _label(canvas, 'B', Offset(right.dx, right.dy - 28));
    _label(canvas, leftInside, left + const Offset(0, 6));
    _label(canvas, rightInside, right + const Offset(0, 6));
    _label(canvas, leftBelow, Offset(left.dx, left.dy + radius + 16));
    _label(canvas, rightBelow, Offset(right.dx, right.dy + radius + 16));
  }

  void _label(Canvas canvas, String text, Offset origin) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: _ink, fontSize: 15),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _ConnectedVesselsPainter oldDelegate) =>
      oldDelegate.leftInside != leftInside ||
      oldDelegate.leftBelow != leftBelow ||
      oldDelegate.rightInside != rightInside ||
      oldDelegate.rightBelow != rightBelow;
}
