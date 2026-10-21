import 'package:flutter/widgets.dart';

import '../l10n/app_localizations.dart';

/// Figure paint labels resolved from the current locale.
class FigureLabels {
  FigureLabels._(this._l10n);

  final AppLocalizations _l10n;

  factory FigureLabels.of(BuildContext context) =>
      FigureLabels._(AppLocalizations.of(context)!);

  factory FigureLabels.fromLocale(Locale locale) =>
      FigureLabels._(lookupAppLocalizations(locale));

  String get objectA => _l10n.figureObjectA;
  String get objectB => _l10n.figureObjectB;
  String get objectC => _l10n.figureObjectC;
  String get externalForce => _l10n.figureExternalForce;
  String get initialSpeed => _l10n.figureInitialSpeed;
  String get antinode => _l10n.figureAntinode;
  String get node => _l10n.figureNode;
  String get wall => _l10n.figureWall;
  String get openPipe => _l10n.figureOpenPipe;
  String get spring => _l10n.figureSpring;
  String get smallMass => _l10n.figureSmallMass;
  String get string => _l10n.figureString;
  String get before => _l10n.figureBefore;
  String get after => _l10n.figureAfter;
  String get isothermal => _l10n.figureIsothermal;
  String get isobaric => _l10n.figureIsobaric;
  String get isochoric => _l10n.figureIsochoric;
  String get adiabatic => _l10n.figureAdiabatic;
  String get sun => _l10n.figureSun;
}
