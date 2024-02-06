import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/utils/hive_utils.dart';
import 'state.dart';

class RelationController extends BaseSubmenuController<RelationState> {
  @override
  final RelationState state = RelationState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // [
    //   FrequentlyUsed(
    //     id: "addPerson",
    //     name: "加好友",
    //     avatar: Ionicons.add,
    //   ),
    //   FrequentlyUsed(
    //     id: "createGroup",
    //     name: "建群组",
    //     avatar: Ionicons.create,
    //   ),
    //   FrequentlyUsed(
    //     id: "addGroup",
    //     name: "加群组",
    //     avatar: Ionicons.add,
    //   ),
    //   FrequentlyUsed(
    //     id: "createCompany",
    //     name: "建单位",
    //     avatar: Ionicons.create,
    //   ),
    //   FrequentlyUsed(
    //     id: "addCompany",
    //     name: "加单位",
    //     avatar: Ionicons.add,
    //   ),
    // ];
  }

  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    var relationSubGroup = HiveUtils.getSubGroup('Relation');
    if (relationSubGroup == null) {
      relationSubGroup = SubGroup.fromJson(relationDefaultConfig);
      HiveUtils.putSubGroup('Relation', relationSubGroup);
    }
    state.subGroup = Rx(relationSubGroup);
    var index = relationSubGroup.groups!
        .indexWhere((element) => element.value == "all");
    state.tabController = TabController(
        initialIndex: index,
        length: relationSubGroup.groups!.length,
        vsync: this,
        animationDuration: Duration.zero);
  }
}
