// ignore_for_file: unused_field, library_private_types_in_public_api

import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sso/component/loading_image_network.dart';
import 'package:sso/pages/home.dart';
import 'package:sso/screen/event_calendar_form.dart';
import 'package:sso/shared/api_provider.dart';
import 'package:sso/shared/extension.dart';
import 'package:table_calendar/table_calendar.dart';

class EventCalendarPage extends StatefulWidget {
  @override
  _EventCalendarPageState createState() => _EventCalendarPageState();
}

class _EventCalendarPageState extends State<EventCalendarPage>
    with TickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  late ValueNotifier<List<dynamic>> _selectedEvents;
  late ValueNotifier<List<dynamic>> _monthEvents;
  late Map<DateTime, List> _events;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  late Future<dynamic> _futureCategory;

  late LinkedHashMap<DateTime, List<dynamic>> model;
  var markData = [];
  late Map<DateTime, List<dynamic>> itemEvent;
  final _random = Random();

  late AnimationController _animationController;
  bool expanded = false;
  String categorySelected = '';
  String categoryTitleSelected = '';

  String keySearch = '';
  bool isHighlight = false;
  int _limit = 10;
  double heightAnimate = 130;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _futureCategory =
        postDioCategory(server + 'eventCalendar/category/' + "read", {});
    model = kEvents;
    _selectedDay = DateTime.now();
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay));
    _monthEvents = ValueNotifier([]);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
    getMarkerEvent();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  getMarkerEvent() async {
    var objectData = [];
    var value = await storage.read(key: 'dataUserLoginSSO');
    json.decode(value!);
    final result = await postDio(server + "m/EventCalendar/mark/read2", {
      "year": DateTime.now().year,
      'profileCode': '',
    });
    // print('-------- > $result');
    if (result != null) {
      objectData = result;

      for (int i = 0; i < objectData.length; i++) {
        if (objectData[i]['items'].length > 0) {
          markData.add(objectData[i]);
        }
      }

      // map current month list.

      itemEvent = Map.fromIterable(
        markData,
        key: (item) => DateTime.parse(item['date']),
        value: (item) => item['items'],
      );

      var mainEvent = LinkedHashMap<DateTime, List<dynamic>>(
        equals: isSameDay,
        hashCode: getHashCode,
      )..addAll(itemEvent);
      // print('value --> ');

      setState(() {
        model = mainEvent;

        _selectedEvents.value = _getEventsForDay(_selectedDay);
      });
      _setMonthData();
    }
  }

  _setMonthData() {
    // where data focus month.
    List<dynamic> data = markData
        .where((e) =>
            DateFormat('yyyyMM').format(_focusedDay) ==
            e['date'].substring(0, 6))
        .toList();

    // expand data['items'].
    List<dynamic> listExpand = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i]['items'].length > 0)
        listExpand = [...data[i]['items'], ...listExpand];
    }

    // remove same data.
    List<dynamic> result = listExpand.unique((x) => x['code']);

    setState(() {
      _monthEvents = ValueNotifier(result.take(10).toList());
    });
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    // Implementation example
    // print('kEvents ---> $kEvents');

    // return kEvents[day] ?? [];
    // print(model[day]);
    return model[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
        _selectedEvents.value = _getEventsForDay(selectedDay);
      });
    }
  }

  void goHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void _toggleMode() {
    setState(() {
      if (_calendarFormat == CalendarFormat.month) {
        _calendarFormat = CalendarFormat.week;
        heightAnimate = 50.0;
      } else {
        _calendarFormat = CalendarFormat.month;
        heightAnimate = 130;
      }
      // expanded = !expanded;
    });
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
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFE8F0F6),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 17,
                          color: Color(0xFF005C9E),
                        ),
                        SizedBox(width: 5),
                        Text(
                          'รายการ',
                          style: TextStyle(
                            color: Color(0xFF005C9E),
                            fontSize: 13,
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
      body: screen(),
    );
  }

  screen() {
    return Column(
      children: [
        tableCalendar(),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (_calendarFormat == CalendarFormat.month)
                    AnimatedSize(
                      curve: Curves.fastOutSlowIn,
                      child: Image.asset(
                        'assets/images/builds_1.png',
                        fit: BoxFit.fitWidth,
                      ),
                      duration: Duration(
                          milliseconds: heightAnimate == 130 ? 1 : 400),
                    ),
                  if (_calendarFormat == CalendarFormat.week)
                    Container(
                      color: Colors.white,
                      height: 50,
                    ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _toggleMode(),
                      child: Container(
                        height: 50,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(),
                        child: Container(
                          height: 50,
                          margin: EdgeInsets.only(top: 10), // ***
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: Container(
                            height: 6,
                            width: 150,
                            decoration: BoxDecoration(
                              color: Color(0xFF005C9E),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: ListView(
                  children: [
                    _buildEventMonthList(),
                    SizedBox(height: 20),
                    _buildHighlightList(),
                    SizedBox(height: 20),
                    _buildTodayList()
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  tableCalendar() {
    return TableCalendar<dynamic>(
      locale: "th_TH",
      firstDay: kFirstDay,
      lastDay: kLastDay,
      focusedDay: _focusedDay,
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      rangeStartDay: _rangeStart,
      rangeEndDay: _rangeEnd,
      calendarFormat: _calendarFormat,
      rangeSelectionMode: _rangeSelectionMode,
      availableGestures: AvailableGestures.all,
      eventLoader: _getEventsForDay,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: HeaderStyle(
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: Color(0xFF005C9E),
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: Color(0xFF005C9E),
        ),
        titleTextFormatter: (date, locale) {
          var year = date.year + 543;
          return DateFormat('MMMM พ.ศ. $year').format(date);
        },
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle().copyWith(
          fontSize: 17.0,
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
        ),
      ),
      calendarStyle: CalendarStyle(
        outsideDaysVisible: true,
        defaultTextStyle: TextStyle().copyWith(
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.bold,
        ),
        rangeEndTextStyle: TextStyle(
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
        ),
        todayDecoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
          borderRadius: BorderRadius.circular(25),
        ),
        todayTextStyle: TextStyle().copyWith(
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.bold,
        ),
        weekendTextStyle: TextStyle().copyWith(
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.bold,
        ),
        outsideTextStyle: TextStyle(
          color: Color(0xFF005C9E),
          fontWeight: FontWeight.normal,
        ),
      ),
      onDaySelected: _onDaySelected,
      onPageChanged: (focusedDay) {
        setState(() {
          _focusedDay = focusedDay;
        });
        _setMonthData();
      },
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(5.0),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF005C9E),
              ),
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          );
        },
        markerBuilder: (context, day, events) =>
            _buildEventsMarker(events, day),
      ),
    );
  }

  Widget? _buildEventsMarker(List events, DateTime day) {
    var colors = [
      Color(0xFF64C5D7),
      Color(0xFFFEC32D),
    ];
    List<int> listItem = [];
    if (events.isNotEmpty)
      for (var i = 0; i < events.length; i++) {
        if (i < 2) {
          listItem.add(i);
        }
      }
    if (events.isEmpty) return null;
    return Positioned(
      bottom: 0,
      child: Row(children: [
        ...listItem
            .map<Padding>(
              (e) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors[_random.nextInt(colors.length)],
                  ),
                  width: 8.0,
                  height: 8.0,
                ),
              ),
            )
            .toList(),
        if (events.length > 3)
          Padding(
            padding: const EdgeInsets.only(left: 1.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              width: 8.0,
              height: 8.0,
            ),
          ),
      ]),
    );
  }

  _buildEventCard(event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarFormPage(
              model: event,
            ),
          ),
        );
      },
      child: Container(
        height: 252,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 0.75),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    '${event['imageUrl']}',
                    fit: BoxFit.cover,
                    height: 196,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    height: 15,
                    padding: EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(0xFFC6DAE9),
                      borderRadius: BorderRadius.circular(7.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 10,
                          color: Color(0xFF005C9E),
                        ),
                        SizedBox(width: 2),
                        Text(
                          dateStringFormat(event['dateStart']),
                          style: TextStyle(
                            fontSize: 9,
                            color: Color(0xFF005C9E),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '${event['title']}',
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

  _buildEventMonthList() {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: _monthEvents,
      builder: (context, value, _) {
        if (value.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'กิจกรรมเด่นเดือนนี้',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 185,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) =>
                      _buildEventMonthCard(value[index]),
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemCount: value.length,
                ),
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  _buildEventMonthCard(model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventCalendarFormPage(
              model: model,
            ),
          ),
        );
      },
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: loadingImageNetwork(
                model['imageUrl'],
                height: 135,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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

  _buildHighlightList() {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        if (value.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'กิจกรรมน่าสนใจ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              ListView.separated(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: value.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _buildEventCard(value[index]);
                },
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }

  _buildTodayList() {
    return ValueListenableBuilder<List<dynamic>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        if (value.isNotEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  'กิจกรรมวันนี้',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: 10),
              ListView.separated(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: value.length,
                separatorBuilder: (context, index) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return _buildEventCard(value[index]);
                },
              ),
            ],
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}

/// default events.
///
/// Using a [LinkedHashMap] is highly recommended if you decide to use a map.
final kEvents = LinkedHashMap<DateTime, List<dynamic>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(1, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => [
          {
            "code": "",
            "dateStart": "20201222",
            "dateEnd": "20201225",
            "title": "",
            "imageUrl": ""
          }
        ]);
// ..addAll({
//   kToday: [
//     Event('', '', ''),
//   ],
// });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 1, kToday.month, kToday.day);
