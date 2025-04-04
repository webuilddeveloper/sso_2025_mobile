import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/component/material/content_with_out_share.dart';
import 'package:sso/pages/blank_page/blank_loading.dart';
import 'package:sso/pages/v2/menu_v2.dart';
import 'package:sso/shared/api_provider.dart';

class FeedbackForm extends StatefulWidget {
  FeedbackForm({
    Key? key,
    required this.code,
    required this.title,
    this.callback,
  }) : super(key: key);

  final String code;
  final String title;
  final Function? callback;

  @override
  _FeedbackForm createState() => _FeedbackForm();
}

XFile? _image;
List<dynamic>? _itemImage = [];
List<dynamic>? reporterCategoryList;
List<dynamic>? provinceList;
final storage = FlutterSecureStorage();

class _FeedbackForm extends State<FeedbackForm> {
  late Future<dynamic> _futureModel;
  late Future<dynamic> _futureCategoryModel;

  final txtDescription = TextEditingController();
  String selectCategoryValue = '';
  String selectProvinceValue = '';
  List<dynamic> _itemImage = [];
  late String imageUrl;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    reporterCategoryList = [
      {'title': 'กรุณาเลือกหัวข้อ', 'value': ''},
    ];
    provinceList = [
      {'title': 'กรุณาเลือกสถานที่', 'code': ''},
    ];
    // print('oo $reporterCategoryList');
    // _futureModel = postDio(comingSoonApi, {'codeShort': widget.code});
    scrollController = ScrollController();
    _readCategory();
    _readProvince();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: headerV3(context, goBack, title: 'สร้างข้อเสนอแนะ'),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: FutureBuilder<dynamic>(
          future: _futureModel,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return Container(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: [
                      DropdownButtonFormField<dynamic>(
                        value: selectCategoryValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0B5C9E),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFE4E4E4),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          hintText: 'กรุณาเลือกสถานที่',
                          contentPadding: const EdgeInsets.all(10.0),
                        ),
                        validator:
                            (value) =>
                                value == '' || value == null
                                    ? 'กรุณาเลือกหัวข้อ'
                                    : null,
                        onChanged: (d) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectCategoryValue = d;
                          });
                          print('00000000 $selectCategoryValue');
                        },
                        items:
                            reporterCategoryList?.map((item) {
                              // print(item);
                              return DropdownMenuItem(
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                                value: item['value'],
                              );
                            }).toList(),
                      ),

                      SizedBox(height: 20),
                      Container(
                        child: Column(
                          children: [
                            TextField(
                              // controller: txtDescription,
                              keyboardType: TextInputType.multiline,
                              maxLines: 4,
                              // maxLength: 100,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Kanit',
                                color: Color(0xFF005C9E),
                              ),
                              decoration: InputDecoration(
                                fillColor: Color(0xFFE8F0F6),
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFF0B5C9E),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xFFE8F0F6),
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    topRight: Radius.circular(5.0),
                                  ),
                                  gapPadding: 1,
                                ),
                                hintText: 'กรุณาใส่รายละเอียด หรือ แนบรูปภาพ',
                                contentPadding: const EdgeInsets.all(10.0),
                              ),
                              controller: txtDescription,
                            ),
                            if (_itemImage.length > 0)
                              Container(
                                color: Color(0xFFE8F0F6),
                                padding: EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 10.0,
                                ),
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 1 / 1,
                                      ),
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _itemImage.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 5.0),
                                      width: 400,
                                      child: MaterialButton(
                                        onPressed: () {
                                          dialogDeleteImage(
                                            _itemImage[index]['id'].toString(),
                                          );
                                        },
                                        child: loadingImageNetwork(
                                          _itemImage[index]['imageUrl'],
                                          width: 1000,
                                          fit: BoxFit.cover,
                                        ),
                                        // Image.network(
                                        //   _itemImage[index]['imageUrl'],
                                        //   width: 1000,
                                        //   fit: BoxFit.cover,
                                        // ),
                                        // ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              height: 34,
                              decoration: BoxDecoration(
                                color: Color(0xFF3880B3),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                ),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  _showPickerImage(context);
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 18,
                                      width: 18,
                                      margin: EdgeInsets.only(right: 8.0),
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: ExactAssetImage(
                                            'assets/logo/icons/picture.png',
                                          ),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'รูปภาพ',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Kanit',
                                          fontSize: 13,
                                          letterSpacing: 0.23,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      // FutureBuilder<dynamic>(
                      //     future:
                      //         _readCategory(snapshot.data[index]['code']),
                      //     builder: (context, _) {
                      //       if (_.hasData) {
                      //         return ClipRRect(
                      //             borderRadius: BorderRadius.circular(10.0),
                      //             child: loadingImageNetwork(
                      //               _.data,
                      //               height: 80,
                      //               width: 80,
                      //               fit: BoxFit.fill,
                      //             ));
                      //       } else {
                      //         return Container();
                      //       }
                      //     }),
                      DropdownButtonFormField<dynamic>(
                        value: selectProvinceValue,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFF0B5C9E),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0xFFE4E4E4),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(7),
                          ),
                          hintText: 'กรุณาเลือกสถานที่',
                          contentPadding: const EdgeInsets.all(10.0),
                        ),
                        onChanged: (d) {
                          setState(() {
                            selectProvinceValue = d;
                          });
                        },
                        items:
                            provinceList!.map((item) {
                              // print(item);
                              return DropdownMenuItem(
                                child: Text(
                                  item['title'],
                                  style: TextStyle(
                                    fontSize: 15.00,
                                    fontFamily: 'Kanit',
                                    color: Color(0xFF000070),
                                  ),
                                ),
                                value: item['code'],
                              );
                            }).toList(),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 29.0),
                    child: MaterialButton(
                      height: 35,
                      minWidth: 168,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      onPressed: () {
                        // launchInWebViewWithJavaScript(model['fileUrl']);
                        submitReporter();
                      },
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
          },
        ),
      ),
    );
  }

  void goBack() async {
    Navigator.pop(context, false);
  }

  buttonCloseBack() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          // width: 60,
          // color: Colors.red,
          // alignment: Alignment.centerRight,
          child: MaterialButton(
            minWidth: 29,
            onPressed: () {
              widget.callback!();
            },
            color: Color.fromRGBO(194, 223, 249, 1),
            textColor: Colors.white,
            child: Icon(Icons.close, size: 29),
            shape: CircleBorder(),
          ),
        ),
      ],
    );
  }

  void _showPickerImage(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text(
                    'อัลบั้มรูปภาพ',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text(
                    'กล้องถ่ายรูป',
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _imgFromCamera() async {
    // File image = await ImagePicker.pickImage(
    //   source: ImageSource.camera,
    //   imageQuality: 100,
    // );

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    _upload();
  }

  _imgFromGallery() async {
    // File image = await ImagePicker.pickImage(
    //   source: ImageSource.gallery,
    //   imageQuality: 100,
    // );

    final ImagePicker _picker = ImagePicker();
    // Pick an image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    _upload();
  }

  void _upload() async {
    if (_image == null) return;

    Random random = Random();
    uploadImageList(_image!)
        .then((res) {
          setState(() {
            _itemImage.add({'imageUrl': res, 'id': random.nextInt(100)});
          });
          // setState(() {
          //   _imageUrl = res;
          // });
        })
        .catchError((err) {
          print(err);
        });
  }

  dialogDeleteImage(String code) async {
    showDialog(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(
              'ต้องการลบรูปภาพ ใช่ไหม',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Kanit',
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
            content: Text(''),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "ยกเลิก",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFFF58A33),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text(
                  "ลบ",
                  style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Kanit',
                    color: Color(0xFF1B6CA8),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onPressed: () {
                  deleteImage(code);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
    );
  }

  deleteImage(String code) async {
    setState(() {
      _itemImage.removeWhere((c) => c['id'].toString() == code.toString());
    });
  }

  Future<dynamic> _readCategory() async {
    var listCat = [];
    final result = await postDio(reporterCategoryApi, {
      'skip': 0,
      'limit': 100,
    });
    // if (result['status'] == 'S') {
    // print('---> $result');
    setState(() {
      result.forEach((e) {
        listCat.add({'title': e['title'], 'value': e['code']});
      });
      reporterCategoryList = [...?reporterCategoryList, ...listCat];
    });

    // print('rr $reporterCategoryList');

    // }
  }

  Future<dynamic> _readProvince() async {
    var list = [];
    final result = await postObjectData(readProvinceApi, {
      "skip": 0,
      "limit": 100,
    });

    if (result['status'] == 'S') {
      setState(() {
        provinceList = [...?provinceList, ...result['objectData']];
      });
    }
    // print('------ $provinceList');
  }

  Future<dynamic> submitReporter() async {
    // var value = await storage.read(key: 'dataUserLoginKSP');
    // var user = json.decode(value);
    print('00000007777777777777777 $_itemImage');
    // var profileCode = await storage.read(key: 'profileCode8');
    var data = {
      "title": selectCategoryValue,
      "description": txtDescription.text,
      // ""
      // "createBy": user['username'] ?? '',
      // "firstName": user['firstName'] ?? '',
      // "lastName": user['lastName'] ?? '',
      // "imageUrlCreateBy": user['imageUrl'] ?? '',
      // "imageUrl": widget.imageUrl ?? '',
      "gallery": _itemImage,
      "province": selectProvinceValue ?? '',
      // "lv0": user['lv0'],
      // "lv1": user['lv1'],
      // "lv2": user['lv2'],
      // "lv3": user['lv3'],
      // "lv4": user['lv4'],
      // "countUnit": user['countUnit'],
      // "language": 'th',
      // "platform": Platform.operatingSystem.toString(),
      // "profileCode": profileCode,
      // "fixedCode": "0"
      "isActive": true,
      "status2": "A",
    };

    final result = await postObjectData('reporter/create', data);

    if (result['status'] == 'S') {
      _itemImage.forEach((element) {
        element['reference'] = result['objectData']['code'];
        final resultImage = postObjectData('reporter/gallery/create', element);
        print('00000007777777777777777 $element');
      });

      return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: Text(
                'บันทึกข้อมูลเรียบร้อยแล้ว',
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
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFFF58A33),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    goBack();
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: CupertinoAlertDialog(
              title: Text(
                'บันทึกข้อมูลไม่สำเร็จ',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              content: Text(
                result['message'],
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Kanit',
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(
                    "ตกลง",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: 'Kanit',
                      color: Color(0xFFF58A33),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                    // goBack();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }
}
