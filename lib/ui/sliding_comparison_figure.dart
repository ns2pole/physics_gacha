import 'package:flutter/material.dart';

/// 同じ水平面をすべる2つの場合。下の距離は上の4倍で、減速の仕方は同じ。
class SlidingComparisonFigure extends StatefulWidget {
  const SlidingComparisonFigure({super.key});

  @override
  State<SlidingComparisonFigure> createState() => _SlidingComparisonFigureState();
}

class _SlidingComparisonFigureState extends State<SlidingComparisonFigure>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    final binding = WidgetsBinding.instance.runtimeType.toString();
    if (!binding.contains('TestWidgetsFlutterBinding')) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      width: 300,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          const motion = 0.82;
          final raw = _controller.value;
          final progress = raw >= motion ? 1.0 : raw / motion;
          return CustomPaint(painter: _SlidingComparisonPainter(progress: progress));
        },
      ),
    );
  }
}

class _SlidingComparisonPainter extends CustomPainter {
  const _SlidingComparisonPainter({required this.progress});

  /// 0 で出発、1 で遅い方が停止した直後。速い方はその半分で止まっている。
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const ink = Color(0xFF37474F);
    const blockColor = Color(0xFF1565C0);
    const origin = 36.0;
    const shortLength = 56.0;
    const longLength = shortLength * 4;

    _case(
      canvas,
      label: '初速 5.0 m/s',
      distance: 'L',
      groundY: 46,
      origin: origin,
      length: shortLength,
      fraction: _stopped(_fraction(progress / 0.5)),
      ink: ink,
      blockColor: blockColor,
    );
    _case(
      canvas,
      label: '初速 v₀',
      distance: '4L',
      groundY: 118,
      origin: origin,
      length: longLength,
      fraction: _stopped(_fraction(progress)),
      ink: ink,
      blockColor: blockColor,
    );
  }

  /// 等加速度で止まるまでの進み方。q は 0 が出発、1 が停止。
  double _fraction(double q) {
    final clamped = q.clamp(0.0, 1.0);
    return 2 * clamped - clamped * clamped;
  }

  double _stopped(double fraction) => fraction.clamp(0.0, 1.0);

  void _case(
    Canvas canvas, {
    required String label,
    required String distance,
    required double groundY,
    required double origin,
    required double length,
    required double fraction,
    required Color ink,
    required Color blockColor,
  }) {
    final ground = Paint()
      ..color = ink
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(origin - 16, groundY),
      Offset(origin + length + 18, groundY),
      ground,
    );
    _labelLeft(canvas, label, Offset(origin, groundY - 28), blockColor);
    _lengthMarker(canvas, groundY + 22, origin, origin + length, distance, ink);

    const blockWidth = 18.0;
    const blockHeight = 14.0;
    final center = Offset(origin + fraction * length, groundY - blockHeight / 2);
    final rect = Rect.fromCenter(center: center, width: blockWidth, height: blockHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(2)),
      Paint()..color = blockColor,
    );
  }

  void _lengthMarker(
    Canvas canvas,
    double y,
    double left,
    double right,
    String text,
    Color color,
  ) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final mid = (left + right) / 2;
    const gap = 16.0;
    if (mid - gap > left) {
      canvas.drawLine(Offset(left, y), Offset(mid - gap, y), paint);
    }
    if (mid + gap < right) {
      canvas.drawLine(Offset(mid + gap, y), Offset(right, y), paint);
    }
    _arrowHead(canvas, Offset(left, y), paint, outward: true);
    _arrowHead(canvas, Offset(right, y), paint, outward: false);
    _label(canvas, text, Offset(mid, y), color);
  }

  void _arrowHead(Canvas canvas, Offset tip, Paint paint, {required bool outward}) {
    final wing = outward ? 6.0 : -6.0;
    canvas.drawLine(tip, Offset(tip.dx + wing, tip.dy - 3.5), paint);
    canvas.drawLine(tip, Offset(tip.dx + wing, tip.dy + 3.5), paint);
  }

  void _label(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(painter.width / 2, painter.height / 2));
  }

  void _labelLeft(Canvas canvas, String text, Offset origin, Color color) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.w600),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, origin - Offset(0, painter.height / 2));
  }

  @override
  bool shouldRepaint(covariant _SlidingComparisonPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
