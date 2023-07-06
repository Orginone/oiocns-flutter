import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';
import 'package:orginone/routers.dart';

class MessageChatsController
    extends BaseFrequentlyUsedListController<MessageChatsState> {
  @override
  final MessageChatsState state = MessageChatsState();

  void loadFrequentlyUsed(){
    state.mostUsedList.value = settingCtrl.chat.messageFrequentlyUsed;
    state.mostUsedList.refresh();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initData();
  }

  @override
  void onReady() {
  }

  @override
  void onReceivedEvent(event) async{
    if (event is LoadUserDone) {
      initData();
    }
  }

  initData() async{
    await settingCtrl.provider.loadChat().then((value){
      if(value){
        loadSuccess();
      }
    });
  }
  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    // TODO: implement loadData
    await settingCtrl.provider.reloadChats();
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }

  @override
  void onTapFrequentlyUsed(used) {
    if(used is MessageFrequentlyUsed){
      used.chat.onMessage();
      Get.toNamed(
        Routers.messageChat,
        arguments: used.chat,
      );
    }
  }
}
