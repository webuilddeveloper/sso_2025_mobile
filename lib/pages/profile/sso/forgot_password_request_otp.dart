import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/pages/v2/menu_v2.dart';
import '../../home.dart';
import 'login_connect_sso.dart';
import 'forgot_password_form_otp.dart';

DateTime now = new DateTime.now();

class ForgotPasswordRequestOTPPage extends StatefulWidget {
  final String idcard;
  final String phone;
  ForgotPasswordRequestOTPPage({
    Key? key,
    required this.idcard,
    required this.phone,
  }) : super(key: key);

  @override
  _ForgotPasswordRequestOTPPageState createState() =>
      _ForgotPasswordRequestOTPPageState();
}

class _ForgotPasswordRequestOTPPageState
    extends State<ForgotPasswordRequestOTPPage> {
  final storage = new FlutterSecureStorage();

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
  late String _phone;
  late String _idcard;

  late Map userProfile;
  bool _isOnlyWebLogin = false;

  late DataUser dataUser;

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
      _firstName = "";
      _lastName = "";
    });
    // checkStatus();
    super.initState();
  }

  void checkStatus() async {
    final storage = new FlutterSecureStorage();
    String? value = await storage.read(key: 'dataUserLoginSSO');
    if (value != null && value != '') {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
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
      _firstName = "";
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
        body: Container(
          child: ListView(
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: new EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                    ),
                  ),
                  Container(
                    child: Container(
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        elevation: 10,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "ลืมรหัสผ่าน",
                                style: new TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                              Text(
                                "โปรดตรวจสอบความถูกต้องของข้อมูล จากนั้นระบุรหัสผ่านที่ได้รับจาก SMS-OTP เพื่อความปลอดภัยในการเปลี่ยนรหัสผ่าน",
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF005C9E),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                "เลขที่บัตรประชาชน:",
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF005C9E),
                                ),
                              ),
                              Text(
                                widget.idcard,
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                              Text(
                                "เบอร์โทรศัพท์",
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                  color: Color(0xFF005C9E),
                                ),
                              ),
                              Text(
                                widget.phone,
                                style: new TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                              SizedBox(height: 20.0),
                              Center(
                                child: Text(
                                  "กรุณากดปุ่ม “Request OTP”",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF005C9E),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "เพื่อรับรหัสรักษาความปลอดภัย SMS-OTP",
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF005C9E),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: 0.0,
                                ),
                                child: ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Color(
                                        0xFFFFC324,
                                      ), // สีพื้นหลัง
                                      padding: EdgeInsets.all(10.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          10.0,
                                        ),
                                        side: BorderSide(
                                          color: Color(0xFFFFC324),
                                        ), // ขอบสีเหลือง
                                      ),
                                      elevation:
                                          0, // ทำให้ไม่มีเงา เหมือน FlatButton
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  ForgotPasswordFormOTPPage(
                                                    phone: widget.phone,
                                                  ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Request OTP",
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
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
