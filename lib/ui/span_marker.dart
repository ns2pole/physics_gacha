import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// ここからここまでを、両端が矢印の線で示す。水平でも垂直でも使える。
/// [tick] は縦のとき、ラベルを置く側（x の符号）を決める。
void paintSpanMarker({
  required Canvas canvas,
  required Offset from,
  required Offset to,
  required String label,
  required Color color,
  Offset tick = Offset.zero,
}) {
  final paint = Paint()
    ..color = color
    ..strokeWidth = 1.2
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;
  final delta = to - from;
  final length = delta.distance;
  if (length < 1) return;
  final along = delta / length;
  final across = Offset(-along.dy, along.dx);
  final cap = tick == Offset.zero ? across * 10 : tick;

  final painter = TextPainter(
    text: TextSpan(
      text: label,
      style: figureLabelStyle(color: color, fontWeight: FontWeight.w600),
    ),
    textAlign: tick.dx < 0 ? TextAlign.right : TextAlign.left,
    textDirection: TextDirection.ltr,
  )..layout();
  final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
  final vertical = along.dy.abs() > along.dx.abs();
  if (vertical) {
    canvas.drawLine(from, to, paint);
  } else {
    final gap = painter.width / 2 + 8;
    if (length > gap * 2 + 16) {
      canvas.drawLine(from, mid - along * gap, paint);
      canvas.drawLine(mid + along * gap, to, paint);
    } else {
      canvas.drawLine(from, to, paint);
    }
  }

  const head = 7.0;
  const wing = 4.0;
  canvas.drawLine(from, from + along * head + across * wing, paint);
  canvas.drawLine(from, from + along * head - across * wing, paint);
  canvas.drawLine(to, to - along * head + across * wing, paint);
  canvas.drawLine(to, to - along * head - across * wing, paint);

  if (vertical) {
    final toward = cap.dx == 0 ? 1.0 : cap.dx.sign;
    final inner = mid.dx + toward * (cap.dx.abs() + 6);
    painter.paint(
      canvas,
      Offset(
        toward > 0 ? inner : inner - painter.width,
        mid.dy - painter.height / 2,
      ),
    );
    return;
  }
  painter.paint(canvas, mid - Offset(painter.width / 2, painter.height / 2));
}
