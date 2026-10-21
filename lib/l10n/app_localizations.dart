import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In ja, this message translates to:
  /// **'物理ガチャ'**
  String get appTitle;

  /// No description provided for @problemList.
  ///
  /// In ja, this message translates to:
  /// **'問題一覧'**
  String get problemList;

  /// No description provided for @spinGacha.
  ///
  /// In ja, this message translates to:
  /// **'ガチャを回す'**
  String get spinGacha;

  /// No description provided for @hint.
  ///
  /// In ja, this message translates to:
  /// **'ヒント'**
  String get hint;

  /// No description provided for @hideHint.
  ///
  /// In ja, this message translates to:
  /// **'ヒントを隠す'**
  String get hideHint;

  /// No description provided for @showAnswer.
  ///
  /// In ja, this message translates to:
  /// **'答えを見る'**
  String get showAnswer;

  /// No description provided for @hideAnswer.
  ///
  /// In ja, this message translates to:
  /// **'答えを隠す'**
  String get hideAnswer;

  /// No description provided for @askAi.
  ///
  /// In ja, this message translates to:
  /// **'AIに聞く'**
  String get askAi;

  /// No description provided for @calculator.
  ///
  /// In ja, this message translates to:
  /// **'電卓'**
  String get calculator;

  /// No description provided for @closeCalculator.
  ///
  /// In ja, this message translates to:
  /// **'電卓を閉じる'**
  String get closeCalculator;

  /// No description provided for @answerLabel.
  ///
  /// In ja, this message translates to:
  /// **'答え'**
  String get answerLabel;

  /// No description provided for @answerWithValue.
  ///
  /// In ja, this message translates to:
  /// **'答え　{value}'**
  String answerWithValue(String value);

  /// No description provided for @approach.
  ///
  /// In ja, this message translates to:
  /// **'方針'**
  String get approach;

  /// No description provided for @firstStep.
  ///
  /// In ja, this message translates to:
  /// **'最初の一手'**
  String get firstStep;

  /// No description provided for @explanation.
  ///
  /// In ja, this message translates to:
  /// **'解説'**
  String get explanation;

  /// No description provided for @detail.
  ///
  /// In ja, this message translates to:
  /// **'詳細'**
  String get detail;

  /// No description provided for @noMatchingProblems.
  ///
  /// In ja, this message translates to:
  /// **'該当する問題がありません'**
  String get noMatchingProblems;

  /// No description provided for @noProblemsAvailable.
  ///
  /// In ja, this message translates to:
  /// **'出題できる問題がありません。単元をオンにするか、除外を緩めてください。'**
  String get noProblemsAvailable;

  /// No description provided for @filterSettings.
  ///
  /// In ja, this message translates to:
  /// **'フィルタ設定'**
  String get filterSettings;

  /// No description provided for @exclusionNone.
  ///
  /// In ja, this message translates to:
  /// **'除外なし'**
  String get exclusionNone;

  /// No description provided for @exclusionNoneWithTotal.
  ///
  /// In ja, this message translates to:
  /// **'除外なし 全{total}問'**
  String exclusionNoneWithTotal(int total);

  /// No description provided for @exclusionLatestPrefix.
  ///
  /// In ja, this message translates to:
  /// **'最新{count}回が'**
  String exclusionLatestPrefix(int count);

  /// No description provided for @exclusionThenRemoveFromGacha.
  ///
  /// In ja, this message translates to:
  /// **'ならガチャから外す'**
  String get exclusionThenRemoveFromGacha;

  /// No description provided for @exclusionThenExcludeProblems.
  ///
  /// In ja, this message translates to:
  /// **'の問題を除く'**
  String get exclusionThenExcludeProblems;

  /// No description provided for @totalProblems.
  ///
  /// In ja, this message translates to:
  /// **'全{total}問'**
  String totalProblems(int total);

  /// No description provided for @remainingProblems.
  ///
  /// In ja, this message translates to:
  /// **'(残 {remaining}問/{total}問)'**
  String remainingProblems(int remaining, int total);

  /// No description provided for @domainMechanics.
  ///
  /// In ja, this message translates to:
  /// **'力学'**
  String get domainMechanics;

  /// No description provided for @domainThermodynamics.
  ///
  /// In ja, this message translates to:
  /// **'熱力学'**
  String get domainThermodynamics;

  /// No description provided for @domainWaves.
  ///
  /// In ja, this message translates to:
  /// **'波動'**
  String get domainWaves;

  /// No description provided for @domainElectromagnetism.
  ///
  /// In ja, this message translates to:
  /// **'電磁気学'**
  String get domainElectromagnetism;

  /// No description provided for @domainAtom.
  ///
  /// In ja, this message translates to:
  /// **'原子'**
  String get domainAtom;

  /// No description provided for @slotEmpty.
  ///
  /// In ja, this message translates to:
  /// **'空'**
  String get slotEmpty;

  /// No description provided for @slotSolved.
  ///
  /// In ja, this message translates to:
  /// **'解決済み'**
  String get slotSolved;

  /// No description provided for @slotUnderstood.
  ///
  /// In ja, this message translates to:
  /// **'理解済み'**
  String get slotUnderstood;

  /// No description provided for @slotFailed.
  ///
  /// In ja, this message translates to:
  /// **'失敗'**
  String get slotFailed;

  /// No description provided for @autoRecordBoth.
  ///
  /// In ja, this message translates to:
  /// **'一致で正解、不一致でバツを自動登録'**
  String get autoRecordBoth;

  /// No description provided for @autoRecordCorrectOnly.
  ///
  /// In ja, this message translates to:
  /// **'一致のときだけ正解を自動登録'**
  String get autoRecordCorrectOnly;

  /// No description provided for @autoRecordOff.
  ///
  /// In ja, this message translates to:
  /// **'自動履歴登録をしない'**
  String get autoRecordOff;

  /// No description provided for @exclusionModeNone.
  ///
  /// In ja, this message translates to:
  /// **'除外なし'**
  String get exclusionModeNone;

  /// No description provided for @exclusionModeLatest1.
  ///
  /// In ja, this message translates to:
  /// **'最新1回が緑なら除く'**
  String get exclusionModeLatest1;

  /// No description provided for @exclusionModeLatest2.
  ///
  /// In ja, this message translates to:
  /// **'最新2回が緑なら除く'**
  String get exclusionModeLatest2;

  /// No description provided for @exclusionModeLatest3.
  ///
  /// In ja, this message translates to:
  /// **'最新3回が緑なら除く'**
  String get exclusionModeLatest3;

  /// No description provided for @dimensionless.
  ///
  /// In ja, this message translates to:
  /// **'無次元'**
  String get dimensionless;

  /// No description provided for @toUnits.
  ///
  /// In ja, this message translates to:
  /// **'単位へ'**
  String get toUnits;

  /// No description provided for @backToNumbers.
  ///
  /// In ja, this message translates to:
  /// **'数値へ戻る'**
  String get backToNumbers;

  /// No description provided for @confirm.
  ///
  /// In ja, this message translates to:
  /// **'確定'**
  String get confirm;

  /// No description provided for @selectUnit.
  ///
  /// In ja, this message translates to:
  /// **'単位を選ぶ'**
  String get selectUnit;

  /// No description provided for @assembleUnitHint.
  ///
  /// In ja, this message translates to:
  /// **'kg m s^-1 のように組み立てる'**
  String get assembleUnitHint;

  /// No description provided for @symbolOrderHint.
  ///
  /// In ja, this message translates to:
  /// **'短い順に左から'**
  String get symbolOrderHint;

  /// No description provided for @cloudLogin.
  ///
  /// In ja, this message translates to:
  /// **'クラウドにログイン'**
  String get cloudLogin;

  /// No description provided for @account.
  ///
  /// In ja, this message translates to:
  /// **'アカウント'**
  String get account;

  /// No description provided for @signedIn.
  ///
  /// In ja, this message translates to:
  /// **'ログイン中'**
  String get signedIn;

  /// No description provided for @cloudSyncOn.
  ///
  /// In ja, this message translates to:
  /// **'クラウド同期: オン'**
  String get cloudSyncOn;

  /// No description provided for @cloudSyncOff.
  ///
  /// In ja, this message translates to:
  /// **'クラウド同期: オフ'**
  String get cloudSyncOff;

  /// No description provided for @syncNow.
  ///
  /// In ja, this message translates to:
  /// **'今すぐ同期'**
  String get syncNow;

  /// No description provided for @deleteAccount.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除'**
  String get deleteAccount;

  /// No description provided for @signOut.
  ///
  /// In ja, this message translates to:
  /// **'ログアウト'**
  String get signOut;

  /// No description provided for @cloudSyncEnabled.
  ///
  /// In ja, this message translates to:
  /// **'クラウド同期をオンにしました。'**
  String get cloudSyncEnabled;

  /// No description provided for @cloudSyncDisabled.
  ///
  /// In ja, this message translates to:
  /// **'クラウド同期をオフにしました。'**
  String get cloudSyncDisabled;

  /// No description provided for @synced.
  ///
  /// In ja, this message translates to:
  /// **'同期しました。'**
  String get synced;

  /// No description provided for @syncFailed.
  ///
  /// In ja, this message translates to:
  /// **'同期に失敗しました: {error}'**
  String syncFailed(String error);

  /// No description provided for @signedOut.
  ///
  /// In ja, this message translates to:
  /// **'ログアウトしました。'**
  String get signedOut;

  /// No description provided for @cloudSyncTitle.
  ///
  /// In ja, this message translates to:
  /// **'クラウドと同期'**
  String get cloudSyncTitle;

  /// No description provided for @cloudSyncBody.
  ///
  /// In ja, this message translates to:
  /// **'ログインすると、学習履歴とガチャ設定をクラウドに保存・復元できます。'**
  String get cloudSyncBody;

  /// No description provided for @back.
  ///
  /// In ja, this message translates to:
  /// **'戻る'**
  String get back;

  /// No description provided for @continueWithApple.
  ///
  /// In ja, this message translates to:
  /// **'Appleで続行'**
  String get continueWithApple;

  /// No description provided for @continueWithGoogle.
  ///
  /// In ja, this message translates to:
  /// **'Googleで続行'**
  String get continueWithGoogle;

  /// No description provided for @signedInWithMethod.
  ///
  /// In ja, this message translates to:
  /// **'{method}でログインしました。クラウド同期をオンにしました。'**
  String signedInWithMethod(String method);

  /// No description provided for @appleSignInFailed.
  ///
  /// In ja, this message translates to:
  /// **'Appleでのログインに失敗しました。'**
  String get appleSignInFailed;

  /// No description provided for @googleSignInFailed.
  ///
  /// In ja, this message translates to:
  /// **'Googleでのログインに失敗しました: {error}'**
  String googleSignInFailed(String error);

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In ja, this message translates to:
  /// **'アカウントとクラウド上の学習履歴・ガチャ設定を削除します。この操作は取り消せません。'**
  String get deleteAccountBody;

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除する'**
  String get delete;

  /// No description provided for @deletingAccount.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除しています…'**
  String get deletingAccount;

  /// No description provided for @accountDeleted.
  ///
  /// In ja, this message translates to:
  /// **'アカウントを削除しました。'**
  String get accountDeleted;

  /// No description provided for @deleteFailedTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除に失敗しました'**
  String get deleteFailedTitle;

  /// No description provided for @close.
  ///
  /// In ja, this message translates to:
  /// **'閉じる'**
  String get close;

  /// No description provided for @reauthGoogle.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除を続けるには、Googleで再度認証してください。'**
  String get reauthGoogle;

  /// No description provided for @reauthApple.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除を続けるには、Appleアカウントで再度認証してください。'**
  String get reauthApple;

  /// No description provided for @reauthenticating.
  ///
  /// In ja, this message translates to:
  /// **'再認証しています…'**
  String get reauthenticating;

  /// No description provided for @reauthUnavailableTitle.
  ///
  /// In ja, this message translates to:
  /// **'再認証できません'**
  String get reauthUnavailableTitle;

  /// No description provided for @reauthUnavailableBody.
  ///
  /// In ja, this message translates to:
  /// **'ログイン方法を確認できませんでした。一度ログアウトしてから、もう一度ログインしてください。'**
  String get reauthUnavailableBody;

  /// No description provided for @reauthFailed.
  ///
  /// In ja, this message translates to:
  /// **'再認証に失敗しました: {error}'**
  String reauthFailed(String error);

  /// No description provided for @identityConfirmTitle.
  ///
  /// In ja, this message translates to:
  /// **'本人確認'**
  String get identityConfirmTitle;

  /// No description provided for @continueAction.
  ///
  /// In ja, this message translates to:
  /// **'続行'**
  String get continueAction;

  /// No description provided for @accountDeletionEndpointMissing.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除の接続先が設定されていません。'**
  String get accountDeletionEndpointMissing;

  /// No description provided for @accountDeletionAuthMissing.
  ///
  /// In ja, this message translates to:
  /// **'ログイン状態を確認できませんでした。'**
  String get accountDeletionAuthMissing;

  /// No description provided for @accountDeletionFailed.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除に失敗しました。'**
  String get accountDeletionFailed;

  /// No description provided for @accountDeletionTimeout.
  ///
  /// In ja, this message translates to:
  /// **'通信に時間がかかっています。しばらくしてからもう一度お試しください。'**
  String get accountDeletionTimeout;

  /// No description provided for @accountDeletionRequiresLogin.
  ///
  /// In ja, this message translates to:
  /// **'アカウント削除にはログインが必要です。'**
  String get accountDeletionRequiresLogin;

  /// No description provided for @reauthCancelled.
  ///
  /// In ja, this message translates to:
  /// **'再認証がキャンセルされました。'**
  String get reauthCancelled;

  /// No description provided for @aiGreeting.
  ///
  /// In ja, this message translates to:
  /// **'この問題について聞いてみてください。'**
  String get aiGreeting;

  /// No description provided for @aiPlaceholder.
  ///
  /// In ja, this message translates to:
  /// **'聞きたいことを書いてください'**
  String get aiPlaceholder;

  /// No description provided for @aiSend.
  ///
  /// In ja, this message translates to:
  /// **'送信'**
  String get aiSend;

  /// No description provided for @aiMoreDetail.
  ///
  /// In ja, this message translates to:
  /// **'もう少し詳しく'**
  String get aiMoreDetail;

  /// No description provided for @aiGenericError.
  ///
  /// In ja, this message translates to:
  /// **'AIの応答に失敗しました。もう一度試してください。'**
  String get aiGenericError;

  /// No description provided for @aiStarterHint.
  ///
  /// In ja, this message translates to:
  /// **'ヒントを教えて'**
  String get aiStarterHint;

  /// No description provided for @aiStarterApproach.
  ///
  /// In ja, this message translates to:
  /// **'方針だけ教えて'**
  String get aiStarterApproach;

  /// No description provided for @aiStarterFirstStep.
  ///
  /// In ja, this message translates to:
  /// **'最初の一手だけ教えて'**
  String get aiStarterFirstStep;

  /// No description provided for @aiFreeLimitReached.
  ///
  /// In ja, this message translates to:
  /// **'今月の無料利用（{limit}回）に達しました。'**
  String aiFreeLimitReached(int limit);

  /// No description provided for @aiPaidLimitReached.
  ///
  /// In ja, this message translates to:
  /// **'AIパスの利用上限（{limit}回）に達しました。'**
  String aiPaidLimitReached(int limit);

  /// No description provided for @aiVoiceListening.
  ///
  /// In ja, this message translates to:
  /// **'聞いています…'**
  String get aiVoiceListening;

  /// No description provided for @aiVoiceSendAuto.
  ///
  /// In ja, this message translates to:
  /// **'音声を自動送信'**
  String get aiVoiceSendAuto;

  /// No description provided for @aiVoiceSendManual.
  ///
  /// In ja, this message translates to:
  /// **'送信前に編集'**
  String get aiVoiceSendManual;

  /// No description provided for @aiVoiceSendAutoLabel.
  ///
  /// In ja, this message translates to:
  /// **'自動送信'**
  String get aiVoiceSendAutoLabel;

  /// No description provided for @aiVoiceSendManualLabel.
  ///
  /// In ja, this message translates to:
  /// **'手動'**
  String get aiVoiceSendManualLabel;

  /// No description provided for @aiVoicePermissionDenied.
  ///
  /// In ja, this message translates to:
  /// **'音声入力にはマイクの許可が必要です。'**
  String get aiVoicePermissionDenied;

  /// No description provided for @figureObjectA.
  ///
  /// In ja, this message translates to:
  /// **'物体A'**
  String get figureObjectA;

  /// No description provided for @figureObjectB.
  ///
  /// In ja, this message translates to:
  /// **'物体B'**
  String get figureObjectB;

  /// No description provided for @figureObjectC.
  ///
  /// In ja, this message translates to:
  /// **'物体C'**
  String get figureObjectC;

  /// No description provided for @figureExternalForce.
  ///
  /// In ja, this message translates to:
  /// **'外力'**
  String get figureExternalForce;

  /// No description provided for @figureInitialSpeed.
  ///
  /// In ja, this message translates to:
  /// **'初速'**
  String get figureInitialSpeed;

  /// No description provided for @figureAntinode.
  ///
  /// In ja, this message translates to:
  /// **'腹'**
  String get figureAntinode;

  /// No description provided for @figureNode.
  ///
  /// In ja, this message translates to:
  /// **'節'**
  String get figureNode;

  /// No description provided for @figureWall.
  ///
  /// In ja, this message translates to:
  /// **'壁'**
  String get figureWall;

  /// No description provided for @figureOpenPipe.
  ///
  /// In ja, this message translates to:
  /// **'開管'**
  String get figureOpenPipe;

  /// No description provided for @figureSpring.
  ///
  /// In ja, this message translates to:
  /// **'ばね'**
  String get figureSpring;

  /// No description provided for @figureSmallMass.
  ///
  /// In ja, this message translates to:
  /// **'小物体'**
  String get figureSmallMass;

  /// No description provided for @figureString.
  ///
  /// In ja, this message translates to:
  /// **'糸'**
  String get figureString;

  /// No description provided for @figureBefore.
  ///
  /// In ja, this message translates to:
  /// **'はじめ'**
  String get figureBefore;

  /// No description provided for @figureAfter.
  ///
  /// In ja, this message translates to:
  /// **'あと'**
  String get figureAfter;

  /// No description provided for @figureIsothermal.
  ///
  /// In ja, this message translates to:
  /// **'等温'**
  String get figureIsothermal;

  /// No description provided for @figureIsobaric.
  ///
  /// In ja, this message translates to:
  /// **'等圧'**
  String get figureIsobaric;

  /// No description provided for @figureIsochoric.
  ///
  /// In ja, this message translates to:
  /// **'等積'**
  String get figureIsochoric;

  /// No description provided for @figureAdiabatic.
  ///
  /// In ja, this message translates to:
  /// **'断熱圧縮'**
  String get figureAdiabatic;

  /// No description provided for @figureSun.
  ///
  /// In ja, this message translates to:
  /// **'太陽'**
  String get figureSun;

  /// No description provided for @hintUnavailableEn.
  ///
  /// In ja, this message translates to:
  /// **'英語のヒントはまだありません。'**
  String get hintUnavailableEn;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
