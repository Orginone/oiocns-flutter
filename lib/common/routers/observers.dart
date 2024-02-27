import 'package:flutter/material.dart';
import 'package:orginone/utils/log/log_util.dart';

import 'index.dart';

/// 记录路由的变化
class RouteObservers<R extends Route<dynamic>> extends RouteObserver<R> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    var name = route.settings.name ?? '';
    if (name.isNotEmpty) {
      RoutePages.history.add(name);
      RoutePages.historyRoute.add(route);
    }
    LogUtil.d('didPush');
    LogUtil.d('did ${RoutePages.history.toString()}');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    RoutePages.history.remove(route.settings.name);
    RoutePages.historyRoute.remove(route);
    LogUtil.d('didPop');
    LogUtil.d('did ${RoutePages.history.toString()}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      var index = RoutePages.history.indexWhere((element) {
        return element == oldRoute?.settings.name;
      });
      var name = newRoute.settings.name ?? '';
      if (name.isNotEmpty) {
        if (index > 0) {
          RoutePages.history[index] = name;
          RoutePages.historyRoute[index] = newRoute;
        } else {
          RoutePages.history.add(name);
          RoutePages.historyRoute.add(newRoute);
        }
      }
    }
    LogUtil.d('didReplace');
    LogUtil.d('did ${RoutePages.history.toString()}');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    RoutePages.history.remove(route.settings.name);
    RoutePages.historyRoute.remove(route);
    LogUtil.d('didRemove');
    LogUtil.d('did ${RoutePages.history.toString()}');
  }
}
