import 'package:event_bus/event_bus.dart';

class XEventBus {
  static EventBus? _instance;

  static EventBus get instance {
    _instance ??= EventBus();
    return _instance!;
  }
}

class User{
  late Map<String,dynamic> person;
  User(this.person);
}

class SignIn {}

class SignOut {}
