import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tests for addition', () {
    test('Testing addition with positive numbers', () {
      int result = 2 + 2;
      expect(result, equals(4));
    });

    test('Testing addition with negative numbers', () {
      int result = -2 + (-2);
      expect(result, equals(-4));
    });
  });
}
