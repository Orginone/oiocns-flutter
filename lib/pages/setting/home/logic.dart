import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/event_bus.dart';

import 'state.dart';

class SettingCenterController extends BaseController<SettingCenterState>
    with GetTickerProviderStateMixin {
  String currentKey = "";
  final Rx<IPerson?> _user = Rxn();
  final Rx<ICompany?> _curSpace = Rxn();

  StreamSubscription<User>? _userSub;
  final SettingCenterState state = SettingCenterState();

  SettingCenterController() {
    state.tabController = TabController(length: tabTitle.length, vsync: this);
  }
}
