import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ブリッジ形の回路。四つの抵抗と電池電圧を図に出す。
/// 中央の対角線はつながない。電流の値は書かない。
class BridgeVoltageDropFigure extends StatelessWidget {
  const BridgeVoltageDropFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 216,
      width: 220,
      child: CustomPaint(painter: _BridgeVoltageDropPainter()),
    );
  }
}

class _BridgeVoltageDropPainter extends CustomPainter {
  const _BridgeVoltageDropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(-40, -28);
    const ink = Color(0xFF37474F);
    final wire = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    const left = Offset(48, 104);
    const top = Offset(150, 36);
    const right = Offset(252, 104);
    const bottom = Offset(150, 164);
    const rail = 208.0;

    _branch(canvas, left, top, wire);
    _branch(canvas, top, right, wire);
    _branch(canvas, left, bottom, wire);
    _branch(canvas, bottom, right, wire);
    canvas.drawLine(left, const Offset(48, rail), wire);
    canvas.drawLine(right, const Offset(252, rail), wire);

    const center = 150.0;
    const gap = 5.0;
    canvas.drawLine(
      const Offset(48, rail),
      const Offset(center - gap, rail),
      wire,
    );
    canvas.drawLine(
      const Offset(center + gap, rail),
      const Offset(252, rail),
      wire,
    );
    canvas.drawLine(
      const Offset(center - gap, rail - 14),
      const Offset(center - gap, rail + 14),
      wire,
    );
    canvas.drawLine(
      const Offset(center + gap, rail - 7),
      const Offset(center + gap, rail + 7),
      Paint()
        ..color = ink
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );

    for (final node in [left, top, right, bottom]) {
      canvas.drawCircle(node, 3.2, Paint()..color = ink);
    }

    _resistorLabel(canvas, left, top, '4.0 Ω', ink);
    _resistorLabel(canvas, top, right, '6.0 Ω', ink);
    _resistorLabel(canvas, left, bottom, '8.0 Ω', ink);
    _resistorLabel(canvas, bottom, right, '12.0 Ω', ink);
    _label(canvas, '6.0 V', const Offset(150, 230), ink);
  }

  /// 抵抗の箱のすぐ外、ひし形の外側に値を置く。
  void _resistorLabel(
    Canvas canvas,
    Offset a,
    Offset b,
    String text,
    Color ink,
  ) {
    final delta = b - a;
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final along = delta / delta.distance;
    final perp = Offset(-along.dy, along.dx);
    const hub = Offset(150, 104);
    final outward = (mid - hub).dx * perp.dx + (mid - hub).dy * perp.dy >= 0
        ? perp
        : Offset(-perp.dx, -perp.dy);
    _label(canvas, text, mid + outward * 20, ink);
  }

  void _branch(Canvas canvas, Offset a, Offset b, Paint wire) {
    final delta = b - a;
    final length = delta.distance;
    final along = delta / length;
    const resistorLength = 34.0;
    final mid = Offset((a.dx + b.dx) / 2, (a.dy + b.dy) / 2);
    final start = mid - along * (resistorLength / 2);
    final end = mid + along * (resistorLength / 2);
    canvas.drawLine(a, start, wire);
    canvas.drawLine(end, b, wire);
    canvas.save();
    canvas.translate(mid.dx, mid.dy);
    canvas.rotate(math.atan2(delta.dy, delta.dx));
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: resistorLength, height: 16),
      wire,
    );
    canvas.restore();
  }

  void _label(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      origin - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant _BridgeVoltageDropPainter oldDelegate) => false;
}
