import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/text_avatar.dart';
import 'package:orginone/components/text_search.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/components/unified_text_style.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/pages/setting/organization/groups/groups_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class GroupsPage extends GetView<GroupsController> {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("我的集团", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body,
    );
  }

  get _body => Column(
        children: [
          TextSearch(searchingCallback: controller.searchingCallback),
          Expanded(
            child: Scrollbar(
              child: RefreshIndicator(
                onRefresh: () async {
                  // controller.onLoadGroups("");
                },
                child: _list,
              ),
            ),
          ),
        ],
      );

  get _list => GetBuilder<GroupsController>(
        init: controller,
        builder: (controller) => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.groups.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(controller.groups[index]);
          },
        ),
      );

  Widget _item(Target targetResp) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.personDetail, arguments: targetResp.team?.code);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Row(
          children: [
            TextAvatar(
              avatarName: StringUtil.getAvatarName(
                avatarName: targetResp.name,
                type: TextAvatarType.chat,
              ),
            ),
            Container(margin: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
            Expanded(child: Text(targetResp.name, style: text16))
          ],
        ),
      ),
    );
  }
}
