import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/routers.dart';

import '../../../../../component/a_font.dart';
import '../../../../../component/choose_item.dart';
import '../../../../../component/unified_edge_insets.dart';
import '../../../../../component/unified_text_style.dart';
import '../../../../../util/widget_util.dart';
import '../../../search/search_controller.dart';
import 'friend_add_controller.dart';

class FriendAddPage extends GetView<FriendAddController> {
  const FriendAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarCenterTitle: true,
      appBarTitle: Text("好友添加", style: AFont.instance.size22Black3),
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextSearch(
            placeHolder: FunctionPoint.addFriends.placeHolder,
            onTap: () {
              List<SearchItem> friends = [SearchItem.friends];
              Get.toNamed(Routers.search, arguments: {
                "items": friends,
                "point": FunctionPoint.addFriends,
              });
            },
          ),
          Container(margin: EdgeInsets.only(top: 6.h)),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routers.mineCard);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("我的名片", style: text16),
                Icon(Icons.qr_code, color: Colors.blueAccent, size: 20.w),
              ],
            ),
          ),
          Container(margin: EdgeInsets.only(top: 6.h)),
          ChooseItem(
            header: const Icon(Icons.qr_code_scanner, color: Colors.blueAccent),
            body: Container(
              margin: left10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("扫一扫", style: text16Bold),
                  Text("扫描二维码名片", style: text12Grey),
                ],
              ),
            ),
            func: () {
              Get.toNamed(Routers.scanning);
            },
          )
        ],
      ),
    );
  }
}
