// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '物理ガチャ';

  @override
  String get problemList => '問題一覧';

  @override
  String get spinGacha => 'ガチャを回す';

  @override
  String get hint => 'ヒント';

  @override
  String get hideHint => 'ヒントを隠す';

  @override
  String get showAnswer => '答えを見る';

  @override
  String get hideAnswer => '答えを隠す';

  @override
  String get askAi => 'AIに聞く';

  @override
  String get calculator => '電卓';

  @override
  String get closeCalculator => '電卓を閉じる';

  @override
  String get answerLabel => '答え';

  @override
  String answerWithValue(String value) {
    return '答え　$value';
  }

  @override
  String get approach => '方針';

  @override
  String get firstStep => '最初の一手';

  @override
  String get explanation => '解説';

  @override
  String get detail => '詳細';

  @override
  String get noMatchingProblems => '該当する問題がありません';

  @override
  String get noProblemsAvailable => '出題できる問題がありません。単元をオンにするか、除外を緩めてください。';

  @override
  String get filterSettings => 'フィルタ設定';

  @override
  String get exclusionNone => '除外なし';

  @override
  String exclusionNoneWithTotal(int total) {
    return '除外なし 全$total問';
  }

  @override
  String exclusionLatestPrefix(int count) {
    return '最新$count回が';
  }

  @override
  String get exclusionThenRemoveFromGacha => 'ならガチャから外す';

  @override
  String get exclusionThenExcludeProblems => 'の問題を除く';

  @override
  String totalProblems(int total) {
    return '全$total問';
  }

  @override
  String remainingProblems(int remaining, int total) {
    return '(残 $remaining問/$total問)';
  }

  @override
  String get domainMechanics => '力学';

  @override
  String get domainThermodynamics => '熱力学';

  @override
  String get domainWaves => '波動';

  @override
  String get domainElectromagnetism => '電磁気学';

  @override
  String get domainAtom => '原子';

  @override
  String get slotEmpty => '空';

  @override
  String get slotSolved => '解決済み';

  @override
  String get slotUnderstood => '理解済み';

  @override
  String get slotFailed => '失敗';

  @override
  String get autoRecordBoth => '一致で正解、不一致でバツを自動登録';

  @override
  String get autoRecordCorrectOnly => '一致のときだけ正解を自動登録';

  @override
  String get autoRecordOff => '自動履歴登録をしない';

  @override
  String get exclusionModeNone => '除外なし';

  @override
  String get exclusionModeLatest1 => '最新1回が緑なら除く';

  @override
  String get exclusionModeLatest2 => '最新2回が緑なら除く';

  @override
  String get exclusionModeLatest3 => '最新3回が緑なら除く';

  @override
  String get dimensionless => '無次元';

  @override
  String get toUnits => '単位へ';

  @override
  String get backToNumbers => '数値へ戻る';

  @override
  String get confirm => '確定';

  @override
  String get selectUnit => '単位を選ぶ';

  @override
  String get assembleUnitHint => 'kg m s^-1 のように組み立てる';

  @override
  String get symbolOrderHint => '短い順に左から';

  @override
  String get cloudLogin => 'クラウドにログイン';

  @override
  String get account => 'アカウント';

  @override
  String get signedIn => 'ログイン中';

  @override
  String get cloudSyncOn => 'クラウド同期: オン';

  @override
  String get cloudSyncOff => 'クラウド同期: オフ';

  @override
  String get syncNow => '今すぐ同期';

  @override
  String get deleteAccount => 'アカウント削除';

  @override
  String get signOut => 'ログアウト';

  @override
  String get cloudSyncEnabled => 'クラウド同期をオンにしました。';

  @override
  String get cloudSyncDisabled => 'クラウド同期をオフにしました。';

  @override
  String get synced => '同期しました。';

  @override
  String syncFailed(String error) {
    return '同期に失敗しました: $error';
  }

  @override
  String get signedOut => 'ログアウトしました。';

  @override
  String get cloudSyncTitle => 'クラウドと同期';

  @override
  String get cloudSyncBody => 'ログインすると、学習履歴とガチャ設定をクラウドに保存・復元できます。';

  @override
  String get back => '戻る';

  @override
  String get continueWithApple => 'Appleで続行';

  @override
  String get continueWithGoogle => 'Googleで続行';

  @override
  String signedInWithMethod(String method) {
    return '$methodでログインしました。クラウド同期をオンにしました。';
  }

  @override
  String get appleSignInFailed => 'Appleでのログインに失敗しました。';

  @override
  String googleSignInFailed(String error) {
    return 'Googleでのログインに失敗しました: $error';
  }

  @override
  String get deleteAccountTitle => 'アカウントを削除';

  @override
  String get deleteAccountBody => 'アカウントとクラウド上の学習履歴・ガチャ設定を削除します。この操作は取り消せません。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除する';

  @override
  String get deletingAccount => 'アカウントを削除しています…';

  @override
  String get accountDeleted => 'アカウントを削除しました。';

  @override
  String get deleteFailedTitle => '削除に失敗しました';

  @override
  String get close => '閉じる';

  @override
  String get reauthGoogle => 'アカウント削除を続けるには、Googleで再度認証してください。';

  @override
  String get reauthApple => 'アカウント削除を続けるには、Appleアカウントで再度認証してください。';

  @override
  String get reauthenticating => '再認証しています…';

  @override
  String get reauthUnavailableTitle => '再認証できません';

  @override
  String get reauthUnavailableBody =>
      'ログイン方法を確認できませんでした。一度ログアウトしてから、もう一度ログインしてください。';

  @override
  String reauthFailed(String error) {
    return '再認証に失敗しました: $error';
  }

  @override
  String get identityConfirmTitle => '本人確認';

  @override
  String get continueAction => '続行';

  @override
  String get accountDeletionEndpointMissing => 'アカウント削除の接続先が設定されていません。';

  @override
  String get accountDeletionAuthMissing => 'ログイン状態を確認できませんでした。';

  @override
  String get accountDeletionFailed => 'アカウント削除に失敗しました。';

  @override
  String get accountDeletionTimeout => '通信に時間がかかっています。しばらくしてからもう一度お試しください。';

  @override
  String get accountDeletionRequiresLogin => 'アカウント削除にはログインが必要です。';

  @override
  String get reauthCancelled => '再認証がキャンセルされました。';

  @override
  String get aiGreeting => 'この問題について聞いてみてください。';

  @override
  String get aiPlaceholder => '聞きたいことを書いてください';

  @override
  String get aiSend => '送信';

  @override
  String get aiMoreDetail => 'もう少し詳しく';

  @override
  String get aiGenericError => 'AIの応答に失敗しました。もう一度試してください。';

  @override
  String get aiStarterHint => 'ヒントを教えて';

  @override
  String get aiStarterApproach => '方針だけ教えて';

  @override
  String get aiStarterFirstStep => '最初の一手だけ教えて';

  @override
  String aiFreeLimitReached(int limit) {
    return '今月の無料利用（$limit回）に達しました。';
  }

  @override
  String aiPaidLimitReached(int limit) {
    return 'AIパスの利用上限（$limit回）に達しました。';
  }

  @override
  String get aiVoiceListening => '聞いています…';

  @override
  String get aiVoiceSendAuto => '音声を自動送信';

  @override
  String get aiVoiceSendManual => '送信前に編集';

  @override
  String get aiVoiceSendAutoLabel => '自動送信';

  @override
  String get aiVoiceSendManualLabel => '手動';

  @override
  String get aiVoicePermissionDenied => '音声入力にはマイクの許可が必要です。';

  @override
  String get figureObjectA => '物体A';

  @override
  String get figureObjectB => '物体B';

  @override
  String get figureObjectC => '物体C';

  @override
  String get figureExternalForce => '外力';

  @override
  String get figureInitialSpeed => '初速';

  @override
  String get figureAntinode => '腹';

  @override
  String get figureNode => '節';

  @override
  String get figureWall => '壁';

  @override
  String get figureOpenPipe => '開管';

  @override
  String get figureSpring => 'ばね';

  @override
  String get figureSmallMass => '小物体';

  @override
  String get figureString => '糸';

  @override
  String get figureBefore => 'はじめ';

  @override
  String get figureAfter => 'あと';

  @override
  String get figureIsothermal => '等温';

  @override
  String get figureIsobaric => '等圧';

  @override
  String get figureIsochoric => '等積';

  @override
  String get figureAdiabatic => '断熱圧縮';

  @override
  String get figureSun => '太陽';

  @override
  String get hintUnavailableEn => '英語のヒントはまだありません。';
}
