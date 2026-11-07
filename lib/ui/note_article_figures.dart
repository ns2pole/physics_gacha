import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/physics_problem.dart';
import '../utils/figure_clock.dart';
import '../utils/figure_labels.dart';
import 'dial_meter.dart';
import 'note_stage.dart';
import 'span_marker.dart';

Widget noteArticleFigure(ProblemFigure figure) {
  return switch (figure) {
    ProblemFigure.dopplerWall => const _Fig(
      _Kind.doppler,
      animate: true,
      width: 260,
    ),
    ProblemFigure.singleSlit => const _Fig(_Kind.slit, width: 260, height: 220),
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
    ProblemFigure.twoSpeakers => const _Fig(
      _Kind.speakers,
      width: 250,
      height: 200,
    ),
    ProblemFigure.soundSpeedColumn => const _Fig(
      _Kind.column,
      width: 280,
      height: 220,
    ),
    ProblemFigure.verticalSpringRelease => const _Fig(
      _Kind.vSpring,
      animate: true,
      height: 220,
    ),
    ProblemFigure.tensionCart => const _Fig(
      _Kind.cart,
      animate: true,
      width: 270,
      height: 210,
    ),
    ProblemFigure.horizontalSpringRelease => const _Fig(
      _Kind.hSpring,
      animate: true,
      height: 210,
      width: 280,
    ),
    ProblemFigure.pendulumBottomSpeed => const _Fig(
      _Kind.swing,
      animate: true,
      duration: Duration(milliseconds: 4800),
    ),
    ProblemFigure.blockEndLift => const _Fig(_Kind.endLift, height: 210),
    ProblemFigure.diskHoleCenter => const _Fig(_Kind.disk, height: 210),
    ProblemFigure.cutSheetCenter => const _Fig(_Kind.sheet, width: 260),
    ProblemFigure.cutSheetExplain =>
        const _Fig(_Kind.sheetExplain, width: 260, height: 320),
    ProblemFigure.slideTipHeight => const _Fig(_Kind.slide, height: 220),
    ProblemFigure.floatingWood => const _Fig(_Kind.wood),
    ProblemFigure.kineticFrictionSlide => const _Fig(
      _Kind.slideMu,
      animate: true,
      scale: 1.25,
    ),
    ProblemFigure.staticFrictionHold => const _Fig(_Kind.hold, scale: 1.25),
    ProblemFigure.turntableSpring => const _Fig(_Kind.turn, animate: true),
    ProblemFigure.elevatorScale => const _Fig(
      _Kind.lift,
      animate: true,
      scale: 1.2,
      height: 300,
    ),
    ProblemFigure.nailPendulum => const _Fig(_Kind.nail, animate: true),
    ProblemFigure.underwaterScale => const _Fig(
      _Kind.dip,
      animate: true,
      height: 220,
      width: 260,
      // 約1.5 s で沈め、約3 s 止めてからループ。
      duration: Duration(milliseconds: 4500),
    ),
    ProblemFigure.pendulumBottomTension =>
      const _Fig(_Kind.tension, animate: true),
    ProblemFigure.stairPressure => const _Fig(_Kind.stairs, scale: 1.5),
    ProblemFigure.fujiPressure => const _Fig(_Kind.fuji, width: 280),
    ProblemFigure.syringePiston => const _Fig(
      _Kind.syringe,
      animate: true,
      scale: 1.5,
      duration: Duration(milliseconds: 4500),
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
    ProblemFigure.currentLoop => const _Fig(
      _Kind.loop,
      height: 220,
      width: 260,
    ),
    ProblemFigure.rcDecay => const _Fig(_Kind.rc, width: 280, height: 210),
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
  sheetExplain,
  slide,
  endLift,
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
    final labels = FigureLabels.of(context);
    return NoteStage(
      animate: animate,
      duration: duration,
      height: height * scale,
      width: width * scale,
      painter: (progress) =>
          _Paint(kind, progress, labels: labels, scale: scale),
    );
  }
}

class _Paint extends NotePainter {
  const _Paint(
    this.kind,
    super.progress, {
    required this.labels,
    this.scale = 1,
  });

  final _Kind kind;
  final FigureLabels labels;
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
      case _Kind.sheetExplain:
        _sheetExplain(canvas, size);
      case _Kind.slide:
        _slide(canvas, size);
      case _Kind.endLift:
        _endLift(canvas, size);
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
      oldDelegate.scale != scale ||
      oldDelegate.labels.naturalLength != labels.naturalLength;

  void _span(
    Canvas canvas,
    Offset from,
    Offset to,
    String label, {
    Offset tick = Offset.zero,
    double guide = 18,
  }) {
    paintSpanMarker(
      canvas: canvas,
      from: from,
      to: to,
      label: label,
      color: noteInk,
      tick: tick,
      guide: guide,
    );
  }

  void _doubleArrow(Canvas canvas, Offset from, Offset to, {double guide = 18}) {
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
    if (guide > 0) {
      paintDashedGuide(
        canvas: canvas,
        from: from - across * guide,
        to: from + across * guide,
        color: noteInk,
      );
      paintDashedGuide(
        canvas: canvas,
        from: to - across * guide,
        to: to + across * guide,
        color: noteInk,
      );
    }
  }

  void _doppler(Canvas canvas, Size size) {
    // 静止音源 3405 Hz、遠ざかる壁、反射音 3395 Hz、音速 340 m/s。
    final wallX = 168 + 28 * progress;
    noteLine(canvas, const Offset(16, 160), const Offset(250, 160));
    const source = Offset(48, 108);
    noteMass(canvas, source, radius: 12);
    noteText(canvas, '3405 Hz', const Offset(48, 48));
    noteText(canvas, '340 m/s', const Offset(130, 28));
    final wall = RRect.fromRectAndRadius(
      Rect.fromLTWH(wallX, 48, 12, 110),
      const Radius.circular(2),
    );
    canvas.drawRRect(wall, noteSolid(const Color(0xFFFFE0B2)));
    canvas.drawRRect(wall, noteStroke());
    noteArrow(canvas, Offset(wallX + 22, 72), Offset(wallX + 48, 72));
    noteText(canvas, '3395 Hz', Offset(wallX + 6, 184));
    for (var i = 1; i <= 3; i++) {
      canvas.drawArc(
        Rect.fromCircle(center: source, radius: 20.0 + i * 18),
        -0.55,
        1.1,
        false,
        noteStroke(noteSoft, 1.2),
      );
    }
  }

  void _slit(Canvas canvas, Size size) {
    // スリット幅 0.10 mm、スクリーンまで 0.50 m。暗線位置は答えなので寸法値は置かない。
    const slitX = 96.0;
    const screenX = 236.0;
    const axisY = 112.0;
    const slitTop = 94.0;
    const slitBottom = 130.0;
    const darkY = 76.0;
    noteLine(canvas, const Offset(slitX, 28), const Offset(slitX, slitTop));
    noteLine(canvas, const Offset(slitX, slitBottom), const Offset(slitX, 176));
    noteLine(canvas, const Offset(screenX, 24), const Offset(screenX, 180));
    noteLine(
      canvas,
      const Offset(slitX, axisY),
      const Offset(screenX, axisY),
      noteStroke(noteSoft),
    );
    noteLine(
      canvas,
      const Offset(slitX, axisY),
      const Offset(screenX, darkY),
      noteStroke(noteAccent),
    );
    canvas.drawCircle(const Offset(screenX, darkY), 4, noteSolid(noteInk));
    // θ は軸と暗線への光線のあいだ。弧は実角に合わせる。
    final theta = math.atan2(darkY - axisY, screenX - slitX);
    canvas.drawArc(
      Rect.fromCircle(center: const Offset(slitX, axisY), radius: 34),
      theta,
      -theta,
      false,
      noteStroke(noteSoft, 1.2),
    );
    noteText(
      canvas,
      'θ',
      Offset(slitX + 44, axisY + (darkY - axisY) * 0.28),
    );
    // 0.10 mm は寸法線の左（光線帯に入れない）。
    _span(
      canvas,
      const Offset(78, slitTop),
      const Offset(78, slitBottom),
      '0.10 mm',
      tick: const Offset(-10, 0),
      guide: 10,
    );
    _span(
      canvas,
      const Offset(slitX, 204),
      const Offset(screenX, 204),
      '0.50 m',
    );
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
    // 定滑車を少し大きく、おもりを少し小さくして、台との被りを避ける。
    const pulleyR = 13.0;
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
    canvas.drawCircle(pulley, 2.2, noteSolid(noteInk));

    final path = Path()..moveTo(stringLeft, stringY);
    const segments = 20;
    for (var i = 1; i <= segments; i++) {
      final t = i / segments;
      final x = stringLeft + (pulley.dx - stringLeft) * t;
      final y = stringY + math.sin(t * math.pi) * 8 * wave;
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
    const massH = 18.0;
    const massW = 18.0;
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
          width: massW,
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
    // 斜め上から見た円軌道。鉛直との角 60° を点線で示す。
    const pivot = Offset(115, 28);
    const orbit = Offset(115, 150);
    const rx = 54.0;
    const ry = 9.0;
    final soft = noteStroke(noteSoft, 1.3);
    final angle = progress * math.pi * 2;
    final bob = Offset(
      orbit.dx + rx * math.cos(angle),
      orbit.dy + ry * math.sin(angle),
    );
    final along = bob - pivot;
    final normal = Offset(-along.dy, along.dx) / along.distance * 14;
    final tangent = Offset(-rx * math.sin(angle), ry * math.cos(angle));
    final tangentDir = tangent / tangent.distance;

    noteLine(canvas, const Offset(40, 28), const Offset(190, 28));
    // 水平な円軌道は点線のみ（塗りなし）。
    _dashedOval(
      canvas,
      Rect.fromCenter(center: orbit, width: rx * 2, height: ry * 2),
      soft,
    );
    // 鉛直の点線と、糸とのあいだの 60°。
    _dashedLine(canvas, pivot, orbit, soft);
    const arcR = 28.0;
    const aVertical = math.pi / 2;
    final aString = math.atan2(bob.dy - pivot.dy, bob.dx - pivot.dx);
    var sweep = aString - aVertical;
    while (sweep > math.pi) {
      sweep -= 2 * math.pi;
    }
    while (sweep < -math.pi) {
      sweep += 2 * math.pi;
    }
    canvas.drawArc(
      Rect.fromCircle(center: pivot, radius: arcR),
      aVertical,
      sweep,
      false,
      soft,
    );
    final mid = aVertical + sweep / 2;
    noteText(
      canvas,
      '60°',
      pivot + Offset(math.cos(mid) * (arcR + 24), math.sin(mid) * (arcR + 14)),
    );
    noteLine(canvas, pivot, bob);
    noteMass(canvas, bob);
    noteArrow(
      canvas,
      bob + tangentDir * 14,
      bob + tangentDir * 32,
      color: noteInk,
    );
    _span(canvas, pivot + normal, bob + normal, '2.0 m');
  }

  void _speakers(Canvas canvas, Size size) {
    // 点までの距離が 120 : 150 = 2.0 : 2.5 になる位置。
    // 寸法線は経路の全長に平行に置く（途中の短い区間を測らない）。
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
    _span(canvas, Offset(near.dx, 26), Offset(ear.dx, 26), '2.0 m');
    final farDelta = ear - far;
    final farLen = farDelta.distance;
    final across = Offset(-farDelta.dy, farDelta.dx) / farLen * 22;
    _span(canvas, far + across, ear + across, '2.5 m');
  }

  Offset _rim(Offset from, Offset to, double radius) {
    final delta = to - from;
    return to - delta / delta.distance * radius;
  }

  void _column(Canvas canvas, Size size) {
    // 左 空気 10℃・16.0 cm、右 空気 40℃・16.9 cm。水面〜開口（腹）。
    void tube({
      required double x,
      required double waterFromTop,
      required String length,
      required String temp,
      required Color water,
      required bool labelLeft,
    }) {
      const top = 36.0;
      const bottom = 176.0;
      const w = 36.0;
      final waterY = top + waterFromTop;
      noteLine(canvas, Offset(x, top), Offset(x, bottom));
      noteLine(canvas, Offset(x + w, top), Offset(x + w, bottom));
      noteLine(canvas, Offset(x, bottom), Offset(x + w, bottom));
      canvas.drawRect(
        Rect.fromLTRB(x + 1, waterY, x + w - 1, bottom),
        noteSolid(water),
      );
      noteLine(
        canvas,
        Offset(x - 6, top),
        Offset(x + w + 6, top),
        noteStroke(noteSoft),
      );
      noteLine(
        canvas,
        Offset(x - 6, waterY),
        Offset(x + w + 6, waterY),
        noteStroke(noteAccent),
      );
      final spanX = labelLeft ? x - 22 : x + w + 22;
      _span(
        canvas,
        Offset(spanX, top),
        Offset(spanX, waterY),
        length,
        tick: Offset(labelLeft ? -10 : 10, 0),
        guide: 12,
      );
      noteText(canvas, temp, Offset(x + w / 2, 22));
    }

    noteText(canvas, '500 Hz', const Offset(140, 208));
    tube(
      x: 48,
      waterFromTop: 88,
      length: '16.0 cm',
      temp: labels.airTemp('10℃'),
      water: const Color(0xFFBBDEFB),
      labelLeft: true,
    );
    tube(
      x: 168,
      waterFromTop: 96,
      length: '16.9 cm',
      temp: labels.airTemp('40℃'),
      water: const Color(0xFFFFCDD2),
      labelLeft: false,
    );
  }

  void _vSpring(Canvas canvas, Size size) {
    // 自然長から 0.20 m 引き下げて放す。おもり 100 g。
    // 自然長は折り返しにしない（通過時に速さがある）。少し上まで行き、戻る。
    const naturalY = 100.0;
    const pull = 48.0; // 図上の 0.20 m
    const overshoot = 28.0;
    final mid = naturalY + (pull - overshoot) / 2;
    final amp = (pull + overshoot) / 2;
    final y = mid + amp * math.cos(progress * math.pi * 2);
    noteLine(canvas, const Offset(70, 16), const Offset(160, 16));
    noteSpring(canvas, const Offset(115, 16), Offset(115, y - 12));
    noteMass(canvas, Offset(115, y));
    noteText(canvas, '100 g', Offset(115 + 40, y + 2));
    paintDashedGuide(
      canvas: canvas,
      from: const Offset(150, naturalY),
      to: const Offset(190, naturalY),
      color: noteInk,
    );
    paintDashedGuide(
      canvas: canvas,
      from: Offset(150, naturalY + pull),
      to: Offset(190, naturalY + pull),
      color: noteInk,
    );
    noteText(canvas, labels.naturalLength, const Offset(168, naturalY - 14));
    _span(
      canvas,
      const Offset(196, naturalY),
      Offset(196, naturalY + pull),
      '0.20 m',
      tick: const Offset(10, 0),
      guide: 0,
    );
  }

  void _cart(Canvas canvas, Size size) {
    // No.50 と同じ：定滑車は台の右上隅、糸は上面の接線で物体の右側面中央へ。
    const tableLeft = 24.0;
    const tableTop = 90.0;
    const tableRight = 168.0;
    const tableBottom = 156.0;
    const pulleyR = 13.0;
    const pulley = Offset(tableRight, tableTop);
    const stringY = tableTop - pulleyR;
    const blockW = 40.0;
    const blockH = 26.0;
    final x = tableLeft + 10 + progress * 72;
    final hangX = pulley.dx + pulleyR;
    final hangY = 128 + progress * 36;
    noteLine(
      canvas,
      const Offset(16, 176),
      const Offset(220, 176),
      noteStroke(noteSoft, 1.4),
    );
    canvas.drawRect(
      const Rect.fromLTRB(tableLeft, tableTop, tableRight, tableBottom),
      noteStroke(noteInk, 1.8),
    );
    final block = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, tableTop - blockH, blockW, blockH),
      const Radius.circular(3),
    );
    canvas.drawRRect(block, noteSolid(const Color(0xFFFFF59D)));
    canvas.drawRRect(block, noteStroke());
    noteText(canvas, '200 g', Offset(x + blockW / 2, tableTop - blockH - 14));
    noteLine(
      canvas,
      Offset(x + blockW, stringY),
      Offset(pulley.dx, stringY),
      noteStroke(noteAccent),
    );
    canvas.drawCircle(pulley, pulleyR, noteSolid(const Color(0xFFFFFFFF)));
    canvas.drawCircle(pulley, pulleyR, noteStroke());
    canvas.drawCircle(pulley, 2.2, noteSolid(noteInk));
    canvas.drawArc(
      Rect.fromCircle(center: pulley, radius: pulleyR),
      -math.pi / 2,
      math.pi / 2,
      false,
      noteStroke(noteAccent),
    );
    noteLine(
      canvas,
      Offset(hangX, pulley.dy),
      Offset(hangX, hangY - 10),
      noteStroke(noteAccent),
    );
    noteMass(canvas, Offset(hangX, hangY), radius: 10);
    noteText(canvas, '200 g', Offset(hangX + 36, hangY + 2));
    _span(
      canvas,
      const Offset(36, 192),
      const Offset(36 + 72, 192),
      '0.80 m',
    );
  }

  void _hSpring(Canvas canvas, Size size) {
    // 壁＋ばね＋おもり。縮み 0.30 m から放す。自然長の両側を通る（鉛直ばねと同じ）。
    // ↔️ は縮めた側だけ。錘は床を掠る高さ。
    const wallX = 24.0;
    const naturalX = 140.0;
    const compress = 64.0;
    const floor = 152.0;
    const massR = 11.0;
    const massY = floor - massR - 1;
    final x = naturalX - compress * math.cos(progress * math.pi * 2);
    noteLine(canvas, const Offset(wallX, 36), const Offset(wallX, floor));
    noteLine(canvas, const Offset(16, floor), const Offset(268, floor));
    noteSpring(canvas, const Offset(wallX, massY), Offset(x - 14, massY), coils: 6);
    noteMass(canvas, Offset(x, massY), radius: massR);
    noteText(canvas, '40 g', Offset(x + 28, massY - 22));
    noteText(canvas, labels.naturalLength, const Offset(naturalX + 36, 48));
    _span(
      canvas,
      Offset(naturalX - compress, floor + 28),
      const Offset(naturalX, floor + 28),
      '0.30 m',
      tick: const Offset(0, 12),
      guide: 22,
    );
  }

  void _swing(Canvas canvas, Size size) {
    // 鉛直から 60° まで上げて放す。最大振れは点線で示す。
    const release = math.pi / 3;
    const length = 100.0;
    final angle = math.sin(progress * math.pi * 2) * release;
    final pivot = const Offset(115, 24);
    final bob = pivot + Offset(math.sin(angle) * length, math.cos(angle) * length);
    final releaseBob =
        pivot + Offset(math.sin(release) * length, math.cos(release) * length);
    final soft = noteStroke(noteSoft, 1.3);
    noteLine(canvas, const Offset(40, 24), const Offset(190, 24));
    _dashedLine(canvas, pivot, Offset(pivot.dx, pivot.dy + length), soft);
    _dashedLine(canvas, pivot, releaseBob, soft);
    canvas.drawCircle(releaseBob, 9, soft);
    canvas.drawArc(
      Rect.fromCircle(center: pivot, radius: 28),
      math.pi / 2,
      -release,
      false,
      soft,
    );
    noteText(canvas, '60°', pivot + const Offset(34, 22));
    noteLine(canvas, pivot, bob);
    noteMass(canvas, bob);
    _span(
      canvas,
      const Offset(64, 24),
      Offset(64, 24 + length),
      '0.20 m',
      tick: const Offset(-8, 0),
    );
  }

  void _disk(Canvas canvas, Size size) {
    const center = Offset(104, 94);
    const radius = 74.0;
    const holeRadius = radius / 2;
    final hole = center + const Offset(holeRadius, 0);
    final holeRight = hole + const Offset(holeRadius, 0);
    const board = Color(0xFFFDAF00);
    canvas.drawCircle(center, radius, noteSolid(board));
    canvas.drawCircle(center, radius, noteStroke(noteInk, 2));
    canvas.drawCircle(hole, holeRadius, noteSolid(const Color(0xFFFFFFFF)));
    canvas.drawCircle(hole, holeRadius, noteStroke(noteInk, 2));
    final leftRim = center + const Offset(-radius, 0);
    // 横寸法。縦の点線はラベル付近まで長く伸ばす。
    _doubleArrow(canvas, leftRim, center, guide: 0);
    _doubleArrow(canvas, hole, holeRight, guide: 0);
    final labelY = center.dy + radius + 10;
    for (final tip in [leftRim, center, hole, holeRight]) {
      paintDashedGuide(
        canvas: canvas,
        from: Offset(tip.dx, tip.dy - 10),
        to: Offset(tip.dx, labelY),
        color: noteInk,
      );
    }
    noteText(
      canvas,
      '10.2 cm',
      Offset(center.dx - holeRadius, center.dy + radius + 16),
    );
    noteText(
      canvas,
      '5.1 cm',
      Offset(hole.dx + holeRadius / 2, center.dy + radius + 16),
    );
  }

  void _sheet(Canvas canvas, Size size) {
    // 左に 16 cm 寸法を置くため、下敷きを右へずらす。
    const dx = 40.0;
    final sheet = Path()
      ..moveTo(28 + dx, 32)
      ..lineTo(188 + dx, 32)
      ..lineTo(188 + dx, 92)
      ..lineTo(108 + dx, 92)
      ..lineTo(108 + dx, 152)
      ..lineTo(28 + dx, 152)
      ..close();
    canvas.drawPath(sheet, noteSolid(noteFill));
    canvas.drawPath(sheet, noteStroke());
    canvas.drawCircle(Offset(72 + dx, 112), 3, noteSolid(noteAccent));
    _span(canvas, Offset(28 + dx, 16), Offset(188 + dx, 16), '24 cm');
    // 16 cm の矢印・数値は下敷きの左外。
    _span(
      canvas,
      const Offset(18, 32),
      const Offset(18, 152),
      '16 cm',
      tick: const Offset(-10, 0),
    );
  }

  /// 残った板を左半分と右下に分け、斜線で示す（解説用）。
  void _sheetExplain(Canvas canvas, Size size) {
    const dx = 40.0;
    const left = 28.0;
    const mid = 108.0;
    const right = 188.0;
    const top = 32.0;
    const midY = 92.0;
    const bottom = 152.0;
    final outline = Path()
      ..moveTo(left + dx, top)
      ..lineTo(right + dx, top)
      ..lineTo(right + dx, midY)
      ..lineTo(mid + dx, midY)
      ..lineTo(mid + dx, bottom)
      ..lineTo(left + dx, bottom)
      ..close();
    final leftHalf = Path()
      ..addRect(Rect.fromLTRB(left + dx, top, mid + dx, bottom));
    final lowerRight = Path()
      ..addRect(Rect.fromLTRB(mid + dx, midY, right + dx, bottom));

    // 上段: 左半分
    canvas.save();
    canvas.translate(0, -8);
    canvas.drawPath(outline, noteSolid(const Color(0xFFFFFFFF)));
    _hatch(canvas, leftHalf);
    canvas.drawPath(outline, noteStroke());
    canvas.drawCircle(Offset((left + mid) / 2 + dx, (top + bottom) / 2), 3, noteSolid(noteAccent));
    noteText(canvas, labels.leftHalf, Offset((left + mid) / 2 + dx, top - 14));
    noteText(canvas, 'x = 6', Offset((left + mid) / 2 + dx, bottom + 14));
    noteText(canvas, '2/3', Offset((left + mid) / 2 + dx, (top + bottom) / 2 + 16));
    canvas.restore();

    // 下段: 右下
    canvas.save();
    canvas.translate(0, 132);
    canvas.drawPath(outline, noteSolid(const Color(0xFFFFFFFF)));
    _hatch(canvas, lowerRight);
    canvas.drawPath(outline, noteStroke());
    canvas.drawCircle(Offset((mid + right) / 2 + dx, (midY + bottom) / 2), 3, noteSolid(noteAccent));
    noteText(canvas, labels.lowerRight, Offset((mid + right) / 2 + dx, top - 14));
    noteText(canvas, 'x = 18', Offset((mid + right) / 2 + dx, bottom + 14));
    noteText(canvas, '1/3', Offset((mid + right) / 2 + dx, (midY + bottom) / 2 + 16));
    canvas.restore();
  }

  void _hatch(Canvas canvas, Path region) {
    canvas.save();
    canvas.clipPath(region);
    final bounds = region.getBounds().inflate(8);
    final paint = noteStroke(noteSoft, 1.1);
    for (var x = bounds.left - bounds.height; x < bounds.right + bounds.height; x += 7) {
      canvas.drawLine(
        Offset(x, bounds.top),
        Offset(x + bounds.height, bounds.bottom),
        paint,
      );
    }
    canvas.restore();
    canvas.drawPath(region, noteStroke(noteSoft, 1.2));
  }

  void _slide(Canvas canvas, Size size) {
    // 幅 6.0 cm、μ = 0.20。境の高さは答えなので寸法値は置かず、押す高さを矢印だけ示す。
    const left = 88.0;
    const top = 24.0;
    const width = 52.0;
    const floor = 150.0;
    const pushY = 64.0;
    final block = RRect.fromRectAndRadius(
      const Rect.fromLTWH(left, top, width, floor - top),
      const Radius.circular(3),
    );
    canvas.drawRRect(block, noteSolid(const Color(0xFFFFE0B2)));
    canvas.drawRRect(block, noteStroke());
    noteLine(canvas, const Offset(24, floor), const Offset(210, floor));
    noteArrow(canvas, const Offset(36, pushY), const Offset(left, pushY));
    // 床〜押す位置（値なしの両矢印）。
    _doubleArrow(
      canvas,
      const Offset(left + width + 28, pushY),
      const Offset(left + width + 28, floor),
      guide: 14,
    );
    // 幅は床下。短いのでラベルを線上に置かず、下へ離す。
    _doubleArrow(
      canvas,
      const Offset(left, floor + 20),
      Offset(left + width, floor + 20),
      guide: 16,
    );
    noteText(canvas, '6.0 cm', Offset(left + width / 2, floor + 38));
    // μ は寸法と紛らわしいので、地面の右下へ。
    noteText(canvas, 'μ = 0.20', const Offset(188, floor + 38));
  }

  void _endLift(Canvas canvas, Size size) {
    // 一端を床につけ、他端を鉛直に持ち上げて静止。質量 200 g。力の値は答えなので置かない。
    // 棒ではなく厚みのあるブロック。角度は地面スレスレ。力は端の上から上向き。
    const floor = 172.0;
    noteLine(canvas, const Offset(24, floor), const Offset(220, floor));
    const theta = 0.12; // 約 7°
    const length = 150.0;
    const height = 30.0;
    const pivot = Offset(200, floor);
    final cosT = math.cos(theta);
    final sinT = math.sin(theta);
    final along = Offset(-cosT, -sinT);
    final normal = Offset(sinT, -cosT);
    final bottomTip = pivot + along * length;
    final topPivot = pivot + normal * height;
    final topTip = bottomTip + normal * height;
    final block = Path()
      ..moveTo(pivot.dx, pivot.dy)
      ..lineTo(bottomTip.dx, bottomTip.dy)
      ..lineTo(topTip.dx, topTip.dy)
      ..lineTo(topPivot.dx, topPivot.dy)
      ..close();
    canvas.drawPath(block, noteSolid(const Color(0xFFFFE0B2)));
    canvas.drawPath(block, noteStroke());
    final center = Offset(
      (pivot.dx + bottomTip.dx + topTip.dx + topPivot.dx) / 4,
      (pivot.dy + bottomTip.dy + topTip.dy + topPivot.dy) / 4,
    );
    noteText(canvas, '200 g', center);
    final liftFrom = topTip + const Offset(0, -4);
    noteArrow(canvas, liftFrom, liftFrom + const Offset(0, -34));
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
    paintDashedGuide(
      canvas: canvas,
      from: Offset(tube.left - 6, waterY),
      to: const Offset(176, waterY),
      color: noteInk,
    );
    _span(
      canvas,
      const Offset(64, stickTop),
      const Offset(64, stickBottom),
      '20 cm',
      tick: const Offset(-8, 0),
    );
    _span(
      canvas,
      const Offset(168, waterY),
      const Offset(168, stickBottom),
      '',
      tick: const Offset(8, 0),
    );
  }

  void _slideMu(Canvas canvas, Size size) {
    _pulledBlock(canvas, 28 + progress * 52, '0.98 N', walk: true);
  }

  void _hold(Canvas canvas, Size size) {
    _pulledBlock(canvas, 64, '1.96 N');
  }

  void _pulledBlock(
    Canvas canvas,
    double x,
    String force, {
    bool walk = false,
  }) {
    const top = 92.0;
    const height = 28.0;
    const width = 44.0;
    const floorY = 122.0;
    noteLine(canvas, const Offset(16, floorY), const Offset(228, floorY));
    final block = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, top, width, height),
      const Radius.circular(3),
    );
    canvas.drawRRect(block, noteSolid(const Color(0xFFFFF59D)));
    canvas.drawRRect(block, noteStroke());
    final midY = top + height / 2;
    final knot = Offset(x + width, midY);
    final center = knot + const Offset(44, 0);
    noteLine(canvas, knot, center - const Offset(16, 0));
    paintDialMeter(canvas, center, 15, color: noteInk, fraction: walk ? 0.38 : 0.62);
    final handle = center + const Offset(18, 0);
    noteLine(canvas, center + const Offset(15, 0), handle);
    canvas.drawCircle(handle, 3.2, noteStroke());
    noteText(canvas, '400 g', Offset(x + width / 2, top - 18));
    noteText(canvas, force, center + const Offset(0, -28));
    _stickPuller(canvas, handle, floorY, walk: walk, phase: x);
  }

  void _stickPuller(
    Canvas canvas,
    Offset hand,
    double floorY, {
    required bool walk,
    required double phase,
  }) {
    final paint = noteStroke(noteInk, 1.5);
    final lean = walk ? 14.0 : 20.0;
    final hip = Offset(hand.dx + lean, floorY - 24);
    final shoulder = Offset(hip.dx - 2, hip.dy - 20);
    final head = Offset(shoulder.dx, shoulder.dy - 10);
    canvas.drawCircle(head, 6.5, noteSolid(noteFill));
    canvas.drawCircle(head, 6.5, paint);
    noteLine(canvas, shoulder, hip, paint);
    noteLine(canvas, shoulder, hand, paint);
    noteLine(canvas, shoulder, Offset(hip.dx + 8, hip.dy - 6), paint);
    final gait = walk ? math.sin(phase * 0.4) * 7 : 0.0;
    noteLine(canvas, hip, Offset(hip.dx - 6 - gait, floorY), paint);
    noteLine(canvas, hip, Offset(hip.dx + 9 + gait, floorY), paint);
  }

  void _turn(Canvas canvas, Size size) {
    final angle = progress * math.pi * 2;
    final center = const Offset(115, 100);
    const radius = 48.0;
    // 台に放射状の模様を付け、回転が分かるようにする。
    canvas.drawCircle(center, radius, noteSolid(noteFill));
    const sectors = 8;
    for (var i = 0; i < sectors; i += 2) {
      final start = angle + i * math.pi * 2 / sectors;
      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(
          Rect.fromCircle(center: center, radius: radius),
          start,
          math.pi * 2 / sectors,
          false,
        )
        ..close();
      canvas.drawPath(path, noteSolid(const Color(0xFFCFD8DC)));
    }
    for (var i = 0; i < sectors; i++) {
      final a = angle + i * math.pi * 2 / sectors;
      noteLine(
        canvas,
        center,
        center + Offset(math.cos(a) * radius, math.sin(a) * radius),
        noteStroke(noteSoft, 1.1),
      );
    }
    canvas.drawCircle(center, radius * 0.55, noteStroke(noteSoft, 1.1));
    canvas.drawCircle(center, radius, noteStroke());
    canvas.drawCircle(center, 4, noteSolid(noteInk));
    final bob = center + Offset(math.cos(angle) * radius, math.sin(angle) * radius);
    noteSpring(canvas, center, bob, coils: 14, amplitude: 2.8);
    noteMass(canvas, bob, radius: 8);
    _span(
      canvas,
      center + const Offset(56, 0),
      center + Offset(56, -radius),
      '0.20 m',
      tick: const Offset(12, 0),
    );
    noteText(canvas, '0.628 s', const Offset(176, 168));
  }

  void _lift(Canvas canvas, Size size) {
    // カゴは小さめ。浮上距離は幅の約 1.75 倍。
    const cabinW = 84.0;
    const cabinH = 100.0;
    const rise = cabinW * 1.75;
    const left = 72.0;
    const topAtPeak = 24.0;
    final top = topAtPeak + (1 - progress) * rise;
    final cx = left + cabinW / 2;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, cabinW, cabinH),
        const Radius.circular(6),
      ),
      noteStroke(),
    );
    noteArrow(
      canvas,
      Offset(left - 28, top + cabinH * 0.62),
      Offset(left - 28, top + cabinH * 0.28),
    );
    noteLine(canvas, Offset(cx, top + 6), Offset(cx, top + 18));
    paintDialMeter(
      canvas,
      Offset(cx, top + 34),
      16,
      color: noteInk,
      fraction: 0.62,
    );
    noteLine(canvas, Offset(cx, top + 50), Offset(cx, top + 72));
    noteMass(canvas, Offset(cx, top + 82), radius: 9);
    noteText(canvas, '1.0 m/s²', Offset(left - 28, top + cabinH + 22));
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
    // 12 cm = 放す高さから最下点まで。水平点線は天井の右端まで。
    _span(
      canvas,
      Offset(18, release.dy),
      Offset(18, bottom.dy),
      '12 cm',
      tick: const Offset(10, 0),
      guide: 0,
    );
    for (final y in [release.dy, bottom.dy]) {
      paintDashedGuide(
        canvas: canvas,
        from: Offset(18, y),
        to: Offset(200, y),
        color: noteInk,
      );
    }
  }

  void _dip(Canvas canvas, Size size) {
    // 100 g・40 cm³ のおもりを飽和食塩水へ。ばねはかりは天井から。
    // サイクル前1/3で沈め、残り約3 sは沈めたまま。
    const tank = Rect.fromLTWH(78, 88, 100, 100);
    final dip = playPauseProgress(progress, motion: 1 / 3);
    final y = 64 + dip * 70;
    canvas.drawRRect(
      RRect.fromRectAndRadius(tank, const Radius.circular(4)),
      noteStroke(),
    );
    canvas.drawRect(
      Rect.fromLTRB(tank.left + 2, 120, tank.right - 2, tank.bottom - 2),
      noteSolid(const Color(0xFFB3E5FC)),
    );
    noteLine(canvas, const Offset(100, 12), const Offset(136, 12));
    noteLine(canvas, const Offset(118, 12), const Offset(118, 20));
    paintDialMeter(canvas, const Offset(118, 36), 16, color: noteInk);
    noteLine(canvas, const Offset(118, 52), Offset(118, y - 12));
    noteMass(canvas, Offset(118, y), radius: 11);
    noteText(canvas, '100 g', const Offset(48, 64));
    noteText(canvas, '40 cm³', const Offset(48, 86));
    noteText(canvas, '1.20 g/cm³', const Offset(186, 140));
  }

  void _tension(Canvas canvas, Size size) {
    // 60° から放すので、糸に沿った張力は T = mg (3 cosθ − 1)。
    const release = math.pi / 3;
    final angle = math.sin(progress * math.pi * 2) * release;
    final pivot = const Offset(115, 22);
    const length = 96.0;
    final bob = pivot + Offset(math.sin(angle) * length, math.cos(angle) * length);
    final startBob =
        pivot + Offset(-math.sin(release) * length, math.cos(release) * length);
    final releaseBob =
        pivot + Offset(math.sin(release) * length, math.cos(release) * length);
    final soft = noteStroke(noteSoft, 1.3);
    noteLine(canvas, const Offset(40, 22), const Offset(190, 22));
    // 鉛直と、左右の最大振れ（60°）の糸・球は点線。
    _dashedLine(canvas, pivot, Offset(pivot.dx, pivot.dy + length), soft);
    _dashedLine(canvas, pivot, startBob, soft);
    _dashedLine(canvas, pivot, releaseBob, soft);
    canvas.drawCircle(startBob, 9, soft);
    canvas.drawCircle(releaseBob, 9, soft);
    canvas.drawArc(
      Rect.fromCircle(center: pivot, radius: 28),
      math.pi / 2 - release,
      release,
      false,
      soft,
    );
    noteText(canvas, '60°', pivot + const Offset(34, 22));
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
      );
    }
  }

  void _dashedLine(Canvas canvas, Offset from, Offset to, Paint paint) {
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

  void _dashedOval(Canvas canvas, Rect rect, Paint paint) {
    const steps = 72;
    const dash = 4.0;
    const gap = 3.5;
    var drawn = 0.0;
    var draw = true;
    var budget = dash;
    Offset? prev;
    for (var i = 0; i <= steps; i++) {
      final t = i / steps * math.pi * 2;
      final p = Offset(
        rect.center.dx + rect.width / 2 * math.cos(t),
        rect.center.dy + rect.height / 2 * math.sin(t),
      );
      if (prev != null) {
        var a = prev;
        var remain = (p - a).distance;
        if (remain > 1e-6) {
          final dir = (p - a) / remain;
          while (remain > 1e-6) {
            final take = math.min(budget, remain);
            final next = a + dir * take;
            if (draw) {
              canvas.drawLine(a, next, paint);
            }
            a = next;
            remain -= take;
            budget -= take;
            if (budget <= 1e-6) {
              draw = !draw;
              budget = draw ? dash : gap;
            }
          }
        }
      }
      prev = p;
    }
  }

  void _stairs(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(30, 140)
      ..lineTo(100, 140)
      ..lineTo(100, 70)
      ..lineTo(180, 70);
    canvas.drawPath(path, noteStroke());
    _span(canvas, const Offset(118, 70), const Offset(118, 140), '5.0 m', tick: const Offset(10, 0));
    // ゲージは段の線から離し、広い ??? hPa は盤の外横へ。
    paintPressureGauge(
      canvas,
      const Offset(58, 82),
      radius: 11,
      labelShift: const Offset(-62, -14),
    );
    paintPressureGauge(
      canvas,
      const Offset(160, 28),
      radius: 11,
      labelShift: const Offset(62, -14),
    );
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
    noteText(canvas, '1013 hPa', const Offset(164, 174));
    // 頂点ゲージは斜面の右外・数値は盤の上へ。
    paintPressureGauge(
      canvas,
      const Offset(236, 52),
      radius: 11,
      labelShift: const Offset(0, -42),
    );
  }

  void _syringe(Canvas canvas, Size size) {
    const cx = 108.0;
    const half = 20.0;
    const barrelTop = 48.0;
    const barrelBottom = 150.0;
    // 先を塞いだ筒の底からピストンを引くと、中が真空に近づく。
    const pistonStart = barrelBottom - 16;
    const pistonEnd = barrelTop + 22;
    final pull = playPauseProgress(progress, motion: 2500 / 4500);
    final piston = pistonStart + (pistonEnd - pistonStart) * pull;
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
    // 先端のノズルを、四角い蓋で塞ぐ。
    canvas.drawRect(
      const Rect.fromLTRB(cx - 6, barrelBottom, cx + 6, barrelBottom + 6),
      noteStroke(noteInk, 2),
    );
    const cap = Rect.fromLTRB(cx - 14, barrelBottom + 5, cx + 14, barrelBottom + 21);
    canvas.drawRect(cap, noteSolid(noteFill));
    canvas.drawRect(cap, noteStroke(noteInk, 2));
    noteLine(
      canvas,
      const Offset(cx - 8, barrelBottom + 13),
      const Offset(cx + 8, barrelBottom + 13),
      noteStroke(noteInk, 1.4),
    );
    // ピストン下の真空領域。
    canvas.drawRect(
      Rect.fromLTRB(cx - half + 2, piston + 8, cx + half - 2, barrelBottom - 1),
      noteSolid(const Color(0xFFECEFF1)),
    );
    canvas.drawRect(
      Rect.fromLTRB(cx - half + 3, piston, cx + half - 3, piston + 8),
      noteSolid(noteFill),
    );
    canvas.drawRect(
      Rect.fromLTRB(cx - half + 3, piston, cx + half - 3, piston + 8),
      noteStroke(noteAccent),
    );
    noteLine(canvas, Offset(cx, piston), const Offset(cx, 18));
    noteArrow(canvas, Offset(cx + 16, 30), Offset(cx + 16, 12));
    const mark = 112.0;
    _doubleArrow(canvas, const Offset(cx - half, mark), const Offset(cx + half, mark));
    noteText(canvas, labels.diameterCm('2.0'), const Offset(178, 78));
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
    _span(canvas, const Offset(22, surface), const Offset(22, depthY), '50 cm', tick: const Offset(8, 0));
    noteText(canvas, '1013 hPa', const Offset(137, 36));
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
    // 上辺の角は下の容器と同じく丸くする。
    const corner = 10.0;
    final tubeFill = Path()
      ..moveTo(tubeLeft, mouthY)
      ..lineTo(tubeLeft, tubeTop + corner)
      ..quadraticBezierTo(tubeLeft, tubeTop, tubeLeft + corner, tubeTop)
      ..lineTo(tubeRight - corner, tubeTop)
      ..quadraticBezierTo(tubeRight, tubeTop, tubeRight, tubeTop + corner)
      ..lineTo(tubeRight, mouthY)
      ..close();
    final tubeStroke = Path()
      ..moveTo(tubeLeft, mouthY)
      ..lineTo(tubeLeft, tubeTop + corner)
      ..quadraticBezierTo(tubeLeft, tubeTop, tubeLeft + corner, tubeTop)
      ..lineTo(tubeRight - corner, tubeTop)
      ..quadraticBezierTo(tubeRight, tubeTop, tubeRight, tubeTop + corner)
      ..lineTo(tubeRight, mouthY);
    canvas.drawPath(tubeFill, noteSolid(const Color(0xFFFFFFFF)));
    canvas.save();
    canvas.clipPath(tubeFill);
    canvas.drawRect(
      const Rect.fromLTRB(tubeLeft, innerY, tubeRight, mouthY),
      noteSolid(water),
    );
    canvas.restore();
    canvas.drawPath(tubeStroke, noteStroke());
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
    noteText(canvas, '1013 hPa', const Offset(186, 108));
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
    noteText(canvas, '1.20 g/cm³', const Offset(146, 16));
    noteText(canvas, '1013 hPa', const Offset(146, 52));
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

    noteText(canvas, 'He', const Offset(40, 96), size: 20);
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
    noteText(canvas, diameter, Offset(markX + 8, cy + ry + 22));
    if (extra != null) {
      noteText(canvas, extra, Offset(far - 4, cy + ry + 34));
    }
  }

  void _loop(Canvas canvas, Size size) {
    // 楕円の巻きを縦にまっすぐ重ねた多巻き円形コイル（斜めずらしはしない）。
    const center = Offset(115, 112);
    const turns = 10;
    const width = 150.0;
    const height = 48.0;
    const step = Offset(0, -3.2);
    final start = center - step * ((turns - 1) / 2);
    for (var i = 0; i < turns; i++) {
      final c = start + step * i.toDouble();
      canvas.drawOval(
        Rect.fromCenter(center: c, width: width, height: height),
        noteStroke(i == turns - 1 ? noteInk : noteSoft, i == turns - 1 ? 1.8 : 1.3),
      );
    }
    final front = start + step * (turns - 1);
    // 各巻きの右端に上向き。同じ向きの電流がどの導線にも流れている。
    for (var i = 0; i < turns; i++) {
      final c = start + step * i.toDouble();
      final at = c + const Offset(width / 2, 0);
      final head = Path()
        ..moveTo(at.dx, at.dy - 5)
        ..lineTo(at.dx - 3.5, at.dy + 3)
        ..lineTo(at.dx + 3.5, at.dy + 3)
        ..close();
      canvas.drawPath(head, noteSolid(noteInk));
    }
    noteText(
      canvas,
      '1.0 A',
      start + step * ((turns - 1) / 2) + const Offset(width / 2 + 32, 0),
    );
    final spanY = front.dy + height / 2 + 22;
    final spanFrom = Offset(front.dx, spanY);
    final spanTo = Offset(front.dx + width / 2, spanY);
    _doubleArrow(canvas, spanFrom, spanTo);
    // 寸法値は線の下へ（楕円に乗せない）。
    noteText(
      canvas,
      '6.28 cm',
      Offset((spanFrom.dx + spanTo.dx) / 2, spanY + 18),
    );
    noteText(
      canvas,
      labels.hundredTurnsCompact,
      Offset(center.dx, front.dy - height / 2 - 14),
    );
  }

  void _rc(Canvas canvas, Size size) {
    // 放電: 5000 μF、2000 Ω、初期 3.0 V。V が半分になる時刻を聞く。
    const left = 48.0;
    const right = 190.0;
    const top = 56.0;
    const bottom = 148.0;
    noteLine(canvas, const Offset(left, top), const Offset(96, top));
    noteLine(canvas, const Offset(118, top), const Offset(right, top));
    noteLine(canvas, const Offset(left, bottom), const Offset(right, bottom));
    noteLine(canvas, const Offset(left, top), const Offset(left, bottom));
    noteLine(canvas, const Offset(right, top), const Offset(right, 78));
    noteLine(canvas, const Offset(right, 130), const Offset(right, bottom));
    // コンデンサー（上辺）
    noteLine(canvas, const Offset(96, top - 12), const Offset(96, top + 12));
    noteLine(canvas, const Offset(112, top - 12), const Offset(112, top + 12));
    noteText(canvas, '5000 μF', const Offset(104, 30));
    // 抵抗（右辺のジグザグ）
    final zig = Path()..moveTo(right, 78);
    for (var i = 0; i < 6; i++) {
      zig.lineTo(right + (i.isEven ? 10 : -10), 86.0 + i * 7);
    }
    zig.lineTo(right, 130);
    canvas.drawPath(zig, noteStroke());
    noteText(canvas, '2000 Ω', const Offset(218, 104));
    noteText(canvas, '3.0 V', const Offset(90, 178));
    noteText(canvas, '→ V/2', const Offset(150, 178));
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
    noteText(canvas, labels.currentI, Offset(lastX + 30, cy + windR + 34));

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
      const Offset(tubeLeft - 14, cy - faceRy * 0.5), );

    // 透磁率
    noteText(canvas, 'μ₀', const Offset(24, cy));
    noteArrow(
      canvas,
      const Offset(34, cy),
      Offset(tubeLeft - faceRx - 2, cy),
      color: noteInk,
    );

    noteText(
      canvas,
      labels.hundredTurns,
      Offset((firstX + lastX) / 2, leadY + 18),
    );
  }

  void _bar(Canvas canvas, Size size) {
    // 電池は底辺（左+・右−）。棒の電流は上→下。B は紙面向こう（×）で F は右。
    const left = 96.0;
    const right = 214.0;
    const top = 32.0;
    const bottom = 128.0;
    const barX = 162.0;
    const mid = (top + bottom) / 2;
    final wire = noteStroke();

    noteLine(canvas, const Offset(left, top), const Offset(right, top), wire);
    noteLine(canvas, const Offset(left, top), const Offset(left, bottom), wire);
    noteLine(canvas, const Offset(left, bottom), const Offset(118, bottom), wire);
    noteLine(canvas, const Offset(136, bottom), const Offset(right, bottom), wire);

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
    noteArrow(
      canvas,
      const Offset(118, top),
      const Offset(150, top),
      color: noteInk,
    );
    noteText(canvas, '1.0 A', Offset((left + right) / 2, top - 18));

    const field = Offset(192, 58);
    canvas.drawCircle(field, 8, wire);
    noteLine(
      canvas,
      field + const Offset(-3.6, -3.6),
      field + const Offset(3.6, 3.6),
      noteStroke(noteInk, 1.5),
    );
    noteLine(
      canvas,
      field + const Offset(-3.6, 3.6),
      field + const Offset(3.6, -3.6),
      noteStroke(noteInk, 1.5),
    );
    noteText(canvas, '0.20 T', const Offset(222, 58));

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
      const Offset(barX + 10, mid),
      const Offset(barX + 52, mid),
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
