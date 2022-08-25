
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/model/db_model.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/model/target_relation_util.dart';
import 'package:orginone/util/hive_util.dart';


class MessageSettingController extends GetxController {
  final Logger log = Logger("czhController");
  TextEditingController searchGroupTextController = TextEditingController();
  MessageController messageController = Get.find<MessageController>();
  ChatController chatController = Get.find<ChatController>();
  var textField1 = 1.obs;
  var textField2 = 2.obs;
  //当前用户信息
  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
  //接收关系对象下的成员列表
  RxList<TargetResp> originPersonList = <TargetResp>[].obs;
  //筛选过后的成员列表，不填值会报错
  RxList<TargetResp> filterPersonList = <TargetResp>[].obs;
  //当前关系对象(观测)的信息
  TargetRelation? currentTargetRelation;
  RxString name = ''.obs;
  RxString remark = ''.obs;
  RxString label = ''.obs;

  void test1(a) {
    textField1.value = a;
  }
  @override
  void onInit() async {
    //初始化关系对象
    currentTargetRelation = await TargetRelationUtil.getItem(messageController.currentSpaceId, messageController.currentMessageItemId);
    name.value = currentTargetRelation?.name ?? '';
    remark.value = currentTargetRelation?.remark ?? '';
    label.value = currentTargetRelation?.label ?? '';
    log.info(currentTargetRelation);
    //初始化成员列表
    for(TargetResp person in chatController.personList) {
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
    List<TargetResp> tempArray = originPersonList.where((item) => exp.hasMatch(item.name)).toList();
    for(TargetResp person in tempArray) {
      filterPersonList.add(person);
    }
  }
  //获取人或集团的信息
  Future<dynamic> getRelationData() async {
    // 根据currentRelationId获取关系信息
    // Map<String, dynamic> chats = await HubUtil().getChats();
    // 转化为api的格式
    // ApiResp apiResp = ApiResp.fromMap(chats);
    // 存入对应
    // relationObj = relationResp.data
  }
}