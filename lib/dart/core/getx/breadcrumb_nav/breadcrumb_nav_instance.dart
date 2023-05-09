import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_breadcrumb_nav_controller.dart';

class BreadcrumbNavInstance {
  factory BreadcrumbNavInstance() =>
      _getInstance ??= const BreadcrumbNavInstance._();

  const BreadcrumbNavInstance._();

  static BreadcrumbNavInstance? _getInstance;

  static final Map<String, _BreadcrumbNavInstance> _breadcrumbNav = {};



  void put(BaseBreadcrumbNavController controller,{String? tag}){
    var router = ModalRoute.of(controller.context)?.settings.name;

    if(router!=null){
       var info = controller.state.bcNav.last;
       info.route = router;
      _breadcrumbNav[router+(tag??"")] = _BreadcrumbNavInstance(router,controller,tag);
    }
  }

  BaseBreadcrumbNavController? find(String router,{String? tag}){
   return _breadcrumbNav[router+(tag??"")]?.controller;
  }



  BaseBreadcrumbNavController? previous(){
    if(_breadcrumbNav.isEmpty){
      return null;
    }
    return _breadcrumbNav.values.last.controller;
  }

  void pop(){
    var router = _breadcrumbNav.keys.last;
    _breadcrumbNav.remove(router);
  }
}

class _BreadcrumbNavInstance {
  late String route;
  late BaseBreadcrumbNavController controller;
  String? tag;

  _BreadcrumbNavInstance(this.route,this.controller,this.tag);
}
