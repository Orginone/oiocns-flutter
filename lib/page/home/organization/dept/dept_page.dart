import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/core/authority.dart';

import '../../../../api_resp/target.dart';
import '../../../../api_resp/tree_node.dart';
import '../../../../component/a_font.dart';
import '../../../../component/bread_crumb.dart';
import '../../../../component/text_avatar.dart';
import '../../../../component/text_search.dart';
import '../../../../component/text_tag.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../util/string_util.dart';
import '../../../../util/widget_util.dart';
import '../../home_controller.dart';
import 'dept_controller.dart';

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
          TextSearch(searchingCallback: controller.searchingCallback),
          BreadCrumb(
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
          onTap: () => controller.entryNode(node),
          child: Container(
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
              top: 15.h,
              bottom: 15.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(node.label, style: text20),
                Container(margin: EdgeInsets.only(left: 5.w)),
                TextTag(
                  node.data.typeName,
                  textStyle: text12BlueBold,
                  padding: EdgeInsets.all(4.w),
                ),
                Container(margin: EdgeInsets.only(left: 5.w)),
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
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextAvatar(
            avatarName: StringUtil.getAvatarName(
              avatarName: name,
              type: TextAvatarType.chat,
            ),
            width: 48.w,
          ),
          Container(margin: EdgeInsets.only(left: 10.w)),
          Text(name, style: text18)
        ],
      ),
    );
  }
}
