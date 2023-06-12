import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/pages/chat/message_chats/message_chats_state.dart';

class MessageChatsController
    extends BaseFrequentlyUsedListController<MessageChatsState> {
  @override
  final MessageChatsState state = MessageChatsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadSuccess();
  }

  @override
  void onReady() async {
    state.mostUsedList.value = await state.setting.chat.loadMostUsed();
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    // TODO: implement loadData
    await state.setting.provider.reload();
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }

  void setMostUsed(IMsgChat chat) async {
    var recent = await state.setting.chat.setMostUsed(chat);
    if (recent != null) {
      state.mostUsedList.add(recent);
      state.mostUsedList.refresh();
    }
  }
}
