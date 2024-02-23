import 'dart:async';
import 'package:event_bus/event_bus.dart';

class EventBusUtil {
  // 工厂模式
  factory EventBusUtil() => _getInstance();
  static EventBusUtil get instance => _getInstance();
  static EventBusUtil? _instance;

  EventBusUtil._internal();

  static EventBusUtil _getInstance() {
    _instance ??= EventBusUtil._internal();
    return _instance!;
  }

  final EventBus _eventBus = EventBus();

  EventBus get eventBus {
    return _eventBus;
  }

  // 发送事件
  void fire(Object event) {
    eventBus.fire(event);
  }

  // 订阅事件
  StreamSubscription<T>? on<T>(void Function(T event) onEvent) {
    return eventBus.on<T>().listen((event) {
      onEvent(event);
    });
  }

  // 取消订阅
  void cancel(StreamSubscription subscription) {
    subscription.cancel();
  }
}
