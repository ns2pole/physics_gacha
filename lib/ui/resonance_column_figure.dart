import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/figure_label_style.dart';

/// 水面を上下できる共鳴装置。l は筒の上端から水面まで。A は水だめ。
class ResonanceColumnFigure extends StatelessWidget {
  const ResonanceColumnFigure({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 228,
      width: 246,
      child: CustomPaint(painter: _ResonanceColumnPainter()),
    );
  }
}

class _ResonanceColumnPainter extends CustomPainter {
  const _ResonanceColumnPainter();

  static const _ink = Color(0xFF37474F);
  static const _hoseInk = Color(0xFF263238);
  static const _water = Color(0xFFC4C4C4);

  static const _tubeL = 72.0;
  static const _tubeR = 100.0;
  static const _mouth = 36.0;
  static const _surface = 74.0;
  static const _bend = 168.0;

  static const _cupL = 158.0;
  static const _cupR = 198.0;
  static const _cupTop = 60.0;
  static const _cupSide = 78.0;
  static const _cupNeck = 102.0;
  static const _neckHalf = 5.5;

  static const _hoseBottom = 212.0;
  static const _hoseWidth = 11.0;

  static double get _tubeCx => (_tubeL + _tubeR) / 2;
  static double get _glassR => (_tubeR - _tubeL) / 2;
  static double get _glassBottom => _bend + _glassR;
  static double get _cupCx => (_cupL + _cupR) / 2;

  @override
  void paint(Canvas canvas, Size size) {
    final wall = Paint()
      ..color = _ink
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.butt;

    final glass = _glassPath();
    final glassFill = Path.from(glass)..close();
    final cupFill = _cupPath(closeBottom: true)..close();
    _fill(canvas, glassFill);
    _fill(canvas, cupFill);
    canvas.drawPath(glass, wall);
    canvas.drawPath(_cupPath(closeBottom: false), wall);
    _surfaces(canvas);
    _hose(canvas);
    _fork(canvas);
    _span(canvas);
    _label(canvas, 'A', const Offset(_cupR + 14, _surface - 1), italic: false);
  }

  Path _glassPath() {
    final r = _glassR;
    return Path()
      ..moveTo(_tubeL, _mouth)
      ..lineTo(_tubeL, _bend)
      ..arcTo(
        Rect.fromLTWH(_tubeL, _bend - r, r * 2, r * 2),
        math.pi,
        -math.pi,
        false,
      )
      ..lineTo(_tubeR, _mouth);
  }

  Path _cupPath({required bool closeBottom}) {
    final cx = _cupCx;
    final path = Path()
      ..moveTo(_cupL, _cupTop)
      ..lineTo(_cupL, _cupSide)
      ..cubicTo(
        _cupL,
        _cupSide + 16,
        cx - _neckHalf,
        _cupNeck - 14,
        cx - _neckHalf,
        _cupNeck,
      );
    if (closeBottom) {
      path.lineTo(cx + _neckHalf, _cupNeck);
    } else {
      path.moveTo(cx + _neckHalf, _cupNeck);
    }
    path
      ..cubicTo(
        cx + _neckHalf,
        _cupNeck - 14,
        _cupR,
        _cupSide + 16,
        _cupR,
        _cupSide,
      )
      ..lineTo(_cupR, _cupTop);
    return path;
  }

  void _fill(Canvas canvas, Path outline) {
    canvas.save();
    canvas.clipPath(outline);
    canvas.drawRect(
      const Rect.fromLTRB(0, _surface, 320, 280),
      Paint()..color = _water,
    );
    canvas.restore();
  }

  void _surfaces(Canvas canvas) {
    final line = Paint()
      ..color = _ink
      ..strokeWidth = 1.15
      ..strokeCap = StrokeCap.butt;
    canvas.drawLine(
      const Offset(_tubeL + 1.1, _surface),
      const Offset(_tubeR - 1.1, _surface),
      line,
    );
    canvas.drawLine(
      const Offset(_cupL + 1.1, _surface),
      const Offset(_cupR - 1.1, _surface),
      line,
    );
  }

  void _hose(Canvas canvas) {
    final paint = Paint()
      ..color = _hoseInk
      ..style = PaintingStyle.stroke
      ..strokeWidth = _hoseWidth
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round;
    final left = _tubeCx;
    final right = _cupCx;
    final bottom = _hoseBottom;
    final path = Path()
      ..moveTo(left, _glassBottom - 10)
      ..lineTo(left, bottom - 32)
      ..cubicTo(left, bottom, left + 28, bottom, (left + right) / 2, bottom)
      ..cubicTo(right - 28, bottom, right, bottom, right, bottom - 32)
      ..lineTo(right, _cupNeck - 6);
    canvas.drawPath(path, paint);
  }

  void _fork(Canvas canvas) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.7
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    const prong = 6.5;
    const top = 4.0;
    const stemY = 18.0;
    final cx = _tubeCx;
    canvas.drawPath(
      Path()
        ..moveTo(cx - prong, top)
        ..lineTo(cx - prong, stemY - 8)
        ..quadraticBezierTo(cx - prong, stemY, cx, stemY)
        ..lineTo(cx, 33),
      paint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(cx + prong, top)
        ..lineTo(cx + prong, stemY - 8)
        ..quadraticBezierTo(cx + prong, stemY, cx, stemY),
      paint,
    );
  }

  void _span(Canvas canvas) {
    final paint = Paint()
      ..color = _ink
      ..strokeWidth = 1.15
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const x = 50.0;
    canvas.drawLine(
      const Offset(x - 3, _mouth),
      const Offset(_tubeL - 2, _mouth),
      paint,
    );
    canvas.drawLine(
      const Offset(x - 3, _surface),
      const Offset(_tubeL - 2, _surface),
      paint,
    );
    canvas.drawLine(const Offset(x, _mouth), const Offset(x, _surface), paint);
    _arrow(canvas, const Offset(x, _mouth), paint, up: true);
    _arrow(canvas, const Offset(x, _surface), paint, up: false);
    _label(
      canvas,
      'l',
      const Offset(x - 12, (_mouth + _surface) / 2),
      italic: true,
    );
  }

  void _arrow(Canvas canvas, Offset tip, Paint paint, {required bool up}) {
    final dy = up ? 6.0 : -6.0;
    canvas.drawLine(tip, Offset(tip.dx - 3.2, tip.dy + dy), paint);
    canvas.drawLine(tip, Offset(tip.dx + 3.2, tip.dy + dy), paint);
  }

  void _label(
    Canvas canvas,
    String text,
    Offset center, {
    required bool italic,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: figureLabelStyle(
          color: _ink,
          fontSize: 16,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(
      canvas,
      center - Offset(painter.width / 2, painter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
