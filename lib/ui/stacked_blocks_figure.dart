import 'package:flutter/material.dart';

/// 仮の力学問題の図。質量は問題文の 1.0 kg、3.0 kg、4.0 kg に合わせてある。
///
/// [groupProgress] が 0 より大きいときは、物体AとBを囲む線が伸びる。
class StackedBlocksFigure extends StatelessWidget {
  const StackedBlocksFigure({super.key, this.groupProgress = 0});

  final double groupProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 195,
      width: 200,
      child: CustomPaint(
        painter: _StackedBlocksPainter(groupProgress: groupProgress),
      ),
    );
  }
}

class _StackedBlocksPainter extends CustomPainter {
  const _StackedBlocksPainter({required this.groupProgress});

  final double groupProgress;

  @override
  void paint(Canvas canvas, Size size) {
    const labels = ['物体A  1.0 kg', '物体B  3.0 kg', '物体C  4.0 kg'];
    final box = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF37474F);
    const blockWidth = 120.0;
    const blockHeight = 42.0;
    final left = (size.width - blockWidth) / 2 + 8;
    var top = 8.0;
    final rects = <Rect>[];
    for (final _ in labels) {
      rects.add(Rect.fromLTWH(left, top, blockWidth, blockHeight));
      top += blockHeight;
    }
    if (groupProgress > 0) {
      final fill = Paint()
        ..color = const Color(0xFF1565C0)
            .withValues(alpha: 0.14 * groupProgress);
      canvas.drawRect(rects[0], fill);
      canvas.drawRect(rects[1], fill);
      _drawGroupBrace(canvas, rects[0], rects[1], groupProgress);
    }
    for (var i = 0; i < labels.length; i++) {
      canvas.drawRect(rects[i], box);
      _drawLabel(canvas, labels[i], rects[i].center);
    }
    _drawForceArrow(canvas, Offset(left + blockWidth / 2, top + 28), top - 4);
  }

  /// 物体AとBの左に、ひとまとめを表す括弧を進捗ぶんだけ描く。
  void _drawGroupBrace(Canvas canvas, Rect upper, Rect lower, double progress) {
    final x = upper.left - 14;
    final top = upper.top + 2;
    final bottom = lower.bottom - 2;
    final mid = (top + bottom) / 2;
    final path = Path()
      ..moveTo(x + 10, top)
      ..cubicTo(x, top + 8, x, mid - 8, x, mid)
      ..cubicTo(x, mid + 8, x, bottom - 8, x + 10, bottom);
    final metric = path.computeMetrics().first;
    canvas.drawPath(
      metric.extractPath(0, metric.length * progress),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF1565C0),
    );
  }

  void _drawLabel(Canvas canvas, String label, Offset center) {
    final painter = TextPainter(
      text: TextSpan(
        text: label,
        style: const TextStyle(color: Color(0xFF263238), fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  void _drawForceArrow(Canvas canvas, Offset from, double tipY) {
    final paint = Paint()
      ..color = const Color(0xFF1565C0)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    final tip = Offset(from.dx, tipY);
    canvas.drawLine(from, tip, paint);
    final head = Path()
      ..moveTo(tip.dx, tip.dy)
      ..lineTo(tip.dx - 6, tip.dy + 10)
      ..lineTo(tip.dx + 6, tip.dy + 10)
      ..close();
    canvas.drawPath(head, Paint()..color = const Color(0xFF1565C0));
    final label = TextPainter(
      text: const TextSpan(
        text: '外力',
        style: TextStyle(color: Color(0xFF1565C0), fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, Offset(from.dx + 10, from.dy - 8));
  }

  @override
  bool shouldRepaint(covariant _StackedBlocksPainter oldDelegate) =>
      oldDelegate.groupProgress != groupProgress;
}
