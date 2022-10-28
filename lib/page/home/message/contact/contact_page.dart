import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/index_bar.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/message/contact/contact_controller.dart';
import 'package:orginone/page/home/search/search_controller.dart';
import 'package:orginone/public/loading/loading_widget.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

///联系人页面
class ContactPage extends GetView<ContactController> {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarCenterTitle: true,
      appBarTitle: Text(
        "我的联系人",
        style: text16,
      ),
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarActions: _actions,
      bgColor: UnifiedColors.white,
      body: LoadingWidget(controller: controller,
      builder:(context)=> Stack(children: [_contactList(), _indexList(), _stickIndexBar()])),
    );
  }

  ///右侧按钮
  get _actions => <Widget>[
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
            style: text16,
          ));
    }
    return Column(children: [
      Container(
        color: Colors.white,
        child: ListTile(
            leading: TextAvatar(
              avatarName: StringUtil.getAvatarName(
                avatarName: targetResp.name,
                type: TextAvatarType.chat,
              ),
            ),
            title: Text(targetResp.name, style: text16),
            subtitle: Text(targetResp.team?.name ?? "", style: text12Grey),
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
            width: 80.w,
            height: 80.h,
            child: Align(
              alignment: Alignment.center,
              child: Text(controller.getBarStr(), style: text25White),
            ),
          ),
        ),
      ),
    );
  }
}
