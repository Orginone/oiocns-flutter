import 'package:event_bus/event_bus.dart';

class XEventBus {
  static EventBus? instance;

  static EventBus get getInstance {
    instance ??= EventBus();
    return instance!;
  }
}

class Signed {}
