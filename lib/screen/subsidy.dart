import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sso/pages/blank_page/toast_fail.dart';
import 'package:sso/shared/extension.dart';
import 'package:sso/widget/year_select.dart';

class SubsidyPage extends StatefulWidget {
  const SubsidyPage({super.key});

  @override
  State<SubsidyPage> createState() => _SubsidyPageState();
}

class _SubsidyPageState extends State<SubsidyPage> {
  late PageController _pageController;
  late int pageSelected;
  List<dynamic> data1 = [];
  List<dynamic> data2 = [];
  List<dynamic> categoryList = [];
  String categorySelected = '';
  String yearSelected = '2565';

  @override
  void initState() {
    pageSelected = 0;
    _pageController = PageController(initialPage: 0);
    _mockData();
    super.initState();
  }

  _mockData() {
    var a = [];
    var b = [
      {
        'title': 'สิงหาคม',
        'value': Random().nextInt(10005).toString(),
        'date': '15/08/65',
      },
      {
        'title': 'กรกฎาคม',
        'value': Random().nextInt(10005).toString(),
        'date': '15/07/65',
      },
      {
        'title': 'มิถุนายน',
        'value': Random().nextInt(10005).toString(),
        'date': '15/06/65',
      },
      {
        'title': 'พฤษภาคม',
        'value': Random().nextInt(10005).toString(),
        'date': '15/05/65',
      },
      {
        'title': 'เมษายน',
        'value': Random().nextInt(10005).toString(),
        'date': '15/04/65',
      },
      {
        'title': 'มีนาคม',
        'value': Random().nextInt(10005).toString(),
        'date': '15/03/65',
      },
      {
        'title': 'กุมภาพันธ์',
        'value': Random().nextInt(10005).toString(),
        'date': '15/02/65',
      },
      {
        'title': 'มกราคม',
        'value': Random().nextInt(10005).toString(),
        'date': '15/01/65',
      },
    ];
    for (var i = 50; i < 65; i++) {
      a.add({
        'title': i.toString(),
        'value': Random().nextInt(10005).toString(),
      });
    }

    setState(() {
      data1 = a.reversed.toList();
      data2 = b;
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
                    children: [
                      Text(
                        'เงินสมทบ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  pageSelected = 0;
                                  _pageController.jumpToPage(0);
                                }),
                            child: Text(
                              'ชราภาพ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    pageSelected == 0
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    pageSelected == 0
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          GestureDetector(
                            onTap:
                                () => setState(() {
                                  pageSelected = 1;
                                  _pageController.jumpToPage(1);
                                }),
                            child: Text(
                              'ผู้ประกันตน',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    pageSelected == 1
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                color:
                                    pageSelected == 1
                                        ? Colors.black
                                        : Colors.black.withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Text(
                        'รวมเงินสมทบชราภาพ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        moneyFormat('25000'),
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
                    ],
                  ),
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 15,
                left: 15,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, size: 30),
                ),
              ),
              if (pageSelected == 1)
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
                SizedBox(
                  height: 25,
                  width: double.infinity,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryList.length,
                    itemBuilder:
                        (_, __) => GestureDetector(
                          onTap:
                              () => {
                                setState(
                                  () =>
                                      categorySelected =
                                          categoryList[__]['code'],
                                ),
                              },
                          child: Text(
                            categoryList[__]['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight:
                                  categorySelected == categoryList[__]['code']
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                              color:
                                  categorySelected == categoryList[__]['code']
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.51),
                            ),
                          ),
                        ),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [_buildCard(data1), _buildCard(data2)],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildCard(List<dynamic> param) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      physics: BouncingScrollPhysics(),
      itemCount: param.length,
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
                  if (pageSelected == 0)
                    Text(
                      'ปี ${param[__]['title']}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF005C9E),
                      ),
                    ),
                  if (pageSelected == 1)
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
                      Text(
                        pageSelected == 0 ? 'รายละเอียด >' : 'อัตราสมทบ 5%',
                        style: TextStyle(fontSize: 8),
                      ),
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
