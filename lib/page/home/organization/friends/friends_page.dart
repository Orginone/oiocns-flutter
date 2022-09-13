import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/organization/friends/friends_controller.dart';

import '../../../../component/text_avatar.dart';
import '../../../../component/text_search.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: GFIconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
          type: GFButtonType.transparent,
        ),
        title: const Text("我的好友"),
      ),
      body: Column(
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
      ),
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
    return Container(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Row(children: [
          TextAvatar(avatarName: targetResp.name, type: TextAvatarType.chat),
          Container(margin: const EdgeInsets.fromLTRB(10, 0, 0, 0)),
          Expanded(
              child:
                  Text(targetResp.name, style: const TextStyle(fontSize: 18)))
        ]));
  }
}
