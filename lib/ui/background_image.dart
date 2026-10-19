import 'package:flutter/material.dart';

/// 単位ガチャと同じ背景。home.png を画面の四分割に敷き、薄く見せる。
class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  static const imagePath = 'assets/background/home.png';

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.white,
      child: Opacity(
        opacity: 0.3,
        child: _TiledImage(imagePath: imagePath),
      ),
    );
  }
}

class _TiledImage extends StatelessWidget {
  const _TiledImage({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = constraints.maxWidth / 2;
        final tileHeight = constraints.maxHeight / 2;
        return Stack(
          children: [
            for (final left in [0.0, tileWidth])
              for (final top in [0.0, tileHeight])
                Positioned(
                  left: left,
                  top: top,
                  width: tileWidth,
                  height: tileHeight,
                  child: Image.asset(imagePath, fit: BoxFit.cover),
                ),
          ],
        );
      },
    );
  }
}
