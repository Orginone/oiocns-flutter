import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/utils/date_util.dart';
import 'package:orginone/config/unified.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'info_item.dart';

class MessageList extends StatefulWidget {
  ISession? chat;
  MessageList({Key? key, this.chat}) : super(key: key);

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  MessageChatController get controller => Get.find();

  ISession get chat => widget.chat ?? controller.state.chat;
  bool isBuilded = false;

  @override
  void dispose() {
    super.dispose();
    chat.unMessage();
  }

  @override
  void initState() {
    super.initState();
    chat.onMessage((messages) => null).then((value) {
      if (!isBuilded) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    isBuilded = true;
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) {
          // "开始滚动"
        } else if (notification is ScrollUpdateNotification) {
          // "正在滚动。。。总滚动距离：${notification.metrics.maxScrollExtent}"
        } else if (notification is ScrollEndNotification) {
          // "停止滚动"
          controller.markVisibleMessagesAsRead();
        }
        return true;
      },
      child: RefreshIndicator(
          onRefresh: () => controller.state.chat.moreMessage(),
          child: Obx(() {
            return ScrollablePositionedList.builder(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              shrinkWrap: true,
              key: controller.state.scrollKey,
              reverse: true,
              physics: const ClampingScrollPhysics(),
              itemScrollController: controller.state.itemScrollController,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              itemCount: chat.messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _item(index);
              },
            );
          })),
    );
  }

  Widget _item(int index) {
    IMessage msg = chat.messages[index];
    Widget currentWidget = DetailItemWidget(
      msg: msg,
      chat: chat,
      key: GlobalKey(debugLabel: msg.metadata.id),
    );
    var time = _time(msg.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == chat.messages.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      IMessage pre = chat.messages[index + 1];
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
