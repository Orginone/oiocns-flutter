//路由 Pages
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';

class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];
  //列表
  static List<GetPage> list = [
    // GetPage(
    //   name: RouteNames.home,
    //   page: () => const HomePage(),
    //   binding: MainBinding(),
    // ),
    // GetPage(
    //   name: RouteNames.myMyIndex,
    //   page: () => const MyIndexPage(),
    // ),
  ];
}
