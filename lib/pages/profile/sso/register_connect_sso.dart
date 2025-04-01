import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as DateTimePickerPlus;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:sso/component/header.dart';
import 'package:sso/models/register.dart';
import 'package:sso/pages/profile/sso/register_connect_form_otp.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/widget/text_form_field.dart';

import 'login_connect_sso.dart';

class RegisterConnectionSSOPage extends StatefulWidget {
  // final String username;
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
  final bool isShowStep3 = false;
  // RegisterConnectionSSOPage({
  //   Key key,
  //   @required this.username,
  //   @required this.password,
  //   @required this.facebookID,
  //   @required this.appleID,
  //   @required this.googleID,
  //   @required this.lineID,
  //   @required this.email,
  //   @required this.imageUrl,
  //   @required this.category,
  //   @required this.prefixName,
  //   @required this.firstName,
  //   @required this.lastName,
  // }) : super(key: key);

  @override
  _RegisterConnectionSSOPageState createState() =>
      _RegisterConnectionSSOPageState();
}

class _RegisterConnectionSSOPageState extends State<RegisterConnectionSSOPage> {
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

  bool _isLoginSocial = false;
  bool _isLoginSocialHaveEmail = false;
  bool _isShowStep1 = true;
  bool _isShowStep2 = false;
  bool _isShowStep3 = false;
  bool _checkedValue = false;
  late Register _register;
  List<dynamic> _dataPolicy = [];

  final _formKey = GlobalKey<FormState>();

