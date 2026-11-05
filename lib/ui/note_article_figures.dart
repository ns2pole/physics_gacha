import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/physics_problem.dart';
import 'dial_meter.dart';
import 'note_stage.dart';
import 'span_marker.dart';

Widget noteArticleFigure(ProblemFigure figure) {
  return switch (figure) {
    ProblemFigure.dopplerWall => const _ArticleImage(
      'assets/figures/doppler_wall.png',
    ),
    ProblemFigure.singleSlit => const _ArticleImage(
      'assets/figures/single_slit.png',
    ),
    ProblemFigure.diffractionGrating => const _Fig(_Kind.grating),
    ProblemFigure.toothbrushString => const _Fig(
      _Kind.brush,
      animate: true,
      duration: Duration(milliseconds: 1730),
    ),
    ProblemFigure.stringFundamental => const _Fig(
      _Kind.string,
      animate: true,
      duration: Duration(milliseconds: 1730),
    ),
    ProblemFigure.conicalPendulum => const _Fig(_Kind.cone, animate: true),
    ProblemFigure.twoSpeakers => const _Fig(_Kind.speakers),
    ProblemFigure.soundSpeedColumn => const _ArticleImage(
      'assets/figures/sound_column.png',
    ),
    ProblemFigure.verticalSpringRelease => const _ArticleImage(
      'assets/figures/vertical_spring.png',
    ),
    ProblemFigure.tensionCart => const _ArticleImage(
      'assets/figures/tension_cart.png',
    ),
    ProblemFigure.horizontalSpringRelease => const _ArticleImage(
      'assets/figures/horizontal_spring.png',
    ),
    ProblemFigure.pendulumBottomSpeed =>
        const _Fig(_Kind.swing, animate: true),
    ProblemFigure.blockEndLift => const _ArticleImage(
      'assets/figures/block_end_lift.png',
      scale: 0.75,
    ),
    ProblemFigure.diskHoleCenter => const _Fig(_Kind.disk),
    ProblemFigure.cutSheetCenter => const _Fig(_Kind.sheet),
    ProblemFigure.slideTipHeight => const _ArticleImage(
      'assets/figures/slide_tip.png',
    ),
    ProblemFigure.floatingWood => const _Fig(_Kind.wood),
    ProblemFigure.kineticFrictionSlide => const _ArticleImage(
      'assets/figures/kinetic_friction.png',
    ),
    ProblemFigure.staticFrictionHold => const _ArticleImage(
      'assets/figures/static_friction.png',
    ),
    ProblemFigure.turntableSpring => const _Fig(_Kind.turn, animate: true),
    ProblemFigure.elevatorScale => const _Fig(_Kind.lift, animate: true),
    ProblemFigure.nailPendulum => const _Fig(_Kind.nail, animate: true),
    ProblemFigure.underwaterScale => const _ArticleImage(
      'assets/figures/underwater_scale.png',
    ),
    ProblemFigure.pendulumBottomTension =>
      const _Fig(_Kind.tension, animate: true),
    ProblemFigure.stairPressure => const _Fig(_Kind.stairs, scale: 1.5),
    ProblemFigure.fujiPressure => const _Fig(_Kind.fuji),
    ProblemFigure.syringePiston => const _Fig(
      _Kind.syringe,
      animate: true,
      scale: 1.5,
    ),
    ProblemFigure.waterDepthPressure => const _Fig(_Kind.depth, scale: 1.25),
    ProblemFigure.invertedColumn => const _Fig(_Kind.invert, scale: 1.25),
    ProblemFigure.saltWaterPressure => const _Fig(_Kind.salt, scale: 1.25),
    ProblemFigure.heliumBag => const _Fig(_Kind.helium),
    ProblemFigure.nichromeWire => const _Fig(
      _Kind.wire,
      height: 220,
      width: 280,
    ),
    ProblemFigure.copperWire => const _Fig(
      _Kind.copper,
      height: 220,
      width: 280,
    ),
    ProblemFigure.currentLoop => const _Fig(_Kind.loop),
    ProblemFigure.rcDecay => const _ArticleImage(
      'assets/figures/rc_decay.jpg',
    ),
    ProblemFigure.solenoidCoil => const _Fig(
      _Kind.coil,
      height: 220,
      width: 280,
    ),
    ProblemFigure.lorentzBar => const _Fig(
      _Kind.bar,
      height: 220,
      width: 280,
    ),
    ProblemFigure.aluminumCube => const _Fig(_Kind.cube),
    _ => throw StateError('図がない: $figure'),
  };
}

class _ArticleImage extends StatelessWidget {
  const _ArticleImage(this.asset, {this.scale = 1});

  final String asset;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 問題カードでは横幅いっぱいに広げる。
        // 問題一覧は FittedBox が子に無限幅を渡すので、元画像サイズで測らせる。
        if (constraints.hasBoundedWidth) {
          return Image.asset(
            asset,
            width: constraints.maxWidth * scale,
            fit: BoxFit.contain,
          );
        }
        return Image.asset(asset, fit: BoxFit.contain);
      },
    );
  }
}

enum _Kind {
  doppler,
  slit,
  grating,
  brush,
  string,
  cone,
  speakers,
  column,
  vSpring,
  cart,
  hSpring,
  swing,
  disk,
  sheet,
  slide,
  wood,
  slideMu,
  hold,
  turn,
  lift,
  nail,
  dip,
  tension,
  stairs,
  fuji,
  syringe,
  depth,
  invert,
  salt,
  helium,
  wire,
  copper,
  loop,
  rc,
  coil,
  bar,
  cube,
}

class _Fig extends StatelessWidget {
  const _Fig(
    this.kind, {
    this.animate = false,
    this.duration = const Duration(milliseconds: 2600),
    this.height = 188,
    this.width = 230,
    this.scale = 1,
  });

  final _Kind kind;
  final bool animate;
  final Duration duration;
  final double height;
  final double width;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return NoteStage(
      animate: animate,
      duration: duration,
      height: height * scale,
      width: width * scale,
      painter: (progress) => _Paint(kind, progress, scale: scale),
    );
  }
}

class _Paint extends NotePainter {
  const _Paint(this.kind, super.progress, {this.scale = 1});

