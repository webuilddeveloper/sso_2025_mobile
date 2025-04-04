import 'package:flutter/material.dart';
import 'package:sso/pages/blank_page/toast_fail.dart';
import 'package:sso/screen/hospital_success.dart';

class HospitalFormPage extends StatefulWidget {
  const HospitalFormPage({super.key, this.model});
  final dynamic model;

  @override
  State<HospitalFormPage> createState() => _HospitalFormPageState();
}

class _HospitalFormPageState extends State<HospitalFormPage> {
  dynamic model;
  bool acceptPolicy = false;

  @override
  void initState() {
    model = widget.model;
    super.initState();
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
                        'ยืนยันเปลี่ยน',
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          _buildCard(model),
          SizedBox(height: 20),
          Text(
            'หลักเกณฑ์การเลือกสถานพยาบาล',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(
            '1. การเลือกสถานพยาบาล ผู้ประกันตนหรือผู้มีสิทธิต้องเลือกสถานพยาบาลซึ่งตั้งอยู่ในเขตจังหวัดที่ประจำทำงานอยู่หรือ พักอาศัยอยู่จริง หรือเขตจังหวัดรอยต่อ 2. การเปลี่ยนสถานพยาบาล ผู้ประกันตนหรือผู้มีสิทธิสามารถขอเปลี่ยนสถานพยาบาลได้ ตามหลักเกณฑ์ ดังต่อไปนี้ (1) เปลี่ยนสถานพยาบาลประจำปีได้ปีละ 1 ครั้ง ตั้งแต่วันที่ 1 มกราคม ถึงวันที่ 31 มีนาคมของทุกปี (ยื่นแบบได้ตั้งแต่วันที่ 16 ธันวาคม เป็นต้นไป) (2) เปลี่ยนสถานพยาบาลระหว่างปี กรณีมีเหตุจำเป็น เช่น ย้ายที่พักอาศัย ย้ายสถานที่ประจำทำงาน หรือพิสูจน์ทราบว่ามีการเลือกสถานพยาบาลให้ผู้ประกันตนหรือผู้มีสิทธิ โดยผู้ประกันตนหรือผู้มีสิทธินั้น ไม่ประสงค์จะไปรับบริการทางการแพทย์ในสถานพยาบาลดังกล่าว ทั้งนี้ กรณีย้ายที่พักอาศัย หรือย้ายสถานที่ประจำทำงาน ให้ยื่นเปลี่ยนสถานพยาบาลภายในระยะเวลา สามสิบวันนับแต่วันที่ย้ายที่พักอาศัย หรือย้ายสถานที่ประจำทำงาน 3. การกำหนดสิทธิในการรับบริการทางการแพทย์ เมื่อผู้ประกันตนหรือผู้มีสิทธิยื่นแบบฯ แล้ว สำนักงานจะกำหนดสถานพยาบาลที่ผู้ประกันตนหรือผู้มีสิทธิมีสิทธิไปรับบริการทางการแพทย์ โดยระบุวันเริ่มสิทธิ ดังนี้ (1) รับแบบฯ ระหว่างวันที่ 1 ถึง 15 (ก่อน 16.30 น.ของวันที่ 15) กำหนดสิทธิในการรับบริการทางการแพทย์เป็นวันที่ 16 ของเดือนนั้น (2) รับแบบฯ ระหว่างวันที่ 16 ถึงวันทำการสุดท้ายของเดือน (ก่อน 16.30 น.ของวันสุดท้ายของเดือน) กำหนดสิทธิในการรับบริการทางการแพทย์เป็นวันที่ 1 ของเดือนถัดไป',
            style: TextStyle(fontSize: 13, color: Color(0xFF646464)),
          ),
          SizedBox(height: 20),
          _buildCheck('ยอมรับข้อตกลง'),
          SizedBox(height: 10),
          Text(
            'ขณะที่ข้าพเจ้าเลือกหรือเปลี่ยนสถานพยาบาลใหม่ ข้าพเจ้าไม่ได้นอนพักรักษาตัวเป็นผู้ป่วยใน ณ สถานพยาบาลใดๆ และขอรับรองว่าข้อความข้างต้นเป็นความจริงทุกประการ หากปรากฎภายหลังว่าข้าพเจ้าให้ข้อมูลที่เป็นเท็จและก่อให้เกิดความเสียหายแก่บุคลลใด หรือสำนักงานประกันสังคม ข้าพเจ้าขอเป็นผู้รับผิดชอบในความเสียหายที่เกิดขึ้น',
            style: TextStyle(fontSize: 13, color: Color(0xFF646464)),
          ),
          SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: 40,
                    width: 85,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        width: 1,
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      'ยกเลิก',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (acceptPolicy) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HospitalSuccessPage(),
                        ),
                      );
                    } else {
                      toastFail(context, text: 'กรุณายอมรับข้อตกลง');
                    }
                  },
                  child: Container(
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color:
                          acceptPolicy ? Color(0xFFFFC324) : Color(0xFFE4E4E4),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Text(
                      'บันทึก',
                      style: TextStyle(
                        color: acceptPolicy ? Colors.white : Color(0xFF646464),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
        ],
      ),
    );
  }

  _buildCard(model) {
    return GestureDetector(
      onTap:
          () => {
            // setState(() => currentHospital = model),
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => HospitalFormPage()),
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
            Image.asset('assets/icon.png', width: 56, height: 56),
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

  _buildCheck(String title) {
    return Container(
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          setState(() {
            acceptPolicy = !acceptPolicy;
          });
        },
        child: Container(
          height: 33,
          width: 135,
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: acceptPolicy ? Color(0xFFE8F0F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color:
                  acceptPolicy
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
                  color: acceptPolicy ? Color(0xFF005C9E) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    width: 1,
                    color: acceptPolicy ? Color(0xFFE8F0F6) : Color(0xFF005C9E),
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
      ),
    );
  }
}
