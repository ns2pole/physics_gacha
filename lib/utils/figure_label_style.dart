import 'package:flutter/painting.dart';

/// 問題一覧PDFを描くときだけセットする。通常は null で、端末のフォントのまま。
String? figureLabelFontFamily;

TextStyle figureLabelStyle({
  required Color color,
  double fontSize = 13,
  FontWeight? fontWeight,
  FontStyle? fontStyle,
  double? height,
}) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
    height: height,
    fontFamily: figureLabelFontFamily,
  );
}
