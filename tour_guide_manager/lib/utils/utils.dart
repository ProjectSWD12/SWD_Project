import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatManual(int day, int month) {
  const months = [
    'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
    'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
  ];
  return '$day ${months[month - 1]}';
}

String formatTime(Timestamp date) {
  final dt = date.toDate().toLocal();
  return DateFormat('HH:mm').format(dt);
}

String formatDate(Timestamp date) {
  final dt = date.toDate().toLocal();
  return formatManual(dt.day, dt.month);
}