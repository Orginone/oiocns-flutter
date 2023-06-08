import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/pages/chat/widgets/chat_item.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

class MessageChats extends GetView<SettingController> {
  const MessageChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: GYColors.backgroundColor,
      child: Obx(() {
        var topChats = controller.chat.topChats;

        var chats = controller.chat.chats;

        return RefreshIndicator(
          onRefresh: () async {
            await controller.provider.reload();
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: recentlyOpened(),
              ),
              SliverToBoxAdapter(
                child: content(),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var chat = topChats[index];
                  return MessageItemWidget(chat: chat);
                }, childCount: topChats.length),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  var chat = chats[index];
                  return MessageItemWidget(chat: chat);
                }, childCount: chats.length),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget content() {
    return Container(
      margin: EdgeInsets.only(top: 10.h),
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "最近",
            style: XFonts.size18Black0,
          ),
          DropdownButton(
            items: const [
              DropdownMenuItem(
                value: 'time',
                child: Text('筛选'),
              )
            ],
            style: XFonts.size18Black0,
            onChanged: (String? value) {},
            value: "time",
            underline: const SizedBox(),
            icon: Icon(
              Icons.filter_alt_outlined,
              size: 22.w,
            ),
          ),
        ],
      ),
    );
  }

  Widget recentlyOpened() {
    var recentlyList = [];
    recentlyList
        .add(Recent("0000", "资产监管", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "资产处置", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "通用表格", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "公物仓", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "公益仓", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0000", "资产监管", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "资产处置", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "通用表格", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "公物仓", "${Constant.host}/img/logo/logo3.jpg"));
    recentlyList
        .add(Recent("0001", "公益仓", "${Constant.host}/img/logo/logo3.jpg"));
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20.w, top: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "常用",
                  style: XFonts.size18Black0,
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: recentlyList.map((value) {
                Widget child = button(value);
                int index = recentlyList.indexOf(value);

                if (index != (recentlyList.length - 1)) {
                  child = Container(
                    margin: EdgeInsets.only(right: 15.w),
                    child: child,
                  );
                }
                return Container(
                  margin: EdgeInsets.only(left: index == 0 ? 0 : 27),
                  child: child,
                );
                ;
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget button(Recent recent) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60.w,
            width: 60.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF17BC84),
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Icon(
              Icons.other_houses,
              color: Colors.white,
              size: 48.w,
            ),
          ),
          Text(
            recent.name,
            maxLines: 1,
            style: TextStyle(
                fontSize: 14.sp,
                color: const Color.fromARGB(255, 52, 52, 54),
                overflow: TextOverflow.ellipsis
            ),
          )
        ],
      ),
    );
  }
}

class MessageChatsList extends GetView<MessageChatsListController> {
  const MessageChatsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var chats = controller.chats;
    if (controller.chats.isEmpty) {
      return Container();
    }
    return GyScaffold(
      titleName: "全部回话",
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) {
          var chat = chats[index];
          return MessageItemWidget(
            chat: chat,
            enabledSlidable: false,
          );
        },
      ),
    );
  }
}

class MessageChatsListController extends GetxController {
  late List<IMsgChat> chats;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    chats = Get.arguments['chats'];
    chats.sort((f, s) {
      return (s.chatdata.value.lastMsgTime) - (f.chatdata.value.lastMsgTime);
    });
  }
}

class MessageChatsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageChatsListController());
  }
}
