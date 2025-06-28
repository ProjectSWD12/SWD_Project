import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  test('Formats date as yyyy-MM-dd', () {
    final date = DateTime(2025, 6, 26);
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    expect(formatted, '2025-06-26');
  });
}
