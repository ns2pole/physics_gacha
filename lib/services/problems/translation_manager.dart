import '../../data/translations/en/sample_problems_en.dart';
import '../../models/problem_translation.dart';

/// Looks up English overlays by problem id.
class TranslationManager {
  TranslationManager._();

  static final Map<String, List<Map<String, ProblemTranslation>>> _sources = {
    'en': [sampleProblemsTranslationsEn],
    'ja': const [],
  };

  static ProblemTranslation? getTranslation(String localeTag, String id) {
    final lang = localeTag.split(RegExp('[-_]')).first.toLowerCase();
    final maps = _sources[lang];
    if (maps == null) return null;
    for (final map in maps) {
      final hit = map[id];
      if (hit != null) return hit;
    }
    return null;
  }
}
