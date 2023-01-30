import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/bread_crumb.dart';
import 'package:orginone/components/text_avatar.dart';
import 'package:orginone/components/text_search.dart';
import 'package:orginone/components/text_tag.dart';
import 'package:orginone/components/unified_colors.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/components/unified_text_style.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/dart/base/model/tree_node.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/pages/setting/organization/dept/dept_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class DeptPage extends GetView<DeptController> {
  const DeptPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text(
        auth.spaceInfo.name,
        style: AFont.instance.size22Black3,
      ),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextSearch(
            margin: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
            searchingCallback: controller.searchingCallback,
          ),
          BreadCrumb(
            padding: EdgeInsets.only(left: 25.w, right: 25.w),
            width: 540.w,
            height: 50.h,
            stackBottomStyle: TextStyle(
              fontSize: 20.sp,
              color: UnifiedColors.themeColor,
            ),
            stackTopStyle: TextStyle(fontSize: 20.sp),
            controller: controller.breadCrumbController,
            popsCallback: (Item<String> item) => controller.popsNode(item),
          ),
          Expanded(
            child: GetBuilder<DeptController>(builder: (controller) {
              var children = controller.currentNode?.children ?? [];
              var persons = controller.persons;
              return ListView.builder(
                itemCount: children.length + persons.length,
                itemBuilder: (BuildContext context, int index) {
                  if (index < children.length) {
                    return _nodeItem(children[index]);
                  }
                  return _personItem(persons[index - children.length]);
                },
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _nodeItem(TreeNode node) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => controller.entryNode(node),
          child: Container(
            margin: EdgeInsets.only(
              left: 25.w,
              right: 25.w,
              top: 15.h,
              bottom: 15.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(node.label, style: AFont.instance.size22Black0),
                Container(margin: EdgeInsets.only(left: 5.w)),
                TextTag(
                  node.data.typeName,
                  textStyle: AFont.instance.size16themeColorW500,
                  padding: EdgeInsets.all(4.w),
                ),
                Container(margin: EdgeInsets.only(left: 10.w)),
                Text("(${node.children.length})"),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.keyboard_arrow_right),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(height: 0),
      ],
    );
  }

  Widget _personItem(Target person) {
    var name = person.team?.name ?? "";
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        if (Get.isRegistered<MessageController>()) {
          var messageCtrl = Get.find<MessageController>();
          if (auth.userId == person.id) {
            await messageCtrl.setCurrent(auth.userId, person.id);
          } else {
            await messageCtrl.setCurrent(auth.spaceId, person.id);
          }
          Get.toNamed(Routers.chat);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextAvatar(
              avatarName: StringUtil.getAvatarName(
                avatarName: name,
                type: TextAvatarType.chat,
              ),
              width: 60.w,
            ),
            Container(margin: EdgeInsets.only(left: 10.w)),
            Text(name, style: text18)
          ],
        ),
      ),
    );
  }
}
