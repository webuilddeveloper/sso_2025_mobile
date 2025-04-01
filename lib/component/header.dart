// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sso/component/loading_image_network.dart';
// import 'package:sso/pages/auth/login.dart';
// import 'package:sso/pages/home.dart';
import 'package:sso/pages/notification/notification_list.dart';
import 'package:sso/pages/profile/user_information.dart';
import 'package:sso/screen/login.dart';

header(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonRight = false,
  Function? rightButton,
  String menu = '',
}) {
  return AppBar(
    backgroundColor: Color(0xFF005C9E),
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 80, // Your Height
          width: 80, // Your width
          child: Image.asset("assets/logo.png"),
        ),
        // Your widgets here
      ],
    ),
    // title: Column(
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: [applicationTitle, applicationSubTitle],
    // ),
    actions: <Widget>[
      context != null
          ? Container(
            width: 45,
            height: 45,
            margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFFFFC324),
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => {functionGoBack()},
            ),
          )
          : Container(),
    ],
  );
}

headerV2(
  BuildContext context, {
  required String imageUrl,
  required String profileCode,
  String title1 = '',
  String title2 = '',
  dynamic userData,
  Function? callback,
}) {
  return AppBar(
    centerTitle: false,
    flexibleSpace: Container(
      // decoration: BoxDecoration(
      //   // color: Colors.transparent,
      //   gradient: LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     colors: <Color>[
      //       Color(0XFFE8F6F8),
      //       Color(0xFF1B6CA8),
      //     ],
      //   ),
      // ),
    ),
    backgroundColor: Colors.white,
    elevation: 0.0,
    titleSpacing: 0,
    automaticallyImplyLeading: false,
    title: Image.asset(
      'assets/images/logo_1.png',
      // width: 175,
      height: 80,
    ),
    // title: Container(
    //   width: 120,
    //   decoration: BoxDecoration(
    //     borderRadius: new BorderRadius.circular(50),
    //     color: Color(0xFFEEBA33),
    //     // gradient: LinearGradient(
    //     //   colors: [
    //     //     Color(0xFFEEBA33),
    //     //     Color(0xFF1B6DA8),
    //     //   ],
    //     // ),
    //   ),
    //   child: Image.asset(
    //     'assets/images/header_opec.png',
    //   ),
    // child: Row(
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.symmetric(horizontal: 10),
    //       child: Image.asset(
    //         'assets/images/header_opec.png',
    //         width: 25,
    //         height: 25,
    //       ),
    //     ),
    //     Text(
    //       title != null ? title : '',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //         fontSize: 15,
    //         fontWeight: FontWeight.normal,
    //         fontFamily: 'Kanit',
    //       ),
    //     ),
    //   ],
    // ),
    //),
    actions: <Widget>[
      GestureDetector(
        onTap: () {
          callback!();
        },
        child: Container(
          margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: loadingImageNetwork(
              imageUrl,
              height: 40,
              width: 40,
              isProfile: true,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap:
            () => {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Menu(),
              //   ),
              // )
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          profileCode != null && profileCode != ''
                              ? UserInformationPage(userData: null)
                              : LoginPage(title: ''),
                ),
              ),
            },
        child: Image.asset(
          'assets/images/settings.png',
          width: 40.0,
          height: 40.0,
        ),
      ),
      SizedBox(width: 10),
      GestureDetector(
        onTap:
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => NotificationList(
                        title: 'แจ้งเตือน',
                        userData: userData,
                      ),
                ),
              ),
            },
        child: Image.asset(
          'assets/images/notification.png',
          width: 40.0,
          height: 40.0,
        ),
      ),
      SizedBox(width: 20),
    ],
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

