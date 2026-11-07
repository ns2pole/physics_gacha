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
      // 断熱は斜線と太い筒のため横に余裕を取る。
      width: roomy ? 360 : 400,
      height: roomy ? 245 : 213,
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

  bool get _roomy =>
      process == GasCylinderProcess.isothermal ||
      process == GasCylinderProcess.isobaric ||
      process == GasCylinderProcess.isochoric;

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final left = switch (process) {
      GasCylinderProcess.isothermal => (
        gasHeight: 72.0,
        pressure: '1013 hPa',
        volume: '2.0×10⁻³ m³',
        temperature: '293 K',
      ),
      GasCylinderProcess.isobaric => (
        gasHeight: 50.0,
        pressure: '1013 hPa',
        volume: '2.0×10⁻³ m³',
        temperature: '300 K',
      ),
      GasCylinderProcess.isochoric => (
        gasHeight: 80.0,
        pressure: '1013 hPa',
        volume: '2.0×10⁻³ m³',
        temperature: '27°C',
      ),
      GasCylinderProcess.adiabatic => (
        gasHeight: 88.0,
        pressure: null,
        volume: '5.0×10⁻³ m³',
        temperature: '27°C',
      ),
    };
    final right = switch (process) {
      GasCylinderProcess.isothermal => (
        gasHeight: 145.0,
        pressure: null,
        volume: '4.0×10⁻³ m³',
        temperature: '293 K',
      ),
      GasCylinderProcess.isobaric => (
        gasHeight: 60.0,
        pressure: '1013 hPa',
        volume: null,
        temperature: '360 K',
      ),
      GasCylinderProcess.isochoric => (
        gasHeight: 80.0,
        pressure: null,
        volume: '2.0×10⁻³ m³',
        temperature: '−3°C',
      ),
      GasCylinderProcess.adiabatic => (
        gasHeight: 18.0,
        pressure: null,
        volume: '1.0×10⁻³ m³',
        temperature: '???',
      ),
    };

    final midX = size.width / 2;
    // 断熱は筒を太くし、斜線のぶんピストン間も広くする。
    final half = (_roomy ? 102.0 : 108.0) / 2;
    final gap = _roomy ? 52.0 : 76.0;
    final leftX = midX - gap / 2 - half;
    final rightX = midX + gap / 2 + half;
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

    final midY = _roomy ? 115.0 : 108.0;
    // 断熱は斜線があるのでピストンとのすき間を広くし、矢印は短く中央に置く。
    const head = 8.0;
    final double arrowFrom;
    final double arrowTo;
    if (_roomy) {
      const arrowPad = 7.0;
      arrowFrom = leftX + half + arrowPad;
      arrowTo = rightX - half - arrowPad - head;
    } else {
      const shaft = 28.0;
      arrowFrom = midX - shaft / 2;
      arrowTo = midX + shaft / 2 - head;
    }
    canvas.drawLine(Offset(arrowFrom, midY), Offset(arrowTo, midY), wire);
    final tip = Path()
      ..moveTo(arrowTo + head, midY)
      ..lineTo(arrowTo - 1, midY - 5)
      ..lineTo(arrowTo - 1, midY + 5)
      ..close();
    canvas.drawPath(tip, Paint()..color = _ink);
    _label(
      canvas,
      processName,
      Offset(midX, _roomy ? 85 : 82),
      size: 15,
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
    final width = _roomy ? 102.0 : 108.0;
    final baseY = _roomy ? 200.0 : 155.0;
    const wallTop = 35.0;
    final half = width / 2;
    final pistonY = baseY - gasHeight;
    const corner = 10.0;
    final wall = Path()
      ..moveTo(cx - half, wallTop)
      ..lineTo(cx - half, baseY - corner)
      ..quadraticBezierTo(cx - half, baseY, cx - half + corner, baseY)
      ..lineTo(cx + half - corner, baseY)
      ..quadraticBezierTo(cx + half, baseY, cx + half, baseY - corner)
      ..lineTo(cx + half, wallTop);
    canvas.drawPath(wall, wire);
    canvas.drawLine(
      Offset(cx - half - 4, pistonY),
      Offset(cx + half + 4, pistonY),
      wire,
    );
    canvas.drawLine(Offset(cx, pistonY), Offset(cx, pistonY - 18), wire);

    if (process == GasCylinderProcess.isobaric ||
        process == GasCylinderProcess.isochoric) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(cx, pistonY - 25),
          width: 24,
          height: 15,
        ),
        wire,
      );
    }
    if (process == GasCylinderProcess.adiabatic) {
      for (var y = wallTop + 10; y < baseY - 8; y += 12) {
        canvas.drawLine(
          Offset(cx - half, y),
          Offset(cx - half - 10, y + 8),
          wire,
        );
        canvas.drawLine(
          Offset(cx + half, y),
          Offset(cx + half + 10, y + 8),
          wire,
        );
      }
    }

    _label(canvas, caption, Offset(cx, 16), size: 15);
    if (_roomy) {
      if (temperature != null) {
        // 等圧は気柱が浅いので、重り箱の上へ逃がす。
        final y = process == GasCylinderProcess.isobaric
            ? pistonY - 42
            : (gasHeight >= 100 ? pistonY + 22 : pistonY + 11);
        _label(canvas, temperature, Offset(cx, y));
      }
      final radius = gasHeight >= 100 ? 12.0 : 10.0;
      const labelGap = 4.0;
      final labelCenter = baseY - 18;
      paintPressureGauge(
        canvas,
        Offset(cx, labelCenter - radius - labelGap),
        radius: radius,
        reading: pressure ?? '??? hPa',
        fraction: pressure == null ? 0.42 : 0.55,
        // 数値を文字盤の下へ十分離す（大きいフォントで盤と被らないように）。
        labelShift: const Offset(0, 6),
      );
    } else {
      final askPressure =
          pressure == null && process != GasCylinderProcess.adiabatic;
      if (temperature != null) {
        final y = gasHeight < 30 ? pistonY - 30 : pistonY + gasHeight * 0.5;
        _label(canvas, temperature, Offset(cx, y));
      }
      if (pressure != null) {
        _label(
          canvas,
          pressure,
          Offset(cx, baseY + (volume == null ? 20 : 40)),
        );
      } else if (askPressure) {
        final tap = Offset(cx + half, pistonY + gasHeight * 0.42);
        final gauge = Offset(cx + half + 26, tap.dy);
        canvas.drawLine(tap, Offset(gauge.dx - 16, gauge.dy), wire);
        paintPressureGauge(canvas, gauge, radius: 14);
      }
    }
    if (volume != null) {
      _label(canvas, volume, Offset(cx, baseY + (_roomy ? 36 : 24)));
    }
  }

  void _label(
    Canvas canvas,
    String text,
    Offset origin, {
    double size = 15,
    bool bold = false,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(
          color: _ink,
          fontSize: size,
          fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
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
