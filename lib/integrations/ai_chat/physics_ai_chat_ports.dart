import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter/widgets.dart';

import '../../l10n/app_localizations.dart';
import '../../utils/l10n_utils.dart';
import 'physics_ai_chat_client_factory.dart';

/// Localized AI chrome strings. Billing UI is not shown.
class PhysicsAiChatPorts implements AiChatHostPorts {
  const PhysicsAiChatPorts();

  static AiChatStrings stringsFor(AppLocalizations l10n) {
    return AiChatStrings(
      greeting: l10n.aiGreeting,
      placeholder: l10n.aiPlaceholder,
      send: l10n.aiSend,
      moreDetail: l10n.aiMoreDetail,
      genericError: l10n.aiGenericError,
      starterChoiceHint: l10n.aiStarterHint,
      starterChoiceApproach: l10n.aiStarterApproach,
      starterChoiceFirstStep: l10n.aiStarterFirstStep,
      freeMonthlyLimitReached: l10n.aiFreeLimitReached,
      paidPassLimitReached: l10n.aiPaidLimitReached,
      voiceListeningHint: l10n.aiVoiceListening,
      voiceSendModeAuto: l10n.aiVoiceSendAuto,
      voiceSendModeManual: l10n.aiVoiceSendManual,
      voiceSendModeAutoLabel: l10n.aiVoiceSendAutoLabel,
      voiceSendModeManualLabel: l10n.aiVoiceSendManualLabel,
      voicePermissionDenied: l10n.aiVoicePermissionDenied,
    );
  }

  @override
  AiChatStrings get strings => stringsFor(appL10nWithoutContext());

  @override
  Future<Map<String, String>> authHeaders() =>
      PhysicsAiChatClientFactory.authHeaders();

  @override
  List<AiChatQuickReply>? starterQuickReplies(String? contentId) {
    final s = strings;
    return [
      AiChatQuickReply(
        label: s.starterChoiceHint,
        sendText: s.starterChoiceHint,
      ),
      AiChatQuickReply(
        label: s.starterChoiceApproach,
        sendText: s.starterChoiceApproach,
      ),
      AiChatQuickReply(
        label: s.starterChoiceFirstStep,
        sendText: s.starterChoiceFirstStep,
      ),
    ];
  }

  @override
  Widget? buildUpgradeOffer(
    BuildContext context, {
    required AiChatRateLimitInfo limitInfo,
    required bool isRestoring,
    required VoidCallback onPurchase,
    required VoidCallback onRestore,
  }) =>
      null;

  @override
  Future<AiChatUpgradeResult> purchaseUpgrade(BuildContext context) async {
    return const AiChatUpgradeResult(success: false);
  }

  @override
  Future<AiChatUpgradeResult> restoreUpgrade(BuildContext context) async {
    return const AiChatUpgradeResult(success: false);
  }
}
