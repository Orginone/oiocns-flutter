import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/text_avatar.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/enumeration/target_type.dart';
import 'package:orginone/page/home/search/search_controller.dart';
import 'package:orginone/util/asset_util.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/util/widget_util.dart';

class SearchPage extends GetView<SearchController> {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMultiple = controller.searchItems.length > 1;
    bool isSingle = controller.searchItems.length == 1;
    Column body = Column(
      children: [Padding(padding: EdgeInsets.only(top: 10.h))],
    );
    if (isMultiple) {
      body.children.addAll([_tabBar(context), _tabView()]);
    } else if (isSingle) {
      SearchItem searchItem = controller.searchItems[0];
      switch (searchItem) {
        case SearchItem.friends:
          body.children.add(_targetBody(TargetType.person));
          break;
        case SearchItem.applications:
          break;
        case SearchItem.comprehensive:
          break;
        case SearchItem.cohorts:
          body.children.add(_targetBody(TargetType.cohort));
          break;
        case SearchItem.messages:
          break;
        case SearchItem.documents:
          break;
        case SearchItem.logs:
          break;
        case SearchItem.labels:
          break;
        case SearchItem.functions:
          break;
        case SearchItem.departments:
          break;
        case SearchItem.publicCohorts:
          break;
        case SearchItem.units:
          body.children.add(_targetBody(TargetType.company));
          break;
        case SearchItem.markets:
          break;
      }
    }
    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: TextSearch(
        searchingCallback: controller.searchingCallback,
        margin: EdgeInsets.only(right: 10.w),
        placeHolder: controller.functionPoint?.placeHolder,
      ),
      appBarCenterTitle: true,
      body: Obx(() {
        var status = controller.searchStatus.value;
        if (status == SearchStatus.stop) {
          controller.animationController.stop();
          return body;
        } else {
          controller.animationController.repeat();
          return _loadingIcon();
        }
      }),
    );
  }

  Widget _loadingIcon() {
    return Container(
      alignment: Alignment.center,
      child: AnimatedBuilder(
        animation: controller.animationController,
        builder: (context, child) => Transform.rotate(
          angle: controller.animationController.value * 2 * pi,
          child: child,
        ),
        child: Icon(
          AssetUtil.loadingIcon,
          color: Colors.blueAccent,
          size: 40.w,
        ),
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    List<Widget> tabs = controller.searchItems
        .map((item) => Text(item.label, style: text12))
        .toList();

    return GFTabBar(
      width: 1000,
      tabBarHeight: 40,
      indicatorColor: Colors.blueAccent,
      tabBarColor: UnifiedColors.easyGrey,
      length: controller.tabController.length,
      controller: controller.tabController,
      tabs: tabs,
    );
  }

  Widget _tabView() {
    return GFTabBarView(
      height: 400,
      controller: controller.tabController,
      children: controller.searchItems
          .map((item) => Container(
                alignment: Alignment.center,
                child: Text(item.label),
              ))
          .toList(),
    );
  }

  Widget _targetBody(TargetType targetType) {
    return GetBuilder<SearchController>(
      builder: (item) {
        List<Target> searchResults = [];
        switch (targetType) {
          case TargetType.person:
            searchResults = controller.personRes?.searchResults ?? [];
            break;
          case TargetType.company:
          case TargetType.university:
          case TargetType.hospital:
            searchResults = controller.companyRes?.searchResults ?? [];
            break;
          case TargetType.cohort:
            searchResults = controller.cohortRes?.searchResults ?? [];
            break;
          default:
            break;
        }
        return Expanded(
          child: ListView.builder(
            controller: controller.scrollController,
            itemCount: searchResults.length,
            itemBuilder: (BuildContext context, int index) {
              return _targetItem(searchResults[index]);
            },
          ),
        );
      },
    );
  }

  Widget _targetItem(Target target) {
    List<Widget> children = [
      TextAvatar(
        avatarName: StringUtil.getPrefixChars(target.name, count: 2),
        textStyle: AFont.instance.size20WhiteW500,
      ),
      Padding(padding: EdgeInsets.only(left: 10.w)),
      Text(target.name, style: AFont.instance.size22Black3W500),
      Expanded(child: Container()),
    ];
    if (controller.functionPoint != null) {
      switch (controller.functionPoint!) {
        case FunctionPoint.addFriends:
        case FunctionPoint.applyCohorts:
        case FunctionPoint.applyCompanies:
          children.add(ElevatedButton(
            onPressed: () async {
              var targetCtrl = Get.find<TargetController>();
              switch (controller.functionPoint!) {
                case FunctionPoint.addFriends:
                  await PersonApi.join(target.id);
                  break;
                case FunctionPoint.applyCohorts:
                  await targetCtrl.currentPerson.applyJoinCohort(target.id);
                  break;
                case FunctionPoint.applyCompanies:
                  await targetCtrl.currentPerson.applyJoinCompany(target.id);
                  break;
              }
              Fluttertoast.showToast(msg: "申请成功");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              minimumSize: MaterialStateProperty.all(Size(10.w, 30.w)),
            ),
            child: Text("申请", style: AFont.instance.size18White),
          ));
          break;
      }
    }
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.only(left: 25.w, bottom: 10.h, right: 25.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
