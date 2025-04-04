// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, deprecated_member_use, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/pages/home.dart';
// import 'package:sso/pages/home.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/shared/api_provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late Future<dynamic> futureModel;

  @override
  void initState() {
    futureModel = postDio('${server}m/splash/read', {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _callTimer(3);
    return _buildSplash();
  }

  _buildSplash() {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                _callTimer(
                  int.parse(snapshot.data[0]['timeOut']) / 1000.round(),
                );
                return Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                  child: Center(
                    child: Image.network(
                      snapshot.data[0]['imageUrl'],
                      fit: BoxFit.cover,
                      height: double.infinity,
                      width: double.infinity,
                    ),
                  ),
                );
              } else {
                return Image.asset(
                  'assets/splash.png',
                  fit: BoxFit.fill,
                  height: double.infinity,
                  width: double.infinity,
                );
              }
            } else if (snapshot.hasError) {
              return Image.asset(
                'assets/splash.png',
                fit: BoxFit.fill,
                height: double.infinity,
                width: double.infinity,
              );
            } else {
              return Center(child: Container());
            }
          },
        ),
      ),
    );
  }

  _callTimer(time) async {
    var _duration = Duration(seconds: time.toInt());
    return Timer(_duration, _callNavigatorPage);
  }

  _callNavigatorPage() async {
    final storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'profileCode1');

    if (!mounted) return; // 🔹 ป้องกันการใช้ context หลัง dispose

    if (value != null && value != '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage(title: '')),
        (Route<dynamic> route) => false,
      );
    }
  }
}
