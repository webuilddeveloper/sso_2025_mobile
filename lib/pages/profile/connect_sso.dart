import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
// import 'package:sso/pages/auth/login.dart';
import 'package:sso/pages/home.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/pages/v2/menu_v2.dart';
import 'package:sso/screen/login.dart';
import 'sso/login_connect_sso.dart';

class ConnectSSOPage extends StatefulWidget {
  ConnectSSOPage({Key? key, required this.goHome}) : super(key: key);

  final bool goHome;

  @override
  _ConnectSSOPageState createState() => _ConnectSSOPageState();
}

class _ConnectSSOPageState extends State<ConnectSSOPage> {
  final storage = new FlutterSecureStorage();

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
  late String _idCard;

  bool _isLoginSocial = false;
  bool _isLoginSocialHaveEmail = false;
  bool _isShowStep1 = true;
  bool _isShowStep2 = false;
  bool _checkedValue = false;

  final _formKey = GlobalKey<FormState>();

  List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  late String _selectedPrefixName;

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

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
    setState(() {});
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

  rowImageAvatarConnect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      _imageUrl.isNotEmpty
                          ? NetworkImage(_imageUrl)
                          : AssetImage("assets/logo/noImage.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  contentButtonConnect() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Color(0xFF005C9E),
                padding: EdgeInsets.all(10.0),
              ),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomePage()),
                // );
              },
              child: Text(
                "เชื่อมต่อเรียบร้อย",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Color(0xFF707070), // สีปุ่ม
                padding: EdgeInsets.all(10.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginConnectionSSOPage(step: 0),
                  ),
                );
              },
              child: Text(
                "ยกเลิกการเชื่อมต่อระบบสมาชิกผู้ประกันตน",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          "ท่านเชื่อมต่อไปยังระบบสมาชิกผู้ประกันตนเรียบร้อย",
          style: new TextStyle(
            fontSize: 13.0,
            color: Color(0xFF005C9E),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
        rowContentDataSSO(
          "assets/icons/Group319.png",
          "สถานพยาบาล",
          "พญาไท นวมินทร์",
        ),
        rowContentDataSSO(
          "assets/icons/Group358.png",
          "สปส. ที่รับผิดชอบ",
          "สปส.",
        ),
        rowContentDataSSO(
          "assets/icons/Group360.png",
          "วันที่เป็นผู้ประกันตน",
          "20/07/2557",
        ),
        rowContentDataSSO(
          "assets/icons/Group363.png",
          "สถานะ",
          "เป็นผู้ประกันตน",
        ),
      ],
    );
  }

  rowContentDataSSO(String imageUrl, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
          child: Image.asset(imageUrl, height: 50.0, width: 50.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              textAlign: TextAlign.start,
              style: new TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
            Text(
              value,
              textAlign: TextAlign.start,
              style: new TextStyle(
                fontSize: 18.0,
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ],
        ),
      ],
    );
  }

  rowImageAvatarNoConnect() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      _imageUrl.isNotEmpty
                          ? NetworkImage(_imageUrl)
                          : AssetImage("assets/logo/noImage.png"),
                ),
              ),
            ),
          ),
        ),
        Container(
          child: Image.asset(
            "assets/icons/connect.png",
            height: 50.0,
            width: 50.0,
          ),
        ),
        Container(
          width: 100.0,
          height: 100.0,
          // alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(0.0),
            child: DecoratedBox(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: CircleBorder(),
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage("assets/icons/tpt.png"),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  contentButtonNoConnect() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.1,
          ),
          alignment: Alignment.center,
          child: ButtonTheme(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: Color(0xFFFFC324),
                padding: EdgeInsets.all(10.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginConnectionSSOPage(step: 0),
                  ),
                );
              },
              child: Text(
                "เชื่อมต่อไปยังระบบสมาชิกผู้ประกันตน",
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ),
        ),
        Text(
          "ท่านกำลังเข้าสู่ระบบสมาชิกผู้ประกันตน",
          style: new TextStyle(
            fontSize: 13.0,
            color: Color(0xFF005C9E),
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
          ),
        ),
      ],
    );
  }

  void goBack() async {
    if (widget.goHome) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomePage()),
      // );
    } else {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => UserInformationPage(),
      //   ),
      // );
      Navigator.pop(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder<dynamic>(
    //   future: futureModel,
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.connectionState == ConnectState.waiting) {
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
              // new Con(
              //   alignment: Alignment.topCenter,
              //   children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Text(
                  'ข้อมูลการเชื่อมต่อประกันสังคม',
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 18.0,
                    color: Color(0xFF005C9E),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,

                  // boxShadow: [
                  //   BoxShadow(color: Colors.green, spreadRadius: 3),
                  // ],
                ),
                height: 70,
                width: MediaQuery.of(context).size.width * 0.8,
              ),
              // Padding(
              //   padding: EdgeInsets.only(top: 75.0),
              //   child: Container(),
              // ),
              Padding(padding: EdgeInsets.only(top: 50.0)),

              // rowImageAvatarConnect(),
              rowImageAvatarNoConnect(),
              Padding(padding: EdgeInsets.only(top: 70.0)),
              // contentButtonConnect(),
              contentButtonNoConnect(),
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
            //   ),
            // ],
          ),
        ),
      ),
    );
  }
}
