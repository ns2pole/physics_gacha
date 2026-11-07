/// Pure functions for AI chat / mixed Japanese+LaTeX text preprocessing and segmentation.
///
/// Kept separate from [MixedTextMath] so behavior can be covered by unit tests.
library;

const int _backslash = 0x5c;
const int _openBrace = 0x7b;
const int _closeBrace = 0x7d;
const int _tab = 0x09;

enum MixedTextSegmentKind { plain, inlineMath, blockMath }

class MixedTextSegment {
  const MixedTextSegment({required this.kind, required this.text});

  final MixedTextSegmentKind kind;
  final String text;

  bool get isPlain => kind == MixedTextSegmentKind.plain;
  bool get isMath =>
      kind == MixedTextSegmentKind.inlineMath ||
      kind == MixedTextSegmentKind.blockMath;
}

/// Preprocess assistant chat text before [MixedTextMath].
String preprocessAiChatMathText(String text) {
  return normalizeAiChatMathDelimiters(
    normalizeDoubleEscapedLatex(
      normalizeLiteralEscapedNewlines(
        repairTabCorruptedLatex(text),
      ),
    ),
  );
}

/// Longest suffix first (matches [functions/src/latexSafeJsonString.ts]).
const List<String> _latexTabMacroSuffixesLongestFirst = [
  'extbf',
  'extit',
  'extnormal',
  'extrm',
  'riangle',
  'frac',
  'ext',
  'imes',
  'heta',
  'ilde',
  'au',
  'an',
  'o',
];

/// Whether [MixedTextMath] should use [_splitByTextMacro] for [paragraph].
///
/// Paragraphs with `$` keep `\text{...}` inside math delimiters for Math.tex.
bool shouldSplitParagraphByTextMacro(String paragraph) {
  return paragraph.contains(r'\text{') && !paragraph.contains(r'$');
}

/// Reverses JSON `\t` corruption (TAB + `ext{` → `\text{`, etc.).
String repairTabCorruptedLatex(String text) {
  if (!text.contains('\t')) return text;

  final out = StringBuffer();
  var i = 0;
  while (i < text.length) {
    if (text.codeUnitAt(i) == _tab) {
      final rest = text.substring(i + 1);
      String? matched;
      for (final suffix in _latexTabMacroSuffixesLongestFirst) {
        if (rest.startsWith(suffix)) {
          matched = suffix;
          break;
        }
      }
      if (matched != null) {
        out.write(r'\t');
        out.write(matched);
        i += 1 + matched.length;
        continue;
      }
    }
    out.writeCharCode(text.codeUnitAt(i));
    i++;
  }
  return out.toString();
}

/// Same suffix guard as [functions/src/latexSafeJsonString.ts] for `\n` in JSON decode.
const List<String> _latexNewlineMacroSuffixes = [
  'abla',
  'eq',
  'u',
  'ot',
  'mid',
  'less',
  'gtr',
];

/// TeX commands that start with `\t` (avoid turning `\text` into tab + ext).
const List<String> _latexTabMacroSuffixes = [
  'ext',
  'extbf',
  'extit',
  'extnormal',
  'extrm',
  'imes',
  'heta',
  'au',
  'an',
  'o',
  'frac',
  'riangle',
  'ilde',
];

/// TeX commands that start with `\r` (avoid turning `\right` into CR + ight).
const List<String> _latexReturnMacroSuffixes = [
  'ight',
  'ightarrow',
  'ightleftharpoons',
  'angle',
  'ho',
  'floor',
  'ceil',
];

