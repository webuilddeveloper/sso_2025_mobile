import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/pages/profile/my_address.dart';
import 'package:sso/pages/profile/profile_policy_sso.dart';
import 'package:sso/pages/profile/profile_sso.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/screen/dental.dart';
import 'package:sso/screen/hospital.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/screen/register_member.dart';
import 'package:sso/screen/subsidy.dart';
import 'package:sso/screen/used_privilege.dart';
import 'package:sso/shared/extension.dart';

import '../component/button_model.dart';
import 'faq_list.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final storage = FlutterSecureStorage();
  dynamic userData;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    try {
      var data = await storage.read(key: 'dataUserLoginSSO');
      if (data != null && data.isNotEmpty) {
        setState(() {
          userData = json.decode(data);
        });
      }
      String? pFirst = await storage.read(key: 'profileFirstName');
      String? pLast = await storage.read(key: 'profileLastName');
      String? pCat = await storage.read(key: 'profileCategory');
      String? pCode = await storage.read(key: 'profileCode1');
      if (pCode != null && pCode.isNotEmpty && (userData == null || userData['firstName'] == null)) {
        var res = await postDio(profileReadApi, {'code': pCode});
        if (res != null && res is Map) {
          setState(() {
            userData = res;
          });
        }
      }
      String? localImg = await storage.read(key: 'profileImageUrl');
      if (localImg != null && localImg.isNotEmpty) {
        setState(() {
          if (userData == null) {
            userData = {'imageUrl': localImg};
          } else if (userData is Map) {
            userData['imageUrl'] = localImg;
          }
        });
      }
    } catch (e) {
      debugPrint('Error in _callRead setting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F4F4),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF6F4F4),
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
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Text(
                        'การตั้งค่าและบัญชี',
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
      body: ListView(
        padding: EdgeInsets.zero,
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _buildQrCode();
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: loadingImageNetwork(
                                userData?['imageUrl']?.toString() ?? '',
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                                isProfile: true,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 3,
                            child: Container(
                              height: 23,
                              width: 23,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Color(0xFFE8F0F6),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Image.asset('assets/images/scan.png'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const UserInformationPage(),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${userData?['firstName'] ?? 'ไม่ทราบชื่อ'} ${userData?['lastName'] ?? 'ไม่ทราบนามสกุล'}',
                                style: TextStyle(fontSize: 13),
                              ),

                              Text(
                                userData?['category'] == '39'
                                    ? 'ผู้ประกันตนมาตรา 39'
                                    : userData?['category'] == '40'
                                        ? 'ผู้ประกันตนมาตรา 40'
                                        : 'ผู้ประกันตนมาตรา 33',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF005C9E),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: Color(0xFFE8F0F6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF005C9E),
                                        borderRadius: BorderRadius.circular(7.5),
                                      ),
                                      height: 15,
                                      width: 15,
                                      child: Icon(
                                        Icons.check_rounded,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'ยืนยันตัวตนแล้ว',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFF005C9E),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                InkWell(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (builder) => RegisterMemberPage(),
                        ),
                      ),
                  child: Container(
                    height: 150,
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/sps.png',
                          height: 56,
                          width: 56,
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'ไม่อยากให้คุณพลาดสวัสดิการ',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color(0xFF005C9E),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF646464),
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE4A025),
                                    borderRadius: BorderRadius.circular(17),
                                  ),
                                  child: Text(
                                    'สมัครเป็นผู้ประกันตน',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
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
                ),
                SizedBox(height: 20),
                Text(
                  'เกี่ยวกับสิทธิ์ประโยชน์ของฉัน',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 88,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SubsidyPage(),
                                ),
                              ),
                          child: Stack(
                            children: [
                              Image.asset('assets/images/card_blue.png'),
                              Positioned(
                                top: 10,
                                left: 15,
                                child: Text(
                                  'เงินสมทบชราภาพ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 15,
                                child: Text(
                                  moneyFormat('20000'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap:
                              () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DentalPage()),
                              ),
                          child: Stack(
                            children: [
                              Image.asset('assets/images/card_yellow.png'),
                              Positioned(
                                top: 10,
                                left: 15,
                                child: Text(
                                  'สิทธิทันตกรรมคงเหลือ',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 15,
                                child: Text(
                                  moneyFormat('900'),
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 15),
                        GestureDetector(
                          onTap:
                              () => buttonModel(
                                context,
                                Future.value([
                                  {
                                    'title': 'เปลี่ยนโรงพยาบาล',
                                    'description':
                                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                                    'imageUrl':
                                        'assets/images/change_hospital.png',
                                  },
                                  {
                                    'title': 'เบิกสิทธิประโยชน์',
                                    'description':
                                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                                    'imageUrl':
                                        'assets/images/withdraw_benefits.png',
                                  },
                                  {
                                    'title': 'ลงทะเบียนขอรับเงินทดแทน',
                                    'description':
                                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                                    'imageUrl':
                                        'assets/images/request_compensation.png',
                                  },
                                  {
                                    'title': 'สมัครเป็นผู้ประกันตน ม.40',
                                    'description':
                                        'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
                                    'imageUrl':
                                        'assets/images/apply_as_an_insurer.png',
                                  },
                                ]),
                                'บริการออนไลน์',
                              ),
                          child: Container(
                            alignment: Alignment.center,
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFF64C5D7),
                            ),
                            child: Text(
                              'บริการอื่นๆ',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'ตั้งค่าอื่นๆ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      _buildItem(
                        'หน้าโปรไฟล์',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const UserInformationPage(),
                          ),
                        ),
                      ),
                      _buildItem(
                        'ที่อยู่ของฉัน',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MyAddressPage(),
                          ),
                        ),
                      ),
                      _buildItem(
                        'ยืนยันตัวตนเพิ่มเติม',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterMemberPage(),
                          ),
                        ),
                      ),
                      _buildItem(
                        'ประวัติการใช้สิทธิ์ประโยชน์',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UsedPrivilegePage(),
                              ),
                            ),
                      ),
                      _buildItem(
                        'เปลี่ยนสถานพยาบาล',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => HospitalPage()),
                            ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      _buildItem(
                        'ตั้งค่าการแจ้งเตือน',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text('ตั้งค่าการแจ้งเตือน'),
                              content: const Text(
                                'ระบบเปิดรับการแจ้งเตือนสิทธิประโยชน์ ข่าวสาร และสถานะการเบิกจ่ายเรียบร้อยแล้ว',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('ตกลง'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      _buildItem(
                        'ตั้งค่าความเป็นส่วนตัว',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfilePolicySSOPage(),
                          ),
                        ),
                      ),
                      _buildItem(
                        'ข้อตกลงและการให้ความยินยอม',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfilePolicySSOPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      _buildItem(
                        'คำถามที่พบบ่อย',
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => faqListPage(
                                      username:
                                          '${userData?['firstName'] ?? 'We Build'} ${userData?['lastName'] ?? 'Operate'}',
                                    ),
                              ),
                            ),
                      ),
                      _buildItem(
                        'ศูนย์ช่วยเหลือ',
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text('ศูนย์ช่วยเหลือสำนักงานประกันสังคม'),
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('• สายด่วน สปส.: โทร 1506 (ตลอด 24 ชั่วโมง)'),
                                  SizedBox(height: 8),
                                  Text('• เว็บไซต์: www.sso.go.th'),
                                  SizedBox(height: 8),
                                  Text('• ให้บริการข้อมูลสิทธิประโยชน์และการยื่นคำขอทุกกรณี'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text('ปิด'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      _buildItem(
                        'เกี่ยวกับเรา',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileSSOPage(
                              model: postDio(aboutUsReadApi, {}),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.all(10.0)),
                  onPressed: () => logout(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.power_settings_new, color: Colors.red),
                      Text(
                        " ออกจากระบบ",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Color(0xFFFC4137),
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/builds_1.png'),
        ],
      ),
    );
  }

  _buildItem(String title, {required Function onTap}) {
    return InkWell(
      onTap: () => onTap(),
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

  _buildQrCode() {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Color(0xFF005C9E).withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            height: 405,
            width: double.infinity,
            margin: EdgeInsets.symmetric(horizontal: 1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Color(0xFF005C9E),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 45,
                        width: 45,
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22.5),
                        ),
                        child: Image.asset('assets/images/logoNoText.png'),
                      ),
                      SizedBox(width: 20),
                      Text(
                        'ผู้ประกันตน',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: QrImageView(
                    data: "https://www.sso.go.th/wpr/",
                    version: QrVersions.auto,
                    embeddedImage: AssetImage('assets/images/logoNoText.png'),
                    embeddedImageStyle: QrEmbeddedImageStyle(
                      size: Size(40, 40),
                    ),
                    size: 250.0,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '${userData?['firstName'] ?? 'We Build Operate'} ${userData?['lastName'] ?? 'Co.,Ltd'}',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
                Text(
                  'ผู้ประกันตนมาตรา 33',
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void logout() async {
    await storage.delete(key: 'dataUserLoginSSO');
    Navigator.pushReplacement(
      // ignore: use_build_context_synchronously
      context,
      MaterialPageRoute(builder: (context) => LoginPage(title: '')),
    );
  }
}
