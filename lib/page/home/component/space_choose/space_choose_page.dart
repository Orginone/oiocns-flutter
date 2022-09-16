import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';

import '../../../../api_resp/target_resp.dart';
import '../../../../component/text_avatar.dart';
import '../../../../component/unified_edge_insets.dart';
import '../../../../util/widget_util.dart';
import 'space_choose_controller.dart';

class SpaceChoosePage extends GetView<SpaceChooseController> {
  const SpaceChoosePage({Key? key}) : super(key: key);

  Widget _item(TargetResp targetResp) {
    var currentSpaceId = controller.homeController.currentSpace.id;
    var spaceId = targetResp.id;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.homeController.switchSpaces(targetResp);
        Get.back();
      },
      child: Container(
          padding: ltr10,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            TextAvatar(avatarName: targetResp.name, type: TextAvatarType.space),
            Container(margin: left10),
            Expanded(
              child: Text(
                targetResp.name,
                style: text18,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Visibility(
              visible: currentSpaceId == spaceId,
              child: TextTag(
                "当前空间",
                bgColor: Colors.green,
                textStyle: text12White,
                padding: const EdgeInsets.all(4),
              ),
            )
          ])),
    );
  }

  get _body => RefreshIndicator(
        onRefresh: () async {
          controller.onLoadSpaces();
        },
        child: GetBuilder<SpaceChooseController>(
            init: controller,
            builder: (controller) => ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: controller.spaces.length,
                itemBuilder: (BuildContext context, int index) {
                  return _item(controller.spaces[index]);
                })),
      );

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: Text("工作空间切换", style: text20),
      appBarCenterTitle: true,
      body: _body,
    );
  }
}
