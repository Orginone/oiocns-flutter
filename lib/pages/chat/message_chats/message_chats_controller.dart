import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';
import 'package:orginone/routers.dart';

class MessageChatsController
    extends BaseFrequentlyUsedListController<MessageChatsState> {
  @override
  final MessageChatsState state = MessageChatsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.mostUsedList =  state.setting.chat.messageRecent;
    loadSuccess();
  }

  @override
  void onReady() async {

  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    // TODO: implement loadData
    await state.setting.provider.reload();
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }


  void jumpMessage(recent) {
    if(recent is MessageRecent){
      recent.chat.onMessage();
      Get.toNamed(
        Routers.messageChat,
        arguments: recent.chat,
      );
    }
  }
}
