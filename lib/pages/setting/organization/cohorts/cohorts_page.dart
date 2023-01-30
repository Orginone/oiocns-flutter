import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/text_avatar.dart';
import 'package:orginone/components/text_search.dart';
import 'package:orginone/components/text_tag.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/config/field_config.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:orginone/dart/controller/target/target_controller.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/dart/core/target/cohort.dart';
import 'package:orginone/pages/other/search/search_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

enum CtrlType {
  manageable("管理的"),
  joined("加入的");

  final String typeName;

  const CtrlType(this.typeName);
}

enum CohortPageReturnType { createCohort, updateCohort }

class CohortsPage extends GetView<TargetController> {
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
            Get.toNamed(
              Routers.maintain,
              arguments: CreateCohort((value) {
                if (Get.isRegistered<TargetController>()) {
                  var targetCtrl = Get.find<TargetController>();
                  targetCtrl.createCohort(value).then((value) => Get.back());
                }
              }),
            );
          },
          icon: const Icon(Icons.create_outlined, color: Colors.black),
        ),
        IconButton(
          onPressed: () {
            List<SearchItem> friends = [SearchItem.cohorts];
            Get.toNamed(Routers.search, arguments: {
              "items": friends,
              "point": FunctionPoint.applyCohorts,
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
              onRefresh: () => controller.currentPerson.refreshJoinedCohorts(),
              child: _list,
            ),
          ),
        ],
      );

  get _list => Obx(() => ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: controller.currentPerson.joinedCohorts.length,
        itemBuilder: (BuildContext context, int index) {
          return _item(context, controller.currentPerson.joinedCohorts[index]);
        },
      ));

  Widget _item(BuildContext context, Cohort cohort) {
    var target = cohort.target;
    var targetIds = [target.id, target.belongId ?? ""];
    bool isRelationAdmin = auth.isRelationAdmin(targetIds);
    List<Widget> children = [];
    if (isRelationAdmin) {
      children.add(_popMenu(context, target, CtrlType.manageable));
    } else {
      children.add(_popMenu(context, target, CtrlType.joined));
    }

    var avatarName = StringUtil.getPrefixChars(target.name, count: 2);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        var messageCtrl = Get.find<MessageController>();
        bool success = await messageCtrl.setCurrentById(target.id);
        if (!success) {
          Fluttertoast.showToast(msg: "未获取到会话信息！");
          return;
        }
        Get.toNamed(Routers.chat);
      },
      child: Container(
        padding: EdgeInsets.only(left: 25.w, top: 20.h, right: 25.w),
        child: Row(
          children: [
            TextAvatar(avatarName: avatarName),
            Padding(padding: EdgeInsets.only(left: 10.w)),
            Expanded(
              child: Text(target.name, style: AFont.instance.size22Black3),
            ),
            Column(children: children)
          ],
        ),
      ),
    );
  }

  Widget _popMenu(BuildContext context, Target cohort, CtrlType ctrlType) {
    double x = 0, y = 0;
    return TextTag(
      ctrlType.typeName,
      textStyle: AFont.instance.size18themeColorW500,
      padding: EdgeInsets.all(10.w),
      onTap: () async {
        List<TargetEvent> items = [];
        if (ctrlType == CtrlType.manageable) {
          items = [TargetEvent.updateCohort, TargetEvent.deleteCohort];
        } else {
          items = [TargetEvent.exitCohort];
        }

        // 弹出菜单
        var top = y - 50;
        var right = MediaQuery.of(context).size.width - x;
        final result = await showMenu<TargetEvent>(
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
          if (result == TargetEvent.updateCohort) {
            var json = cohort.toJson();
            json["remark"] = cohort.team?.remark;
            Get.toNamed(
              Routers.maintain,
              arguments: CreateCohort((value) {
                if (Get.isRegistered<TargetController>()) {
                  var targetCtrl = Get.find<TargetController>();
                  targetCtrl.createCohort(value).then((value) => Get.back());
                }
              }),
            );
          } else if (result == TargetEvent.deleteCohort) {
            controller.deleteCohort(cohort);
          } else if (result == TargetEvent.exitCohort) {
            controller.exitCohort(cohort);
          }
        }
      },
      onPanDown: (details) {
        x = details.globalPosition.dx;
        y = details.globalPosition.dy;
      },
    );
  }
}
