import 'dart:async';

import 'package:event_bus/event_bus.dart';

class EventBusHelper {
  static final EventBus _instance = EventBus(sync: true);
  static final Map<dynamic, StreamSubscription> _map = {};

  static Stream<T> on<T>() {
    return _instance.on<T>();
  }

  static StreamSubscription<T> listen<T>(void onData(T event),
      {Function? onError, void onDone()?, bool? cancelOnError}) {
    return on<T>().listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  static void register(context, void onData(event),
      {Function? onError, void onDone()?, bool? cancelOnError}) {
    unregister(context);
    _map[context] = listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  static void unregister(context) {
    _map.remove(context)?.cancel();
  }

  static void fire(event) {
    _instance.fire(event);
  }

  static void destroy() {
    _instance.destroy();
  }
}
