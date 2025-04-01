import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sso/component/link_url_in.dart';
import 'dart:async';
import 'package:sso/component/link_url_out.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:sso/shared/extension.dart';

class PrivilegeForm extends StatefulWidget {
  PrivilegeForm({Key? key, required this.code, this.model}) : super(key: key);
  final String code;
  final dynamic model;

  @override
  _PrivilegeDetailPageState createState() =>
      _PrivilegeDetailPageState(code: code);
}

class _PrivilegeDetailPageState extends State<PrivilegeForm> {
  _PrivilegeDetailPageState({required this.code});

  late Future<dynamic> _futureModel;
  String _urlShared = '';
  String code;

  @override
  void initState() {
    super.initState();
    sharedApi();
    _futureModel = postDio(privilegeReadApi, {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
  }

  Future<dynamic> sharedApi() async {
    final result = await postObjectData('configulation/shared/read', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });

    if (result['status'] == 's') {
      setState(() {
        _urlShared = result['objectData']['description'].toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );

    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: _futureModel, // function where you call your api
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          // AsyncSnapshot<Your object type>

          if (snapshot.hasData) {
            return myCard(snapshot.data[0]);
          } else {
            if (widget.model != null) {
              return myCard(widget.model);
            } else {
              return Container(
                alignment: Alignment.bottomCenter,
                color: Colors.white,
                height: height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 50),
                                  child: Image.network(
                                    '',
                                    height: 350,
                                    width: double.infinity,
                                    loadingBuilder: (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: new BorderRadius.only(
                                      bottomLeft: const Radius.circular(40.0),
                                      bottomRight: const Radius.circular(40.0),
                                    ),
                                    color: Color(0xFF005C9E),
                                  ),
                                  height: 170.0,
                                  width: double.infinity,
                                  child: Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: width - 80.0,
                                            margin: EdgeInsets.only(
                                              top: statusBarHeight + 10,
                                            ),
                                            padding: EdgeInsets.only(
                                              left: 15.0,
                                            ),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              top: statusBarHeight,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                  top: 5.0,
                                                  right: 15.0,
                                                ),
                                                width: 35.0,
                                                height: 35.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                        17.5,
                                                      ),
                                                  color: Color(0xFF3880B3),
                                                ),
                                                child: Icon(
                                                  Icons.close,
                                                  size: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.only(
                                              left: 15.0,
                                              top: 5.0,
                                            ),
                                            // color: Colors.orange,
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                    '',
                                                  ),
                                                  radius: 15.0,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        left: 16.0,
                                                      ),
                                                      child: Text(
                                                        '',
                                                        style: TextStyle(
                                                          fontFamily: 'Kanit',
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 16.0,
                                                              ),
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Kanit',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                left: 5.0,
                                                              ),
                                                          child: Text(
                                                            '',
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  'Kanit',
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 70.0,
                                            height: 30.0,
                                            margin: EdgeInsets.only(
                                              right: 10.0,
                                              top: 10.0,
                                            ),
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/share.png',
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.bottomRight,
                                            child: TextButton(
                                              onPressed: () {},
                                              child: TextButton(
                                                onPressed: () {},
                                                child: Container(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 15.0, top: 50.0),
                              child: Text(
                                'เงื่อนไขการรับสิทธิ์',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                            Html(data: ''),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (BuildContext context) =>
                                  new CupertinoAlertDialog(
                                    title: new Text(
                                      'test',
                                      style: TextStyle(
                                        // fontWeight: FontWeight.normal,
                                        fontSize: 20,
                                        fontFamily: 'Kanit',
                                        color: Colors.black,
                                      ),
                                    ),
                                    content: Text(" "),
                                    actions: [
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        child: new Text(
                                          "ยกเลิก",
                                          style: TextStyle(
                                            // fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            fontFamily: 'Kanit',
                                            color: Color(0xFF6C6C6C),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        isDefaultAction: true,
                                        child: new Text(
                                          "โทร",
                                          style: TextStyle(
                                            // fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            fontFamily: 'Kanit',
                                            color: Color(0xFF005C9E),
                                          ),
                                        ),
                                        onPressed: () {
                                          //to do...
                                        },
                                      ),
                                    ],
                                  ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 80.0,
                        width: double.infinity,
                        color: Color(0xFF005C9E),
                        // height: double.infinity,
                        child: Text(
                          'กดเพื่อรับสิทธิ์',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Kanit',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  myCard(dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      alignment: Alignment.bottomCenter,
      color: Colors.white,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 50),
                        child: Image.network(
                          model['imageUrl'],
                          height: 350,
                          fit: BoxFit.cover,
                          loadingBuilder: (
                            BuildContext context,
                            Widget child,
                            ImageChunkEvent? loadingProgress,
                          ) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value:
                                    loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                              ),
                            );
                          },
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          borderRadius: new BorderRadius.only(
                            bottomLeft: const Radius.circular(40.0),
                            bottomRight: const Radius.circular(40.0),
                          ),
                          color: Color(0xFF005C9E),
                        ),
                        // color: Colors.orange
                        height: 160.0,
                        width: double.infinity,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: width - 80.0,
                                  margin: EdgeInsets.only(
                                    top: statusBarHeight + 10,
                                  ),
                                  padding: EdgeInsets.only(left: 15.0),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    model['title'],
                                    style: TextStyle(
                                      fontFamily: 'Kanit',
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: statusBarHeight),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        top: 5.0,
                                        right: 15.0,
                                      ),
                                      width: 35.0,
                                      height: 35.0,
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.circular(
                                          17.5,
                                        ),
                                        color: Color(0xFF3880B3),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(
                                    left: 15.0,
                                    top: 5.0,
                                  ),
                                  // color: Colors.orange,
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          model['imageUrlCreateBy'],
                                        ),
                                        radius: 15.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 16.0,
                                            ),
                                            child: Text(
                                              model['createBy'],
                                              style: TextStyle(
                                                fontFamily: 'Kanit',
                                                fontSize: 13,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 16.0,
                                                ),
                                                child: Text(
                                                  dateStringToDate(
                                                    model['updateDate'],
                                                  ),
                                                  style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Text(
                                                  model['view'] != null
                                                      ? '| เข้าชม ' +
                                                          model['view']
                                                              .toString() +
                                                          ' ครั้ง'
                                                      : '| เข้าชม 0 ครั้ง',
                                                  style: TextStyle(
                                                    fontFamily: 'Kanit',
                                                    fontSize: 10,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 70.0,
                                  height: 30.0,
                                  margin: EdgeInsets.only(
                                    right: 10.0,
                                    top: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        'assets/images/share.png',
                                      ),
                                    ),
                                  ),
                                  alignment: Alignment.bottomRight,
                                  child: TextButton(
                                    onPressed: () {
                                      final RenderBox box =
                                          context.findRenderObject()
                                              as RenderBox;
                                      Share.share(
                                        _urlShared +
                                            'content/privilege/' +
                                            model['code'] +
                                            model['title'],
                                        subject: model['title'],
                                        sharePositionOrigin:
                                            box.localToGlobal(Offset.zero) &
                                            box.size,
                                      );
                                    },
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.all(10.0),
                                      backgroundColor: Colors.transparent,
                                      side: BorderSide(
                                        color: Color(0xFF707070),
                                      ),
                                    ),
                                    child: Text(
                                      'แชร์',
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: Colors.black,
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
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15.0, top: 40.0),
                    child: Text(
                      'เงื่อนไขการรับสิทธิ์',
                      style: TextStyle(fontSize: 20.0, fontFamily: 'Kanit'),
                    ),
                  ),

                  Html(
                    data: model['description'],
                    onLinkTap: (
                      String? url,
                      Map<String, String> attributes,
                      element,
                    ) {
                      launchInWebViewWithJavaScript(url!);
                      //open URL in webview, or launch URL in browser, or any other logic here
                    },
                  ),
                ],
              ),
            ),
          ),
          // btnPrivilege(model),
        ],
      ),
    );
  }

  btnPrivilege(dynamic model) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder:
              (BuildContext context) => new CupertinoAlertDialog(
                title: new Text(
                  'ยืนยัน',
                  style: TextStyle(
                    // fontWeight: FontWeight.normal,
                    fontSize: 20,
                    fontFamily: 'Kanit',
                    color: Colors.black,
                  ),
                ),
                content: Text("คุณยืนยันที่จะรับสิทธิ์ " + model['title']),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: new Text(
                      "ยกเลิก",
                      style: TextStyle(
                        // fontWeight: FontWeight.normal,
                        fontSize: 15,
                        fontFamily: 'Kanit',
                        color: Color(0xFF6C6C6C),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
                      //
                    },
                  ),
                ],
              ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        height: 80.0,
        width: double.infinity,
        color: Color(0xFF005C9E),
        // height: double.infinity,
        child: Text(
          'กดเพื่อรับสิทธิ์',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Kanit',
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
