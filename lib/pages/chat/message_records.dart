import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message/message.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/event/message.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';


class MessageRecordsPage
    extends BaseGetView<MessageRecordsController, MessageRecordsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleWidget: CommonWidget.commonSearchBarWidget(
          hint: "聊天记录",
          searchColor: Colors.grey.shade200,
          onChanged: (str) {
            controller.searchMsg(str);
          }),
      leading: const SizedBox(),
      leadingWidth: 0,
      actions: [
        GestureDetector(
          child: Center(
            child: Text(
              "取消",
              style: TextStyle(color: XColors.themeColor, fontSize: 22.sp),
            ),
          ),
          onTap: () {
            Get.back();
          },
        ),
        SizedBox(
          width: 10.w,
        ),
      ],
      body: Obx(() {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            var item = state.searchMsg[index];

            return Container(
              decoration: BoxDecoration(
                  border: Border(
                bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
              )),
              child: FutureBuilder<ShareIcon>(
                builder: (context, snapshot) {
                  return ListTile(
                    leading: TeamAvatar(
                      info: TeamTypeInfo(userId: item.metadata.fromId),
                      size: 55.w,
                    ),
                    title: Text(snapshot.data?.name ?? ""),
                    subtitle: Text(
                      StringUtil.msgConversion(item.metadata, ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      EventBusHelper.fire(JumpSpecifyMessage(item));
                      Get.until((route) =>
                          route.settings.name == Routers.messageChat);
                    },
                  );
                },
                future: item.from,
              ),
            );
          },
          itemCount: state.searchMsg.length,
        );
      }),
    );
  }
}

class MessageRecordsController extends BaseController<MessageRecordsState> {
  final MessageRecordsState state = MessageRecordsState();

  void searchMsg(String str) {
    state.searchMsg.clear();
    if (str.isNotEmpty) {
      state.searchMsg.value = state.chat.messages
          .where((p0) =>
              p0.msgBody.toLowerCase().contains(str.toLowerCase()) &&
              p0.msgType == MessageType.text.label)
          .toList();
    }
  }
}

class MessageRecordsBinding extends BaseBindings<MessageRecordsController> {
  @override
  MessageRecordsController getController() {
    return MessageRecordsController();
  }
}

class MessageRecordsState extends BaseGetState {
  late IMsgChat chat;
  var searchMsg = <IMessage>[].obs;

  MessageRecordsState() {
    chat = Get.arguments['chat'];
  }
}
