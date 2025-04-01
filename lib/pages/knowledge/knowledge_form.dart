import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sso/component/link_url_in.dart';
import 'package:sso/component/link_url_out.dart';
import 'dart:async';

// import 'package:sso/component/downloadFile.dart';
import 'package:sso/component/pdf_viewer_page.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:flutter/services.dart';
import 'package:sso/shared/extension.dart';

class KnowledgeForm extends StatefulWidget {
  KnowledgeForm({
    Key? key,
    required this.code,
    this.model,
    required this.urlComment,
  }) : super(key: key);
  final String code;
  final dynamic model;
  final String urlComment;

  @override
  _KnowledgeDetailPageState createState() =>
      _KnowledgeDetailPageState(code: code);
}

class _KnowledgeDetailPageState extends State<KnowledgeForm> {
  _KnowledgeDetailPageState({required this.code});

  late Future<dynamic> _futureModel;

  String code;

  @override
  void initState() {
    super.initState();
    _futureModel = post('${knowledgeApi}read', {
      'skip': 0,
      'limit': 1,
      'code': widget.code,
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () => {Navigator.pop(context)},
        child: Icon(Icons.close),
        backgroundColor: Color(0xFF3880B3),
      ),
      body: FutureBuilder<dynamic>(
        future: _futureModel,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            return myContent(snapshot.data[0]);
          } else {
            if (widget.model != null) {
              return myContent(widget.model);
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      // overflow: Overflow.visible,
                      children: [
                        Stack(
                          children: [
                            Container(height: 540, width: double.infinity),
                            Container(
                              height: 540,
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: 60.0),
                            Container(
                              height: 110,
                              width: double.infinity,
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 25,
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                    ),
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    '',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              width: 400.0,
                              padding: EdgeInsets.only(left: 90.0, right: 90.0),
                              child: Material(
                                elevation: 5.0,
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white,
                                child: Container(
                                  alignment: Alignment(1, 1),
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(Icons.book, color: Colors.blue),
                                        Text(
                                          'อ่าน',
                                          style: TextStyle(
                                            color: Colors.blue,
                                            fontFamily: 'Kanit',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }

  myContent(dynamic model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            // overflow: Overflow.visible,
            children: [
              Stack(
                children: [
                  Container(
                    height: 540,
                    width: double.infinity,
                    child: Image.network(model['imageUrl'], fit: BoxFit.cover),
                  ),
                  Container(height: 540, color: Colors.black.withOpacity(0.5)),
                ],
              ),
              Column(
                children: [
                  SizedBox(height: 60.0),
                  Image.network(model['imageUrl'], height: 334, width: 250),
                  Container(
                    height: 110,
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      top: 10.0,
                    ),
                    child: Column(
                      children: [
                        Text(
                          model['title'],
                          style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          dateStringToDate(model['createDate']),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    width: 400.0,
                    padding: EdgeInsets.only(left: 90.0, right: 90.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.white,
                      child: Container(
                        alignment: Alignment(1, 1),
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width,
                          onPressed: () {
                            // launchURL(model['fileUrl']);
                            launchInWebViewWithJavaScript(model['fileUrl']);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     // builder: (context) => FlutterDemo(storage: CounterStorage()),
                            //     builder: (context) => PdfViewerPage(
                            //       path: model['fileUrl'],
                            //     ),
                            //   ),
                            // );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(Icons.book, color: Colors.blue),
                              Text(
                                'อ่าน',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 50.0),
          Column(
            children: [
              TextDetail(
                title: 'ข้อมูล',
                value: '',
                fsTitle: 20.0,
                fsValue: 14.0,
                color: Colors.black,
              ),
              TextDetail(
                title: 'ผู้แต่ง',
                value: model['author'] != '' ? model['author'] : '-',
                fsTitle: 14.0,
                fsValue: 14.0,
                color: Colors.grey,
              ),
              TextDetail(
                title: 'สำนักพิมพ์',
                value: model['publisher'] != '' ? model['publisher'] : '-',
                fsTitle: 14.0,
                fsValue: 14.0,
                color: Colors.grey,
              ),
              TextDetail(
                title: 'หมวดหมู่',
                value:
                    model['categoryList'][0]['title'] != ''
                        ? model['categoryList'][0]['title']
                        : '-',
                fsTitle: 14.0,
                fsValue: 14.0,
                color: Colors.grey,
              ),
              TextDetail(
                title: 'ประเภทหนังสือ',
                value: model['bookType'] != '' ? model['bookType'] : '-',
                fsTitle: 14.0,
                fsValue: 14.0,
                color: Colors.grey,
              ),
              TextDetail(
                title: 'จำนวนหน้า',
                value:
                    model['numberOfPages'].toString() != ''
                        ? model['numberOfPages'].toString()
                        : '-',
                fsTitle: 14.0,
                fsValue: 14.0,
                color: Colors.grey,
              ),
              TextDetail(
                title: 'ขนาด',
                value: model['size'] != '' ? model['size'] : '-',
                fsTitle: 14.0,
                fsValue: 14.0,
                color: Colors.grey,
              ),
              SizedBox(height: 50.0),
              TextDetail(
                title: 'รายละเอียด',
                value: '',
                fsTitle: 20.0,
                fsValue: 14.0,
                color: Colors.black,
              ),
              SizedBox(height: 10.0),
              Container(
                width: 380,
                padding: EdgeInsets.only(left: 20.0, top: 5, right: 15.0),
                alignment: Alignment.topLeft,

                child: Html(
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
              ),
              SizedBox(height: 40.0),
            ],
          ),
        ],
      ),
    );
  }
}

class TextDetail extends StatelessWidget {
  TextDetail({
    Key? key,
    required this.title,
    required this.value,
    required this.fsTitle,
    required this.fsValue,
    required this.color,
  });

  final String title;
  final String value;
  final double fsTitle;
  final double fsValue;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 140,
          padding: EdgeInsets.only(left: 20.0, top: 5, right: 15.0),
          alignment: Alignment.topLeft,
          child: Text(
            title,
            style: TextStyle(
              fontSize: fsTitle,
              color: color,
              fontFamily: 'Kanit',
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 20.0, top: 5),
            child: Text(
              value,
              style: TextStyle(
                fontSize: fsValue,
                color: color,
                fontFamily: 'Kanit',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
