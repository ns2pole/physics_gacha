import 'package:flutter/material.dart';

import '../utils/figure_clock.dart';
import '../utils/figure_label_style.dart';

const noteInk = Color(0xFF37474F);
const noteFill = Color(0xFFECEFF1);
const noteAccent = Color(0xFF1565C0);
const noteSoft = Color(0xFF90A4AE);

class NoteStage extends StatefulWidget {
  const NoteStage({
    super.key,
    required this.painter,
    this.animate = false,
    this.duration = const Duration(milliseconds: 2600),
    this.height = 188,
    this.width = 230,
  });

  final CustomPainter Function(double progress) painter;
  final bool animate;
  final Duration duration;
  final double height;
  final double width;

  @override
  State<NoteStage> createState() => _NoteStageState();
}

class _NoteStageState extends State<NoteStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _clock;

  @override
  void initState() {
    super.initState();
    _clock = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate && figureClockRuns) _clock.repeat();
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: AnimatedBuilder(
        animation: _clock,
        builder: (context, _) {
          final progress = widget.animate ? _clock.value : 0.0;
          return CustomPaint(painter: widget.painter(progress));
        },
      ),
    );
  }
}

Paint noteStroke([Color color = noteInk, double width = 1.6]) {
  return Paint()
    ..color = color
    ..strokeWidth = width
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
}

Paint noteSolid(Color color) => Paint()..color = color;

void noteText(Canvas canvas, String text, Offset center, {double size = 12}) {
  final painter = TextPainter(
    text: TextSpan(
      text: text,
      style: figureLabelStyle(
        color: noteInk,
        fontSize: size,
        fontWeight: FontWeight.w600,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();
  painter.paint(canvas, center - Offset(painter.width / 2, painter.height / 2));
}

void noteLine(Canvas canvas, Offset a, Offset b, [Paint? paint]) {
  canvas.drawLine(a, b, paint ?? noteStroke());
}

void noteMass(Canvas canvas, Offset center, {double radius = 11}) {
  canvas.drawCircle(center, radius, noteSolid(noteFill));
  canvas.drawCircle(center, radius, noteStroke());
}

void noteSpring(Canvas canvas, Offset from, Offset to, {int coils = 7}) {
  final delta = to - from;
  final length = delta.distance;
  if (length < 1) return;
  final dir = delta / length;
  final normal = Offset(-dir.dy, dir.dx);
  final path = Path()..moveTo(from.dx, from.dy);
  final lead = length * 0.12;
  path.lineTo(from.dx + dir.dx * lead, from.dy + dir.dy * lead);
  final span = length - 2 * lead;
  for (var i = 0; i < coils; i++) {
    final along = lead + span * (i + 0.5) / coils;
    final side = i.isEven ? 8.0 : -8.0;
    final point = from + dir * along + normal * side;
    path.lineTo(point.dx, point.dy);
  }
  path.lineTo(to.dx, to.dy);
  canvas.drawPath(path, noteStroke());
}

void noteArrow(Canvas canvas, Offset from, Offset to, {Color? color}) {
  final paint = noteStroke(color ?? noteAccent, 1.8);
  canvas.drawLine(from, to, paint);
  final delta = to - from;
  final length = delta.distance;
  if (length < 1) return;
  final dir = delta / length;
  final normal = Offset(-dir.dy, dir.dx);
  final head = Path()
    ..moveTo(to.dx, to.dy)
    ..lineTo((to - dir * 8 + normal * 4).dx, (to - dir * 8 + normal * 4).dy)
    ..lineTo((to - dir * 8 - normal * 4).dx, (to - dir * 8 - normal * 4).dy)
    ..close();
  canvas.drawPath(head, noteSolid(color ?? noteAccent));
}

class NotePainter extends CustomPainter {
  const NotePainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant NotePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
