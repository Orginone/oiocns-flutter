// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

// ignore_for_file: avoid_print

import 'package:common_utils/common_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Test String', () {
    String str = "dddd不在线aaad";
    LogUtil.d(str.contains('不在线'));
    LogUtil.d(str.contains('ccc'));
  });
}
