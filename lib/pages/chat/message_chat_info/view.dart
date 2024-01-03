import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/values/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/config/unified.dart';

import 'logic.dart';
import 'state.dart';

class MessageChatInfoPage
    extends BaseGetView<MessageChatInfoController, MessageChatInfoState> {
  const MessageChatInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            title(),
            SizedBox(
              height: 10.h,
            ),
            tileWidget(
                title: "动态",
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 15.w),
                        child: ImageWidget(
                          AssetsImages.empty,
                          size: 60.w,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList())),
            tileWidget(
                title: "共享",
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 15.w),
                        child: ImageWidget(
                          AssetsImages.empty,
                          size: 60.w,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList())),
            tileWidget(
                title: "交易",
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 15.w),
                        child: ImageWidget(
                          AssetsImages.empty,
                          size: 60.w,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList())),
            tileWidget(
                title: "群应用",
                trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(4, (index) {
                      return Container(
                        margin: EdgeInsets.only(right: 15.w),
                        child: ImageWidget(
                          AssetsImages.empty,
                          size: 60.w,
                          fit: BoxFit.fill,
                        ),
                      );
                    }).toList())),
          ],
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 120.h,
        child: Builder(builder: (context) {
          List<Widget> children = [
            circle(
                icon: Ionicons.chatbubble_sharp,
                lable: "发消息",
                callback: () {
                  controller.jumpMessage();
                }),
            circle(icon: Ionicons.call_sharp, lable: "打电话"),
          ];
          if (!state.isFriend) {
            children.add(circle(
                icon: Ionicons.person_add_sharp,
                lable: "加好友",
                callback: () {
                  controller.addPerson();
                }));
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          );
        }),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ImageWidget(
            state.chat.share.avatar?.thumbnailUint8List ??
                state.chat.share.avatar?.defaultAvatar,
            size: 72.w,
            radius: 12.w,
          ),
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  state.chat.share.name,
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(
                  height: 5.w,
                ),
                Text(
                  state.chat.chatdata.value.chatRemark,
                  style: TextStyle(fontSize: 16.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: IconButton(
              onPressed: () {
                controller.jumpQr();
              },
              icon: const Icon(Ionicons.qr_code_outline),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(maxWidth: 30.w),
            ),
          )
        ],
      ),
    );
  }

  Widget dynamic() {
    return tileWidget(title: "动态");
  }

  Widget circle(
      {required IconData icon, required String lable, VoidCallback? callback}) {
    return GestureDetector(
      onTap: callback,
      child: Column(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: const BoxDecoration(
              color: XColors.themeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24.w,
            ),
          ),
          SizedBox(
            height: 5.h,
          ),
          Text(
            lable,
            style: TextStyle(color: XColors.themeColor, fontSize: 18.sp),
          )
        ],
      ),
    );
  }

  Widget tileWidget(
      {required String title, Widget? trailing, VoidCallback? callback}) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 20.sp),
            ),
            Expanded(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                trailing ?? const SizedBox(),
                const Icon(Ionicons.chevron_forward),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
