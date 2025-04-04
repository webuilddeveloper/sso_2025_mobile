import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactListVertical extends StatefulWidget {
  const ContactListVertical({
    super.key,
    required this.site,
    required this.model,
    required this.title,
    required this.url,
  });

  final String site;
  final Future<dynamic> model;
  final String title;
  final String url;

  @override
  // ignore: library_private_types_in_public_api
  _ContactListVertical createState() => _ContactListVertical();
}

class _ContactListVertical extends State<ContactListVertical> {
  @override
  void initState() {
    super.initState();
  }

  final List<String> items =
      List<String>.generate(10, (index) => "Item: ${++index}");

  _makePhoneCall(String url) async {
    // ignore: prefer_interpolation_to_compose_strings
    url = 'tel:' + url;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
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
            return Container(
              // color: Colors.transparent,
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        margin: EdgeInsets.only(bottom: 5.0),
                        // width: 600,
                        child: Column(
                          children: [
                            Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Color(0xFFE8F0F6),
                              ),
                              padding: EdgeInsets.all(10.0),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                '${snapshot.data[index]['imageUrl']}'),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        // color: Color(0xFF005C9E),
                                        alignment: Alignment.centerLeft,
                                        width: 55.0,
                                        height: 55.0,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            padding: EdgeInsets.only(left: 5.0),
                                            // color: Colors.red,
                                            child: Text(
                                              '${snapshot.data[index]['phone']}',
                                              style: TextStyle(
                                                // fontWeight: FontWeight.normal,
                                                fontSize: 17,
                                                fontFamily: 'Kanit',
                                                color: Color.fromRGBO(
                                                    0, 92, 158, 1),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.58,
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              // color: Colors.red,
                                              child: Text(
                                                '${snapshot.data[index]['title']}',
                                                style: TextStyle(
                                                  // fontWeight: FontWeight.normal,
                                                  fontSize: 12.0,
                                                  fontFamily: 'Kanit',
                                                  color: Color.fromRGBO(
                                                      0, 0, 0, 0.6),
                                                ),
                                                // overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _makePhoneCall(
                                          snapshot.data[index]['phone']);
                                    },
                                    child: Container(
                                      width: 50.00,
                                      height: 50.00,
                                      // color: Color(0xFFA12624),
                                      padding: EdgeInsets.all(10.00),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(27),
                                        color: Color(0xFFA12624),
                                      ),
                                      child: Image.asset(
                                          'assets/images/phone.png'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
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
