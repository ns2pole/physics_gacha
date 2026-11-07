import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// ここからここまでを、両端が矢印の線で示す。水平でも垂直でも使える。
/// [tick] は縦のとき、ラベルを置く側（x の符号）を決める。
/// 両端には、寸法に垂直な点線ガイドを描き「ここからここまで」を明示する。
void paintSpanMarker({
  required Canvas canvas,
  required Offset from,
  required Offset to,
  required String label,
  required Color color,
  Offset tick = Offset.zero,
  double guide = 18,
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
      style: figureLabelStyle(color: color),
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

  if (guide > 0) {
    // 縦寸法 → 水平の点線、横寸法 → 鉛直の点線。
    // tick があるときはラベルと反対側（図本体側）へ長めに伸ばす。
    if (tick != Offset.zero) {
      final objectDir = Offset(
        tick.dx == 0 ? 0.0 : -tick.dx.sign,
        tick.dy == 0 ? 0.0 : -tick.dy.sign,
      );
      final dir = objectDir.distance > 0 ? objectDir : across;
      final reach = guide * 2.8;
      for (final tip in [from, to]) {
        paintDashedGuide(
          canvas: canvas,
          from: tip - dir * (guide * 0.35),
          to: tip + dir * reach,
          color: color,
        );
      }
    } else {
      paintDashedGuide(
        canvas: canvas,
        from: from - across * guide,
        to: from + across * guide,
        color: color,
      );
      paintDashedGuide(
        canvas: canvas,
        from: to - across * guide,
        to: to + across * guide,
        color: color,
      );
    }
  }

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
  final gap = painter.width / 2 + 8;
  if (length > gap * 2 + 16) {
    painter.paint(canvas, mid - Offset(painter.width / 2, painter.height / 2));
  } else {
    painter.paint(
      canvas,
      Offset(to.dx + 8, mid.dy - painter.height / 2),
    );
  }
}

/// 寸法の端を示す点線。
void paintDashedGuide({
  required Canvas canvas,
  required Offset from,
  required Offset to,
  required Color color,
}) {
  final paint = Paint()
    ..color = color.withValues(alpha: 0.55)
    ..strokeWidth = 1.2
    ..strokeCap = StrokeCap.round;
  final delta = to - from;
  final length = delta.distance;
  if (length < 1) return;
  final step = delta / length;
  const dash = 4.0;
  const gap = 3.5;
  var drawn = 0.0;
  while (drawn < length) {
    final end = math.min(drawn + dash, length);
    canvas.drawLine(from + step * drawn, from + step * end, paint);
    drawn += dash + gap;
  }
}
