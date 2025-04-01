// ignore_for_file: library_private_types_in_public_api, prefer_interpolation_to_compose_strings, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/comment_loading.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';

// ignore: must_be_immutable
class Comment extends StatefulWidget {
  Comment({
    super.key,
    required this.code,
    required this.url,
    required this.model,
    required this.limit,
  });

  final String code;
  final String url;
  Future<dynamic> model;
  final int limit;

  @override
  _Comment createState() => _Comment();
}

class _Comment extends State<Comment> {
  final txtDescription = TextEditingController();
  late FlutterSecureStorage storage;
  String username = '';
  String imageUrlCreateBy = '';

  // Future<dynamic> _futureModel;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    storage = FlutterSecureStorage();
    print('--------------- initState limit (${widget.limit})--------------');

    // setState(() {
    //   _futureModel = widget.model;
    // });
    getUser();
    super.initState();
    // _futureModel = post(
    //     '${widget.url}read', {'skip': 0, 'limit': 10, 'code': widget.code});
  }

  getUser() async {
    var value = await storage.read(key: 'dataUserLoginSSO');
    var data = json.decode(value!);

    setState(() {
      imageUrlCreateBy = data['imageUrl'];
      username = data['firstName'] + ' ' + data['lastName'];
    });
  }

  // @override
  // void didChangeDependencies() {
  //   print('--------------- didChangeDependencies limit (${widget.limit})--------------');

  //   setState(() {
  //     _futureModel = widget.model;
  //   });

  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          alignment: Alignment.centerLeft,
          child: Text(
            'แสดงความคิดเห็น',
            style: TextStyle(fontSize: 15, fontFamily: 'Kanit'),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 15, left: 15, right: 15),
          child: TextField(
            controller: txtDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            maxLength: 100,
            style: TextStyle(fontSize: 13, fontFamily: 'Kanit'),
            // decoration: new InputDecoration(hintText: "Enter Something", contentPadding: const EdgeInsets.all(20.0)),
            decoration: InputDecoration(
              fillColor: Colors.white,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.black.withAlpha(50),
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                gapPadding: 1,
              ),
              hintText: 'แสดงความคิดเห็น',
              contentPadding: const EdgeInsets.all(10.0),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          alignment: Alignment.centerRight,
          // color: Colors.red,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF235789), // Background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: EdgeInsets.all(10.0),
              splashFactory:
                  NoSplash.splashFactory, // To remove the splash effect
              elevation: 0, // Optional: Removes the elevation
            ),
            onPressed: () {
              if (txtDescription.text != '') {
                postAny('${widget.url}create', {
                      'createBy': username,
                      'imageUrlCreateBy': imageUrlCreateBy,
                      'reference': widget.code,
                      'description': txtDescription.text,
                    })
                    .then((response) {
                      if (response == 'S') {
                        txtDescription.text = '';
                        unfocus(context);

                        setState(() {
                          widget.model = post('${newsCommentApi}read', {
                            'skip': 0,
                            'limit': widget.limit,
                            'code': widget.code,
                          });
                        });

                        return showDialog(
                          context: context,
                          builder:
                              (BuildContext context) => CupertinoAlertDialog(
                                title: Text(
                                  'ขอบคุณสำหรับความคิดเห็น',
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
                    })
                    .catchError((onError) {
                      return showDialog(
                        context: context,
                        builder:
                            (BuildContext context) => CupertinoAlertDialog(
                              title: Text(
                                'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
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
                    });
              }
            },
            child: Text(
              'ส่ง',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Kanit',
              ),
            ),
          ),
        ),
        FutureBuilder<dynamic>(
          // future: widget.model,
          future: widget.model,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return myComment(
                snapshot.data,
              ); // } else if (snapshot.hasError) {
              //   return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return CommentLoading();
              // return Container();
            }

            // if (snapshot.hasError) {
            //   return Text(snapshot.error.toString());
            // }

            // return Container(
            //   alignment: Alignment.center,
            //   height: 200,
            //   child: Text('Loading...'),
            // );
          },
        ),
      ],
    );
  }

  myComment(dynamic model) {
    return ListView.builder(
      shrinkWrap: true, // 1st add
      physics: ClampingScrollPhysics(), // 2nd
      // scrollDirection: Axis.horizontal,
      itemCount: model.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
              '${model[index]['imageUrlCreateBy']}',
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: 5,
                      left: 15,
                      right: 15,
                    ),
                    margin: EdgeInsets.only(
                      left: 1,
                      right: 15,
                      top: 5,
                      bottom: 1,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(10),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withAlpha(50)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model[index]['createBy']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            fontFamily: 'Kanit',
                          ),
                        ),
                        Text(
                          '${model[index]['description']}',
                          style: TextStyle(fontSize: 13, fontFamily: 'Kanit'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  dateStringToDate(model[index]['createDate']),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.black.withAlpha(80),
                    fontFamily: 'Kanit',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// SmartRefresher(
//           enablePullDown: true,
//           enablePullUp: false,
//           footer: ClassicFooter(
//             loadingText: ' ',
//             idleIcon: Icon(Icons.arrow_upward, color: Colors.transparent),
//           ),
//           controller: _refreshController,
//           onLoading: _onLoading,
//           child: FutureBuilder<dynamic>(
//             // future: widget.model,
//             future: _futureModel,
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.hasData) {
//                 return myComment(
//                     snapshot.data); // } else if (snapshot.hasError) {
//                 //   return Center(child: Text('Error: ${snapshot.error}'));
//               } else {
//                 return CommentLoading();
//                 // return Container();
//               }

//               // if (snapshot.hasError) {
//               //   return Text(snapshot.error.toString());
//               // }

//               // return Container(
//               //   alignment: Alignment.center,
//               //   height: 200,
//               //   child: Text('Loading...'),
//               // );
//             },
//           ),
//         )
