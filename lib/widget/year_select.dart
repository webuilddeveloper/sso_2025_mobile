// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class YearSelectWidget extends StatefulWidget {
  const YearSelectWidget({
    Key? key,
    this.current = 0,
    this.start = 60,
    required this.changed,
  }) : super(key: key);
  final int start;
  final int current;
  final Function changed;

  @override
  State<YearSelectWidget> createState() => _YearSelectWidgetState();
}

class _YearSelectWidgetState extends State<YearSelectWidget> {
  List<int> yearList = [];
  int current = 0;
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController(initialItem: current - 3);
    _setYear();
  }

  _setYear() {
    if (widget.current > 0) {
      current = widget.current;
    } else {
      current = DateTime.now().year;
    }
    for (
      int i = DateTime.now().year - widget.start;
      i <= DateTime.now().year;
      i++
    ) {
      yearList.add(i + 543);
    }
    yearList = yearList.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: _controller,
      itemExtent: 50,
      diameterRatio: 1.4,
      perspective: 0.005,
      // controller: ,
      physics: const FixedExtentScrollPhysics(),
      onSelectedItemChanged:
          (value) => {
            setState(() {
              current = yearList[value];
            }),
            widget.changed(current),
          },
      childDelegate: ListWheelChildBuilderDelegate(
        childCount: yearList.length,
        builder:
            (_, __) => Text(
              yearList[__].toString(),
              style: TextStyle(
                color:
                    current == yearList[__]
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                fontSize: current == yearList[__] ? 25 : 17,
                fontWeight:
                    current == yearList[__]
                        ? FontWeight.bold
                        : FontWeight.normal,
              ),
            ),
      ),
    );
  }
}
