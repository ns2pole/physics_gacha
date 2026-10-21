import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:physics_gacha/integrations/ai_chat/physics_ai_chat_ports.dart';
import 'package:physics_gacha/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('スターターはヒント・方針・最初の一手（日本語）', (tester) async {
    final dispatcher = TestWidgetsFlutterBinding.instance.platformDispatcher;
    dispatcher.localeTestValue = const Locale('ja');
    dispatcher.localesTestValue = const [Locale('ja')];
    addTearDown(() {
      dispatcher.clearLocaleTestValue();
      dispatcher.clearLocalesTestValue();
    });

    late List<String> labels;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ja'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            const ports = PhysicsAiChatPorts();
            final replies = ports.starterQuickReplies('any-id');
            labels = replies!.map((r) => r.label).toList();
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(labels, [
      'ヒントを教えて',
      '方針だけ教えて',
      '最初の一手だけ教えて',
    ]);
  });

  testWidgets('スターターは英語端末で英語', (tester) async {
    late List<String> labels;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            final ports = PhysicsAiChatPorts();
            // Force EN via stringsFor since ports.strings uses platform locale.
            final s = PhysicsAiChatPorts.stringsFor(
              AppLocalizations.of(context)!,
            );
            labels = [
              s.starterChoiceHint,
              s.starterChoiceApproach,
              s.starterChoiceFirstStep,
            ];
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(labels, [
      'Give me a hint',
      'Tell me only the approach',
      'Tell me only the first step',
    ]);
  });

  testWidgets('課金 UI は出さない', (tester) async {
    const ports = PhysicsAiChatPorts();
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            final offer = ports.buildUpgradeOffer(
              context,
              limitInfo: const AiChatRateLimitInfo(
                message: 'limit',
                tier: 'free',
                usageLimit: 15,
              ),
              isRestoring: false,
              onPurchase: () {},
              onRestore: () {},
            );
            expect(offer, isNull);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
