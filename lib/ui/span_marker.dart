import 'package:flutter/material.dart';

/// ここからここまで、を `|<---->|` で示す。水平でも垂直でも使える。
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

  canvas.drawLine(from - cap, from + cap, paint);
  canvas.drawLine(to - cap, to + cap, paint);

  const head = 6.0;
  canvas.drawLine(from, from + along * head + across * 3.5, paint);
  canvas.drawLine(from, from + along * head - across * 3.5, paint);
  canvas.drawLine(to, to - along * head + across * 3.5, paint);
  canvas.drawLine(to, to - along * head - across * 3.5, paint);

  final painter = TextPainter(
    text: TextSpan(
      text: label,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  final mid = Offset((from.dx + to.dx) / 2, (from.dy + to.dy) / 2);
  final vertical = along.dy.abs() > along.dx.abs();
  if (vertical) {
    canvas.drawLine(from, to, paint);
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

  final gap = painter.width / 2 + 8;
  if (length > gap * 2 + 16) {
    canvas.drawLine(from, mid - along * gap, paint);
    canvas.drawLine(mid + along * gap, to, paint);
  } else {
    canvas.drawLine(from, to, paint);
  }
  painter.paint(
    canvas,
    mid - Offset(painter.width / 2, painter.height / 2),
  );
}
