import 'package:flutter_test/flutter_test.dart';
import 'package:tour_guide_manager/screens/calendar.dart';

void main() {
  test('ExcursionModel initializes correctly', () {
    final model = ExcursionModel(
      type: 'Обзорная',
      time: '10:00',
      people: 25,
      route: 'Красная площадь',
      meetingPlace: 'У входа',
      lunch: 'да',
      masterClass: 'нет',
    );

    expect(model.type, 'Обзорная');
    expect(model.time, '10:00');
    expect(model.people, 25);
    expect(model.route, 'Красная площадь');
    expect(model.meetingPlace, 'У входа');
    expect(model.lunch, 'да');
    expect(model.masterClass, 'нет');
  });
}
