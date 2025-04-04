import 'package:flutter/material.dart';
import 'package:sso/pages/home.dart';

class HospitalSuccessPage extends StatelessWidget {
  const HospitalSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF4F9),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFEFF4F9),
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        flexibleSpace: Container(
          color: Colors.transparent,
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomePage(),
                      ),
                      (Route<dynamic> route) => false,
                    );
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
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 170,
              width: 170,
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(85),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 0.75),
                    color: Colors.grey.withOpacity(0.3),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/logoNoText.png',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'ส่งคำขอเรียบร้อย',
              style: TextStyle(
                fontSize: 30,
                color: Color(0xFF005C9E),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'ท่านสามารถตรวจสอบผลการเปลี่ยนสถานพยาบาล',
              style: TextStyle(
                fontSize: 13,
              ),
            ),
            RichText(
              text: TextSpan(
                text: '',
                style: TextStyle(fontSize: 13, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'ได้อีก',
                  ),
                  TextSpan(
                    text: ' 2 วันทำการ ',
                    style: TextStyle(
                      color: Color(0xFF005C9E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(
                    text: 'ที่เมนู',
                  ),
                  TextSpan(
                    text: 'ประวัติการเปลี่ยนแปลงสถานพยาบาล',
                    style: TextStyle(
                      color: Color(0xFF005C9E),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 70),
          ],
        ),
      ),
    );
  }
}
