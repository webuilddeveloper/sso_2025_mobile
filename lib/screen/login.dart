// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, sized_box_for_whitespace

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sso/component/material/input_with_label.dart';
import 'package:sso/pages/auth/forgot_password.dart';
import 'package:sso/pages/auth/register.dart';
import 'package:sso/pages/home.dart';
import 'dart:io';
import 'package:sso/shared/api_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/shared/apple_firebase.dart';
import 'package:sso/shared/facebook_firebase.dart';
import 'package:sso/shared/google_firebase.dart';
import 'package:sso/shared/line.dart';

DateTime now = DateTime.now();
void main() {
  // Intl.defaultLocale = 'th';

  runApp(LoginPage(title: ''));
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = FlutterSecureStorage();

  late String _username;
  late String _password;
  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  String _imageUrl = '';
  late String _category;
  late String _prefixName;
  late String _firstName;
  late String _lastName;

  late Map userProfile;

  // DataUser dataUser;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();

    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      _username = "";
      _password = "";
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _category = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });
    // checkStatus();
    super.initState();
  }

  void checkStatus() async {
    final storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'dataUserLoginSSO');
    if (value != null && value != '') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    }
  }

  Future<dynamic> register() async {
    final result = await postLoginRegister('m/Register/create', {
      'username': _username,
      'password': _password,
      'category': _category,
      'email': _email,
      'facebookID': _facebookID,
      'appleID': _appleID,
      'googleID': _googleID,
      'lineID': _lineID,
      'imageUrl': _imageUrl,
      'prefixName': _prefixName,
      'firstName': _firstName,
      'lastName': _lastName,
      'status': "N",
      'platform': Platform.operatingSystem.toString(),
      'birthDay': "",
      'phone': "",
      'countUnit': "[]",
    });

    if (result.status == 'S') {
      await storage.write(
        key: 'dataUserLoginSSO',
        value: jsonEncode(result.objectData),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePage()),
        (Route<dynamic> route) => false,
      );
    } else {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                result.message,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: WillPopScope(
        onWillPop: () {
          return Future.value(false);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        height: 80.0,
                        child: Image.asset(
                          "assets/images/logo_1.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19.0),
                  ),
                  elevation: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color(0xFF1590B4).withOpacity(.95),
                      //     Color(0xFF0D69A4).withOpacity(.95),
                      //   ],
                      //   begin: Alignment.topCenter,
                      //   end: Alignment.bottomCenter,
                      // ),
                      borderRadius: BorderRadius.circular(19.0),
                    ),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'เข้าสู่ระบบ',
                              style: TextStyle(
                                fontSize: 27,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF005C9E),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.0),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/person.png',
                              color: Color(0xFF005C9E),
                              height: 20,
                            ),
                            SizedBox(width: 15),
                            Text(
                              'ชื่อผู้ใช้งาน',
                              style: TextStyle(
                                fontSize: 15.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF005C9E),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: txtUsername,
                          inputFormatters: InputFormatTemple.username(),
                          decoration: DecorationRegister.register(
                            context,
                            hintText: 'ชื่อผู้ใช้งาน',
                          ),
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/icons/lock.png',
                              color: Color(0xFF005C9E),
                              height: 20,
                            ),
                            SizedBox(width: 15),
                            Text(
                              'รหัสผ่าน',
                              style: TextStyle(
                                fontSize: 15.00,
                                fontFamily: 'Kanit',
                                color: Color(0xFF005C9E),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        TextFormField(
                          controller: txtPassword,
                          obscureText: true,
                          inputFormatters: InputFormatTemple.username(),
                          decoration: DecorationRegister.register(
                            context,
                            hintText: 'รหัสผ่าน',
                          ),
                        ),
                        SizedBox(height: 30.0),
                        _buildButtonLogin(),
                        SizedBox(height: 20),
                        _buildLongLine('หรือท่านอาจจะ', Color(0xFF64C5D7)),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                ),
                                child: Text(
                                  "ลืมรหัสผ่าน",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Kanit',
                                    color: Colors.grey.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (BuildContext context) => RegisterPage(
                                          username: "",
                                          password: "",
                                          facebookID: "",
                                          appleID: "",
                                          googleID: "",
                                          lineID: "",
                                          email: "",
                                          imageUrl: "",
                                          category: "guest",
                                          prefixName: "",
                                          firstName: "",
                                          lastName: "",
                                        ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 30,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  color: Color(0xFF64C5D7),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF64C5D7).withOpacity(0.6),
                                  ),
                                ),
                                child: Text(
                                  "สมัครเป็นสมาชิก",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Kanit',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      _buildLongLine('เข้าสู่ระบบผ่าน', Color(0xFF005C9E)),
                      SizedBox(height: 8.0),
                      _buildLoginSocial(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonLogin() {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(20),
      color: Color(0xFFE4A025),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        height: 40,
        onPressed: () {
          _pressGuest();
        },
        child: Text(
          'เข้าสู่ระบบ',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
      ),
    );
  }

  Widget _buildLongLine(String title, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(child: Container(height: 1, color: color)),
        Text(
          ' $title ',
          style: TextStyle(fontSize: 14.00, fontFamily: 'Kanit', color: color),
        ),
        Expanded(child: Container(height: 1, color: color)),
      ],
    );
  }

  Widget _buildLoginSocial() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        if (Platform.isIOS)
          Container(
            alignment: FractionalOffset(0.5, 0.5),
            height: 50.0,
            width: 50.0,
            child: IconButton(
              onPressed: () async {
                _pressApple();
              },
              icon: Image.asset("assets/logo/socials/apple.png"),
              padding: EdgeInsets.all(5.0),
            ),
          ),
        Container(
          alignment: FractionalOffset(0.5, 0.5),
          height: 50.0,
          width: 50.0,
          child: IconButton(
            onPressed: () async {
              _pressFacebook();
            },
            icon: Image.asset("assets/logo/socials/Group379.png"),
            padding: EdgeInsets.all(5.0),
          ),
        ),
        Container(
          alignment: FractionalOffset(0.5, 0.5),
          height: 50.0,
          width: 50.0,
          child: IconButton(
            onPressed: () async {
              _pressGoogle();
            },
            icon: Image.asset("assets/logo/socials/Group380.png"),
            padding: EdgeInsets.all(5.0),
          ),
        ),
        Container(
          alignment: FractionalOffset(0.5, 0.5),
          height: 50.0,
          width: 50.0,
          child: IconButton(
            onPressed: () async {
              _pressLine();
            },
            icon: Image.asset("assets/logo/socials/Group381.png"),
            padding: EdgeInsets.all(5.0),
          ),
        ),
      ],
    );
  }

  //login username / password
  Future<dynamic> login() async {
    if ((_username == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'กรุณากรอกชื่อผู้ใช้',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    } else if ((_password == '') && _category == 'guest') {
      return showDialog(
        barrierDismissible: false,
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'กรุณากรอกรหัสผ่าน',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(" "),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF9A1120),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
      );
    } else {
      String url =
          _category == 'guest'
              ? 'm/Register/login'
              : 'm/Register/$_category/login';

      final result = await postLoginRegister(url, {
        'username': _username.toString(),
        'password': _password.toString(),
        'category': _category.toString(),
        'email': _email.toString(),
      });

      if (result.status == 'S' || result.status == 's') {
        await storage.write(
          key: 'dataUserLoginSSO',
          value: jsonEncode(result.objectData),
        );

        createStorageApp(
          category: _category.toString(),
          model: {
            'code': result.objectData!.code,
            'imageUrl': result.objectData!.imageUrl,
            'firstName': result.objectData!.firstName,
            'lastName': result.objectData!.lastName,
            'username': result.objectData!.username,
            'birthDay': result.objectData!.birthDay,
            'email': result.objectData!.email,
            'idcard': result.objectData!.idcard,
          },
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            // builder: (context) => PermissionRegisterPage(),
            builder: (context) => HomePage(),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        if (_category == 'guest') {
          return showDialog(
            barrierDismissible: false,
            context: context,
            builder:
                (BuildContext context) => CupertinoAlertDialog(
                  title: Text(
                    result.message,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Kanit',
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  content: Text(" "),
                  actions: [
                    CupertinoDialogAction(
                      isDefaultAction: true,
                      child: Text(
                        "ตกลง",
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Kanit',
                          color: Color(0xFF9A1120),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
          );
        } else {
          register();
        }
      }
    }
  }

  //login guest
  void _pressGuest() async {
    setState(() {
      _category = 'guest';
      _username = txtUsername.text;
      _password = txtPassword.text;
      _facebookID = "";
      _appleID = "";
      _googleID = "";
      _lineID = "";
      _email = "";
      _imageUrl = "";
      _prefixName = "";
      _firstName = "";
      _lastName = "";
    });

    await storage.write(key: 'imageUrlSocial', value: '');

    await storage.write(key: 'categorySocial', value: '');
    login();
  }

  void _pressFacebook() async {
    var obj = await signInWithFacebook();
    if (obj != null) {
      var model = {
        "username": obj.user?.email,
        "email": obj.user!.email,
        "imageUrl": obj.user!.photoURL ?? '',
        "firstName": obj.user!.displayName,
        "lastName": '',
        "facebookID": obj.user!.uid,
      };

      Dio dio = Dio();
      var response = await dio.post(
        '${server}m/v2/register/facebook/login',
        data: model,
      );

      await storage.write(key: 'categorySocial', value: 'Facebook');

      await storage.write(key: 'imageUrlSocial', value: model['imageUrl']);

      createStorageApp(
        model: response.data['objectData'],
        category: 'facebook',
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  void _pressGoogle() async {
    var obj = await signInWithGoogle();
    var model = {
      "username": obj.user!.email,
      "email": obj.user!.email,
      "imageUrl": obj.user!.photoURL ?? '',
      "firstName": obj.user?.displayName,
      "lastName": '',
      "googleID": obj.user!.uid,
    };

    Dio dio = Dio();
    var response = await dio.post(
      '${server}m/v2/register/google/login',
      data: model,
    );

    await storage.write(key: 'categorySocial', value: 'Google');

    await storage.write(key: 'imageUrlSocial', value: obj.user?.photoURL ?? '');

    createStorageApp(model: response.data['objectData'], category: 'google');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void _pressLine() async {
    try {
      var obj = await loginLine();

      // ตรวจสอบว่าผู้ใช้กดยกเลิกหรือไม่
      if (obj == null) {
        print("ผู้ใช้กดยกเลิกการเข้าสู่ระบบ");
        return;
      }

      final idToken = obj.accessToken.idToken;
      final userEmail = (idToken != null) ? idToken['email'] ?? '' : '';

      var model = {
        "username":
            (userEmail.isNotEmpty) ? userEmail : obj.userProfile?.userId,
        "email": userEmail,
        "imageUrl": obj.userProfile?.pictureUrl ?? '',
        "firstName": obj.userProfile?.displayName ?? '',
        "lastName": '',
        "lineID": obj.userProfile?.userId ?? '',
      };

      Dio dio = Dio();
      var response = await dio.post(
        '${server}m/v2/register/line/login',
        data: model,
      );

      await storage.write(key: 'categorySocial', value: 'Line');

      await storage.write(
        key: 'imageUrlSocial',
        value: obj.userProfile?.pictureUrl ?? '',
      );

      createStorageApp(model: response.data['objectData'], category: 'line');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      print("เกิดข้อผิดพลาดขณะเข้าสู่ระบบ: $e");
    }
  }

  void _pressApple() async {
    var obj = await signInWithApple();
    var model = {
      "username": obj.user?.email ?? obj.user?.uid,
      "email": obj.user?.email ?? '',
      "imageUrl": '',
      "firstName": obj.user?.email,
      "lastName": '',
      "appleID": obj.user?.uid,
    };
    Dio dio = Dio();
    var response = await dio.post(
      '${server}m/v2/register/apple/login',
      data: model,
    );
    createStorageApp(model: response.data['objectData'], category: 'apple');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }
}
