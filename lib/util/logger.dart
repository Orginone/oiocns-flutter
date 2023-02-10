import 'package:logging/logging.dart';

class Log {
  static final Logger _log = Logger("logger");

  static info(dynamic msg) {
    _log.info(msg);
  }
}
