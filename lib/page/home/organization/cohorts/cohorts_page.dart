import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/component/text_tag.dart';
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

enum CtrlType {
  manageable("管理的"),
  joined("加入的");

  final String typeName;

  const CtrlType(this.typeName);
}

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
            Map<String, dynamic> args = {"func": CohortFunction.create};
            Get.toNamed(Routers.cohortMaintain, arguments: args);
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
            return _item(context, controller.cohorts[index]);
          },
        ),
      );

  Widget _item(BuildContext context, TargetResp cohort) {
    var targetIds = [cohort.id, cohort.belongId ?? ""];
    bool isRelationAdmin = auth.isRelationAdmin(targetIds);
    List<Widget> children = [];
    if (isRelationAdmin) {
      children.add(_popMenu(context, cohort, CtrlType.manageable));
    } else {
      children.add(_popMenu(context, cohort, CtrlType.joined));
    }

    var avatarName = StringUtil.getPrefixChars(cohort.name, count: 2);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        var messageController = controller.messageController;
        var spaceMessageItemMap = messageController.spaceMessageItemMap;
        var hasSpace = spaceMessageItemMap.containsKey(cohort.belongId);
        var spaceId = hasSpace ? cohort.belongId : auth.userId;
        if (spaceId == null) {
          Fluttertoast.showToast(msg: "未获取到空间 ID!");
          return;
        }
        Map<String, dynamic> args = {
          "spaceId": spaceId,
          "messageItemId": cohort.id
        };
        Get.toNamed(Routers.chat, arguments: args);
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
        child: Row(
          children: [
            TextAvatar(avatarName: avatarName),
            Padding(padding: EdgeInsets.only(left: 10.w)),
            Expanded(
              child: Text(cohort.name, style: AFont.instance.size22Black3),
            ),
            Column(children: children)
          ],
        ),
      ),
    );
  }

  Widget _popMenu(BuildContext context, TargetResp cohort, CtrlType ctrlType) {
    double x = 0, y = 0;
    return TextTag(
      ctrlType.typeName,
      textStyle: AFont.instance.size18themeColorW500,
      padding: EdgeInsets.all(10.w),
      onTap: () async {
        var items = CohortFunction.values;
        if (ctrlType == CtrlType.manageable) {
          items = items.where((item) {
            return item != CohortFunction.create && item != CohortFunction.exit;
          }).toList();
        } else {
          items = [CohortFunction.exit];
        }

        // 弹出菜单
        var top = y - 50;
        var right = MediaQuery.of(context).size.width - x;
        final result = await showMenu<CohortFunction>(
          context: context,
          position: RelativeRect.fromLTRB(x, top, right, 0),
          items: items.map((item) {
            return PopupMenuItem(
              value: item,
              child: Text(item.funcName),
            );
          }).toList(),
        );
        if (result != null) {
          controller.cohortFunc(result, cohort);
        }
      },
      onPanDown: (details) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      },
    );
  }
}
