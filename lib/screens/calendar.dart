import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<ExcursionModel> excursions = [];
  final List<String> weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  Future<void> _loadExcursions(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String userEmail = FirebaseAuth.instance.currentUser!.email!;
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('excursions')
        .where('assignedTo', isEqualTo: userEmail).get();
    List<ExcursionModel> parsedExcursions = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String excursionDate = data['date'];
      if (excursionDate == formattedDate) {
        int people = data['people'];
        String route = data['route'];
        String type = data['type'];
        String time = data['time'];
        parsedExcursions.add(ExcursionModel(type, time, people, route));
      }
    }
    setState(() {
      excursions = parsedExcursions;
    });
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
              padding: EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final date = DateTime.now().add(Duration(days: index));
                  final weekday = weekdays.elementAt(date.weekday - 1);
                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color(0xff333333),
                      minimumSize: Size(46, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () { _loadExcursions(date); },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          weekday,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8),
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: excursions.isEmpty ?
            Text("Нет экскурсий") :
            ListView.separated(
              itemCount: excursions.length,
              itemBuilder: (context, index) {
                ExcursionModel excursionModel = excursions.elementAt(index);
                return Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      Text('${excursionModel.type} ${excursionModel.time}'),
                      Text(excursionModel.route),
                      Text('${excursionModel.people}'),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class ExcursionModel {
  int people;
  String time;
  String type;
  String route;

  ExcursionModel(this.type, this.time, this.people, this.route);
}
