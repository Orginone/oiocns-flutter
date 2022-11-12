import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/choose_item.dart';
import 'package:orginone/component/icon_avatar.dart';
import 'package:orginone/component/score.dart';
import 'package:orginone/component/tab_combine.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/text_tag.dart';
import 'package:orginone/component/unified_colors.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

class ApplicationManagerPage extends GetView<ApplicationManagerController> {
  const ApplicationManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarTitle: Text("资产管理", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: WidgetUtil.defaultBackBtn,
      bgColor: UnifiedColors.navigatorBgColor,
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      color: UnifiedColors.navigatorBgColor,
      child: Column(
        children: [
          TextSearch(
            margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
            searchingCallback: controller.searchingCallback,
            bgColor: Colors.white,
          ),
          Padding(padding: EdgeInsets.only(top: 20.h)),
          Row(
            children: [
              Padding(padding: EdgeInsets.only(left: 20.w)),
              Text("应用", style: AFont.instance.size20Black3W700),
              Expanded(child: Container()),
              Wrap(children: [
                Text("购买", style: AFont.instance.size16themeColorW500),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("创建", style: AFont.instance.size16themeColorW500),
                Padding(padding: EdgeInsets.only(left: 10.w)),
                Text("暂存", style: AFont.instance.size16themeColorW500),
              ]),
              Padding(padding: EdgeInsets.only(left: 20.w)),
            ],
          ),
          SizedBox(
            height: 60.h,
            child: TabBar(
              controller: controller.tabController,
              padding: EdgeInsets.only(left: 20.w, right: 20.w),
              labelPadding: EdgeInsets.zero,
              tabs: controller.tabs.map((item) => item.body!).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: controller.tabController,
              children: controller.tabs.map((item) => item.tabView).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationManagerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // 应用内 Tab
  late TabController tabController;
  late TabCombine all, created, buy, share, assigned;
  late List<TabCombine> tabs;

  @override
  onInit() {
    super.onInit();
    _initTabs();
  }

  _initTabs() {
    all = TabCombine(
      tabView: _list(),
      body: Text("全部", style: AFont.instance.size20Black3),
    );
    created = TabCombine(
      tabView: _list(),
      body: Text("创建的", style: AFont.instance.size20Black3),
    );
    buy = TabCombine(
      tabView: _list(),
      body: Text("购买的", style: AFont.instance.size20Black3),
    );
    share = TabCombine(
      tabView: _list(),
      body: Text("共享的", style: AFont.instance.size20Black3),
    );
    assigned = TabCombine(
      tabView: _list(),
      body: Text("分配的", style: AFont.instance.size20Black3),
    );
    tabs = [all, created, buy, share, assigned];
    tabController = TabController(length: tabs.length, vsync: this);
    int preIndex = tabController.index;
    tabController.addListener(() {
      if (preIndex == tabController.index) {
        return;
      }
      preIndex = tabController.index;
    });
  }

  Widget _list() {
    List<Widget> items = [
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
      _applicationItem(),
    ];
    return ListView(children: items);
  }

  Widget _applicationItem() {
    return ChooseItem(
      bgColor: Colors.white,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(top: 20.h, left: 20.w, right: 20.w),
      header: IconAvatar(
        width: 64.w,
        radius: 20.w,
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.group, color: Colors.white),
      ),
      body: Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 10.w)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("资产监管", style: AFont.instance.size14Black3W500),
                Padding(padding: EdgeInsets.only(top: 5.h)),
                Text(
                  "此处显示应用描述描应用描描此处显示应用描述描应用描描此处显示应",
                  overflow: TextOverflow.ellipsis,
                  style: AFont.instance.size12Black9,
                ),
                Padding(padding: EdgeInsets.only(top: 2.h)),
                Score(total: 5, actual: 4, size: 20.w),
              ],
            ),
          )
        ],
      ),
      operate: TextTag(
        "更多",
        borderColor: UnifiedColors.themeColor,
        bgColor: Colors.white,
        padding: EdgeInsets.all(5.w),
        textStyle: AFont.instance.size12themeColor,
      ),
      func: () {},
    );
  }

  searchingCallback() {}
}

class ApplicationManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ApplicationManagerController());
  }
}
