import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/components/widgets/image_widget.dart';

import 'message_routers.dart';

class MessageForward extends StatefulWidget {
  final IMessage msgBody;

  final String msgType;

  final VoidCallback? onSuccess;

  const MessageForward(
      {Key? key, required this.msgBody, required this.msgType, this.onSuccess})
      : super(key: key);

  @override
  State<MessageForward> createState() => _MessageForwardState();
}

class _MessageForwardState extends State<MessageForward> {
  late List<Hierarchy> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Hierarchy> companyItems = [];
    for (var company in settingCtrl.user.companys) {
      companyItems.add(
        Hierarchy(
          type: ChatType.list,
          msg: settingCtrl.chats.last,
          children: [
            Hierarchy(
              msg: settingCtrl.chats.last,
              children: company.memberChats
                  .map((item) => Hierarchy(msg: item, children: []))
                  .toList(),
            ),
            ...company.cohortChats
                .where((i) => i.isMyChat)
                .map((item) => Hierarchy(msg: item, children: []))
                .toList(),
          ],
        ),
      );
    }
    list = [
      Hierarchy(
          msg: settingCtrl.chats.last,
          children: [
            Hierarchy(
              msg: settingCtrl.chats.last,
              children: settingCtrl.user.memberChats
                  .map((chat) => Hierarchy(msg: chat, children: []))
                  .toList(),
            ),
            ...settingCtrl.user.cohortChats
                .where((i) => i.isMyChat)
                .map((item) => Hierarchy(msg: item, children: []))
                .toList(),
          ],
          type: ChatType.list),
      ...companyItems,
    ];
  }

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      titleName: "发送给",
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: buildList(list)),
    );
  }

  Widget buildList(List<Hierarchy> list,
      {ScrollPhysics? physics, double leftPadding = 0}) {
    return ListView.builder(
      physics: physics,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var item = list[index];
        return Container(
          padding: EdgeInsets.only(top: 10.h, bottom: 10.h, left: leftPadding),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  if (item.type == ChatType.chat) {
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title:
                              Text("发送给${item.msg.chatdata.value.chatName}?"),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text('取消'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('确定'),
                              onPressed: () async {
                                var msgType =
                                    MessageType.getType(widget.msgType);
                                var success = await item.msg.sendMessage(
                                    msgType!,
                                    msgType == MessageType.text
                                        ? widget.msgBody.msgType
                                        : widget.msgBody.msgSource,
                                    []);
                                if (success) {
                                  ToastUtils.showMsg(msg: "转发成功");
                                }
                                Navigator.pop(context, success);
                              },
                            ),
                          ],
                        );
                      },
                    ).then((success) {
                      if (success) {
                        if (widget.onSuccess != null) {
                          widget.onSuccess!();
                        }
                      }
                    });
                  }
                },
                child: Row(
                  children: [
                    ImageWidget(
                      item.msg.share.avatar?.thumbnailUint8List ??
                          item.msg.share.avatar?.defaultAvatar,
                      size: 50.w,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Expanded(
                        child: Text(
                      item.msg.share.name,
                      textAlign: TextAlign.left,
                    )),
                    item.children.isNotEmpty
                        ? IconButton(
                            icon: Icon(item.isOpen
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down),
                            onPressed: () {
                              item.isOpen = !item.isOpen;
                              setState(() {});
                            },
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              item.children.isNotEmpty && item.isOpen
                  ? buildList(item.children,
                      physics: const NeverScrollableScrollPhysics(),
                      leftPadding: 20.w)
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

class Hierarchy {
  late ISession msg;
  late ChatType type;
  bool isOpen = false;
  bool isSelected = false;
  late List<Hierarchy> children;

  Hierarchy(
      {required this.msg, this.type = ChatType.chat, required this.children});
}
