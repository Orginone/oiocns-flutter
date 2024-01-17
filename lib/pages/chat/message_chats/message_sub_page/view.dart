import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/pages/chat/widgets/message_breadcrumb_nav_item.dart';

import 'logic.dart';
import 'state.dart';

class MessageSubPage
    extends BaseGetListPageView<MessageSubController, MessageSubState> {
  late String type;
  late String label;

  MessageSubPage(this.type, this.label, {super.key});

  @override
  Widget buildView() {
    // if (type == 'all') {
    //   // TODO 暂时放弃
    //   return allWidget();
    // }
    // if (type == 'common') {
    //   return commonWidget();
    // }
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
          // var item = relationCtrl.chat.messageFrequentlyUsed[index];
          var item = relationCtrl.chats[index];
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
        // itemCount: relationCtrl.chat.messageFrequentlyUsed.length,
        itemCount: relationCtrl.chats.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      );
    });
  }

  Widget messageWidget() {
    return Obx(() {
      List<ISession> chats = state.chats;
      // if (type == "unread") {
      //   chats = chats
      //       .where((element) => element.chatdata.value.noReadCount != 0)
      //       .toList();
      // }
      // if (type == "single") {
      //   chats = chats
      //       .where(
      //           (element) => element.share.typeName == TargetType.person.label)
      //       .toList();
      // }
      // if (type == "group") {
      //   chats = chats
      //       .where((element) => element.typeName == TargetType.cohort.label)
      //       .toList();
      // } else if (type == "friend") {
      //   chats = chats.where((element) => element.isFriend).toList();
      // } else if (type == "company") {
      //   chats = chats
      //       .where((element) => element.typeName == TargetType.company.label)
      //       .toList();
      // } else if (type == "company_friend") {
      //   chats = chats
      //       .where((element) =>
      //           !element.isFriend &&
      //           element.typeName == TargetType.person.label)
      //       .toList();
      // }
      chats = chats
          .where(
              (element) => label == '最近' || element.groupTags.contains(label))
          .toList();
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

  void showErr() {
    var time = Future.delayed(const Duration(milliseconds: 100), () {
      if (relationCtrl.provider.errInfo != "") {
        Navigator.of(context).push(PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) {
              return Dialog(
                child: Text(relationCtrl.provider.errInfo),
              );
            }));
      } else {
        showErr();
      }
    });
  }

  @override
  MessageSubController getController() {
    // showErr();
    return MessageSubController(type);
  }

  @override
  String tag() {
    return "message_$type";
  }

  @override
  bool displayNoDataWidget() => false;
}
