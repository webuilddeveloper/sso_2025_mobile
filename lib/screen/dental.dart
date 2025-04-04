import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sso/pages/blank_page/toast_fail.dart';
import 'package:sso/shared/extension.dart';
import 'package:sso/widget/year_select.dart';

class DentalPage extends StatefulWidget {
  const DentalPage({super.key});

  @override
  State<DentalPage> createState() => _DentalPageState();
}

class _DentalPageState extends State<DentalPage> {
  List<dynamic> model = [];
  List<dynamic> categoryList = [];
  String categorySelected = '';
  String yearSelected = '2565';

  @override
  void initState() {
    _mockData();
    super.initState();
  }

  _mockData() {
    var a = [];
    var b = [
      {
        'title': 'สิงหาคม',
        'value': Random().nextInt(900).toString(),
        'date': '15/08/65',
      },
      {
        'title': 'กรกฎาคม',
        'value': Random().nextInt(900).toString(),
        'date': '15/07/65',
      },
      {
        'title': 'มิถุนายน',
        'value': Random().nextInt(900).toString(),
        'date': '15/06/65',
      },
      {
        'title': 'พฤษภาคม',
        'value': Random().nextInt(900).toString(),
        'date': '15/05/65',
      },
      {
        'title': 'เมษายน',
        'value': Random().nextInt(900).toString(),
        'date': '15/04/65',
      },
      {
        'title': 'มีนาคม',
        'value': Random().nextInt(900).toString(),
        'date': '15/03/65',
      },
      {
        'title': 'กุมภาพันธ์',
        'value': Random().nextInt(900).toString(),
        'date': '15/02/65',
      },
      {
        'title': 'มกราคม',
        'value': Random().nextInt(900).toString(),
        'date': '15/01/65',
      },
    ];
    for (var i = 50; i < 65; i++) {
      a.add({'title': i.toString(), 'value': Random().nextInt(900).toString()});
    }

    setState(() {
      model = b;
      categoryList = [
        {'code': '', 'title': 'ทั้งหมด'},
        {'code': '1', 'title': 'มาตรา 33'},
        {'code': '2', 'title': 'มาตรา 39'},
      ];
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
                        'ข้อมูล ณ 03/08/65',
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
                      'ยุทธเลิศ สรณะ',
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
                      '1-234-12345-5',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '33/39',
                      style: TextStyle(
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
