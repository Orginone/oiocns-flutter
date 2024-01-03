import 'package:logger/logger.dart';

class LogUtil {
  static Logger _logger = Logger(
    printer: PrefixPrinter(PrettyPrinter(
      stackTraceBeginIndex: 1,
      methodCount: 1,
      lineLength: 12800,
      printEmojis: true,
      colors: true,
    )),
  );

  static void d(dynamic message, {String? tag}) {
    _logger.d(message);
  }

  static void v(dynamic message) {
    _logger.v(message);
  }

  static void i(dynamic message) {
    _logger.i(message);
  }

  static void w(dynamic message) {
    _logger.w(message);
  }

  static void e(dynamic message) {
    _logger.e(message);
  }

  static void wtf(dynamic message) {
    _logger.wtf(message);
  }
}
