import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/message/message_controller.dart';

class CzhController extends GetxController {
  String currentRelationId = '';
  TextEditingController searchGroupText = TextEditingController();
  MessageController messageController = Get.find<MessageController>();
  var textField1 = 1.obs;
  var textField2 = 2.obs;
  // relationObj testObj = {}.obs;
  void test1(a) {
    textField1.value = a;
  }
  @override
  void onInit() async {
    await getRelationData();
    super.onInit();
  }
  //获取人或集团的信息
  Future<dynamic> getRelationData() async {
    // 根据currentRelationId获取关系信息
    // Map<String, dynamic> chats = await HubUtil().getChats();
    // 转化为api的格式
    // ApiResp apiResp = ApiResp.fromMap(chats);
    // 存入对应
    // testObj = relationResp.data
  }
}