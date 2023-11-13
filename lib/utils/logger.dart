import 'package:logging/logging.dart';

class Log {
  static final Logger logger = Logger("logger");

  static info(dynamic msg) {
    logger.info(msg);
  }
}

final logger = Log.logger;
