import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';

import '../../../../api_resp/target_resp.dart';
import '../../../../component/text_avatar.dart';
import '../../../../util/widget_util.dart';
import 'space_choose_controller.dart';

class SpaceChoosePage extends GetView<SpaceChooseController> {
  const SpaceChoosePage({Key? key}) : super(key: key);

  Widget _item(TargetResp targetResp) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.homeController.switchSpaces(targetResp);
        Get.back();
      },
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 10, 0),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            TextAvatar(avatarName: targetResp.name, type: TextAvatarType.space),
            Container(margin: const EdgeInsets.fromLTRB(5, 0, 0, 0)),
            Expanded(
              child: Text(
                targetResp.name,
                style: text18,
                overflow: TextOverflow.ellipsis,
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
      appBarTitle:
          Text(controller.homeController.currentSpace.name, style: text20),
      body: _body,
    );
  }
}
