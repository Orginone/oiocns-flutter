import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_freqiently_usedList_controller.dart';
import 'package:orginone/dart/core/getx/frequently_used_list/base_frequently_used_list_state.dart';
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
    state.frequentlyUsedList.add( Recent("0000", "资产监管", "${Constant.host}/img/logo/logo3.jpg"));
  }

  @override
  void onReady() {
    // TODO: implement onReady
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    // TODO: implement loadData
    await state.setting.provider.reload();
    super.loadData(isRefresh: isRefresh,isLoad: isLoad);
  }
}
