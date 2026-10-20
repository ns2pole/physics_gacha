import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'cloud_sync_coordinator.dart';
import 'cloud_sync_preference_service.dart';
import 'firebase_auth_service.dart';

/// Platform-native sign-in when the user taps the cloud icon while logged out.
class CloudSignInFlow {
  CloudSignInFlow._();

  static bool get usesAppleSignIn =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Starts Google (Android) or Apple (iOS) sign-in. Returns true on success.
  static Future<bool> signIn(
    BuildContext context, {
    CloudSyncCoordinator? coordinator,
  }) async {
    final shouldEnableCloud = await _confirmCloudSignIn(context);
    if (!shouldEnableCloud) return false;

    try {
      final userCredential = usesAppleSignIn
          ? await FirebaseAuthService.signInWithApple()
          : await FirebaseAuthService.signInWithGoogle();

      if (userCredential == null) return false;

      final uid = userCredential.user?.uid;
      if (uid != null) {
        await CloudSyncPreferenceService.setEnabled(uid, true);
        await CloudSyncPreferenceService.refreshForUser(uid);
      }

      final sync = coordinator ?? CloudSyncCoordinator();
      await sync.refreshAuthAndMaybeSwitch();
      // Ignore errors from background-style sync; UI already signed in.
      try {
        await sync.pullMergeAndSave();
      } catch (e) {
        debugPrint('Post sign-in sync failed: $e');
      }

      if (!context.mounted) return true;
      final method = usesAppleSignIn ? 'Apple' : 'Google';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$methodでログインしました。クラウド同期をオンにしました。'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
      return true;
    } catch (e) {
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            usesAppleSignIn
                ? 'Appleでのログインに失敗しました。'
                : 'Googleでのログインに失敗しました: $e',
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
      return false;
    }
  }

  static Future<bool> _confirmCloudSignIn(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('クラウドと同期'),
          content: const Text(
            'ログインすると、学習履歴とガチャ設定をクラウドに保存・復元できます。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('戻る'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(usesAppleSignIn ? 'Appleで続行' : 'Googleで続行'),
            ),
          ],
        );
      },
    );
    return confirmed == true;
  }
}
