import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/pages/blank_page/toast_fail.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';
import 'package:sso/widget/year_select.dart';

class DentalPage extends StatefulWidget {
  const DentalPage({super.key});

  @override
  State<DentalPage> createState() => _DentalPageState();
}

class _DentalPageState extends State<DentalPage> {
  final storage = const FlutterSecureStorage();
  List<dynamic> model = [];
  List<dynamic> categoryList = [];
  String categorySelected = '';
  String yearSelected = (DateTime.now().year + 543).toString();
  String updateDateText = '';
  int totalRemaining = 900;
  bool isLoading = true;

  String _profileName = 'We Build Operate Co.,Ltd';
  String _idCard = '1-1004-99882-12-3';
  String _section = '33';

  String _formatIdCard(String id) {
    if (id.isEmpty) return '1-1004-99882-12-3';
    if (id.length == 13) {
      return '${id.substring(0, 1)}-${id.substring(1, 5)}-${id.substring(5, 10)}-${id.substring(10, 12)}-${id.substring(12, 13)}';
    }
    return id;
  }

  @override
  void initState() {
    int bYear = DateTime.now().year + 543;
    yearSelected = bYear.toString();
    updateDateText = 'ข้อมูล ณ ${DateTime.now().day}/${DateTime.now().month}/${(bYear % 100).toString().padLeft(2, '0')}';
    _loadDentalData();
    super.initState();
  }

  Future<void> _loadDentalData() async {
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
      debugPrint('Error reading user profile in dental: $e');
    }

    try {
      var result = await postDio('${server}m/welfare/read', {
        'category': 'dental',
        'limit': 20,
      });

      if (result != null && result is List && result.isNotEmpty) {
        setState(() {
          model = result;
          categoryList = [
            {'code': '', 'title': 'ทั้งหมด'},
            {'code': '1', 'title': 'มาตรา 33'},
            {'code': '2', 'title': 'มาตรา 39'},
          ];
          isLoading = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('Error loading dental data: $e');
    }

    // Default benefit information when offline or pending backend records
    setState(() {
      model = [
        {
          'title': 'สิทธิประโยชน์ทันตกรรมประจำปี $yearSelected',
          'value': '900',
          'date': '${DateTime.now().day}/${DateTime.now().month}/${(int.parse(yearSelected) % 100)}',
          'description': 'ถอนฟัน อุดฟัน ขูดหินปูน และผ่าฟันคุด 900 บาท/ปี',
        },
      ];
      categoryList = [
        {'code': '', 'title': 'ทั้งหมด'},
        {'code': '1', 'title': 'มาตรา 33'},
        {'code': '2', 'title': 'มาตรา 39'},
      ];
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/images/bg_cloud.png',
                width: double.infinity,
                height: 212 + MediaQuery.of(context).padding.top,
                fit: BoxFit.cover,
              ),
              Positioned.fill(
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'ยอดเงินคงเหลือ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        moneyFormat('900'),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005C9E),
                          height: 1,
                        ),
                      ),
                      Text(
                        updateDateText,
                        style: TextStyle(fontSize: 13, height: 1),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 15,
                left: 15,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios, size: 30),
                      SizedBox(width: 4),
                      Text(
                        'ทันตกรรม',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 5,
                right: 15,
                child: GestureDetector(
                  onTap: () => _buildModalSelectYear(),
                  child: Row(
                    children: [
                      Text(
                        ' ปี $yearSelected',
                        style: TextStyle(fontSize: 17),
                      ),
                      Icon(Icons.arrow_drop_down, size: 25),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _profileName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005C9E),
                      ),
                    ),
                    const Text(
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
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _section.isNotEmpty ? _section : '33/39',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005C9E),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  'ประวัติการใช้สิทธิ์ทันตกรรม',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(child: _buildCard(model)),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCard(List<dynamic> param) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      itemCount: param.length,
      physics: BouncingScrollPhysics(),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder:
          (_, __) => InkWell(
            onTap: () => toastFail(context),
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
                      Text('ค่าขูดหินปูน', style: TextStyle(fontSize: 8)),
                    ],
                  ),
                ],
              ),
            ),
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
}