  List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtIdCard = TextEditingController();
  final txtPhone = TextEditingController();

  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtIdCard.dispose();
    txtPhone.dispose();
    super.dispose();
  }

  @override
  void initState() {
    var now = new DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
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

  String _message = "";
  void _showMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<dynamic> readPolicy() async {
    final result = await postObjectData('m/policy/read', {
      'username': this._username,
      'category': 'verification',
    });

    print(result['status'].toString());
    if (result['status'] == 'S') {
      if (result['objectData'].length > 0) {
        setState(() {
          _dataPolicy = [..._dataPolicy, ...result['objectData']];
        });
      }
    }
  }

  Future<Null> checkValueStep1() async {
    if (_checkedValue) {
      setState(() {
        _isShowStep1 = false;
        _isShowStep2 = true;
        _isShowStep3 = false;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    } else {
      return showDialog(
        context: context,
        builder:
            (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
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
                  child: new Text(
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

  Future<Null> checkValueStep2() async {
    if (_checkedValue) {
      setState(() {
        _isShowStep1 = false;
        _isShowStep2 = false;
        _isShowStep3 = true;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
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
      'email': txtUsername.text,
      // 'imageUrl': widget.imageUrl,
      // 'category': widget.category,
      'prefixName': _selectedPrefixName,
      'firstName': txtFirstName.text,
      'lastName': txtLastName.text,
    });

    if (result.status == 'S') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginConnectionSSOPage(step: 0),
        ),
      );

      return showDialog(
        context: context,
        builder:
            (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                'ลงทะเบียนประกันสังคมเรียบร้อยแล้ว',
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
                  child: new Text(
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
            (BuildContext context) => new CupertinoAlertDialog(
              title: new Text(
                'ลงทะเบียนระบบประกันสังคมไม่สำเร็จ',
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
                  child: new Text(
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
              new Row(
                children: [
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep1 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep1
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ข้อตกลง',
                        style: new TextStyle(
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
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '2',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep2 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep2
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ข้อมูลส่วนตัว',
                        style: new TextStyle(
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
                  new Column(
                    children: <Widget>[
                      new Container(
                        width: 50.0,
                        height: 50.0,
                        padding: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        child: Text(
                          '3',
                          textAlign: TextAlign.center,
                          style: new TextStyle(
                            fontSize: 20.0,
                            color: _isShowStep3 ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        decoration: new BoxDecoration(
                          color:
                              _isShowStep3
                                  ? Color(0xFFFFC324)
                                  : Color(0xFFFFFFFF),
                          borderRadius: new BorderRadius.all(
                            new Radius.circular(25.0),
                          ),
                          border: new Border.all(
                            color: Color(0xFFFFC324),
                            width: 2.0,
                          ),
                        ),
                      ),
                      Text(
                        'ยืนยันตัวตน',
                        style: new TextStyle(
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
        child:
            _isShowStep1
                ? formContentStep1()
                : _isShowStep2
                ? formContentStep2()
                : formContentStep3(),
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
        new Container(
          alignment: Alignment.center,
          child: CheckboxListTile(
            activeColor: Color(0xFF005C9E),
            title: Text(
              "ฉันยอมรับข้อตกลงในการบริการ",
              style: new TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
            value: _checkedValue,
            onChanged: (newValue) {
              setState(() {
                _checkedValue = newValue as bool;
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
              backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color(0xFFFFC324)), // ขอบสีส้ม
              ),
              elevation: 0, // ไม่มีเงา เหมือน RaisedButton
            ),
            onPressed: () {
              checkValueStep1();
            },
            child: Text(
              "ถัดไป >",
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
      ],
    );
  }

  dialogOpenPickerDate() {
    DateTimePickerPlus.DatePicker.showDatePicker(
      context,
      theme: DateTimePickerPlus.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        });
      },
      currentTime: DateTime(_selectedYear, _selectedMonth, _selectedDay),
      locale: DateTimePickerPlus.LocaleType.th,
    );
  }

  formContentStep2() {
    return (Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          labelTextFormField('หมายเลขบัตรประชาชน (13 หลัก)'),
          textFormIdCardField(
            txtIdCard,
            'หมายเลขบัตรประชาชน (13 หลัก)',
            'หมายเลขบัตรประชาชน (13 หลัก)',
            true,
          ),
          labelTextFormField('เบอร์ติดต่อ'),
          textFormPhoneField(
            txtPhone,
            'เบอร์มือถือ (10 หลัก)',
            'เบอร์มือถือ (10 หลัก)',
            true,
            false,
          ),
          if (!_isLoginSocial) labelTextFormFieldPassword('รหัสผ่าน'),
          if (!_isLoginSocial)
            textFormField(
              txtPassword,
              '',
              'รหัสผ่าน',
              'รหัสผ่าน',
              true,
              true,
              false,
            ),
          if (!_isLoginSocial) labelTextFormField('ยืนยันรหัสผ่าน'),
          if (!_isLoginSocial)
            textFormField(
              txtConPassword,
              txtPassword.text,
              'ยืนยันรหัสผ่าน',
              'ยืนยันรหัสผ่าน',
              true,
              true,
              false,
            ),
          SizedBox(height: 20.0),
          labelTextFormField('คำนำหน้า'),
          new Container(
            width: 5000.0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              color: Color(0xFFE8F0F6),
              borderRadius: BorderRadius.circular(10),
            ),
            // child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator:
                  (value) =>
                      value == '' || value == null
                          ? 'กรุณาเลือกคำนำหน้า'
                          : null,
              hint: Text(
                'กรุณาเลือกคำนำหน้า',
                style: TextStyle(fontSize: 15.00, fontFamily: 'Kanit'),
              ),
              value: _selectedPrefixName,
              onChanged: (newValue) {
                setState(() {
                  _selectedPrefixName = newValue as String;
                });
                _showMessage(_selectedPrefixName);
              },
              items:
                  _prefixNames.map((prefixName) {
                    return DropdownMenuItem(
                      child: new Text(
                        prefixName,
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Kanit',
                          color: Color(0xFF005C9E),
                        ),
                      ),
                      value: prefixName,
                    );
                  }).toList(),
            ),
            // ),
          ),
          labelTextFormField('ชื่อ'),
          textFormField(txtFirstName, '', 'ชื่อ', 'ชื่อ', true, false, false),
          labelTextFormField('นามสกุล'),
          textFormField(
            txtLastName,
            '',
            'นามสกุล',
            'นามสกุล',
            true,
            false,
            false,
          ),
          labelTextFormField('วันเดือนปีเกิด'),
          GestureDetector(
            onTap: () => dialogOpenPickerDate(),
            child: AbsorbPointer(
              child: TextFormField(
                controller: txtDate,
                style: TextStyle(
                  color: Color(0xFF005C9E),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 15.0,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE8F0F6),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  hintText: "วันเดือนปีเกิด",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  errorStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 10.0,
                  ),
                ),
                validator: (model) {
                  if (model!.isEmpty) {
                    return 'กรุณากรอกวันเดือนปีเกิด.';
                  }
                },
              ),
            ),
          ),

          // TextFormField(
          //   controller: txtDate,
          //   style: TextStyle(
          //     color: Color(0xFF005C9E),
          //     fontWeight: FontWeight.normal,
          //     fontFamily: 'Kanit',
          //     fontSize: 15.0,
          //   ),
          //   decoration: InputDecoration(
          //     filled: true,
          //     fillColor: Color(0xFFE8F0F6),
          //     contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
          //     hintText: "วันเดือนปีเกิด",
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //       borderSide: BorderSide.none,
          //     ),
          //     errorStyle: TextStyle(
          //       fontWeight: FontWeight.normal,
          //       fontFamily: 'Kanit',
          //       fontSize: 10.0,
          //     ),
          //   ),
          //   onTap: () async {
          //     DateTime date = DateTime(1900);
          //     FocusScope.of(context).requestFocus(new FocusNode());

          //     final DateTime picked = await showDatePicker(
          //       context: context,
          //       initialDate: selectedDate,
          //       firstDate: DateTime(1900),
          //       lastDate: DateTime(3000),
          //     );
          //     if (picked != null && picked != selectedDate) {
          //       setState(() {
          //         selectedDate = picked;
          //         txtDate.value = TextEditingValue(
          //           text: DateFormat("dd-MM-yyyy").format(picked),
          //         );
          //       });
          //     }
          //   },
          // ),
          labelTextFormField('อีเมล์'),
          textFormField(
            txtUsername,
            '',
            'อีเมล์',
            'อีเมล์',
            _isLoginSocialHaveEmail ? false : true,
            false,
            true,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Container(
              //   alignment: Alignment.topRight,
              //   padding: const EdgeInsets.symmetric(
              //     vertical: 10.0,
              //     horizontal: 0.0,
              //   ),
              //   child: new RaisedButton(
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(
              //         10.0,
              //       ),
              //       side: BorderSide(
              //         color: Color(
              //           0xFFFFC324,
              //         ),
              //       ),
              //     ),
              //     onPressed: () {
              //       setState(
              //         () {
              //           _isShowStep1 = true;
              //           _isShowStep2 = false;

              //           scrollController
              //               .jumpTo(scrollController.position.minScrollExtent);
              //         },
              //       );
              //     },
              //     color: Color(0xFFFFC324),
              //     textColor: Colors.white,
              //     child: Text(
              //       "ย้อนกลับ",
              //       style: new TextStyle(
              //         fontSize: 20.0,
              //         color: Colors.white,
              //         fontWeight: FontWeight.normal,
              //         fontFamily: 'Kanit',
              //       ),
              //     ),
              //   ),
              // ),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 0.0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
                    padding: EdgeInsets.all(10.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFFFFC324)), // ขอบสีส้ม
                    ),
                    elevation: 0, // ไม่มีเงา เหมือน RaisedButton
                  ),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form!.validate()) {
                      form!.save();
                      checkValueStep2();
                    }
                  },
                  child: Text(
                    "ถัดไป >",
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
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
    ));
  }

  formContentStep3() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "ยืนยันตัวตน การสมัครสมาชิก",
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
          txtIdCard.text,
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
          txtPhone.text,
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
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0),
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.5,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
                padding: EdgeInsets.all(10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Color(0xFFFFC324)), // ขอบสีส้ม
                ),
                elevation: 0, // ไม่มีเงา เหมือน FlatButton
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) =>
                            RegisterConnectFormOTPPage(phone: txtPhone.text),
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
    );
  }

  void goBack() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginConnectionSSOPage(step: 1)),
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
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
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
                    controller: scrollController,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: const EdgeInsets.all(10.0),
                    children: <Widget>[myWizard(), card()],
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
