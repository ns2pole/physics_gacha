import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

import '../utils/figure_labels.dart';
import 'dial_meter.dart';

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
    final roomy =
        process == GasCylinderProcess.isothermal ||
        process == GasCylinderProcess.isobaric ||
        process == GasCylinderProcess.isochoric;
    return SizedBox(
      height: roomy ? 196 : 170,
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
  bool get _roomy =>
      process == GasCylinderProcess.isothermal ||
      process == GasCylinderProcess.isobaric ||
      process == GasCylinderProcess.isochoric;

  void paint(Canvas canvas, Size size) {
    if (!_roomy) canvas.translate(-16, 0);
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final left = switch (process) {
      GasCylinderProcess.isothermal => (
        gasHeight: 58.0,
        pressure: '1013 hPa',
        volume: '2.0×10⁻³ m³',
        temperature: '293 K',
      ),
      GasCylinderProcess.isobaric => (
        gasHeight: 40.0,
        pressure: '1013 hPa',
        volume: '2.0×10⁻³ m³',
        temperature: '300 K',
      ),
      GasCylinderProcess.isochoric => (
        gasHeight: 64.0,
        pressure: '1013 hPa',
        volume: '2.0×10⁻³ m³',
        temperature: '27°C',
      ),
      GasCylinderProcess.adiabatic => (
        gasHeight: 70.0,
        pressure: null,
        volume: '5.0×10⁻³ m³',
        temperature: '27°C',
      ),
    };
    final right = switch (process) {
      GasCylinderProcess.isothermal => (
        gasHeight: 116.0,
        pressure: null,
        volume: '4.0×10⁻³ m³',
        temperature: '293 K',
      ),
      GasCylinderProcess.isobaric => (
        gasHeight: 48.0,
        pressure: '1013 hPa',
        volume: null,
        temperature: '360 K',
      ),
      GasCylinderProcess.isochoric => (
        gasHeight: 64.0,
        pressure: null,
        volume: '2.0×10⁻³ m³',
        temperature: '−3°C',
      ),
      GasCylinderProcess.adiabatic => (
        gasHeight: 14.0,
        pressure: null,
        volume: '1.0×10⁻³ m³',
        temperature: '???',
      ),
    };

    final leftX = _roomy ? 62.0 : 78.0;
    final rightX = _roomy ? 214.0 : 222.0;
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

    final midY = _roomy ? 92.0 : 86.0;
    final arrowFrom = _roomy ? 112.0 : 128.0;
    final arrowTo = _roomy ? 158.0 : 166.0;
    canvas.drawLine(Offset(arrowFrom, midY), Offset(arrowTo, midY), wire);
    final head = Path()
      ..moveTo(arrowTo + 8, midY)
      ..lineTo(arrowTo - 2, midY - 5)
      ..lineTo(arrowTo - 2, midY + 5)
      ..close();
    canvas.drawPath(head, Paint()..color = _ink);
    _label(
      canvas,
      processName,
      Offset((leftX + rightX) / 2, _roomy ? 68 : 66),
      size: 14,
      bold: true,
    );
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
    final width = _roomy ? 68.0 : 48.0;
    final baseY = _roomy ? 160.0 : 124.0;
    const wallTop = 28.0;
    final half = width / 2;
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
    if (_roomy) {
      if (temperature != null) {
        final y = gasHeight >= 80 ? pistonY + 18 : pistonY + 9;
        _label(canvas, temperature, Offset(cx, y));
      }
      final radius = gasHeight >= 80 ? 10.0 : 8.0;
      const labelGap = 3.0;
      final labelCenter = baseY - 14;
      paintPressureGauge(
        canvas,
        Offset(cx, labelCenter - radius - labelGap),
        radius: radius,
        reading: pressure ?? '??? hPa',
        fraction: pressure == null ? 0.42 : 0.55,
        labelShift: const Offset(0, labelGap - 10),
      );
    } else {
      final askPressure =
          pressure == null && process != GasCylinderProcess.adiabatic;
      if (temperature != null) {
        final y = gasHeight < 24 ? pistonY - 24 : pistonY + gasHeight * 0.5;
        _label(canvas, temperature, Offset(cx, y));
      }
      if (pressure != null) {
        _label(
          canvas,
          pressure,
          Offset(cx, baseY + (volume == null ? 16 : 32)),
        );
      } else if (askPressure) {
        final tap = Offset(cx + half, pistonY + gasHeight * 0.42);
        final gauge = Offset(cx + half + 20, tap.dy);
        canvas.drawLine(tap, Offset(gauge.dx - 13, gauge.dy), wire);
        paintPressureGauge(canvas, gauge, radius: 12);
      }
    }
    if (volume != null) {
      _label(canvas, volume, Offset(cx, baseY + 16));
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
        style: figureLabelStyle(
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
