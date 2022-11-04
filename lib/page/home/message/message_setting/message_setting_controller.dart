import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/cohort_api.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';

import '../../../../api/person_api.dart';
import '../../../../api_resp/message_item_resp.dart';
import '../../../../enumeration/target_type.dart';
import '../../../../logic/authority.dart';
import '../../../../util/hub_util.dart';

class MessageSettingController extends GetxController {
  final Logger log = Logger("MessageSettingController");

  TextEditingController searchGroupTextController = TextEditingController();

  MessageController messageController = Get.find<MessageController>();
  ChatController chatController = Get.find<ChatController>();

  //当前用户信息
  TargetResp userInfo = auth.userInfo;

  //接收关系对象下的成员列表
  RxList<TargetResp> originPersonList = <TargetResp>[].obs;

  //筛选过后的成员列表，不填值会报错
  RxList<TargetResp> filterPersonList = <TargetResp>[].obs;

  //当前关系对象(观测)的信息
  late MessageItemResp messageItem;
  late String spaceId;
  late String messageItemId;
  RxList<TargetResp> personList = <TargetResp>[].obs;

  @override
  void onInit() async {
    //初始化
    Map<String, dynamic> args = Get.arguments;
    spaceId = args["spaceId"];
    messageItemId = args["messageItemId"];
    messageItem = args["messageItem"];

    await getPersons();

    //初始化成员列表
    for (TargetResp person in personList) {
      originPersonList.add(person);
      filterPersonList.add(person);
    }
    super.onInit();
  }

  //查询成员
  searchPerson() {
    //清空人员数组
    filterPersonList.clear();
    //筛选
    RegExp exp = RegExp(searchGroupTextController.text);
    List<TargetResp> tempArray =
        originPersonList.where((item) => exp.hasMatch(item.name)).toList();
    for (TargetResp person in tempArray) {
      filterPersonList.add(person);
    }
  }

  //获取人或集团的信息
  Future<dynamic> getRelationData() async {
    // 根据currentRelationId获取关系信息
    // Map<String, dynamic> chats = await HubUtil().getChats();
    // 转化为api的格式
    // ApiResp apiResp = ApiResp.fromJson(chats);
    // 存入对应
    // relationObj = relationResp.data
  }

  /// 查询群成员信息
  Future<void> getPersons() async {
    OrgChatCache orgChatCache = messageController.orgChatCache;
    Map<String, dynamic> nameMap = orgChatCache.nameMap;

    int offset = 0;
    int limit = 100;
    while (true) {
      PageResp<TargetResp> personPage = await HubUtil().getPersons(
        messageItemId,
        limit,
        offset,
      );
      var persons = personPage.result;
      personList.addAll(persons);
      if (persons.isEmpty) {
        break;
      }
      for (var person in persons) {
        var typeName = person.typeName;
        typeName = typeName == TargetType.person.name ? "" : "[$typeName]";
        nameMap[person.id] = "${person.team?.name}$typeName";
      }
      offset += limit;
      if (persons.length < limit) {
        break;
      }
    }
    HubUtil().cacheChats(orgChatCache);
  }

  /// 消息免打扰
  interruptionOrNot(bool trueOrNot) async {
    var orgChatCache = messageController.orgChatCache;

    // 会话中止
    orgChatCache.chats.where((space) => space.id == spaceId).forEach((space) {
      space.chats.where((chat) => chat.id == messageItemId).forEach((item) {
        item.isInterruption = trueOrNot;
      });
    });

    // 近期会话
    orgChatCache.recentChats?.forEach((chat) {
      chat.isInterruption = trueOrNot;
    });

    // 打开的会话
    for (var chat in orgChatCache.openChats) {
      chat.isInterruption = trueOrNot;
    }
    messageController.update();
    update();

    // 同步会话
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 删除个人空间所有聊天记录
  clearHistoryMsg() async {
    await HubUtil().clearHistoryMsg(spaceId, messageItemId);

    // 清空页面
    var chatSpaceId = chatController.spaceId;
    var chatMessageItemId = chatController.messageItemId;
    if (chatSpaceId == spaceId && messageItemId == chatMessageItemId) {
      chatController.details.clear();
    }

    var userId = auth.userId;

    var orgChatCache = messageController.orgChatCache;
    orgChatCache.chats.where((space) => space.id == userId).forEach((space) {
      for (var chat in space.chats) {
        if (chat.id == messageItemId) {
          chat.showTxt = null;
        }
      }
    });
    orgChatCache.recentChats
        ?.where((c) => c.spaceId == userId && c.id == messageItemId)
        .forEach((chat) {
      chat.showTxt = null;
    });
    messageController.update();

    // 同步会话
    await HubUtil().cacheChats(orgChatCache);
  }

  /// 删除好友
  removeFriends() async {
    // 接口删除好友
    var targetId = messageItem.id;
    await PersonApi.remove(targetId);
    await cacheRemove(auth.userId, targetId);
    messageController.update();
  }

  /// 退出群组
  exitGroup() async {
    var targetId = messageItem.id;
    await CohortApi.exit(targetId);
    await cacheRemove(spaceId, targetId);
    messageController.update();
  }

  // 清理缓存内容并同步信息
  cacheRemove(String spaceId, String targetId) async {
    var orgChatCache = messageController.orgChatCache;

    // 从缓存中删掉会话
    orgChatCache.chats.where((space) => space.id == spaceId).forEach((space) {
      space.chats.removeWhere((chat) => chat.id == targetId);
    });

    // 从近期删除会话
    orgChatCache.recentChats
        ?.removeWhere((chat) => chat.spaceId == spaceId && chat.id == targetId);

    // 从打开的会话删除
    orgChatCache.openChats
        .removeWhere((chat) => chat.spaceId == spaceId && chat.id == targetId);

    // 同步会话
    await HubUtil().cacheChats(orgChatCache);
  }
}
