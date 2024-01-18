import 'package:flutter/material.dart';
import 'package:orginone/components/base/group_nav_list/base_group_nav_list_controller.dart';

class BaseGroupNavListInstance {
  factory BaseGroupNavListInstance() =>
      _getInstance ??= const BaseGroupNavListInstance._();

  const BaseGroupNavListInstance._();

  static BaseGroupNavListInstance? _getInstance;

  static final Map<String, _BaseGroupNavListInstance> _breadcrumbNav = {};

  void put(BaseGroupNavListController controller, {String? tag}) {
    var router = ModalRoute.of(controller.context)?.settings.name;

    if (router != null) {
      var info = controller.state.bcNav.last;
      info.route = router;
      _breadcrumbNav[router + (tag ?? "")] =
          _BaseGroupNavListInstance(router, controller, tag);
    }
  }

  BaseGroupNavListController? find(String router, {String? tag}) {
    return _breadcrumbNav[router + (tag ?? "")]?.controller;
  }

  BaseGroupNavListController? previous() {
    if (_breadcrumbNav.isEmpty) {
      return null;
    }
    return _breadcrumbNav.values.last.controller;
  }

  void pop() {
    var router = _breadcrumbNav.keys.last;
    _breadcrumbNav.remove(router);
  }
}

class _BaseGroupNavListInstance {
  late String route;
  late BaseGroupNavListController controller;
  String? tag;

  _BaseGroupNavListInstance(this.route, this.controller, this.tag);
}
