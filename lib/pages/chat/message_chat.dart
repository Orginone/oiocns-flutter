import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  Widget _content(List<MsgSaveModel> messages) {
    return Container(
      color: XColors.bgChat,
      child: RefreshIndicator(
        onRefresh: () => state.chat.moreMessage(),
        child: Container(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Obx(
            () => ListView.builder(
              reverse: true,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(index);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int index) {
    MsgSaveModel msg = state.chat.messages[index];
    Widget currentWidget = DetailItemWidget(msg: msg, chat: state.chat);
    var time = _time(msg.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == state.chat.messages.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      MsgSaveModel pre = state.chat.messages[index + 1];
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

  void forward(String msgType,String text) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MessageForward(text: text, msgType: msgType,onSuccess: (){
            Navigator.pop(context);
          },);
        },
        isScrollControlled: true,
        isDismissible: false,
        useSafeArea: true,
        barrierColor: Colors.white);
  }
}

class MessageChatState extends BaseGetState {
  late IMsgChat chat;

  ChatBoxController get chatBoxCtrl => Get.find();

  MessageChatState() {
    chat = Get.arguments;
  }
}

class MessageChatBinding extends BaseBindings<MessageChatController> {
  @override
  MessageChatController getController() {
    return MessageChatController();
  }
}