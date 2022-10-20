import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/page/home/home_controller.dart';
import 'package:orginone/page/home/message/message_controller.dart';
import 'package:orginone/util/hive_util.dart';

import '../../../component/choose_item.dart';
import '../../../component/unified_edge_insets.dart';
import '../../../component/unified_text_style.dart';
import '../../../routers.dart';
import 'component/group_item_widget.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: 120.w,
        child: TabBar(
          controller: controller.tabController,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: EdgeInsets.only(top: 10.h, bottom: 6.h),
          labelStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          labelColor: Colors.black,
          tabs: const [
            Text("会话"),
            Text("通讯录"),
          ],
        ),
      ),
      Expanded(
        child: TabBarView(
          controller: controller.tabController,
          children: [_chat(), _relation()],
        ),
      )
    ]);
  }

  Widget _chat() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshCharts();
      },
      child: GetBuilder<MessageController>(
        init: controller,
        builder: (controller) => ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: controller.orgChatCache.chats.length,
          itemBuilder: (BuildContext context, int index) {
            return GroupItemWidget(index);
          },
        ),
      ),
    );
  }

  Widget _relation() {
    List<Widget> children = [];
    children.addAll(_recent());
    children.add(Container(margin: EdgeInsets.only(top: 10.h)));

    TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
    HomeController homeController = Get.find<HomeController>();
    if (userInfo.id != homeController.currentSpace.id) {
      children.addAll(_tree());
    }

    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      child: Column(children: children),
    );
  }

  List<Widget> _recent() {
    double avatarWidth = 44.w;
    return [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "最近联系",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          GestureDetector(onTap: () {}, child: const Text("更多"))
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 10.h),
        height: avatarWidth,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(6.w)),
              ),
              margin: EdgeInsets.only(right: 12.w),
              child: CachedNetworkImage(
                  width: avatarWidth,
                  height: avatarWidth,
                  imageUrl:
                      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fblog%2F202105%2F04%2F20210504062111_d8dc3.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1668839600&t=153f1b08bff7c682539eabde8c2f862f"),
            );
          },
        ),
      )
    ];
  }

  List<Widget> _tree() {
    return [
      ChooseItem(
        padding: EdgeInsets.zero,
        header: const TextTag("单位"),
        body: Container(
          margin: left10,
          child: Text("组织架构", style: text16Bold),
        ),
        func: () {
          Get.toNamed(Routers.dept);
        },
      )
    ];
  }
}
