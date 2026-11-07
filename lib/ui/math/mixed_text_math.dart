import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter/material.dart';
import 'mixed_text_math_pipeline.dart';

/// テキストと数式（TeX）を混在表示するウィジェット
///
/// 主な機能:
/// - TeXマクロ（\displaystyle, \int等）を検出して数式として表示
/// - Math.texのビルドエラー時はプレーンテキストでフォールバック
/// - ブロック数式（$$...$$）は横スクロール表示
/// - インライン数式（$...$）は数式部分のみ横スクロール可能
/// - 段落間パディング: vertical:4.0、行間: height:1.35
///
/// 入力例:
/// - "これは $x^2 + y^2 = 1$ の式です"
/// - "$$\\int_0^1 x dx = \\frac{1}{2}$$"
/// - "tex: \\displaystyle \\sum_{i=1}^{n} i = \\frac{n(n+1)}{2}"
class MixedTextMath extends StatelessWidget {
  final String mixed;
  final TextStyle? labelStyle;
  final TextStyle? mathStyle;
  final bool forceTex;
  final bool displayInlineFractions;
  final bool plainTextOnMathError;

  const MixedTextMath(
    this.mixed, {
    this.labelStyle,
    this.mathStyle,
    this.forceTex = false,
    this.displayInlineFractions = false,
    this.plainTextOnMathError = false,
    Key? key,
  }) : super(key: key);

  /// "tex:" または "tex：" プレフィックスを除去
  ///
  /// 入力例: "tex: \\int x dx" → "\\int x dx"
  /// 入力例: "tex：\\displaystyle \\sum_{i=1}^n i" → "\\displaystyle \\sum_{i=1}^n i"
  String _stripTexPrefix(String s) {
    var t = s.trim();
    if (t.toLowerCase().startsWith('tex:')) t = t.substring(4).trim();
    if (t.toLowerCase().startsWith('tex：')) t = t.substring(4).trim();
    return _stripOuterMathDelimiters(t);
  }

  /// Math.tex expects TeX content only, not Markdown-style math delimiters.
  String _stripOuterMathDelimiters(String s) {
    final t = s.trim();
    if (t.length >= 4 && t.startsWith(r'$$') && t.endsWith(r'$$')) {
      final inner = t.substring(2, t.length - 2);
      if (inner.trim().isNotEmpty && !inner.contains(r'$$')) {
        return inner.trim();
      }
    }
    if (t.length >= 2 &&
        t.startsWith(r'$') &&
        t.endsWith(r'$') &&
        !t.startsWith(r'$$')) {
      final inner = t.substring(1, t.length - 1);
      if (inner.trim().isNotEmpty && !inner.contains(r'$')) {
        return inner.trim();
      }
    }
    if (t.length >= 4 && t.startsWith(r'\(') && t.endsWith(r'\)')) {
      return t.substring(2, t.length - 2).trim();
    }
    if (t.length >= 4 && t.startsWith(r'\[') && t.endsWith(r'\]')) {
      return t.substring(2, t.length - 2).trim();
    }
    return t;
  }

  bool _isDelimitedMathOnly(String s) {
    return _stripOuterMathDelimiters(s) != s.trim();
  }

