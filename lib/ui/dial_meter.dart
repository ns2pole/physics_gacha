import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 円い文字盤。針は下左から上を通って下右へ回る。
void paintDialMeter(
  Canvas canvas,
  Offset center,
  double radius, {
  Color color = const Color(0xFF37474F),
  Color needle = const Color(0xFF1565C0),
  double fraction = 0.38,
}) {
  final ring = Paint()
    ..color = color
    ..strokeWidth = 1.4
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  canvas.drawCircle(center, radius, Paint()..color = const Color(0xFFFFFFFF));
  canvas.drawCircle(center, radius, ring);
  const ticks = 11;
  for (var i = 0; i < ticks; i++) {
    final angle = math.pi * 0.75 + i * (math.pi * 1.5 / (ticks - 1));
    final long = i.isEven;
    final inner = center + _dir(angle) * (radius * (long ? 0.58 : 0.68));
    final outer = center + _dir(angle) * (radius * 0.84);
    canvas.drawLine(
      inner,
      outer,
      ring..strokeWidth = long ? 1.3 : 0.9,
    );
  }
  final needleAngle =
      math.pi * 0.75 + fraction.clamp(0.0, 1.0) * math.pi * 1.5;
  canvas.drawLine(
    center,
    center + _dir(needleAngle) * (radius * 0.62),
    Paint()
      ..color = needle
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round,
  );
  canvas.drawCircle(center, math.max(1.6, radius * 0.08), Paint()..color = color);
}

/// 測る場所の圧力計。針の下に [reading] を書く。
void paintPressureGauge(
  Canvas canvas,
  Offset center, {
  String reading = '??? hPa',
  Color color = const Color(0xFF37474F),
  double radius = 13,
  double fraction = 0.42,
  Offset labelShift = Offset.zero,
}) {
  paintDialMeter(canvas, center, radius, color: color, fraction: fraction);
  final painter = TextPainter(
    text: TextSpan(
      text: reading,
      style: figureLabelStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final origin = center + Offset(0, radius + 10) + labelShift;
  painter.paint(
    canvas,
    origin - Offset(painter.width / 2, painter.height / 2),
  );
}

/// 皿の下に文字盤がある台秤。皿の中心を [pan] に置く。
void paintPlatformScale(
  Canvas canvas,
  Offset pan, {
  Color color = const Color(0xFF37474F),
  double panHalf = 30,
  double bodyHeight = 38,
  double fraction = 0.38,
}) {
  final line = Paint()
    ..color = color
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final y = pan.dy;
  final x = pan.dx;
  canvas.drawLine(Offset(x - panHalf, y - 5), Offset(x - panHalf + 5, y), line);
  canvas.drawLine(Offset(x - panHalf + 5, y), Offset(x + panHalf - 5, y), line);
  canvas.drawLine(Offset(x + panHalf - 5, y), Offset(x + panHalf, y - 5), line);
  final body = Path()
    ..moveTo(x - panHalf + 8, y + 3)
    ..lineTo(x + panHalf - 8, y + 3)
    ..lineTo(x + panHalf + 2, y + bodyHeight)
    ..lineTo(x - panHalf - 2, y + bodyHeight)
    ..close();
  canvas.drawPath(body, line);
  paintDialMeter(
    canvas,
    Offset(x, y + bodyHeight * 0.56),
    bodyHeight * 0.34,
    color: color,
    fraction: fraction,
  );
}

Offset _dir(double angle) => Offset(math.cos(angle), math.sin(angle));
