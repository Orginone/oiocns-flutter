import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/model/db_model.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';
import 'package:orginone/page/home/message/chat/component/chat_box.dart';
import 'package:orginone/util/date_util.dart';

import '../../../../component/unified_edge_insets.dart';
import '../../../../routers.dart';
import '../../../../util/widget_util.dart';
import 'component/chat_message_detail.dart';

class ChatPage extends GetView<ChatController> {
  const ChatPage({Key? key}) : super(key: key);

  get _title => Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Text(
          controller.messageItem.name ?? "",
          style: text20,
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        ),
        TextTag(
          controller.messageItem.label,
          textStyle: text12WhiteBold,
          bgColor: Colors.blueAccent,
          padding: const EdgeInsets.all(4),
        )
      ]);

  get _actions => <Widget>[
        GFIconButton(
            color: Colors.white.withOpacity(0),
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onPressed: () {
              Get.toNamed(Routers.messageSetting);
            })
      ];

  Widget _chatItem(int index) {
    ChatMessageDetail currentWidget = controller.messageDetails[index];
    if (index == 0) {
      return currentWidget;
    } else {
      MessageDetail pre = controller.messageDetails[index - 1].messageDetail;
      MessageDetail current = currentWidget.messageDetail;
      if (current.createTime == null || current.createTime == null) {
        return currentWidget;
      }
      var difference = current.createTime!.difference(pre.createTime!);
      if (difference.inSeconds > 60) {
        return Column(
          children: [
            Container(
              alignment: Alignment.center,
              margin: topSmall,
              child: Text(
                CustomDateUtil.getDetailTime(current.createTime!),
                style: text12Grey,
              ),
            ),
            currentWidget
          ],
        );
      }
      return currentWidget;
    }
  }

  get _body => Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: RefreshIndicator(
                  onRefresh: () async {
                    var currentPage = controller.currentPage;
                    if (currentPage <= 1) {
                      EasyLoading.showToast("数据已更新完全");
                      return;
                    }
                    controller.currentPage = currentPage - 1;
                    await controller.getPageDataAndRender();
                  },
                  child: Scrollbar(
                      key: UniqueKey(),
                      child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Obx(() => ListView.builder(
                              controller: controller.messageScrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: controller.messageDetails.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _chatItem(index);
                              })))))),
          const ChatBox()
        ],
      );

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: _title,
      appBarActions: _actions,
      body: _body,
    );
  }
}
