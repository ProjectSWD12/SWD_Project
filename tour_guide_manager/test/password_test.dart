import 'package:flutter_test/flutter_test.dart';

bool isPasswordStrong(String password) => password.length >= 6;

void main() {
  test('Rejects short passwords', () {
    expect(isPasswordStrong('123'), false);
  });

  test('Accepts long passwords', () {
    expect(isPasswordStrong('abcdef455'), true);
  });
}
