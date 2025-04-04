import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/key_search.dart';
import 'package:sso/component/sub_header.dart';
import 'package:sso/pages/privilege/list_content_horizontal_privilege.dart';
import 'package:sso/pages/privilege/list_content_horizontal_privlege_suggested.dart';
import 'package:sso/pages/privilege/privilege_form.dart';
import 'package:sso/pages/privilege/privilege_list.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:http/http.dart' as http;

class PrivilegeMain extends StatefulWidget {
  PrivilegeMain({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _PrivilegeMain createState() => _PrivilegeMain();
}

class _PrivilegeMain extends State<PrivilegeMain> {
  // final ScrollController _controller = ScrollController();
  bool hideSearch = true;
  late Future<dynamic> _futurePrivilege;
  // Future<dynamic> _futurePrivilegeCategory;
  List<dynamic> listData = [];
  List<dynamic> category = [];

  @override
  void initState() {
    _futurePrivilege = postDio(privilegeReadApi, {
      'skip': 0,
      'limit': 10,
      'isHighlight': true,
    });
    // _futurePrivilegeCategory =
    //     post('${privilegeCategoryApi}read', {'skip': 0, 'limit': 100});
    categoryRead();
    super.initState();
  }

  Future<dynamic> categoryRead() async {
    var body = json.encode({
      "permission": "all",
      "skip": 0,
      "limit": 999, // integer value type
    });
    var response = await http.post(
      Uri.parse(privilegeCategoryApi + 'read'),
      body: body,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
    );

    var data = json.decode(response.body);
    setState(() {
      category = data['objectData'];
    });

    if (category.length > 0) {
      for (int i = 0; i <= category.length - 1; i++) {
        var res = post(privilegeReadApi, {
          'skip': 0,
          'limit': 100,
          'category': category[i]['code'],
        });
        listData.add(res);
      }
    }
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, goBack),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overScroll) {
          overScroll.disallowIndicator();
          return false;
        },
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: ListView(
            // controller: _controller,
            children: [
              SubHeader(th: 'สิทธิประโยชน์', en: 'Privilege'),
              SizedBox(height: 5.0),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrivilegeList(
                            keySearch: val,
                            title: 'สิทธิประโยชน์',
                            category: '',
                            isHighlight: null,
                          ),
                    ),
                  );
                },
              ),
              SizedBox(height: 10.0),
              ListContentHorizontalPrivilegeSuggested(
                title: 'แนะนำ',
                url: privilegeReadApi,
                model: _futurePrivilege,
                urlComment: '',
                navigationList: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrivilegeList(
                            title: 'แนะนำ',
                            isHighlight: true,
                            keySearch: '',
                            category: '',
                          ),
                    ),
                  );
                },
                navigationForm: (String code, dynamic model) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => PrivilegeForm(code: code, model: model),
                    ),
                  );
                },
              ),
              for (int i = 0; i < listData.length; i++)
                new ListContentHorizontalPrivilege(
                  code: category[i]['code'],
                  title: category[i]['title'],
                  model: listData[i],
                  navigationList: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PrivilegeList(
                              title: category[i]['title'],
                              category: category[i]['code'],
                              keySearch: '',
                            ),
                      ),
                    );
                  },
                  navigationForm: (String code, dynamic model) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                PrivilegeForm(code: code, model: model),
                      ),
                    );
                  },
                ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
