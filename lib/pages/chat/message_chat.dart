import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/message.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/chat/message_routers.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'message_forward.dart';
import 'widgets/chat_item.dart';

class MessageChatPage
    extends BaseGetView<MessageChatController, MessageChatState> {
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
            Expanded(child: _content(state.chat.messages)),
            ChatBox(chat: state.chat, controller: state.chatBoxCtrl)
          ],
        ),
      ),
    );
  }

  Widget _title() {
    String name = state.chat.chatdata.value.chatName ?? "";
    if (state.chat.memberChats.length > 1) {
      name += "(${state.chat.memberChats.length})";
    }
    var spaceName = state.chat.chatdata.value.labels.join(" | ");
    return Column(
      children: [
        Text(name, style: XFonts.size22Black3),
        Text(spaceName, style: XFonts.size14Black9),
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

  Widget _content(List<IMessage> messages) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          print("开始滚动");
        } else if (notification is ScrollUpdateNotification) {
          print("正在滚动。。。总滚动距离：${notification.metrics.maxScrollExtent}");
        } else if (notification is ScrollEndNotification) {
          print("停止滚动");
          controller.markVisibleMessagesAsRead();
        }
        return true;
      },
      child: RefreshIndicator(
        onRefresh: ()=>state.chat.moreMessage(),
        child: Obx(() {
          return ListView.builder(
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            key: state.scrollKey,
            shrinkWrap: true,
            reverse: true,
            addAutomaticKeepAlives: true,
            itemCount: messages.length,
            itemBuilder: (BuildContext context, int index) {
              return _item(index);
            },
          );
        }),
      ),
    );
  }

  Widget _item(int index) {
    IMessage msg = state.chat.messages[index];
    Widget currentWidget = DetailItemWidget(
      msg: msg, chat: state.chat, key: msg.metadata.key,);
    var time = _time(msg.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == state.chat.messages.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      IMessage pre = state.chat.messages[index + 1];
      var curCreateTime = DateTime.parse(msg.createTime);
      var preCreateTime = DateTime.parse(pre.createTime);
      var difference = curCreateTime.difference(preCreateTime);
      if (difference.inSeconds > 60 * 3) {
        item.children.insert(0, time);
        return item;
      }
      return item;
    }
  }

  Widget _time(String dateTime) {
    var content = CustomDateUtil.getDetailTime(DateTime.parse(dateTime));
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Text(content, style: XFonts.size16Black9),
    );
  }
}

class MessageChatController extends BaseController<MessageChatState> {
  final MessageChatState state = MessageChatState();


  SettingController get setting => Get.find();


  void forward(String msgType, String text) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MessageForward(text: text, msgType: msgType, onSuccess: () {
            Navigator.pop(context);
          },);
        },
        isScrollControlled: true,
        isDismissible: false,
        useSafeArea: true,
        barrierColor: Colors.white);
  }

  void markVisibleMessagesAsRead() {
    final RenderObject? renderObject = state.scrollKey.currentContext
        ?.findRenderObject();
    if (renderObject is RenderBox) {
      final Offset topLeft = renderObject.localToGlobal(Offset.zero);
      final Offset bottomRight = renderObject.localToGlobal(
          renderObject.size.bottomRight(Offset.zero));
      final Rect bounds = Rect.fromPoints(topLeft, bottomRight);
      for (var message in state.chat.messages) {
        if (isMessageVisible(bounds, message.metadata.key)) {
          bool isRead = false;
          try {
            var tag = message.metadata.tags
                ?.firstWhere((element) => element.userId == setting.user.id);
            isRead = tag != null;
          } catch (e) {
            isRead = false;
          }

          if (!isRead) {
            state.chat.tagHasReadMsg([message.metadata]);
          }
        }
      }
    }
  }

  bool isMessageVisible(Rect bounds, GlobalKey key) {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      final RenderAbstractViewport viewport = RenderAbstractViewport.of(
          renderObject);
      return bounds.overlaps(viewport.paintBounds);
    }
    return false;
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}

class MessageChatState extends BaseGetState {
  late IMsgChat chat;

  ChatBoxController get chatBoxCtrl => Get.find();

  late GlobalKey scrollKey;

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