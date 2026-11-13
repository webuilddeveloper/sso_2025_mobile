import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';
import 'package:sso/widget/year_select.dart';

class UsedPrivilegePage extends StatefulWidget {
  const UsedPrivilegePage({super.key});

  @override
  State<UsedPrivilegePage> createState() => _UsedPrivilegePageState();
}

class _UsedPrivilegePageState extends State<UsedPrivilegePage> {
  final storage = const FlutterSecureStorage();
  String yearSelected = (DateTime.now().year + 543).toString();
  bool isLoading = true;

  String _profileName = 'We Build Operate Co.,Ltd';
  String _idCard = '1-1004-99882-12-3';
  String _section = '33';

  List<dynamic> model = [];

  @override
  void initState() {
    yearSelected = (DateTime.now().year + 543).toString();
    _loadUsedPrivileges();
    super.initState();
  }

  String _formatIdCard(String id) {
    if (id.isEmpty) return '1-1004-99882-12-3';
    if (id.length == 13) {
      return '${id.substring(0, 1)}-${id.substring(1, 5)}-${id.substring(5, 10)}-${id.substring(10, 12)}-${id.substring(12, 13)}';
    }
    return id;
  }

  Future<void> _loadUsedPrivileges() async {
    setState(() {
      isLoading = true;
    });

    try {
      final pFirst = await storage.read(key: 'profileFirstName');
      final pLast = await storage.read(key: 'profileLastName');
      final pCat = await storage.read(key: 'profileCategory');
      final pCode = await storage.read(key: 'profileCode1');

      if (pFirst != null && pFirst.isNotEmpty) {
        _profileName = '$pFirst ${pLast ?? ''}'.trim();
      }
      if (pCat != null && pCat.isNotEmpty) {
        _section = pCat;
      }

      if (pCode != null && pCode.isNotEmpty) {
        var userData = await postDio(profileReadApi, {'code': pCode});
        if (userData != null && userData is Map) {
          if (userData['firstName'] != null) {
            _profileName =
                '${userData['firstName']} ${userData['lastName'] ?? ''}'.trim();
          }
          if (userData['idcard'] != null &&
              userData['idcard'].toString().isNotEmpty) {
            _idCard = userData['idcard'].toString();
          }
          if (userData['category'] != null) {
            _section = userData['category'].toString();
          }
        }
      }
    } catch (e) {
      debugPrint('Error reading user profile in used_privilege: $e');
    }

    try {
      var result = await postDio('${server}m/privilege/read', {
        'limit': 20,
      });

      if (result != null && result is List && result.isNotEmpty) {
        setState(() {
          model = result;
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('Error reading used privileges: $e');
    }

    setState(() {
      model = [
        {
          'title': 'ตรวจสุขภาพประจำปี 14 รายการ',
          'value': 'ใช้สิทธิแล้ว',
          'date': '15/05/${int.parse(yearSelected) % 100}',
          'description': 'ตรวจสุขภาพทั่วไปและตรวจเลือด ณ โรงพยาบาลตามสิทธิ',
        },
        {
          'title': 'ทำฟัน ขูดหินปูน อุดฟัน (ทันตกรรม)',
          'value': '900 บาท',
          'date': '10/08/${int.parse(yearSelected) % 100}',
          'description': 'รับบริการทันตกรรมไม่ต้องสำรองจ่าย คลินิกในเครือข่าย สปส.',
        },
        {
          'title': 'สิทธิรักษาพยาบาลผู้ป่วยนอก (OPD)',
          'value': 'ใช้สิทธิแล้ว',
          'date': '02/10/${int.parse(yearSelected) % 100}',
          'description': 'ตรวจรักษาโรคทั่วไป ณ โรงพยาบาลตามสิทธิ โดยไม่มีค่าใช้จ่าย',
        },
        {
          'title': 'เงินสมทบกรณีชราภาพสะสม ประจำปี $yearSelected',
          'value': 'สะสมต่อเนื่อง',
          'date':
              '${DateTime.now().day}/${DateTime.now().month}/${int.parse(yearSelected) % 100}',
          'description': 'เงินสมทบฝ่ายผู้ประกันตน + นายจ้าง + รัฐบาล',
        },
      ];
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                        'การใช้สิทธิประโยชน์',
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
                GestureDetector(
                  onTap: () => _buildModalSelectYear(),
                  child: Row(
                    children: [
                      Text(' ปี $yearSelected', style: TextStyle(fontSize: 17)),
                      Icon(Icons.arrow_drop_down, size: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 160,
                width: double.infinity,
                color: Color(0xFF3880B3).withOpacity(0.15),
              ),
              Positioned.fill(
                bottom: 0,
                child: Image.asset(
                  'assets/images/builds.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _profileName,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005C9E),
                            ),
                          ),
                          Text(
                            'ผู้ประกันตนมาตรา',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatIdCard(_idCard),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            _section,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF005C9E),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              'การใช้สิทธิประโยชน์',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: _buildList(model)),
        ],
      ),
    );
  }

  _buildModalSelectYear() {
    int year = 2561;
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0.6),
      builder: (BuildContext bc) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                offset: Offset(0.75, 0),
                blurRadius: 8,
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                'กรุณาเลือกปี',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: YearSelectWidget(
                  current: year,
                  changed: (value) => year = value,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFFE4E4E4),
                      ),
                      child: Text(
                        'ยกเลิก',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap:
                        () => {
                          setState(() => yearSelected = year.toString()),
                          Navigator.pop(context),
                        },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFFE8F0F6),
                      ),
                      child: Text(
                        'ยืนยัน',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C9E),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 40),
            ],
          ),
        );
      },
    );
  }

  Widget _buildList(List<dynamic> param) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      physics: BouncingScrollPhysics(),
      itemCount: param.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder:
          (_, __) => InkWell(
            // onTap: () => toastFail(context),
            child: SizedBox(
              height: 42,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${param[__]['title']}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C9E),
                        ),
                      ),
                      Text(
                        '${param[__]['date']}',
                        style: TextStyle(fontSize: 8),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        moneyFormat(param[__]['value']),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C9E),
                        ),
                      ),
                      Text('สิทธิ์ทันตกรรม', style: TextStyle(fontSize: 8)),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
