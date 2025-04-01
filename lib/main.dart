import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:sso/screen/splash.dart';

void main() {
  Intl.defaultLocale = 'th';
  initializeDateFormatting();

  WidgetsFlutterBinding.ensureInitialized();

  LineSDK.instance.setup('1654889512').then((_) {
    print('LineSDK Prepared');
  });

  // AppleSignIn.onCredentialRevoked.listen((_) {
  //   print("Credentials revoked");
  // });

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xffe9ebee),
        primaryColor: Colors.blue,
        fontFamily: 'Kanit',
      ),
      title: 'SSO',
      home: SplashPage(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}
