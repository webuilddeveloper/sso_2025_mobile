// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/models/user.dart';
import 'package:sso/pages/blank_page/blank_loading.dart';
import 'package:sso/pages/blank_page/toast_fail.dart';
// import 'package:sso/pages/event_calendar/event_calendar_form.dart';
import 'package:sso/pages/knowledge/knowledge_form.dart';
import 'package:sso/pages/news/news_form.dart';
// import 'package:sso/pages/poi/poi_form.dart';
// import 'package:sso/pages/poll/poll_form.dart';
import 'package:sso/pages/privilege/privilege_form.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sso/pages/notification/main_page_form.dart';

class NotificationList extends StatefulWidget {
  const NotificationList({super.key, required this.title, this.userData});

  final User? userData;
  final String title;

  @override
  _NotificationList createState() => _NotificationList();
}

class _NotificationList extends State<NotificationList> {
  late Future<dynamic> _futureModel;

  @override
  void initState() {
    super.initState();

    setState(() {
      _futureModel = post('${notificationApi}read', {
        'skip': 0,
        'limit': 999,
        'username': widget.userData!.username,
      });
    });
  }

  checkNavigationPage(String page, dynamic model) {
    switch (page) {
      case 'newsPage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      NewsFormPage(code: model['reference'], model: model),
            ),
          ).then(
            (value) => {
              setState(() {
                _futureModel = post('${notificationApi}read', {
                  'skip': 0,
                  'limit': 999,
                  'username': widget.userData!.username,
                });
              }),
            },
          );
        }
        break;

      // case 'eventPage':
      //   {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => EventCalendarForm(
      //           code: model['reference'],
      //           model: model,
      //         ),
      //       ),
      //     ).then((value) => {
      //           setState(() {
      //             _futureModel = post(
      //               '${notificationApi}read',
      //               {
      //                 'skip': 0,
      //                 'limit': 999,
      //                 'username': widget.userData.username
      //               },
      //             );
      //           })
      //         });
      //   }
      //   break;

      case 'privilegePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      PrivilegeForm(code: model['reference'], model: model),
            ),
          ).then(
            (value) => {
              setState(() {
                _futureModel = post('${notificationApi}read', {
                  'skip': 0,
                  'limit': 999,
                  'username': widget.userData!.username,
                });
              }),
            },
          );
        }
        break;

      case 'knowledgePage':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => KnowledgeForm(
                    code: model['reference'],
                    model: model,
                    urlComment: '',
                  ),
            ),
          ).then(
            (value) => {
              setState(() {
                _futureModel = post('${notificationApi}read', {
                  'skip': 0,
                  'limit': 999,
                  'username': widget.userData!.username,
                });
              }),
            },
          );
        }
        break;

      // case 'poiPage':
      //   {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PoiForm(
      //           url: poiApi + 'read',
      //           code: model['reference'],
      //           model: model,
      //           urlComment: poiCommentApi,
      //           urlGallery: poiGalleryApi,
      //         ),
      //       ),
      //     ).then((value) => {
      //           setState(() {
      //             _futureModel = post(
      //               '${notificationApi}read',
      //               {
      //                 'skip': 0,
      //                 'limit': 999,
      //                 'username': widget.userData.username
      //               },
      //             );
      //           })
      //         });
      //   }
      //   break;

      // case 'pollPage':
      //   {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => PollForm(
      //           code: model['reference'],
      //           model: model,
      //         ),
      //       ),
      //     ).then((value) => {
      //           setState(() {
      //             _futureModel = post(
      //               '${notificationApi}read',
      //               {
      //                 'skip': 0,
      //                 'limit': 999,
      //                 'username': widget.userData.username
      //               },
      //             );
      //           })
      //         });
      //   }
      //   break;

      case 'mainPage':
        {
          return Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      MainPageForm(code: model['reference'], model: model),
            ),
          ).then(
            (value) => {
              setState(() {
                _futureModel = post('${notificationApi}read', {
                  'skip': 0,
                  'limit': 999,
                  'username': widget.userData!.username,
                });
              }),
            },
          );
        }

      default:
        {
          return toastFail(context, text: 'เกิดข้อผิดพลาด');
        }
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Note: Sensitivity is integer used when you don't want to mess up vertical drag
        if (details.delta.dx > 10) {
          // Right Swipe
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: header(
          context,
          () => goBack(),
          title: widget.title,
          isButtonRight: true,
          rightButton: () => _handleClickMe(),
          menu: 'notification',
        ),
        backgroundColor: Colors.white,
        body: FutureBuilder<dynamic>(
          future: _futureModel, // function where you call your api
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                return ListView.builder(
                  shrinkWrap: true, // 1st add
                  physics: ClampingScrollPhysics(), // 2nd
                  // scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return card(context, snapshot.data[index]);
                  },
                );
              } else {
                return Container(
                  width: width,
                  margin: EdgeInsets.only(top: height * 30 / 100),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 70,
                        width: width,
                        child: Image.asset('assets/logo/logo.png'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 1 / 100),
                        alignment: Alignment.center,
                        width: width,
                        child: Text(
                          'ไม่พบข้อมูล',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else if (snapshot.hasError) {
              return SizedBox(
                width: width,
                height: height,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _futureModel = post('${notificationApi}read', {
                        'skip': 0,
                        'limit': 999,
                        'username': widget.userData!.username,
                      });
                    });
                  },
                  child: Icon(Icons.refresh, size: 50.0, color: Colors.blue),
                ),
              );
            } else {
              return ListView.builder(
                shrinkWrap: true, // 1st add
                physics: ClampingScrollPhysics(), // 2nd
                // scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return BlankLoading(width: width, height: height * 15 / 100);
                },
              );
            }
          },
        ),
      ),
    );
  }

  card(BuildContext context, dynamic model) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return InkWell(
      onTap:
          () => {
            postAny('${notificationApi}update', {
              'username': widget.userData!.username,
              'category': '${model['category']}',
              "code": '${model['code']}',
            }).then((response) {
              if (response == 'S') {
                checkNavigationPage(model['category'], model);
              }
            }),
          },
      child: Slidable(
        // actionPane: SlidableDrawerActionPane(),
        // actionExtentRatio: 0.25,
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          children: [
            InkWell(
              child: Icon(Icons.remove),
              onTap:
                  () => {
                    setState(() {
                      postAny('${notificationApi}delete', {
                        'username': widget.userData!.username,
                        'category': '${model['category']}',
                        "code": '${model['code']}',
                      }).then((response) {
                        if (response == 'S') {
                          setState(() {
                            _futureModel = post('${notificationApi}read', {
                              'skip': 0,
                              'limit': 999,
                              'username': widget.userData!.username,
                            });
                          });
                        }
                      });
                    }),
                  },
            ),
          ],
        ),
        // actionPane: SlidableDrawerActionPane(),
        // actionExtentRatio: 0.25,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.2 / 100),
          height: (height * 15) / 100,
          width: width,
          decoration: BoxDecoration(
            color: model['status'] == 'A' ? Colors.white : Color(0xFFE7E7EE),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 1 / 100,
                  vertical: height * 1.2 / 100,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: height * 0.7 / 100,
                        right: width * 1 / 100,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(height * 1 / 100),
                        color:
                            model['status'] == 'A' ? Colors.white : Colors.red,
                      ),
                      height: height * 2 / 100,
                      width: height * 2 / 100,
                    ),
                    Expanded(
                      child: Text(
                        '${model['title']}',
                        style: TextStyle(
                          fontSize: (height * 2) / 100,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF9D040C),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 5 / 100,
                  vertical: height * 1.5 / 100,
                ),
                child: Text(
                  '${dateStringToDate(model['createDate'])}',
                  style: TextStyle(
                    fontSize: (height * 1.7) / 100,
                    fontFamily: 'Kanit',
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleClickMe() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                'อ่านทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.lightBlue,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}update', {
                    'username': widget.userData!.username,
                  }).then((response) {
                    if (response == 'S') {
                      setState(() {
                        _futureModel = post('${notificationApi}read', {
                          'skip': 0,
                          'limit': 999,
                          'username': widget.userData!.username,
                        });
                      });
                    }
                  });
                });
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                'ลบทั้งหมด',
                style: TextStyle(
                  fontSize: 15.0,
                  fontFamily: 'Kanit',
                  fontWeight: FontWeight.normal,
                  color: Colors.red,
                ),
              ),
              onPressed: () {
                setState(() {
                  postAny('${notificationApi}delete', {
                    'username': widget.userData!.username,
                  }).then((response) {
                    if (response == 'S') {
                      setState(() {
                        _futureModel = post('${notificationApi}read', {
                          'skip': 0,
                          'limit': 999,
                          'username': widget.userData!.username,
                        });
                      });
                    }
                  });
                });
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDefaultAction: true,
            child: Text(
              'ยกเลิก',
              style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Kanit',
                fontWeight: FontWeight.normal,
                color: Colors.lightBlue,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
