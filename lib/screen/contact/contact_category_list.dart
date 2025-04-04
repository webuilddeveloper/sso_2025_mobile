// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sso/component/material/list_view_search.dart';
import 'package:sso/screen/contact/contact_list.dart';
import 'package:sso/shared/api_provider.dart';
import "package:collection/collection.dart";
import '../../component/header.dart';
import '../../component/material/input_with_label.dart';

class ContactCategoryListV2 extends StatefulWidget {
  const ContactCategoryListV2({
    Key? key,
    required this.username,
  }) : super(key: key);
  final String username;
  @override
  _ContactCategoryListV2State createState() => _ContactCategoryListV2State();
}

class _ContactCategoryListV2State extends State<ContactCategoryListV2> {
  late Future<dynamic> futureModel;
  late Future<dynamic> _futureCategoryContact;
  late Future<dynamic> futureModelSearch;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() {
    _futureCategoryContact = postDio('${contactCategoryApi}read', {});
    futureModelSearch = postDio('${server}m/contact/search/read', {});
  }

  _callReadSearch(param) async {
    var text = await post(
        '${contactApi}read', {'skip': 0, 'limit': 50, 'keySearch': param});
  }

  void _onRefresh() async {
    _callRead();

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  // ignore: unused_element
  void _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerV3(context, goBack, title: "เบอร์ติดต่อ"),
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
                color: Colors.white,
                height: 170,
                width: double.infinity,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      alignment: Alignment.centerLeft,
                      width: double.infinity,
                      height: 150,
                      color: Color(0xFF64C5D7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'สวัสดีครับ ${widget.username}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                          Text(
                            'ต้องการความช่วยเหลือหรือสงสัยเรื่องใดครับ',
                            style: TextStyle(
                              fontSize: 15,
                              // fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 126,
                      right: 0,
                      left: 0,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        // width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        child: Container(
                          height: 35,
                          margin: EdgeInsets.only(top: 7),
                          // child: KeySearch(),
                          child: Container(
                            // height: 30,
                            padding: EdgeInsets.only(left: 10),
                            child: TextFormField(
                              onChanged: (text) => _callReadSearch(text),
                              decoration: DecorationRegister.searchHospital(
                                context,
                                hintText: 'ค้นหา',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // SizedBox(height: 30),
              Container(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                padding:
                    EdgeInsets.only(right: 15, left: 15, top: 15, bottom: 5),
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
              _buildCategory(),
            ],
          ),
        ),
      ),
    );
  }

  _buildCategory() {
    return FutureBuilder<dynamic>(
      future: _futureCategoryContact,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          // ignore: deprecated_member_use
          if (snapshot.data.length > 0) {
            var dataList = snapshot.data as List<dynamic>;
            var newMap = groupBy(dataList, (obj) => (obj as Map<String, dynamic>)['subCategory'])
                .map((k, v) => MapEntry(
                    k,
                    v
                        .map((item) => {
                              'code': (item as Map<String, dynamic>)['code'],
                              'title': (item)['title'],
                            })
                        .toList()));
            var children = <Widget>[];
            for (var k in newMap.keys) {
              var column = <Widget>[];
              children.add(
                Text(
                  k ?? "",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
              children.add(
                SizedBox(height: 5),
              );
              for (var i2 = 0; i2 < newMap[k]!.length; i2++) {
                column.add(
                  _buildItem(
                    newMap[k]![i2]['title'],
                    onTap: () {
                      // print('go to new page ${snapshot.data[index]['code']}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContactListV2(
                            title: newMap[k]![i2]['title'],
                            code: newMap[k]![i2]['code'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
              children.add(
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: column,
                  ),
                ),
              );
              children.add(
                SizedBox(height: 15),
              );
            }
            return Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                physics: BouncingScrollPhysics(),
                children: children,
              ),
            );
          } else
            return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildItem(String title, {Function? onTap}) {
    return InkWell(
      onTap: () => onTap!(),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 30,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Container(
                      height: 1,
                      color: Colors.grey.withOpacity(0.4),
                    )
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}
