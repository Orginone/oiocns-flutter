import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/pages/chat/widgets/chat_box.dart';
import 'package:orginone/pages/chat/widgets/detail_item_widget.dart';
import 'package:orginone/util/date_util.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarHeight: 74.h,
      appBarBgColor: XColors.navigatorBgColor,
      resizeToAvoidBottomInset: false,
      appBarLeading: XWidgets.defaultBackBtn,
      appBarTitle: _title,
      appBarCenterTitle: true,
      appBarActions: _actions,
      body: _body(context),
    );
  }

  get _title {
    return Obx(() {
      var chat = controller.chat;
      var messageItem = chat!.target;
      String name = messageItem.name;
      if (messageItem.typeName != TargetType.person.label) {
        name += "(${chat.personCount})";
      }
      String spaceName = "${chat.spaceName} | ${messageItem.label}";
      return Column(
        children: [
          Text(name, style: XFonts.size22Black3),
          Text(spaceName, style: XFonts.size14Black9),
        ],
      );
    });
  }

  get _actions => <Widget>[
        GFIconButton(
          color: Colors.white.withOpacity(0),
          icon: Icon(
            Icons.more_horiz,
            color: XColors.black3,
            size: 32.w,
          ),
          onPressed: () async {
            await controller.setCurrent(controller.chat!);
            Get.toNamed("");
          },
        ),
      ];

  Widget _time(String? dateTime) {
    var content = dateTime != null
        ? CustomDateUtil.getDetailTime(DateTime.parse(dateTime))
        : "";
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
      child: Text(content, style: XFonts.size16Black9),
    );
  }

  Widget _chatItem(int index) {
    var chat = controller.chat!;
    XImMsg msg = chat.messages[index];
    Widget currentWidget = DetailItemWidget(msg: msg);

    var time = _time(msg.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == chat.messages.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      XImMsg pre = chat.messages[index + 1];
      if (msg.createTime != null && pre.createTime != null) {
        var curCreateTime = DateTime.parse(msg.createTime!);
        var preCreateTime = DateTime.parse(pre.createTime!);
        var difference = curCreateTime.difference(preCreateTime);
        if (difference.inSeconds > 60 * 3) {
          item.children.insert(0, time);
          return item;
        }
      }
      return item;
    }
  }

  Widget _body(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        ChatBoxController chatBoxController = Get.find<ChatBoxController>();
        chatBoxController.eventFire(context, InputEvent.clickBlank);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              color: XColors.bgColor,
              child: RefreshIndicator(
                onRefresh: () => controller.chat!.moreMessage(),
                child: Container(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Obx(
                    () => ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: ScrollController(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.chat!.messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _chatItem(index);
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          ChatBox()
        ],
      ),
    );
  }
}
