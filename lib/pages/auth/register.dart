// ignore_for_file: avoid_print, use_build_context_synchronously, sort_child_properties_last, curly_braces_in_flow_control_structures, avoid_unnecessary_containers, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/link_url_in.dart';
// import 'package:sso/component/link_url_out.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/widget/text_form_field.dart';

// import 'package:sso/screen/login.dart';

class RegisterPage extends StatefulWidget {
  final String username;
  final String password;
  final String facebookID;
  final String appleID;
  final String googleID;
  final String lineID;
  final String email;
  final String imageUrl;
  final String category;
  final String prefixName;
  final String firstName;
  final String lastName;
  final bool isShowStep1 = true;
  final bool isShowStep2 = false;

  const RegisterPage({
    super.key,
    required this.username,
    required this.password,
    required this.facebookID,
    required this.appleID,
    required this.googleID,
    required this.lineID,
    required this.email,
    required this.imageUrl,
    required this.category,
    required this.prefixName,
    required this.firstName,
    required this.lastName,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final storage = FlutterSecureStorage();

  String? _username;

  bool _isLoginSocial = false;
  bool _isLoginSocialHaveEmail = false;
  bool _isShowStep1 = true;
  bool _isShowStep2 = false;
  bool _checkedValue = false;
  bool _isLoading = true;
  // Register _register;
  List<dynamic> _dataPolicy = [];

  final _formKey = GlobalKey<FormState>();

  final List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // กำหนดค่าเริ่มต้นให้กับ _selectedPrefixName
    _selectedPrefixName = _prefixNames[0];

    txtUsername.text = widget.username;
    print('------------------${widget.username}');

    if (widget.category != 'guest') {
      _isLoginSocial = true;
    }

    if (widget.username != '') {
      _isLoginSocialHaveEmail = true;
    }

    // เรียกใช้ readPolicy พร้อม timeout และการจัดการข้อผิดพลาด
    readPolicy()
        .then((_) {
          setState(() {
            _isLoading = false;
          });
        })
        .catchError((error) {
          print("Error loading policy: $error");
          setState(() {
            _isLoading = false;
          });
        })
        .timeout(
          Duration(seconds: 15),
          onTimeout: () {
            print("Policy loading timeout");
            setState(() {
              _isLoading = false;
            });
          },
        );
  }

  Future<void> readPolicy() async {
    try {
      print('---------------111111---------${_username}');
      final result = await postObjectData('m/policy/read', {
        'username': _username,
        'category': 'register',
      });

      print("Policy result status: ${result['status']}");

      if (result['status'] == 'S') {
        if (result['objectData'] != null && result['objectData'].length > 0) {
          setState(() {
            _dataPolicy = [...result['objectData']];
          });
        }
      } else {
        print("Policy error: ${result['message']}");
      }
    } catch (e) {
      print("Exception in readPolicy: $e");
      throw e; // ส่งต่อข้อผิดพลาดเพื่อให้ catchError ใน initState จัดการ
    }
  }

  Future<void> checkValueStep1() async {
    if (_checkedValue) {
      setState(() {
        _isShowStep1 = false;
        _isShowStep2 = true;
        scrollController.jumpTo(scrollController.position.minScrollExtent);
      });
    } else {
      await showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                'กรุณาติ้ก ยอมรับข้อตกลงเงื่อนไข',
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
    try {
      final result = await postLoginRegister('m/Register/create', {
        'username': txtUsername.text,
        'password': txtPassword.text,
        'facebookID': widget.facebookID,
        'appleID': widget.appleID,
        'googleID': widget.googleID,
        'lineID': widget.lineID,
        'email': txtUsername.text,
        'imageUrl': widget.imageUrl,
        'category': widget.category,
        'prefixName': _selectedPrefixName,
        'firstName': txtFirstName.text,
        'lastName': txtLastName.text,
      });

      if (result.status == 'S') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage(title: '')),
        );

        return showDialog(
          context: context,
          builder:
              (BuildContext context) => CupertinoAlertDialog(
                title: Text(
                  'ลงทะเบียนเรียบร้อยแล้ว',
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
    } catch (e) {
      print("Error during registration: $e");
      return showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                "เกิดข้อผิดพลาดในการลงทะเบียน กรุณาลองใหม่อีกครั้ง",
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

  Widget myWizard() {
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

  Widget card() {
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

  Widget formContentStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _dataPolicy.isEmpty
            ? Center(
              child: Text(
                "ไม่พบข้อตกลงและเงื่อนไขการใช้งาน",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
            )
            : Column(
              children:
                  _dataPolicy.map((item) {
                    return Html(
                      data: item['description'] ?? "",
                      onLinkTap: (
                        String? url,
                        Map<String, String> attributes,
                        element,
                      ) {
                        if (url != null) {
                          launchInWebViewWithJavaScript(url);
                        }
                      },
                    );
                  }).toList(),
            ),
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
              backgroundColor: Color(0xFFFFC324),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: Color(0xFFFFC324)),
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

  Widget formContentStep2() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
          labelTextFormField('คำนำหน้า'),
          Container(
            width: 5000.0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              color: Color(0xFFE8F0F6),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonFormField<String>(
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
                      value == null || value.isEmpty
                          ? 'กรุณาเลือกคำนำหน้า'
                          : null,
              hint: Text(
                'กรุณาเลือกคำนำหน้า',
                style: TextStyle(fontSize: 15.00, fontFamily: 'Kanit'),
              ),
              value: _selectedPrefixName,
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPrefixName = newValue;
                  });
                }
              },
              items:
                  _prefixNames.map((prefixName) {
                    return DropdownMenuItem(
                      value: prefixName,
                      child: Text(
                        prefixName,
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Kanit',
                          color: Color(0xFF005C9E),
                        ),
                      ),
                    );
                  }).toList(),
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 0.0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC324),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFFFFC324)),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _isShowStep1 = true;
                      _isShowStep2 = false;
                      scrollController.jumpTo(
                        scrollController.position.minScrollExtent,
                      );
                    });
                  },
                  child: Text(
                    "ย้อนกลับ",
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.topRight,
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 0.0,
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFC324),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Color(0xFFFFC324)),
                    ),
                  ),
                  onPressed: () {
                    final form = _formKey.currentState;
                    if (form != null && form.validate()) {
                      form.save();
                      submitRegister();
                    }
                  },
                  child: Text(
                    "บันทึก",
                    style: TextStyle(
                      fontSize: 20.0,
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
    );
  }

  void goBack() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(title: '')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // สร้าง background container
    final backgroundContainer = Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/login.png"),
          fit: BoxFit.cover,
        ),
      ),
    );

    if (_isLoading) {
      // แสดง loading indicator บนพื้นหลัง
      return Stack(
        children: [
          backgroundContainer,
          Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFFFC324)),
            ),
          ),
        ],
      );
    }

    // แสดงหน้าลงทะเบียนเมื่อโหลดข้อมูลเสร็จแล้ว
    return Stack(
      children: [
        backgroundContainer,
        Scaffold(
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
      ],
    );
  }
}
