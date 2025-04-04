import 'dart:math';

import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<dynamic> model = [];
  List<dynamic> modelSuggest = [];
  List<String> tempTitle = ['ลดเงินสมทบ เหลือ 250', 'ได้รับเงินสมทบของคุณแล้ว'];
  List<String> tempTitleSuggest = [
    'รับข่าวสารได้รวดเร็วและถูกต้อง',
    'สิทธิ์พิเศษสำหรับคุณ',
  ];

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() {
    List<dynamic> data = [];
    List<dynamic> data2 = [];
    for (var i = 0; i < 5; i++) {
      setState(() {
        data.add({
          'title': tempTitle[Random().nextInt(tempTitle.length)],
          'description':
              'ลดเงินสมทบสำหรับสมาชิกผู้ประกันตนมาตรา 33 ตั้งแต่เดือน ก.ค. - ส.ค.',
          'date': '08 / 07 / 65',
        });
        data2.add({
          'title': tempTitleSuggest[Random().nextInt(tempTitleSuggest.length)],
          'description':
              'SSO Plus ขอมอบสิทธิ์พิเศษมากมายรอคุณอยู่ เพียงยืนยันตัวตนกับประกันสังคมบนแอพ',
          'date': '08 / 07 / 65',
        });
      });
    }
    setState(() {
      model = data;
      modelSuggest = data2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Text(
                        'แจ้งเตือน',
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
                  onTap:
                      () => {
                        setState(() {
                          model = [];
                          modelSuggest = [];
                        }),
                      },
                  child: Image.asset(
                    'assets/images/bin_box.png',
                    height: 35,
                    width: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            if (model.length > 0)
              Text(
                'จากประกันสังคมถึงท่าน',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => _buildCard(model[index]),
              separatorBuilder: (_, __) => SizedBox(height: 20),
              itemCount: model.length,
            ),
            SizedBox(height: 25),
            if (modelSuggest.length > 0)
              Text(
                'แนะนำ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
            SizedBox(height: 10),
            ListView.separated(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) => _buildCard(modelSuggest[index]),
              separatorBuilder: (_, __) => SizedBox(height: 20),
              itemCount: modelSuggest.length,
            ),
          ],
        ),
      ),
    );
  }

  _buildCard(param) {
    return Container(
      height: 95,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey.withOpacity(0.4)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('assets/images/letter_speed.png', width: 27, height: 20),
          SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  param['title'],
                  style: TextStyle(color: Color(0xFF005C9E), fontSize: 15),
                ),
                Text(
                  param['description'],
                  style: TextStyle(fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 5),
                Text(param['date'], style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          SizedBox(width: 7),
          Icon(Icons.arrow_forward_ios, size: 20),
        ],
      ),
    );
  }
}
