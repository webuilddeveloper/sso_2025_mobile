// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sso/models/user.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  Profile({
    super.key,
    required this.model,
    this.userData,
    this.organizationImage,
    this.nav,
    this.nav1,
    this.imageLv0,
    this.checkOrganization = false,
  });

  Future<dynamic> model;

  final User? userData;
  final Future<dynamic>? organizationImage;
  final Function? nav;
  final Function? nav1;
  final List? imageLv0;
  final bool? checkOrganization;
  final storage = FlutterSecureStorage();

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  String province = "กรุงเทพมหานคร";
  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );

    // final coordinates = new Coordinates(position.latitude, position.longitude);

    // var address = await Geocoder.google(
    //   'AIzaSyD-pkE26l2sWEU_CrbDz6b2myMe5Ab7jJo',
    //   language: 'th',
    // ).findAddressesFromCoordinates(coordinates);
    // setState(() {
    //   province = address.first.adminArea;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>

        // data from refresh api
        if (snapshot.hasData) {
          if (snapshot.data['countUnit'] != '') {
            // return cardUnActivate(snapshot.data, widget.userData!, true);
            return cardActivate(snapshot.data, widget.userData!, true);
          } else {
            return cardActivate(snapshot.data, widget.userData!, true);
          }
        }
        // data from storage
        else {
          if (widget.userData!.countUnit != '') {
            return cardActivate(snapshot.data, widget.userData!, false);
          } else {
            return cardUnActivate(snapshot.data, widget.userData!, false);
          }
        }
      },
    );
  }

  Widget cardActivate(dynamic model, User userData, bool dataFormSnapShot) {
    if (dataFormSnapShot) {
      var countUnit = model['countUnit'];
      return Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber,
          // border: Border.all(color: Colors.black.withAlpha(150)),
          gradient: LinearGradient(
            colors: [Color(0xFF3880B3), Color(0xFF005C9E), Color(0xFF0191B4)],
          ),
        ),
        // height: 115,
        // height: 115,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    // margin: EdgeInsets.only(left: 10),
                    height: 80,
                    width: 80,
                    child: GestureDetector(
                      // onTap: () =>
                      // {
                      //   Toast.show("Toast plugin app", context,
                      //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM)
                      // },
                      child: CircleAvatar(
                        // radius: 60,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(model['imageUrl']),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            '${model['firstName']} ${model['lastName']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            'โรงพยาบาล พญาไท นวมินทร์',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Kanit',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                province,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF005C9E),
                    Color(0xFF3880B3),
                    Color(0xFFFFC326),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment(1.3, 0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '''มาตรา''',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  Text(
                    '''33''',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      var countUnit = userData.countUnit;
      return Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber,
          gradient: LinearGradient(
            colors: [Color(0xFF3880B3), Color(0xFF005C9E), Color(0xFF0191B4)],
          ),
        ),
        // height: 115,
        // height: 115,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: GestureDetector(
                      // onTap: () =>
                      // {
                      //   Toast.show("Toast plugin app", context,
                      //       duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM)
                      // },
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(userData.imageUrl),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            '${userData.firstName} ${userData.lastName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            province,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Kanit',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                province,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF005C9E),
                    Color(0xFF3880B3),
                    Color(0xFFFFC326),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment(1.3, 0),
                ),
              ),
              child: Text(
                countUnit,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget cardUnActivate(dynamic model, User userData, bool dataFormSnapShot) {
    if (dataFormSnapShot) {
      return Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber,
          // border: Border.all(color: Colors.black.withAlpha(150)),
          gradient: LinearGradient(
            colors: [Color(0xFF808588), Color(0xFF808588), Color(0xFF808588)],
          ),
        ),
        // height: 115,
        // height: 115,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    // margin: EdgeInsets.only(left: 10),
                    height: 80,
                    width: 80,
                    child: GestureDetector(
                      // onTap: () =>
                      // {
                      //   Toast.show("Toast plugin app", context,
                      //       duration: Toast.LENGTH_SHORT,
                      //       gravity: Toast.BOTTOM)
                      // },
                      child: CircleAvatar(
                        // radius: 60,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(model['imageUrl']),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            '${model['firstName']} ${model['lastName']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            'ยังไม่ได้เชื่อมต่อระบบผู้ประกันตน',
                            style: TextStyle(
                              color: Color(0xFFFFC324),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Kanit',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.location_on,
                                size: 15.0,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                province,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.only(left: 15),
              alignment: Alignment.center,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                // border: Border.all(color: Colors.black.withAlpha(150)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF575B5D),
                    Color(0xFF808588),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment(1.3, 0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'มาตรา',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  Text(
                    'N/A',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ],
              ),
              // child: CircleAvatar(
              //   // radius: 60,
              //   backgroundColor: Colors.black,
              //   backgroundImage: NetworkImage(snapshot.data['imageUrl']),
              // ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.amber,
          // border: Border.all(color: Colors.black.withAlpha(150)),
          gradient: LinearGradient(
            colors: [Color(0xFF808588), Color(0xFF808588), Color(0xFF808588)],
          ),
        ),
        // height: 115,
        // height: 115,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    // margin: EdgeInsets.only(left: 10),
                    height: 80,
                    width: 80,
                    child: GestureDetector(
                      // onTap: () =>
                      // {
                      //   Toast.show("Toast plugin app", context,
                      //       duration: Toast.LENGTH_SHORT,
                      //       gravity: Toast.BOTTOM)
                      // },
                      child: CircleAvatar(
                        // radius: 60,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(userData.imageUrl),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            '${userData.firstName} ${userData.lastName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kanit',
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 15.0, right: 1.0),
                          child: Text(
                            'ยังไม่ได้เชื่อมต่อระบบผู้ประกันตน',
                            style: TextStyle(
                              color: Color(0xFFFFC324),
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Kanit',
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Icon(
                                Icons.location_on,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 5.0),
                              child: Text(
                                province,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: 'Kanit',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              // padding: EdgeInsets.only(left: 15),
              alignment: Alignment.center,
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.all(Radius.circular(45.0)),
                // border: Border.all(color: Colors.black.withAlpha(150)),
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF575B5D),
                    Color(0xFF808588),
                    Color(0xFFFFFFFF),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment(1.3, 0),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'มาตรา',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Kanit',
                    ),
                  ),
                  Text(
                    'N/A',
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ],
              ),
              // child: CircleAvatar(
              //   // radius: 60,
              //   backgroundColor: Colors.black,
              //   backgroundImage: NetworkImage(snapshot.data['imageUrl']),
              // ),
            ),
          ],
        ),
      );
    }
  }
}

// Container(
//           alignment: Alignment.center,
//           decoration: BoxDecoration(
//             color: Colors.amber,
//             border: Border.all(color: Colors.black.withAlpha(150)),
//             gradient: LinearGradient(
//               colors: [Color(0xFF3880B3), Color(0xFF005C9E), Color(0xFF0191B4)],
//             ),
//           ),
//           height: 115,
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(15),
//                 child: Row(
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundColor: Colors.black,
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(left: 15),
//                       child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'ยุทธเลิศ  สรณะ',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                             Expanded(
//                               child: Container(
//                                 padding: EdgeInsets.only(top: 5),
//                                 child: Text(
//                                   'โรงพยาบาล พญาไท นวมินท์ โรงพยาบาล พญาไท นวมินท์โรงพยาบาล พญาไท นวมินท์',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               ),
//                             ),
//                             Text(
//                               'กรุงเทพฯ',
//                               style: TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold),
//                             ),
//                           ]),
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: EdgeInsets.all(15),
//                 child: CircleAvatar(
//                   radius: 30,
//                   backgroundColor: Colors.black,
//                   child: Container(
//                     padding: EdgeInsets.only(
//                       left: 5,
//                     ),
//                     alignment: Alignment.center,
//                     child: Text('N/A'),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
