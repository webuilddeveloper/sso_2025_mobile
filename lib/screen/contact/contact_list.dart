import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/material/list_view_search.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/pages/contact/contact_list_vertical.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../component/material/input_with_label.dart';

class ContactListV2 extends StatefulWidget {
  const ContactListV2({
    Key? key,
    required this.title,
    required this.code,
    // this.subCategory,
  }) : super(key: key);

  final String title;
  final String code;
  // final String subCategory;

  @override
  _ContactListV2 createState() => _ContactListV2();
}

class _ContactListV2 extends State<ContactListV2> {
  late ContactListVertical contact;
  bool hideSearch = true;
  final txtDescription = TextEditingController();
  late String keySearch;
  late String category;

  late Future<dynamic> futureModelSearch;
  late Future<dynamic> _futureContact;

  // final ScrollController _controller = ScrollController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // _controller.addListener(_scrollListener);

    _futureContact = postDio('${contactApi}read', {'category': widget.code});
    futureModelSearch = postDio('${server}m/contact/search/read', {});

    super.initState();
  }

  _makePhoneCall(String url) async {
    // final Uri launchUri = Uri(
    //   scheme: 'tel',
    //   path: url,
    // );
    await launch("tel://$url");
    // url = 'tel:' + url;
    // if (await canLaunch(url)) {
    //   await launch(url);
    // } else {
    //   throw 'Could not launch $url';
    // }
  }

  void launchURLMap(String lat, String lng) async {
    String homeLat = lat;
    String homeLng = lng;

    final String googleMapslocationUrl =
        "https://www.google.com/maps/search/?api=1&query=" +
            homeLat +
            ',' +
            homeLng;

    final String encodedURl = Uri.encodeFull(googleMapslocationUrl);

    launchUrl(Uri.parse(encodedURl), mode: LaunchMode.externalApplication);

    // if (await canLaunch(encodedURl)) {
    //   await launch(encodedURl);
    // } else {
    //   throw 'Could not launch $encodedURl';
    // }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerV3(context, goBack, title: widget.title),
      // backgroundColor: Colors.white,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                color: Colors.white,
                padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: Container(
                  height: 35,
                  margin: EdgeInsets.only(top: 7),
                  // child: KeySearch(),
                  child: Container(
                    child: TextFormField(
                      decoration: DecorationRegister.searchHospital(context,
                          hintText: 'ค้นหา', color: Colors.white),
                    ),
                  ),
                ),
              ),
              // SizedBox(height: 30),
              Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                child: Text(
                  'คำค้นยอดฮิต',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: listViewSearch(futureModelSearch),
              ),
              SizedBox(height: 15),
              _buildData(),
            ],
          ),
        ),
      ),
    );
  }

  _buildData() {
    return FutureBuilder<dynamic>(
      future: _futureContact, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length == 0) {
            return Container(
              alignment: Alignment.center,
              height: 200,
              child: Text(
                'ไม่พบข้อมูล',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'Kanit',
                  color: Color.fromRGBO(0, 0, 0, 0.6),
                ),
              ),
            );
          } else {
            return Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                child: ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 70,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.circular(5.0),
                        color: Color(0xFFFFFFFF),
                      ),
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsets.only(bottom: 8),
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // Container(
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(5),
                                //     image: DecorationImage(
                                //       image: NetworkImage(
                                //           '${snapshot.data[index]['imageUrl']}'),
                                //       fit: BoxFit.cover,
                                //     ),
                                //   ),
                                //   // color: Color(0xFF005C9E),
                                //   alignment: Alignment.centerLeft,
                                //   width: 55.0,
                                //   height: 55.0,
                                // ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.58,
                                        padding: EdgeInsets.only(left: 10.0),
                                        // color: Colors.red,
                                        child: Text(
                                          '${snapshot.data[index]['title']}',
                                          style: TextStyle(
                                            // fontWeight: FontWeight.normal,
                                            fontSize: 15.0,
                                            fontFamily: 'Kanit',
                                            color: Color(0XFF707070),
                                          ),
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      padding: EdgeInsets.only(left: 5.0),
                                      // color: Colors.red,
                                      child: Text(
                                        '${snapshot.data[index]['phone']}',
                                        style: TextStyle(
                                          // fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Kanit',
                                          color: Color(0XFF000000),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          snapshot.data[index]['latitude'] != '' &&
                                  snapshot.data[index]['latitude'] != null &&
                                  snapshot.data[index]['longitude'] != '' &&
                                  snapshot.data[index]['longitude'] != null
                              ? InkWell(
                                  onTap: () {
                                    var lat = snapshot.data[index]
                                                ['latitude'] !=
                                            ''
                                        ? '${snapshot.data[index]['latitude']}'
                                        : '0.0';
                                    var lng = snapshot.data[index]
                                                ['longitude'] !=
                                            ''
                                        ? '${snapshot.data[index]['longitude']}'
                                        : '0.0';
                                    launchURLMap(
                                        lat.toString(), lng.toString());
                                  },
                                  child: Image.asset(
                                    'assets/images/map_contact.png',
                                  ),
                                )
                              : Container(),
                          // SizedBox(width: 15),
                          InkWell(
                            onTap: () {
                              _makePhoneCall(snapshot.data[index]['phone']);
                            },
                            child: Image.asset(
                              'assets/images/phone_2.png',
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }
        } else {
          return Container();
        }
      },
    );
  }
}
