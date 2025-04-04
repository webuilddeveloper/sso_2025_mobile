import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/component/material/content_with_out_share.dart';
import 'package:sso/pages/blank_page/blank_loading.dart';
import 'package:sso/pages/v2/menu_v2.dart';
import 'package:sso/screen/feedback/feedback_form.dart';
import 'package:sso/shared/api_provider.dart' as service;
import 'package:sso/shared/api_provider.dart';
// import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';

// import '../../shared/api_provider.dart';

class FeedbackMain extends StatefulWidget {
  const FeedbackMain({
    Key? key,
    required this.code,
    required this.title,
    this.callback,
  }) : super(key: key);

  final String code;
  final String title;
  final Function? callback;

  @override
  _FeedbackMain createState() => _FeedbackMain();
}

List<ImageProvider> galleryItems = [];
List<dynamic> gallerys = [];
String? image;

class _FeedbackMain extends State<FeedbackMain> {
  ScrollController scrollController = new ScrollController();
  late Future<dynamic> _futureModel;
  late Future<dynamic> futureGalleryModel;
  @override
  void initState() {
    scrollController = ScrollController();
    _futureModel = post('${service.reporterApi}read', {'skip': 0, 'limit': 10});
    super.initState();
    // readFeedbackGallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerV3(context, goBack, title: 'ข้อเสนอแนะ'),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: FutureBuilder<dynamic>(
          future: _futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return Container(
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'ประวัติข้อเสนอแนะของท่าน',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontSize: 15,
                            letterSpacing: 0.23,
                          ),
                        ),
                      ),
                      ListView.builder(
                        controller: scrollController,
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  // onTap: () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) => KnowledgeForm(
                                  //         code: snapshot.data[index]['code'],
                                  //       ),
                                  //     ),
                                  //   );
                                  // },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              alignment: Alignment.topLeft,
                                              // height: 80,
                                              // width: 80,
                                              margin: EdgeInsets.only(
                                                top: 10.0,
                                                right: 10.0,
                                              ),
                                              decoration: new BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.blueGrey,
                                                    spreadRadius: 0,
                                                  ),
                                                ],
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                      11.0,
                                                    ),
                                              ),
                                              child: FutureBuilder<dynamic>(
                                                future: readFeedbackGallery(
                                                  snapshot.data[index]['code'],
                                                ),
                                                builder: (context, gallerySnapshot) {
                                                  if (gallerySnapshot.hasData) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10.0,
                                                          ),
                                                      child:
                                                          loadingImageNetwork(
                                                            gallerySnapshot.data,
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.fill,
                                                          ),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                },
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                top: 10.0,
                                              ),
                                              height: 80,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: FutureBuilder<
                                                      dynamic
                                                    >(
                                                      future: readCategory(
                                                        snapshot
                                                            .data[index]['title'],
                                                      ),
                                                      builder: (
                                                        context,
                                                        title,
                                                      ) {
                                                        if (title.hasData) {
                                                          return Text(
                                                            title.data,
                                                            // 'การติดต่อประกันสังคม',
                                                            style: TextStyle(
                                                              fontSize: 13,
                                                              color:
                                                                  Colors.black,
                                                              fontFamily:
                                                                  'Kanit',
                                                            ),
                                                          );
                                                        } else {
                                                          return Container();
                                                        }
                                                      },
                                                    ),

                                                    // child: Text(
                                                    //   snapshot.data[index]
                                                    //       ['title'],
                                                    //   // 'การติดต่อประกันสังคม',
                                                    //   style: TextStyle(
                                                    //     fontSize: 13,
                                                    //     color: Colors.black,
                                                    //     fontFamily: 'Kanit',
                                                    //   ),
                                                    // ),
                                                  ),
                                                  Container(
                                                    child: Text(
                                                      'ส่งเมื่อวันที่ ' +
                                                          dateStringToDate(
                                                            snapshot
                                                                .data[index]['createDate'],
                                                          ),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontFamily: 'Kanit',
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10.0),
                                          height: 80,
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            height: 35,
                                            width: 35,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Color(0xFFE8F0F6),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(7.0),
                                              child: Image.asset(
                                                snapshot.data[index]['status2'] ==
                                                        'C'
                                                    ? 'assets/logo/icons/check.png'
                                                    : 'assets/logo/icons/process.png',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 20.0),
                        child: MaterialButton(
                          height: 35,
                          minWidth: 168,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(28),
                          ),
                          onPressed:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FeedbackForm(code: '', title: '',),
                                ),
                              ),
                          child: Text(
                            "ส่งข้อเสนอแนะ",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          color: Color(0xFFE4A025),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                  alignment: Alignment.center,
                  height: 200,
                  child: Text(
                    'ไม่พบข้อมูล',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Kanit',
                      color: Color.fromRGBO(0, 0, 0, 0.6),
                    ),
                  ),
                );
              }
            } else {
              // return CircularProgressIndicator();
              return Container(
                alignment: Alignment.center,
                height: 200,
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  readFeedbackGallery(param) async {
    // print('----------------');
    // futureGalleryModel = post(reporterGalleryApi, {'skip': 0, 'limit': 10, 'code' : });
    var data = await post(reporterGalleryApi, {'code': param});
    return data[0]['imageUrl'] ?? '';
  }

  readCategory(param) async {
    // print('----------------');
    // futureGalleryModel = post(reporterGalleryApi, {'skip': 0, 'limit': 10, 'code' : });
    var data = await post(reporterCategoryApi, {'code': param});
    return data[0]['title'] ?? '';
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  // buttonCloseBack() {
  //   return Column(
  //     children: [
  //       Container(
  //         // width: 60,
  //         // color: Colors.red,
  //         // alignment: Alignment.centerRight,
  //         child: MaterialButton(
  //           minWidth: 29,
  //           onPressed: () {
  //             widget.callback();
  //           },
  //           color: Color.fromRGBO(194, 223, 249, 1),
  //           textColor: Colors.white,
  //           child: Icon(
  //             Icons.close,
  //             size: 29,
  //           ),
  //           shape: CircleBorder(),
  //         ),
  //       ),
  //     ],
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.end,
  //   );
  // }
}
