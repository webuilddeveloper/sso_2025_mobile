import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sso/models/user.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sso/screen/login.dart';

import 'package:sso/shared/facebook_firebase.dart';
import 'package:sso/shared/google.dart';
import 'package:sso/shared/line.dart';

// flutter build apk --build-name=1.0.0 --build-number=1
const appName = 'SSO Plus';
const versionName = '0.0.3';
const versionNumber = 3;
const versionReadApi = server + 'm/v2/version/read';

const server = 'https://sso.we-builds.com/sso-api/';
const serverUpload = 'https://gateway.we-builds.com/wb-document/upload';

const sharedApi = server + 'configulation/shared/';
const registerApi = server + 'm/register/';
const newsApi = server + 'm/news/';
const newsGalleryApi = 'm/news/gallery/read';
const pollApi = server + 'm/poll/';
const faqApi = server + 'm/faq/';
const knowledgeApi = server + 'm/knowledge/';
const contactApi = server + 'm/contact/';
const bannerApi = server + 'banner/';
const bannerGalleryApi = 'm/banner/gallery/read';
const rotationApi = server + 'rotation/';
const rotationGalleryApi = 'm/rotation/gallery/read';
const privilegeReadApi = server + "m/privilege/read";
const menuApi = server + "m/menu/";
const aboutUsReadApi = server + "m/aboutus/read";
const mainPopupReadApi = server + 'm/MainPopup/read';
const bannerReadApi = server + 'm/Banner/main/read';
const facebookLogin = server + 'm/v2/register/facebook/login';
const questionApi = server + 'm/question/';
const answerApi = server + 'm/answer/';
const comingSoonApi = server + 'm/comingsoon/read';
const comingSoonGalleryApi = server + 'm/comingsoon/gallery/read';
const reporterApi = server + 'm/reporter/';
const reporterGalleryApi = server + 'm/reporter/gallery/read';
const readProvinceApi = 'route/province/read';

// comment
const newsCommentApi = server + 'm/news/comment/';

//category
const knowledgeCategoryApi = server + 'm/knowledge/category/';
const newsCategoryApi = server + 'm/news/category/';
const privilegeCategoryApi = server + 'm/privilege/category/';
const contactCategoryApi = server + 'm/contact/category/';
const reporterCategoryApi = server + 'm/reporter/category/read';

const splashApi = server + 'm/splash/read';

const profileReadApi = server + 'm/v2/register/read';
// const organizationImageReadApi = server + 'm/v2/organization/image/read';
const notificationApi = server + 'm/v2/notification/';

Future<dynamic> postCategory(String url, dynamic criteria) async {
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] != null ? criteria['skip'] : 0,
    "limit": criteria['limit'] != null ? criteria['limit'] : 1,
    "code": criteria['code'] != null ? criteria['code'] : '',
    "reference": criteria['reference'] != null ? criteria['reference'] : '',
    "description":
        criteria['description'] != null ? criteria['description'] : '',
    "category": criteria['category'] != null ? criteria['category'] : '',
    "keySearch": criteria['keySearch'] != null ? criteria['keySearch'] : '',
    "username": criteria['username'] != null ? criteria['username'] : '',
    "isHighlight":
        criteria['isHighlight'] != null ? criteria['isHighlight'] : false,
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'},
  ];
  list = [...list, ...data['objectData']];

  return Future.value(list);
}

Future<dynamic> post(String url, dynamic criteria) async {
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] != null ? criteria['skip'] : 0,
    "limit": criteria['limit'] != null ? criteria['limit'] : 1,
    "code": criteria['code'] != null ? criteria['code'] : '',
    "reference": criteria['reference'] != null ? criteria['reference'] : '',
    "description":
        criteria['description'] != null ? criteria['description'] : '',
    "category": criteria['category'] != null ? criteria['category'] : '',
    "keySearch": criteria['keySearch'] != null ? criteria['keySearch'] : '',
    "username": criteria['username'] != null ? criteria['username'] : '',
    "isHighlight":
        criteria['isHighlight'] != null ? criteria['isHighlight'] : false,
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  return Future.value(data['objectData']);
}

