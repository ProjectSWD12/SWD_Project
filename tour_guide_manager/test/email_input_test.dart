import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  test('Email controller holds input value', () {
    final controller = TextEditingController();
    controller.text = 'user@example.com';
    expect(controller.text, contains('@'));
    expect(controller.text.endsWith('.com'), true);
  });
}
