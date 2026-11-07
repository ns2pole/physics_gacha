import 'package:flutter/painting.dart';

/// 問題一覧PDFを描くときだけセットする。通常は null で、端末のフォントのまま。
String? figureLabelFontFamily;

/// 図の数値・単位ラベル。No.12/13（ばね・寸法矢印）の見え方に合わせる。
TextStyle figureLabelStyle({
  required Color color,
  double fontSize = 15,
  FontWeight fontWeight = FontWeight.w500,
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
