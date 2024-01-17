import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/pages/chat/message_routers.dart';

import 'state.dart';

class MessageSubController extends BaseListController<MessageSubState> {
  @override
  final MessageSubState state = MessageSubState();

  late String type;
  late String key;

  MessageSubController(this.type);

  @override
  void onInit() async {
    super.onInit();
    // await initChatBreadNav();
    // loadSuccess();
    key = relationCtrl.subscribe((key, args) async {
      // await initChatBreadNav();
      loadSuccess();
    });
    if (relationCtrl.provider.inited) {
      loadSuccess();
    }
  }

  Future<void> initChatBreadNav() async {
    List<ChatBreadcrumbNav> companyItems = [];
    for (var company in relationCtrl.user.companys) {
      companyItems.add(
        createNav(
            company.id,
            company.session,
            [
              createNav(
                "${company.id}0",
                company.session,
                company.memberChats
                    .map((item) => createNav(item.sessionId, item, []))
                    .toList(),
              ),
              ...company.cohortChats
                  .where((i) => i.isMyChat)
                  .map((item) => createNav(item.sessionId, item, [],
                      spaceEnum: SpaceEnum.departments))
                  .toList(),
            ],
            type: ChatType.list,
            spaceEnum: SpaceEnum.company),
      );
    }
    state.nav = ChatBreadcrumbNav(children: [
      createNav(
          relationCtrl.user.id,
          relationCtrl.user.session,
          [
            createNav(
              "${relationCtrl.user.id}0",
              relationCtrl.user.session,
              relationCtrl.user.memberChats
                  .map((chat) => createNav(chat.sessionId, chat, [],
                      spaceEnum: SpaceEnum.person))
                  .toList(),
            ),
            ...relationCtrl.user.cohortChats
                .where((i) => i.isMyChat)
                .map((item) => createNav(item.sessionId, item, [],
                    spaceEnum: SpaceEnum.departments))
                .toList(),
          ],
          type: ChatType.list),
      ...companyItems,
    ], name: "沟通", target: relationCtrl.user.session);
  }

  ChatBreadcrumbNav createNav(
      String id, ISession target, List<ChatBreadcrumbNav> children,
      {ChatType type = ChatType.chat, SpaceEnum? spaceEnum}) {
    dynamic image = target.share.avatar?.thumbnailUint8List ??
        target.share.avatar?.defaultAvatar;
    return ChatBreadcrumbNav(
        id: id,
        type: type,
        spaceEnum: spaceEnum,
        children: children,
        name: target.chatdata.value.chatName ?? "",
        target: target,
        image: image);
  }

  void jumpNext(ChatBreadcrumbNav chat) {
    if (chat.children.isEmpty) {
      jumpDetails(chat);
    } else {
      Get.toNamed(Routers.initiateChat,
          preventDuplicates: false, arguments: {"data": chat});
    }
  }

  void jumpDetails(ChatBreadcrumbNav chat) {
    if (chat.type == ChatType.chat) {
      chat.target.onMessage((messages) {});
      Get.toNamed(Routers.messageChat, arguments: chat.target);
    } else {
      Get.toNamed(Routers.messageChatsList, arguments: {
        "chats": (chat.target as ITeam)
            .memberChats
            .where((element) => element.isMyChat)
            .toList()
      });
    }
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    state.scrollController.dispose();
    super.onClose();
    relationCtrl.unsubscribe(key);
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    // if (type != 'all') {
    // if (type == "common") {
    //TODO:无此方法
    // await relationCtrl.chat.loadMostUsed();
    // }
    if (isRefresh) {
      // await relationCtrl.loadChats(true);
    }
    // }
  }

  void onSelected(key, ISession chat) {
    //TODO:无此方法
    // relationCtrl.chat.removeMostUsed(chat);
  }
}
