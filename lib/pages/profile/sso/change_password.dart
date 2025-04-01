// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
// import 'package:sso/pages/auth/login.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/widget/text_form_field.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final storage = FlutterSecureStorage();

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

  void logout() async {
    await storage.delete(key: 'dataUserLoginSSO');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(title: '')),
    );
  }

  Future<dynamic> submitChangePassword() async {
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
                result['message'],
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
          Padding(padding: EdgeInsets.only(top: 65.0)),
          Text(
            'เปลี่ยนรหัสผ่าน',
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
            ),
          ),
          labelTextFormFieldPasswordOldNew('รหัสผ่านปัจจุบัน', false),
          TextFormField(
            obscureText: showTxtPasswordOld,
            style: TextStyle(
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
              fontSize: 15.0,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  showTxtPasswordOld ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    showTxtPasswordOld = !showTxtPasswordOld;
                  });
                },
              ),
              filled: true,
              fillColor: Color(0xFFE8F0F6),
              contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
              hintText: 'รหัสผ่านปัจจุบัน',
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
                return 'กรุณากรอกรหัสผ่านปัจจุบัน.';
              }
              return null;
            },
            controller: txtPasswordOld,
            enabled: true,
          ),
          labelTextFormFieldPasswordOldNew('รหัสผ่านใหม่', true),
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
              hintText: 'รหัสผ่านใหม่',
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
                return 'กรุณากรอกรหัสผ่านใหม่.';
              }

              String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(model)) {
                return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
              }
              return null;
            },
            controller: txtPasswordNew,
            enabled: true,
          ),
          labelTextFormFieldPasswordOldNew('ยืนยันรหัสผ่านใหม่', false),
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
              hintText: 'ยืนยันรหัสผ่านใหม่',
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
                return 'กรุณากรอกยืนยันรหัสผ่านใหม่.';
              }

              if (model != txtPasswordNew.text && txtPasswordNew != null) {
                return 'กรุณากรอกรหัสผ่านให้ตรงกัน.';
              }

              String pattern = r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{6,}$';
              RegExp regex = RegExp(pattern);
              if (!regex.hasMatch(model)) {
                return 'กรุณากรอกรูปแบบรหัสผ่านให้ถูกต้อง.';
              }
              return null;
            },
            controller: txtConPasswordNew,
            enabled: true,
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Container(
            alignment: Alignment.center,
            child: ButtonTheme(
              minWidth: 200.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFFC324),
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  minimumSize: Size(200.0, 36.0),
                ),
                onPressed: () {
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form.save();
                    submitChangePassword();
                  }
                },
                child: Text(
                  "บันทึกข้อมูล",
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
            child: Padding(
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
              style: TextStyle(
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
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => UserInformationPage(),
    //   ),
    // );
    Navigator.pop(context, false);
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
        body: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.all(10.0),
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(padding: EdgeInsets.only(top: 75.0), child: card()),
                SizedBox(
                  width: 150.0,
                  height: 150.0,
                  // decoration: ShapeDecoration(
                  //   shape: CircleBorder(),
                  //   color: Color(0xFFFC4137),
                  // ),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: DecoratedBox(
                      decoration: ShapeDecoration(
                        shape: CircleBorder(),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              _imageUrl != null
                                  ? NetworkImage(_imageUrl)
                                  : AssetImage("assets/logo/noImage.png"),
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
    );
  }
}
