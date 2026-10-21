import 'package:flutter/widgets.dart';

/// テストでは止め、実機ではループさせる。
bool get figureClockRuns => !WidgetsBinding.instance.runtimeType
    .toString()
    .contains('TestWidgetsFlutterBinding');

/// [motion] まで動かし、残りは止まった絵のまま。
double playPauseProgress(double raw, {double motion = 0.82}) {
  if (raw >= motion) return 1.0;
  return raw / motion;
}
