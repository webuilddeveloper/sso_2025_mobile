import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/pages/v2/menu_v2.dart';
import 'package:sso/widget/text_field.dart';
import 'package:sso/widget/text_form_field.dart';
import '../../home.dart';
import 'change_phone_step_2_sso.dart';
import 'login_connect_sso.dart';

DateTime now = DateTime.now();

class ChangePhoneStep1SSOPage extends StatefulWidget {
  // ChangePhoneStep1SSOPage({Key key, this.title}) : super(key: key);
  // final String title;
  @override
  _ChangePhoneStep1SSOPageState createState() =>
      _ChangePhoneStep1SSOPageState();
}

class _ChangePhoneStep1SSOPageState extends State<ChangePhoneStep1SSOPage> {
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
  late String _lastName;

  late Map userProfile;
  bool _isOnlyWebLogin = false;

  late DataUser dataUser;
  final _formKey = GlobalKey<FormState>();
  final txtIdCard = TextEditingController();
  final txtPhone = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtIdCard.dispose();
    txtPhone.dispose();

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
      _lastName = "";
    });
    // checkStatus();
    super.initState();
  }

  void checkStatus() async {
    final storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'dataUserLoginSSOSSO');
    if (value != null && value != '') {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomePage(),
      //   ),
      // );
    }
  }

  void _setStateData() {
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
      _lastName = "";
    });
  }

  TextStyle style = TextStyle(fontFamily: 'Kanit', fontSize: 18.0);

  void goBack() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginConnectionSSOPage(step: 1)),
    );
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
      child: Scaffold(
        appBar: header(context, goBack),
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                  ),
                ),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 10,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                'เปลี่ยนแปลงหมายเลขโทรศัพท์',
                                style: TextStyle(
                                  fontSize: 20.00,
                                  fontFamily: 'Kanit',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'กรุณาระบุหมายเลขบัตรประชาชน และเบอร์โทรศัพท์ของท่าน เพื่อยืนยันตัวตน',
                            style: TextStyle(
                              fontSize: 14.00,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005C9E),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          labelTextField(
                            'รหัสผู้ใช้งาน (เลขประจำตัวบัตรประชาชน)',
                            Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                              size: 20.00,
                            ),
                          ),
                          SizedBox(height: 5.0, width: 200.00),
                          textFormIdCardField(
                            txtIdCard,
                            'หมายเลขบัตรประชาชน (13 หลัก)',
                            'หมายเลขบัตรประชาชน (13 หลัก)',
                            true,
                          ),
                          SizedBox(height: 15.0),
                          labelTextField(
                            'เบอร์โทรศัพท์ (10 หลัก)',
                            Icon(
                              Icons.phone,
                              color: Colors.blueAccent,
                              size: 20.00,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          textFormPhoneField(
                            txtPhone,
                            'เบอร์มือถือ (10 หลัก)',
                            'เบอร์มือถือ (10 หลัก)',
                            true,
                            true,
                          ),
                          SizedBox(height: 25.0),
                          ButtonTheme(
                            minWidth: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    10.0,
                                  ),
                                ),
                                backgroundColor: Color(
                                  0xFFFFC324,
                                ), // สีปุ่ม
                                padding: EdgeInsets.all(10.0),
                              ),
                              onPressed: () {
                                final form = _formKey.currentState;
                                if (form!.validate()) {
                                  form.save();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ChangePhoneStep2SSOPage(
                                                phone: txtPhone.text,
                                                idcard: txtIdCard.text,
                                              ),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                "ดำเนินการต่อ",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      10.0,
                                    ),
                                  ),
                                  backgroundColor: Color(
                                    0xFF707070,
                                  ), // สีปุ่ม
                                  padding: EdgeInsets.all(10.0),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              LoginConnectionSSOPage(
                                                step: 1,
                                              ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "ยกเลิก",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Kanit',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
