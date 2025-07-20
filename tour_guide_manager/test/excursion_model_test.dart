import 'package:flutter_test/flutter_test.dart';
import 'package:tour_guide_manager/screens/calendar.dart';

void main() {
  test('ExcursionModel initializes correctly', () {
    final model = ExcursionModel(
      title: 'Обзорная',
      startTime: '10:00',
      people: 25,
      route: 'Красная площадь',
      meetingPlace: 'У входа',
      lunch: 'да',
      masterClass: 'нет',
      endTime: '12:00',
      paymentStatus: 'Оплачено',
    );

    expect(model.title, 'Обзорная');
    expect(model.startTime, '10:00');
    expect(model.endTime, '12:00');
    expect(model.people, 25);
    expect(model.route, 'Красная площадь');
    expect(model.meetingPlace, 'У входа');
    expect(model.lunch, 'да');
    expect(model.masterClass, 'нет');
  });
}
