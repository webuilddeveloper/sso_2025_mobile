import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sso/component/material/input_with_label.dart';
import 'package:sso/models/user.dart';
import 'package:sso/pages/home.dart';
import 'package:sso/shared/api_provider.dart';

class PollAnswerPage extends StatefulWidget {
  const PollAnswerPage({Key? key, this.model}) : super(key: key);

  final dynamic model;

  @override
  State<PollAnswerPage> createState() => _PollAnswerPageState();
}

class _PollAnswerPageState extends State<PollAnswerPage> {
  FlutterSecureStorage storage = FlutterSecureStorage();
  dynamic question;
  late User userData;

  @override
  void initState() {
    question = widget.model;
    _getUser();
    super.initState();
  }

  _getUser() async {
    var value = await storage.read(key: 'dataUserLoginSSO');
    var data = json.decode(value!);
    setState(() {
      userData = User(
        idcard: data['idcard'] != '' ? data['idcard'] : '',
        username: data['username'] != '' ? data['username'] : '',
        password: data['password'] != '' ? data['password'].toString() : '',
        firstName: data['firstName'] != '' ? data['firstName'] : '',
        lastName: data['lastName'] != '' ? data['lastName'] : '',
        imageUrl:
            data['imageUrl'] != '' && data['imageUrl'] != null
                ? data['imageUrl']
                : '',
      );
    });
    print(userData);
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
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
            ),
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
      body: Column(
        children: [
          _buildProgressBar(),
          SizedBox(height: 5),
          Expanded(child: _buildContent(question)),
        ],
      ),
    );
  }

  _buildProgressBar() {
    double widthBar = 0.0;
    List questionList = question['questions'];
    var progressComplete = 0;
    bool sc = false;
    questionList.forEach(
      (c) async => {
        sc = false,
        c['answers'].forEach(
          (e) => {
            if (c['category'] == 'text')
              {
                if (e['title'] != '') {sc = true},
              },
            if (e['value']) {sc = true},
          },
        ),
        if (sc) {progressComplete += 1},
      },
    );
    widthBar = (MediaQuery.of(context).size.width - 30) / questionList.length;
    return Container(
      height: 7,
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Color(0xFF005C9E)),
        borderRadius: BorderRadius.circular(3.5),
      ),
      child: Container(
        width: widthBar * progressComplete,
        decoration: BoxDecoration(
          color: Color(0xFF005C9E),
          borderRadius: BorderRadius.circular(3.5),
        ),
      ),
    );
  }

  _buildContent(model) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 15),
      physics: BouncingScrollPhysics(),
      children: [
        SizedBox(height: 10),
        if (model['questions'].length > 0)
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: model['questions'].length,
            separatorBuilder: (_, __) => SizedBox(height: 10),
            itemBuilder: (_, __) => _buildQuestion(model['questions'], __),
          ),
        SizedBox(height: 40),
        Center(
          child: GestureDetector(
            onTap: () => _sendAnswer(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 5),
              decoration: BoxDecoration(
                color: Color(0xFFFFC324),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                'ส่ง',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ),
        SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
      ],
    );
  }

  _buildQuestion(dynamic param, int index) {
    var model = param[index];
    String sequence = '${index + 1}/${param.length}';
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _buildQuestionTitle(model['title'], sequence),
        if (model['category'] == 'single')
          ...model['answers'].map<Widget>((e) {
            return _buildAnswerSingle(e, index);
          }).toList(),
        if (model['category'] == 'multiple')
          ...model['answers'].map<Widget>((e) {
            return _buildAnswerMultiple(e, index);
          }).toList(),
        if (model['category'] == 'text')
          Padding(
            padding: EdgeInsets.symmetric(vertical: 7),
            child: TextField(
              onChanged:
                  (value) =>
                      setState(() => model['answers'][0]['title'] = value),
              decoration: DecorationRegister.register(
                context,
                hintText: 'เขียนที่บริเวณนี้',
              ),
              maxLines: 5,
            ),
          ),
      ],
    );
  }

  Widget _buildQuestionTitle(title, sequence) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFE8F0F6),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0xFF005C9E),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              sequence,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerSingle(model, indexQuestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: InkWell(
        onTap: () {
          dynamic currentQuestion = question['questions'][indexQuestion];
          List<dynamic> currentAnswers = currentQuestion['answers'];
          currentAnswers.forEach(
            (e) => {
              setState(() {
                if (e['code'] == model['code']) {
                  e['value'] = true;
                } else {
                  e['value'] = false;
                }
              }),
            },
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(
                model['value']
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: Color(0xFF005C9E),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  model['title'],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswerMultiple(model, indexQuestion) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
      child: InkWell(
        onTap: () {
          setState(() {
            model['value'] = !model['value'];
          });
        },
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(
                model['value']
                    ? Icons.check_box
                    : Icons.check_box_outline_blank,
                color: Color(0xFF005C9E),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  model['title'],
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _sendAnswer() async {
    String reference = question['code'];
    String title = '';

    bool checkSendReply = true;
    for (int i = 0; i < question['questions'].length; i++) {
      if (question['questions'][i]['isRequired']) {
        List<dynamic> data = question['questions'][i]['answers'];

        var checkValue = data.indexWhere(
          (item) => item['value'] == true && item['value'] != '',
        );

        if (checkValue == -1) {
          checkSendReply = false;
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                onWillPop: () {
                  return Future.value(false);
                },
                child: CupertinoAlertDialog(
                  title: new Text(
                    'กรุณาตอบคำถาม',
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
                          color: Color(0xFFF28A34),
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
          );
          break;
        } else {
          checkSendReply = true;
        }
      } else {
        checkSendReply = true;
      }
    }
    if (checkSendReply) {
      question['questions']
          .map(
            (question) => {
              title = question['title'],
              reference = question['reference'],
              question['answers']
                  .map(
                    (answer) => {
                      if (answer['value'])
                        {
                          postDio(server + 'm/poll/reply/create', {
                            'reference': reference.toString(),
                            'username': userData.username,
                            'firstName': userData.firstName,
                            'lastName': userData.lastName,
                            'title': title.toString(),
                            'answer':
                                question['reference'] == 'text'
                                    ? answer['value'] == false
                                        ? ''
                                        : answer['value'].toString()
                                    : answer['title'].toString(),
                            'msgOther': (answer['msgOther'] ?? '').toString(),
                            // 'platform': Platform.operatingSystem.toString()
                          }),
                        },
                    },
                  )
                  .toList(),
            },
          )
          .toList();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PollDialog(userData: userData, titleHome: ''),
        ),
      );
    }
  }
}

class PollDialog extends StatefulWidget {
  PollDialog({Key? key, required this.titleHome, this.userData})
    : super(key: key);

  final dynamic userData;
  final String titleHome;

  @override
  _PollDialogState createState() => new _PollDialogState();
}

class _PollDialogState extends State<PollDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: CupertinoAlertDialog(
          title: new Text(
            'บันทึกคำตอบเรียบร้อย',
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
              onPressed: () {
                goBack();
              },
            ),
          ],
        ),
      ),
    );
  }

  void goBack() async {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
