import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/component/material/input_with_label.dart';
import 'package:sso/screen/hospital_form.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/scroll_behavior.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  final storage = FlutterSecureStorage();
  String yearSelected = (DateTime.now().year + 543).toString();
  String remarkSelected = '';
  dynamic userData;
  String _profileName = 'We Build Operate Co.,Ltd';
  String _imageUrl = '';
  String _section = '33';
  String _hospitalName = 'โรงพยาบาลกรุงเทพ';
  dynamic currentHospital = {
    'title': 'โรงพยาบาลกรุงเทพ',
    'imageUrl': '',
    'description': 'กรุงเทพมหานครและปริมณฑล',
    'date': '${DateTime.now().day}/${DateTime.now().month}/${(DateTime.now().year + 543) % 100}',
  };

  List<dynamic> temp = [
    {
      'title': 'โรงพยาบาลจุฬาลงกรณ์ สภากาชาดไทย',
      'imageUrl': '',
      'description': 'เขตปทุมวัน กรุงเทพมหานคร',
      'date': '${DateTime.now().day}/${DateTime.now().month}/${(DateTime.now().year + 543) % 100}',
    },
    {
      'title': 'โรงพยาบาลศิริราช',
      'imageUrl': '',
      'description': 'เขตบางกอกน้อย กรุงเทพมหานคร',
      'date': '${DateTime.now().day}/${DateTime.now().month}/${(DateTime.now().year + 543) % 100}',
    },
    {
      'title': 'โรงพยาบาลรามาธิบดี',
      'imageUrl': '',
      'description': 'เขตราชเทวี กรุงเทพมหานคร',
      'date': '${DateTime.now().day}/${DateTime.now().month}/${(DateTime.now().year + 543) % 100}',
    },
  ];

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    try {
      var data = await storage.read(key: 'dataUserLoginSSO');
      if (data != null && data.isNotEmpty) {
        var user = json.decode(data);
        if (user is Map) {
          setState(() {
            userData = user;
            if (user['firstName'] != null) {
              _profileName = '${user['firstName']} ${user['lastName'] ?? ''}'.trim();
            }
            if (user['imageUrl'] != null) {
              _imageUrl = user['imageUrl'].toString();
            }
            if (user['category'] != null) {
              _section = user['category'].toString();
            }
          });
        }
      }

      String? pFirst = await storage.read(key: 'profileFirstName');
      String? pLast = await storage.read(key: 'profileLastName');
      String? pCat = await storage.read(key: 'profileCategory');
      String? pCode = await storage.read(key: 'profileCode1');

      if (pFirst != null && pFirst.isNotEmpty) {
        setState(() {
          _profileName = '$pFirst ${pLast ?? ''}'.trim();
        });
      }
      if (pCat != null && pCat.isNotEmpty) {
        setState(() {
          _section = pCat;
        });
      }

      if (pCode != null && pCode.isNotEmpty) {
        var pData = await postDio(profileReadApi, {'code': pCode});
        if (pData != null && pData is Map) {
          setState(() {
            if (pData['firstName'] != null) {
              _profileName = '${pData['firstName']} ${pData['lastName'] ?? ''}'.trim();
            }
            if (pData['imageUrl'] != null) {
              _imageUrl = pData['imageUrl'].toString();
            }
            if (pData['category'] != null) {
              _section = pData['category'].toString();
            }
          });
        }
      }

      var poiHospitals = await postDio('${server}m/poi/read', {
        'category': 'hospital',
        'limit': 20,
      });

      if (poiHospitals != null && poiHospitals is List && poiHospitals.isNotEmpty) {
        setState(() {
          temp = poiHospitals;
        });
      }
    } catch (e) {
      debugPrint('Error reading hospital data: $e');
    }
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
                        'เปลี่ยนสถานพยาบาล',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 215,
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
                bottom: 10,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: loadingImageNetwork(
                              _imageUrl,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              isProfile: true,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _profileName,
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            'ผู้ประกันตนมาตรา ${_section == 'guest' || _section.isEmpty ? '33' : _section}',
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color(0xFF005C9E),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
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
                            child: Text(
                              _hospitalName,
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF005C9E),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เหตุผลการเปลี่ยนสถานพยาบาล',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 35,
                  child: ScrollConfiguration(
                    behavior: CsBehavior(),
                    child: ListView(
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildRemark('เปลี่ยนประจำปี'),
                        SizedBox(width: 10),
                        _buildRemark('ย้ายสถานประกอบการ'),
                        SizedBox(width: 10),
                        _buildRemark('ย้ายที่อยู่'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                _buildCurrentCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildRemark(String title) {
    return GestureDetector(
      onTap: () {
        setState(() {
          remarkSelected = title;
        });
      },
      child: Container(
        height: 33,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color:
              remarkSelected == title ? Color(0xFFE8F0F6) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color:
                remarkSelected == title
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
                    remarkSelected == title
                        ? Color(0xFF005C9E)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  width: 1,
                  color:
                      remarkSelected == title
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

  _buildCurrentCard() {
    return GestureDetector(
      onTap: () => _buildModal(temp),
      child: Container(
        height: 144,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color(0xFFE8F0F6),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF005C9E).withOpacity(0.2)),
              ),
              child: const Icon(
                Icons.local_hospital_rounded,
                color: Color(0xFF005C9E),
                size: 30,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('สถานพยาบาลปัจจุบัน', style: TextStyle(fontSize: 13, fontFamily: 'Kanit')),
                  Expanded(
                    child: Text(
                      currentHospital['title'] ?? 'โรงพยาบาลกรุงเทพ',
                      style: const TextStyle(
                        fontSize: 19,
                        color: Color(0xFF005C9E),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit',
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE4A025),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Text(
                      'เลือกสถานพยาบาล',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Kanit',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildModal(List<dynamic> param) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white.withOpacity(0.6),
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(10),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.centerRight,
                  width: double.infinity,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      color: Color(0xFFFFC324),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: DecorationRegister.searchHospital(
                  context,
                  hintText: 'โรงพยาบาล',
                ),
              ),
              SizedBox(height: 15),
              Text(
                'โรงพยาบาลใกล้เคียง',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.separated(
                  itemCount: param.length,
                  physics: BouncingScrollPhysics(),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (_, __) => InkWell(child: _buildCard(param[__])),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _buildCard(model) {
    return GestureDetector(
      onTap:
          () => {
            // setState(() => currentHospital = model),
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HospitalFormPage(model: model)),
            ),
            // Navigator.pop(context),
          },
      child: Container(
        height: 124,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFFE8F0F6),
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF005C9E).withOpacity(0.15)),
              ),
              child: const Icon(
                Icons.local_hospital_outlined,
                color: Color(0xFF005C9E),
                size: 28,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF005C9E),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    model['description'],
                    style: TextStyle(fontSize: 11),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
