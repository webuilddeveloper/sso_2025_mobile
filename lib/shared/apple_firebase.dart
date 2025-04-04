import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Generates a cryptographically secure random nonce, to be included in a
/// credential request.
String generateNonce([int length = 32]) {
  final charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  final random = Random.secure();
  return List.generate(
    length,
    (_) => charset[random.nextInt(charset.length)],
  ).join();
}

/// Returns the sha256 hash of [input] in hex notation.
String sha256ofString(String input) {
  final bytes = utf8.encode(input);
  final digest = sha256.convert(bytes);
  return digest.toString();
}

Future<UserCredential> signInWithApple() async {
  try {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final oauthCredential = OAuthProvider(
      "apple.com",
    ).credential(idToken: appleCredential.identityToken, rawNonce: rawNonce);

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  } on SignInWithAppleAuthorizationException catch (e) {
    print("🔥 เกิดข้อผิดพลาดขณะล็อกอิน Apple: ${e.code} - ${e.message}");

    switch (e.code) {
      case AuthorizationErrorCode.canceled:
        print("🚨 ผู้ใช้กดยกเลิกการล็อกอิน");
        break;
      case AuthorizationErrorCode.failed:
        print("❌ การล็อกอินล้มเหลว กรุณาลองใหม่");
        break;
      case AuthorizationErrorCode.invalidResponse:
        print("⚠️ ข้อมูลที่ได้รับจาก Apple ไม่ถูกต้อง");
        break;
      case AuthorizationErrorCode.notHandled:
        print("🛑 การล็อกอินไม่ได้รับการจัดการ");
        break;
      case AuthorizationErrorCode.unknown:
      default:
        print("⚠️ ลองตรวจสอบการตั้งค่าใน Apple Developer Console และ Firebase");
        break;
    }

    return Future.error(e);
  } catch (e) {
    print("❌ ข้อผิดพลาดที่ไม่คาดคิด: $e");
    return Future.error(e);
  }
}
