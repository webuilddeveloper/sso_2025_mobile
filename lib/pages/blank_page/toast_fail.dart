import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastFail(
  BuildContext context, {
  String text = 'การเชื่อมต่อผิดพลาด',
  Color color = Colors.grey,
  Color fontColor = Colors.white,
  int duration = 3,
}) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: duration,
    backgroundColor: color,
    textColor: fontColor,
  );
}
