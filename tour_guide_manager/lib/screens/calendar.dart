import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_manager/colors.dart';

String formatManual(int day, int month) {
  const months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];
  return '$day ${months[month - 1]}';
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<ExcursionModel> excursions = [];
  DateTime _selectedDate = DateTime.now();
  bool isLoading = false;
  String message = 'Нет экскурсий';

  final List<String> weekdays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  final List<String> fullWeekdays = [
    'понедельник', 'вторник', 'среда', 'четверг',
    'пятница', 'суббота', 'воскресенье'
  ];

  @override
  void initState() {
    super.initState();
    _loadExcursions(_selectedDate);
  }

  Future<void> _loadExcursions(DateTime date) async {
    setState(() {
      isLoading = true;
      message = 'Нет экскурсий';
    });

    final String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    try {
      final String userEmail = FirebaseAuth.instance.currentUser!.email!;
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore.collection('excursions')
          .where('assignedTo', isEqualTo: userEmail)
          .where('date', isEqualTo: formattedDate)
          .orderBy('time')
          .get();

      final List<ExcursionModel> parsedExcursions = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final int people = data['people'] ?? 0;
        final String route = data['route'] ?? 'не указан';
        final String type = data['type'] ?? 'Экскурсия';
        final String time = data['time'] ?? 'не указано';
        final String meetingPlace = data['meetingPlace'] ?? 'не указано';
        final String hasLunch = (data['lunch'] ?? false) ? 'да' : 'нет';
        final String hasMasterClass = (data['masterClass'] ?? false) ? 'да' : 'нет';
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
    } catch (e) {
      setState(() {
        excursions = [];
        message = 'Ошибка загрузки';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text(
          'Мои экскурсии',
          style: TextStyle(fontWeight: FontWeight.w600)
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 82,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 8,
              ),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, index) {
                  final DateTime date = DateTime.now().add(Duration(days: index));
                  final String weekday = weekdays.elementAt(date.weekday - 1);
                  final bool isSelected = date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;

                  return TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isSelected ? AppColors.darkBlue : Colors.white,
                      foregroundColor: isSelected ? Colors.white : AppColors.darkGrey,
                      minimumSize: const Size(46, 66),
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
                          style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500
                          ),
                        ),
                        Text(
                          weekday,
                          style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(width: 8),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
            child: Text(
              '${formatManual(_selectedDate.day, _selectedDate.month)}, ${fullWeekdays[_selectedDate.weekday - 1]}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.darkGrey,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: isLoading ?
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.darkBlue,
              ),
            ) : excursions.isEmpty ?
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                SvgPicture.asset(
                  'assets/no_data.svg',
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.33,
                ),
                Text(
                  message,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 60),
              ],
            ) :
            ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: excursions.length,
              itemBuilder: (context, index) {
                return ExcursionCard(model: excursions[index]);
              },
              separatorBuilder: (context, index) => const SizedBox(height: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class ExcursionCard extends StatelessWidget {
  const ExcursionCard({required this.model, super.key});
  final ExcursionModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
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
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              Text(
                model.time,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Место встречи: ${model.meetingPlace}\n'
            'Маршрут: ${model.route}\n'
            'Кол-во человек: ${model.people}\n'
            'Обед: ${model.lunch}\n'
            'Мастер-класс: ${model.masterClass}',
            style: const TextStyle(color: AppColors.grey, fontWeight: FontWeight.w500),
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
