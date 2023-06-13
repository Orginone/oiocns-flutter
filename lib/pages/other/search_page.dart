import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/tabs/gf_tabbar.dart';
import 'package:getwidget/components/tabs/gf_tabbar_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/text_avatar.dart';
import 'package:orginone/widget/widgets/text_search.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/person.dart';

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
    return OrginoneScaffold(
      appBarLeading: XWidgets.defaultBackBtn,
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
        child: XIcons.loading32,
      ),
    );
  }

  Widget _tabBar(BuildContext context) {
    List<Widget> tabs = controller.searchItems
        .map((item) => Text(item.label, style: XFonts.size12Black0))
        .toList();

    return GFTabBar(
      width: 1000,
      tabBarHeight: 40,
      indicatorColor: Colors.blueAccent,
      tabBarColor: XColors.easyGrey,
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
        List<XTarget> searchResults = [];
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

  Widget _targetItem(XTarget target) {
    List<Widget> children = [
      TextAvatar(
        avatarName: target.name.substring(0, 2),
        textStyle: XFonts.size20WhiteW700,
      ),
      Padding(padding: EdgeInsets.only(left: 10.w)),
      Text(target.name, style: XFonts.size22Black3W700),
      Expanded(child: Container()),
    ];
    if (controller.functionPoint != null) {
      switch (controller.functionPoint!) {
        case FunctionPoint.addFriends:
        case FunctionPoint.applyCohorts:
        case FunctionPoint.applyCompanies:
          children.add(ElevatedButton(
            onPressed: () async {
              switch (controller.functionPoint!) {
                case FunctionPoint.addFriends:
                  // await PersonApi.join(target.id);
                  break;
                case FunctionPoint.applyCohorts:
                case FunctionPoint.applyCompanies:
                  await settingCtrl.user
                      .applyJoin([target]);
                  break;
              }
              Fluttertoast.showToast(msg: "申请成功");
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.green),
              minimumSize: MaterialStateProperty.all(Size(10.w, 30.w)),
            ),
            child: Text("申请", style: XFonts.size18White),
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

enum SearchItem {
  comprehensive("综合", []),
  friends("好友", [FunctionPoint.addFriends]),
  cohorts("群组", [FunctionPoint.applyCohorts]),
  messages("消息", []),
  documents("文档", []),
  logs("日志", []),
  labels("文本", []),
  functions("功能", []),
  departments("部门", []),
  publicCohorts("公开群组", []),
  applications("应用", []),
  markets("市场", []),
  units("单位", [FunctionPoint.applyCompanies]);

  const SearchItem(this.label, this.functionPoint);

  final String label;
  final List<FunctionPoint> functionPoint;
}

enum FunctionPoint {
  addFriends("添加好友", "通过账号/手机号搜索"),
  applyCohorts("申请入群", "通过群组编号搜索"),
  applyCompanies("申请入单位", "通过单位编号搜索");

  const FunctionPoint(this.functionName, this.placeHolder);

  final String functionName;
  final String placeHolder;
}

class SearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}

enum SearchStatus { stop, searching }

class SearchController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;
  late List<SearchItem> searchItems;
  FunctionPoint? functionPoint;
  ScrollController scrollController = ScrollController();

  // 搜索的一些结果
  SearchParams<XTarget>? personRes;
  SearchParams<XTarget>? cohortRes;
  SearchParams<XTarget>? companyRes;

  // 搜索状态
  Rx<SearchStatus> searchStatus = SearchStatus.stop.obs;

  // 动画
  late AnimationController animationController;

  @override
  void onInit() {
    Map<String, dynamic> args = Get.arguments ?? {};
    searchItems = args["items"] ?? SearchItem.values;
    functionPoint = args["point"];

    tabController = TabController(length: searchItems.length, vsync: this);
    const duration = Duration(seconds: 1);
    animationController = AnimationController(vsync: this, duration: duration);
    animationController.repeat();
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    tabController.dispose();
    animationController.dispose();
  }

  Future<void> searchingCallback(String filter) async {
    searchStatus.value = SearchStatus.searching;
    update();
    try {
      switch (searchItems[tabController.index]) {
        case SearchItem.friends:
          var settingCtrl = Get.find<SettingController>();
          var person = settingCtrl.user;
          await person.searchTargets(filter,[]).then((value){
            print('value:$value');
          }).onError((error, stackTrace) {
            print('error:$error');
          });
          // personRes = SearchParams();
          // var pageResp = await PersonApi.searchPersons(
          //   keyword: filter,
          //   limit: personRes!.limit,
          //   offset: personRes!.offset,
          // );
          // log.info(pageResp.result);
          // var result = pageResp.result;
          // personRes!.offset = result.length;
          // personRes!.searchResults = result;
          // update();
          break;
        case SearchItem.applications:
          break;
        case SearchItem.comprehensive:
          break;
        case SearchItem.cohorts:
        // cohortRes = SearchParams();
        // var pageResp = await CohortApi.search(
        //   keyword: filter,
        //   limit: cohortRes!.limit,
        //   offset: cohortRes!.offset,
        // );
        // log.info(pageResp.result);
        // var result = pageResp.result;
        // cohortRes!.offset = result.length;
        // cohortRes!.searchResults = result;
        // update();
        // break;
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
          // companyRes = SearchParams();
          // var pageResp = await CompanyApi.searchCompanys(
          //   keyword: filter,
          //   limit: companyRes!.limit,
          //   offset: companyRes!.offset,
          // );
          // var result = pageResp.result;
          // companyRes!.offset = result.length;
          // companyRes!.searchResults = result;
          // update();
          break;
        case SearchItem.markets:
          break;
      }
    } finally {
      searchStatus.value = SearchStatus.stop;
    }
  }
}

class SearchParams<T> {
  List<T> searchResults = [];
  int limit = 20;
  int offset = 0;
}
