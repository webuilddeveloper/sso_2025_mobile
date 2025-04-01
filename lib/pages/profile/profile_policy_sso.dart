// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/header.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/shared/api_provider.dart';

class ProfilePolicySSOPage extends StatefulWidget {
  @override
  _ProfilePolicySSOPageState createState() => _ProfilePolicySSOPageState();
}

class _ProfilePolicySSOPageState extends State<ProfilePolicySSOPage> {
  final storage = FlutterSecureStorage();

  late String _username;

  List<dynamic> _dataPolicy = [];

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      futureModel = readPolicy();
    });

    super.initState();
  }

  Future<dynamic> readPolicy() async {
    List<dynamic> _dataPolicySet = [];

    final result = await postObjectData('m/policy/read', {
      'username': _username,
      'category': 'register',
    });

    if (result['status'] == 'S') {
      setState(() {
        _dataPolicySet = [..._dataPolicySet, ...result['objectData']];
      });
    }

    final result1 = await postObjectData('m/policy/read', {
      'username': _username,
      'category': 'verification',
    });

    if (result1['status'] == 'S') {
      setState(() {
        _dataPolicySet = [..._dataPolicySet, ...result1['objectData']];
      });
    }
    setState(() {
      _dataPolicy = [..._dataPolicy, ..._dataPolicySet];
    });

    final result2 = await postObjectData('m/policy/read', {
      'username': _username,
      'category': 'marketing',
    });

    if (result2['status'] == 'S') {
      setState(() {
        _dataPolicySet = [..._dataPolicySet, ...result2['objectData']];
      });
    }
    setState(() {
      _dataPolicy = [..._dataPolicy, ..._dataPolicySet];
    });
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: formContentStep1()),
    );
  }

  formContentStep1() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(top: 45.0)),
        Center(
          child: Text(
            'สำนักงานประกันสังคม',
            textAlign: TextAlign.center,
            style: TextStyle(
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
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 10.0)),
        for (var item in _dataPolicy)
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Html(data: item['description'].toString()),
            ),
          ),
      ],
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
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 75.0),
                          child: card(),
                        ),
                        SizedBox(
                          width: 150.0,
                          height: 150.0,
                          child: Padding(
                            padding: EdgeInsets.all(0.0),
                            child: DecoratedBox(
                              decoration: ShapeDecoration(
                                shape: CircleBorder(),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage("assets/logoNoText.png"),
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
      },
    );
  }
}
