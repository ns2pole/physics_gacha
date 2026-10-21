import 'package:flutter/material.dart';

import '../utils/figure_labels.dart';

/// シリンダーの前後。体積の高さは目安で、求める量は書かない。
enum GasCylinderProcess { isothermal, isobaric, isochoric, adiabatic }

class GasCylinderFigure extends StatelessWidget {
  const GasCylinderFigure({super.key, required this.process});

  final GasCylinderProcess process;

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    final processName = switch (process) {
      GasCylinderProcess.isothermal => labels.isothermal,
      GasCylinderProcess.isobaric => labels.isobaric,
      GasCylinderProcess.isochoric => labels.isochoric,
      GasCylinderProcess.adiabatic => labels.adiabatic,
    };
    return SizedBox(
      height: 170,
      width: 270,
      child: CustomPaint(
        painter: _GasCylinderPainter(
          process: process,
          before: labels.before,
          after: labels.after,
          processName: processName,
        ),
      ),
    );
  }
}

class _GasCylinderPainter extends CustomPainter {
  const _GasCylinderPainter({
    required this.process,
    required this.before,
    required this.after,
    required this.processName,
  });

  final GasCylinderProcess process;
  final String before;
  final String after;
  final String processName;

  static const _ink = Color(0xFF37474F);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-16, 0);
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final left = switch (process) {
      GasCylinderProcess.isothermal => (
        gasHeight: 40.0,
        pressure: '2.0×10⁵ Pa',
        volume: '4.0×10⁻³ m³',
        temperature: '300 K',
      ),
      GasCylinderProcess.isobaric => (
        gasHeight: 36.0,
        pressure: '1.0×10⁵ Pa',
        volume: '2.0×10⁻³ m³',
        temperature: '300 K',
      ),
      GasCylinderProcess.isochoric => (
        gasHeight: 48.0,
        pressure: '1.5×10⁵ Pa',
        volume: '2.0×10⁻³ m³',
        temperature: '300 K',
      ),
      GasCylinderProcess.adiabatic => (
        gasHeight: 78.0,
        pressure: '1.0×10⁵ Pa',
        volume: '8.0×10⁻³ m³',
        temperature: null,
      ),
    };
    final right = switch (process) {
      GasCylinderProcess.isothermal => (
        gasHeight: 80.0,
        pressure: null,
        volume: '8.0×10⁻³ m³',
        temperature: '300 K',
      ),
      GasCylinderProcess.isobaric => (
        gasHeight: 50.0,
        pressure: '1.0×10⁵ Pa',
        volume: null,
        temperature: '450 K',
      ),
      GasCylinderProcess.isochoric => (
        gasHeight: 48.0,
        pressure: null,
        volume: '2.0×10⁻³ m³',
        temperature: '600 K',
      ),
      GasCylinderProcess.adiabatic => (
        gasHeight: 22.0,
        pressure: null,
        volume: '1.0×10⁻³ m³',
        temperature: null,
      ),
    };

    const leftX = 78.0;
    const rightX = 222.0;
    _cylinder(
      canvas,
      wire,
      cx: leftX,
      gasHeight: left.gasHeight,
      pressure: left.pressure,
      volume: left.volume,
      temperature: left.temperature,
      caption: before,
    );
    _cylinder(
      canvas,
      wire,
      cx: rightX,
      gasHeight: right.gasHeight,
      pressure: right.pressure,
      volume: right.volume,
      temperature: right.temperature,
      caption: after,
    );

    const midY = 86.0;
    canvas.drawLine(const Offset(128, midY), const Offset(166, midY), wire);
    final head = Path()
      ..moveTo(174, midY)
      ..lineTo(164, midY - 5)
      ..lineTo(164, midY + 5)
      ..close();
    canvas.drawPath(head, Paint()..color = _ink);
    _label(canvas, processName, const Offset(150, 66), size: 14, bold: true);
  }

  void _cylinder(
    Canvas canvas,
    Paint wire, {
    required double cx,
    required double gasHeight,
    required String? pressure,
    required String? volume,
    required String? temperature,
    required String caption,
  }) {
    const width = 48.0;
    const baseY = 124.0;
    const wallTop = 28.0;
    const half = width / 2;
    final pistonY = baseY - gasHeight;
    final left = Offset(cx - half, baseY);
    final right = Offset(cx + half, baseY);

    canvas.drawLine(left, right, wire);
    canvas.drawLine(Offset(cx - half, wallTop), left, wire);
    canvas.drawLine(Offset(cx + half, wallTop), right, wire);
    canvas.drawLine(
      Offset(cx - half - 3, pistonY),
      Offset(cx + half + 3, pistonY),
      wire,
    );
    canvas.drawLine(Offset(cx, pistonY), Offset(cx, pistonY - 14), wire);

    if (process == GasCylinderProcess.isobaric ||
        process == GasCylinderProcess.isochoric) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, pistonY - 20),
          width: 18,
          height: 12,
        ),
        wire,
      );
    }
    if (process == GasCylinderProcess.adiabatic) {
      for (var y = wallTop + 8; y < baseY - 6; y += 10) {
        canvas.drawLine(
          Offset(cx - half, y),
          Offset(cx - half - 8, y + 6),
          wire,
        );
        canvas.drawLine(
          Offset(cx + half, y),
          Offset(cx + half + 8, y + 6),
          wire,
        );
      }
    }

    _label(canvas, caption, Offset(cx, 14), size: 13);
    if (temperature != null) {
      _label(canvas, temperature, Offset(cx, pistonY + gasHeight * 0.5));
    }
    var below = baseY + 16;
    if (volume != null) {
      _label(canvas, volume, Offset(cx, below));
      below += 16;
    }
    if (pressure != null) {
      _label(canvas, pressure, Offset(cx, below));
    }
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin, {
    double size = 14,
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: _ink,
          fontSize: size,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w400,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _GasCylinderPainter oldDelegate) =>
      oldDelegate.process != process ||
      oldDelegate.before != before ||
      oldDelegate.after != after ||
      oldDelegate.processName != processName;
}
