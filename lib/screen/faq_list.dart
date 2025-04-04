import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:sso/pages/auth/login.dart';
import 'package:sso/pages/home.dart';
import 'package:sso/pages/v2/menu_v2.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/shared/api_provider.dart';

import '../component/header.dart';
import '../component/material/input_with_label.dart';

class faqListPage extends StatefulWidget {
  const faqListPage({Key? key, required this.username}) : super(key: key);
  final String username;
  @override
  _faqListPageState createState() => _faqListPageState();
}

class _faqListPageState extends State<faqListPage> {
  late Future<dynamic> futureModel;

  RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() {
    // futureModel = postDio('${server}m/faq/read', {});
    futureModel = Future.value([
      {'code': '1', 'title': 'วิธีการสมัครเป็นผู้ประกันตน'},
      {'code': '2', 'title': 'การขอรับเงินเยียวยากรณีว่างงาน'},
      {'code': '3', 'title': 'การส่งเงินสมทบ'},
      {'code': '4', 'title': 'วิธีการสมัครเป็นผู้ประกันตน'},
      {'code': '5', 'title': 'การขอรับเงินเยียวยากรณีว่างงาน'},
    ]);
  }

  void _onRefresh() async {
    _callRead();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerV3(context, goBack, title: "คำถามที่พบบ่อย"),
      backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              Container(
                height: 180,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 151,
                      color: Color(0xFF64C5D7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สวัสดีครับ ${widget.username}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          Text(
                            'ต้องการความช่วยเหลือหรือสงสัยเรื่องใดครับ',
                            style: TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Positioned(
                    //   top: 126,
                    //   right: 0,
                    //   left: 0,
                    //   child: Container(
                    //     alignment: Alignment.center,
                    //     color: Colors.transparent,
                    //     width: MediaQuery.of(context).size.width,
                    //     padding: EdgeInsets.only(
                    //       left: 15,
                    //       right: 15,
                    //     ),
                    //     child: Container(
                    //       height: 35,
                    //       margin: EdgeInsets.only(top: 7),
                    //       // child: KeySearch(),
                    //       child: InkWell(
                    //         onTap: () {},
                    //         child: Container(
                    //           // height: 30,
                    //           padding: EdgeInsets.only(left: 10),
                    //           decoration: BoxDecoration(
                    //             color: Colors.white,
                    //             borderRadius: BorderRadius.circular(20),
                    //             border: Border.all(
                    //               width: 1,
                    //               color: Color(0XFF68C5D6),
                    //             ),
                    //           ),
                    //           child: Row(
                    //             mainAxisAlignment: MainAxisAlignment.start,
                    //             children: [
                    //               // _buildCurrentLocationBar(),
                    //               Image.asset(
                    //                 'assets/images/search.png',
                    //                 height: 18.0,
                    //                 width: 18.0,
                    //                 color: Color(0XFF68C5D6),
                    //               ),
                    //               SizedBox(width: 10),
                    //               Text(
                    //                 'ค้นหา',
                    //                 style: TextStyle(
                    //                   fontFamily: 'Kanit',
                    //                   fontSize: 13,
                    //                   color: Color(0xFF707070),
                    //                 ),
                    //               ),
                    //               // SizedBox(width: 10),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Positioned(
                      top: 126,
                      right: 0,
                      left: 0,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        // width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Container(
                          height: 35,
                          margin: EdgeInsets.only(top: 7),
                          // child: KeySearch(),
                          child: Container(
                            // height: 30,
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              decoration: DecorationRegister.searchHospital(
                                context,
                                hintText: 'ค้นหา',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 30),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text(
                  'คำถามยอดฮิต',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: _listView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _listView() {
    return FutureBuilder<dynamic>(
      future: futureModel,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // ignore: deprecated_member_use
          var children = <Widget>[];
          for (var i = 0; i < snapshot.data.length; i++) {
            children.add(_buildItem(snapshot.data[i]['title']));
          }

          return Column(children: children);
        } else {
          return Container();
        }
      },
    );
  }

  _buildItem(String title, {Function? onTap}) {
    return InkWell(
      onTap: () => onTap!(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontSize: 13)),
                    Container(height: 1, color: Colors.grey.withOpacity(0.4)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
