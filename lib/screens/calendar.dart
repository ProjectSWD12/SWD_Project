import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<ExcursionModel> excursions = [];
  final List<String> weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  Future<void> _loadExcursions() async {
    // database request
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffE6F2FF),
        title: Text('Мои экскурсии'),
        centerTitle: true,
      ),
      backgroundColor: Color(0xffE6F2FF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 82,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final weekday = weekdays.elementAt(date.weekday - 1);
                  return GestureDetector(
                    onTap: _loadExcursions,
                    child: Container(
                      height: 66,
                      width: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(date.day.toString(), style: TextStyle(fontSize: 17)),
                          Text(weekday, style: TextStyle(fontSize: 14)),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class ExcursionModel {
  int people;
  String time;
  String type;

  ExcursionModel(this.type, this.time, this.people);
}
