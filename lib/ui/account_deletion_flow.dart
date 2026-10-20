import 'package:flutter/material.dart';

import '../services/auth/account_deletion_service.dart';
import '../services/auth/firebase_auth_service.dart';

class AccountDeletionFlow {
  AccountDeletionFlow._();

  static Future<bool> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アカウントを削除'),
        content: const SingleChildScrollView(
          child: Text(
            'アカウントとクラウド上の学習履歴・ガチャ設定を削除します。'
            'この操作は取り消せません。',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('削除する'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return false;

    final reauthenticated = await _reauthenticate(context);
    if (!reauthenticated || !context.mounted) return false;

    try {
      await _runWithProgress(
        context,
        'アカウントを削除しています…',
        AccountDeletionService.deleteCurrentAccount,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('アカウントを削除しました。'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('削除に失敗しました'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('閉じる'),
              ),
            ],
          ),
        );
      }
      return false;
    }
  }

  static Future<bool> _reauthenticate(BuildContext context) async {
    final method = FirebaseAuthService.loginMethod;
    try {
      switch (method) {
        case 'google':
          final ok = await _confirmReauth(
            context,
            'アカウント削除を続けるには、Googleで再度認証してください。',
          );
          if (ok != true || !context.mounted) return false;
          await _runWithProgress(
            context,
            '再認証しています…',
            FirebaseAuthService.reauthenticateWithGoogle,
          );
          return true;
        case 'apple':
          final ok = await _confirmReauth(
            context,
            'アカウント削除を続けるには、Appleアカウントで再度認証してください。',
          );
          if (ok != true || !context.mounted) return false;
          await _runWithProgress(
            context,
            '再認証しています…',
            FirebaseAuthService.reauthenticateWithApple,
          );
          return true;
        default:
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('再認証できません'),
              content: const Text(
                'ログイン方法を確認できませんでした。一度ログアウトしてから、'
                'もう一度ログインしてください。',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('閉じる'),
                ),
              ],
            ),
          );
          return false;
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('再認証に失敗しました: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  static Future<bool?> _confirmReauth(BuildContext context, String message) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('本人確認'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('続行'),
          ),
        ],
      ),
    );
  }

  static Future<void> _runWithProgress(
    BuildContext context,
    String message,
    Future<void> Function() action,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(width: 16),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
    try {
      await action();
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }
}