  final _Kind kind;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    if (scale != 1) {
      canvas.scale(scale);
    }
    switch (kind) {
      case _Kind.doppler:
        _doppler(canvas, size);
      case _Kind.slit:
        _slit(canvas, size);
      case _Kind.grating:
        _grating(canvas, size);
      case _Kind.brush:
        _brush(canvas, size);
      case _Kind.string:
        _string(canvas, size);
      case _Kind.cone:
        _cone(canvas, size);
      case _Kind.speakers:
        _speakers(canvas, size);
      case _Kind.column:
        _column(canvas, size);
      case _Kind.vSpring:
        _vSpring(canvas, size);
      case _Kind.cart:
        _cart(canvas, size);
      case _Kind.hSpring:
        _hSpring(canvas, size);
      case _Kind.swing:
        _swing(canvas, size);
      case _Kind.disk:
        _disk(canvas, size);
      case _Kind.sheet:
        _sheet(canvas, size);
      case _Kind.slide:
        _slide(canvas, size);
      case _Kind.wood:
        _wood(canvas, size);
      case _Kind.slideMu:
        _slideMu(canvas, size);
      case _Kind.hold:
        _hold(canvas, size);
      case _Kind.turn:
        _turn(canvas, size);
      case _Kind.lift:
        _lift(canvas, size);
      case _Kind.nail:
        _nail(canvas, size);
      case _Kind.dip:
        _dip(canvas, size);
      case _Kind.tension:
        _tension(canvas, size);
      case _Kind.stairs:
        _stairs(canvas, size);
      case _Kind.fuji:
        _fuji(canvas, size);
      case _Kind.syringe:
        _syringe(canvas, size);
      case _Kind.depth:
        _depth(canvas, size);
      case _Kind.invert:
        _invert(canvas, size);
      case _Kind.salt:
        _salt(canvas, size);
      case _Kind.helium:
        _helium(canvas, size);
      case _Kind.wire:
        _wire(canvas, size);
      case _Kind.copper:
        _copper(canvas, size);
      case _Kind.loop:
        _loop(canvas, size);
      case _Kind.rc:
        _rc(canvas, size);
      case _Kind.coil:
        _coil(canvas, size);
      case _Kind.bar:
        _bar(canvas, size);
      case _Kind.cube:
        _cube(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant _Paint oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.kind != kind ||
      oldDelegate.scale != scale;

  void _span(
    Canvas canvas,
    Offset from,
    Offset to,
    String label, {
    Offset tick = Offset.zero,
  }) {
    paintSpanMarker(
      canvas: canvas,
      from: from,
      to: to,
      label: label,
      color: noteInk,
      tick: tick,
    );
  }

  void _doubleArrow(Canvas canvas, Offset from, Offset to) {
    noteLine(canvas, from, to);
    final delta = to - from;
    final length = delta.distance;
    if (length < 1) return;
    final along = delta / length;
    final across = Offset(-along.dy, along.dx);
    const head = 7.0;
    const wing = 3.5;
    noteLine(canvas, from, from + along * head + across * wing);
    noteLine(canvas, from, from + along * head - across * wing);
    noteLine(canvas, to, to - along * head + across * wing);
    noteLine(canvas, to, to - along * head - across * wing);
  }

  void _doppler(Canvas canvas, Size size) {
    final wallX = 168 + 36 * progress;
    noteMass(canvas, const Offset(36, 96), radius: 14);
    noteText(canvas, '340 m/s', const Offset(70, 28));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(wallX, 48, 10, 100),
        const Radius.circular(2),
      ),
      noteSolid(noteFill),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(wallX, 48, 10, 100),
        const Radius.circular(2),
      ),
      noteStroke(),
    );
    noteArrow(canvas, Offset(wallX + 16, 70), Offset(wallX + 36, 70));
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: const Offset(36, 96), radius: 18.0 + i * 16),
        -0.7,
        1.4,
        false,
        noteStroke(noteSoft, 1.2),
      );
    }
  }

  void _slit(Canvas canvas, Size size) {
    noteLine(canvas, const Offset(28, 40), const Offset(28, 78));
    noteLine(canvas, const Offset(28, 110), const Offset(28, 150));
    noteLine(canvas, const Offset(190, 30), const Offset(190, 160));
    noteLine(canvas, const Offset(68, 94), const Offset(190, 94), noteStroke(noteSoft));
    noteLine(canvas, const Offset(68, 94), const Offset(190, 62), noteStroke(noteAccent));
    canvas.drawCircle(const Offset(190, 62), 4, noteSolid(noteInk));
    _span(canvas, const Offset(42, 78), const Offset(42, 110), 'd', tick: const Offset(8, 0));
    _span(canvas, const Offset(28, 172), const Offset(190, 172), 'L');
    _span(canvas, const Offset(204, 94), const Offset(204, 62), 'x', tick: const Offset(10, 0));
  }

  void _grating(Canvas canvas, Size size) {
    for (var i = 0; i < 5; i++) {
      final y = 46.0 + i * 22;
      noteLine(canvas, Offset(24, y), Offset(24, y + 12));
    }
    noteLine(canvas, const Offset(196, 24), const Offset(196, 164));
    noteLine(canvas, const Offset(32, 90), const Offset(196, 90), noteStroke(noteSoft));
    noteLine(canvas, const Offset(32, 90), const Offset(196, 48), noteStroke(noteAccent));
    canvas.drawCircle(const Offset(196, 48), 4, noteSolid(noteInk));
    _span(canvas, const Offset(24, 176), const Offset(196, 176), '1.0 m');
    noteText(canvas, '600 nm', const Offset(70, 28));
  }

  void _brush(Canvas canvas, Size size) {
    _stringOverPulley(
      canvas,
      lengthLabel: '0.50 m',
      massLabel: null,
      extraLabel: '70 Hz',
      leftIsVibrator: true,
    );
  }

  void _string(Canvas canvas, Size size) {
    _stringOverPulley(
      canvas,
      lengthLabel: '50 cm',
      massLabel: '200 g',
      extraLabel: null,
      leftIsVibrator: false,
    );
  }

  /// 台上の弦が、端の定滑車を通っておもりをつるす。
  void _stringOverPulley(
    Canvas canvas, {
    required String lengthLabel,
    required String? massLabel,
    required String? extraLabel,
    required bool leftIsVibrator,
  }) {
    const floorY = 172.0;
    const tableLeft = 28.0;
    const tableTop = 78.0;
    const tableRight = 148.0;
    const tableBottom = 160.0;
    const table = Rect.fromLTRB(tableLeft, tableTop, tableRight, tableBottom);
    const pulleyR = 10.0;
    const pulley = Offset(tableRight, tableTop);
    const stringY = tableTop - pulleyR;
    const stringLeft = tableLeft + 18.0;
    final wave = math.sin(progress * math.pi * 2);

    // 床と直方体の台。色は塗らず輪郭だけ。
    noteLine(
      canvas,
      const Offset(16, floorY),
      const Offset(214, floorY),
      noteStroke(noteSoft, 1.4),
    );
    canvas.drawRect(table, noteStroke(noteInk, 1.8));

    if (leftIsVibrator) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: const Offset(stringLeft - 8, stringY),
            width: 20,
            height: 30,
          ),
          const Radius.circular(3),
        ),
        noteStroke(),
      );
    } else {
      noteLine(
        canvas,
        const Offset(stringLeft, stringY - 20),
        const Offset(stringLeft, tableTop + 2),
      );
    }

    // 定滑車（台の右上隅）。
    canvas.drawCircle(pulley, pulleyR, noteSolid(const Color(0xFFFFFFFF)));
    canvas.drawCircle(pulley, pulleyR, noteStroke());
    canvas.drawCircle(pulley, 2.0, noteSolid(noteInk));

    final path = Path()..moveTo(stringLeft, stringY);
    const segments = 20;
    for (var i = 1; i <= segments; i++) {
      final t = i / segments;
      final x = stringLeft + (pulley.dx - stringLeft) * t;
      final y = stringY + math.sin(t * math.pi) * 12 * wave;
      path.lineTo(x, y);
    }
    canvas.drawPath(path, noteStroke(noteAccent));
    canvas.drawArc(
      Rect.fromCircle(center: pulley, radius: pulleyR),
      -math.pi / 2,
      math.pi / 2,
      false,
      noteStroke(noteAccent),
    );

    final hangX = pulley.dx + pulleyR;
    const massTop = 118.0;
    const massH = 22.0;
    noteLine(
      canvas,
      Offset(hangX, pulley.dy),
      Offset(hangX, massTop),
      noteStroke(noteAccent),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(hangX, massTop + massH / 2),
          width: 24,
          height: massH,
        ),
        const Radius.circular(3),
      ),
      noteStroke(),
    );

    _span(
      canvas,
      const Offset(stringLeft, 24),
      Offset(pulley.dx, 24),
      lengthLabel,
    );
    if (massLabel != null) {
      noteText(canvas, massLabel, Offset(hangX, massTop + massH + 14));
    }
    if (extraLabel != null) {
      noteText(canvas, extraLabel, Offset(table.center.dx, table.center.dy));
    }
  }

  void _cone(Canvas canvas, Size size) {
    // 斜め上から見た円軌道。おもりの中心が灰色の楕円をなぞる。
    const pivot = Offset(115, 28);
    const orbit = Offset(115, 150);
    const rx = 54.0;
    const ry = 9.0;
    final angle = progress * math.pi * 2;
    final bob = Offset(
      orbit.dx + rx * math.cos(angle),
      orbit.dy + ry * math.sin(angle),
    );
    final along = bob - pivot;
    final normal = Offset(-along.dy, along.dx) / along.distance * 14;
    // 接線方向（角速度と同じ向き）
    final tangent = Offset(-rx * math.sin(angle), ry * math.cos(angle));
    final tangentDir = tangent / tangent.distance;

    noteLine(canvas, const Offset(40, 28), const Offset(190, 28));
    canvas.drawOval(
      Rect.fromCenter(center: orbit, width: rx * 2, height: ry * 2),
      noteSolid(const Color(0xFFCFD8DC)),
    );
    canvas.drawOval(
      Rect.fromCenter(center: orbit, width: rx * 2, height: ry * 2),
      noteStroke(noteSoft, 1.4),
    );
    noteLine(canvas, pivot, bob);
    noteMass(canvas, bob);
    // 軌道上の速度の向き
    noteArrow(
      canvas,
      bob + tangentDir * 14,
      bob + tangentDir * 32,
      color: noteInk,
    );
    _span(canvas, pivot + normal, bob + normal, '2.0 m');
    noteText(canvas, '60°', const Offset(176, 56));
  }

  void _speakers(Canvas canvas, Size size) {
    // 点までの距離が 120 : 150 = 2.0 : 2.5 になる位置。
    const near = Offset(46, 50);
    const far = Offset(46, 140);
    const ear = Offset(166, 50);
    const radius = 8.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(18, 32, 28, 36),
        const Radius.circular(4),
      ),
      noteStroke(),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(18, 122, 28, 36),
        const Radius.circular(4),
      ),
      noteStroke(),
    );
    noteMass(canvas, ear, radius: radius);
    noteLine(canvas, near, _rim(near, ear, radius), noteStroke(noteAccent));
    noteLine(canvas, far, _rim(far, ear, radius), noteStroke(noteAccent));
    _span(canvas, const Offset(58, 26), const Offset(154, 26), '2.0 m');
    _span(canvas, const Offset(88, 156), const Offset(168, 96), '2.5 m');
  }

  Offset _rim(Offset from, Offset to, double radius) {
    final delta = to - from;
    return to - delta / delta.distance * radius;
  }

  void _column(Canvas canvas, Size size) {
    const left = 102.0;
    const right = 146.0;
    const top = 22.0;
    const bottom = 168.0;
    const markShort = 98.0;
    const markLong = 104.0;
    noteLine(canvas, const Offset(left, top), const Offset(left, bottom));
    noteLine(canvas, const Offset(right, top), const Offset(right, bottom));
    noteLine(canvas, const Offset(left, bottom), const Offset(right, bottom));
    canvas.drawRect(
      const Rect.fromLTRB(left + 1, markLong, right - 1, bottom),
      noteSolid(const Color(0xFFBBDEFB)),
    );
    noteLine(canvas, const Offset(80, top), const Offset(left, top), noteStroke(noteSoft));
    noteLine(canvas, const Offset(right, top), const Offset(164, top), noteStroke(noteSoft));
    noteLine(canvas, const Offset(80, markShort), const Offset(right, markShort), noteStroke(noteAccent));
    noteLine(canvas, const Offset(left, markLong), const Offset(164, markLong), noteStroke(noteSoft));
    _span(canvas, const Offset(80, top), const Offset(80, markShort), '16.0 cm', tick: const Offset(-8, 0));
    _span(canvas, const Offset(164, top), const Offset(164, markLong), '16.9 cm', tick: const Offset(8, 0));
  }

  void _vSpring(Canvas canvas, Size size) {
    final y = 118 + math.cos(progress * math.pi * 2) * 36;
    noteLine(canvas, const Offset(70, 16), const Offset(160, 16));
    noteSpring(canvas, const Offset(115, 16), Offset(115, y - 12));
    noteMass(canvas, Offset(115, y));
    noteLine(canvas, const Offset(100, 118), const Offset(206, 118), noteStroke(noteSoft));
    noteLine(canvas, const Offset(126, 154), const Offset(206, 154), noteStroke(noteSoft));
    _span(canvas, const Offset(206, 118), const Offset(206, 154), '0.30 m', tick: const Offset(-10, 0));
  }

  void _cart(Canvas canvas, Size size) {
    final x = 48 + progress * 70;
    noteLine(canvas, const Offset(20, 110), const Offset(210, 110));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, 86, 36, 22),
        const Radius.circular(3),
      ),
      noteStroke(),
    );
    noteLine(canvas, Offset(x + 36, 96), const Offset(198, 96));
    canvas.drawCircle(const Offset(198, 96), 8, noteStroke());
    noteLine(canvas, const Offset(198, 104), Offset(198, 128 + progress * 28));
    noteMass(canvas, Offset(198, 140 + progress * 28), radius: 9);
    noteLine(canvas, const Offset(84, 110), const Offset(84, 128), noteStroke(noteSoft));
    noteLine(canvas, const Offset(154, 110), const Offset(154, 128), noteStroke(noteSoft));
    _span(canvas, const Offset(84, 128), const Offset(154, 128), '0.50 m');
  }

  void _hSpring(Canvas canvas, Size size) {
    final x = 78 + progress * 70;
    noteLine(canvas, const Offset(16, 50), const Offset(16, 140));
    noteSpring(canvas, const Offset(16, 96), Offset(x - 16, 96), coils: 6);
    noteMass(canvas, Offset(x, 96));
    noteLine(canvas, const Offset(78, 108), const Offset(78, 136), noteStroke(noteSoft));
    noteLine(canvas, const Offset(148, 78), const Offset(148, 136), noteStroke(noteSoft));
    _span(canvas, const Offset(78, 136), const Offset(148, 136), '0.30 m');
  }

  void _swing(Canvas canvas, Size size) {
    final angle = math.sin(progress * math.pi * 2) * 1.05;
    final pivot = const Offset(115, 24);
    final bob = pivot + Offset(math.sin(angle) * 100, math.cos(angle) * 100);
    noteLine(canvas, const Offset(40, 24), const Offset(190, 24));
    noteLine(canvas, pivot, bob);
    noteMass(canvas, bob);
    noteLine(canvas, const Offset(64, 124), const Offset(115, 124), noteStroke(noteSoft));
    _span(canvas, const Offset(64, 24), const Offset(64, 124), '0.20 m', tick: const Offset(-8, 0));
    noteText(canvas, '60°', const Offset(150, 48));
  }

  void _disk(Canvas canvas, Size size) {
    const center = Offset(104, 94);
    const radius = 74.0;
    const holeRadius = radius / 2;
    final hole = center + const Offset(holeRadius, 0);
    const board = Color(0xFFFDAF00);
    canvas.drawCircle(center, radius, noteSolid(board));
    canvas.drawCircle(center, radius, noteStroke(noteInk, 2));
    canvas.drawCircle(hole, holeRadius, noteSolid(const Color(0xFFFFFFFF)));
    canvas.drawCircle(hole, holeRadius, noteStroke(noteInk, 2));
    final leftRim = center + const Offset(-radius, 0);
    _doubleArrow(canvas, leftRim, center);
    noteText(canvas, '10.2 cm', center + const Offset(-holeRadius, 16), size: 11);
    _doubleArrow(canvas, hole, hole + const Offset(holeRadius, 0));
    noteText(canvas, '5.1 cm', hole + const Offset(holeRadius / 2, 16), size: 11);
  }

  void _sheet(Canvas canvas, Size size) {
    final sheet = Path()
      ..moveTo(28, 32)
      ..lineTo(188, 32)
      ..lineTo(188, 92)
      ..lineTo(108, 92)
      ..lineTo(108, 152)
      ..lineTo(28, 152)
      ..close();
    canvas.drawPath(sheet, noteSolid(noteFill));
    canvas.drawPath(sheet, noteStroke());
    canvas.drawCircle(const Offset(72, 112), 3, noteSolid(noteAccent));
    _span(canvas, const Offset(28, 16), const Offset(188, 16), '24 cm');
    _span(canvas, const Offset(40, 32), const Offset(40, 152), '16 cm', tick: const Offset(8, 0));
  }

  void _slide(Canvas canvas, Size size) {
    const left = 72.0;
    const top = 20.0;
    const width = 56.0;
    const floor = 160.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(left, top, width, floor - top),
        const Radius.circular(3),
      ),
      noteStroke(),
    );
    noteLine(canvas, const Offset(24, floor), const Offset(200, floor));
    noteArrow(canvas, const Offset(28, 64), const Offset(left, 64));
    noteLine(canvas, const Offset(128, top), const Offset(156, top), noteStroke(noteSoft));
    noteLine(canvas, const Offset(128, floor), const Offset(156, floor), noteStroke(noteSoft));
    _span(canvas, const Offset(156, top), const Offset(156, floor), 'h', tick: const Offset(12, 0));
    _span(canvas, const Offset(left, 174), Offset(left + width, 174), '6.0 cm');
  }

  void _wood(Canvas canvas, Size size) {
    const stickTop = 16.0;
    const stickBottom = 158.0;
    const stickLeft = 124.0;
    const stickWidth = 14.0;
    const waterY = stickBottom - (stickBottom - stickTop) * 8.0 / 20;
    const tube = Rect.fromLTWH(108, 36, 46, 136);
    canvas.drawRRect(
      RRect.fromRectAndRadius(tube, const Radius.circular(10)),
      noteStroke(noteInk, 2),
    );
    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        tube.deflate(2),
        const Radius.circular(8),
      ),
    );
    canvas.drawRect(
      Rect.fromLTRB(tube.left, waterY, tube.right, tube.bottom),
      noteSolid(const Color(0xFF81D4FA)),
    );
    canvas.restore();
    final stick = RRect.fromRectAndRadius(
      const Rect.fromLTWH(stickLeft, stickTop, stickWidth, stickBottom - stickTop),
      const Radius.circular(2),
    );
    canvas.drawRRect(stick, noteSolid(const Color(0xFFFFE0B2)));
    canvas.drawRRect(stick, noteStroke(const Color(0xFF8D6E63), 1.4));
    noteArrow(canvas, const Offset(78, waterY), Offset(stickLeft - 2, waterY), color: noteInk);
    _span(
      canvas,
      const Offset(64, stickTop),
      const Offset(64, stickBottom),
      '20 cm',
      tick: const Offset(-8, 0),
    );
  }

  void _slideMu(Canvas canvas, Size size) {
    _pulledBlock(canvas, 28 + progress * 52, '0.98 N');
  }

  void _hold(Canvas canvas, Size size) {
    _pulledBlock(canvas, 64, '1.96 N');
  }

  void _pulledBlock(Canvas canvas, double x, String force) {
    const top = 92.0;
    const height = 26.0;
    const width = 40.0;
    noteLine(canvas, const Offset(16, 120), const Offset(214, 120));
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, top, width, height),
        const Radius.circular(3),
      ),
      noteStroke(),
    );
    final midY = top + height / 2;
    final knot = Offset(x + width, midY);
    final center = knot + const Offset(46, 0);
    noteLine(canvas, knot, center - const Offset(16, 0));
    canvas.drawCircle(knot, 2.4, noteSolid(noteInk));
    paintDialMeter(canvas, center, 16, color: noteInk, fraction: 0.46);
    canvas.drawCircle(center + const Offset(22, 0), 4.5, noteStroke());
    noteText(canvas, '400 g', Offset(x + width / 2, top - 16));
    noteText(canvas, force, center + const Offset(0, -28), size: 11);
  }

  void _turn(Canvas canvas, Size size) {
    final angle = progress * math.pi * 2;
    final center = const Offset(115, 100);
    canvas.drawCircle(center, 48, noteStroke());
    canvas.drawCircle(center, 4, noteSolid(noteInk));
    final bob = center + Offset(math.cos(angle) * 48, math.sin(angle) * 48);
    noteSpring(canvas, center, bob, coils: 14, amplitude: 2.8);
    noteMass(canvas, bob, radius: 8);
    _span(canvas, center, center + const Offset(0, -48), '0.20 m', tick: const Offset(12, 0));
    noteText(canvas, '0.628 s', const Offset(176, 168));
  }

  void _lift(Canvas canvas, Size size) {
    final y = 40 - progress * 36;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(60, 40 + y, 110, 120),
        const Radius.circular(6),
      ),
      noteStroke(),
    );
    noteArrow(canvas, Offset(40, 90 + y), Offset(40, 50 + y));
    noteLine(canvas, Offset(115, 46 + y), Offset(115, 58 + y));
    paintDialMeter(canvas, Offset(115, 74 + y), 16, color: noteInk, fraction: 0.62);
    noteLine(canvas, Offset(115, 90 + y), Offset(115, 112 + y));
    noteMass(canvas, Offset(115, 122 + y), radius: 9);
    noteText(canvas, '1.0 m/s^2', const Offset(40, 168), size: 11);
  }

  void _nail(Canvas canvas, Size size) {
    const pivot = Offset(132, 24);
    const length = 112.0;
    const releaseAngle = 0.85;
    final release = pivot +
        Offset(-math.sin(releaseAngle) * length, math.cos(releaseAngle) * length);
    final bottom = pivot + const Offset(0, length);
    final nail = pivot + const Offset(0, 46);
    final rest = length - 46;
    final caught = nail + Offset(math.sin(0.9) * rest, math.cos(0.9) * rest);
    noteLine(canvas, Offset(78, pivot.dy), Offset(200, pivot.dy));
    noteLine(canvas, pivot, release);
    noteMass(canvas, release, radius: 8);
    canvas.drawArc(
      Rect.fromCircle(center: pivot, radius: length),
      math.pi / 2,
      releaseAngle,
      false,
      noteStroke(noteSoft),
    );
    noteLine(canvas, pivot, nail, noteStroke(noteSoft));
    canvas.drawCircle(nail, 3.5, noteSolid(noteInk));
    noteLine(canvas, nail, caught, noteStroke(noteAccent));
    noteMass(canvas, caught, radius: 8);
    _doubleArrow(canvas, Offset(18, release.dy), Offset(18, bottom.dy));
    noteText(canvas, '12 cm', Offset(40, (release.dy + bottom.dy) / 2), size: 11);
  }

  void _dip(Canvas canvas, Size size) {
    final y = 78 + progress * 62;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(70, 78, 100, 96),
        const Radius.circular(4),
      ),
      noteStroke(),
    );
    canvas.drawRect(
      const Rect.fromLTWH(72, 112, 96, 60),
      noteSolid(const Color(0xFFBBDEFB)),
    );
    noteLine(canvas, const Offset(100, 8), const Offset(130, 8));
    noteLine(canvas, const Offset(115, 8), const Offset(115, 14));
    paintDialMeter(canvas, const Offset(115, 30), 16, color: noteInk);
    noteLine(canvas, const Offset(115, 46), Offset(115, y - 12));
    noteMass(canvas, Offset(115, y), radius: 10);
    noteText(canvas, '40 cm^3', const Offset(42, 48), size: 11);
  }

  void _tension(Canvas canvas, Size size) {
    // 60° から放すので、糸に沿った張力は T = mg (3 cosθ − 1)。
    const release = math.pi / 3;
    final angle = math.sin(progress * math.pi * 2) * release;
    final pivot = const Offset(115, 22);
    const length = 96.0;
    final bob = pivot + Offset(math.sin(angle) * length, math.cos(angle) * length);
    noteLine(canvas, const Offset(40, 22), const Offset(190, 22));
    noteLine(canvas, pivot, bob);
    noteMass(canvas, bob);
    // おもりから支点向きが張力。長さは最下点 T = 2mg を 36 px にする。
    final toPivot = (pivot - bob) / length;
    final tensionOverMg = 3 * math.cos(angle) - 1;
    if (tensionOverMg > 0.05) {
      final tip = bob + toPivot * (18 * tensionOverMg);
      noteArrow(canvas, bob, tip);
      noteText(
        canvas,
        'T',
        bob + toPivot * (9 * tensionOverMg) + Offset(-toPivot.dy, toPivot.dx) * 12,
        size: 11,
      );
    }
    noteText(canvas, '60°', const Offset(180, 48));
  }

  void _stairs(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(30, 140)
      ..lineTo(100, 140)
      ..lineTo(100, 70)
      ..lineTo(180, 70);
    canvas.drawPath(path, noteStroke());
    _span(canvas, const Offset(118, 70), const Offset(118, 140), '5.0 m', tick: const Offset(10, 0));
    paintPressureGauge(canvas, const Offset(58, 118), radius: 12);
    paintPressureGauge(canvas, const Offset(148, 48), radius: 12);
  }

  void _fuji(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(108, 156)
      ..lineTo(158, 26)
      ..lineTo(214, 156);
    canvas.drawPath(path, noteStroke());
    noteLine(canvas, const Offset(22, 26), const Offset(158, 26), noteStroke(noteSoft));
    noteLine(canvas, const Offset(22, 156), const Offset(108, 156), noteStroke(noteSoft));
    _span(canvas, const Offset(22, 26), const Offset(22, 156), '3000 m', tick: const Offset(8, 0));
    noteText(canvas, '1013 hPa', const Offset(164, 174), size: 11);
    paintPressureGauge(canvas, const Offset(186, 26), radius: 12);
  }

  void _syringe(Canvas canvas, Size size) {
    final pull = progress * 10;
    const cx = 108.0;
    const half = 20.0;
    const barrelTop = 48.0;
    const barrelBottom = 150.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(cx - 30, barrelTop - 8, cx + 30, barrelTop + 6),
        const Radius.circular(2),
      ),
      noteStroke(noteInk, 2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(cx - half, barrelTop, cx + half, barrelBottom),
        const Radius.circular(3),
      ),
      noteStroke(noteInk, 2),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTRB(cx - 6, barrelBottom, cx + 6, barrelBottom + 14),
        const Radius.circular(2),
      ),
      noteStroke(noteInk, 2),
    );
    final piston = barrelTop + 18 - pull;
    canvas.drawRect(
      Rect.fromLTRB(cx - half + 3, piston, cx + half - 3, piston + 8),
      noteSolid(noteFill),
    );
    canvas.drawRect(
      Rect.fromLTRB(cx - half + 3, piston, cx + half - 3, piston + 8),
      noteStroke(noteAccent),
    );
    noteLine(canvas, Offset(cx, piston), Offset(cx, 18));
    noteArrow(canvas, Offset(cx + 16, 30), Offset(cx + 16, 12));
    const mark = 112.0;
    _doubleArrow(canvas, const Offset(cx - half, mark), const Offset(cx + half, mark));
    noteText(canvas, '直径 2.0 cm', const Offset(178, 78), size: 11);
  }

  void _depth(Canvas canvas, Size size) {
    const left = 78.0;
    const right = 196.0;
    const top = 22.0;
    const bottom = 170.0;
    const surface = 52.0;
    const depthY = 140.0;
    const radius = 6.0;
    final wall = Path()
      ..moveTo(left, top)
      ..lineTo(left, bottom - radius)
      ..quadraticBezierTo(left, bottom, left + radius, bottom)
      ..lineTo(right - radius, bottom)
      ..quadraticBezierTo(right, bottom, right, bottom - radius)
      ..lineTo(right, top);
    canvas.save();
    canvas.clipPath(wall);
    canvas.drawRect(
      const Rect.fromLTRB(left, surface, right, bottom),
      noteSolid(const Color(0xFF81D4FA)),
    );
    canvas.restore();
    canvas.drawPath(wall, noteStroke(noteInk, 2));
    noteLine(canvas, const Offset(left - 8, top), const Offset(left, top), noteStroke(noteInk, 2));
    noteLine(canvas, const Offset(right, top), const Offset(right + 8, top), noteStroke(noteInk, 2));
    noteLine(
      canvas,
      const Offset(left, surface),
      const Offset(right, surface),
      noteStroke(const Color(0xFF4FC3F7), 1.4),
    );
    const gauge = Offset(148, depthY);
    noteLine(
      canvas,
      const Offset(22, depthY),
      Offset(gauge.dx - 14, depthY),
      noteStroke(noteSoft),
    );
    paintPressureGauge(canvas, gauge, radius: 12);
    noteLine(canvas, const Offset(22, surface), const Offset(left, surface), noteStroke(noteSoft));
    _span(canvas, const Offset(22, surface), const Offset(22, depthY), '30 cm', tick: const Offset(8, 0));
    noteText(canvas, '1013 hPa', const Offset(137, 36), size: 11);
  }

  void _invert(Canvas canvas, Size size) {
    const water = Color(0xFFBBDEFB);
    const basinLeft = 16.0;
    const basinRight = 214.0;
    const openY = 128.0;
    const mouthY = 150.0;
    const innerY = 68.0;
    const tubeLeft = 86.0;
    const tubeRight = 160.0;
    const tubeTop = 8.0;
    const basinBottom = 178.0;
    final basin = Path()
      ..moveTo(basinLeft, openY)
      ..lineTo(basinLeft, basinBottom - 6)
      ..quadraticBezierTo(basinLeft, basinBottom, basinLeft + 6, basinBottom)
      ..lineTo(basinRight - 6, basinBottom)
      ..quadraticBezierTo(basinRight, basinBottom, basinRight, basinBottom - 6)
      ..lineTo(basinRight, openY);
    canvas.save();
    canvas.clipPath(basin);
    canvas.drawRect(
      const Rect.fromLTRB(basinLeft, openY, basinRight, basinBottom),
      noteSolid(water),
    );
    canvas.restore();
    canvas.drawPath(basin, noteStroke());
    noteLine(canvas, const Offset(basinLeft - 8, openY), const Offset(basinLeft, openY));
    noteLine(canvas, const Offset(basinRight, openY), const Offset(basinRight + 8, openY));
    canvas.drawRect(
      const Rect.fromLTRB(tubeLeft + 1, tubeTop, tubeRight - 1, mouthY),
      noteSolid(const Color(0xFFFFFFFF)),
    );
    canvas.drawRect(
      const Rect.fromLTRB(tubeLeft + 1, innerY, tubeRight - 1, mouthY),
      noteSolid(water),
    );
    noteLine(canvas, const Offset(tubeLeft, tubeTop), const Offset(tubeRight, tubeTop));
    noteLine(canvas, const Offset(tubeLeft, tubeTop), const Offset(tubeLeft, mouthY));
    noteLine(canvas, const Offset(tubeRight, tubeTop), const Offset(tubeRight, mouthY));
    noteLine(
      canvas,
      const Offset(tubeLeft, innerY),
      const Offset(tubeRight, innerY),
      noteStroke(noteAccent),
    );
    noteLine(canvas, const Offset(62, innerY), const Offset(tubeLeft, innerY), noteStroke(noteSoft));
    noteLine(canvas, const Offset(62, mouthY), const Offset(tubeLeft, mouthY), noteStroke(noteSoft));
    noteLine(canvas, const Offset(tubeRight, mouthY), const Offset(184, mouthY), noteStroke(noteSoft));
    _span(canvas, const Offset(62, innerY), const Offset(62, mouthY), '28 cm', tick: const Offset(-10, 0));
    _span(canvas, const Offset(184, openY), const Offset(184, mouthY), '3 cm', tick: const Offset(10, 0));
    paintPressureGauge(canvas, const Offset(123, 34), radius: 11);
    noteText(canvas, '1013 hPa', const Offset(186, 108), size: 11);
  }

  void _salt(Canvas canvas, Size size) {
    const left = 86.0;
    const right = 206.0;
    const top = 36.0;
    const bottom = 170.0;
    const surface = 72.0;
    final wall = Path()
      ..moveTo(left, top)
      ..lineTo(left, bottom - 6)
      ..quadraticBezierTo(left, bottom, left + 6, bottom)
      ..lineTo(right - 6, bottom)
      ..quadraticBezierTo(right, bottom, right, bottom - 6)
      ..lineTo(right, top);
    canvas.save();
    canvas.clipPath(wall);
    canvas.drawRect(
      const Rect.fromLTRB(left, surface, right, bottom),
      noteSolid(const Color(0xFFB3E5FC)),
    );
    canvas.restore();
    canvas.drawPath(wall, noteStroke());
    noteLine(canvas, const Offset(left - 12, top), const Offset(left, top));
    noteLine(canvas, const Offset(right, top), const Offset(right + 12, top));
    noteLine(
      canvas,
      const Offset(left, surface),
      const Offset(right, surface),
      noteStroke(const Color(0xFF4FC3F7), 1.4),
    );
    const gauge = Offset(168, 156);
    noteLine(canvas, const Offset(146, 156), Offset(gauge.dx - 13, gauge.dy), noteStroke(noteSoft));
    paintPressureGauge(canvas, gauge, radius: 12);
    noteLine(canvas, const Offset(24, surface), const Offset(left, surface), noteStroke(noteSoft));
    noteLine(canvas, const Offset(24, 156), const Offset(146, 156), noteStroke(noteSoft));
    _span(canvas, const Offset(24, surface), const Offset(24, 156), '50 cm', tick: const Offset(8, 0));
    noteText(canvas, '1.20 g/cm^3', const Offset(146, 16), size: 11);
    noteText(canvas, '1013 hPa', const Offset(146, 52), size: 11);
  }

  void _helium(Canvas canvas, Size size) {
    final leftHandle = Path()
      ..moveTo(86, 50)
      ..quadraticBezierTo(78, 10, 108, 28)
      ..quadraticBezierTo(114, 34, 108, 50);
    final rightHandle = Path()
      ..moveTo(122, 50)
      ..quadraticBezierTo(116, 34, 122, 28)
      ..quadraticBezierTo(152, 10, 144, 50);
    canvas.drawPath(leftHandle, noteStroke(noteAccent, 1.8));
    canvas.drawPath(rightHandle, noteStroke(noteAccent, 1.8));

    final bag = Path()
      ..moveTo(74, 50)
      ..quadraticBezierTo(58, 96, 68, 136)
      ..quadraticBezierTo(115, 158, 162, 136)
      ..quadraticBezierTo(172, 96, 156, 50)
      ..close();
    canvas.drawPath(bag, noteSolid(const Color(0xFFE3F2FD)));
    canvas.drawPath(bag, noteStroke(noteAccent, 1.8));
    noteLine(
      canvas,
      const Offset(74, 50),
      const Offset(156, 50),
      noteStroke(noteAccent, 1.8),
    );

    noteText(canvas, 'He', const Offset(115, 96), size: 20);
    noteText(canvas, '2.493 L', const Offset(115, 174));
    noteText(canvas, '1.0 g', const Offset(196, 96));
  }

  void _wire(Canvas canvas, Size size) {
    _roundWire(canvas, length: '0.785 m', diameter: '0.50 mm');
  }

  void _copper(Canvas canvas, Size size) {
    _roundWire(
      canvas,
      length: '10 m',
      diameter: '1.0×10⁻⁸ m²',
      extra: '50°C',
    );
  }

  /// 丸い切り口が端についている一本の線。切り口は別の物体にしない。
  void _roundWire(
    Canvas canvas, {
    required String length,
    required String diameter,
    String? extra,
  }) {
    const cx = 92.0;
    const far = 236.0;
    const cy = 100.0;
    const rx = 16.0;
    const ry = 28.0;
    const tip = 10.0;
    final end = Rect.fromCenter(
      center: const Offset(cx, cy),
      width: rx * 2,
      height: ry * 2,
    );
    final farRim = Rect.fromCenter(
      center: const Offset(far, cy),
      width: tip * 2,
      height: ry * 2,
    );
    final body = Path()
      ..moveTo(cx, cy - ry)
      ..lineTo(far, cy - ry)
      ..arcTo(farRim, -math.pi / 2, math.pi, false)
      ..lineTo(cx, cy + ry)
      ..close();
    canvas.drawPath(body, noteSolid(noteFill));
    canvas.drawOval(end, noteSolid(const Color(0xFFCFD8DC)));
    final outline = Path()
      ..moveTo(cx, cy - ry)
      ..lineTo(far, cy - ry)
      ..arcTo(farRim, -math.pi / 2, math.pi, false)
      ..lineTo(cx, cy + ry);
    canvas.drawPath(outline, noteStroke(noteAccent, 2.0));
    canvas.drawOval(end, noteStroke(noteAccent, 2.0));
    noteLine(
      canvas,
      Offset(cx + rx + 2, cy - ry * 0.42),
      Offset(far - 2, cy - ry * 0.42),
      noteStroke(const Color(0xFFFFFFFF), 2.4),
    );

    _span(canvas, const Offset(cx - rx, 32), const Offset(far + tip, 32), length);
    final markX = cx - rx - 20;
    _doubleArrow(canvas, Offset(markX, cy - ry), Offset(markX, cy + ry));
    noteText(canvas, diameter, Offset(markX + 8, cy + ry + 22), size: 14);
    if (extra != null) {
      noteText(canvas, extra, Offset(far - 4, cy + ry + 34), size: 14);
    }
  }

  void _loop(Canvas canvas, Size size) {
    // 斜めから見た多巻き円形コイル。奥から手前へ少しずらしてぐるぐる感を出す。
    const center = Offset(108, 108);
    const turns = 7;
    const width = 150.0;
    const height = 78.0;
    const step = Offset(3.2, -2.4);
    final start = center - step * ((turns - 1) / 2);
    for (var i = 0; i < turns; i++) {
      final c = start + step * i.toDouble();
      canvas.drawOval(
        Rect.fromCenter(center: c, width: width, height: height),
        noteStroke(i == turns - 1 ? noteInk : noteSoft, i == turns - 1 ? 1.8 : 1.3),
      );
    }
    final front = start + step * (turns - 1);
    noteArrow(
      canvas,
      front + const Offset(0, height * 0.28),
      front - const Offset(0, height * 0.28),
    );
    _span(
      canvas,
      front,
      front + const Offset(width / 2, 0),
      '6.28 cm',
    );
    noteText(canvas, '100', const Offset(196, 36));
    noteText(canvas, '1.0 A', const Offset(196, 168));
  }

  void _rc(Canvas canvas, Size size) {
    noteLine(canvas, const Offset(36, 150), const Offset(200, 150));
    noteLine(canvas, const Offset(36, 150), const Offset(36, 28));
    final path = Path();
    for (var i = 0; i <= 40; i++) {
      final x = 36.0 + i * 4;
      final y = 150 - 110 * math.exp(-i / 14);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    canvas.drawPath(path, noteStroke(noteAccent));
    final mark = progress;
    final x = 36 + mark * 120;
    final y = 150 - 110 * math.exp(-(x - 36) / 56);
    canvas.drawCircle(Offset(x, y), 4, noteSolid(noteInk));
    noteLine(canvas, const Offset(36, 95), const Offset(70, 95), noteStroke(noteSoft));
    noteText(canvas, 'V/2', const Offset(24, 95), size: 11);
  }

  void _coil(Canvas canvas, Size size) {
    // 横から見たソレノイド。筒の周りに密な巻き、下に回路。
    const cy = 96.0;
    const faceRx = 12.0;
    const faceRy = 24.0;
    const tubeLeft = 56.0;
    const tubeRight = 216.0;
    const turns = 20;
    const windR = 26.0;
    final soft = noteStroke(noteSoft, 1.3);
    final wire = noteStroke(noteInk, 1.45);

    // 筒（左端面・上下・右端面）
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(tubeLeft, cy),
        width: faceRx * 2,
        height: faceRy * 2,
      ),
      soft,
    );
    noteLine(
      canvas,
      const Offset(tubeLeft, cy - faceRy),
      const Offset(tubeRight, cy - faceRy),
      soft,
    );
    noteLine(
      canvas,
      const Offset(tubeLeft, cy + faceRy),
      const Offset(tubeRight, cy + faceRy),
      soft,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: const Offset(tubeRight, cy),
        width: faceRx * 2,
        height: faceRy * 2,
      ),
      soft,
    );

    // 巻き線
    final firstX = tubeLeft + 8.0;
    final lastX = tubeRight - 8.0;
    final pitch = (lastX - firstX) / (turns - 1);
    for (var i = 0; i < turns; i++) {
      final x = firstX + i * pitch;
      canvas.drawCircle(Offset(x, cy), windR, wire);
    }

    // 正面の電流向き（上向き）
    for (var i = 1; i < turns - 1; i += 2) {
      final x = firstX + i * pitch;
      noteArrow(
        canvas,
        Offset(x, cy + windR * 0.42),
        Offset(x, cy - windR * 0.42),
      );
    }

    // 引き出し線と下の回路
    const leadY = 178.0;
    noteLine(canvas, Offset(firstX, cy + windR), Offset(firstX, leadY), wire);
    noteLine(canvas, Offset(lastX, cy + windR), Offset(lastX, leadY), wire);
    noteLine(canvas, Offset(firstX, leadY), Offset(lastX, leadY), wire);
    noteArrow(
      canvas,
      Offset(lastX, leadY - 2),
      Offset(lastX, cy + windR + 16),
    );
    noteArrow(
      canvas,
      Offset(firstX, cy + windR + 16),
      Offset(firstX, leadY - 2),
    );
    noteText(canvas, '電流 I', Offset(lastX + 30, cy + windR + 34), size: 11);

    // 長さは今までどおり寸法線
    _span(
      canvas,
      const Offset(tubeLeft, cy - faceRy - 24),
      const Offset(tubeRight, cy - faceRy - 24),
      '0.314 m',
    );

    // 左端面の半径
    _doubleArrow(
      canvas,
      const Offset(tubeLeft, cy),
      const Offset(tubeLeft, cy - faceRy),
    );
    noteText(
      canvas,
      'r',
      const Offset(tubeLeft - 14, cy - faceRy * 0.5),
      size: 12,
    );

    // 透磁率
    noteText(canvas, 'μ₀', const Offset(24, cy), size: 13);
    noteArrow(
      canvas,
      const Offset(34, cy),
      Offset(tubeLeft - faceRx - 2, cy),
      color: noteInk,
    );

    noteText(
      canvas,
      '100 巻き',
      Offset((firstX + lastX) / 2, leadY + 18),
      size: 11,
    );
  }

  void _bar(Canvas canvas, Size size) {
    const left = 96.0;
    const right = 214.0;
    const top = 32.0;
    const bottom = 128.0;
    const barX = 162.0;
    const mid = (top + bottom) / 2;
    final wire = noteStroke();

    noteLine(canvas, const Offset(left, top), const Offset(right, top), wire);
    noteLine(canvas, const Offset(left, bottom), const Offset(right, bottom), wire);
    noteLine(canvas, const Offset(left, top), const Offset(left, bottom), wire);

    canvas.drawRect(
      const Rect.fromLTRB(left - 10, 58, left + 10, 96),
      noteSolid(const Color(0xFFFFFFFF)),
    );
    canvas.drawRect(const Rect.fromLTRB(left - 10, 58, left + 10, 96), wire);

    canvas.drawRect(
      const Rect.fromLTRB(118, bottom - 16, 136, bottom + 16),
      noteSolid(const Color(0xFFFFFFFF)),
    );
    noteLine(canvas, const Offset(122, bottom - 13), const Offset(122, bottom + 13), wire);
    noteLine(
      canvas,
      const Offset(132, bottom - 7),
      const Offset(132, bottom + 7),
      noteStroke(noteInk, 2.6),
    );

    final bar = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: const Offset(barX, mid),
        width: 14,
        height: bottom - top,
      ),
      const Radius.circular(2),
    );
    canvas.drawRRect(bar, noteSolid(noteFill));
    canvas.drawRRect(bar, noteStroke(noteInk, 1.8));
    noteArrow(canvas, const Offset(barX, bottom - 16), const Offset(barX, top + 16));
    noteText(canvas, '1.0 A', const Offset(barX - 26, mid));

    const field = Offset(192, 58);
    canvas.drawCircle(field, 8, wire);
    canvas.drawCircle(field, 2.2, noteSolid(noteInk));
    noteText(canvas, '0.20 T', const Offset(192, 80));

    noteLine(canvas, const Offset(28, top), const Offset(left, top), noteStroke(noteSoft));
    noteLine(canvas, const Offset(28, bottom), const Offset(left, bottom), noteStroke(noteSoft));
    _span(
      canvas,
      const Offset(28, top),
      const Offset(28, bottom),
      '2.0 cm',
      tick: const Offset(8, 0),
    );
    noteArrow(
      canvas,
      const Offset(barX + 12, 112),
      const Offset(right - 8, 112),
      color: noteInk,
    );
  }

  void _cube(Canvas canvas, Size size) {
    final front = Path()
      ..moveTo(50, 70)
      ..lineTo(140, 70)
      ..lineTo(140, 150)
      ..lineTo(50, 150)
      ..close();
    canvas.drawPath(front, noteStroke());
    noteLine(canvas, const Offset(50, 70), const Offset(90, 36));
    noteLine(canvas, const Offset(140, 70), const Offset(180, 36));
    noteLine(canvas, const Offset(140, 150), const Offset(180, 116));
    noteLine(canvas, const Offset(90, 36), const Offset(180, 36));
    noteLine(canvas, const Offset(180, 36), const Offset(180, 116));
    _span(canvas, const Offset(50, 168), const Offset(140, 168), '3.0 cm');
  }
}
