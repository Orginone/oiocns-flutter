import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/pages/chat/widgets/message_list.dart';

class ChatSessionPage extends OrginoneStatefulWidget {
  ChatSessionPage({super.key, super.data});
  @override
  State<StatefulWidget> createState() => _ChatSessionPageState();
}

class _ChatSessionPageState extends OrginoneStatefulState<ChatSessionPage> {
  late ChatBoxController chatBoxCtrl;

  @override
  void initState() {
    super.initState();
    MessageChatController chatCtrl = MessageChatController();
    chatCtrl.context = context;
    Get.lazyPut(() => chatCtrl);
    PlayController playCtrl = PlayController();
    Get.lazyPut(() => playCtrl);
    chatBoxCtrl = ChatBoxController();
    Get.lazyPut(() => chatBoxCtrl);
  }

  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    // state.noReadCount = state.chat.noReadCount;
    ISession? session;
    if (data is ISession) {
      session = data;
    } else if (data is ITarget) {
      session = data.session;
    }

    return null != session
        ? GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
              chatBoxCtrl.eventFire(context, InputEvent.clickBlank, session!);
            },
            child: Column(
              children: [
                const Expanded(child: MessageList()),
                ChatBox(chat: session, controller: chatBoxCtrl)
              ],
            ),
          )
        : Container(
            child: const Center(
              child: Text("--还未开始沟通--"),
            ),
          );
  }

  // @override
  // bool showMore(BuildContext context, dynamic data) {
  //   return true;
  // }

  // @override
  // void onMore(BuildContext context, dynamic data) {
  //   Get.toNamed(Routers.messageSetting, arguments: data);
  // }
}
