import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:tour_guide_manager/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Selecting a date changes the title', (tester) async {
    app.main();
    await tester.pumpAndSettle();
    final dateButtons = find.byType(TextButton);

    final secondDate = DateTime.now().add(Duration(days: 1));
    final day = secondDate.day;
    final month = secondDate.month;
    final weekday = secondDate.weekday;

    const months = [
      'января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
      'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
    ];

    const weekdays = [
      'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота', 'воскресенье'
    ];

    final expectedText = '$day ${months[month - 1]}, ${weekdays[weekday - 1]}';

    await tester.tap(dateButtons.at(1));
    await tester.pumpAndSettle();

    expect(find.text(expectedText), findsOneWidget);
  });
}
