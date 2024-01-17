import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/widgets/target_text.dart';
import 'package:orginone/components/widgets/text_tag.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_bean.dart';
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
    list = [];
    List<Hierarchy> companyItems = [];

    // for (var company in relationCtrl.user.companys) {
    //   for (var chats in company.chats) {
    //     companyItems.add(
    //       Hierarchy(
    //         // type: ChatType.list,
    //         msg: chats,
    //         children: [
    //           // Hierarchy(
    //           //   msg: relationCtrl.chats.last,
    //           //   children: company.memberChats
    //           //       .map((item) => Hierarchy(msg: item, children: []))
    //           //       .toList(),
    //           // ),
    //           // ...company.cohortChats
    //           //     .where((i) => i.isMyChat)
    //           //     .map((item) => Hierarchy(msg: item, children: []))
    //           //     .toList(),
    //         ],
    //       ),
    //     );
    //   }
    // }
    // list = [
    //   //   Hierarchy(
    //   //       msg: relationCtrl.chats.last,
    //   //       children: [
    //   //         // Hierarchy(
    //   //         //   msg: relationCtrl.chats.last,
    //   //         //   children: relationCtrl.user.memberChats
    //   //         //       .map((chat) => Hierarchy(msg: chat, children: []))
    //   //         //       .toList(),
    //   //         // ),
    //   //         ...relationCtrl.user.cohortChats
    //   //             .where((i) => i.isMyChat)
    //   //             .map((item) => Hierarchy(msg: item, children: []))
    //   //             .toList(),
    //   //       ],
    //   //       type: ChatType.list),
    //   // Hierarchy(
    //   //   msg: relationCtrl.user.chats.last,
    //   //   children: [],
    //   // ),
    //   ...companyItems,
    // ];

    for (var element in relationCtrl.chats.value) {
      list.add(Hierarchy(msg: element, children: []));
    }
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
        return GestureDetector(
            onTap: () {
              if (item.type == ChatType.chat) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text("发送给${item.msg.chatdata.value.chatName}?"),
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
                            var msgType = MessageType.getType(widget.msgType);
                            var success = await item.msg.sendMessage(
                                msgType!,
                                msgType == MessageType.text
                                    ? widget.msgBody.msgSource
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
                  if (success ?? false) {
                    if (widget.onSuccess != null) {
                      widget.onSuccess!();
                    }
                  }
                });
              }
            },
            child: Container(
              padding:
                  EdgeInsets.only(top: 2.h, bottom: 2.h, left: leftPadding),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(
                          top: 12.h, bottom: 12.h, left: leftPadding),
                      color: XColors.bgColor,
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
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Text(
                                  item.msg.share.name,
                                  textAlign: TextAlign.left,
                                ),
                                Row(
                                  children: [...item.labels],
                                )
                              ])),
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
                      )),
                  item.children.isNotEmpty && item.isOpen
                      ? buildList(item.children,
                          physics: const NeverScrollableScrollPhysics(),
                          leftPadding: 20.w)
                      : const SizedBox(),
                ],
              ),
            ));
      },
    );
  }
}

class Hierarchy {
  late ISession msg;
  late ChatType type;
  bool isOpen = false;
  bool isSelected = false;
  bool isUserLabel = false;
  late List<Hierarchy> children;

  Hierarchy(
      {required this.msg, this.type = ChatType.chat, required this.children});

  List<Widget> get labels {
    var labels = <Widget>[];
    for (var item in msg.groupTags) {
      if (item.isNotEmpty) {
        bool isTop = item == "置顶";

        Widget label;

        var style = TextStyle(
          color: isTop ? XColors.fontErrorColor : XColors.designBlue,
          fontSize: 14.sp,
        );
        if (isUserLabel) {
          label = Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: XColors.tinyBlue),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: TargetText(userId: item, style: style),
          );
        } else {
          label = TextTag(
            item,
            bgColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
            textStyle: style,
            borderColor: isTop ? XColors.fontErrorColor : XColors.tinyBlue,
          );
        }

        labels.add(label);
        labels.add(Padding(padding: EdgeInsets.only(left: 4.w)));
      }
    }
    return labels;
  }
}
