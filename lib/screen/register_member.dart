// ignore_for_file: library_prefixes

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dtPicker;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:sso/component/material/input_with_label.dart';
import 'package:sso/pages/blank_page/toast_fail.dart';
import 'package:sso/shared/scroll_behavior.dart';

class RegisterMemberPage extends StatefulWidget {
  const RegisterMemberPage({super.key});

  @override
  State<RegisterMemberPage> createState() => _RegisterMemberPageState();
}

class _RegisterMemberPageState extends State<RegisterMemberPage> {
  final storage = FlutterSecureStorage();
  late PageController _pageController;
  late DateTime currentBackPressTime;
  dynamic userData;
  int pageSelected = 0;

  late TextEditingController _birthDayEditingController;

  // step 1
  bool acceptPolicy = false;

  //step 2
  List<dynamic> prefixNameList = ['นาย', 'นาง', 'นางสาว'];
  bool passwordVisibility = true;
  bool confirmPasswordVisibility = true;
  bool acceptLetter = false;
  String prefixNameSelected = 'นาย';
  DateTime now = DateTime.now();
  int _selectedDay = 1;
  int _selectedMonth = 1;
  int _selectedYear = 1980;

  //step 3

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _birthDayEditingController = TextEditingController();
    _callRead();
    super.initState();
  }

  _callRead() async {
    var data = await storage.read(key: 'dataUserLoginSSO');
    print(data);
    setState(() {
      userData = json.decode(data!);
    });
  }

  Future<bool> confirmExit() {
    DateTime now = DateTime.now();
    if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      if (pageSelected > 0) {
        toastFail(
          context,
          text: 'กดอีกครั้งเพื่อออกจากการสมัครสมาชิก',
          color: Colors.black,
          fontColor: Colors.white,
          duration: 2,
        );
        return Future.value(false);
      }
    }
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage("assets/images/builds_1.png"),
          alignment: Alignment.bottomCenter,
          fit: BoxFit.fitWidth,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            toolbarHeight: 50,
            flexibleSpace: Container(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 10,
                ),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        if (pageSelected == 0) {
                          Navigator.pop(context);
                        } else {
                          setState(() {
                            pageSelected -= 1;
                          });
                          _pageController.jumpToPage(pageSelected);
                        }
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios),
                          Text(
                            'สมัครสมาชิก',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: WillPopScope(
            onWillPop: confirmExit,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStepItem(
                        step: '1',
                        title: 'ข้อตกลง',
                        focused: pageSelected == 0,
                      ),
                      _buildStepItem(
                        step: '2',
                        title: 'ข้อมูลส่วนตัว',
                        focused: pageSelected == 1,
                      ),
                      _buildStepItem(
                        step: '3',
                        title: 'ยืนยันตัวตน',
                        focused: pageSelected == 2,
                      ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        _buildPageOne(),
                        _buildPageTwo(),
                        _buildPageThree(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildStepItem({String step = '', String title = '', bool focused = false}) {
    return SizedBox(
      height: 80,
      width: 100,
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: focused ? Color(0xFF005C9E) : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(width: 1, color: Color(0xFF005C9E)),
            ),
            child: Text(
              step,
              style: TextStyle(
                color: focused ? Colors.white : Color(0xFF005C9E),
                fontSize: 35,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF005C9E),
              fontSize: 15,
              fontWeight: focused ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  _buildPageOne() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'นโยบายการคุ้มครองสิทธิ์ข้อมูลส่วนบุคคล',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 220,
              child: ScrollConfiguration(
                behavior: CsBehavior(),
                child: SingleChildScrollView(
                  child: Text(
                    'สำนักงานประกันสังคม มีนโยบายในการคุ้มครองข้อมูลส่วนบุคคลของผู้ใช้บริการทุกท่านโดยสังเขปดังนี้ ข้อมูลส่วนบุคคลที่ท่านได้ให้หรือใช้ผ่านการประมวลผล ของเครื่องคอมพิวเตอร์ ที่ควบคุมการทำงาน ของเว็บไซด์ ของสำนักงานประกันสังคมทั้งหมดนั้น ท่านยอมรับและตกลงว่าเป็นสิทธิและกรรมสิทธิ์ของสำนักงาน ประกันสังคม ซึ่งสำนักงานประกันสังคม จะให้ความคุ้มครองความลับ ดังกล่าวอย่างดีที่สุด โดยสำนักงานประกันสังคมขอเรียนว่าปัจจุบันสำนักงานประกันสังคมได้ใช้ ระบบรักษาความปลอดภัยที่ได้มาตรฐานเพื่อคุ้มครองข้อมูลดังกล่าว อย่างไรก็ตาม เพื่อความปลอดภัย ในข้อมูลส่วนบุคคลของท่าน ท่านควรปฏิบัติตามข้อกำหนด และเงื่อนไขการให้ บริการของเว็บไซด์ ของสำนักงานประกันสังคม แต่ละเว็บไซด์โดยเคร่งครัด ในกรณีที่ข้อมูลส่วนบุคคลดังกล่าว ถูกจารกรรมโดยวิธีการทาง อิเล็กทรอนิกส์ (hack)หรือสูญหาย เสียหายอันเนื่องจากเหตุสุดวิสัยหรือไม่ว่ากรณีใดๆทั้งสิ้น สำนักงานประกันสังคมขอสงวนสิทธิในการปฏิเสธความรับผิดจากเหตุ ดังกล่าวทั้งหมด',
                    style: TextStyle(color: Color(0xFF646464), fontSize: 13),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  acceptPolicy = !acceptPolicy;
                });
              },
              child: Container(
                height: 52,
                width: 150,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: acceptPolicy ? Color(0xFFE8F0F6) : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 1,
                    color:
                        acceptPolicy
                            ? Color(0xFFE8F0F6)
                            : Color(0xFF005C9E).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                        color:
                            acceptPolicy
                                ? Color(0xFF005C9E)
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(
                          width: 1,
                          color:
                              acceptPolicy
                                  ? Color(0xFFE8F0F6)
                                  : Color(0xFF005C9E),
                        ),
                      ),
                      child: Icon(Icons.check, size: 14, color: Colors.white),
                    ),
                    SizedBox(width: 7),
                    Expanded(
                      child: Text(
                        'ฉันยอมรับข้อตกลง ในการบริการ',
                        style: TextStyle(
                          color: Color(0xFF005C9E),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          bottom: 150,
          right: 15,
          child: GestureDetector(
            onTap: () {
              if (acceptPolicy) {
                setState(() {
                  pageSelected = 1;
                  _pageController.jumpToPage(pageSelected);
                });
              }
            },
            child: Container(
              height: 40,
              width: 85,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: acceptPolicy ? Color(0xFFFFC324) : Color(0xFFE4E4E4),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                'ถัดไป',
                style: TextStyle(
                  color: acceptPolicy ? Colors.white : Color(0xFF646464),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildPageTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ข้อมูลส่วนตัว',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: DecorationRegister.registerMember(
            context,
            hintText: 'หมายเลขประจำตัวประชาชน',
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          inputFormatters: InputFormatTemple.phone(),
          decoration: DecorationRegister.registerMember(
            context,
            hintText: 'เบอร์ติดต่อ (10 หลัก)',
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          obscureText: passwordVisibility,
          inputFormatters: InputFormatTemple.username(),
          decoration: DecorationRegister.passwordMember(
            context,
            labelText: 'รหัสผ่าน',
            hintText:
                'รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
            visibility: passwordVisibility,
            suffixTap:
                () => setState(() => passwordVisibility = !passwordVisibility),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          obscureText: confirmPasswordVisibility,
          inputFormatters: InputFormatTemple.username(),
          decoration: DecorationRegister.passwordMember(
            context,
            labelText: 'ยืนยันรหัสผ่าน',
            hintText:
                'รหัสผ่านต้องเป็นตัวอักษร a-z, A-Z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร',
            visibility: confirmPasswordVisibility,
            suffixTap:
                () => setState(
                  () => confirmPasswordVisibility = !confirmPasswordVisibility,
                ),
          ),
        ),
        SizedBox(height: 40),
        SizedBox(
          height: 35,
          child: Row(
            children: [
              _buildPrefixNameItem('นาย'),
              SizedBox(width: 10),
              _buildPrefixNameItem('นาง'),
              SizedBox(width: 10),
              _buildPrefixNameItem('นางสาว'),
            ],
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: DecorationRegister.registerMember(
            context,
            hintText: 'ชื่อนามสกุล',
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => dialogOpenPickerDate(),
          child: Container(
            height: 48,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(
                width: 1,
                color: Colors.black.withOpacity(0.2),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _birthDayEditingController.text == ''
                      ? 'วันเดือนปีเกิด'
                      : _birthDayEditingController.text,
                  style: TextStyle(
                    fontSize: 13,
                    color:
                        _birthDayEditingController.text == ''
                            ? Color(0xFF707070)
                            : Colors.black,
                  ),
                ),
                Icon(Icons.calendar_today, color: Color(0xFF707070)),
                // Image.asset(
                //   'assets/images/dropdown_calendar.png',
                //   width: 15,
                //   height: 13.5,
                // ),
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        TextFormField(
          decoration: DecorationRegister.registerMember(
            context,
            hintText: 'อีเมล',
          ),
        ),
        SizedBox(height: 35),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildAcceptLetter(
              'รับจดหมายข่าว',
              acceptLetter,
              onTap: () {
                setState(() {
                  acceptLetter = !acceptLetter;
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  pageSelected = 2;
                  _pageController.jumpToPage(pageSelected);
                });
              },
              child: Container(
                height: 40,
                width: 85,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Color(0xFFFFC324),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Text(
                  'ถัดไป',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildPageThree() {
    return Column(
      children: [
        Text(
          'กรุณากรอกรหัส OTP',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.start,
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildItemOTP(),
            _buildItemOTP(),
            _buildItemOTP(),
            _buildItemOTP(),
            _buildItemOTP(),
            _buildItemOTP(),
          ],
        ),
        SizedBox(height: 30),
        Text('091 - 123 - 4567', style: TextStyle(fontSize: 15)),
        Text(
          'เราได้ส่งรหัส OTP ไปยังหมายเลข',
          style: TextStyle(color: Color(0xFF646464), fontSize: 11),
        ),
        SizedBox(height: 13),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(width: 1, color: Color(0xFF005C9E)),
          ),
          child: Text(
            'ส่งรหัสอีกครั้ง',
            style: TextStyle(color: Color(0xFF005C9E), fontSize: 15),
          ),
        ),
      ],
    );
  }

  _buildItemOTP() {
    return Container(
      height: 60,
      width: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Color(0xFFE8F0F6),
        borderRadius: BorderRadius.circular(10),
      ),
      // child: TextFormField(
      //   showCursor: false,
      //   inputFormatters: InputFormatTemple.otp(),
      //   style: TextStyle(fontSize: 25),
      //   decoration: InputDecoration(
      //     contentPadding: EdgeInsets.symmetric(horizontal: 15),
      //     border: InputBorder.none,
      //   ),
      // ),
    );
  }

  _buildPrefixNameItem(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          prefixNameSelected = title;
        });
      },
      child: Container(
        height: 33,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:
              prefixNameSelected == title
                  ? Color(0xFFE8F0F6)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color:
                prefixNameSelected == title
                    ? Color(0xFFE8F0F6)
                    : Color(0xFF005C9E).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color:
                    prefixNameSelected == title
                        ? Color(0xFF005C9E)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color:
                      prefixNameSelected == title
                          ? Color(0xFFE8F0F6)
                          : Color(0xFF005C9E),
                ),
              ),
              child: Icon(Icons.check, size: 14, color: Colors.white),
            ),
            SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  _buildAcceptLetter(String title, bool value, {required Function onTap}) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 33,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: value ? Color(0xFFE8F0F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color:
                value ? Color(0xFFE8F0F6) : Color(0xFF005C9E).withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 16,
              width: 16,
              decoration: BoxDecoration(
                color: value ? Color(0xFF005C9E) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color:
                      prefixNameSelected == title
                          ? Color(0xFFE8F0F6)
                          : Color(0xFF005C9E),
                ),
              ),
              child: Icon(Icons.check, size: 14, color: Colors.white),
            ),
            SizedBox(width: 3),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }

  dialogOpenPickerDate() {
    dtPicker.DatePicker.showDatePicker(
      context,
      theme: dtPicker.DatePickerTheme(
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
      minTime: DateTime(now.year - 100, 1, 1),
      maxTime: DateTime(now.year + 1, now.month, now.day),
      onConfirm: (date) {
        setState(() {
          _selectedYear = date.year;
          _selectedMonth = date.month;
          _selectedDay = date.day;
          _birthDayEditingController.value = TextEditingValue(
            text: DateFormat("dd/MM/yyyy").format(date),
          );
        });
      },
      currentTime: DateTime(_selectedYear, _selectedMonth, _selectedDay),
      locale: dtPicker.LocaleType.th,
    );
  }
}
