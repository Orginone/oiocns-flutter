import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/organization/friends/friends_controller.dart';

import '../../../../component/text_avatar.dart';
import '../../../../component/text_search.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../routers.dart';
import '../../../../util/widget_util.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({Key? key}) : super(key: key);

  get _body => Column(
        children: [
          TextSearch(controller.searchingCallback),
          Expanded(
              child: Scrollbar(
                  child: RefreshIndicator(
                      onRefresh: () async {
                        controller.onLoadFriends("");
                      },
                      child: _list())))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("我的好友", style: text16),
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body,
    );
  }

  Widget _list() {
    return GetBuilder<FriendsController>(
        init: FriendsController(),
        builder: (controller) => ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: controller.friends.length,
            itemBuilder: (BuildContext context, int index) {
              return _item(controller.friends[index]);
            }));
  }

  Widget _item(TargetResp targetResp) {
    return GestureDetector(
        onTap: () {
          Get.toNamed(Routers.personDetail, arguments: targetResp.name);
        },
        child: Container(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(children: [
              TextAvatar(
                  avatarName: targetResp.name, type: TextAvatarType.chat),
              Container(margin: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
              Expanded(child: Text(targetResp.name, style: text16))
            ])));
  }
}
