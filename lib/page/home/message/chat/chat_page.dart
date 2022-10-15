import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/message_detail_resp.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/chat/component/chat_box.dart';
import 'package:orginone/util/date_util.dart';

import '../../../../api_resp/message_item_resp.dart';
import '../../../../component/unified_edge_insets.dart';
import '../../../../enumeration/target_type.dart';
import '../../../../routers.dart';
import '../../../../util/hive_util.dart';
import '../../../../util/widget_util.dart';
import 'component/chat_message_detail.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      resizeToAvoidBottomInset: false,
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: _title,
      appBarActions: _actions,
      body: _body(context),
    );
  }

  get _title => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Obx(() => Text(
                controller.titleName.value,
                style: text20,
              )),
          Container(
            margin: left10,
          ),
          TextTag(
            controller.messageItem.label,
            textStyle: text12WhiteBold,
            bgColor: Colors.blueAccent,
            padding: const EdgeInsets.all(4),
          )
        ],
      );

  get _actions => <Widget>[
        GFIconButton(
          color: Colors.white.withOpacity(0),
          icon: const Icon(Icons.more_horiz, color: Colors.black),
          onPressed: () {
            Map<String, dynamic> args = {
              "spaceId": controller.spaceId,
              "messageItemId": controller.messageItemId,
              "messageItem": controller.messageItem,
              "personList": controller.personList
            };
            Get.toNamed(Routers.messageSetting, arguments: args);
          },
        ),
      ];

  Widget _time(DateTime? dateTime) {
    return Container(
      alignment: Alignment.center,
      margin: top10,
      child: Text(
        dateTime != null ? CustomDateUtil.getDetailTime(dateTime) : "",
        style: text10Grey,
      ),
    );
  }

  Widget _chatItem(int index) {
    MessageItemResp messageItem = controller.messageItem;
    MessageDetailResp messageDetail = controller.messageDetails[index];

    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
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
    if (index == controller.messageDetails.length - 1) {
      item.children.insert(0, time);
      return item;
    } else {
      MessageDetailResp pre = controller.messageDetails[index + 1];
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
        controller.chatBoxController.eventFire(context, InputEvent.clickBlank);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.getHistoryMsg();
                controller.update();
              },
              child: Container(
                padding: lr10,
                child: GetBuilder<ChatController>(
                  builder: (controller) => ListView.builder(
                    reverse: true,
                    shrinkWrap: true,
                    controller: controller.messageScrollController,
                    scrollDirection: Axis.vertical,
                    itemCount: controller.messageDetails.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _chatItem(index);
                    },
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
