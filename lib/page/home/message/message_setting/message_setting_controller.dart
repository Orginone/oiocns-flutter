import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/org_chat_cache.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../../api_resp/message_item_resp.dart';
import '../../../../enumeration/target_type.dart';
import '../../../../logic/authority.dart';
import '../../../../util/hub_util.dart';

class MessageSettingController extends GetxController {
  final Logger log = Logger("MessageSettingController");
  TextEditingController searchGroupTextController = TextEditingController();
  MessageController messageController = Get.find<MessageController>();
  ChatController chatController = Get.find<ChatController>();
  RxBool textField1 = true.obs;
  RxBool textField2 = true.obs;

  //当前用户信息
  TargetResp userInfo = auth.userInfo;

  //接收关系对象下的成员列表
  RxList<TargetResp> originPersonList = <TargetResp>[].obs;

  //筛选过后的成员列表，不填值会报错
  RxList<TargetResp> filterPersonList = <TargetResp>[].obs;

  //当前关系对象(观测)的信息
  Rx<MessageItemResp>? messageItem;
  Rx<String>? spaceId;
  late String messageItemId;
  RxList<TargetResp> personList = <TargetResp>[].obs;

  @override
  void onInit() async {
    //初始化
    Map<String, dynamic> args = Get.arguments;
    spaceId = RxString(args["spaceId"]);
    messageItemId = args["messageItemId"];
    messageItem = Rx<MessageItemResp>(args["messageItem"]);

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
}
