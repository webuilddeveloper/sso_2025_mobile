import 'dart:async';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/sub_header.dart';

// ignore: must_be_immutable
class AboutUsForm extends StatefulWidget {
  AboutUsForm({Key? key, required this.model, required this.title})
    : super(key: key);

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
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else if (snapshot.hasData) {
            var lat = double.parse(
              snapshot.data['latitude'] != '' ? snapshot.data['latitude'] : 0.0,
            );
            var lng = double.parse(
              snapshot.data['longitude'] != ''
                  ? snapshot.data['longitude']
                  : 0.0,
            );
            return Scaffold(
              appBar: header(context, goBack),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowIndicator();
                  return false;
                },
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    // controller: _controller,
                    children: [
                      // Stack(
                      //   children: [
                      //     Container(
                      //       padding: const EdgeInsets.only(top: 50),
                      //       // color: Colors.orange,
                      //       child: Image.network(
                      //         snapshot.data['imageBgUrl'],
                      //         height: 350.0,
                      //         width: double.infinity,
                      //         fit: BoxFit.cover,
                      //         loadingBuilder: (
                      //           BuildContext context,
                      //           Widget child,
                      //           ImageChunkEvent? loadingProgress,
                      //         ) {
                      //           if (loadingProgress == null) return child;
                      //           return Center(
                      //             child: CircularProgressIndicator(
                      //               value:
                      //                   loadingProgress.expectedTotalBytes !=
                      //                           null
                      //                       ? loadingProgress
                      //                               .cumulativeBytesLoaded /
                      //                           loadingProgress
                      //                               .expectedTotalBytes!
                      //                       : null,
                      //             ),
                      //           );
                      //         },
                      //       ),
                      //     ),
                      //     SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                      //     Container(
                      //       alignment: Alignment.center,
                      //       margin: EdgeInsets.only(
                      //         top: 350.0,
                      //         left: 15.0,
                      //         right: 15.0,
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: Colors.white,
                      //         borderRadius: BorderRadius.circular(8),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.5),
                      //             spreadRadius: 0,
                      //             blurRadius: 7,
                      //             offset: Offset(
                      //               0,
                      //               3,
                      //             ), // changes position of shadow
                      //           ),
                      //         ],
                      //       ),
                      //       height: 100.0,
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         children: [
                      //           Container(
                      //             // color: Colors.orange,
                      //             padding: EdgeInsets.symmetric(vertical: 17.0),
                      //             child: Image.network(
                      //               snapshot.data['imageLogoUrl'],
                      //             ),
                      //           ),
                      //           Expanded(
                      //             child: Container(
                      //               padding: EdgeInsets.only(
                      //                 left: 10.0,
                      //                 right: 5.0,
                      //               ),
                      //               child: Text(
                      //                 snapshot.data['title'],
                      //                 style: TextStyle(
                      //                   fontSize: 18,
                      //                   fontFamily: 'Kanit',
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      Stack(
                        children: [
                          // 🔹 ภาพพื้นหลัง imageBgUrl
                          Container(
                            padding: const EdgeInsets.only(top: 50),
                            child: () {
                              final imageBgUrl = snapshot.data?['imageBgUrl'];
                              if (imageBgUrl != null &&
                                  imageBgUrl.toString().isNotEmpty) {
                                print('🟢 ใช้รูปจาก imageBgUrl: $imageBgUrl');
                                return Image.network(
                                  imageBgUrl,
                                  height: 350.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (
                                    BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                print(
                                  '🟡 ไม่มี imageBgUrl หรือค่าว่าง ใช้รูป default',
                                );
                                return Image.network(
                                  'https://via.placeholder.com/350',
                                  height: 350.0,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                );
                              }
                            }(),
                          ),

                          // 🔹 หัวข้อ SubHeader
                          SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),

                          // 🔹 กล่อง logo + title
                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                              top: 350.0,
                              left: 15.0,
                              right: 15.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 0,
                                  blurRadius: 7,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            height: 100.0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 🔹 โลโก้ imageLogoUrl
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 17.0),
                                  child: () {
                                    final imageLogoUrl =
                                        snapshot.data?['imageLogoUrl'];
                                    if (imageLogoUrl != null &&
                                        imageLogoUrl.toString().isNotEmpty) {
                                      print(
                                        '🟢 ใช้รูปจาก imageLogoUrl: $imageLogoUrl',
                                      );
                                      return Image.network(imageLogoUrl);
                                    } else {
                                      print(
                                        '🟡 ไม่มี imageLogoUrl หรือค่าว่าง ใช้รูป default',
                                      );
                                      return Image.network(
                                        'https://via.placeholder.com/100',
                                      );
                                    }
                                  }(),
                                ),

                                // 🔹 ข้อความ title
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 10.0,
                                      right: 5.0,
                                    ),
                                    child: () {
                                      final title = snapshot.data?['title'];
                                      if (title != null &&
                                          title.toString().isNotEmpty) {
                                        print('🟢 ใช้ title: $title');
                                        return Text(
                                          title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Kanit',
                                          ),
                                        );
                                      } else {
                                        print(
                                          '🟡 ไม่มี title หรือค่าว่าง ใช้ข้อความ default',
                                        );
                                        return Text(
                                          'ไม่มีข้อมูล',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontFamily: 'Kanit',
                                            color: Colors.red,
                                          ),
                                        );
                                      }
                                    }(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 20.0),
                      rowData(
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        title: snapshot.data['address'] ?? '',
                      ),
                      rowData(
                        icon: Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        title: snapshot.data['telephone'] ?? '',
                      ),
                      rowData(
                        icon: Icon(
                          Icons.email,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        title: snapshot.data['email'] ?? '',
                      ),
                      rowData(
                        icon: Icon(
                          Icons.language,
                          color: Colors.white,
                          size: 20.0,
                        ),
                        title: snapshot.data['site'] ?? '',
                      ),
                      SizedBox(height: 10.0),
                      // googleMap(lat, lng),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        width: double.infinity,
                        child: googleMap(lat, lng),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: header(context, goBack),
              body: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overScroll) {
                  overScroll.disallowIndicator();
                  return false;
                },
                child: ListView(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  // controller: _controller,
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 50),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          // color: Colors.orange,
                          child: Image.network(
                            '',
                            height: 350,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SubHeader(th: "เกี่ยวกับเรา", en: "About Us"),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: 350.0,
                            left: 15.0,
                            right: 15.0,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 7,
                                offset: Offset(
                                  0,
                                  3,
                                ), // changes position of shadow
                              ),
                            ],
                          ),
                          height: 100.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                // color: Colors.orange,
                                padding: EdgeInsets.symmetric(vertical: 17.0),
                                child: Image.asset("assets/logo/sso_only.png"),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 5.0,
                                  ),
                                  child: Text(
                                    'สำนักงานประกันสังคม',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Kanit',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    rowData(
                      icon: Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      title: '-',
                    ),
                    rowData(
                      icon: Icon(Icons.phone, color: Colors.white, size: 20.0),
                      title: '-',
                    ),
                    rowData(
                      icon: Icon(Icons.email, color: Colors.white, size: 20.0),
                      title: '-',
                    ),
                    rowData(
                      icon: Icon(
                        Icons.language,
                        color: Colors.white,
                        size: 20.0,
                      ),
                      title: '-',
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      height: 300,
                      width: double.infinity,
                      child: googleMap(13.8462512, 100.5234803),
                    ),
                  ],
                ),
              ),
            );
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
      markers:
          <Marker>[
            Marker(
              markerId: MarkerId('1'),
              position: LatLng(lat, lng),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          ].toSet(),
    );
  }

  Widget rowData({required Icon icon, String title = ''}) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.0),
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: Color(0xFF005C9E),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Container(child: icon),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                title,
                style: TextStyle(fontFamily: 'Kanit', fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
