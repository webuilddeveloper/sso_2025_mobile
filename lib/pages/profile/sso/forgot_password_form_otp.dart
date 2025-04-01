// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:numeric_keyboard/numeric_keyboard.dart';
import 'package:sso/pages/profile/connect_sso.dart';
import 'package:sso/pages/profile/sso/login_connect_sso.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/shared/api_provider.dart';

import 'forgot_password_change_sso.dart';

class ForgotPasswordFormOTPPage extends StatefulWidget {
  const ForgotPasswordFormOTPPage({super.key, required this.phone});
  final String phone;

  @override
  _ForgotPasswordFormOTPPageState createState() =>
      _ForgotPasswordFormOTPPageState();
}

class _ForgotPasswordFormOTPPageState extends State<ForgotPasswordFormOTPPage> {
  final storage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  final txtPasswordOld = TextEditingController();
  final txtPasswordNew = TextEditingController();
  final txtConPasswordNew = TextEditingController();
  late String _imageUrl;
  bool showTxtPasswordOld = true;
  bool showTxtPasswordNew = true;
  bool showTxtConPasswordNew = true;

  DateTime selectedDate = DateTime.now();
  TextEditingController dateCtl = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtPasswordOld.dispose();
    txtPasswordNew.dispose();
    txtConPasswordNew.dispose();
    super.dispose();
  }

  @override
  void initState() {
    readStorage();
    super.initState();
  }

  Future<dynamic> submitForgotPasswordFormOTP() async {
    var value = await storage.read(key: 'dataUserLoginSSO');
    var user = json.decode(value!);
    user['password'] = txtPasswordOld.text;
    user['newPassword'] = txtPasswordNew.text;

    final result = await postObjectData('m/Register/change', user);
    if (result['status'] == 'S') {
      await storage.write(
        key: 'dataUserLoginSSO',
        value: jsonEncode(result['objectData']),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserInformationPage()),
      );

      return showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'เปลี่ยนรหัสผ่านเรียบร้อยแล้ว',
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
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF005C9E),
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
      return showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'เปลี่ยนรหัสผ่านไม่สำเร็จ',
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
                    "ยกเลิก",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFF005C9E),
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

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginSSO');
    var user = json.decode(value!);

    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
      });
    }
  }

  String text = '';

  void submitSMSForgotPasswordFormOTP() async {
    int len = text.length;

    if (len == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ForgotPasswordChangeSSOPage(),
        ),
      );
    } else {}
  }

  void goBack() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginConnectionSSOPage(step: 1)),
    );
  }

  void _onKeyboardTap(String value) {
    int len = text.length;
    if (len < 6) {
      setState(() {
        text = text + value;
      });
    }
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(text[position], style: TextStyle(color: Colors.white)),
        ),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<dynamic>(
    //   future: futureModel,
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // return Center(child: Text('Please wait its loading...'));
    //       // return Center(
    //       //   child: CircularProgressIndicator(),
    //       // );
    //       return Center(
    //         child: Image.asset(
    //           "assets/background/login.png",
    //           fit: BoxFit.cover,
    //         ),
    //       );
    //     } else {
    //       if (snapshot.hasError)
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       else
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        // appBar: header(context, goBack),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(
                              top: 40.0,
                              bottom: 40.0,
                              right: 20.0,
                              left: 20.0,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'ระบบได้ทำการส่งรหัส SMS-OTP ไปยังหมายเลขโทรศัพท์ ${widget.phone} แล้ว',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'รหัสอ้างอ้ง : NFTE',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                            ),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'กรุณาระบุรหัสความปลอดภัย SMS-OTP ที่ได้รับ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Kanit',
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20.0),
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                otpNumberWidget(0),
                                otpNumberWidget(1),
                                otpNumberWidget(2),
                                otpNumberWidget(3),
                                otpNumberWidget(4),
                                otpNumberWidget(5),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          // min: 120.0,
                          padding: EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF707070), // สีพื้นหลัง
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Color(0xFF707070),
                                ), // ขอบสีเทา
                              ),
                              elevation: 0, // ทำให้ไม่มีเงา เหมือน FlatButton
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          ConnectSSOPage(goHome: false),
                                ),
                              );
                            },
                            child: Text(
                              "ยกเลิก",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        ),
                        Container(
                          // min: 120.0,
                          padding: EdgeInsets.all(5.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
                              padding: EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(
                                  color: Color(0xFFFFC324),
                                ), // ขอบสีส้ม
                              ),
                              elevation: 0, // ไม่มีเงา เหมือน FlatButton
                            ),
                            onPressed: () {
                              submitSMSForgotPasswordFormOTP();
                            },
                            child: Text(
                              "ยืนยัน",
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    NumericKeyboard(
                      onKeyboardTap: _onKeyboardTap,
                      textColor: Color(0xFF005C9E),
                      rightIcon: Icon(
                        Icons.backspace,
                        color: Color(0xFF005C9E),
                      ),
                      rightButtonFn: () {
                        setState(() {
                          text = text.substring(0, text.length - 1);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
