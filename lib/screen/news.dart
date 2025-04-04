import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/component/loading_tween.dart';
import 'package:sso/screen/event_calendar.dart';
import 'package:sso/screen/news_form.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  late Future<dynamic> _future;
  late Future<dynamic> _futureHighLight;
  int _limit = 20;

  @override
  void initState() {
    _callRead();
    super.initState();
  }

  _callRead() {
    _future = postDio('${server}m/news/read', {'limit': _limit});
    _futureHighLight =
        postDio('${server}m/news/read', {'limit': _limit, 'isHighlight': true});
  }

  void _onRefresh() async {
    setState(() {
      _limit = 20;
    });
    _callRead();

    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    setState(() {
      _limit += 10;
      _future = postDio('${server}m/news/read', {'limit': _limit});
    });
    await Future.delayed(Duration(milliseconds: 1000));

    _refreshController.loadComplete();
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
                  child: Row(
                    children: [
                      Icon(Icons.arrow_back_ios),
                      Text(
                        'ข่าวประกาศ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.start,
                      )
                    ],
                  ),
                ),
                InkWell(
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventCalendarPage(),
                      ),
                    )
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFE8F0F6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 15,
                          color: Color(0xFF005C9E),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'ปฏิทิน',
                          style: TextStyle(
                            color: Color(0xFF005C9E),
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          // _buildHighlight(),
          FutureBuilder<dynamic>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _buildList(snapshot.data);
              } else if (snapshot.hasError) {
                return Container();
              } else {
                return Expanded(
                  child: ListView.separated(
                    itemCount: 20,
                    separatorBuilder: (_, __) => SizedBox(height: 10),
                    itemBuilder: (_, __) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: LoadingTween(width: double.infinity, height: 50),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  _buildList(model) {
    return Expanded(
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropHeader(
          complete: Container(
            child: Text(''),
          ),
          completeDuration: Duration(milliseconds: 0),
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              height: 155,
              child: Row(
                children: [
                  Expanded(child: _buildCardHighLight(model[0])),
                  if (model.length > 1) SizedBox(width: 15),
                  if (model.length > 1)
                    Expanded(child: _buildCardHighLight(model[1])),
                ],
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 15),
              physics: ClampingScrollPhysics(),
              itemBuilder: (_, __) {
                if (__ > 1) {
                  return _buildCard(model[__]);
                } else {
                  return SizedBox();
                }
              },
              separatorBuilder: (_, __) => SizedBox(height: 10),
              itemCount: model.length,
            )
          ],
        ),
      ),
    );
  }

  _buildHighlight() {
    return FutureBuilder<dynamic>(
      future: _futureHighLight,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: 155,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 15),
              scrollDirection: Axis.horizontal,
              physics: ClampingScrollPhysics(),
              itemBuilder: (_, __) => _buildCardHighLight(snapshot.data[__]),
              separatorBuilder: (_, __) => SizedBox(width: 15),
              itemCount: snapshot.data.length,
            ),
          );
        } else if (snapshot.hasError) {
          return Container();
        } else {
          return Container();
        }
      },
    );
  }

  _buildCard(model) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsFormPage(
            model: model,
          ),
        ),
      ),
      child: Container(
        height: 45,
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: loadingImageNetwork(
                model['imageUrl'],
                width: 80,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                model['title'],
                style: TextStyle(
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildCardHighLight(model) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NewsFormPage(
            model: model,
          ),
        ),
      ),
      child: Container(
        height: 155,
        width: 165,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: loadingImageNetwork(
                model['imageUrl'],
                width: double.infinity,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: Text(
                model['title'],
                style: TextStyle(
                  fontSize: 13,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              dateStringFormat(model['createDate']),
              style: TextStyle(
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
