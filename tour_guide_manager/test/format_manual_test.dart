import 'package:flutter_test/flutter_test.dart';
import 'package:tour_guide_manager/screens/calendar.dart';

void main() {
  test('Correctly formats date (manual)', () {
    expect(formatManual(5, 1), '5 января');
    expect(formatManual(26, 6), '26 июня');
    expect(formatManual(1, 12), '1 декабря');
  });
}
