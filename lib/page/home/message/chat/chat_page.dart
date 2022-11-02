import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/chat/component/chat_box.dart';
import 'package:orginone/util/date_util.dart';

import '../../../../api_resp/message_item_resp.dart';
import '../../../../component/a_font.dart';
import '../../../../enumeration/target_type.dart';
import '../../../../logic/authority.dart';
import '../../../../routers.dart';
import '../../../../util/widget_util.dart';
import 'component/chat_message_detail.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarHeight: 74.h,
      resizeToAvoidBottomInset: false,
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: _title,
      appBarCenterTitle: true,
      appBarActions: _actions,
      body: _body(context),
    );
  }

  get _title {
    var spaceMap = controller.messageController.spaceMap;
    var space = spaceMap[controller.spaceId];
    var messageItem = controller.messageItem;

    var style = TextStyle(color: UnifiedColors.black9, fontSize: 14.sp);
    return Column(
      children: [
        Obx(() => Text(controller.titleName.value, style: text22Bold)),
        Text("${space?.name} | ${messageItem.label}", style: style),
      ],
    );
  }

  get _actions => <Widget>[
        GFIconButton(
          color: Colors.white.withOpacity(0),
          icon: Icon(
            Icons.more_horiz,
            color: UnifiedColors.black3,
            size: 32.w,
          ),
          onPressed: () {
            Map<String, dynamic> args = {
              "spaceId": controller.spaceId,
              "messageItemId": controller.messageItemId,
              "messageItem": controller.messageItem,
            };
            Get.toNamed(Routers.messageSetting, arguments: args);
          },
        ),
      ];

  Widget _time(DateTime? dateTime) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
      child: Text(
        dateTime != null ? CustomDateUtil.getDetailTime(dateTime) : "",
        style: AFont.instance.size20Black9,
      ),
    );
  }

  Widget _chatItem(int index) {
    MessageItemResp messageItem = controller.messageItem;
    MessageDetailResp messageDetail = controller.details[index].resp;

    TargetResp userInfo = auth.userInfo;
    bool isMy = messageDetail.fromId == userInfo.id;
    bool isMultiple = messageItem.typeName != TargetType.person.name;

    Widget currentWidget = ChatMessageDetail(
      detail: messageDetail,
      isMy: isMy,
      isMultiple: isMultiple,
    );

    var time = _time(messageDetail.createTime);
    var item = Column(children: [currentWidget]);
    if (index == 0) {
      item.children.add(Container(margin: EdgeInsets.only(bottom: 5.h)));
    }
    if (index == controller.details.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      MessageDetailResp pre = controller.details[index + 1].resp;
      if (messageDetail.createTime != null && pre.createTime != null) {
        var difference = messageDetail.createTime!.difference(pre.createTime!);
        if (difference.inSeconds > 60) {
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
              color: UnifiedColors.bgColor,
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.getHistoryMsg(isCacheNameMap: true);
                  controller.update();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Obx(
                    () => ListView.builder(
                      reverse: true,
                      shrinkWrap: true,
                      controller: controller.messageScrollController,
                      scrollDirection: Axis.vertical,
                      itemCount: controller.details.length,
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
