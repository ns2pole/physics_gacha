import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../services/auth/account_deletion_service.dart';
import '../services/auth/firebase_auth_service.dart';
import '../utils/l10n_utils.dart';

class AccountDeletionFlow {
  AccountDeletionFlow._();

  static Future<bool> show(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccountTitle),
        content: SingleChildScrollView(
          child: Text(l10n.deleteAccountBody),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
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
        AppLocalizations.of(context)!.deletingAccount,
        AccountDeletionService.deleteCurrentAccount,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.accountDeleted),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return true;
    } catch (e) {
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(AppLocalizations.of(context)!.deleteFailedTitle),
            content: Text(_errorMessage(e)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.close),
              ),
            ],
          ),
        );
      }
      return false;
    }
  }

  static String _errorMessage(Object e) {
    if (e is AccountDeletionException) {
      return localizedAccountDeletionMessage(e);
    }
    return e.toString();
  }

  static Future<bool> _reauthenticate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final method = FirebaseAuthService.loginMethod;
    try {
      switch (method) {
        case 'google':
          final ok = await _confirmReauth(context, l10n.reauthGoogle);
          if (ok != true || !context.mounted) return false;
          await _runWithProgress(
            context,
            AppLocalizations.of(context)!.reauthenticating,
            FirebaseAuthService.reauthenticateWithGoogle,
          );
          return true;
        case 'apple':
          final ok = await _confirmReauth(context, l10n.reauthApple);
          if (ok != true || !context.mounted) return false;
          await _runWithProgress(
            context,
            AppLocalizations.of(context)!.reauthenticating,
            FirebaseAuthService.reauthenticateWithApple,
          );
          return true;
        default:
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.reauthUnavailableTitle),
              content: Text(AppLocalizations.of(context)!.reauthUnavailableBody),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(AppLocalizations.of(context)!.close),
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
            content: Text(AppLocalizations.of(context)!.reauthFailed('$e')),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  static Future<bool?> _confirmReauth(BuildContext context, String message) {
    final l10n = AppLocalizations.of(context)!;
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.identityConfirmTitle),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.continueAction),
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

String localizedAccountDeletionMessage(AccountDeletionException e) {
  final l10n = appL10nWithoutContext();
  return switch (e.code) {
    'endpoint_not_configured' => l10n.accountDeletionEndpointMissing,
    'not_signed_in' => l10n.accountDeletionAuthMissing,
    'server_rejected' => e.message.isNotEmpty
        ? e.message
        : l10n.accountDeletionFailed,
    'timeout' => l10n.accountDeletionTimeout,
    _ => e.message.isNotEmpty ? e.message : l10n.accountDeletionFailed,
  };
}
