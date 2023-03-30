import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/event_bus.dart';
import 'package:orginone/widget/gy_scaffold.dart';

class PersonPage extends BaseGetPageView<PersonController, PersonState> {
  // PersonPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: '个人中心',
      body: Column(children: [
        Expanded(
            child: Row(children: [
          // Obx(() {
          //   // controller.state.
          //   return Obx(() => controller.signed
          //       ? TextAvatar(
          //           radius: 45.w,
          //           width: 45.w,
          //           avatarName: controller.user!.name.substring(0, 1),
          //           textStyle: XFonts.size22White,
          //           // margin: insets,
          //         )
          //       : Container());
          // }),
        ])),
      ]),
    );
  }

  @override
  PersonController getController() {
    return PersonController();
  }
}

class PersonController extends BaseController<PersonState> {
  final Rx<IPerson?> _user = Rxn();
  IPerson? get user => _user.value;
  StreamSubscription<User>? _userSub;

  /// 是否已登录
  bool get signed {
    return _user.value?.target.id != null;
  }
}

class PersonState extends BaseGetState {}

class PersonBinding extends BaseBindings<PersonController> {
  @override
  PersonController getController() {
    return PersonController();
  }
}
