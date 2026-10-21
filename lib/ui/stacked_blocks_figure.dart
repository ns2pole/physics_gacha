import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';

/// 仮の力学問題の図。質量は問題文の 1.0 kg、3.0 kg、4.0 kg に合わせてある。
///
/// [groupProgress] が 0 より大きいときは、物体AとBを囲む線が伸びる。
/// 全体は上向きに加速して止まり、はじめの位置に戻る。
class StackedBlocksFigure extends StatefulWidget {
  const StackedBlocksFigure({super.key, this.groupProgress = 0});

  final double groupProgress;

  @override
  State<StackedBlocksFigure> createState() => _StackedBlocksFigureState();
}

class _StackedBlocksFigureState extends State<StackedBlocksFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    if (figureClockRuns) _clock.repeat();
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final labels = FigureLabels.of(context);
    return SizedBox(
      height: 210,
      width: 160,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          final t = playPauseProgress(_clock.value);
          return CustomPaint(
            painter: _StackedBlocksPainter(
              groupProgress: widget.groupProgress,
              lift: 40 * t * t,
              objectA: '${labels.objectA}  1.0 kg',
              objectB: '${labels.objectB}  3.0 kg',
              objectC: '${labels.objectC}  4.0 kg',
              externalForce: labels.externalForce,
            ),
          );
        },
      ),
    );
  }
}

class _StackedBlocksPainter extends CustomPainter {
  const _StackedBlocksPainter({
    required this.groupProgress,
    required this.lift,
    required this.objectA,
    required this.objectB,
    required this.objectC,
    required this.externalForce,
  });

  final double groupProgress;
  final double lift;
  final String objectA;
  final String objectB;
  final String objectC;
  final String externalForce;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(-22, -lift);
    final labels = [objectA, objectB, objectC];
    final box = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = const Color(0xFF37474F);
    const blockWidth = 120.0;
    const blockHeight = 42.0;
    const left = 48.0;
    var top = 50.0;
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
    canvas.restore();
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
      text: TextSpan(
        text: externalForce,
        style: const TextStyle(color: Color(0xFF1565C0), fontSize: 13),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    label.paint(canvas, Offset(from.dx + 10, from.dy - 8));
  }

  @override
  bool shouldRepaint(covariant _StackedBlocksPainter oldDelegate) =>
      oldDelegate.groupProgress != groupProgress ||
      oldDelegate.lift != lift ||
      oldDelegate.objectA != objectA ||
      oldDelegate.objectB != objectB ||
      oldDelegate.objectC != objectC ||
      oldDelegate.externalForce != externalForce;
}
