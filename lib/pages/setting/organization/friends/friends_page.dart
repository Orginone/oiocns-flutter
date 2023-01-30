import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/text_avatar.dart';
import 'package:orginone/components/text_search.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/pages/other/search/search_controller.dart';
import 'package:orginone/pages/setting/organization/friends/friends_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class FriendsPage extends GetView<FriendsController> {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("我的好友", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      body: _body,
      floatingButton: FloatingActionButton(
        onPressed: () {
          List<SearchItem> friends = [SearchItem.friends];
          Get.toNamed(Routers.search, arguments: {
            "items": friends,
            "point": FunctionPoint.addFriends,
          });
        },
        backgroundColor: Colors.blueAccent,
        splashColor: Colors.white,
        child: Icon(Icons.person_add, size: 40.w, color: Colors.white),
      ),
    );
  }

  get _body => Column(
        children: [
          TextSearch(
            searchingCallback: controller.searchingCallback,
            margin: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.onLoadFriends("");
              },
              child: _list(),
            ),
          ),
        ],
      );

  Widget _list() {
    return GetBuilder<FriendsController>(
      builder: (controller) => ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.friends.length,
        itemBuilder: (BuildContext context, int index) {
          return _item(controller.friends[index]);
        },
      ),
    );
  }

  Widget _item(Target targetResp) {
    var avatarName = StringUtil.getPrefixChars(targetResp.name, count: 2);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Get.toNamed(Routers.personDetail, arguments: targetResp.team?.code);
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextAvatar(avatarName: avatarName),
            Container(margin: EdgeInsets.only(left: 10.w)),
            Expanded(
              child: Text(targetResp.name, style: AFont.instance.size22Black3),
            )
          ],
        ),
      ),
    );
  }
}
