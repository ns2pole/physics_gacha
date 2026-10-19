import 'package:ai_chat_kit/ai_chat_kit.dart';
import 'package:flutter/widgets.dart';

import 'physics_ai_chat_client_factory.dart';

/// 日本語文言・App Check ヘッダ・スターターチップ。課金 UI は出さない。
class PhysicsAiChatPorts implements AiChatHostPorts {
  const PhysicsAiChatPorts();

  static const AiChatStrings japaneseStrings = AiChatStrings(
    greeting: 'この問題について聞いてみてください。',
    placeholder: '聞きたいことを書いてください',
    send: '送信',
    moreDetail: 'もう少し詳しく',
    genericError: 'AIの応答に失敗しました。もう一度試してください。',
    starterChoiceHint: 'ヒントを教えて',
    starterChoiceApproach: '方針だけ教えて',
    starterChoiceFirstStep: '最初の一手だけ教えて',
    freeMonthlyLimitReached: _freeMonthlyLimitReached,
    paidPassLimitReached: _paidPassLimitReached,
    voiceListeningHint: '聞いています…',
    voiceSendModeAuto: '音声を自動送信',
    voiceSendModeManual: '送信前に編集',
    voiceSendModeAutoLabel: '自動送信',
    voiceSendModeManualLabel: '手動',
    voicePermissionDenied: '音声入力にはマイクの許可が必要です。',
  );

  static String _freeMonthlyLimitReached(int limit) =>
      '今月の無料利用（$limit回）に達しました。';

  static String _paidPassLimitReached(int limit) =>
      'AIパスの利用上限（$limit回）に達しました。';

  @override
  AiChatStrings get strings => japaneseStrings;

  @override
  Future<Map<String, String>> authHeaders() =>
      PhysicsAiChatClientFactory.authHeaders();

  @override
  List<AiChatQuickReply>? starterQuickReplies(String? contentId) {
    return [
      AiChatQuickReply(
        label: strings.starterChoiceHint,
        sendText: strings.starterChoiceHint,
      ),
      AiChatQuickReply(
        label: strings.starterChoiceApproach,
        sendText: strings.starterChoiceApproach,
      ),
      AiChatQuickReply(
        label: strings.starterChoiceFirstStep,
        sendText: strings.starterChoiceFirstStep,
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
