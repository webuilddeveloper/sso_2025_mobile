// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
import 'package:sso/models/register.dart';
import 'package:sso/pages/profile/sso/change_phone_step_1_sso.dart';
import 'package:sso/pages/profile/sso/register_connect_sso.dart';
import 'package:sso/pages/profile/connect_sso.dart';
// import 'package:sso/pages/v2/menu_v2.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/widget/text_field.dart';

// import '../../../../home.dart';
import '../sso/change_phone_step_1_sso.dart';
import '../sso/forgot_password_sso.dart';

class LoginConnectionSSOPage extends StatefulWidget {
  final int step;
  // final String password;
  // final String facebookID;
  // final String appleID;
  // final String googleID;
  // final String lineID;
  // final String email;
  // final String imageUrl;
  // final String category;
  // final String prefixName;
  // final String firstName;
  // final String lastName;
  final bool isShowStep1 = true;
  final bool isShowStep2 = false;

  const LoginConnectionSSOPage({
    Key? key,
    required this.step,
    // @required this.password,
    // @required this.facebookID,
    // @required this.appleID,
    // @required this.googleID,
    // @required this.lineID,
    // @required this.email,
    // @required this.imageUrl,
    // @required this.category,
    // @required this.prefixName,
    // @required this.firstName,
    // @required this.lastName,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LoginConnectionSSOPageState createState() => _LoginConnectionSSOPageState();
}

class _LoginConnectionSSOPageState extends State<LoginConnectionSSOPage> {
  final storage = FlutterSecureStorage();
  late int _step;
  late String _username;
  late String _password;
  late String _facebookID;
  late String _appleID;
  late String _googleID;
  late String _lineID;
  late String _email;
  late String _imageUrl;
  late String _category;
  late String _prefixName;
  late String _firstName;
  late String _lastName;

  final bool _isLoginSocial = false;
  final bool _isLoginSocialHaveEmail = false;
  bool _isShowStep1 = true;
  bool _isShowStep2 = false;
  bool _checkedValue = false;
  late Register _register;
  List<dynamic> _dataPolicy = [];

  final _formKey = GlobalKey<FormState>();

  // Option 2
  // ignore: unused_field
  late String _selectedPrefixName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      if (widget.step == 1) {
        setState(() {
          _isShowStep1 = false;
          _isShowStep2 = true;
        });
      } else {
        setState(() {
          _isShowStep1 = true;
          _isShowStep2 = false;
        });
      }
      futureModel = readPolicy();
    });

    // if (widget.category != 'guest') {
    //   setState(() {
    //     _isLoginSocial = true;
    //   });
    // }
    // if (widget.username != '' && widget.username != null) {
    //   setState(() {
    //     _isLoginSocialHaveEmail = true;
    //   });
    // }

