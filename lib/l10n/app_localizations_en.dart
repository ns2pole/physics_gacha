// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Physics Gacha';

  @override
  String get problemList => 'Problem list';

  @override
  String get spinGacha => 'Spin';

  @override
  String get hint => 'Hint';

  @override
  String get hideHint => 'Hide hint';

  @override
  String get showAnswer => 'Show answer';

  @override
  String get hideAnswer => 'Hide answer';

  @override
  String get askAi => 'Ask AI';

  @override
  String get calculator => 'Calculator';

  @override
  String get closeCalculator => 'Close calculator';

  @override
  String get answerLabel => 'Answer';

  @override
  String answerWithValue(String value) {
    return 'Answer  $value';
  }

  @override
  String get approach => 'Approach';

  @override
  String get firstStep => 'First step';

  @override
  String get explanation => 'Solution';

  @override
  String get detail => 'Details';

  @override
  String get noMatchingProblems => 'No matching problems';

  @override
  String get noProblemsAvailable =>
      'No problems available. Turn a topic on or ease the exclusion filter.';

  @override
  String get filterSettings => 'Filter';

  @override
  String get exclusionNone => 'No exclusion';

  @override
  String exclusionNoneWithTotal(int total) {
    return 'No exclusion · $total total';
  }

  @override
  String exclusionLatestPrefix(int count) {
    return 'If the latest $count';
  }

  @override
  String get exclusionThenRemoveFromGacha => 'are green, exclude from gacha';

  @override
  String get exclusionThenExcludeProblems => 'exclude those problems';

  @override
  String totalProblems(int total) {
    return '$total total';
  }

  @override
  String remainingProblems(int remaining, int total) {
    return '($remaining left / $total)';
  }

  @override
  String get domainMechanics => 'Mechanics';

  @override
  String get domainThermodynamics => 'Thermo';

  @override
  String get domainWaves => 'Waves';

  @override
  String get domainElectromagnetism => 'EM';

  @override
  String get domainAtom => 'Atomic';

  @override
  String get slotEmpty => 'Empty';

  @override
  String get slotSolved => 'Solved';

  @override
  String get slotUnderstood => 'Understood';

  @override
  String get slotFailed => 'Missed';

  @override
  String get autoRecordBoth => 'Auto-mark correct on match, miss on mismatch';

  @override
  String get autoRecordCorrectOnly => 'Auto-mark only when correct';

  @override
  String get autoRecordOff => 'Do not auto-record history';

  @override
  String get exclusionModeNone => 'No exclusion';

  @override
  String get exclusionModeLatest1 => 'Exclude if latest 1 is green';

  @override
  String get exclusionModeLatest2 => 'Exclude if latest 2 are green';

  @override
  String get exclusionModeLatest3 => 'Exclude if latest 3 are green';

  @override
  String get dimensionless => 'Dimensionless';

  @override
  String get toUnits => 'Units';

  @override
  String get backToNumbers => 'Back to numbers';

  @override
  String get confirm => 'OK';

  @override
  String get selectUnit => 'Choose a unit';

  @override
  String get assembleUnitHint => 'Build like kg m s^-1';

  @override
  String get symbolOrderHint => 'Shortest wavelength first, left to right';

  @override
  String get cloudLogin => 'Sign in to cloud';

  @override
  String get account => 'Account';

  @override
  String get signedIn => 'Signed in';

  @override
  String get cloudSyncOn => 'Cloud sync: On';

  @override
  String get cloudSyncOff => 'Cloud sync: Off';

  @override
  String get syncNow => 'Sync now';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get signOut => 'Sign out';

  @override
  String get cloudSyncEnabled => 'Cloud sync turned on.';

  @override
  String get cloudSyncDisabled => 'Cloud sync turned off.';

  @override
  String get synced => 'Synced.';

  @override
  String syncFailed(String error) {
    return 'Sync failed: $error';
  }

  @override
  String get signedOut => 'Signed out.';

  @override
  String get cloudSyncTitle => 'Sync with cloud';

  @override
  String get cloudSyncBody =>
      'Sign in to save and restore your learning history and gacha settings in the cloud.';

  @override
  String get back => 'Back';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String signedInWithMethod(String method) {
    return 'Signed in with $method. Cloud sync turned on.';
  }

  @override
  String get appleSignInFailed => 'Apple sign-in failed.';

  @override
  String googleSignInFailed(String error) {
    return 'Google sign-in failed: $error';
  }

  @override
  String get deleteAccountTitle => 'Delete account';

  @override
  String get deleteAccountBody =>
      'This deletes your account and cloud learning history and gacha settings. This cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deletingAccount => 'Deleting account…';

  @override
  String get accountDeleted => 'Account deleted.';

  @override
  String get deleteFailedTitle => 'Deletion failed';

  @override
  String get close => 'Close';

  @override
  String get reauthGoogle =>
      'To continue deleting your account, sign in again with Google.';

  @override
  String get reauthApple =>
      'To continue deleting your account, sign in again with Apple.';

  @override
  String get reauthenticating => 'Reauthenticating…';

  @override
  String get reauthUnavailableTitle => 'Cannot reauthenticate';

  @override
  String get reauthUnavailableBody =>
      'Could not confirm how you signed in. Sign out, then sign in again.';

  @override
  String reauthFailed(String error) {
    return 'Reauthentication failed: $error';
  }

  @override
  String get identityConfirmTitle => 'Confirm identity';

  @override
  String get continueAction => 'Continue';

  @override
  String get accountDeletionEndpointMissing =>
      'Account deletion endpoint is not configured.';

  @override
  String get accountDeletionAuthMissing => 'Could not confirm sign-in state.';

  @override
  String get accountDeletionFailed => 'Account deletion failed.';

  @override
  String get accountDeletionTimeout =>
      'The request timed out. Please try again later.';

  @override
  String get accountDeletionRequiresLogin =>
      'You must be signed in to delete your account.';

  @override
  String get reauthCancelled => 'Reauthentication was cancelled.';

  @override
  String get aiGreeting => 'Ask anything about this problem.';

  @override
  String get aiPlaceholder => 'Type your question';

  @override
  String get aiSend => 'Send';

  @override
  String get aiMoreDetail => 'More detail';

  @override
  String get aiGenericError => 'The AI response failed. Please try again.';

  @override
  String get aiStarterHint => 'Give me a hint';

  @override
  String get aiStarterApproach => 'Tell me only the approach';

  @override
  String get aiStarterFirstStep => 'Tell me only the first step';

  @override
  String aiFreeLimitReached(int limit) {
    return 'You have reached this month\'s free limit ($limit).';
  }

  @override
  String aiPaidLimitReached(int limit) {
    return 'You have reached the AI pass limit ($limit).';
  }

  @override
  String get aiVoiceListening => 'Listening…';

  @override
  String get aiVoiceSendAuto => 'Send voice automatically';

  @override
  String get aiVoiceSendManual => 'Edit before sending';

  @override
  String get aiVoiceSendAutoLabel => 'Auto-send';

  @override
  String get aiVoiceSendManualLabel => 'Manual';

  @override
  String get aiVoicePermissionDenied =>
      'Microphone permission is required for voice input.';

  @override
  String get figureObjectA => 'Block A';

  @override
  String get figureObjectB => 'Block B';

  @override
  String get figureObjectC => 'Block C';

  @override
  String get figureExternalForce => 'Force';

  @override
  String get figureInitialSpeed => 'Initial speed';

  @override
  String get figureAntinode => 'Antinode';

  @override
  String get figureNode => 'Node';

  @override
  String get figureWall => 'Wall';

  @override
  String get figureOpenPipe => 'Open pipe';

  @override
  String get figureSpring => 'Spring';

  @override
  String get figureSmallMass => 'Mass';

  @override
  String get figureString => 'String';

  @override
  String get figureBefore => 'Before';

  @override
  String get figureAfter => 'After';

  @override
  String get figureIsothermal => 'Isothermal';

  @override
  String get figureIsobaric => 'Isobaric';

  @override
  String get figureIsochoric => 'Isochoric';

  @override
  String get figureAdiabatic => 'Adiabatic compression';

  @override
  String get figureSun => 'Sun';

  @override
  String get hintUnavailableEn => 'Hint is not available in English yet.';
}
