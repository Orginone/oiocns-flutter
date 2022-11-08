import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/index_bar.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/logic/authority.dart';
import 'package:orginone/page/home/message/contact/contact_controller.dart';
import 'package:orginone/page/home/search/search_controller.dart';
import 'package:orginone/public/loading/load_status.dart';
import 'package:orginone/public/view/base_view.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import '../../../../component/a_font.dart';

///联系人页面
class ContactPage extends BaseView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  LoadStatusX initStatus() {
    return LoadStatusX.loading;
  }

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
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: controller.mData.length,
          itemBuilder: (context, index) {
            return item(controller.mData[index]);
          }),
    );
  }

  /// 联系人列表item
  Widget item(TargetResp targetResp) {
    if (targetResp.id == "-101") {
      return Container(
          color: UnifiedColors.lineLight,
          padding: EdgeInsets.only(left: 40.w, top: 10.h, bottom: 10.h),
          child: Text(
            targetResp.name,
            style: AFont.instance.size20themeColorW500,
          ));
    }
    return Column(children: [
      Container(
        color: Colors.white,
        child: ListTile(
          onTap: (){
            var msgItem = controller.getMsgItem(targetResp);
            Map<String, dynamic> args = {
              "spaceId": auth.userId,
              "messageItemId": msgItem.id
            };
            Get.toNamed(Routers.chat, arguments: args);
          },
            leading: TextAvatar(
              avatarName: StringUtil.getAvatarName(
                avatarName: targetResp.name,
                type: TextAvatarType.chat,
              ),
            ),
            title: Text(targetResp.name, style: AFont.instance.size22Black3),
            subtitle: Text(targetResp.team?.name ?? "", style: AFont.instance.size20Black9),
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
    return GetBuilder<ContactController>(
      init: controller,
      builder: (controller) => Visibility(
        visible: controller.isVisibility(),
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
              child: Text(controller.getBarStr(), style: AFont.instance.size28White),
            ),
          ),
        ),
      ),
    );
  }
}
