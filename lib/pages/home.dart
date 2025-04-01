// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_app_badger/flutter_app_badger.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:intl/intl.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:sso/component/carousel_banner.dart';
// import 'package:sso/component/loading_image_network.dart';
// import 'package:sso/component/sso/profile.dart';
// import 'package:sso/models/user.dart';
// import 'package:sso/pages/blank_page/toast_fail.dart';
// import 'package:sso/pages/main_popup/dialog_main_popup.dart';
// import 'package:sso/pages/v2/policy_v2.dart';
// import 'package:sso/screen/contact/emergency_number.dart';
// import 'package:sso/screen/dental.dart';
// import 'package:sso/screen/feedback/feedback_main.dart';
// import 'package:sso/screen/login.dart';
// import 'package:sso/screen/news.dart';
// import 'package:sso/screen/notification.dart';
// import 'package:sso/screen/poll.dart';
// import 'package:sso/screen/setting.dart';
// import 'package:sso/screen/subsidy.dart';
// import 'package:sso/shared/api_provider.dart';

// import '../component/button_model.dart';
// import '../screen/about_us/about_us_form.dart';
// import '../screen/contact/contact_category_list.dart';
// import '../screen/knowledge/knowledge_list.dart';
// import '../screen/privilege/privilege_main.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   AppLifecycleState _notification;
//   PageController pageController;
//   final storage = new FlutterSecureStorage();
//   RefreshController _refreshController = RefreshController(
//     initialRefresh: false,
//   );
//   DateTime currentBackPressTime;

//   Profile profile = new Profile(model: Future.value({}));
//   User userData = User(imageUrl: '');

//   Future<dynamic> _futureProfile;
//   Future<dynamic> _futureOrganizationImage;
//   Future<dynamic> _futureAboutUs;
//   Future<dynamic> _futureMainPopUp;
//   Future<dynamic> _futureRotation;
//   Future<dynamic> _futureBanner;
//   dynamic _isNewsCount = false;
//   dynamic _isEventCount = false;
//   dynamic _isPollCount = false;

//   String profileCode = "";
//   String userCode = '';
//   String _imageUrl = '';

//   final seen = Set<String>();
//   List unique = [];
//   List resultImageLv0 = [];
//   List imageLv0 = [];

//   bool notShowOnDay = false;
//   bool hiddenMainPopUp = false;
//   bool showSlideUp = false;

//   int add_badger = 0;

//   @override
//   void initState() {
//     _callRead();
//     super.initState();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     setState(() {
//       _notification = state;
//       _addBadger();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: InkWell(
//         child: Image.asset('assets/images/emergency_number.png', height: 50),
//         onTap:
//             () => Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder:
//                     (context) => EmergencyNumber(
//                       title: 'เบอร์ฉุกเฉิน',
//                       code: '20220926145544-283-886',
//                     ),
//               ),
//             ),
//       ),
//       appBar: AppBar(
//         centerTitle: false,
//         flexibleSpace: Container(),
//         backgroundColor: Colors.white,
//         brightness: Brightness.light,
//         elevation: 0.0,
//         titleSpacing: 0,
//         automaticallyImplyLeading: false,
//         title: Image.asset('assets/images/logo_1.png', height: 80),
//         actions: <Widget>[
//           GestureDetector(
//             onTap:
//                 () => {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) =>
//                               profileCode != null && profileCode != ''
//                                   // ? UserInformationPage()
//                                   ? SettingPage()
//                                   : LoginPage(),
//                     ),
//                   ),
//                 },
//             child: Image.asset(
//               'assets/images/settings.png',
//               width: 40.0,
//               height: 40.0,
//             ),
//           ),
//           SizedBox(width: 10),
//           GestureDetector(
//             onTap:
//                 () => {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => NotificationPage()),
//                   ),
//                 },
//             child: Image.asset(
//               'assets/images/notification.png',
//               width: 40.0,
//               height: 40.0,
//             ),
//           ),
//           SizedBox(width: 20),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: InkWell(
//         splashColor: Colors.transparent,
//         highlightColor: Colors.transparent,
//         onTap: () {
//           FocusScope.of(context).unfocus();
//         },
//         child: WillPopScope(child: _buildMenu(), onWillPop: confirmExit),
//       ),
//     );
//   }

