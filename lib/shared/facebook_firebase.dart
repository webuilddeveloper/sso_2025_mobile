// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<UserCredential?> signInWithFacebook() async {
  // Trigger the sign-in flow
  final LoginResult loginResult = await FacebookAuth.instance.login();

  if (loginResult.status == LoginStatus.success) {
    final AccessToken? accessToken = loginResult.accessToken;

    if (accessToken != null) {
      final OAuthCredential credential = FacebookAuthProvider.credential(
        accessToken.tokenString,
      );

      try {
        return await FirebaseAuth.instance.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException: ${e.message}");
        return null;
      } catch (e) {
        print("Unexpected error: $e");
        return null;
      }
    }
  }

  // Login failed or was canceled
  print("Facebook login failed: ${loginResult.message}");
  return null;
}

void logoutFacebook() async {
  await FacebookAuth.instance.logOut();
}
