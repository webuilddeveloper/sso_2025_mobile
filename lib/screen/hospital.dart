import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/component/material/input_with_label.dart';
import 'package:sso/screen/hospital_form.dart';
import 'package:sso/shared/scroll_behavior.dart';

class HospitalPage extends StatefulWidget {
  const HospitalPage({super.key});

  @override
  State<HospitalPage> createState() => _HospitalPageState();
}

class _HospitalPageState extends State<HospitalPage> {
  final storage = FlutterSecureStorage();
  String yearSelected = '2565';
  String remarkSelected = '';
  dynamic userData;
  dynamic currentHospital = {
    'title': 'โรงพยาบาลกรุงเทพ',
    'imageUrl':
        'https://vetweb.we-builds.com/vet-document/images/news/31cb4390-49bf-4d94-9865-e4af67461a32/ss.png',
    'description': 'แขวงสายไหม เขตสายไหม กรุงเทพมหานคร',
    'date': '15/08/65',
  };

  List<dynamic> temp = [
    {
      'title': 'โรงพยาบาลบีแคร์ เมดิคอลเซ็นเตอร์',
      'imageUrl':
          'https://vetweb.we-builds.com/vet-document/images/news/b8a362a8-af7a-4686-910a-3a3c6e5b84ee/download.jpeg',
      'description': 'แขวงสายไหม เขตสายไหม กรุงเทพมหานคร',
      'date': '15/08/65',
    },
    {
      'title': 'โรงพยาบาลเปาโลโชคชัย 4',
      'imageUrl':
          'https://vetweb.we-builds.com/vet-document/images/news/6c67c189-9466-4b69-a7e9-d99e3f1652e8/download.png',
      'description': 'แขวงลาดพร้าว เขตลาดพร้าว กรุงเทพ',
      'date': '15/08/65',
    },
  ];

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() async {
    var data = await storage.read(key: 'dataUserLoginSSO');
    setState(() {
      userData = json.decode(data!);
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
                            child:
                                userData['imageUrl'] != '' &&
                                        userData['imageUrl'] != null
                                    ? loadingImageNetwork(
                                      userData['imageUrl'],
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                    : SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Image.asset(
                                        'assets/images/user_not_found.png',
                                        height: 40,
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userData['firstName']} ${userData['lastName']}',
                            style: TextStyle(fontSize: 13),
                          ),
                          Text(
                            'ผู้ประกันตนมาตรา 33',
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
                            child: Text(
                              'โรงพยาบาลกรุงเทพ',
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
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Color(0xFFE8F0F6),
        ),
        child: Row(
          children: [
            loadingImageNetwork(
              currentHospital['imageUrl'],
              width: 50,
              height: 50,
            ),
            SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('สถานพยาบาลปัจจุบัน', style: TextStyle(fontSize: 13)),
                  Expanded(
                    child: Text(
                      currentHospital['title'],
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF005C9E),
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    decoration: BoxDecoration(
                      color: Color(0xFFE4A025),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Text(
                      'เลือกสถานพยาบาล',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
            loadingImageNetwork(model['imageUrl'], width: 56, height: 56),
            SizedBox(width: 13),
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
