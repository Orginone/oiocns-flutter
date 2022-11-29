import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/api/kernelapi.dart';
import 'package:orginone/api/model.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/target/base_target.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class InvitePage extends GetView<InviteController> {
  const InvitePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: Text("好友邀请", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      body: _body,
      appBarActions: _actions,
    );
  }

  get _actions {
    return [
      IconButton(
        onPressed: () async {
          await controller.pull();
        },
        icon: const Icon(Icons.save, color: Colors.black),
      )
    ];
  }

  get _body {
    return Column(
      children: [
        TextSearch(
          searchingCallback: controller.searchCallback,
          margin: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
        ),
        _chooseBody,
        _list,
      ],
    );
  }

  get _chooseBody {
    return Obx(() {
      var queue = controller.targetQueue;
      if (queue.isEmpty) {
        return Container();
      }
      return GridView.count(
        padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 10.w),
        shrinkWrap: true,
        crossAxisCount: 7,
        children: controller.targetQueue.map((item) {
          return _chooseItem(item);
        }).toList(),
      );
    });
  }

  Widget _chooseItem(Target target) {
    var avatarName = StringUtil.getPrefixChars(target.name, count: 2);
    return GestureDetector(
      onTap: () => controller.remove(target),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextAvatar(
            avatarName: avatarName,
            status: Icon(Icons.close, color: Colors.white, size: 20.w),
          ),
        ],
      ),
    );
  }

  get _list => GetBuilder<InviteController>(
        builder: (controller) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: controller.filterNotJoinedFriends.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(controller.filterNotJoinedFriends[index]);
          },
        ),
      );

  Widget _item(Target target) {
    var chooseMap = controller.chooseMap;
    var targetId = target.id;
    chooseMap.putIfAbsent(targetId, () => false.obs);

    var avatarName = StringUtil.getPrefixChars(target.name, count: 2);
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.personDetail, arguments: target.team?.code);
      },
      child: Container(
        padding: EdgeInsets.only(left: 15.w, top: 10.h, right: 25.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return Checkbox(
                value: chooseMap[targetId]!.value,
                onChanged: (value) {
                  bool isChoose = value ?? false;
                  chooseMap[targetId]!.value = isChoose;
                  if (isChoose) {
                    controller.push(target);
                  } else {
                    controller.remove(target);
                  }
                },
              );
            }),
            TextAvatar(avatarName: avatarName),
            Container(margin: EdgeInsets.only(left: 10.w)),
            Expanded(
              child: Text(
                target.name,
                style: AFont.instance.size22Black3,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class InviteController extends GetxController {
  late final String spaceId;
  late final String messageItemId;
  late final List<String> joinedPersonIds;

  /// 目标对象和索引
  final Map<String, RxBool> chooseMap = {};
  final RxList<Target> targetQueue = <Target>[].obs;

  /// 没有加入的好友
  final List<Target> initNotJoinedFriends = [];
  final List<Target> filterNotJoinedFriends = [];

  @override
  void onInit() async {
    super.onInit();
    Map<String, dynamic> args = Get.arguments;
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];

    var messageCtrl = Get.find<MessageController>();
    var chat = messageCtrl.getCurrentSetting!;
    while (chat.hasMorePersons()) {
      await messageCtrl.getCurrentSetting!.morePersons();
    }
    List<Target> allPersons = [];
    if (auth.userId == spaceId) {
      allPersons.addAll(await PersonApi.friendsAll(""));
    } else {
      var res = await CompanyApi.getCompanyPersons(spaceId, maxInt, 0);
      allPersons.addAll(res.result);
    }
    List<String> joinedFriendIds = [];
    for (var friend in allPersons) {
      for (var person in chat.persons) {
        if (friend.id == person.id) {
          joinedFriendIds.add(friend.id);
          break;
        }
      }
    }
    for (var joinedFriendId in joinedFriendIds) {
      allPersons.removeWhere((item) => item.id == joinedFriendId);
    }
    initNotJoinedFriends.addAll(allPersons);
    filterNotJoinedFriends.addAll(allPersons);
    update();
  }

  /// 搜索回调
  searchCallback(String value) {
    filterNotJoinedFriends.clear();
    List<Target> friends = initNotJoinedFriends
        .where((item) => item.name.contains(value))
        .toList();
    filterNotJoinedFriends.addAll(friends);
  }

  /// 推入队列
  push(Target target) {
    var matched = targetQueue.firstWhereOrNull((item) => item.id == target.id);
    if (matched == null) {
      targetQueue.add(target);
    }
  }

  /// 从队列里移除相关内容
  remove(Target target) {
    targetQueue.removeWhere((item) => item.id == target.id);
    chooseMap[target.id]?.value = false;
  }

  /// 邀请人员进群
  pull() async {
    if (targetQueue.isEmpty) {
      Fluttertoast.showToast(msg: "请至少选择一个需要拉取的好友!");
      return;
    }
    var messageCtrl = Get.find<MessageController>();
    var chat = messageCtrl.getCurrentSetting!;

    // 拉取的人员
    List<String> targetIds = targetQueue.map((item) => item.id).toList();
    var teamPull = TeamPullModel(
      id: chat.chatId,
      teamTypes: [TargetType.cohort.label, TargetType.jobCohort.label],
      targetType: TargetType.person.label,
      targetIds: targetIds,
    );
    await Kernel.getInstance.pullAnyToTeam(teamPull);

    // 组装对象
    var targetNames = targetQueue.map((item) => item.name).join("，");
    var msgBody = "${auth.userInfo.name}邀请$targetNames加入了群聊";

    // 发送消息
    await chat.sendMsg(
      msgBody: jsonEncode(msgBody),
      msgType: MsgType.pull,
    );

    Fluttertoast.showToast(msg: "邀请成功!");
    Get.back();
  }
}

class InviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteController());
  }
}
