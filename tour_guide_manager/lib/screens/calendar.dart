import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tour_guide_manager/colors.dart';
import 'package:tour_guide_manager/utils/utils.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<ExcursionModel> _excursions = [];
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  String _message = 'Нет экскурсий';

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
      _isLoading = true;
      _message = 'Нет экскурсий';
    });

    final DateTime startOfDay = DateTime(date.year, date.month, date.day);
    final DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    try {
      final String userEmail = FirebaseAuth.instance.currentUser!.email!;
      final firestore = FirebaseFirestore.instance;
      final QuerySnapshot snapshot = await firestore.collection('excursions')
          .where('assignedGuides', arrayContains: userEmail)
          .where('startDate', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(endOfDay))
          .orderBy('startDate')
          .get();

      final List<ExcursionModel> parsedExcursions = [];
      for (var doc in snapshot.docs) {
        final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        parsedExcursions.add(ExcursionModel.fromJson(data));
      }
      setState(() {
        _excursions = parsedExcursions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _excursions = [];
        _message = 'Ошибка загрузки';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final calendarHeight = screenHeight * 0.09;
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double maxContentWidth = 600;
          final double availableWidth = constraints.maxWidth;
          final double contentWidth = availableWidth > maxContentWidth
              ? maxContentWidth
              : availableWidth;
          return Center(
            child: SizedBox(
              width: contentWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: calendarHeight,
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
                          final DateTime date = DateTime.now().add(
                              Duration(days: index));
                          final String weekday = weekdays.elementAt(
                              date.weekday - 1);
                          final bool isSelected = date.year ==
                              _selectedDate.year &&
                              date.month == _selectedDate.month &&
                              date.day == _selectedDate.day;
                          final buttonHeight = calendarHeight - 16;
                          final buttonWidth = buttonHeight * 0.7;
                          return TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: isSelected
                                  ? AppColors.darkBlue
                                  : Colors.white,
                              foregroundColor: isSelected
                                  ? Colors.white
                                  : AppColors.darkGrey,
                              minimumSize: Size(buttonWidth, buttonHeight),
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
                        separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                    child: Text(
                      '${formatManual(_selectedDate.day,
                          _selectedDate.month)}, ${fullWeekdays[_selectedDate
                          .weekday - 1]}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: AppColors.darkGrey,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                    child: _isLoading ?
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.darkBlue,
                      ),
                    ) : _excursions.isEmpty ?
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          _message == 'Ошибка загрузки'
                              ? 'assets/error.svg' : 'assets/no_data.svg',
                          height: screenHeight *
                              (_message == 'Ошибка загрузки' ? 0.27 : 0.35),
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _message,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ) :
                    ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      itemCount: _excursions.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: ExcursionCard(model: _excursions[index]),
                        );
                      },
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 12),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
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
                model.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkGrey,
                ),
              ),
              Text(
                '${model.startTime}-${model.endTime}',
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
            'Мастер-класс: ${model.masterClass}\n'
            'Статус оплаты: ${model.paymentStatus}',
            style: const TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w500
            ),
          ),
        ],
      )
    );
  }
}

class ExcursionModel {
  final int people;
  final String startTime;
  final String endTime;
  final String title;
  final String route;
  final String meetingPlace;
  final String lunch;
  final String masterClass;
  final String paymentStatus;

  ExcursionModel({
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.people,
    required this.route,
    required this.meetingPlace,
    required this.lunch,
    required this.masterClass,
    required this.paymentStatus,
  });

  factory ExcursionModel.fromJson(Map<String, dynamic> json) {
    return ExcursionModel(
      title: json['title'] ?? 'Экскурсия',
      startTime: formatTime(json['startDate']),
      endTime: formatTime(json['endDate']),
      people: json['maxParticipants'] ?? 0,
      route: json['route'] ?? 'не указан',
      meetingPlace: json['meetingPlace'] ?? 'не указано',
      lunch: json['hasLunch'] ? 'да' : 'нет',
      masterClass: json['hasMasterclass'] ? 'да' : 'нет',
      paymentStatus: json['paymentStatus'] == 'paid' ? 'Оплачено'
          : json['paymentStatus'] == 'partial'
          ? json['paymentAmount'].toString() + 'руб. доплата' : 'Не оплачено'
    );
  }
}
