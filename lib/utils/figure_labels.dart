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
  String get cylinderHeight => _l10n.figureCylinderHeight;
  String get cylinderRadius => _l10n.figureCylinderRadius;
  String get placedBefore => _l10n.figurePlacedBefore;
  String get placedAfter => _l10n.figurePlacedAfter;
  String get fromSide => _l10n.figureFromSide;
  String get isothermal => _l10n.figureIsothermal;
  String get isobaric => _l10n.figureIsobaric;
  String get isochoric => _l10n.figureIsochoric;
  String get adiabatic => _l10n.figureAdiabatic;
  String get sun => _l10n.figureSun;
  String get earth => _l10n.figureEarth;
  String get moon => _l10n.figureMoon;
  String get satellite => _l10n.figureSatellite;
  String get water => _l10n.figureWater;
  String get insulated => _l10n.figureInsulated;
  String get naturalLength => _l10n.figureNaturalLength;
  String diameterCm(String value) => _l10n.figureDiameterCm(value);
  String airTemp(String temp) => _l10n.figureAirTemp(temp);
  String get hundredTurnsCompact => _l10n.figureHundredTurnsCompact;
  String get hundredTurns => _l10n.figureHundredTurns;
  String get currentI => _l10n.figureCurrentI;
  String get oneYear => _l10n.figureOneYear;
  String get leftHalf => _l10n.figureLeftHalf;
  String get upperRight => _l10n.figureUpperRight;
}
