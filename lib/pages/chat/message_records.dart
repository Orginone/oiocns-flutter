import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/dart/core/public/enums.dart';

import 'package:orginone/utils/event_bus_helper.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/components/widgets/team_avatar.dart';

class MessageRecordsPage
    extends BaseGetView<MessageRecordsController, MessageRecordsState> {
  const MessageRecordsPage({super.key});

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
        if (state.isSearchState.value && state.searchMsg.isEmpty) {
          return noData();
        }

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
                      StringUtil.msgConversion(
                          item.metadata as MsgSaveModel, ''),
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
                future: Future(() => item.from),
              ),
            );
          },
          itemCount: state.searchMsg.length,
        );
      }),
    );
  }

  Widget noData() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      child: Image.asset(
        AssetsImages.empty,
        width: 300.w,
        height: 400.w,
      ),
    );
  }
}

class MessageRecordsController extends BaseController<MessageRecordsState> {
  @override
  final MessageRecordsState state = MessageRecordsState();

  void searchMsg(String str) {
    state.isSearchState.value = str.isNotEmpty;
    state.searchMsg.clear();
    if (str.isNotEmpty) {
      state.searchMsg.value = state.chat.messages.where((p0) {
        String text = p0.msgBody ?? "";

        text = text.replaceAll(StringUtil.imgReg, '');

        bool isSearchText = p0.msgType == MessageType.text.label &&
            text.toLowerCase().contains(str.toLowerCase());
        if (isSearchText) {
          print(text);
        }

        return isSearchText;
      }).toList();
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
  late ISession chat;
  var searchMsg = <IMessage>[].obs;
  var isSearchState = false.obs;

  MessageRecordsState() {
    chat = Get.arguments['chat'];
  }
}
