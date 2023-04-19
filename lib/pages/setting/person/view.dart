import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/local_store.dart';
import 'package:orginone/widget/gy_scaffold.dart';

class PersonPage extends BaseGetPageView<PersonController, PersonState> {
  // var list = List.of(['carBag', 'security', 'dynamic', 'mark']);
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: '个人中心',
      body: body,
    );
  }

  @override
  PersonController getController() {
    return PersonController();
  }

  Widget get body {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 170.h,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [getAvatar, getName]),
            )),
        // 卡包
        Container(
          height: 5,
        ),
        const Item(
          goTo: Routers.cardbag,
          alignment: MainAxisAlignment.spaceBetween,
          text: Text.rich(TextSpan(text: "卡包")),
        ),
        Container(
          height: 5,
        ),
        //安全
        const Item(
          goTo: Routers.security,
          alignment: MainAxisAlignment.spaceBetween,
          text: Text.rich(TextSpan(text: "安全")),
        ),
        Container(
          height: 5,
        ),
        //动态
        const Item(
          goTo: Routers.dynamic,
          alignment: MainAxisAlignment.spaceBetween,
          text: Text.rich(TextSpan(text: "动态")),
        ),
        Container(
          height: 5,
        ),
        //收藏
        const Item(
          goTo: Routers.mark,
          alignment: MainAxisAlignment.spaceBetween,
          text: Text.rich(TextSpan(text: "收藏")),
        ),
        Container(
          height: 5,
        ),
        //注销登录
        const Item(
          goTo: Routers.login,
          alignment: MainAxisAlignment.center,
          text: Text.rich(TextSpan(text: "注 销 登 录"),
              style: TextStyle(color: Colors.red)),
        )
      ],
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
    var name = settingCtrl.user!.name.substring(0, 1);
    var size = 100.w;
    if (avatar == null) {
      return AdvancedAvatar(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: XColors.themeColor,
            shape: BoxShape.rectangle,
          ),
          child: Container(
            alignment: Alignment.center,
            width: size,
            height: size,
            child: Stack(
              children: [
                Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Container(
                    margin: const EdgeInsets.all(2),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    name,
                    style: XFonts.size28White,
                  ),
                )
              ],
            ),
          ));
    }
    var thumbnail = avatar!.thumbnail!.split(",")[1];
    thumbnail = thumbnail.replaceAll('\r', '').replaceAll('\n', '');
    return AdvancedAvatar(
      decoration: const BoxDecoration(
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

class PersonController extends BaseController<PersonState> {}

class PersonState extends BaseGetState {
  late final Person person;
}

class PersonBinding extends BaseBindings<PersonController> {
  @override
  PersonController getController() {
    return PersonController();
  }
}

class Item extends StatelessWidget {
  final String goTo;
  final MainAxisAlignment alignment;
  final Text text;
  const Item({
    super.key,
    required this.goTo,
    required this.alignment,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 80.h,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(30, 5, 20, 5),
          child: GestureDetector(
              onTap: () {
                if(goTo == Routers.login){
                  Get.offAllNamed(goTo);
                  LocalStore.getStore().remove('account');
                  HiveUtils.clean();
                }else{
                  Get.toNamed(goTo);
                }
              },
              child: Row(
                mainAxisAlignment: alignment,
                children: [
                  text,
                  if (goTo != Routers.login)
                    const Icon(
                      Icons.navigate_next,
                    )
                ],
              )),
        ));
  }
}
