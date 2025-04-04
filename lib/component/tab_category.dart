import 'package:flutter/material.dart';
// import 'package:flutter_html/style.dart';

class CategorySelector extends StatefulWidget {
  CategorySelector({
    Key? key,
    required this.site,
    required this.model,
    required this.onChange,
  }) : super(key: key);

  //  final VoidCallback onTabCategory;
  final String site;
  final Function(String) onChange;
  final Future<dynamic> model;

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;

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
          return Container(
            height: 60.0,
            margin: EdgeInsets.only(left: 5.0),
            decoration: new BoxDecoration(color: Colors.white),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    widget.onChange(snapshot.data[index]['code']);
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 10.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            index == selectedIndex
                                ? Color(0xFF005C9E)
                                : Color(0xFFE8F0F6),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          snapshot.data[index]['title'],
                          style: TextStyle(
                            color:
                                index == selectedIndex
                                    ? Colors.white
                                    : Color(0xFF005C9E),
                            fontSize: 15.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 1.2,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return Container(
            height: 45.0,
            padding: EdgeInsets.only(left: 5.0, right: 5.0),
            margin: EdgeInsets.symmetric(horizontal: 30.0),
            decoration: new BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: new BorderRadius.circular(6.0),
              color: Colors.white,
            ),
          );
        }
      },
    );
  }
}
