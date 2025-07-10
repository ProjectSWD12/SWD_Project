import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:tour_guide_manager/colors.dart';


String formatManual(int d, int m) {
  const months = [
    'января','февраля','марта','апреля','мая','июня',
    'июля','августа','сентября','октября','ноября','декабря',
  ];
  return '$d ${months[m - 1]}';
}

double fs(double base) =>
    base * (ScreenUtil().scaleWidth < 1 ? ScreenUtil().scaleWidth : 1);


class Calendar extends StatefulWidget {
  const Calendar({super.key});
  @override State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<ExcursionModel> excursions = [];
  DateTime _selectedDate = DateTime.now();
  bool isLoading = false;
  String message = 'Нет экскурсий';

  final weekdays = ['Пн','Вт','Ср','Чт','Пт','Сб','Вс'];
  final fullWeekdays = [
    'понедельник','вторник','среда','четверг',
    'пятница','суббота','воскресенье'
  ];

  @override
  void initState() {
    super.initState();
    _loadExcursions(_selectedDate);
  }

  Future<void> _loadExcursions(DateTime date) async {
    setState(() { isLoading = true; message = 'Нет экскурсий'; });
    final formatted = DateFormat('yyyy-MM-dd').format(date);

    try {
      final email = FirebaseAuth.instance.currentUser!.email!;
      final snap  = await FirebaseFirestore.instance
          .collection('excursions')
          .where('assignedTo', isEqualTo: email)
          .where('date',       isEqualTo: formatted)
          .orderBy('time')
          .get();

      excursions = snap.docs.map((d) {
        final m = d.data() as Map<String,dynamic>;
        return ExcursionModel(
          people       : m['people'] ?? 0,
          route        : m['route']  ?? 'не указан',
          type         : m['type']   ?? 'Экскурсия',
          time         : m['time']   ?? 'не указано',
          meetingPlace : m['meetingPlace'] ?? 'не указано',
          lunch        : (m['lunch'] ?? false)       ? 'да' : 'нет',
          masterClass  : (m['masterClass'] ?? false) ? 'да' : 'нет',
        );
      }).toList();
      setState(() {});
    } catch (_) {
      setState(() { excursions = []; message = 'Ошибка загрузки'; });
    } finally { setState(() => isLoading = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Мои экскурсии',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: fs(18))),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          SizedBox(
            height: 96,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  const int totalDays = 14;
                  const double spacing = 8;          
                  const double minBtn = 56;         

                  final double neededWidth = totalDays * minBtn + (totalDays - 1) * spacing;

                  final bool showAll = constraints.maxWidth >= neededWidth;

                  final double btnWidth = showAll
                      ? (constraints.maxWidth - (spacing * (totalDays - 1))) / totalDays
                      : minBtn;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics:
                    showAll ? const NeverScrollableScrollPhysics() : const BouncingScrollPhysics(),
                    itemCount: totalDays,
                    itemBuilder: (context, index) {
                      final DateTime date = DateTime.now().add(Duration(days: index));
                      final String weekday = weekdays[date.weekday - 1];
                      final bool isSelected = date.year == _selectedDate.year &&
                          date.month == _selectedDate.month &&
                          date.day == _selectedDate.day;

                      return SizedBox(
                        width: btnWidth,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:
                            isSelected ? AppColors.darkBlue : Colors.white,
                            foregroundColor:
                            isSelected ? Colors.white : AppColors.darkGrey,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            _loadExcursions(date);
                            setState(() => _selectedDate = date);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${date.day}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                              Text(weekday,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => const SizedBox(width: spacing),
                  );
                },
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.fromLTRB(0, 8.h, 0, 16.h),
            child: Text(
              '${formatManual(_selectedDate.day,_selectedDate.month)}, '
                  '${fullWeekdays[_selectedDate.weekday-1]}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color     : AppColors.darkGrey,
                fontSize  : fs(20),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.darkBlue))
                : excursions.isEmpty
                ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(height: 40.h),
                SvgPicture.asset('assets/no_data.svg',
                    width: 0.7.sw, height: 0.33.sh),
                Text(message,
                    style: TextStyle(fontSize: fs(20), fontWeight: FontWeight.w500)),
                SizedBox(height: 60.h),
              ],
            )
                : ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: excursions.length,
              itemBuilder: (_, i) => ExcursionCard(model: excursions[i]),
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
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
      margin : EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color        : Colors.white,
        borderRadius : BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(model.type,
                  style: TextStyle(fontSize: fs(17),
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey)),
              Text(model.time,
                  style: TextStyle(fontSize: fs(17),
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkGrey)),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'Место встречи: ${model.meetingPlace}\n'
                'Маршрут: ${model.route}\n'
                'Кол-во человек: ${model.people}\n'
                'Обед: ${model.lunch}\n'
                'Мастер-класс: ${model.masterClass}',
            style: TextStyle(
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
              fontSize: fs(14),
            ),
          ),
        ],
      ),
    );
  }
}

class ExcursionModel {
  final int    people;
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