//   _buildMenu() {
//     return SmartRefresher(
//       enablePullDown: true,
//       enablePullUp: false,
//       header: WaterDropHeader(
//         complete: Container(child: Text('')),
//         completeDuration: Duration(milliseconds: 0),
//       ),
//       controller: _refreshController,
//       onRefresh: _onRefresh,
//       onLoading: _onLoading,
//       child: ListView(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
//         children: [
//           GestureDetector(
//             onTap:
//                 () => Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (_) => SettingPage()),
//                 ),
//             child: Row(
//               children: [
//                 if (userData.imageUrl != '' && userData.imageUrl != null)
//                   ClipRRect(
//                     child: loadingImageNetwork(
//                       '${userData.imageUrl}',
//                       height: 80,
//                       width: 80,
//                     ),
//                   ),
//                 if (userData.imageUrl == '')
//                   Container(
//                     height: 80,
//                     width: 80,
//                     padding: EdgeInsets.all(10),
//                     decoration: BoxDecoration(color: Colors.white),
//                     child: ClipRRect(
//                       child: Image.asset(
//                         'assets/images/user_not_found.png',
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 SizedBox(width: 20),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         '${userData.firstName} ${userData.lastName}',
//                         style: TextStyle(fontSize: 13),
//                       ),
//                       Text(
//                         'ผู้ประกันตนมาตรา 33',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF005C9E),
//                         ),
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 15,
//                           vertical: 7,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: Color(0xFFE8F0F6),
//                         ),
//                         child: Text(
//                           'โรงพยาบาลกรุงเทพ',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Color(0xFF005C9E),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 10),
//           Carousel3(model: _futureRotation),
//           SizedBox(
//             height: 140,
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap:
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => SubsidyPage()),
//                         ),
//                     child: Stack(
//                       children: [
//                         Container(color: Color(0xFF005C9E)),
//                         Positioned(
//                           top: 12,
//                           left: 15,
//                           child: Text(
//                             'ยอดเงินสบทบชราภาพ',
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 47,
//                           left: 15,
//                           child: Text(
//                             'ณ ปัจจุบัน',
//                             style: TextStyle(fontSize: 11, color: Colors.white),
//                           ),
//                         ),
//                         Positioned(
//                           right: 11,
//                           bottom: 9,
//                           child: Text(
//                             '25,000',
//                             style: TextStyle(
//                               fontSize: 40,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           right: 11,
//                           bottom: 5,
//                           child: Text(
//                             'บาท',
//                             style: TextStyle(fontSize: 11, color: Colors.white),
//                           ),
//                         ),
//                         Positioned(
//                           right: 10,
//                           top: 12,
//                           child: Image.asset(
//                             'assets/images/old_person.png',
//                             height: 50,
//                             width: 47,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => DentalPage()),
//                       ),
//                   child: Container(
//                     width: 120,
//                     color: Color(0xFFFFC324),
//                     child: Stack(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(10.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'สิทธิ์ทันตกรรม',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     'คงเหลือ',
//                                     style: TextStyle(
//                                       fontSize: 11,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         Positioned(
//                           top: 48,
//                           left: 12,
//                           child: Image.asset(
//                             'assets/images/toot.png',
//                             width: 15,
//                             height: 17,
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 15,
//                           left: 0,
//                           right: 0,
//                           child: Text(
//                             '900',
//                             style: TextStyle(
//                               fontSize: 25,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 140,
//             width: double.infinity,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     storage.write(key: 'isBadgerNews', value: '0');
//                     setState(() {
//                       _isNewsCount = false;
//                       _addBadger();
//                     });
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => NewsPage()),
//                     ).then((value) => _callRead());
//                   },
//                   child: Container(
//                     width: 120,
//                     color: Color(0xFFFFC324),
//                     padding: EdgeInsets.only(top: 32, bottom: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/megaphone.png',
//                           width: 72,
//                           height: 50,
//                         ),
//                         Text(
//                           'ข่าวประกาศ',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       buttonModel(
//                         context,
//                         Future.value([
//                           {
//                             'title': 'เปลี่ยนโรงพยาบาล',
//                             'description':
//                                 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                             'imageUrl': 'assets/images/change_hospital.png',
//                           },
//                           {
//                             'title': 'เบิกสิทธิประโยชน์',
//                             'description':
//                                 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                             'imageUrl': 'assets/images/withdraw_benefits.png',
//                           },
//                           {
//                             'title': 'ลงทะเบียนขอรับเงินทดแทน',
//                             'description':
//                                 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                             'imageUrl':
//                                 'assets/images/request_compensation.png',
//                           },
//                           {
//                             'title': 'สมัครเป็นผู้ประกันตน ม.40',
//                             'description':
//                                 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                             'imageUrl': 'assets/images/apply_as_an_insurer.png',
//                           },
//                         ]),
//                         'บริการออนไลน์',
//                       );
//                     },
//                     child: Stack(
//                       children: [
//                         Container(color: Color(0xFF5794BF)),
//                         Positioned(
//                           top: 16,
//                           left: 15,
//                           child: Text(
//                             'ลงทะเบียนขอรับเงินทดแทน',
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         Positioned(
//                           top: 37,
//                           left: 15,
//                           child: Text(
//                             'ว่างงาน หรือ ชราภาพ',
//                             style: TextStyle(fontSize: 11, color: Colors.white),
//                           ),
//                         ),
//                         Positioned(
//                           bottom: 17,
//                           right: 15,
//                           child: Image.asset(
//                             'assets/images/man_two_box.png',
//                             width: 50,
//                             height: 75,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap:
//                 () => buttonModel(
//                   context,
//                   Future.value([
//                     {
//                       'title': 'เปลี่ยนโรงพยาบาล',
//                       'description':
//                           'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                       'imageUrl': 'assets/images/change_hospital.png',
//                     },
//                     {
//                       'title': 'เบิกสิทธิประโยชน์',
//                       'description':
//                           'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                       'imageUrl': 'assets/images/withdraw_benefits.png',
//                     },
//                     {
//                       'title': 'ลงทะเบียนขอรับเงินทดแทน',
//                       'description':
//                           'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                       'imageUrl': 'assets/images/request_compensation.png',
//                     },
//                     {
//                       'title': 'สมัครเป็นผู้ประกันตน ม.40',
//                       'description':
//                           'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor',
//                       'imageUrl': 'assets/images/apply_as_an_insurer.png',
//                     },
//                   ]),
//                   'บริการออนไลน์',
//                 ),
//             child: Stack(
//               children: [
//                 Image.asset(
//                   'assets/images/bg_macbook.png',
//                   fit: BoxFit.cover,
//                   height: 140,
//                   width: double.infinity,
//                 ),
//                 Positioned(
//                   top: 6,
//                   right: 15,
//                   child: SizedBox(
//                     width: 160,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'บริการออนไลน์',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.check_rounded,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                             Text(
//                               'เปลี่ยนโรงพยาบาล',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.check_rounded,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                             Text(
//                               'เบิกสิทธิประโยชน์',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(height: 4),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.check_rounded,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 'สมัครเป็นผู้ประกันตน ม.40',
//                                 style: TextStyle(
//                                   fontSize: 15,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 140,
//             width: double.infinity,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => KnowledgeList(),
//                         ),
//                       ),
//                   child: Container(
//                     width: 120,
//                     color: Color(0xFF3880B3),
//                     padding: EdgeInsets.only(top: 32, bottom: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/book.png',
//                           width: 72,
//                           height: 50,
//                         ),
//                         Text(
//                           'คลังความรู้',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap:
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => PrivilegeMainV2(),
//                           ),
//                         ),
//                     child: Stack(
//                       children: [
//                         Image.asset(
//                           'assets/images/Privilge.png',
//                           width: double.infinity,
//                           height: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         Positioned.fill(
//                           child: Image.asset(
//                             'assets/images/shadow_bg.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 16,
//                           left: 15,
//                           child: Text(
//                             'สิทธิประโยชน์ สำหรับสมาชิก',
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 140,
//             width: double.infinity,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => FeedbackMain(code: 'FAQ'),
//                         ),
//                       );
//                     },
//                     child: Stack(
//                       children: [
//                         Image.asset(
//                           'assets/images/FAQ.png',
//                           width: double.infinity,
//                           height: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         Positioned.fill(
//                           child: Image.asset(
//                             'assets/images/shadow_bg.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 16,
//                           left: 15,
//                           child: Text(
//                             'ข้อเสนอแนะ',
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => PollPage()),
//                       ),
//                   child: Container(
//                     width: 120,
//                     color: Color(0xFF3880B3),
//                     padding: EdgeInsets.only(top: 32, bottom: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/document.png',
//                           width: 72,
//                           height: 50,
//                         ),
//                         Text(
//                           'แบบสำรวจ',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 140,
//             width: double.infinity,
//             child: Row(
//               children: [
//                 GestureDetector(
//                   onTap:
//                       () => Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder:
//                               (context) => AboutUsFormV2(
//                                 model: _futureAboutUs,
//                                 title: 'เกี่ยวกับเรา',
//                                 userData: userData,
//                               ),
//                         ),
//                       ),
//                   child: Container(
//                     width: 120,
//                     color: Color(0xFF3880B3),
//                     padding: EdgeInsets.only(top: 32, bottom: 15),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/information.png',
//                           width: 72,
//                           height: 50,
//                         ),
//                         Text(
//                           'เกี่ยวกับเรา',
//                           style: TextStyle(
//                             fontSize: 15,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: GestureDetector(
//                     onTap:
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder:
//                                 (context) => ContactCategoryListV2(
//                                   username:
//                                       '${userData.firstName} ${userData.lastName}',
//                                 ),
//                           ),
//                         ),
//                     child: Stack(
//                       children: [
//                         Image.asset(
//                           'assets/images/telephone.png',
//                           width: double.infinity,
//                           height: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                         Positioned.fill(
//                           child: Image.asset(
//                             'assets/images/shadow_bg.png',
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                         Positioned(
//                           top: 16,
//                           left: 15,
//                           child: Text(
//                             'สมุดโทรศัพท์',
//                             style: TextStyle(
//                               fontSize: 15,
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<bool> confirmExit() {
//     DateTime now = DateTime.now();
//     if (currentBackPressTime == null ||
//         now.difference(currentBackPressTime) > Duration(seconds: 2)) {
//       currentBackPressTime = now;
//       toastFail(
//         context,
//         text: 'กดอีกครั้งเพื่อออก',
//         color: Colors.black,
//         fontColor: Colors.white,
//       );
//       return Future.value(false);
//     }
//     return Future.value(true);
//   }

//   void _onRefresh() async {
//     _callRead();

//     // if failed,use refreshFailed()
//     _refreshController.refreshCompleted();
//   }

//   void _onLoading() async {
//     await Future.delayed(Duration(milliseconds: 1000));
//     _refreshController.loadComplete();
//   }

//   _addBadger() async {
//     String storageNewsCount = await storage.read(key: 'isBadgerNews');
//     String storageEventCount = await storage.read(key: 'isBadgerEvent');
//     String storagePollCount = await storage.read(key: 'isBadgerPoll');

//     _isNewsCount = storageNewsCount == '1' ? true : false;
//     _isEventCount = storageEventCount == '1' ? true : false;
//     _isPollCount = storagePollCount == '1' ? true : false;
//     if (_isNewsCount && _isEventCount && _isPollCount)
//       add_badger = 3;
//     else if ((_isNewsCount && _isEventCount) ||
//         (_isNewsCount && _isPollCount) ||
//         (_isPollCount && _isEventCount))
//       add_badger = 2;
//     else if (_isNewsCount || _isEventCount || _isPollCount)
//       add_badger = 1;
//     else
//       add_badger = 0;

//     FlutterAppBadger.updateBadgeCount(add_badger);

//     _updateBadgerStorage('isBadgerNews', _isNewsCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerEvent', _isEventCount ? '1' : '0');
//     _updateBadgerStorage('isBadgerPoll', _isPollCount ? '1' : '0');
//   }

//   _updateBadgerStorage(String keyTitle, String isActive) {
//     storage.write(key: keyTitle, value: isActive);
//   }

//   _callRead() async {
//     dynamic data;
//     profileCode = await storage.read(key: 'profileCode1');
//     // print('------------------------$profileCode----------------------');
//     if (profileCode != '' && profileCode != null) {
//       _futureProfile = postDio(profileReadApi, {'code': profileCode});
//       _futureOrganizationImage = postDio(organizationImageReadApi, {
//         "code": profileCode,
//       });

//       data = await _futureProfile;
//     } else {
//       logout(context);
//     }

//     var token = await storage.read(key: 'token');
//     if (token != '' && token != null)
//       postDio('${server}m/v2/register/token/create', {
//         'token': token,
//         'profileCode': profileCode,
//       });

//     var imageUrlSocial = await storage.read(key: 'profileImageUrl');
//     if (imageUrlSocial != '' && imageUrlSocial != null)
//       setState(() {
//         _imageUrl = imageUrlSocial;
//       });
//     // print('-------------start response------------');
//     var value = await storage.read(key: 'dataUserLoginSSO');
//     if (value == '' || value == null) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => LoginPage()),
//         (Route<dynamic> route) => false,
//       );
//     }

//     userCode = data['code'];

//     setState(() {
//       userData = new User(
//         idcard: data['idcard'] != '' ? data['idcard'] : '',
//         username: data['username'] != '' ? data['username'] : '',
//         password: data['password'] != '' ? data['password'].toString() : '',
//         firstName: data['firstName'] != '' ? data['firstName'] : '',
//         lastName: data['lastName'] != '' ? data['lastName'] : '',
//         imageUrl:
//             data['imageUrl'] != '' && data['imageUrl'] != null
//                 ? data['imageUrl']
//                 : '',
//         category: data['category'] != '' ? data['category'] : '',
//         countUnit: data['countUnit'] != '' ? data['countUnit'] : '',
//         address: data['address'] != '' ? data['address'] : '',
//         status: data['status'] != '' ? data['status'] : '',
//         checkOrganization: data['checkOrganization'],
//       );
//     });

//     // _futurePrivilege = post('${privilegeApi}read', {'skip': 0, 'limit': 10});
//     // _futureKnowledge = post('${knowledgeApi}read', {'skip': 0, 'limit': 10});
//     // _futurePoll = post('${pollApi}read', {'skip': 0, 'limit': 10});
//     _futureAboutUs = postDio(aboutUsReadApi, {});
//     _futureBanner = postDio(bannerReadApi, {'skip': 0, 'limit': 10});
//     _futureRotation = postDio(rotationApi + 'read', {'skip': 0, 'limit': 10});
//     _futureMainPopUp = postDio(mainPopupReadApi, {'skip': 0, 'limit': 10});

//     _addBadger();
//     // getMainPopUp();
//     //getImageLv0();
//     _callReadPolicy();
//     // print('-------------end response------------');
//   }

//   getMainPopUp() async {
//     var result = await postDio(mainPopupReadApi, {'skip': 0, 'limit': 100});

//     if (result.length > 0) {
//       var valueStorage = await storage.read(key: 'mainPopupSSO');
//       var dataValue;
//       if (valueStorage != null) {
//         dataValue = json.decode(valueStorage);
//       } else {
//         dataValue = null;
//       }

//       var now = new DateTime.now();
//       DateTime date = new DateTime(now.year, now.month, now.day);

//       if (dataValue != null) {
//         var index = dataValue.indexWhere(
//           (c) =>
//               c['username'] == userData.username &&
//               c['date'].toString() ==
//                   DateFormat("ddMMyyyy").format(date).toString() &&
//               c['boolean'] == "true",
//         );

//         if (index == -1) {
//           this.setState(() {
//             hiddenMainPopUp = false;
//           });
//           return showDialog(
//             barrierDismissible: false, // close outside
//             context: context,
//             builder: (_) {
//               return WillPopScope(
//                 onWillPop: () {
//                   return Future.value(false);
//                 },
//                 child: MainPopupDialog(
//                   model: _futureMainPopUp,
//                   type: 'mainPopup',
//                   username: userData.username,
//                 ),
//               );
//             },
//           );
//         } else {
//           this.setState(() {
//             hiddenMainPopUp = true;
//           });
//         }
//       } else {
//         this.setState(() {
//           hiddenMainPopUp = false;
//         });
//         return showDialog(
//           barrierDismissible: false, // close outside
//           context: context,
//           builder: (_) {
//             return WillPopScope(
//               onWillPop: () {
//                 return Future.value(false);
//               },
//               child: MainPopupDialog(
//                 model: _futureMainPopUp,
//                 type: 'mainPopup',
//                 username: userData.username,
//               ),
//             );
//           },
//         );
//       }
//     }
//   }

//   Future<Null> _callReadPolicy() async {
//     var policy = await postDio(server + "m/policy/read", {
//       "category": "application",
//     });
//     if (policy.length > 0) {
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder:
//               (context) => PolicyV2Page(
//                 category: 'application',
//                 navTo: () {
//                   Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(builder: (context) => HomePage()),
//                     (Route<dynamic> route) => false,
//                   );
//                 },
//               ),
//         ),
//         (Route<dynamic> route) => false,
//       );
//     } else {
//       getMainPopUp();
//     }
//   }
// }
