import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class AboutUsForm extends StatefulWidget {
  const AboutUsForm({super.key, required this.model, required this.title});

  final Future<dynamic> model;
  final String title;

  @override
  _AboutUsForm createState() => _AboutUsForm();
}

class _AboutUsForm extends State<AboutUsForm> {
  // final Set<Marker> _markers = {};
  Completer<GoogleMapController> _mapController = Completer();

  @override
  void initState() {
    super.initState();
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        } else {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var lat = double.parse(
              snapshot.data['latitude'] != ''
                  ? snapshot.data['latitude']
                  : '0.0',
            );
            var lng = double.parse(
              snapshot.data['longitude'] != ''
                  ? snapshot.data['longitude']
                  : '0.0',
            );
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/background/bg_sso.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    title: Text(widget.title),
                  ),
                  // ส่วนที่สำคัญ - ใส่ SingleChildScrollView เพื่อให้สามารถเลื่อนได้
                  body: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Container(
                            height: 105,
                            width: 105,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/logo-2.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'SSO Plus',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Kanit',
                              color: Color(0xFF005C9E),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: rowData(
                              icon: Icon(
                                Icons.location_on_outlined,
                                color: Colors.black,
                                size: 20.0,
                              ),
                              title:
                                  snapshot.data != null
                                      ? snapshot.data['address'] ?? ''
                                      : '',
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: rowData(
                              title:
                                  'สำนักงานประกันสังคมได้รับการจัดตั้งขึ้นภายใต้กระทรวงมหาดไทย เมื่อวันที่ 3 กันยายน 2533 งานที่เกี่ยวข้องกับการจัดหาประกันสังคมและกองทุนเงินทดแทนได้ถูกโอนจากกรมประชาสงเคราะห์และกรมแรงงานตามลำดับไปยังสำนักงานประกันสังคม ในปีเดียวกันร่างพระราชบัญญัติประกันสังคมได้รับความเห็นชอบจากรัฐสภาและมีผลบังคับใช้เมื่อวันที่ 2 กันยายน 2533 นับตั้งแต่เริ่มก่อตั้งกระทรวงแรงงานในปี 2536 สำนักงานประกันสังคมอยู่ภายใต้การกำกับดูแลโดยรวม สำนักงานประกันสังคมมีหน้าที่รับผิดชอบโครงการประกันสังคมที่ครอบคลุมซึ่งรวมถึง การประสบอันตราย หรือเจ็บป่วยทุพพลภาพ และตาย ทั้งนี้เนื่องและไม่เนื่องจากการทำงาน รวมไปถึงการคลอดบุตรสงเคราะห์บุตร ชราภาพ และการว่างงาน',
                            ),
                          ),
                          SizedBox(height: 16),
                          Container(
                            width: MediaQuery.of(context).size.width - 30,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'ช่องทางการติดต่อ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Kanit',
                                          fontSize: 15,
                                          decoration: TextDecoration.none,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE8F0F6),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        alignment: Alignment.centerRight,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'ติดต่อสาขา',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Kanit',
                                              fontSize: 12,
                                              decoration: TextDecoration.none,
                                              color: Color(0xFF005C9E),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  rowData2(
                                    iconMain:
                                        'assets/logo/icons/icon_phone_b.png',
                                    title: 'เบอร์ติดต่อ',
                                    subTitle:
                                        snapshot.data != null
                                            ? snapshot.data['telephone'] ?? ''
                                            : '',
                                    iconimg: 'assets/images/chat.png',
                                    iconSub: Icons.phone_outlined,
                                    onTap1: () {},
                                    onTap2: () {},
                                  ),
                                  SizedBox(height: 10),
                                  rowData2(
                                    iconMain:
                                        'assets/logo/icons/icon_facebook.png',
                                    title: 'Website',
                                    subTitle: 'https://www.sso.go.th',
                                    iconimg: 'assets/images/chat.png',
                                    onTap1: () {},
                                    onTap2: () {},
                                  ),
                                  SizedBox(height: 10),
                                  rowData2(
                                    iconMain: 'assets/logo/icons/icon_mail.png',
                                    title: 'Email',
                                    subTitle: 'info@sso1506.com',
                                    iconimg: 'assets/images/chat.png',
                                    onTap1: () {},
                                    onTap2: () {},
                                  ),
                                  SizedBox(height: 10),
                                  rowData2(
                                    iconMain: 'assets/logo/icons/icon_line.png',
                                    title: 'Line',
                                    subTitle: '@ssothai',
                                    iconimg: 'assets/images/chat.png',
                                    onTap1: () {},
                                    onTap2: () {},
                                  ),

                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        }
      },
    );
  }

  googleMap(double lat, double lng) {
    return GoogleMap(
      myLocationEnabled: true,
      compassEnabled: true,
      tiltGesturesEnabled: false,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: LatLng(lat, lng), zoom: 16),
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: <Marker>{
        Marker(
          markerId: MarkerId('1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      },
    );
  }

  Widget rowData({Icon? icon, String title = ''}) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          children: [
            Container(child: icon),
            Expanded(
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                      fontSize: 12,
                      decoration: TextDecoration.none,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowData2({
    required String iconMain,
    required String title,
    required String subTitle,
    required String iconimg,
    IconData? iconSub,
    Function? onTap1,
    Function? onTap2,
  }) {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,

          // decoration: BoxDecoration(
          //   color: Color(0xFFE8F0F6),
          //   borderRadius: BorderRadius.circular(15),
          // ),
          child: Image.asset(iconMain, fit: BoxFit.contain),
        ),

        SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                  fontSize: 13,
                  decoration: TextDecoration.none,
                  color: Color(0xFF707070),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                  fontSize: 15,
                  decoration: TextDecoration.none,
                  color: Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: onTap1 as void Function()? ?? () {},
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: Image.asset(iconimg, fit: BoxFit.contain),
              ),
            ),
          ),
        ),

        SizedBox(width: 16),

        if (iconSub != null)
          GestureDetector(
            onTap: onTap2 as void Function()? ?? () {},
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Icon(iconSub, color: Colors.black, size: 30.0),
              ),
            ),
          ),
      ],
    );
  }
}
