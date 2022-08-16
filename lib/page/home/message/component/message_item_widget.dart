import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/routers.dart';

class MessageItemWidget extends GetView<MessageController> {
  // 用户信息
  final int groupId;
  final String username;

  const MessageItemWidget(this.groupId, this.username, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          MessageController messageController = Get.find();
          messageController.currentGroupId = groupId;
          Get.toNamed(Routers.chat);
        },
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    alignment: Alignment.center,
                    width: 54,
                    height: 54,
                    decoration: const BoxDecoration(
                        color: CustomColors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Stack(children: [
                      Align(
                          alignment: Alignment.center,
                          child: Text(
                            username
                                .substring(0, username.length >= 2 ? 2 : 1)
                                .toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          )),
                      Obx(() {
                        var notReadCount = controller
                                .latestDetailMap[groupId]?.notReadCount.value ??
                            0;
                        return Visibility(
                            visible: notReadCount > 0,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: GFBadge(child: Text("$notReadCount"))));
                      })
                    ])),
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        height: 50,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.currentUserInfo.id == groupId
                                          ? "$username（我）"
                                          : username,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Obx(() => Text(formatDate(
                                        controller.latestDetailMap[groupId]
                                                ?.createTime.value ??
                                            DateTime.now(),
                                        [HH, ':', nn, ':', ss])))
                                  ]),
                              Obx(() => Text(controller.latestDetailMap[groupId]
                                      ?.msgBody.value ??
                                  ""))
                            ])))
              ]),
        ));
  }
}
