import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 極板そのものの断面。回路は描かない。
enum CapacitorPlateKind { vacuum, paper, metal }

/// 一辺 10 cm の正方形極板。真空、紙、金属板の3通り。
class CapacitorPlateFigure extends StatelessWidget {
  const CapacitorPlateFigure({super.key, required this.kind});

  final CapacitorPlateKind kind;

  @override
  Widget build(BuildContext context) {
    final metal = kind == CapacitorPlateKind.metal;
    return SizedBox(
      height: metal ? 176 : 120,
      width: 236,
      child: CustomPaint(painter: _CapacitorPlatePainter(kind)),
    );
  }
}

class _CapacitorPlatePainter extends CustomPainter {
  const _CapacitorPlatePainter(this.kind);

  final CapacitorPlateKind kind;

  static const _ink = Color(0xFF37474F);
  static const _left = 16.0;
  static const _right = 148.0;

  @override
  void paint(Canvas canvas, Size size) {
    switch (kind) {
      case CapacitorPlateKind.vacuum:
        _pair(canvas, top: 16, gap: 44, gapLabel: '1 mm');
      case CapacitorPlateKind.paper:
        _pair(canvas, top: 16, gap: 44, gapLabel: '0.1 mm', paper: true);
      case CapacitorPlateKind.metal:
        _metal(canvas);
    }
  }

  void _pair(
    Canvas canvas, {
    required double top,
    required double gap,
    required String gapLabel,
    bool paper = false,
  }) {
    final upper = Rect.fromLTRB(_left, top, _right, top + 8);
    final lowerTop = upper.bottom + gap;
    final lower = Rect.fromLTRB(_left, lowerTop, _right, lowerTop + 8);
    final space = Rect.fromLTRB(_left, upper.bottom, _right, lower.top);
    if (paper) _paper(canvas, space);
    _electrode(canvas, upper);
    _electrode(canvas, lower);
    _gapDim(canvas, space, gapLabel);
    _lengthDim(canvas, lower.bottom);
    if (paper) {
      _label(
        canvas,
        'εᵣ = 2.0',
        space.center,
        backdrop: const Color(0xFFFFE0B2),
      );
    }
  }

  void _metal(Canvas canvas) {
    const top = 12.0;
    final upper = Rect.fromLTRB(_left, top, _right, top + 8);
    final gap1 = Rect.fromLTRB(_left, upper.bottom, _right, upper.bottom + 30);
    final slab = Rect.fromLTRB(_left, gap1.bottom, _right, gap1.bottom + 24);
    final gap2 = Rect.fromLTRB(_left, slab.bottom, _right, slab.bottom + 45);
    final lower = Rect.fromLTRB(_left, gap2.bottom, _right, gap2.bottom + 8);

    canvas.drawRect(slab, Paint()..color = const Color(0xFF607D8B));
    canvas.drawRect(slab, _stroke());
    _electrode(canvas, upper);
    _electrode(canvas, lower);
    _gapDim(canvas, gap1, '0.2 mm');
    _gapDim(canvas, gap2, '0.3 mm');
    _lengthDim(canvas, lower.bottom);
  }

  void _electrode(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, Paint()..color = const Color(0xFFECEFF1));
    canvas.drawRect(rect, _stroke());
  }

  void _paper(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, Paint()..color = const Color(0xFFFFE0B2));
    canvas.save();
    canvas.clipRect(rect);
    final hatch = Paint()
      ..color = const Color(0xFF8D6E63).withValues(alpha: 0.55)
      ..strokeWidth = 1.1;
    for (var x = rect.left - rect.height; x < rect.right; x += 6) {
      canvas.drawLine(
        Offset(x, rect.bottom),
        Offset(x + rect.height, rect.top),
        hatch,
      );
    }
    canvas.restore();
  }

  void _gapDim(Canvas canvas, Rect gap, String label) {
    final paint = _stroke(1.15);
    const x = 166.0;
    canvas.drawLine(
      Offset(gap.right + 3, gap.top),
      Offset(x + 4, gap.top),
      paint,
    );
    canvas.drawLine(
      Offset(gap.right + 3, gap.bottom),
      Offset(x + 4, gap.bottom),
      paint,
    );
    canvas.drawLine(Offset(x, gap.top), Offset(x, gap.bottom), paint);
    _arrow(canvas, Offset(x, gap.top), const Offset(0, -1), paint);
    _arrow(canvas, Offset(x, gap.bottom), const Offset(0, 1), paint);
    final text = _text(label);
    text.paint(canvas, Offset(x + 8, gap.center.dy - text.height / 2));
  }

  void _lengthDim(Canvas canvas, double plateBottom) {
    final paint = _stroke(1.15);
    final y = plateBottom + 22;
    canvas.drawLine(
      Offset(_left, plateBottom + 3),
      Offset(_left, y + 4),
      paint,
    );
    canvas.drawLine(
      Offset(_right, plateBottom + 3),
      Offset(_right, y + 4),
      paint,
    );
    final label = _text('10 cm');
    final mid = (_left + _right) / 2;
    final half = label.width / 2 + 6;
    canvas.drawLine(Offset(_left, y), Offset(mid - half, y), paint);
    canvas.drawLine(Offset(mid + half, y), Offset(_right, y), paint);
    _arrow(canvas, Offset(_left, y), const Offset(-1, 0), paint);
    _arrow(canvas, Offset(_right, y), const Offset(1, 0), paint);
    label.paint(canvas, Offset(mid - label.width / 2, y - label.height / 2));
  }

  Paint _stroke([double width = 1.5]) {
    return Paint()
      ..color = _ink
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
  }

  void _arrow(Canvas canvas, Offset tip, Offset dir, Paint paint) {
    final normal = Offset(-dir.dy, dir.dx);
    final base = tip - dir * 6;
    canvas.drawLine(tip, base + normal * 3.2, paint);
    canvas.drawLine(tip, base - normal * 3.2, paint);
  }

  TextPainter _text(String text) {
    return TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(color: _ink, height: 1),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  void _label(Canvas canvas, String text, Offset center, {Color? backdrop}) {
    final painter = _text(text);
    final origin = center - Offset(painter.width / 2, painter.height / 2);
    if (backdrop != null) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            origin.dx - 4,
            origin.dy - 1,
            painter.width + 8,
            painter.height + 2,
          ),
          const Radius.circular(2),
        ),
        Paint()..color = backdrop,
      );
    }
    painter.paint(canvas, origin);
  }

  @override
  bool shouldRepaint(covariant _CapacitorPlatePainter oldDelegate) =>
      oldDelegate.kind != kind;
}
