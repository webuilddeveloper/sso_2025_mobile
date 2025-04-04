import 'package:flutter/material.dart';
import 'package:sso/component/header.dart';
import 'package:sso/pages/knowledge/knowledge_list_vertical.dart' as grid;
import 'package:sso/component/key_search.dart';
import 'package:sso/component/tab_category.dart';
import 'package:sso/shared/api_provider.dart' as service;
import 'package:sso/component/sub_header.dart';

class KnowledgeList extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  KnowledgeList({super.key, required this.title});
  final String title;
  @override
  // ignore: library_private_types_in_public_api
  _KnowledgeList createState() => _KnowledgeList();
}

class _KnowledgeList extends State<KnowledgeList> {
  late grid.KnowledgeListVertical gridView;
  final txtDescription = TextEditingController();
  bool hideSearch = true;
  late String keySearch;
  late String category;

  // Future<dynamic> _futureKnowledge;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    txtDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    gridView = grid.KnowledgeListVertical(
      site: 'CIO',
      model: service.post('${service.knowledgeApi}read', {
        'skip': 0,
        'limit': 10,
      }),
    );
  }

  void goBack() async {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, goBack),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          children: [
            SubHeader(th: 'คลังความรู้', en: 'Knowledge'),
            SizedBox(height: 5),
            CategorySelector(
              model: service.postCategory(
                '${service.knowledgeCategoryApi}read',
                {'skip': 0, 'limit': 100},
              ),
              onChange: (String val) {
                setState(() {
                  category = val;
                  gridView = grid.KnowledgeListVertical(
                    site: 'CIO',
                    model: service.post('${service.knowledgeApi}read', {
                      'skip': 0,
                      'limit': 10,
                      'category': category,
                    }),
                  );
                });
              },
              site: '',
            ),
            SizedBox(height: 5.0),
            KeySearch(
              show: hideSearch,
              onKeySearchChange: (String val) {
                setState(() {
                  keySearch = val;
                  gridView = grid.KnowledgeListVertical(
                    site: 'CIO',
                    model: service.post('${service.knowledgeApi}read', {
                      'skip': 0,
                      'limit': 10,
                      'keySearch': keySearch,
                      'category': category,
                    }),
                  );
                });
              },
            ),
            SizedBox(height: 10.0),
            gridView,
            // Expanded(
            //   flex: 1,
            //   child: gridView,
            // ),
          ],
        ),
      ),
    );
  }
}
