import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../utils/l10n_utils.dart';

class GoogleSignInFailedException implements Exception {
  GoogleSignInFailedException({required this.code, this.message});

  final String code;
  final String? message;

  @override
  String toString() => message == null ? code : '$code: $message';
}

/// Apple / Google のみ。メール・電話は扱わない。
class FirebaseAuthService {
  FirebaseAuthService._();

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  static bool get _isFirebaseInitialized => Firebase.apps.isNotEmpty;

  static User? get currentUser {
    if (!_isFirebaseInitialized) return null;
    return _auth.currentUser;
  }

  static bool get isAuthenticated => currentUser != null;

  static String? get userId => currentUser?.uid;

  static String? get userEmail => currentUser?.email;

  static String? get displayName => currentUser?.displayName;

  static Stream<User?> authStateChanges() {
    if (!_isFirebaseInitialized) {
      return const Stream<User?>.empty();
    }
    return _auth.authStateChanges();
  }

  /// 例: "google", "apple"
  static String? get loginMethod {
    final user = currentUser;
    if (user == null) return null;
    for (final provider in user.providerData) {
      switch (provider.providerId) {
        case 'google.com':
          return 'google';
        case 'apple.com':
          return 'apple';
        default:
          continue;
      }
    }
    return null;
  }

  static Future<UserCredential?> signInWithGoogle() async {
    if (!_isFirebaseInitialized) return null;
    try {
      final googleSignIn = GoogleSignIn(scopes: const ['email', 'profile']);
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw GoogleSignInFailedException(
        code: 'native-google-sign-in-failed',
        message: e.toString(),
      );
    }
  }

  static Future<UserCredential?> signInWithApple() async {
    if (!_isFirebaseInitialized) return null;
    try {
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final identityToken = appleCredential.identityToken;
      if (identityToken == null || identityToken.isEmpty) return null;

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: identityToken,
        accessToken: appleCredential.authorizationCode,
      );
      return await _auth.signInWithCredential(oauthCredential);
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) return null;
      rethrow;
    } on FirebaseAuthException {
      return null;
    }
  }

  static User _requireCurrentUser() {
    final user = currentUser;
    if (user == null) {
      throw StateError(appL10nWithoutContext().accountDeletionRequiresLogin);
    }
    return user;
  }

  static Future<void> reauthenticateWithGoogle() async {
    final user = _requireCurrentUser();
    final credential = await _requestGoogleCredential();
    if (credential == null) {
      throw StateError(appL10nWithoutContext().reauthCancelled);
    }
    await user.reauthenticateWithCredential(credential);
  }

  static Future<OAuthCredential?> _requestGoogleCredential() async {
    final googleSignIn = GoogleSignIn(scopes: const ['email', 'profile']);
    await googleSignIn.signOut();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;
    final googleAuth = await googleUser.authentication;
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  static Future<void> reauthenticateWithApple() async {
    final user = _requireCurrentUser();
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final identityToken = appleCredential.identityToken;
    if (identityToken == null || identityToken.isEmpty) {
      throw FirebaseAuthException(
        code: 'invalid-id-token',
        message: 'Apple Sign-In identity token is empty.',
      );
    }
    final credential = OAuthProvider('apple.com').credential(
      idToken: identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    await user.reauthenticateWithCredential(credential);
  }

  static Future<void> signOut() async {
    if (!_isFirebaseInitialized) return;
    try {
      await GoogleSignIn().signOut();
    } catch (_) {}
    await _auth.signOut();
  }
}
