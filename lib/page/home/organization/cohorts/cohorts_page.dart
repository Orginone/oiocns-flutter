import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_controller.dart';
import 'package:orginone/util/string_util.dart';

import '../../../../api_resp/target_resp.dart';
import '../../../../component/a_font.dart';
import '../../../../component/text_avatar.dart';
import '../../../../component/text_search.dart';
import '../../../../component/unified_scaffold.dart';
import '../../../../logic/authority.dart';
import '../../../../routers.dart';
import '../../../../util/widget_util.dart';
import '../../search/search_controller.dart';

class CohortsPage extends GetView<CohortsController> {
  const CohortsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("我的群组", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarActions: _actions,
      body: _body,
    );
  }

  get _actions => <Widget>[
        IconButton(
          onPressed: () {
            Get.toNamed(Routers.cohortCreate);
          },
          icon: const Icon(Icons.create_outlined, color: Colors.black),
        ),
        IconButton(
          onPressed: () {
            List<SearchItem> friends = [SearchItem.cohorts];
            Get.toNamed(Routers.search, arguments: {
              "items": friends,
              "point": FunctionPoint.applyFriends,
            });
          },
          icon: const Icon(Icons.add, color: Colors.black),
        ),
      ];

  get _body => Column(
        children: [
          TextSearch(
            searchingCallback: controller.searchingCallback,
            margin: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                controller.onLoad();
              },
              child: _list,
            ),
          ),
        ],
      );

  get _list => GetBuilder<CohortsController>(
        init: controller,
        builder: (controller) => ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: controller.cohorts.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(controller.cohorts[index]);
          },
        ),
      );

  Widget _item(TargetResp cohort) {
    auth.isRelationAdmin([cohort.id]);

    var avatarName = StringUtil.getPrefixChars(cohort.name, count: 2);
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 20.h),
        child: Row(
          children: [
            TextAvatar(avatarName: avatarName),
            Padding(padding: EdgeInsets.only(left: 10.w)),
            Text(cohort.name, style: AFont.instance.size22Black3),
            Expanded(child: Container()),
            Column(children: [])
          ],
        ),
      ),
    );
  }
}
