import 'package:flutter/material.dart';

labelTextField(String label, Icon icon) {
  return Row(
    children: <Widget>[
      icon,
      Text(
        ' $label',
        style: TextStyle(
          fontSize: 15.00,
          fontFamily: 'Kanit',
          color: Color(0xFF005C9E),
        ),
      ),
    ],
  );
}

labelTextFieldLogin(String label, image) {
  return Row(
    children: <Widget>[
      Image.asset(image, height: 20),
      Text(
        ' ${label}',
        style: TextStyle(
          fontSize: 20.00,
          fontFamily: 'Kanit',
          color: Color(0xFFFFFFFF),
        ),
      ),
    ],
  );
}

textField(
  TextEditingController model,
  TextEditingController? modelMatch,
  String hintText,
  String validator,
  bool enabled,
  bool isPassword,
) {
  return SizedBox(
    height: 40.0,
    child: TextField(
      obscureText: isPassword,
      controller: model,
      enabled: enabled,
      style: TextStyle(
        color: Color(0xFF005C9E),
        fontWeight: FontWeight.normal,
        fontFamily: 'Kanit',
        fontSize: 15.0,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFE8F0F6),
        contentPadding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
