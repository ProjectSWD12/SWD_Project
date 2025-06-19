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
  DateTime _selectedDate = DateTime.now();
  final List<String> weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  void initState() {
    super.initState();
    _loadExcursions(_selectedDate);
  }

  Future<void> _loadExcursions(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    String userEmail = FirebaseAuth.instance.currentUser!.email!;

    final firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('excursions')
        .where('assignedTo', isEqualTo: userEmail)
        .where('date', isEqualTo: formattedDate)
        .orderBy('time')
        .get();

    List<ExcursionModel> parsedExcursions = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      int people = data['people'];
      String route = data['route'];
      String type = data['type'];
      String time = data['time'];
      String meetingPlace = data['meetingPlace'];
      String hasLunch = data['lunch'] ? 'да' : 'нет';
      String hasMasterClass = data['masterClass'] ? 'да' : 'нет';
      parsedExcursions.add(
        ExcursionModel(
          people: people,
          route: route,
          type: type,
          time: time,
          meetingPlace: meetingPlace,
          lunch: hasLunch,
          masterClass: hasMasterClass
        )
      );
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
        title: Text('Мои экскурсии', style: TextStyle(fontWeight: FontWeight.w500)),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
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
                  final DateTime date = DateTime.now().add(Duration(days: index));
                  final String weekday = weekdays.elementAt(date.weekday - 1);
                  bool isSelected = date.year  == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day   == _selectedDate.day;

                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isSelected ? Color(0xff005BFF) : Colors.white,
                      foregroundColor: isSelected ? Colors.white : Color(0xff333333),
                      minimumSize: Size(46, 66),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      _loadExcursions(date);
                      setState(() {
                        _selectedDate = date;
                      });
                    },
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
            Center(
              child: Text(
                "Нет экскурсий", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)
              )
            ) :
            ListView.separated(
              itemCount: excursions.length,
              itemBuilder: (context, index) {
                return ExcursionCard(model: excursions[index]);
              },
              separatorBuilder: (context, index) => SizedBox(height: 8),
            ),
          ),
        ],
      ),
    );
  }
}

class ExcursionCard extends StatelessWidget {
  const ExcursionCard({super.key, required this.model});
  final ExcursionModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 24),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  model.type,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
                Text(
                  model.time,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff333333),
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              'Место встречи: ${model.meetingPlace}\n'
              'Маршрут: ${model.route}\n'
              'Кол-во человек: ${model.people}\n'
              'Обед: ${model.lunch}\n'
              'Мастер-класс: ${model.masterClass}',
              style: TextStyle(color: Color(0xff5A5A5A), fontWeight: FontWeight.w500),
            ),
          ],
        )
    );
  }
}

class ExcursionModel {
  final int people;
  final String time;
  final String type;
  final String route;
  final String meetingPlace;
  final String lunch;
  final String masterClass;

  ExcursionModel({
    required this.type,
    required this.time,
    required this.people,
    required this.route,
    required this.meetingPlace,
    required this.lunch,
    required this.masterClass,
  });
}
