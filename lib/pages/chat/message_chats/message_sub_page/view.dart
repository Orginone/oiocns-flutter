import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/message_breadcrumb_nav_item.dart';

import 'logic.dart';
import 'state.dart';

class MessageSubPage
    extends BaseGetListPageView<MessageSubController, MessageSubState> {
  late String type;

  MessageSubPage(this.type, {super.key});

  @override
  Widget buildView() {
    if (type == 'all') {
      return allWidget();
    }
    if (type == 'common') {
      return commonWidget();
    }
    return messageWidget();
  }

  Widget allWidget() {
    return ListView.builder(
      controller: state.scrollController,
      itemBuilder: (BuildContext context, int index) {
        var item = state.nav!.children[index];
        return MessageBreadcrumbNavItem(
          item: item,
          onNext: () {
            controller.jumpNext(item);
          },
          onTap: () {
            controller.jumpDetails(item);
          },
          onSelected: (key) {},
        );
      },
      itemCount: state.nav!.children.length,
    );
  }

  Widget commonWidget() {
    return Obx(() {
      return GridView.builder(
        controller: state.scrollController,
        itemBuilder: (BuildContext context, int index) {
          // var item = settingCtrl.chat.messageFrequentlyUsed[index];
          var item = settingCtrl.chats[index];
          var adapter = ListAdapter.chat(item);
          adapter.popupMenuItems = [
            PopupMenuItem(
              value: PopupMenuKey.removeCommon,
              child: Text(PopupMenuKey.removeCommon.label),
            )
          ];
          adapter.onSelected = (key) {
            controller.onSelected(key, item);
          };
          return GridItem(adapter: adapter);
        },
        // itemCount: settingCtrl.chat.messageFrequentlyUsed.length,
        itemCount: settingCtrl.chats.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      );
    });
  }

  Widget messageWidget() {
    return Obx(() {
      List<ISession> chats = state.chats;
      if (type == "unread") {
        chats = chats
            .where((element) => element.chatdata.noReadCount != 0)
            .toList();
      }
      if (type == "single") {
        chats = chats
            .where(
                (element) => element.share.typeName == TargetType.person.label)
            .toList();
      }
      if (type == "group") {
        chats = chats
            .where(
                (element) => element.share.typeName != TargetType.person.label)
            .toList();
      }
      return ListView.builder(
        controller: state.scrollController,
        itemBuilder: (BuildContext context, int index) {
          var item = chats[index];
          return ListItem(adapter: ListAdapter.chat(item));
        },
        itemCount: chats.length,
      );
    });
  }

  @override
  MessageSubController getController() {
    return MessageSubController(type);
  }

  @override
  String tag() {
    return "message_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
