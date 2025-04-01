import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sso/screen/splash.dart';

dialogFail(
  BuildContext context, {
  bool reloadApp = false,
  String title = 'การเชื่อมต่อมีปัญหากรุณาลองใหม่อีกครั้ง',
  Color background = Colors.white,
}) {
  return WillPopScope(
    onWillPop: () {
      return Future.value(reloadApp);
    },
    child: Container(
      height: double.infinity,
      width: double.infinity,
      color: background,
      child: CupertinoAlertDialog(
        title: new Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontFamily: 'Kanit',
            color: Colors.black,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: Text(" "),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "ตกลง",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Kanit',
                color: Color(0xFFA9151D),
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
