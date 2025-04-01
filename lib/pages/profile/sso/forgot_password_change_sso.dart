import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
import 'package:sso/pages/home.dart';
import 'package:sso/widget/text_form_field.dart';
import 'login_connect_sso.dart';

class ForgotPasswordChangeSSOPage extends StatefulWidget {
  @override
  _ForgotPasswordChangeSSOPageState createState() =>
      _ForgotPasswordChangeSSOPageState();
}

class _ForgotPasswordChangeSSOPageState
    extends State<ForgotPasswordChangeSSOPage> {
  final storage = new FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();

  final txtPasswordOld = TextEditingController();
  final txtPasswordNew = TextEditingController();
  final txtConPasswordNew = TextEditingController();
  String _imageUrl = '';
  bool showTxtPasswordOld = true;
  bool showTxtPasswordNew = true;
  bool showTxtConPasswordNew = true;

  DateTime selectedDate = DateTime.now();
  TextEditingController dateCtl = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

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

  Future<dynamic> submitForgotPasswordChangeSSO() async {
    // var value = await storage.read(key: 'dataUserLoginSSO');
    // var user = json.decode(value);
    // user['password'] = txtPasswordOld.text;
    // user['newPassword'] = txtPasswordNew.text;

    // final result = await postObjectData('m/Register/change', user);
    // if (result['status'] == 'S') {
    //   await storage.write(
    //     key: 'dataUserLoginSSO',
    //     value: jsonEncode(result['objectData']),
    //   );
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => UserInformationPage(),
    //     ),
    //   );

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder:
          (BuildContext context) => new CupertinoAlertDialog(
            title: new Text(
              'เปลี่ยนรหัสผ่านแล้ว กำลังนำท่านกลับเข้าสู่ระบบผู้ประกันตน',
              style: TextStyle(
                fontSize: 15,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
            content: Text(" "),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text(
                  "ยืนยัน",
                  style: TextStyle(
                    // fontWeight: FontWeight.normal,
                    fontSize: 15,
                    fontFamily: 'Kanit',
                    color: Color(0xFF005C9E),
                  ),
                ),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => HomePage()),
                  // );
                },
              ),
            ],
          ),
    );

    // return showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: Text('Change password ' + result['message'].toString()),
    //     );
    //   },
    // );
    // } else {
    //   return showDialog(
    //     context: context,
    //     builder: (context) {
    //       return AlertDialog(
    //         content: Text(result['message'].toString()),
    //       );
    //     },
    //   );
    // }
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

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
    );
  }

  contentCard() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(
            'เปลี่ยนรหัสผ่าน',
            style: new TextStyle(
              fontSize: 20.0,
              // color: Color(0xFF005C9E),
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
            ),
          ),
          Text(
            'กรุณาระบุรหัสผ่านใหม่ของท่าน และยืนยันรหัสใหม่',
            style: new TextStyle(
              fontSize: 15.0,
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
            ),
          ),
          labelTextFormFieldPasswordOldNew('รหัสผ่าน', true),
          TextFormField(
            obscureText: showTxtPasswordNew,
            style: TextStyle(
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  showTxtPasswordNew ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showTxtPasswordNew = !showTxtPasswordNew;
                  });
                },
              ),
              filled: true,
              fillColor: Color(0xFFE8F0F6),
              contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              hintText: 'รหัสผ่าน',
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
                return 'กรุณากรอกรหัสผ่าน.';
              }

              String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(model)) {
                return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
              }
            },
            controller: txtPasswordNew,
            enabled: true,
          ),
          labelTextFormFieldPasswordOldNew('ยืนยันรหัสผ่าน', false),
          TextFormField(
            obscureText: showTxtConPasswordNew,
            style: TextStyle(
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  showTxtConPasswordNew
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showTxtConPasswordNew = !showTxtConPasswordNew;
                  });
                },
              ),
              filled: true,
              fillColor: Color(0xFFE8F0F6),
              contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              hintText: 'ยืนยันรหัสผ่าน',
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
                return 'กรุณากรอกยืนยันรหัสผ่าน.';
              }

              if (model != txtPasswordNew.text && txtPasswordNew != null) {
                return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
              }

              String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
              RegExp regex = new RegExp(pattern);
              if (!regex.hasMatch(model)) {
                return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
              }
            },
            controller: txtConPasswordNew,
            enabled: true,
          ),
          Padding(padding: EdgeInsets.only(top: 20.0)),
          Container(
            alignment: Alignment.center,
            child: ButtonTheme(
              minWidth: 200.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC324), // สีพื้นหลัง
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  elevation: 0, // ไม่มีเงา เหมือน FlatButton
                ),
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form!.save();
                    submitForgotPasswordChangeSSO();
                  }
                },
                child: Text(
                  "ยืนยัน",
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
        ],
      ),
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            child: new Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(urlImage, height: 5.0, width: 5.0),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: new TextStyle(
                fontSize: 12.0,
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
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
        appBar: header(context, goBack),
        backgroundColor: Colors.transparent,
        body: Container(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              new Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 10.0), child: card()),
                  // Container(
                  //   width: 150.0,
                  //   height: 150.0,
                  //   // decoration: ShapeDecoration(
                  //   //   shape: CircleBorder(),
                  //   //   color: Color(0xFFFC4137),
                  //   // ),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(0.0),
                  //     child: DecoratedBox(
                  //       decoration: ShapeDecoration(
                  //         shape: CircleBorder(),
                  //         image: DecorationImage(
                  //           fit: BoxFit.cover,
                  //           image: _imageUrl != null
                  //               ? NetworkImage(_imageUrl)
                  //               : Image.asset("assets/logo/noImage.png"),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
