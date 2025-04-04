import 'package:flutter_line_sdk/flutter_line_sdk.dart';

Future<LoginResult> loginLine() async {
  try {
    return await LineSDK.instance.login(scopes: ["profile", "openid", "email"]);
  } catch (e) {
    print("Login failed: $e");
    return Future.error(e);
  }
}

void logoutLine() {
  LineSDK.instance.logout();
}