  /// 文字列が数式（TeX）かどうかを判定
  ///
  /// 判定基準:
  /// - 先頭がバックスラッシュ（例: "\\int"）
  /// - TeXマクロを含む（\displaystyle, \int, \sum, \frac等）
  /// - TeXマクロパターン（\\[A-Za-z]+）に一致
  /// - 上付き/下付き記号（^, _）を含む
  /// - 数学記号（括弧、演算子）を含む
  ///
  /// 入力例:
  /// - "\\int_0^1 x dx" → true
  /// - "x^2 + y^2" → true
  /// - "これは普通のテキスト" → false
  bool _looksLikeMath(String s) {
    if (s.isEmpty) return false;
    final t = s.trim();

    if (t.startsWith(r'\')) return true;

    final keywords = [
      r'\displaystyle',
      r'\int',
      r'\sum',
      r'\frac',
      r'\sqrt',
      r'\lim',
      r'\begin',
      r'\end',
      r'\alpha',
      r'\beta',
      r'\gamma',
      r'\,',
    ];
    for (final k in keywords) {
      if (t.contains(k)) return true;
    }

    final macroRe = RegExp(r'\\[A-Za-z]+');
    if (macroRe.hasMatch(t)) return true;

    if (t.contains('^') || t.contains('_') || t.contains(r'$')) return true;

    final mathChars = RegExp(r'[(){}\[\]\+\-\*/=]');
    if (mathChars.hasMatch(t)) return true;

    return false;
  }

  /// TeX文字列をMath.texでレンダリング。エラー時はプレーンテキストでフォールバック
  ///
  /// 入力: TeX文字列（例: "\\int_0^1 x dx"）
  /// 出力: Math.texウィジェット、またはエラー時はSelectableText
  Widget _mathCoreSafe(String tex, TextStyle style, {MathStyle? mathStyle}) {
    final normalizedTex = _wrapBareCjkTextInTex(trimDanglingTrailingTexSpacing(tex));
    try {
      if (plainTextOnMathError) {
        return Math.tex(
          normalizedTex,
          textStyle: style,
          mathStyle: mathStyle ?? MathStyle.text,
          onErrorFallback: (_) => SelectableText(tex, style: style),
        );
      }

      return Math.tex(
        normalizedTex,
        textStyle: style,
        mathStyle: mathStyle ?? MathStyle.text,
      );
    } catch (e, st) {
      // ignore: avoid_print
      print(
        'MixedTextMath: Math.tex build error: $e\n'
        'tex: $tex\nnormalized: $normalizedTex\n$st',
      );
      return SelectableText(tex, style: style);
    }
  }

  String _wrapBareCjkTextInTex(String tex) {
    if (!_containsCjkText(tex)) return tex;

    final out = StringBuffer();
    var i = 0;
    while (i < tex.length) {
      final codeUnit = tex.codeUnitAt(i);
      if (codeUnit == 0x5c) {
        i = _copyCommandAndSkippedArgument(tex, i, out);
        continue;
      }

      if (_isCjkTextCodeUnit(codeUnit)) {
        final start = i;
        i++;
        while (i < tex.length) {
          final current = tex.codeUnitAt(i);
          if (_isCjkTextCodeUnit(current)) {
            i++;
            continue;
          }
          if (_isInlineWhitespace(current) &&
              _hasFollowingCjkText(tex, i + 1)) {
            i++;
            continue;
          }
          break;
        }

        final textRun = tex.substring(start, i);
        out
          ..write(r'\text{')
          ..write(_escapeTextMacroContent(textRun))
          ..write('}');
        continue;
      }

      out.writeCharCode(codeUnit);
      i++;
    }

    return out.toString();
  }

  int _copyCommandAndSkippedArgument(String tex, int start, StringBuffer out) {
    var i = start + 1;
    while (i < tex.length && _isAsciiLetter(tex.codeUnitAt(i))) {
      i++;
    }

    final command = tex.substring(start + 1, i);
    out.write(tex.substring(start, i));

    if (i < tex.length && tex.codeUnitAt(i) == 0x2a) {
      out.writeCharCode(tex.codeUnitAt(i));
      i++;
    }

    if (!_shouldSkipTextWrappingInside(command)) return i;

    final spacesStart = i;
    while (i < tex.length && _isInlineWhitespace(tex.codeUnitAt(i))) {
      i++;
    }
    out.write(tex.substring(spacesStart, i));

    if (i >= tex.length || tex.codeUnitAt(i) != 0x7b) return i;

    final end = _findBalancedBraceEnd(tex, i);
    if (end < 0) return i;

    out.write(tex.substring(i, end + 1));
    return end + 1;
  }

  int _findBalancedBraceEnd(String tex, int openIndex) {
    var depth = 0;
    for (var i = openIndex; i < tex.length; i++) {
      final codeUnit = tex.codeUnitAt(i);
      if (codeUnit == 0x5c) {
        i++;
        continue;
      }
      if (codeUnit == 0x7b) depth++;
      if (codeUnit == 0x7d) {
        depth--;
        if (depth == 0) return i;
      }
    }
    return -1;
  }

  bool _shouldSkipTextWrappingInside(String command) {
    const skippedCommands = {
      'text',
      'textrm',
      'textbf',
      'textit',
      'textnormal',
      'mbox',
      'hbox',
      'operatorname',
      'mathrm',
      'mathit',
      'mathbf',
      'mathsf',
      'mathtt',
    };
    return skippedCommands.contains(command);
  }

  bool _containsCjkText(String text) {
    for (var i = 0; i < text.length; i++) {
      if (_isCjkTextCodeUnit(text.codeUnitAt(i))) return true;
    }
    return false;
  }

  bool _hasFollowingCjkText(String text, int start) {
    for (var i = start; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      if (_isInlineWhitespace(codeUnit)) continue;
      return _isCjkTextCodeUnit(codeUnit);
    }
    return false;
  }

  bool _isAsciiLetter(int codeUnit) {
    return (codeUnit >= 0x41 && codeUnit <= 0x5a) ||
        (codeUnit >= 0x61 && codeUnit <= 0x7a);
  }

  bool _isInlineWhitespace(int codeUnit) {
    return codeUnit == 0x20 || codeUnit == 0x09;
  }

  bool _isCjkTextCodeUnit(int codeUnit) {
    return (codeUnit >= 0x3040 && codeUnit <= 0x30ff) ||
        (codeUnit >= 0x3400 && codeUnit <= 0x4dbf) ||
        (codeUnit >= 0x4e00 && codeUnit <= 0x9fff) ||
        (codeUnit >= 0x3000 && codeUnit <= 0x303f) ||
        (codeUnit >= 0xff01 && codeUnit <= 0xff60) ||
        codeUnit == 0x3005 ||
        codeUnit == 0x3006 ||
        codeUnit == 0x3007;
  }

  String _escapeTextMacroContent(String text) {
    return text
        .replaceAll(r'\', r'\textbackslash{}')
        .replaceAll('{', r'\{')
        .replaceAll('}', r'\}');
  }

  /// ブロック数式（独立行の数式）を表示するウィジェット
  ///
  /// 入力: TeX文字列（例: "\\int_0^1 x dx = \\frac{1}{2}"）
  /// 出力: 横スクロール可能な数式ウィジェット
  /// 使用例: "$$x^2 + y^2 = 1$$" や "\\begin{align}...\\end{align}"
  Widget _blockMathWidget(String tex, TextStyle? style) {
    final effective = style ?? const TextStyle(fontSize: 26);
    final core = _mathCoreSafe(tex, effective, mathStyle: MathStyle.display);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 0),
          child: core,
        ),
      ),
    );
  }

  /// インライン数式（文中の数式）を表示するウィジェット
  ///
  /// 入力: TeX文字列（例: "x^2"）、最大幅
  /// 出力: 数式部分のみ横スクロール可能なウィジェット
  /// 使用例: "これは $x^2 + y^2 = 1$ の式です" の "$x^2 + y^2 = 1$" 部分
  Widget _inlineMathWidgetConstrained(
    String tex,
    double maxWidth,
    TextStyle? style,
  ) {
    final effective = style ?? const TextStyle(fontSize: 22);
    final core = _mathCoreSafe(
      tex,
      effective,
      mathStyle: _inlineMathStyleFor(tex),
    );

    final maxAllowed = maxWidth.isFinite ? maxWidth * 0.95 : 300.0;
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxAllowed),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const ClampingScrollPhysics(),
          child: core,
        ),
      ),
    );
  }

  MathStyle _inlineMathStyleFor(String tex) {
    if (!displayInlineFractions) return MathStyle.text;
    return _containsFractionCommand(tex) ? MathStyle.display : MathStyle.text;
  }

  bool _containsFractionCommand(String tex) {
    return RegExp(r'\\(?:frac|dfrac|cfrac)\b').hasMatch(tex);
  }

  // 正規表現パターン定義
  /// 段落区切り（空行）を検出: "\n\n" や "\n  \n"
  static final RegExp _paraSplit = RegExp(r'\n\s*\n', dotAll: true);

  /// ブロック数式を検出: "$$x^2 + y^2 = 1$$" → "x^2 + y^2 = 1"
  static final RegExp _blockMath = RegExp(
    r'^\s*\$\$(.+?)\$\$\s*$',
    dotAll: true,
  );

  /// \textマクロを検出: "\text{これはテキスト}" → "これはテキスト"
  static final RegExp _textMacro = RegExp(
    r'\\text\s*\{([^}]*)\}',
    dotAll: true,
  );

  /// TeX環境ブロックを検出: "\\begin{align}...\\end{align}" など
  static final RegExp _envBlock = RegExp(
    r'^\s*\\begin\{(aligned|align\*?|alignedat|gather\*?|equation\*?|multline\*?|cases)\}(.+?)\\end\{\1\}\s*$',
    dotAll: true,
  );

  /// \textマクロで文字列を分割し、テキスト部分と数式部分を区別
  ///
  /// 入力例: "x^2 + \text{これはテキスト} + y^2"
  /// 出力: [
  ///   {'isText': false, 'text': 'x^2 + '},
  ///   {'isText': true, 'text': 'これはテキスト'},
  ///   {'isText': false, 'text': ' + y^2'}
  /// ]
  List<Map<String, dynamic>> _splitByTextMacro(String s) {
    final out = <Map<String, dynamic>>[];
    int last = 0;
    for (final m in _textMacro.allMatches(s)) {
      if (m.start > last) {
        final between = s.substring(last, m.start);
        if (between.isNotEmpty) out.add({'isText': false, 'text': between});
      }
      final inner = m.group(1) ?? '';
      out.add({'isText': true, 'text': inner});
      last = m.end;
    }
    if (last < s.length) {
      final tail = s.substring(last);
      if (tail.isNotEmpty) out.add({'isText': false, 'text': tail});
    }
    return out;
  }

  /// 文字列の先頭・末尾の空白を分離
  ///
  /// 入力例: "  x^2 + y^2  "
  /// 出力: {'leading': '  ', 'core': 'x^2 + y^2', 'trailing': '  '}
  Map<String, String> _extractPad(String s) {
    final leadingMatch = RegExp(r'^\s+').firstMatch(s);
    final trailingMatch = RegExp(r'\s+$').firstMatch(s);
    final leading = leadingMatch?.group(0) ?? '';
    final trailing = trailingMatch?.group(0) ?? '';
    final start = leading.length;
    final end = s.length - trailing.length;
    final core = (end > start) ? s.substring(start, end) : '';
    return {'leading': leading, 'core': core, 'trailing': trailing};
  }

  void _appendTextSpan(List<InlineSpan> spans, String text, TextStyle style) {
    if (text.isEmpty) return;
    spans.add(TextSpan(text: text, style: style));
  }

  int _findClosingSingleDollar(String source, int start) {
    for (var i = start; i < source.length; i++) {
      if (source.codeUnitAt(i) != 36) continue; // $
      final isPartOfDoubleDollar =
          (i > 0 && source.codeUnitAt(i - 1) == 36) ||
          (i + 1 < source.length && source.codeUnitAt(i + 1) == 36);
      if (!isPartOfDoubleDollar) return i;
    }
    return -1;
  }

  void _appendDollarMathSpans({
    required List<InlineSpan> spans,
    required String source,
    required double maxWidth,
    required TextStyle textStyle,
  }) {
    var cursor = 0;

    while (cursor < source.length) {
      final dollarIndex = source.indexOf(r'$', cursor);
      if (dollarIndex < 0) {
        _appendTextSpan(spans, source.substring(cursor), textStyle);
        return;
      }

      _appendTextSpan(spans, source.substring(cursor, dollarIndex), textStyle);

      if (source.startsWith(r'$$', dollarIndex)) {
        final end = source.indexOf(r'$$', dollarIndex + 2);
        if (end < 0) {
          _appendTextSpan(spans, source.substring(dollarIndex), textStyle);
          return;
        }

        final mathBody = source.substring(dollarIndex + 2, end).trim();
        if (mathBody.isEmpty) {
          _appendTextSpan(
            spans,
            source.substring(dollarIndex, end + 2),
            textStyle,
          );
        } else {
          spans.add(
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: _inlineMathWidgetConstrained(
                mathBody,
                maxWidth,
                mathStyle ?? const TextStyle(fontSize: 22),
              ),
            ),
          );
        }
        cursor = end + 2;
        continue;
      }

      final end = _findClosingSingleDollar(source, dollarIndex + 1);
      if (end < 0) {
        _appendTextSpan(spans, source.substring(dollarIndex), textStyle);
        return;
      }

      final mathBody = source.substring(dollarIndex + 1, end).trim();
      if (mathBody.isEmpty) {
        _appendTextSpan(
          spans,
          source.substring(dollarIndex, end + 1),
          textStyle,
        );
      } else {
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: _inlineMathWidgetConstrained(
              mathBody,
              maxWidth,
              mathStyle ?? const TextStyle(fontSize: 22),
            ),
          ),
        );
      }
      cursor = end + 1;
    }
  }

  TextStyle _defaultLabelStyle(BuildContext context) {
    return labelStyle ?? const TextStyle(fontSize: 17, height: 1.35);
  }

  @override
  Widget build(BuildContext context) {
    final text = mixed;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return const SizedBox.shrink();

    final hasTextMacro = text.contains(r'\text{');

    if (forceTex && !hasTextMacro) {
      final tex = _stripTexPrefix(trimmed);
      return _blockMathWidget(tex, mathStyle ?? const TextStyle(fontSize: 22));
    }

    final bool hasParaBreak = _paraSplit.hasMatch(text);
    final bool isSingleLine = !hasParaBreak && !text.contains('\n');
    final bool hasInlineDollar = text.contains(r'$');

    if ((isSingleLine &&
        _looksLikeMath(trimmed) &&
        !hasTextMacro &&
        (!hasInlineDollar || _isDelimitedMathOnly(trimmed)))) {
      final tex = _stripTexPrefix(trimmed);
      return _blockMathWidget(tex, mathStyle ?? const TextStyle(fontSize: 22));
    }

    final bool isLongPlain = text.length > 60 && text.contains(' ');

    if (hasParaBreak || hasInlineDollar || hasTextMacro || isLongPlain) {
      final paragraphs = text.split(_paraSplit);

      return LayoutBuilder(
        builder: (ctx, constraints) {
          final maxW = constraints.hasBoundedWidth
              ? constraints.maxWidth
              : double.infinity;
          final defaultLabel = _defaultLabelStyle(context);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: paragraphs.map((para) {
              final paraTrim = para.trim();
              if (paraTrim.isEmpty) return const SizedBox.shrink();

              final envMatch = _envBlock.firstMatch(paraTrim);
              if (envMatch != null) {
                final envBody = envMatch.group(0) ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Center(
                    child: _blockMathWidget(
                      envBody,
                      mathStyle ?? const TextStyle(fontSize: 26),
                    ),
                  ),
                );
              }

              final blockMatch = _blockMath.firstMatch(paraTrim);
              if (blockMatch != null) {
                final mathBody = blockMatch.group(1) ?? '';
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Center(
                    child: _blockMathWidget(
                      mathBody,
                      mathStyle ?? const TextStyle(fontSize: 26),
                    ),
                  ),
                );
              }

              if (shouldSplitMixedCjkAndLatex(para)) {
                final spans = <InlineSpan>[];
                for (final segment in segmentMixedCjkAndLatex(para)) {
                  if (segment.isPlain) {
                    _appendTextSpan(
                      spans,
                      segment.text,
                      labelStyle ?? defaultLabel,
                    );
                  } else {
                    spans.add(
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: _inlineMathWidgetConstrained(
                          segment.text,
                          maxW,
                          mathStyle ?? const TextStyle(fontSize: 22),
                        ),
                      ),
                    );
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text.rich(
                    TextSpan(children: spans),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                );
              }

              if (_looksLikeMath(paraTrim) &&
                  !para.contains(r'\text{') &&
                  (!para.contains(r'$') || _isDelimitedMathOnly(paraTrim))) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: _blockMathWidget(
                    _stripOuterMathDelimiters(paraTrim),
                    mathStyle ?? const TextStyle(fontSize: 26),
                  ),
                );
              }

              if (shouldSplitParagraphByTextMacro(para)) {
                final parts = _splitByTextMacro(para);
                final spans = <InlineSpan>[];

                for (final part in parts) {
                  final isText = part['isText'] as bool;
                  final content = part['text'] as String;
                  if (isText) {
                    spans.add(
                      TextSpan(
                        text: content,
                        style: labelStyle ?? defaultLabel,
                      ),
                    );
                  } else {
                    final pad = _extractPad(content);
                    final leading = pad['leading'] ?? '';
                    final core = pad['core'] ?? '';
                    final trailing = pad['trailing'] ?? '';

                    if (leading.isNotEmpty) {
                      spans.add(
                        TextSpan(
                          text: leading,
                          style: labelStyle ?? defaultLabel,
                        ),
                      );
                    }

                    if (core.isNotEmpty) {
                      if (core.contains(r'$')) {
                        _appendDollarMathSpans(
                          spans: spans,
                          source: core,
                          maxWidth: maxW,
                          textStyle: labelStyle ?? defaultLabel,
                        );
                      } else {
                        spans.add(
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: _inlineMathWidgetConstrained(
                              core,
                              maxW,
                              mathStyle ?? const TextStyle(fontSize: 22),
                            ),
                          ),
                        );
                      }
                    }

                    if (trailing.isNotEmpty) {
                      spans.add(
                        TextSpan(
                          text: trailing,
                          style: labelStyle ?? defaultLabel,
                        ),
                      );
                    }
                  }
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text.rich(
                    TextSpan(children: spans),
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                );
              }

              final spans = <InlineSpan>[];
              _appendDollarMathSpans(
                spans: spans,
                source: para,
                maxWidth: maxW,
                textStyle: labelStyle ?? defaultLabel,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text.rich(
                  TextSpan(children: spans),
                  softWrap: true,
                  textAlign: TextAlign.left,
                ),
              );
            }).toList(),
          );
        },
      );
    }

    final colonIndex = text.indexOf(':');
    final colonIndexFull = colonIndex >= 0 ? colonIndex : text.indexOf('：');
    if (colonIndexFull >= 0) {
      final leftRaw = text.substring(0, colonIndexFull).trim();
      final rightRaw = text.substring(colonIndexFull + 1).trim();

      if (leftRaw.toLowerCase() == 'tex') {
        final rightTex = _stripTexPrefix(rightRaw);
        return _blockMathWidget(
          rightTex,
          mathStyle ?? const TextStyle(fontSize: 22),
        );
      }

      final leftWidget = _looksLikeMath(leftRaw)
          ? _blockMathWidget(
              leftRaw,
              mathStyle ?? const TextStyle(fontSize: 20),
            )
          : Text(
              leftRaw + ':',
              style: labelStyle ?? _defaultLabelStyle(context),
            );

      final rightWidget = rightRaw.isEmpty
          ? const SizedBox.shrink()
          : _blockMathWidget(
              rightRaw,
              mathStyle ?? const TextStyle(fontSize: 22),
            );

      final leftCompact = Row(
        mainAxisSize: MainAxisSize.min,
        children: [leftWidget],
      );

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(flex: 0, child: leftCompact),
          const SizedBox(width: 6),
          Expanded(child: rightWidget),
        ],
      );
    }

    final mathStartRegexp = RegExp(
      r'[=\\_\^]|\\bI_\\w|\\bint\\b|\\bfrac\\b',
      caseSensitive: false,
    );
    final match = mathStartRegexp.firstMatch(text);
    if (match != null) {
      final idx = match.start;
      final left = text.substring(0, idx).trim();
      final right = text.substring(idx).trim();
      if (left.isEmpty) {
        return _blockMathWidget(
          right,
          mathStyle ?? const TextStyle(fontSize: 22),
        );
      } else {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 0,
              child: Text(
                left + ' ',
                style: labelStyle ?? _defaultLabelStyle(context),
              ),
            ),
            Flexible(
              child: _blockMathWidget(
                right,
                mathStyle ?? const TextStyle(fontSize: 22),
              ),
            ),
          ],
        );
      }
    }

    return _blockMathWidget(
      trimmed,
      mathStyle ?? const TextStyle(fontSize: 22),
    );
  }
}