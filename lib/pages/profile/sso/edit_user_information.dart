// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as DateTimePickerPlus;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:sso/component/custom_dialog.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/widget/text_form_field.dart';

class EditUserInformationPage extends StatefulWidget {
  @override
  _EditUserInformationPageState createState() =>
      _EditUserInformationPageState();
}

class _EditUserInformationPageState extends State<EditUserInformationPage> {
  final storage = FlutterSecureStorage();

  String _imageUrl = '';
  String _code = '';

  final _formKey = GlobalKey<FormState>();

  final List<String> _prefixNames = ['นาย', 'นาง', 'นางสาว']; // Option 2
  String _selectedPrefixName = 'นาย';

  final txtEmail = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();
  final txtPhone = TextEditingController();
  DateTime selectedDate = DateTime.now();
  TextEditingController txtDate = TextEditingController();

  late Future<dynamic> futureModel;

  ScrollController scrollController = ScrollController();

  File? _image;

  int _selectedDay = 0;
  int _selectedMonth = 0;
  int _selectedYear = 0;
  int year = 0;
  int month = 0;
  int day = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtEmail.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    txtPhone.dispose();
    txtDate.dispose();
    super.dispose();
  }

  @override
  void initState() {
    futureModel = Future.value({});
    readStorage();
    super.initState();
    var now = DateTime.now();
    setState(() {
      year = now.year;
      month = now.month;
      day = now.day;
      _selectedYear = now.year;
      _selectedMonth = now.month;
      _selectedDay = now.day;
    });
  }

  Future<dynamic> readUser() async {
    final result = await postObjectData("m/Register/read", {'code': _code});

    if (result != null &&
        result['status'] == 'S' &&
        result['objectData'] != null &&
        result['objectData'].isNotEmpty) {
      var obj = result['objectData'][0];
      String serverImg = obj['imageUrl'] ?? '';
      if (serverImg.isNotEmpty) {
        await storage.write(key: 'profileImageUrl', value: serverImg);
      }

      await storage.write(key: 'dataUserLoginSSO', value: jsonEncode(obj));

      if (obj['birthDay'] != null && obj['birthDay'] != '') {
        var date = obj['birthDay'].toString();
        if (date.length >= 8) {
          var year = date.substring(0, 4);
          var month = date.substring(4, 6);
          var day = date.substring(6, 8);
          DateTime todayDate = DateTime.parse('$year-$month-$day');
          setState(() {
            _selectedYear = todayDate.year;
            _selectedMonth = todayDate.month;
            _selectedDay = todayDate.day;
            txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
          });
        }
      }

      setState(() {
        if (serverImg.isNotEmpty) {
          _imageUrl = serverImg;
        }
        txtFirstName.text = obj['firstName'] ?? '';
        txtLastName.text = obj['lastName'] ?? '';
        txtEmail.text = obj['email'] ?? '';
        txtPhone.text = obj['phone'] ?? '';
        _selectedPrefixName = obj['prefixName'] ?? '';
        _code = obj['code'] ?? '';
      });
    }
  }

  Future<dynamic> submitUpdateUser() async {
    Map<String, dynamic> user = {};
    var value = await storage.read(key: 'dataUserLoginSSO');
    if (value != null && value.isNotEmpty) {
      try {
        user = Map<String, dynamic>.from(json.decode(value));
      } catch (_) {}
    }
    user['imageUrl'] = _imageUrl;
    user['firstName'] = txtFirstName.text.trim();
    user['lastName'] = txtLastName.text.trim();
    user['email'] = txtEmail.text.trim();
    user['phone'] = txtPhone.text.trim();
    user['prefixName'] = _selectedPrefixName;
    user['birthDay'] = DateFormat(
      "yyyyMMdd",
    ).format(DateTime(_selectedYear, _selectedMonth, _selectedDay));

    final result = await postObjectData('m/Register/update', user);
    user['imageUrl'] = _imageUrl;
    await storage.write(
      key: 'dataUserLoginSSO',
      value: jsonEncode(
        result != null && result['objectData'] != null
            ? result['objectData']
            : user,
      ),
    );
    if (_imageUrl.isNotEmpty) {
      await storage.write(key: 'profileImageUrl', value: _imageUrl);
    }
    if (txtFirstName.text.trim().isNotEmpty) {
      await storage.write(
        key: 'profileFirstName',
        value: txtFirstName.text.trim(),
      );
      await storage.write(
        key: 'profileLastName',
        value: txtLastName.text.trim(),
      );
    }

    if (!mounted) return;
    await showSSODialog(
      context,
      title: 'อัปเดตข้อมูลเรียบร้อยแล้ว',
      message: 'ข้อมูลส่วนตัวของท่านได้รับการบันทึกลงในระบบเรียบร้อยแล้ว',
      type: SSODialogType.success,
      confirmText: 'ตกลง',
    );
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  readStorage() async {
    try {
      var value = await storage.read(key: 'dataUserLoginSSO');
      if (value != null && value.isNotEmpty) {
        var user = json.decode(value);
        if (user is Map) {
          setState(() {
            _imageUrl = user['imageUrl'] ?? '';
            txtFirstName.text = user['firstName'] ?? '';
            txtLastName.text = user['lastName'] ?? '';
            txtEmail.text = user['email'] ?? '';
            txtPhone.text = user['phone'] ?? '';
            if (user['prefixName'] != null &&
                user['prefixName'].toString().isNotEmpty) {
              _selectedPrefixName = user['prefixName'].toString();
            }
            _code = user['code']?.toString() ?? '';
          });

          if (user['birthDay'] != null &&
              user['birthDay'].toString().length >= 8) {
            var date = user['birthDay'].toString();
            var year = date.substring(0, 4);
            var month = date.substring(4, 6);
            var day = date.substring(6, 8);
            DateTime todayDate = DateTime.parse('$year-$month-$day');

            setState(() {
              _selectedYear = todayDate.year;
              _selectedMonth = todayDate.month;
              _selectedDay = todayDate.day;
              txtDate.text = DateFormat("dd-MM-yyyy").format(todayDate);
            });
          }
          if (_code.isNotEmpty) {
            readUser();
          }
        }
      }
      String? localImg = await storage.read(key: 'profileImageUrl');
      if (localImg != null && localImg.isNotEmpty) {
        setState(() {
          _imageUrl = localImg;
        });
      }
    } catch (e) {
      debugPrint('Error in readStorage edit_user_information: $e');
    }
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 5,
      child: Padding(padding: EdgeInsets.all(15), child: contentCard()),
    );
  }

  dialogOpenPickerDate() {
    DateTimePickerPlus.DatePicker.showDatePicker(
      context,
      theme: DateTimePickerPlus.DatePickerTheme(
        containerHeight: 210.0,
        itemStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        doneStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
        cancelStyle: TextStyle(
          fontSize: 16.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
        ),
      ),
      showTitleActions: true,
      minTime: DateTime(1800, 1, 1),
      maxTime: DateTime(year, month, day),
      onConfirm: (date) {
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          txtDate.value = TextEditingValue(
            text: DateFormat("dd-MM-yyyy").format(date),
          );
        });
      },
      currentTime: DateTime(_selectedYear, _selectedMonth, _selectedDay),
      locale: DateTimePickerPlus.LocaleType.th,
    );
  }

  contentCard() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 65.0)),
          Text(
            'ข้อมูลส่วนตัว',
            style: TextStyle(
              fontSize: 15.0,
              color: Color(0xFF005C9E),
              fontWeight: FontWeight.normal,
              fontFamily: 'Kanit',
            ),
          ),
          labelTextFormField('คำนำหน้า'),
          Container(
            width: 5000.0,
            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              color: Color(0xFFE8F0F6),
              borderRadius: BorderRadius.circular(10),
            ),
            // child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 10.0,
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              validator:
                  (value) =>
                      value == '' || value == null
                          ? 'กรุณาเลือกคำนำหน้า'
                          : null,
              hint: Text(
                'กรุณาเลือกคำนำหน้า',
                style: TextStyle(fontSize: 15.00, fontFamily: 'Kanit'),
              ),
              value: _selectedPrefixName,
              onChanged: (newValue) {
                setState(() {
                  _selectedPrefixName = newValue!;
                });
              },
              items:
                  _prefixNames.map((prefixName) {
                    return DropdownMenuItem(
                      value: prefixName,
                      child: Text(
                        prefixName,
                        style: TextStyle(
                          fontSize: 15.00,
                          fontFamily: 'Kanit',
                          color: Color(0xFF005C9E),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            // ),
          ),
          labelTextFormField('ชื่อ'),
          textFormField(txtFirstName, '', 'ชื่อ', 'ชื่อ', true, false, false),
          labelTextFormField('นามสกุล'),
          textFormField(
            txtLastName,
            '',
            'นามสกุล',
            'นามสกุล',
            true,
            false,
            false,
          ),
          labelTextFormField('วันเดือนปีเกิด'),
          GestureDetector(
            onTap: () => dialogOpenPickerDate(),
            child: AbsorbPointer(
              child: TextFormField(
                controller: txtDate,
                style: TextStyle(
                  color: Color(0xFF005C9E),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                  fontSize: 15.0,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFFE8F0F6),
                  contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                  hintText: "วันเดือนปีเกิด",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  errorStyle: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Kanit',
                    fontSize: 10.0,
                  ),
                ),
                validator: (model) {
                  if (model!.isEmpty) {
                    return 'กรุณากรอกวันเดือนปีเกิด.';
                  }
                  return null;
                },
              ),
            ),
          ),
          labelTextFormField('เบอร์ติดต่อ'),
          textFormPhoneField(
            txtPhone,
            'เบอร์ติดต่อ',
            'เบอร์ติดต่อ',
            true,
            false,
          ),
          labelTextFormField('อีเมล'),
          textFormField(txtEmail, '', 'อีเมล', 'อีเมล', true, false, true),
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
                  final form = _formKey.currentState;
                  if (form!.validate()) {
                    form.save();
                    submitUpdateUser();
                  }
                },
                child: Text(
                  "บันทึกข้อมูล",
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

  rowContentButton(String urlImage, String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Color(0xFF0B5C9E),
            ),
            width: 30.0,
            height: 30.0,
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(urlImage, height: 5.0, width: 5.0),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.63,
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12.0,
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.normal,
                fontFamily: 'Kanit',
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: Image.asset(
              "assets/icons/Group6232.png",
              height: 20.0,
              width: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  _imgFromCamera() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _upload();
    }
  }

  _imgFromGallery() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _upload();
    }
  }

  void _upload() async {
    if (_image == null) return;

    uploadImage(_image!)
        .then((res) async {
          if (res != null && res.isNotEmpty) {
            setState(() {
              _imageUrl = res;
            });
            await storage.write(key: 'profileImageUrl', value: res);
            var value = await storage.read(key: 'dataUserLoginSSO');
            if (value != null && value.isNotEmpty) {
              try {
                var user = json.decode(value);
                if (user is Map) {
                  user['imageUrl'] = res;
                  await storage.write(
                    key: 'dataUserLoginSSO',
                    value: jsonEncode(user),
                  );
                }
              } catch (_) {}
            }
          }
        })
        .catchError((err) {
          debugPrint('Upload image error: $err');
        });
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Photo Library'),
                  onTap: () {
                    _imgFromGallery();
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
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
    // return FutureBuilder<dynamic>(
    //   future: futureModel,
    //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       // return Center(child: Text('Please wait its loading...'));
    //       // return Center(
    //       //   child: CircularProgressIndicator(),
    //       // );
    //       return Center(
    //         child: Image.asset(
    //           "assets/background/login.png",
    //           fit: BoxFit.cover,
    //         ),
    //       );
    //     } else {
    //       if (snapshot.hasError)
    //         return Center(child: Text('Error: ${snapshot.error}'));
    //       else
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        appBar: header(context, goBack, title: 'ข้อมูลส่วนตัว'),
        backgroundColor: Colors.transparent,
        body: Container(
          child: ListView(
            controller: scrollController,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 75.0), child: card()),
                  GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: SizedBox(
                      width: 150.0,
                      height: 150.0,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE8F0F6),
                              border: Border.all(
                                color: const Color(0xFF005C9E).withOpacity(0.3),
                                width: 3,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: loadingImageNetwork(
                                _imageUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                isProfile: true,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            right: 16,
                            child: Container(
                              width: 34,
                              height: 34,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFF005C9E),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ],
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
  }
}
