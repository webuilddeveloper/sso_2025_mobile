import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

buttonCloseBack(BuildContext context) {
  return Column(
    children: [
      Container(
        // width: 60,
        // color: Colors.red,
        // alignment: Alignment.centerRight,
        child: MaterialButton(
          minWidth: 29,
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(194, 223, 249, 1),
          textColor: Colors.white,
          child: Icon(
            Icons.close,
            size: 29,
          ),
          shape: CircleBorder(),
        ),
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
  );
}

buttonCloseBackV2(BuildContext context, title) {
  return InkWell(
    onTap: () => Navigator.pop(context),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 25, // Your Height
          width: 25, // Your width
          child: Image.asset("assets/icons/left.png", color: Colors.black),
        ),
        SizedBox(width: 10),
        Text(
          "$title",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'Kanit',
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ),
  );
}
