import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sso/shared/extension.dart';
import 'package:sso/widget/year_select.dart';

class UsedPrivilegePage extends StatefulWidget {
  const UsedPrivilegePage({super.key});

  @override
  State<UsedPrivilegePage> createState() => _UsedPrivilegePageState();
}

class _UsedPrivilegePageState extends State<UsedPrivilegePage> {
  String yearSelected = '2565';

  List<dynamic> model = [
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
