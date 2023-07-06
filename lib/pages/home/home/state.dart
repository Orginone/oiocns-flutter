


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class HomeState extends BaseGetState{
  var currentIndex = 0.obs;
  DateTime? lastCloseApp;
  PageController pageController = PageController(initialPage: 2);
}