headerHome(
  BuildContext context, {
  String title = '',
  bool isShowLogo = true,
  bool isCenter = false,
  bool isShowButtonCalendar = false,
  bool isButtonCalendar = false,
  bool isShowButtonPoi = false,
  bool isButtonPoi = false,
  bool isNoti = false,
  Function? callBackClickButtonCalendar,
}) {
  return AppBar(
    backgroundColor: Color(0xFFF58A33),
    centerTitle: isCenter,
    elevation: 0.0,
    flexibleSpace: Container(
      // decoration: BoxDecoration(
      //   // color: Color(0xFFF5661F),
      //   gradient: LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     colors: <Color>[
      //       Color(0xFFF58A33),
      //       Color(0xFFF5661F),
      //     ],
      //   ),
      // ),
    ),
    title:
        isCenter
            ? Column(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'KSP',
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'BY Khurusapha',
                  style: TextStyle(
                    fontFamily: 'KSP',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            )
            : Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (isShowLogo) Image.asset('assets/logo.png', height: 30),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily:
                        isShowButtonCalendar || isShowButtonPoi
                            ? 'Kanit'
                            : 'Kanit',
                    fontSize: isShowButtonCalendar || isShowButtonPoi ? 18 : 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(
                //     left: 10,
                //   ),
                //   child: Text(
                //     title,
                //     style: TextStyle(fontFamily: 'Kanit', fontSize: 15),
                //   ),
                // )
              ],
            ),
    actions: [
      if (isShowButtonCalendar)
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              callBackClickButtonCalendar!();
            },
            child:
                isButtonCalendar
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icon_header_calendar_1.png',
                          color: Theme.of(context).primaryColor,
                        ),
                        Text(
                          'ปฏิทิน',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // widgetText(
                        //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                      ],
                    ),
          ),
        ),
      if (isShowButtonPoi)
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 10.0),
          margin: EdgeInsets.only(right: 10, top: 12, bottom: 12),
          width: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: InkWell(
            onTap: () {
              callBackClickButtonCalendar!();
            },
            child:
                isButtonPoi
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.list,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    )
                    : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 20,
                        ),
                        // Image.asset('assets/icon_header_calendar_1.png'),
                        Text(
                          'แผนที่',
                          style: TextStyle(
                            fontSize: 9,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        // widgetText(
                        //     title: 'ปฏิทิน', fontSize: 9, color: 0xFF1B6CA8),
                      ],
                    ),
          ),
        ),
      if (isNoti)
        Container(
          width: 40.0,
          // height: 20.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(0xFFFACBA4),
          ),
          margin: EdgeInsets.only(top: 10.0, right: 10.0, bottom: 10.0),
          padding: EdgeInsets.all(8.0),
          child: InkWell(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationList(title: 'แจ้งเตือน'),
                  ),
                ),
            child: Image.asset(
              'assets/logo/icons/Group103.png',
              color: Colors.white,
            ),
          ),
        ),
    ],
  );
}

headerV3(
  BuildContext context,
  Function functionGoBack, {
  String title = '',
  bool isButtonRight = false,
  Function? rightButton,
  String menu = '',
}) {
  return AppBar(
    backgroundColor: Color(0xFFFFFFFF),
    elevation: 0.0,
    titleSpacing: 5,
    automaticallyImplyLeading: false,
    title: InkWell(
      onTap: () => functionGoBack(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 20, // Your Height
            width: 20, // Your width
            child: Image.asset("assets/icons/left.png", color: Colors.black),
          ),
          SizedBox(width: 10),
          Text(title, style: TextStyle(color: Colors.black)),
        ],
      ),
    ),
    // actions: <Widget>[
    //   context != null
    //       ? Container(
    //           // padding: EdgeInsets.only(right: 10.0),
    //           child: Container(
    //             child: Container(
    //               width: 45,
    //               height: 45,
    //               margin: EdgeInsets.only(top: 6.0, right: 10.0, bottom: 6.0),
    //               decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(50),
    //                 color: Color(0xFFFFC324),
    //               ),
    //               child: new IconButton(
    //                 icon: new Icon(
    //                   Icons.close,
    //                   color: Colors.white,
    //                 ),
    //                 onPressed: () => {
    //                   functionGoBack(),
    //                 },
    //               ),
    //             ),
    //           ),
    //         )
    //       : Container(),
    // ],
  );
}
