import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'message_routers.dart';

class MessageForward extends StatefulWidget {

  final String text;

  final String msgType;

  final VoidCallback? onSuccess;

  const MessageForward({Key? key, required this.text, required this.msgType, this.onSuccess}) : super(key: key);

  @override
  State<MessageForward> createState() => _MessageForwardState();
}

class _MessageForwardState extends State<MessageForward> {
  SettingController get setting => Get.find();

  late List<Hierarchy> list;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    List<Hierarchy> companyItems = [];
    for (var company in setting.user.companys) {
      companyItems.add(
        Hierarchy(
          type: ChatType.list,
          msg: company,
          children: [
            Hierarchy(
              msg: company,
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
          msg: setting.user,
          children: [
            Hierarchy(
              msg: setting.user,
              children: setting.user.memberChats
                  .map((chat) => Hierarchy(msg: chat, children: []))
                  .toList(),
            ),
            ...setting.user.cohortChats
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

  Widget buildList(List<Hierarchy> list, {ScrollPhysics? physics,double leftPadding = 0}) {
    return ListView.builder(
      physics: physics,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: list.length,
      itemBuilder: (BuildContext context, int index) {
        var item = list[index];
        return Container(
          padding: EdgeInsets.only(top: 10.h,bottom: 10.h,left: leftPadding),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  if(item.type == ChatType.chat){
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
                                var success = await item.msg.sendMessage(MessageType.getType(widget.msgType)!, widget.text);
                                if(success){
                                  ToastUtils.showMsg(msg: "转发成功");
                                }
                                Navigator.pop(context,success);
                              },
                            ),
                          ],
                        );
                      },
                    ).then((success){
                      if(success){
                        if(widget.onSuccess!=null){
                          widget.onSuccess!();
                        }
                      }
                    });
                  }
                },
                child: Row(
                  children: [
                    AdvancedAvatar(
                      size: 50.w,
                      decoration: BoxDecoration(
                          color: XColors.themeColor,
                          borderRadius: BorderRadius.all(Radius.circular(8.w)),
                         ),
                      child: ImageWidget(item.msg.share.avatar?.thumbnailUint8List??item.msg.share.avatar?.defaultAvatar),
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
                      physics: const NeverScrollableScrollPhysics(),leftPadding: 20.w)
                  : const SizedBox(),
            ],
          ),
        );
      },
    );
  }
}

class Hierarchy {
  late IMsgChat msg;
  late ChatType type;
  bool isOpen = false;
  bool isSelected = false;
  late List<Hierarchy> children;

  Hierarchy(
      {required this.msg, this.type = ChatType.chat, required this.children});
}
