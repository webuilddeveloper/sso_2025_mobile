import 'package:flutter/material.dart';

listViewSearch(model) {
  return FutureBuilder<dynamic>(
    future: model,
    builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.hasData) {
        return Wrap(
          runSpacing: 10,
          spacing: 10,
          children: snapshot.data
              .map<Widget>((e) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color(0xFFE8F0F6),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        e['title'],
                        style: TextStyle(
                          color: Color(0xFF005C9E),
                          fontSize: 15.0,
                          fontWeight: FontWeight.normal,
                          letterSpacing: 1.2,
                          fontFamily: 'Kanit',
                        ),
                      ),
                    ),
                  ))
              .toList(),
        );
      } else {
        return Container();
      }
    },
  );
}