    super.initState();
  }

  // ignore: unused_field
  String _message = "";
  // ignore: unused_element
  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<dynamic> readPolicy() async {
    final result = await postObjectData('m/policy/read', {
      'username': _username,
      'category': 'verification',
    });

    print(result['status'].toString());
    if (result['status'] == 'S') {
      // if (result['objectData'].length > 0) {
      setState(() {
        _dataPolicy = [..._dataPolicy, ...result['objectData']];
      });
      // }
    }
  }

  Future<Null> checkValueStep1() async {
    if (_checkedValue) {
      setState(() {
        _isShowStep1 = false;
        _isShowStep2 = true;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    } else {
      return showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'กรุณาติ้ก ยอมรับข้อตกลงในการใช้บริการ',
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

  Future<dynamic> submitRegister() async {
    final result = await postLoginRegister('m/Register/create', {
      'username': txtUsername.text,
      'password': txtPassword.text,
      // 'facebookID': widget.facebookID,
      // 'appleID': widget.appleID,
      // 'googleID': widget.googleID,
      // 'lineID': widget.lineID,
      // 'email': txtUsername.text,
      // 'imageUrl': widget.imageUrl,
      // 'category': widget.category,
      // 'prefixName': _selectedPrefixName,
      // 'firstName': txtFirstName.text,
      // 'lastName': txtLastName.text,
    });

    if (result.status == 'S') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConnectSSOPage(goHome: false)),
      );

      return showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'เชื่อมต่อระบบเรียบร้อยแล้ว',
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
                'เชื่อมต่อระบบไม่สำเร็จ',
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

  myWizard() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 0.0,
            left: 30.0,
            right: 30.0,
            bottom: 0.0,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Column(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              _isShowStep1
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          border: Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                      Text(
                        'ข้อตกลง',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        height: 2.0,
                        color: Color(0xFFFFC324),
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color:
                              _isShowStep2
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                          border: Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                        child: Text(
                          '2',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep2 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                      Text(
                        'ข้อมูลส่วนตัว',
                        style: TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: _isShowStep1 ? formContentStep1() : formContentStep2(),
      ),
    );
  }

  formContentStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (var item in _dataPolicy)
          Html(data: item['description'].toString()),
        Container(
          alignment: Alignment.center,
          child: CheckboxListTile(
            activeColor: Color(0xFF005C9E),
            title: Text(
              "ฉันยอมรับข้อตกลงในการบริการ",
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
            value: _checkedValue,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue!;
              });
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Color(0xFFFFC324),
              side: BorderSide(color: Color(0xFFFFC324)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: () {
              checkValueStep1();
            },
            child: Text(
              "ถัดไป >",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ],
    );
  }

  formContentStep2() {
    return (Container(
      padding: EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    fontSize: 18.00,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Text(
                //   ' (สำหรับสมาชิก)',
                //   style: TextStyle(
                //     fontSize: 15.00,
                //     fontFamily: 'Kanit',
                //     fontWeight: FontWeight.w100,
                //   ),
                // ),
              ],
            ),
            SizedBox(height: 20.0),
            labelTextField(
              'รหัสผู้ใช้งาน (เลขประจำตัวบัตรประชาชน)',
              Icon(Icons.person, color: Colors.blueAccent, size: 20.00),
            ),
            SizedBox(height: 5.0, width: 200.00),
            textField(
              txtUsername,
              null,
              'ชื่อผู้ใช้',
              'ชื่อผู้ใช้',
              true,
              false,
            ),
            SizedBox(height: 15.0),
            labelTextField(
              'รหัสผ่าน',
              Icon(Icons.lock, color: Colors.blueAccent, size: 20.00),
            ),
            SizedBox(height: 5.0),
            textField(txtPassword, null, 'รหัสผ่าน', 'รหัสผ่าน', true, true),
            SizedBox(height: 30.0),
            Container(
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form.save();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => HomePage()),
                      // );
                    }
                  },
                  child: Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 5.0),
              alignment: Alignment.center,
              child: ButtonTheme(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                // child: FlatButton(
                //   shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.circular(10.0),
                //   ),
                //   onPressed:
                //       () => {
                //         Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => RegisterConnectionSSOPage(),
                //           ),
                //         ),
                //       },
                //   color: Color(0xFF005C9E),
                //   padding: EdgeInsets.all(10.0),
                //   child: Text(
                //     "สมัครสมาชิกเป็นผู้ประกันตน",
                //     style: TextStyle(
                //       fontSize: 18.0,
                //       color: Color(0xFFFFFFFF),
                //       fontWeight: FontWeight.normal,
                //       fontFamily: 'Kanit',
                //     ),
                //   ),
                // ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF005C9E), // สีพื้นหลัง
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 0, // ทำให้ไม่มีเงา เหมือน FlatButton
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterConnectionSSOPage(),
                      ),
                    );
                  },
                  child: Text(
                    "สมัครสมาชิกเป็นผู้ประกันตน",
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "หรือ",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ButtonTheme(
                //   // minWidth: MediaQuery.of(context).size.width * 0.5,
                //   child:
                SizedBox(
                  width: 130.0,
                  child: ButtonTheme(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF707070), // กำหนดสีพื้นหลัง
                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordSSOPage(),
                          ),
                        );
                      },
                      child: Text(
                        "ลืมรหัสผ่าน",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 5.0),
                ButtonTheme(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(
                        0x0FFFFFFF,
                      ), // กำหนดพื้นหลังให้โปร่งใส
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        side: BorderSide(
                          color: Color(0xFF707070),
                        ), // กำหนดเส้นขอบ
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePhoneStep1SSOPage(),
                        ),
                      );
                    },
                    child: Text(
                      "เปลี่ยนเบอร์โทรศัพท์",
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF707070), // กำหนดสีตัวอักษร
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),

        // ],
      ),
      //   Form(
      //   key: _formKey,
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: <Widget>[
      //       labelTextFormField('อีเมล์'),
      //       textFormField(
      //         txtUsername,
      //         null,
      //         'อีเมล์',
      //         'อีเมล์',
      //         _isLoginSocialHaveEmail ? false : true,
      //         false,
      //         true,
      //       ),
      //       if (!_isLoginSocial) labelTextFormFieldPassword(),
      //       if (!_isLoginSocial)
      //         textFormField(
      //           txtPassword,
      //           null,
      //           'รหัสผ่าน',
      //           'รหัสผ่าน',
      //           true,
      //           true,
      //           false,
      //         ),
      //       if (!_isLoginSocial)
      //         labelTextFormField(
      //           'ยืนยันรหัสผ่าน',
      //         ),
      //       if (!_isLoginSocial)
      //         textFormField(
      //           txtConPassword,
      //           txtPassword.text,
      //           'ยืนยันรหัสผ่าน',
      //           'ยืนยันรหัสผ่าน',
      //           true,
      //           true,
      //           false,
      //         ),
      //       labelTextFormField('คำนำหน้า'),
      //       new Container(
      //         width: 5000.0,
      //         padding: EdgeInsets.symmetric(
      //           horizontal: 5,
      //           vertical: 0,
      //         ),
      //         decoration: BoxDecoration(
      //           color: Color(0xFFE8F0F6),
      //           borderRadius: BorderRadius.circular(
      //             10,
      //           ),
      //         ),
      //         // child: DropdownButtonHideUnderline(
      //         child: DropdownButtonFormField(
      //           decoration: InputDecoration(
      //             errorStyle: TextStyle(
      //               fontWeight: FontWeight.normal,
      //               fontFamily: 'Kanit',
      //               fontSize: 10.0,
      //             ),
      //             enabledBorder: UnderlineInputBorder(
      //               borderSide: BorderSide(
      //                 color: Colors.white,
      //               ),
      //             ),
      //           ),
      //           validator: (value) =>
      //               value == '' || value == null ? 'กรุณาเลือกคำนำหน้า' : null,
      //           hint: Text(
      //             'กรุณาเลือกคำนำหน้า',
      //             style: TextStyle(
      //               fontSize: 15.00,
      //               fontFamily: 'Kanit',
      //             ),
      //           ),
      //           value: _selectedPrefixName,
      //           onChanged: (newValue) {
      //             setState(() {
      //               _selectedPrefixName = newValue;
      //             });
      //             _showMessage(_selectedPrefixName);
      //           },
      //           items: _prefixNames.map((prefixName) {
      //             return DropdownMenuItem(
      //               child: new Text(
      //                 prefixName,
      //                 style: TextStyle(
      //                   fontSize: 15.00,
      //                   fontFamily: 'Kanit',
      //                   color: Color(
      //                     0xFF005C9E,
      //                   ),
      //                 ),
      //               ),
      //               value: prefixName,
      //             );
      //           }).toList(),
      //         ),
      //         // ),
      //       ),
      //       labelTextFormField('ชื่อ'),
      //       textFormField(
      //         txtFirstName,
      //         null,
      //         'ชื่อ',
      //         'ชื่อ',
      //         true,
      //         false,
      //         false,
      //       ),
      //       labelTextFormField('นามสกุล'),
      //       textFormField(
      //         txtLastName,
      //         null,
      //         'นามสกุล',
      //         'นามสกุล',
      //         true,
      //         false,
      //         false,
      //       ),
      //       new Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Container(
      //             alignment: Alignment.topRight,
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 10.0,
      //               horizontal: 0.0,
      //             ),
      //             child: new RaisedButton(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(
      //                   10.0,
      //                 ),
      //                 side: BorderSide(
      //                   color: Color(
      //                     0xFFFFC324,
      //                   ),
      //                 ),
      //               ),
      //               onPressed: () {
      //                 setState(
      //                   () {
      //                     _isShowStep1 = true;
      //                     _isShowStep2 = false;

      //                     scrollController
      //                         .jumpTo(scrollController.position.minScrollExtent);
      //                   },
      //                 );
      //               },
      //               color: Color(0xFFFFC324),
      //               textColor: Colors.white,
      //               child: Text(
      //                 "ย้อนกลับ",
      //                 style: new TextStyle(
      //                   fontSize: 20.0,
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.normal,
      //                   fontFamily: 'Kanit',
      //                 ),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             alignment: Alignment.topRight,
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 10.0,
      //               horizontal: 0.0,
      //             ),
      //             child: new RaisedButton(
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(
      //                   10.0,
      //                 ),
      //                 side: BorderSide(
      //                   color: Color(0xFFFFC324),
      //                 ),
      //               ),
      //               onPressed: () {
      //                 final form = _formKey.currentState;
      //                 if (form.validate()) {
      //                   form.save();
      //                   submitRegister();
      //                 }
      //               },
      //               color: Color(0xFFFFC324),
      //               textColor: Colors.white,
      //               child: Text(
      //                 "บันทึก",
      //                 style: new TextStyle(
      //                   fontSize: 20.0,
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.normal,
      //                   fontFamily: 'Kanit',
      //                 ),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //     ],
      //   ),
      // )
    ));
  }

  void goBack() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ConnectSSOPage(goHome: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // return Center(child: Text('Please wait its loading...'));
          // return Center(
          //   child: CircularProgressIndicator(),
          // );
          return Center(
            child: Image.asset(
              "assets/background/login.png",
              fit: BoxFit.cover,
            ),
          );
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background/login.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Scaffold(
                appBar: header(context, goBack),
                backgroundColor: Colors.transparent,
                body: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: const EdgeInsets.all(10.0),
                  children: <Widget>[myWizard(), card()],
                ),
              ),
            );
          }
        }
      },
    );
  }
}
