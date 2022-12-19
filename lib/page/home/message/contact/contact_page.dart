import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/component/index_bar.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/page/home/message/contact/contact_controller.dart';
import 'package:orginone/page/home/search/search_controller.dart';
import 'package:orginone/public/view/base_view.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import '../../../../component/a_font.dart';

///联系人页面
class ContactPage extends BaseView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  String getTitle() {
    return "我的联系人";
  }

  @override
  bool isUseScaffold() {
    return true;
  }

  @override
  List<Widget> actions() {
    return [
      GFIconButton(
        color: Colors.white.withOpacity(0),
        icon: const Icon(Icons.person_add_alt, color: Colors.black),
        onPressed: () {
          List<SearchItem> friends = [SearchItem.friends];
          Get.toNamed(Routers.search, arguments: {
            "items": friends,
            "point": FunctionPoint.addFriends,
          });
        },
      ),
    ];
  }

  @override
  Widget builder(BuildContext context) {
    return Stack(children: [_contactList(), _indexList(), _stickIndexBar()]);
  }

  /// 联系人列表
  Widget _contactList() {
    return GetBuilder<ContactController>(
      init: controller,
      builder: (controller) => ListView.builder(
          key: controller.mGlobalKey,
          shrinkWrap: true,
          controller: controller.mScrollController,
          scrollDirection: Axis.vertical,
          itemCount: controller.mData.length,
          itemBuilder: (context, index) {
            return item(controller.mData[index]);
          }),
    );
  }

  /// 联系人列表item
  Widget item(Target target) {
    if (target.id == "-101") {
      return Container(
          color: UnifiedColors.lineLight,
          height: 45.h,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 40.w),
          child: Text(
            target.name,
            style: AFont.instance.size20themeColorW500,
          ));
    }
    return Column(children: [
      Container(
        color: Colors.white,
        height: 110.h,
        child: ListTile(
            onTap: () async {
              var messageCtrl = Get.find<MessageController>();
              bool success = await messageCtrl.setCurrent(
                auth.userId,
                target.id,
              );
              if (!success) {
                Fluttertoast.showToast(msg: "未获取到会话信息！");
                return;
              }
              Get.toNamed(Routers.chat);
            },
            leading: TextAvatar(
              avatarName: StringUtil.getAvatarName(
                avatarName: target.name,
                type: TextAvatarType.chat,
              ),
            ),
            title: Text(target.name, style: AFont.instance.size22Black3),
            subtitle: Text(target.team?.name ?? "",
                style: AFont.instance.size20Black9),
            contentPadding: EdgeInsets.only(left: 30.w)),
      ),
      Container(
          padding: EdgeInsets.only(left: 72.w, right: 10.w),
          child: Divider(height: 1.5.h, color: UnifiedColors.lineLight))
    ]);
  }

  /// 索引widget
  _indexList() {
    return Align(
      alignment: Alignment.centerRight,
      child: GetBuilder<ContactController>(
          init: controller,
          builder: (controller) => IndexBar(
              mData: controller.mIndex,
              indexBarCallBack: (str, index, touchUp) {
                controller.updateIndex(index, touchUp);
              })),
    );
  }

  /// 触摸索引显示的view
  _stickIndexBar() {
    return Obx(() => Visibility(
          visible: !controller.mTouchUp.value,
          child: Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(5.w))),
              width: 100.w,
              height: 100.w,
              child: Align(
                alignment: Alignment.center,
                child: Text(controller.mTouchChar.value,
                    style: AFont.instance.size28White),
              ),
            ),
          ),
        ));
  }
}
