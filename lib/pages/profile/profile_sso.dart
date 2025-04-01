import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileSSOPage extends StatefulWidget {
  ProfileSSOPage({Key? key, required this.model}) : super(key: key);

  final Future<dynamic> model;

  @override
  _ProfileSSOPageState createState() => _ProfileSSOPageState();
}

class _ProfileSSOPageState extends State<ProfileSSOPage> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();

  String _imageUrl = '';

  late Future<dynamic> futureModel;

  ScrollController scrollController = new ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    readStorage();
    super.initState();
  }

  _makePhoneCall(String url) async {
    url = 'tel:' + url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  readStorage() async {
    var value = await storage.read(key: 'dataUserLoginSSO');
    if (value != null) {
      var user = json.decode(value);
      if (user['code'] != '') {
        setState(() {
          _imageUrl = user['imageUrl'] ?? '';
        });
      }
    }
  }

  card(data) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard(data)),
    );
  }

  contentCard(data) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 45.0)),
          Center(
            child: Text(
              'สำนักงานประกันสังคม',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 20.0,
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Center(
            child: Text(
              'กระทรวงแรงงาน',
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 15.0,
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          rowData(
            icon: Icon(Icons.location_on, color: Colors.white, size: 20.0),
            title: data['address'] ?? '-',
          ),
          rowData(
            icon: Icon(Icons.public, color: Colors.white, size: 20.0),
            title: data['site'] ?? '-',
          ),
          rowData(
            icon: Icon(Icons.phone, color: Colors.white, size: 20.0),
            title: data['telephone'] ?? '-',
          ),
          // rowData(
          //   icon: Icon(
          //     Icons.email,
          //     color: Colors.white,
          //     size: 20.0,
          //   ),
          //   title: data['email'] ?? '-',
          // ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Container(
            alignment: Alignment.center,
            child: ButtonTheme(
              minWidth: 200.0,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  backgroundColor: Color(0xFFFFC324),
                  padding: EdgeInsets.all(10.0),
                ),
                onPressed: () {
                  _makePhoneCall(data['telephone']);
                },
                child: Text(
                  "โทร",
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

  Widget rowData({required Icon icon, String title = ''}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Color(0xFF005C9E),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(child: icon),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(
                  fontFamily: 'Kanit',
                  fontSize: 10,
                  color: Color(0xFF005C9E),
                ),
              ),
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
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Image.asset(
              "assets/background/login.png",
              fit: BoxFit.cover,
            ),
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else if (snapshot.hasData) {
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
                          Padding(
                            padding: EdgeInsets.only(top: 75.0),
                            child: card(snapshot.data),
                          ),
                          Container(
                            width: 150.0,
                            height: 150.0,
                            child: Padding(
                              padding: EdgeInsets.all(0.0),
                              child: DecoratedBox(
                                decoration: ShapeDecoration(
                                  shape: CircleBorder(),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:
                                        snapshot.data['imageLogoUrl'] != null
                                            ? NetworkImage(
                                              snapshot.data['imageLogoUrl'],
                                            )
                                            : AssetImage(
                                              "assets/logo/noImage.png",
                                            ),
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
          } else {
            return Container();
          }
        }
      },
    );
  }
}