Future<dynamic> postAny(String url, dynamic criteria) async {
  var body = json.encode({
    "permission": "all",
    "skip": criteria['skip'] != null ? criteria['skip'] : 0,
    "limit": criteria['limit'] != null ? criteria['limit'] : 1,
    "code": criteria['code'] != null ? criteria['code'] : '',
    "createBy": criteria['createBy'] != null ? criteria['createBy'] : '',
    "imageUrlCreateBy":
        criteria['imageUrlCreateBy'] != null
            ? criteria['imageUrlCreateBy']
            : '',
    "reference": criteria['reference'] != null ? criteria['reference'] : '',
    "description":
        criteria['description'] != null ? criteria['description'] : '',
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  return Future.value(data['status']);
}

Future<dynamic> postLogin(String url, dynamic criteria) async {
  var body = json.encode({
    "category": criteria['category'] != null ? criteria['category'] : '',
    "password": criteria['password'] != null ? criteria['password'] : '',
    "username": criteria['username'] != null ? criteria['username'] : '',
  });

  var response = await http.post(
    Uri.parse(url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  var data = json.decode(response.body);

  return Future.value(data['objectData']);
}

Future<dynamic> postObjectData(String url, dynamic criteria) async {
  var body = json.encode(criteria);

  var response = await http.post(
    Uri.parse(server + url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return {
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData'],
    };
    // Future.value(data['objectData']);
  } else {
    return {"status": "F"};
  }
}

Future<LoginRegister> postLoginRegister(String url, dynamic criteria) async {
  var body = json.encode(criteria);

  var response = await http.post(
    Uri.parse(server + url),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var userMap = jsonDecode(response.body);

    var user = LoginRegister.fromJson(userMap);
    return Future.value(user);
  } else {
    return Future.value();
  }
}

//upload with dio
Future<String> uploadImage(File file) async {
  Dio dio = Dio();

  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "ImageCaption": "flutter",
    "Image": await MultipartFile.fromFile(file.path, filename: fileName),
  });

  // print('----- Ready -----');
  var response = await dio.post(
    "http://122.155.223.147/document/upload",
    data: formData,
  );
  // print('----- Response ----- ${response}');
  return response.data['imageUrl'];
}

Future<String> uploadImageList(XFile file) async {
  Dio dio = Dio();

  String fileName = file.path.split('/').last;
  FormData formData = FormData.fromMap({
    "ImageCaption": "flutter",
    "Image": await MultipartFile.fromFile(file.path, filename: fileName),
  });

  var response = await dio.post(serverUpload, data: formData);

  return response.data['imageUrl'];
}

//upload with http
upload(File file) async {
  var uri = Uri.parse('http://122.155.223.147/document/upload');
  var request =
      http.MultipartRequest('POST', uri)
        ..fields['ImageCaption'] = 'flutter2'
        ..files.add(
          await http.MultipartFile.fromPath(
            'Image',
            file.path,
            contentType: MediaType('application', 'x-tar'),
          ),
        );
  var response = await request.send();
  if (response.statusCode == 200) {
    return response;
  }
}

Future<dynamic> postConfigShare() async {
  var body = json.encode({});

  var response = await http.post(
    Uri.parse(server + 'configulation/shared/read'),
    body: body,
    headers: {"Accept": "application/json", "Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    return {
      // Future.value(data['objectData']);
      "status": data['status'],
      "message": data['message'],
      "objectData": data['objectData'],
    };
  } else {
    return {"status": "F"};
  }
}

Future<dynamic> postDio(String url, dynamic criteria) async {
  // print('-------------------------->>>>>> ${url}');
  // print('-------------------------->>>>>> ${criteria}');

  final storage = FlutterSecureStorage();
  // var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode1');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  // print('---------------------------------------');
  // print(response.data['objectData'].toString());
  // print('---------------------------------------');
  return Future.value(response.data['objectData']);
}

Future<dynamic> postDioCategory(String url, dynamic criteria) async {
  print(url);
  print(criteria);
  final storage = FlutterSecureStorage();
  var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode1');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);

  List<dynamic> list = [
    {'code': "", 'title': 'ทั้งหมด'},
  ];
  list = [...list, ...response.data['objectData']];

  return Future.value(list);
}

Future<dynamic> postDioMessage(String url, dynamic criteria) async {
  final storage = FlutterSecureStorage();
  final profileCode = await storage.read(key: 'profileCode1');
  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }
  Dio dio = Dio();
  print('-----dio criteria-----' + criteria.toString());
  print('-----dio criteria-----' + url);
  var response = await dio.post(url, data: criteria);
  print('-----dio message-----' + response.data.toString());
  return Future.value(response.data['objectData']);
}

Future<dynamic> postDioFull(String url, dynamic criteria) async {
  print(url);
  print(criteria);
  final storage = FlutterSecureStorage();
  var platform = Platform.operatingSystem.toString();
  final profileCode = await storage.read(key: 'profileCode1');

  if (profileCode != '' && profileCode != null) {
    criteria = {'profileCode': profileCode, ...criteria};
  }

  Dio dio = Dio();
  var response = await dio.post(url, data: criteria);
  // print(response.data['objectData'].toString());
  return Future.value(response.data);
}

logout(BuildContext context) async {
  final storage = FlutterSecureStorage();
  var profileCategory = await storage.read(key: 'profileCategory');
  storage.deleteAll();
  if (profileCategory != '' && profileCategory != null) {
    switch (profileCategory) {
      case 'facebook':
        logoutFacebook();
        break;
      case 'google':
        logoutGoogle();
        break;
      case 'line':
        logoutLine();
        break;
      default:
    }
  }

  // Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(builder: (context) => LoginAndRegisterPage()),
  //     (Route<dynamic> route) => false);

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => LoginPage(title: '')),
    (Route<dynamic> route) => false,
  );
}

createStorageApp({dynamic model, required String category}) {
  final storage = FlutterSecureStorage();

  storage.write(key: 'profileCategory', value: category);

  storage.write(key: 'profileCode1', value: model['code']);

  storage.write(key: 'profileImageUrl', value: model['imageUrl']);

  storage.write(key: 'profileFirstName', value: model['firstName']);

  storage.write(key: 'profileLastName', value: model['lastName']);

  storage.write(key: 'profilePhone', value: model['phone']);

  storage.write(key: 'profileUserName', value: model['userName']);

  storage.write(key: 'dataUserLoginSSO', value: jsonEncode(model));
}

Future<File> convertimageTofile(imgUrl) async {
  var response = await http.get(imgUrl);
  Directory documentDirectory = await getApplicationDocumentsDirectory();
  File file = File(join(documentDirectory.path, 'imagetest.png'));
  file.writeAsBytesSync(response.bodyBytes);
  return file;
}

String join(String path, String s) {
  return path + s;
}
