import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/logic/chat/i_chat.dart';

class GroupItemWidget extends StatelessWidget {
  final IChatGroup chatGroup;

  const GroupItemWidget(this.chatGroup, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var line = const Divider(height: 0);
    List<Widget> children = [_title, line, _chats];
    children.add(Obx(() => chatGroup.isOpened ? Container() : line));
    return Column(children: children);
  }

  get _title {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        chatGroup.openOrNot(!chatGroup.isOpened);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20.w, top: 10.h, bottom: 10.h),
            child: Text(
              "${chatGroup.spaceName}(${chatGroup.chats.length})",
              style: AFont.instance.size22Black3W500,
            ),
          ),
          Container(
            padding: EdgeInsets.only(right: 20.w),
            child: Obx(() {
              return Icon(
                chatGroup.isOpened ? Icons.arrow_drop_down : Icons.arrow_right,
                size: 30.w,
              );
            }),
          ),
        ],
      ),
    );
  }

  get _chats => Obx(() {
        if (!chatGroup.isOpened) {
          return Container();
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: 16.h),
          itemCount: chatGroup.chats.length,
          itemBuilder: (context, index) {
            return chatGroup.chats[index].mapping();
          },
        );
      });
}
