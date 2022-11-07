import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:orginone/api/cohort_api.dart';
import 'package:orginone/component/unified_scaffold.dart';

import '../../../../api_resp/target_resp.dart';
import '../../../../component/a_font.dart';
import '../../../../component/text_avatar.dart';
import '../../../../component/text_search.dart';
import '../../../../routers.dart';
import '../../../../util/string_util.dart';
import '../../../../util/widget_util.dart';
import '../../organization/friends/friends_controller.dart';

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
          Fluttertoast.showToast(msg: "邀请成功!");
          Get.back();
        },
        icon: const Icon(Icons.save, color: Colors.black),
      )
    ];
  }

  get _body {
    var friendsController = controller.friendsController;
    return Column(
      children: [
        TextSearch(
          searchingCallback: friendsController.searchingCallback,
          margin: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
        ),
        _chooseBody,
        Expanded(
          child: RefreshIndicator(
            onRefresh: () async {
              friendsController.onLoadFriends("");
            },
            child: _list,
          ),
        ),
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

  Widget _chooseItem(TargetResp target) {
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

  get _list => GetBuilder<FriendsController>(
        builder: (controller) => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.friends.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(controller.friends[index]);
          },
        ),
      );

  Widget _item(TargetResp target) {
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
  /// 好友控制器
  final FriendsController friendsController = Get.find();

  late final String messageItemId;

  /// 目标对量和索引
  final Map<String, RxBool> chooseMap = {};
  final RxList<TargetResp> targetQueue = <TargetResp>[].obs;

  @override
  void onInit() {
    super.onInit();
    messageItemId = Get.arguments;
  }

  /// 推入队列
  push(TargetResp target) {
    var matched = targetQueue.firstWhereOrNull((item) => item.id == target.id);
    if (matched == null) {
      targetQueue.add(target);
    }
  }

  /// 从队列里移除相关内容
  remove(TargetResp target) {
    targetQueue.removeWhere((item) => item.id == target.id);
    chooseMap[target.id]?.value = false;
  }

  /// 邀请人员进群
  pull() async {
    List<String> targetIds = targetQueue.map((item) => item.id).toList();
    await CohortApi.pull(messageItemId, targetIds);
  }
}

class InviteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteController());
    Get.lazyPut(() => FriendsController());
  }
}
