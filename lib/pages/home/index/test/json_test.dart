import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Tests for addition', () {
    int a=0, b =0;

    setUp(() {
      a = 2;
      b = 3;
    });

    tearDown(() {
      a = 11;
      b = 12;
    });

    test('Testing addition with positive numbers', () {
      int result = a + b;
      expect(result, equals(5));
    });

    test('Testing addition with negative numbers', () {
      int result = -a + (-b);
      expect(result, equals(-5));
    });
  });
}
