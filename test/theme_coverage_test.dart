import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/data/sample_problems.dart';
import 'package:physics_gacha/data/theme_catalog.dart';

void main() {
  test('テーマは下敷きの項目で、チェック表と一致する', () {
    final names = coverageThemes.map((theme) => theme.name).toList();
    expect(names.length, names.toSet().length);

    final byTheme = <String, List<String>>{};
    for (final problem in sampleProblems) {
      expect(names, contains(problem.theme), reason: problem.id);
      byTheme.putIfAbsent(problem.theme, () => []).add(problem.id);
    }

    final duplicated = [
      for (final theme in coverageThemes)
        if (theme.onSheet && (byTheme[theme.name]?.length ?? 0) > 1) theme.name,
    ];
    expect(duplicated, ['仕事とエネルギー']);

    final listed = <String>[];
    final checked = <String, String>{};
    final pattern = RegExp(r'^- \[([ x])\] (.+?)(?: — (.+))?$');
    for (final line in File('docs/theme-coverage.md').readAsLinesSync()) {
      final match = pattern.firstMatch(line);
      if (match == null) continue;
      final name = match.group(2)!;
      listed.add(name);
      if (match.group(1) == 'x') {
        checked[name] = match.group(3) ?? '';
      }
    }

    expect(listed, names);
    for (final theme in coverageThemes) {
      final ids = byTheme[theme.name];
      if (ids == null) {
        expect(checked.containsKey(theme.name), isFalse, reason: theme.name);
      } else {
        expect(checked[theme.name], ids.join(', '), reason: theme.name);
      }
    }
  });
}
