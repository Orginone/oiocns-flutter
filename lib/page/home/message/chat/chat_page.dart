import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/message/chat/component/chat_box.dart';
import 'package:orginone/page/home/message/chat/chat_controller.dart';

import '../../../../routers.dart';
import '../../../../util/widget_util.dart';

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
        TextTag(controller.messageItem.label)
      ]);

  get _actions => <Widget>[
        GFIconButton(
            icon: const Icon(Icons.more_horiz),
            onPressed: () {
              Get.toNamed(Routers.messageSetting);
            })
      ];

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
                          padding: const EdgeInsets.all(10),
                          child: Obx(() => ListView.builder(
                              controller: controller.messageScrollController,
                              scrollDirection: Axis.vertical,
                              itemCount: controller.messageDetails.length,
                              itemBuilder: (BuildContext context, int index) {
                                return controller.messageDetails[index];
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
