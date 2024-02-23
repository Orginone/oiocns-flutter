import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/utils/date_util.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/components/widgets/common/image/team_avatar.dart';

Future<void>? showMessageReadDialog(
    BuildContext context,
    List<XTarget> readMember,
    List<XTarget> unreadMember,
    List<IMessageLabel> labels) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.w),
          topRight: Radius.circular(16.w),
        ),
        child: SizedBox(
          height: 800.h,
          child: MessageRead(
            readMember: readMember,
            unreadMember: unreadMember,
            labels: labels,
          ),
        ),
      );
    },
  );
}

class MessageRead extends StatefulWidget {
  final List<XTarget> readMember;
  final List<XTarget> unreadMember;
  final List<IMessageLabel> labels;

  const MessageRead(
      {Key? key,
      required this.readMember,
      required this.unreadMember,
      required this.labels})
      : super(key: key);

  @override
  State<MessageRead> createState() => _MessageReadState();
}

class _MessageReadState extends State<MessageRead>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  final List<String> tabs = ['已读', '未读'];

  @override
  void initState() {
    //
    super.initState();
    controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      titleName: "消息接收人列表",
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: Colors.black,
          )),
      body: Column(
        children: [
          TabBar(
            tabs: [
              Tab(
                text: "${tabs[0]}(${widget.readMember.length})",
              ),
              Tab(
                text: "${tabs[1]}(${widget.unreadMember.length})",
              )
            ],
            controller: controller,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: XColors.black,
            unselectedLabelColor: Colors.grey,
            unselectedLabelStyle: TextStyle(fontSize: 21.sp),
            labelColor: XColors.black,
            labelStyle: TextStyle(fontSize: 23.sp),
          ),
          Container(
            height: 10.h,
            width: double.infinity,
            color: Colors.grey.shade100,
          ),
          Expanded(
            child: TabBarView(
              controller: controller,
              children: [
                buildList(widget.readMember, widget.labels),
                buildList(widget.unreadMember),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildList(List<XTarget> targets, [List<IMessageLabel>? labels]) {
    return ListView.builder(
      itemBuilder: (context, index) {
        var target = targets[index];
        String hint = target.remark ?? "";
        if (labels != null) {
          IMessageLabel label =
              labels.firstWhere((element) => element.userId == target.id);
          hint = "已读:${CustomDateUtil.getSessionTime(label.time)}";
        }
        return Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          )),
          child: ListTile(
            leading: TeamAvatar(
              info: TeamTypeInfo(userId: target.id),
              size: 55.w,
            ),
            title: Text(target.name!),
            subtitle: Text(
              hint,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
      itemCount: targets.length,
    );
  }
}
