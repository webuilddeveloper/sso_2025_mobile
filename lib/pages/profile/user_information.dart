// ignore_for_file: unnecessary_null_comparison, library_private_types_in_public_api, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/custom_dialog.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/models/user.dart';
import 'package:sso/pages/home.dart';
import 'package:sso/pages/profile/connect_sso.dart';
import 'package:sso/pages/profile/my_address.dart';
import 'package:sso/pages/profile/profile_policy_sso.dart';
import 'package:sso/pages/profile/profile_sso.dart';
import 'package:sso/screen/digital_card.dart';
import 'package:sso/screen/hospital.dart';
import 'package:sso/screen/login.dart';
import 'package:sso/shared/api_provider.dart';
import '../profile/sso/change_password.dart';
import '../profile/sso/connect_social.dart';
import '../profile/sso/edit_user_information.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({super.key, this.userData});
  final User? userData;
  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  final storage = const FlutterSecureStorage();

  String _imageUrl = '';
  String _firstName = 'We Build Operate';
  String _lastName = 'Co.,Ltd';
  String _idCard = '1100499882123';
  String _section = '33';
  String _hospital = 'โรงพยาบาลกรุงเทพ';
  String _phone = '081-234-5678';
  String _bankName = 'ธนาคารกรุงไทย';
  String _bankAccountNo = '012-3-45678-9';

  final txtUsername = TextEditingController();
  final txtPassword = TextEditingController();
  final txtConPassword = TextEditingController();
  final txtFirstName = TextEditingController();
  final txtLastName = TextEditingController();

  late Future<dynamic> futureModel;
  late Future<dynamic> _futureAboutUs;

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    txtUsername.dispose();
    txtPassword.dispose();
    txtConPassword.dispose();
    txtFirstName.dispose();
    txtLastName.dispose();
    super.dispose();
  }

  @override
  void initState() {
    readStorage();
    _futureAboutUs = postDio(aboutUsReadApi, {});
    super.initState();
  }

  String _formatIdCard(String id) {
    if (id.isEmpty) return '1-1004-99882-12-3';
    String digits = id.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 13) {
      return '${digits.substring(0, 1)}-${digits.substring(1, 5)}-${digits.substring(5, 10)}-${digits.substring(10, 12)}-${digits.substring(12, 13)}';
    }
    return id;
  }

  void goBack() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  void logout() async {
    await storage.delete(key: 'dataUserLoginSSO');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage(title: '')),
    );
  }

  void _confirmLogout() {
    showSSODialog(
      context,
      title: 'ออกจากระบบ',
      message: 'ท่านต้องการออกจากระบบ SSO Plus ใช่หรือไม่?',
      type: SSODialogType.confirm,
      showCancel: true,
      cancelText: 'ยกเลิก',
      confirmText: 'ออกจากระบบ',
      onConfirm: logout,
    );
  }

  readStorage() async {
    try {
      var value = await storage.read(key: 'dataUserLoginSSO');
      if (value != null && value.isNotEmpty) {
        var user = json.decode(value);
        if (user is Map) {
          setState(() {
            _imageUrl = user['imageUrl'] ?? '';
            if (user['firstName'] != null && user['firstName'].toString().isNotEmpty) {
              _firstName = user['firstName'];
              _lastName = user['lastName'] ?? '';
            }
            if (user['idCard'] != null && user['idCard'].toString().isNotEmpty) {
              _idCard = user['idCard'].toString();
            } else if (user['idcard'] != null && user['idcard'].toString().isNotEmpty) {
              _idCard = user['idcard'].toString();
            }
            if (user['category'] != null && user['category'].toString().isNotEmpty && user['category'].toString() != 'guest') {
              _section = user['category'].toString();
            } else {
              _section = '33';
            }
            if (user['phone'] != null) {
              _phone = user['phone'].toString();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('Error reading dataUserLoginSSO: $e');
    }

    String? pCode = await storage.read(key: 'profileCode1');
    String? pFirst = await storage.read(key: 'profileFirstName');
    String? pLast = await storage.read(key: 'profileLastName');
    String? pCat = await storage.read(key: 'profileCategory');
    String? pPhone = await storage.read(key: 'profilePhone');

    if (pFirst != null && pFirst.isNotEmpty) {
      setState(() {
        _firstName = pFirst;
        _lastName = pLast ?? '';
      });
    }
    if (pCat != null && pCat.isNotEmpty && pCat != 'guest') {
      setState(() {
        _section = pCat;
      });
    }
    if (pPhone != null && pPhone.isNotEmpty) {
      setState(() {
        _phone = pPhone;
      });
    }

    if (pCode != null && pCode.isNotEmpty) {
      try {
        var res = await postDio(profileReadApi, {'code': pCode});
        if (res != null && res is Map) {
          setState(() {
            if (res['imageUrl'] != null) _imageUrl = res['imageUrl'];
            if (res['firstName'] != null) _firstName = res['firstName'];
            if (res['lastName'] != null) _lastName = res['lastName'] ?? '';
            if (res['idcard'] != null) _idCard = res['idcard'].toString();
            if (res['category'] != null) _section = res['category'].toString();
          });
        }
      } catch (e) {
        debugPrint('Error reading profile in user_information: $e');
      }
    }

    String? localImg = await storage.read(key: 'profileImageUrl');
    if (localImg != null && localImg.isNotEmpty) {
      setState(() {
        _imageUrl = localImg;
      });
    }
  }

  void _showBenefitAccountDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0F6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.account_balance, color: Color(0xFF005C9E), size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'บัญชีรับเงินประโยชน์ทดแทน',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C9E),
                        ),
                      ),
                      Text(
                        'ผูกบัญชีสำหรับรับเงินสิทธิประโยชน์ สปส.',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7FAFD),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color(0xFF005C9E).withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset('assets/images/correct.png', width: 20, height: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'พร้อมเพย์ (PromptPay)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ผูกสำเร็จ (Active)',
                          style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'ผูกกับเลขบัตรประชาชน: ${_formatIdCard(_idCard)}',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'ใช้รับเงิน: บำเหน็จ/บำนาญชราภาพ, สงเคราะห์บุตร, ทันตกรรม, คลอดบุตร, ว่างงาน',
                    style: TextStyle(fontSize: 12, color: Color(0xFF646464)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.grey[700], size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            'บัญชีธนาคารรับเงินสำรอง',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ],
                      ),
                      const Text(
                        'บัญชีรอง',
                        style: TextStyle(color: Colors.grey, fontSize: 11),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$_bankName • เลขที่ $_bankAccountNo',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ชื่อบัญชี: $_firstName $_lastName',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF646464)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005C9E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ข้อมูลบัญชีรับเงินสิทธิประโยชน์เป็นปัจจุบันแล้ว'),
                      backgroundColor: Color(0xFF005C9E),
                    ),
                  );
                },
                child: const Text('ตกลง', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  void _openDigitalCard() {
    User u = User();
    u.firstName = _firstName;
    u.lastName = _lastName;
    u.idcard = _idCard;
    u.category = _section;
    u.imageUrl = _imageUrl;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DigitalCardPage(user: u),
      ),
    );
  }

  card() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: contentCard(),
      ),
    );
  }

  contentCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 55.0),
        Center(
          child: Column(
            children: [
              Text(
                '$_firstName $_lastName',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: Color(0xFF005C9E),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Text(
                'เลขประจำตัวประชาชน: ${_formatIdCard(_idCard)}',
                style: const TextStyle(
                  fontSize: 13.0,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Kanit',
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified, size: 14, color: Color(0xFF005C9E)),
                        const SizedBox(width: 4),
                        Text(
                          'ผู้ประกันตนมาตรา ${_section == 'guest' || _section.isEmpty ? '33' : _section}',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005C9E),
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F0F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.local_hospital, size: 14, color: Color(0xFF005C9E)),
                        const SizedBox(width: 4),
                        Text(
                          _hospital,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF005C9E),
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        const Divider(height: 24, thickness: 0.8),

        // หมวด 1: ข้อมูลผู้ประกันตน
        _buildSectionHeader('ข้อมูลผู้ประกันตน'),
        _buildMenuItem(
          icon: Icons.person_rounded,
          iconColor: const Color(0xFF005C9E),
          iconBgColor: const Color(0xFFEBF3FA),
          title: 'ข้อมูลผู้ใช้งานและข้อมูลส่วนตัว',
          subtitle: 'ชื่อ-นามสกุล, วันเกิด, เบอร์โทรศัพท์, อีเมล',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditUserInformationPage(),
            ),
          ).then((value) => readStorage()),
        ),
        _buildMenuItem(
          icon: Icons.location_on_rounded,
          iconColor: const Color(0xFFE67E22),
          iconBgColor: const Color(0xFFFFF4E5),
          title: 'ที่อยู่ของฉัน',
          subtitle: 'ที่อยู่ตามทะเบียนบ้านและที่อยู่ติดต่อจัดส่ง',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MyAddressPage(),
            ),
          ),
        ),
        _buildMenuItem(
          icon: Icons.account_balance_rounded,
          iconColor: const Color(0xFF2E7D32),
          iconBgColor: const Color(0xFFE8F5E9),
          title: 'บัญชีรับเงินสิทธิประโยชน์ (พร้อมเพย์/ธนาคาร)',
          subtitle: 'พร้อมเพย์ ${_formatIdCard(_idCard)} (ผูกสำเร็จ)',
          onTap: _showBenefitAccountDialog,
        ),
        _buildMenuItem(
          icon: Icons.local_hospital_rounded,
          iconColor: const Color(0xFF00897B),
          iconBgColor: const Color(0xFFE0F2F1),
          title: 'สถานพยาบาลตามสิทธิและการเปลี่ยนสิทธิ',
          subtitle: '$_hospital (เปลี่ยนสิทธิประจำปี)',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const HospitalPage(),
            ),
          ),
        ),

        // หมวด 2: บริการดิจิทัลและสิทธิประโยชน์
        _buildSectionHeader('บริการดิจิทัลและสิทธิประโยชน์'),
        _buildMenuItem(
          icon: Icons.qr_code_2_rounded,
          iconColor: const Color(0xFF5E35B1),
          iconBgColor: const Color(0xFFEDE7F6),
          title: 'บัตรประจำตัวผู้ประกันตนดิจิทัล (SSO Card)',
          subtitle: 'QR Code แสดงตนเข้ารับการรักษาพยาบาล',
          onTap: _openDigitalCard,
        ),
        _buildMenuItem(
          icon: Icons.sync_alt_rounded,
          iconColor: const Color(0xFF0288D1),
          iconBgColor: const Color(0xFFE1F5FE),
          title: 'ข้อมูลการเชื่อมต่อประกันสังคม',
          subtitle: 'สถานะเชื่อมต่อระบบฐานข้อมูล สปส.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConnectSSOPage(goHome: false),
            ),
          ).then((value) => readStorage()),
        ),
        _buildMenuItem(
          icon: Icons.share_rounded,
          iconColor: const Color(0xFF7B1FA2),
          iconBgColor: const Color(0xFFF3E5F5),
          title: 'การเชื่อมต่อบัญชีโซเชียลเน็ตเวิร์ก',
          subtitle: 'Google, Facebook, Line, Apple ID',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConnectSocialPage(),
            ),
          ).then((value) => readStorage()),
        ),

        // หมวด 3: ความปลอดภัยและการช่วยเหลือ
        _buildSectionHeader('ความปลอดภัยและการช่วยเหลือ'),
        _buildMenuItem(
          icon: Icons.lock_outline_rounded,
          iconColor: const Color(0xFFF57C00),
          iconBgColor: const Color(0xFFFFF3E0),
          title: 'เปลี่ยนรหัสผ่าน',
          subtitle: 'ความปลอดภัยของบัญชีผู้ใช้งาน',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangePasswordPage(),
            ),
          ).then((value) => readStorage()),
        ),
        _buildMenuItem(
          icon: Icons.verified_user_rounded,
          iconColor: const Color(0xFF3949AB),
          iconBgColor: const Color(0xFFE8EAF6),
          title: 'นโยบายเงื่อนไขและข้อตกลง (PDPA)',
          subtitle: 'ข้อกำหนดการใช้บริการและการคุ้มครองข้อมูล',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfilePolicySSOPage(),
            ),
          ).then((value) => readStorage()),
        ),
        _buildMenuItem(
          icon: Icons.phone_in_talk_rounded,
          iconColor: const Color(0xFFE53935),
          iconBgColor: const Color(0xFFFFEBEE),
          title: 'ติดต่อสำนักงานประกันสังคม (สายด่วน 1506)',
          subtitle: 'โทร 1506 ตลอด 24 ชม. หรือติดต่อสาขา สปส.',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileSSOPage(model: _futureAboutUs),
            ),
          ).then((value) => readStorage()),
        ),

        const SizedBox(height: 15),
        const Divider(height: 24, thickness: 0.8),
        InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _confirmLogout,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.power_settings_new, color: Color(0xFFFC4137), size: 20),
                SizedBox(width: 8),
                Text(
                  "ออกจากระบบ",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFFFC4137),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Kanit',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14.0, bottom: 6.0, left: 4.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.bold,
          color: Color(0xFF005C9E),
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 7.0),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: iconBgColor,
                ),
                width: 38.0,
                height: 38.0,
                child: Icon(icon, color: iconColor, size: 20.0),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Color(0xFF102F30),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF757575),
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              trailing ??
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: Color(0xFFBDBDBD),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background/login.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          controller: scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            left: 12,
            right: 12,
            bottom: 30,
          ),
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                Padding(padding: const EdgeInsets.only(top: 75.0), child: card()),
                SizedBox(
                  width: 150.0,
                  height: 150.0,
                  child: Center(
                    child: Container(
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
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 10,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const SizedBox(
                      height: 35,
                      width: 35,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFF005C9E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
