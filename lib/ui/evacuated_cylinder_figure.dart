import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';
import '../utils/figure_labels.dart';
import 'dial_meter.dart';
import 'span_marker.dart';

/// 秤に載せた円柱容器。27℃で空気を 1.0×10⁵ Pa からほぼ真空まで抜く。
class EvacuatedCylinderFigure extends StatelessWidget {
  const EvacuatedCylinderFigure({super.key});

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      height: 208,
      width: 368,
      child: CustomPaint(
        painter: _EvacuatedCylinderPainter(
          before: labels.before,
          after: labels.after,
          heightLabel: labels.cylinderHeight,
          radiusLabel: labels.cylinderRadius,
        ),
      ),
    );
  }
}

class _EvacuatedCylinderPainter extends CustomPainter {
  const _EvacuatedCylinderPainter({
    required this.before,
    required this.after,
    required this.heightLabel,
    required this.radiusLabel,
  });

  final String before;
  final String after;
  final String heightLabel;
  final String radiusLabel;

  static const _ink = Color(0xFF37474F);
  static const _guide = Color(0xFF90A4AE);

  @override
  void paint(Canvas canvas, Size size) {
    final wire = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    const top = 56.0;
    const bottom = 128.0;
    const half = 34.0;
    const rim = 7.0;
    const leftX = 180.0;
    const rightX = 308.0;

    _vessel(
      canvas,
      wire,
      cx: leftX,
      top: top,
      bottom: bottom,
      half: half,
      rim: rim,
      caption: before,
      pressure: '1.0×10⁵ Pa',
    );
    _vessel(
      canvas,
      wire,
      cx: rightX,
      top: top,
      bottom: bottom,
      half: half,
      rim: rim,
      caption: after,
      pressure: '≈0',
    );
    _flowArrow(
      canvas,
      Offset(leftX + half + 8, (top + bottom) / 2),
      Offset(rightX - half - 8, (top + bottom) / 2),
    );
    _label(canvas, '27°C', Offset((leftX + rightX) / 2, 18), size: 11);

    final spanX = leftX - half - 16;
    canvas.drawLine(Offset(spanX, top), Offset(leftX - half, top), wire..color = _guide);
    canvas.drawLine(
      Offset(spanX, bottom),
      Offset(leftX - half, bottom),
      wire..color = _guide,
    );
    wire.color = _ink;
    paintSpanMarker(
      canvas: canvas,
      from: Offset(spanX, top),
      to: Offset(spanX, bottom),
      label: heightLabel,
      color: _ink,
      tick: const Offset(-8, 0),
    );

    final radiusY = bottom - 34;
    canvas.drawLine(
      Offset(leftX, radiusY - 7),
      Offset(leftX, radiusY + 7),
      wire..color = _guide,
    );
    wire.color = _ink;
    _doubleArrow(canvas, Offset(leftX, radiusY), Offset(leftX + half, radiusY), wire);
    _label(canvas, radiusLabel, Offset(leftX + 4, radiusY + 16), size: 11);
  }

  void _vessel(
    Canvas canvas,
    Paint wire, {
    required double cx,
    required double top,
    required double bottom,
    required double half,
    required double rim,
    required String caption,
    required String pressure,
  }) {
    final left = cx - half;
    final right = cx + half;
    canvas.drawLine(Offset(left, top), Offset(left, bottom), wire);
    canvas.drawLine(Offset(right, top), Offset(right, bottom), wire);
    canvas.drawOval(
      Rect.fromCenter(center: Offset(cx, top), width: half * 2, height: rim * 2),
      wire,
    );
    canvas.drawArc(
      Rect.fromCenter(center: Offset(cx, bottom), width: half * 2, height: rim * 2),
      0,
      math.pi,
      false,
      wire,
    );

    paintPlatformScale(
      canvas,
      Offset(cx, bottom + rim + 6),
      color: _ink,
      panHalf: half + 8,
      bodyHeight: 36,
      fraction: pressure.startsWith('7') ? 0.28 : 0.46,
    );

    _label(canvas, caption, Offset(cx, 18), size: 13);
    _label(canvas, pressure, Offset(cx, top + (bottom - top) * 0.38), size: 12);
  }

  void _flowArrow(Canvas canvas, Offset from, Offset to) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(from, to - const Offset(9, 0), paint);
    final head = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(to.dx - 10, to.dy - 5)
      ..lineTo(to.dx - 10, to.dy + 5)
      ..close();
    canvas.drawPath(head, Paint()..color = _ink);
  }

  void _doubleArrow(Canvas canvas, Offset from, Offset to, Paint paint) {
    final delta = to - from;
    final length = delta.distance;
    if (length < 1) return;
    final along = delta / length;
    final across = Offset(-along.dy, along.dx);
    canvas.drawLine(from, to, paint);
    const head = 7.0;
    const wing = 4.0;
    canvas.drawLine(from, from + along * head + across * wing, paint);
    canvas.drawLine(from, from + along * head - across * wing, paint);
    canvas.drawLine(to, to - along * head + across * wing, paint);
    canvas.drawLine(to, to - along * head - across * wing, paint);
  }

  void _label(Canvas canvas, String text, Offset origin, {double size = 12}) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(
          color: _ink,
          fontSize: size,
          fontWeight: FontWeight.w600,
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
  bool shouldRepaint(covariant _EvacuatedCylinderPainter oldDelegate) =>
      oldDelegate.before != before ||
      oldDelegate.after != after ||
      oldDelegate.heightLabel != heightLabel ||
      oldDelegate.radiusLabel != radiusLabel;
}
