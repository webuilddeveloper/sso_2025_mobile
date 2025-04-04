import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:sso/screen/hospital.dart';

buttonModel(BuildContext context, Future<dynamic> model, String title) {
  return showCupertinoModalBottomSheet(
    context: context,
    barrierColor: Colors.black.withOpacity(0.4),
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Material(
        type: MaterialType.transparency,
        // ignore: unnecessary_new
        child: new Container(
          height: MediaQuery.of(context).size.height * 0.58,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(15, 50, 15, 15),
                child: FutureBuilder<dynamic>(
                  future: model, // function where you call your api
                  builder: (
                    BuildContext context,
                    AsyncSnapshot<dynamic> snapshot,
                  ) {
                    if (snapshot.hasData) {
                      if (snapshot.data.length > 0) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return _buildRowMenuModal(
                              context,
                              snapshot.data[index],
                            );
                          },
                        );
                      } else {
                        return Container();
                      }
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Positioned(
                top: 15,
                left: 0,
                right: 0,
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Kanit',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102F30),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 15,
                right: 15,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 35,
                    width: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFF28A34),
                    ),
                    child: Icon(Icons.clear, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

_buildRowMenuModal(BuildContext context, dynamic model) {
  const imageUrl = 'assets/icon.png';
  return InkWell(
    onTap: () {
      if (model['title'] == 'เปลี่ยนโรงพยาบาล') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HospitalPage()),
        );
      }
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: SizedBox(
        height: 85,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  // imageUrl,
                  model['imageUrl'] == '' ? imageUrl : model['imageUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model['title'],
                    style: TextStyle(
                      color: Color(0xFF005C9E),
                      fontFamily: 'Kanit',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    model['description'],
                    style: TextStyle(
                      color: Color(0xFF707070),
                      fontFamily: 'Kanit',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
