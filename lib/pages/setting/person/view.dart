import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/widget/gy_scaffold.dart';

class PersonPage extends BaseGetPageView<PersonController, PersonState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: '个人中心',
      body: title,
    );
  }

  @override
  PersonController getController() {
    return PersonController();
  }

  Widget get title {
    return Container(
      height: 180.h,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.fromLTRB(20, 30, 30, 20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [getAvatar, getName]),
      ]),
    );
  }

  Widget get getName {
    var settingCtrl = Get.find<SettingController>();
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text.rich(TextSpan(text: settingCtrl.user!.name)),
    );
  }

  Widget get getAvatar {
    var settingCtrl = Get.find<SettingController>();
    var avatar = settingCtrl.user!.shareInfo.avatar;
    var thumbnail = avatar!.thumbnail!.split(",")[1];
    thumbnail = thumbnail.replaceAll('\r', '').replaceAll('\n', '');
    var size = 100.w;
    return AdvancedAvatar(
      decoration: const BoxDecoration(
        // shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(18.0)),
      ),
      child: Image(
        width: size,
        height: size,
        image: MemoryImage(base64Decode(thumbnail)),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      ),
    );
  }
}

class PersonController extends BaseController<PersonState> {
  // final Rx<IPerson?> _user = Rxn();
  // IPerson? get user => _user.value;
  // StreamSubscription<User>? _userSub;

  // /// 是否已登录
  // bool get signed {
  //   return _user.value?.target.id != null;
  // }
}

class PersonState extends BaseGetState {
  late final Person person;
}

class PersonBinding extends BaseBindings<PersonController> {
  @override
  PersonController getController() {
    return PersonController();
  }
}
