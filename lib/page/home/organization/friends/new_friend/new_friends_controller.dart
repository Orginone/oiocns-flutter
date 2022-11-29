import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/public/http/base_list_controller.dart';
import 'package:orginone/public/loading/opt_loading.dart';

import '../../../../../api/person_api.dart';
import '../../../../../api_resp/friends_entity.dart';

class NewFriendsController extends BaseListController<FriendsEntity> {
  int limit = 20;
  int offset = 0;

  @override
  void onInit() {
    super.onInit();
    onRefresh();
  }

  @override
  void onLoadMore() async {
    offset += 1;
    var pageResp = await PersonApi.approvalAll("0", limit, offset);
    addData(true, pageResp);
  }

  @override
  void onRefresh() async {
    var pageResp = await PersonApi.approvalAll("0", limit, offset);
    addData(true, pageResp);
  }

  String getName(String userId) {
    MessageController find = Get.find<MessageController>();
    var orgChatCache = find.orgChatCache;
    String name = "";
    if (orgChatCache.nameMap.isNotEmpty) {
      name = (orgChatCache.nameMap[userId]) ?? "";
    }
    return name;
  }

  void joinSuccess(FriendsEntity friends) async {
    ALoading.showCircle();
    await PersonApi.joinSuccess(friends.id)
        .then((value) {
          //成功，刷新列表
          Fluttertoast.showToast(msg: "已通过");
          offset = 0;
          onRefresh();
          var team = friends.team;
          if (team != null) {
            var target = team.target;
            if (target != null) {
              // 所有非人员的都要加一条信息
              if (Get.isRegistered<MessageController>()) {
                var messageCtrl = Get.find<MessageController>();
                if (target.typeName != TargetType.person.name) {
                  var chat = messageCtrl.refById(target.id);
                  if (chat != null) {
                    var msgBody = "${auth.userInfo.name}邀请${team.name}加入了群聊";
                    chat.sendMsg(msgType: MsgType.pull, msgBody: msgBody);
                  }
                } else {
                  messageCtrl.refreshMails();
                }
              }
            }
          }
        })
        .onError((error, stackTrace) {})
        .whenComplete(() => ALoading.dismiss());
  }

  void joinRefuse(String id) async {
    ALoading.showCircle();
    await PersonApi.joinRefuse(id)
        .then((value) {
          //成功，刷新列表
          offset = 0;
          onRefresh();
        })
        .onError((error, stackTrace) {})
        .whenComplete(() => ALoading.dismiss());
  }

  String getStatus(int status) {
    if (status >= 0 && status <= 100) {
      return "待批";
    } else if (status >= 100 && status < 200) {
      return "已通过";
    }
    return "已拒绝";
  }
}
