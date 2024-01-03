import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/config/unified.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'message_forward.dart';
import 'widgets/message_list.dart';

class MessageChatPage
    extends BaseGetView<MessageChatController, MessageChatState> {
  const MessageChatPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleWidget: _title(),
      actions: _actions(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          state.chatBoxCtrl
              .eventFire(context, InputEvent.clickBlank, state.chat);
        },
        child: Column(
          children: [
            const Expanded(child: MessageList()),
            ChatBox(chat: state.chat, controller: state.chatBoxCtrl)
          ],
        ),
      ),
    );
  }

  Widget _title() {
    String name = state.chat.chatdata.value.chatName ?? "";
    if (state.chat.members.length > 1) {
      name += "(${state.chat.members.length})";
    }
    var spaceName = state.chat.groupTags.join(" | ");
    return Column(
      children: [
        Text(name, style: XFonts.size24Black3),
        Text(spaceName, style: XFonts.size16Black9),
      ],
    );
  }

  List<Widget> _actions() {
    return <Widget>[
      GFIconButton(
        color: Colors.white.withOpacity(0),
        icon: Icon(
          Icons.more_vert,
          color: XColors.black3,
          size: 32.w,
        ),
        onPressed: () async {
          Get.toNamed(Routers.messageSetting, arguments: state.chat);
        },
      ),
    ];
  }
}

class MessageChatController extends BaseController<MessageChatState> {
  @override
  final MessageChatState state = MessageChatState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    // Future.delayed(const Duration(milliseconds: 100), () {
    //   markVisibleMessagesAsRead();
    // });
  }

  void forward(String msgType, IMessage msgBody) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MessageForward(
            msgBody: msgBody,
            msgType: msgType,
            onSuccess: () {
              Navigator.pop(context);
            },
          );
        },
        isScrollControlled: true,
        isDismissible: false,
        useSafeArea: true,
        barrierColor: Colors.white);
  }

  void markVisibleMessagesAsRead() {
    final RenderObject? renderObject =
        state.scrollKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final Offset topLeft = renderObject.localToGlobal(Offset.zero);
      final Offset bottomRight = renderObject
          .localToGlobal(renderObject.size.bottomRight(Offset.zero));
      final Rect bounds = Rect.fromPoints(topLeft, bottomRight);
      // for (var message in state.chat.messages) {
      //   ////TODO:无此方法
      //   if (isMessageVisible(bounds, message.metadata.key)) {
      //     bool isRead = false;
      //     try {
      //       var tag = message.labels
      //           .firstWhere((element) => element.userId == settingCtrl.user.id);
      //       isRead = tag != null;
      //     } catch (e) {
      //       isRead = false;
      //     }

      //     if (!isRead) {
      //       //TODO:无此方法
      //       // state.chat.tagHasReadMsg([message.metadata]);
      //     }
      //   }
      // }
    }
  }

  bool isMessageVisible(Rect bounds, GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final RenderAbstractViewport viewport =
          RenderAbstractViewport.of(renderObject);
      return bounds.overlaps(viewport.paintBounds);
    }
    return false;
  }

  void showReadMessage(List<XTarget> readMember, List<XTarget> unreadMember,
      List<IMessageLabel> labels) {
    // showMessageReadDialog(context, readMember, unreadMember,labels);
    Get.toNamed(Routers.messageReceive, arguments: {
      'readMember': readMember,
      'unreadMember': unreadMember,
      'labels': labels
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    //TODO:无此方法
    // settingCtrl.chat.currentChat = null;
    super.onClose();
  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is JumpSpecifyMessage) {
      int index = state.chat.messages.indexOf(event.message);
      state.itemScrollController.jumpTo(index: index);
    }
  }
}

class MessageChatState extends BaseGetState {
  late ISession chat;

  ChatBoxController get chatBoxCtrl => Get.find();

  late GlobalKey scrollKey;

  final ItemScrollController itemScrollController = ItemScrollController();

  MessageChatState() {
    chat = Get.arguments;
    scrollKey = GlobalKey();
  }
}

class MessageChatBinding extends BaseBindings<MessageChatController> {
  @override
  MessageChatController getController() {
    return MessageChatController();
  }
}
