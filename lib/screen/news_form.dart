import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sso/component/gallery_view.dart';
import 'package:sso/component/link_url_in.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';
import 'package:sso/shared/scroll_behavior.dart';

class NewsFormPage extends StatefulWidget {
  const NewsFormPage({Key? key, this.model}) : super(key: key);

  final dynamic model;

  @override
  State<NewsFormPage> createState() => _NewsFormPageState();
}

class _NewsFormPageState extends State<NewsFormPage> {
  late Future<dynamic> _future;
  late Future<dynamic> _futureGallery;
  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() {
    _future = postDio('${server}m/news/read', {'code': widget.model['code']});
    _futureGallery =
        postDio('${server}m/news/gallery/read', {'code': widget.model['code']});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        flexibleSpace: Container(
          color: Colors.transparent,
          child: Container(
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).padding.top + 10),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios),
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return _buildContent(snapshot.data[0]);
          } else {
            return _buildContent(widget.model);
          }
        },
      ),
    );
  }

  _buildContent(model) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 15),
      children: [
        Text(
          model['title'],
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        Text(
          dateStringFormat(model['createDate']),
          style: TextStyle(
            fontSize: 15,
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => showCupertinoDialog(
            context: context,
            builder: (context) => ImageViewer(
              initialIndex: 0,
              imageProviders: [
                NetworkImage(
                  model['imageUrl'],
                ),
              ],
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: loadingImageNetwork(
              model['imageUrl'],
              height: 165,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/share_link.png',
              height: 35,
              width: 35,
            ),
            SizedBox(width: 10),
            Image.asset(
              'assets/images/share_facebook.png',
              height: 35,
              width: 35,
            ),
            SizedBox(width: 10),
            Image.asset(
              'assets/images/share_line.png',
              height: 35,
              width: 35,
            ),
            SizedBox(width: 10),
            Image.asset(
              'assets/images/copy_clipboard.png',
              height: 35,
              width: 35,
            ),
          ],
        ),
        SizedBox(height: 20),
        // Html(
        //   data: model['description'].toString(),
        //   onLinkTap: (String url, RenderContext context,
        //       Map<String, String> attributes, element) {
        //     launchInWebViewWithJavaScript(url);
        //     //open URL in webview, or launch URL in browser, or any other logic here
        //   },
        // ),
        SizedBox(height: 10),
        _buildGallery(),
        SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  _buildGallery() {
    return FutureBuilder<dynamic>(
      future: _futureGallery,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'รูปประกอบ',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 100,
                  child: ScrollConfiguration(
                    behavior: CsBehavior(),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 15),
                      itemBuilder: (context, index) => ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () => showCupertinoDialog(
                            context: context,
                            builder: (context) => ImageViewer(
                              initialIndex: index,
                              imageProviders: snapshot.data
                                  .map<ImageProvider<Object>>(
                                      (e) => NetworkImage(e['imageUrl']))
                                  .toList(),
                            ),
                          ),
                          child: loadingImageNetwork(
                            snapshot.data[index]['imageUrl'],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Container();
          }
        } else {
          return Container();
        }
      },
    );
  }
}
