import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CarouselRotation extends StatefulWidget {
  CarouselRotation({Key? key, this.model, this.nav}) : super(key: key);

  final Future<dynamic>? model;
  final Function(String, String, dynamic, String)? nav;

  @override
  _CarouselRotation createState() => _CarouselRotation();
}

class _CarouselRotation extends State<CarouselRotation> {
  final txtDescription = TextEditingController();
  int _current = 0;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  final List<String> imgList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.model, // function where you call your api
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        // AsyncSnapshot<Your object type>
        if (snapshot.hasData) {
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 120,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items:
                    snapshot.data.map<Widget>((document) {
                      return new InkWell(
                        onTap: () {
                          widget.nav!(
                            snapshot.data[_current]['linkUrl'],
                            snapshot.data[_current]['action'],
                            snapshot.data[_current],
                            snapshot.data[_current]['code'],
                          );
                        },
                        child: Container(
                          child: Center(
                            child: Image.network(
                              document['imageUrl'],
                              fit: BoxFit.fitWidth,
                              height: 120,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: snapshot.data.map<Widget>(
              //     (url) {
              //       int index = snapshot.data.indexOf(url);
              //       return Container(
              //         width: _current == index ? 20.0 : 5.0,
              //         height: 5.0,
              //         margin: EdgeInsets.only(
              //             top: 100.0, left: 2.0, right: 2.0, bottom: 5.0),
              //         decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(5),
              //           color: _current == index
              //               ? Color(0xFF3880B3)
              //               : Colors.white,
              //         ),
              //       );
              //     },
              //   ).toList(),
              // ),
            ],
          );
        } else {
          return Stack(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 120,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                items:
                    imgList
                        .map(
                          (item) => Center(
                            child: Image.network(
                              item,
                              fit: BoxFit.cover,
                              width: 1920,
                            ),
                          ),
                        )
                        .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    imgList.map<Widget>((url) {
                      int index = imgList.indexOf(url);
                      return Container(
                        width: _current == index ? 20.0 : 5.0,
                        height: 5.0,
                        margin: EdgeInsets.only(
                          top: 100.0,
                          left: 2.0,
                          right: 2.0,
                          bottom: 5.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color:
                              _current == index
                                  ? Color(0xFF3880B3)
                                  : Colors.white,
                        ),
                      );
                    }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