/// Turns literal `\n` / `\t` / `\r` (two-char escapes) into whitespace when not TeX.
String normalizeLiteralEscapedNewlines(String text) {
  if (!text.contains(r'\')) return text;

  final out = StringBuffer();
  var i = 0;
  while (i < text.length) {
    if (text.codeUnitAt(i) == _backslash && i + 1 < text.length) {
      final esc = text[i + 1];
      if (esc == 'n' || esc == 't' || esc == 'r') {
        final rest = text.substring(i + 2);
        if (!_isLatexMacroContinuationAfterEsc(esc, rest)) {
          if (esc == 'n') {
            out.write('\n');
          } else if (esc == 't') {
            out.write('\t');
          } else {
            out.write('\r');
          }
          i += 2;
          continue;
        }
      }
    }
    out.writeCharCode(text.codeUnitAt(i));
    i++;
  }
  return out.toString();
}

bool _isLatexMacroContinuationAfterEsc(String esc, String rest) {
  final suffixes = switch (esc) {
    'n' => _latexNewlineMacroSuffixes,
    't' => _latexTabMacroSuffixes,
    'r' => _latexReturnMacroSuffixes,
    _ => const <String>[],
  };
  for (final suffix in suffixes) {
    if (rest.startsWith(suffix)) return true;
  }
  return false;
}

final RegExp _doubleEscapedMacro = RegExp(r'\\\\([A-Za-z]+)');

/// Collapses JSON-style double backslashes before TeX commands (\\frac → \frac).
String normalizeDoubleEscapedLatex(String text) {
  var out = text;
  while (_doubleEscapedMacro.hasMatch(out)) {
    out = out.replaceAllMapped(
      _doubleEscapedMacro,
      (m) => '\\${m.group(1)}',
    );
  }
  return out;
}

/// Converts `\(...\)` / `\[...\]` (not used by [MixedTextMath]) to `$` / `$$`.
String normalizeAiChatMathDelimiters(String text) {
  if (text.isEmpty) return text;
  if (!text.contains(r'\(') &&
      !text.contains(r'\)') &&
      !text.contains(r'\[') &&
      !text.contains(r'\]')) {
    return text;
  }

  return text
      .replaceAll(r'\[', r'$$')
      .replaceAll(r'\]', r'$$')
      .replaceAll(r'\(', r'$')
      .replaceAll(r'\)', r'$');
}

/// Whether [MixedTextMath] should render this chat line (not plain [Text] only).
bool shouldRenderWithMixedTextMath(String text) {
  if (text.trim().isEmpty) return false;
  if (RegExp(r'(^|\n)\s*tex[:：]|\$').hasMatch(text)) return true;
  if (RegExp(r'\\[A-Za-z]+').hasMatch(text)) return true;
  return false;
}

/// Strips Markdown-style math delimiters when the whole fragment is delimited.
String stripOuterMathDelimiters(String s) {
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

bool isDelimitedMathOnly(String s) {
  return stripOuterMathDelimiters(s) != s.trim();
}

bool looksLikeMath(String s) {
  if (s.isEmpty) return false;
  final t = s.trim();

  if (t.startsWith(r'\')) return true;

  const keywords = [
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

  if (RegExp(r'\\[A-Za-z]+').hasMatch(t)) return true;
  if (t.contains('^') || t.contains('_') || t.contains(r'$')) return true;
  if (RegExp(r'[(){}\[\]\+\-\*/=]').hasMatch(t)) return true;

  return false;
}

bool containsCjkText(String s) {
  for (final codeUnit in s.codeUnits) {
    if (_isCjkTextCodeUnit(codeUnit)) return true;
  }
  return false;
}

bool shouldSplitMixedCjkAndLatex(String paragraph) {
  final trimmed = paragraph.trim();
  if (trimmed.isEmpty) return false;
  if (paragraph.contains(r'$')) return false;
  if (paragraph.contains(r'\text{')) return false;
  if (!containsCjkText(paragraph)) return false;
  if (!looksLikeMath(trimmed)) return false;
  if (isDelimitedMathOnly(trimmed)) return false;
  if (texMacrosAreOnlyInsideDollarSpans(paragraph)) return false;
  return containsRecognizedTexMacros(paragraph);
}

/// True when every `\macro` sits inside a `$...$` / `$$...$$` span (dollar handler can render it).
bool texMacrosAreOnlyInsideDollarSpans(String paragraph) {
  if (!paragraph.contains(r'$')) return false;

  var withoutDollarSpans = paragraph;
  withoutDollarSpans = withoutDollarSpans.replaceAll(
    RegExp(r'\$\$[^$]+\$\$', dotAll: true),
    '',
  );
  withoutDollarSpans = withoutDollarSpans.replaceAll(RegExp(r'\$[^$]+\$'), '');
  return !containsRecognizedTexMacros(withoutDollarSpans);
}

/// True when [text] contains a TeX command (`\frac`, `\lim`, …), not JSON `\n` artifacts.
bool containsRecognizedTexMacros(String text) {
  if (!text.contains(r'\')) return false;

  for (var i = 0; i < text.length - 1; i++) {
    if (text.codeUnitAt(i) != _backslash) continue;

    final next = text[i + 1];
    if (next == 'n' || next == 't' || next == 'r') {
      if (_isLatexMacroContinuationAfterEsc(next, text.substring(i + 2))) {
        return true;
      }
      continue;
    }

    if (!_isAsciiLetter(text.codeUnitAt(i + 1))) continue;

    var j = i + 1;
    while (j < text.length && _isAsciiLetter(text.codeUnitAt(j))) {
      j++;
    }
    if (j > i + 1) return true;
  }
  return false;
}

/// Splits a paragraph into plain text and inline TeX when Japanese and macros are mixed.
List<MixedTextSegment> segmentMixedCjkAndLatex(String paragraph) {
  final segments = <MixedTextSegment>[];
  var i = 0;

  while (i < paragraph.length) {
    if (paragraph.codeUnitAt(i) == _backslash) {
      final end = _findTexCommandSpanEnd(paragraph, i);
      if (end != null && end > i) {
        final tex = paragraph.substring(i, end).trim();
        if (tex.isEmpty) {
          i = end;
          continue;
        }
        segments.add(
          MixedTextSegment(kind: MixedTextSegmentKind.inlineMath, text: tex),
        );
        i = end;
        continue;
      }
    }

    final plainStart = i;
    i++;
    while (i < paragraph.length) {
      if (paragraph.codeUnitAt(i) == _backslash) {
        final end = _findTexCommandSpanEnd(paragraph, i);
        if (end != null && end > i) break;
      }
      i++;
    }

    final plain = paragraph.substring(plainStart, i);
    if (plain.isNotEmpty) {
      segments.add(
        MixedTextSegment(kind: MixedTextSegmentKind.plain, text: plain),
      );
    }
  }

  return _mergeAdjacentPlainSegments(segments);
}

List<MixedTextSegment> _mergeAdjacentPlainSegments(List<MixedTextSegment> input) {
  if (input.isEmpty) return input;

  final out = <MixedTextSegment>[];
  for (final segment in input) {
    if (out.isNotEmpty &&
        out.last.kind == MixedTextSegmentKind.plain &&
        segment.kind == MixedTextSegmentKind.plain) {
      final last = out.removeLast();
      out.add(
        MixedTextSegment(
          kind: MixedTextSegmentKind.plain,
          text: last.text + segment.text,
        ),
      );
    } else {
      out.add(segment);
    }
  }
  return out;
}

int? _findTexCommandSpanEnd(String s, int start) {
  if (start >= s.length || s.codeUnitAt(start) != _backslash) return null;

  var i = start + 1;
  if (i >= s.length) return null;

  var commandStart = i;
  while (i < s.length && _isAsciiLetter(s.codeUnitAt(i))) {
    i++;
  }
  if (i == commandStart) return null;

  if (i < s.length && s.codeUnitAt(i) == 0x2a) i++;

  while (i < s.length && _isInlineWhitespace(s.codeUnitAt(i))) {
    i++;
  }

  while (i < s.length && s.codeUnitAt(i) == _openBrace) {
    final end = _findBalancedBraceEnd(s, i);
    if (end < 0) break;
    i = end + 1;
    while (i < s.length && _isInlineWhitespace(s.codeUnitAt(i))) {
      i++;
    }
  }

  while (i < s.length &&
      (s.codeUnitAt(i) == 0x5e || s.codeUnitAt(i) == 0x5f)) {
    i++;
    if (i < s.length && s.codeUnitAt(i) == _openBrace) {
      final end = _findBalancedBraceEnd(s, i);
      if (end < 0) break;
      i = end + 1;
    } else if (i < s.length) {
      i++;
    }
  }

  return i > start + 1 ? i : null;
}

int _findBalancedBraceEnd(String tex, int openIndex) {
  var depth = 0;
  for (var i = openIndex; i < tex.length; i++) {
    final codeUnit = tex.codeUnitAt(i);
    if (codeUnit == _backslash) {
      i++;
      continue;
    }
    if (codeUnit == _openBrace) depth++;
    if (codeUnit == _closeBrace) {
      depth--;
      if (depth == 0) return i;
    }
  }
  return -1;
}

bool _isAsciiLetter(int codeUnit) {
  return (codeUnit >= 0x41 && codeUnit <= 0x5a) ||
      (codeUnit >= 0x61 && codeUnit <= 0x7a);
}

bool _isInlineWhitespace(int codeUnit) {
  return codeUnit == 0x20 || codeUnit == 0x09 || codeUnit == 0x0a;
}

bool _isCjkTextCodeUnit(int codeUnit) {
  return (codeUnit >= 0x3040 && codeUnit <= 0x30ff) ||
      (codeUnit >= 0x3400 && codeUnit <= 0x4dbf) ||
      (codeUnit >= 0x4e00 && codeUnit <= 0x9fff) ||
      (codeUnit >= 0xf900 && codeUnit <= 0xfaff) ||
      codeUnit == 0x3005 ||
      codeUnit == 0x3007;
}

/// Strips trailing TeX spacing commands that become invalid when [MixedTextMath]
/// splits on `\text{...}` and renders the prefix without the following macro body.
///
/// Example: `...\sin(\omega t) \ \ ` → `...\sin(\omega t)` (valid for [Math.tex]).
String trimDanglingTrailingTexSpacing(String tex) {
  var t = tex.trimRight();
  while (true) {
    final before = t;
    if (t.endsWith(r'\quad')) {
      t = t.substring(0, t.length - 5).trimRight();
      continue;
    }
    if (t.endsWith(r'\qquad')) {
      t = t.substring(0, t.length - 6).trimRight();
      continue;
    }
    if (t.endsWith(r'\,')) {
      t = t.substring(0, t.length - 2).trimRight();
      continue;
    }
    if (RegExp(r'\\\s$').hasMatch(t)) {
      t = t.substring(0, t.length - 2).trimRight();
      continue;
    }
    if (t.endsWith(r'\')) {
      t = t.substring(0, t.length - 1).trimRight();
      continue;
    }
    if (t == before) break;
  }
  return t;
}

/// Builds a `cases` block for physics-math equation + conditions (same layout as
/// [PhysicsMathCaseDisplay]).
String buildPhysicsMathCasesTex({
  required String equation,
  required String conditions,
  String? constants,
}) {
  final conditionLines = conditions.split(RegExp(r'\\\\\s*(?!\[)'));
  final trimmedLines = conditionLines
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();
  final normalizedConditions = trimmedLines.join(r' \\[4pt] ');

  if (constants != null && constants.trim().isNotEmpty) {
    return r"""
\begin{cases}
$equation \\[4pt]
$conditions \\[4pt]
$constants
\end{cases}
"""
        .replaceAll('\$equation', equation.trim())
        .replaceAll('\$conditions', normalizedConditions)
        .replaceAll('\$constants', constants.trim());
  }

  return r"""
\begin{cases}
$equation \\[4pt]
$conditions
\end{cases}
"""
      .replaceAll('\$equation', equation.trim())
      .replaceAll('\$conditions', normalizedConditions);
}
