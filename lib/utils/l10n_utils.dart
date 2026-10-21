import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';
import '../models/physics_problem.dart';
import '../services/problems/translation_manager.dart';
import 'locale_utils.dart';

bool isEnglishLocale(BuildContext context) =>
    Localizations.localeOf(context).languageCode.toLowerCase() != 'ja';

String _localeTag(BuildContext context) =>
    Localizations.localeOf(context).toLanguageTag();

extension PhysicsProblemLocalization on PhysicsProblem {
  String getLocalizedTheme(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.theme ?? theme;
  }

  String getLocalizedStatement(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.statement ?? statement;
  }

  String getLocalizedHint(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    if (t?.hint != null) return t!.hint!;
    if (isEnglishLocale(context)) {
      return AppLocalizations.of(context)!.hintUnavailableEn;
    }
    return hint;
  }

  String getLocalizedApproach(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.approach ?? approach;
  }

  String getLocalizedFirstStep(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.firstStep ?? firstStep;
  }

  String getLocalizedExplanation(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.explanation ?? explanation;
  }

  String getLocalizedAnswerDisplay(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.answerDisplay ?? answerDisplay;
  }

  List<String> getLocalizedSymbolChoices(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.symbolChoices ?? symbolChoices;
  }

  String getLocalizedSymbolOrder(BuildContext context) {
    final t = TranslationManager.getTranslation(_localeTag(context), id);
    return t?.symbolOrder ?? symbolOrder;
  }

  String getLocalizedAnswerUnitLabel(BuildContext context) {
    if (isSymbolOrder) return '';
    if (isDimensionless) {
      return AppLocalizations.of(context)!.dimensionless;
    }
    return answerUnit;
  }
}

/// 並べた名称を解答表示にする。英語はカンマ、日本語は読点。
String formatSymbolOrder(List<String> tokens, BuildContext context) {
  if (tokens.isEmpty) return '';
  return tokens.join(isEnglishLocale(context) ? ', ' : '、');
}

/// Resolve l10n without a BuildContext (auth / services).
AppLocalizations appL10nWithoutContext() {
  final locale = resolveAppLocale(
        WidgetsBinding.instance.platformDispatcher.locale,
        AppLocalizations.supportedLocales,
      ) ??
      const Locale('en');
  return lookupAppLocalizations(locale);
}
