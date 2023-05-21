import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_util.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';

class MessageChat extends StatefulWidget {
  const MessageChat({super.key});

  @override
  State<StatefulWidget> createState() => _MessageChatState();
}

class _MessageChatState extends State<MessageChat> {
  final IMsgChat chat = Get.arguments;
  final chatBoxCtrl = ChatBoxController();

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarHeight: 74.h,
      appBarBgColor: XColors.navigatorBgColor,
      resizeToAvoidBottomInset: false,
      appBarLeading: XWidgets.defaultBackBtn,
      appBarTitle: _title(chat),
      appBarCenterTitle: true,
      appBarActions: _actions(chat),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          chatBoxCtrl.eventFire(context, InputEvent.clickBlank, chat);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: _content(chat, chat.messages)),
            ChatBox(chat: chat, controller: chatBoxCtrl)
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    chatBoxCtrl.dispose();
    super.dispose();
  }

  Widget _title(IMsgChat chat) {
    String name = chat.chatdata.value.chatName ?? "";
    if (chat.memberChats.length > 1) {
      name += "(${chat.memberChats.length})";
    }
    var spaceName = chat.chatdata.value.labels.join(" | ");
    return Column(
      children: [
        Text(name, style: XFonts.size22Black3),
        Text(spaceName, style: XFonts.size14Black9),
      ],
    );
  }

  List<Widget> _actions(IMsgChat chat) {
    return <Widget>[
      GFIconButton(
        color: Colors.white.withOpacity(0),
        icon: Icon(
          Icons.more_horiz,
          color: XColors.black3,
          size: 32.w,
        ),
        onPressed: () async {
          Get.toNamed(Routers.messageSetting, arguments: chat);
        },
      ),
    ];
  }

  Widget _content(IMsgChat chat, List<MsgSaveModel> messages) {
    return Container(
      color: XColors.bgColor,
      child: RefreshIndicator(
        onRefresh: () => chat.moreMessage(),
        child: Container(
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          child: Obx(
            () => ListView.builder(
              reverse: true,
              shrinkWrap: true,
              controller: ScrollController(),
              scrollDirection: Axis.vertical,
              itemCount: messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(index, chat);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _item(int index, IMsgChat chat) {
    MsgSaveModel msg = chat.messages[index];
    Widget currentWidget = DetailItemWidget(msg: msg, chat: chat);

    var time = _time(msg.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == chat.messages.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      MsgSaveModel pre = chat.messages[index + 1];
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
