import 'dart:async';
import 'dart:convert';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../integrations/ai_chat/physics_ai_chat_config.dart';
import '../../state/gacha_store.dart';
import '../../utils/l10n_utils.dart';
import 'cloud_sync_preference_service.dart';
import 'firebase_auth_service.dart';

class AccountDeletionException implements Exception {
  const AccountDeletionException(
    this.message, {
    required this.code,
    this.statusCode,
  });

  final String code;
  final String message;
  final int? statusCode;

  @override
  String toString() => 'AccountDeletionException($code): $message';
}

class AccountDeletionService {
  AccountDeletionService._();

  static Future<void> deleteCurrentAccount({
    Uri? endpoint,
    http.Client? httpClient,
    GachaStore? store,
  }) async {
    final resolved =
        endpoint ?? PhysicsAiChatConfig.accountDeletionEndpointFromEnvironment();
    if (resolved == null) {
      throw AccountDeletionException(
        appL10nWithoutContext().accountDeletionEndpointMissing,
        code: 'endpoint_not_configured',
      );
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw AccountDeletionException(
        appL10nWithoutContext().accountDeletionAuthMissing,
        code: 'not_signed_in',
      );
    }

    final client = httpClient ?? http.Client();
    final shouldCloseClient = httpClient == null;
    try {
      final idToken = await user.getIdToken(true);
      final appCheckToken = await FirebaseAppCheck.instance.getToken();
      final response = await client
          .post(
            resolved,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $idToken',
              'X-Firebase-AppCheck': ?appCheckToken,
            },
            body: jsonEncode(const <String, dynamic>{}),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw AccountDeletionException(
          _readErrorMessage(response) ??
              appL10nWithoutContext().accountDeletionFailed,
          code: _readErrorCode(response) ?? 'server_rejected',
          statusCode: response.statusCode,
        );
      }

      await CloudSyncPreferenceService.removeForUser(user.uid);
      final gachaStore = store ?? GachaStore();
      await gachaStore.clearSnapshot();
      await gachaStore.saveLastUserId(null);
      await FirebaseAuthService.signOut();
      await CloudSyncPreferenceService.refreshForUser(null);
    } on TimeoutException {
      throw AccountDeletionException(
        appL10nWithoutContext().accountDeletionTimeout,
        code: 'timeout',
      );
    } on AccountDeletionException {
      rethrow;
    } catch (e) {
      debugPrint('[AccountDeletion] Failed: $e');
      throw AccountDeletionException(e.toString(), code: 'unexpected');
    } finally {
      if (shouldCloseClient) client.close();
    }
  }

  static String? _readErrorCode(http.Response response) {
    final decoded = _decodeResponse(response);
    if (decoded is Map<String, dynamic>) {
      final error = decoded['error'];
      if (error is Map<String, dynamic> && error['code'] is String) {
        return error['code'] as String;
      }
    }
    return null;
  }

  static String? _readErrorMessage(http.Response response) {
    final decoded = _decodeResponse(response);
    if (decoded is Map<String, dynamic>) {
      final error = decoded['error'];
      if (error is Map<String, dynamic> && error['message'] is String) {
        return error['message'] as String;
      }
    }
    return null;
  }

  static Object? _decodeResponse(http.Response response) {
    try {
      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
      return null;
    }
  }
}
