import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

inputWithLabel({
  BuildContext? context,
  required TextEditingController textEditingController,
  required bool checkText,
  Function? callback,
  String title = '',
  double fontSizeTitle = 20.0,
  FontWeight fontWeightTitle = FontWeight.w500,
  Color fontColorTitle = Colors.black,
  String hintText = '',
  required Function validator,
  bool isShowPattern = false,
  bool hasBorder = false,
  Color enabledBorderColor = const Color(0xFF9A1120),
  Color focusedBorderColor = const Color(0xFF9A1120),
  bool isShowIcon = false,
  required TextInputType keyboardType, //TextInputType.multiline
  int maxLines = 1,
  required int maxLength,
  bool isPassword = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        child: Text(
          title,
          style: TextStyle(
            color: fontColorTitle,
            fontFamily: 'Kanit',
            fontSize: fontSizeTitle,
            fontWeight: fontWeightTitle,
          ),
        ),
      ),
      SizedBox(height: 9.0),
      TextFormField(
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        obscureText: isPassword ? checkText : false,
        style: TextStyle(
          // color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.normal,
          fontFamily: 'Kanit',
          fontSize: 13.0,
        ),
        decoration: InputDecoration(
          border:
              hasBorder
                  ? new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.red, width: 1),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                  : null,
          enabledBorder:
              hasBorder
                  ? OutlineInputBorder(
                    borderSide: BorderSide(
                      color: enabledBorderColor,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  )
                  : null,
          // focusedBorder: hasBorder
          //     ? OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //         borderSide: BorderSide(
          //           color: focusedBorderColor,
          //           width: 2.0,
          //         ),
          //       )
          //     : null,
          // suffixIcon: isShowIcon
          //     ? IconButton(
          //         icon: Icon(
          //           checkText ? Icons.visibility : Icons.visibility_off,
          //         ),
          //         onPressed: () {
          //           callback();
          //         },
          //       )
          //     : null,
          // filled: true,
          fillColor: Colors.transparent,
          contentPadding: EdgeInsets.only(left: 5.0, right: 5.0, top: 19.0),
          hintText: hintText,
          errorStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontFamily: 'Kanit',
            fontSize: 12.0,
          ),
        ),
        validator: (model) {
          return validator(model);
        },
        controller: textEditingController,
        // enabled: true,
      ),
      isShowPattern
          ? Text(
            '(รหัสผ่านต้องมีตัวอักษร A-Z, a-z และ 0-9 ความยาวขั้นต่ำ 6 ตัวอักษร)',
            style: TextStyle(
              fontSize: 10.00,
              fontFamily: 'Kanit',
              color: Color(0xFFFF0000),
            ),
          )
          : Container(),
    ],
  );
}

class DecorationRegister {
  static InputDecoration register(context, {String hintText = ''}) =>
      InputDecoration(
        // label: Text(hintText),
        // labelStyle: const TextStyle(
        //   color: Color(0xFF707070),
        // ),
        hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  static InputDecoration registerMember(context, {String hintText = ''}) =>
      InputDecoration(
        label: Text(hintText),
        labelStyle: const TextStyle(color: Color(0xFF707070)),
        // hintText: hintText,
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
        ),
        errorStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 10.0,
        ),
      );

  static InputDecoration password(
    context, {
    String hintText = '',
    bool visibility = false,
    required Function suffixTap,
  }) => InputDecoration(
    label: Text(hintText),
    labelStyle: const TextStyle(color: Color(0xFF707070)),
    hintText: hintText,
    suffixIcon: GestureDetector(
      onTap: () {
        suffixTap();
      },
      child:
          visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
    ),
    filled: true,
    fillColor: const Color(0xFFFFFFFF),
    contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
    ),
    errorStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
  );

  static InputDecoration passwordMember(
    context, {
    String labelText = '',
    String hintText = '',
    bool visibility = false,
    required Function suffixTap,
  }) => InputDecoration(
    label: Text(labelText),
    labelStyle: const TextStyle(color: Color(0xFF707070)),
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFF707070), fontSize: 8),
    suffixIcon: GestureDetector(
      onTap: () {
        suffixTap();
      },
      child:
          visibility
              ? const Icon(Icons.visibility_off)
              : const Icon(Icons.visibility),
    ),
    filled: true,
    fillColor: Colors.transparent,
    contentPadding: const EdgeInsets.fromLTRB(15.0, 5.0, 5.0, 5.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
    ),
    errorStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
  );

  static InputDecoration searchHospital(
    context, {
    String hintText = '',
    Function? prefixTap,
    Color color = Colors.transparent,
    Color colorBorder = Colors.transparent,
  }) => InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: Color(0xFF707070), fontSize: 12),
    prefixIcon: GestureDetector(
      onTap: () {
        prefixTap!();
      },
      child: const Icon(Icons.search),
    ),
    filled: true,
    fillColor: color,
    contentPadding: const EdgeInsets.fromLTRB(15.0, 2.0, 2.0, 2.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: colorBorder),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: Theme.of(context).primaryColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18.0),
      borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
    ),
    errorStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 10.0),
  );
}

class InputFormatTemple {
  static username() => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z.]')),
  ];
  static password() => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z@!_.]')),
  ];
  static phone() => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    LengthLimitingTextInputFormatter(10),
  ];

  static otp() => [
    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
    LengthLimitingTextInputFormatter(1),
  ];
}
