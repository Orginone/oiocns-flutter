import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/util/string_util.dart';

import '../../../../api_resp/target_resp.dart';
import '../../../../component/text_avatar.dart';
import '../../../../component/text_search.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../component/unified_text_style.dart';
import '../../../../routers.dart';
import '../../../../util/widget_util.dart';
import 'groups_controller.dart';

class GroupsPage extends GetView<GroupsController> {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("我的集团", style: text20),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body,
    );
  }

  get _body => Column(
        children: [
          TextSearch(controller.searchingCallback),
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

  Widget _item(TargetResp targetResp) {
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
