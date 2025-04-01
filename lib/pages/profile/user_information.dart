// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:sso/component/header.dart';
import 'package:sso/models/user.dart';
// import 'package:sso/pages/auth/login.dart';
// import 'package:sso/pages/home.dart';
import 'package:sso/pages/profile/connect_sso.dart';
import 'package:sso/pages/profile/profile_policy_sso.dart';
import 'package:sso/pages/profile/profile_sso.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/shared/api_provider.dart';
import '../profile/sso/change_password.dart';
import '../profile/sso/connect_social.dart';
import '../profile/sso/edit_user_information.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key, this.userData});
  final User? userData;
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final storage = FlutterSecureStorage();

  String _imageUrl = '';
  String _firstName = '';
  String _lastName = '';
  String _idCard = '';

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  late Future<dynamic> futureModel;
  late Future<dynamic> _futureAboutUs;

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
    readStorage();
    _futureAboutUs = postDio(aboutUsReadApi, {});
    super.initState();
  }

  void goBack() async {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomePage()),
    // );
  }

  void logout() async {
    await storage.delete(key: 'dataUserLoginSSO');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(title: '')),
    );
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginSSO');
    var user = json.decode(value!);
    if (user['code'] != '') {
      setState(() {
        _imageUrl = user['imageUrl'] ?? '';
        _firstName = user['firstName'] ?? '';
        _lastName = user['lastName'] ?? '';
        _idCard = user['idCard'] ?? '';
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
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(top: 65.0),
      children: <Widget>[
        Center(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _firstName,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  Text(' '),
                  Text(
                    _lastName,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ],
              ),
              Text(
                _idCard != '' ? _idCard : 'ไม่พบเลขบัตรประชาชน',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Color(0xFF005C9E),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
            ],
          ),
        ),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
            child: rowContentButton(
              "assets/icons/Group923.png",
              "ข้อมูลผู้ใช้งาน",
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditUserInformationPage(),
                  ),
                ).then((value) => readStorage()),
          ),

          // onPressed: () => Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => EditUserInformationPage(),
          //   ),
          // ),
          // ),
        ),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
            child: rowContentButton(
              "assets/icons/Group6304.png",
              "ข้อมูลการเชื่อมต่อประกันสังคม",
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConnectSSOPage(goHome: false),
                  ),
                ).then((value) => readStorage()),
          ),
        ),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
            child: rowContentButton(
              "assets/icons/Group874.png",
              "การเชื่อมต่อบัญชีโซเชียลเน็ตเวิร์ก",
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConnectSocialPage()),
                ).then((value) => readStorage()),
          ),
        ),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
            child: rowContentButton(
              "assets/icons/Group6303.png",
              "เปลี่ยนรหัสผ่าน",
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                ).then((value) => readStorage()),
          ),
        ),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
            child: rowContentButton("assets/icons/Path6569.png", "ติดต่อเรา"),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileSSOPage(model: _futureAboutUs),
                  ),
                ).then((value) => readStorage()),
          ),
        ),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(0.0)),
            child: rowContentButton(
              "assets/icons/Group6305.png",
              "นโยบายเงื่อนไขและข้อตกลง",
            ),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePolicySSOPage(),
                  ),
                ).then((value) => readStorage()),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        ButtonTheme(
          child: TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.all(10.0)),
            onPressed: () => {logout()},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.power_settings_new, color: Colors.red),
                Text(
                  " ออกจากระบบ",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Color(0xFFFC4137),
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(urlImage, height: 5.0, width: 5.0),
            ),
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
        backgroundColor: Colors.transparent,
        body: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 10,
            right: 10,
          ),
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
                              _imageUrl != null && _imageUrl.isNotEmpty
                                  ? NetworkImage(_imageUrl)
                                  : AssetImage("assets/logo/noImage.png"),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF005C9E),
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
