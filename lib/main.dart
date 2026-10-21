import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'ui/gacha_page.dart';
import 'ui/store_shot_tour.dart';
import 'utils/locale_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeFirebase();
  runApp(const PhysicsGachaApp());
}

Future<void> _initializeFirebase() async {
  if (kIsWeb) return;

  try {
    // Placeholders → native google-services.json / GoogleService-Info.plist.
    if (DefaultFirebaseOptions.hasPlaceholders) {
      await Firebase.initializeApp();
    } else {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }
    await _activateFirebaseAppCheck();
  } catch (error, stack) {
    debugPrint('[Firebase] init failed: $error');
    debugPrint('$stack');
  }
}

Future<void> _activateFirebaseAppCheck() async {
  await FirebaseAppCheck.instance.activate(
    androidProvider:
        kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    appleProvider: kDebugMode
        ? AppleProvider.debug
        : AppleProvider.appAttestWithDeviceCheckFallback,
  );
}

class PhysicsGachaApp extends StatelessWidget {
  const PhysicsGachaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final forcedLocale = storeShotLocale();
    return MaterialApp(
      debugShowCheckedModeBanner: !storeShotsEnabled,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: forcedLocale,
      localeResolutionCallback:
          forcedLocale == null ? resolveAppLocale : null,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1565C0)),
        useMaterial3: true,
      ),
      home: const GachaPage(),
    );
  }
}
