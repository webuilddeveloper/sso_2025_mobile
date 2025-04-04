// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/component/key_search.dart';
import 'package:sso/component/sub_header.dart';
import 'package:sso/pages/privilege/privilege_list_vertical.dart';
import 'package:sso/shared/api_provider.dart';

class PrivilegeList extends StatefulWidget {
  const PrivilegeList({
    super.key,
    required this.keySearch,
    required this.category,
    this.isHighlight,
    required this.title,
  });

  final String title;
  final String keySearch;
  final String category;
  final bool? isHighlight;

  @override
  _PrivilegeList createState() => _PrivilegeList();
}

class _PrivilegeList extends State<PrivilegeList> {
  late PrivilegeListVertical gridView;
  bool hideSearch = true;

  @override
  void initState() {
    // ignore: unnecessary_new
    gridView = new PrivilegeListVertical(
      site: 'CIO',
      model: postDio(privilegeReadApi, {
        'skip': 0,
        'limit': 10,
        'keySearch': widget.keySearch,
        'isHighlight': widget.isHighlight,
        'category': widget.category,
      }),
    );
    super.initState();
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
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: ListView(
            // controller: _controller,
            children: [
              SubHeader(th: widget.title, en: ''),
              SizedBox(height: 5.0),
              KeySearch(
                show: hideSearch,
                onKeySearchChange: (String val) {
                  setState(
                    () {
                      gridView = PrivilegeListVertical(
                        site: 'CIO',
                        model: postDio(privilegeReadApi, {
                          'skip': 0,
                          'limit': 10,
                          'keySearch': val,
                          'isHighlight': widget.isHighlight ?? false,
                          'category': widget.category,
                        }),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 10.0),
              gridView,
            ],
          ),
        ),
      ),
    );
  }
}
