/*
 * @Descripttion: 
 * @version: 
 * @Author: 
 * @Date: 
 */

import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/base/network_tip.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/log/log_util.dart';

import '../tab_bar/expand_tab_bar.dart';
import 'index.dart';

/// 移动端列表信息页面
class TabPage extends StatefulWidget {
  ///信息列表页签模型
  ITabModel iTabModel;

  TabPage(this.iTabModel, {super.key});

  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  ///活跃页签
  late TabItemsModel activeTab;

  @override
  void initState() {
    super.initState();
    if (widget.iTabModel.activeTabTitle != null) {
      TabItemsModel? activeTabTmp = widget.iTabModel.tabItems.firstWhereOrNull(
          (element) => element.title == widget.iTabModel.activeTabTitle);
      activeTab = activeTabTmp ?? widget.iTabModel.tabItems.first;
    } else {
      activeTab = widget.iTabModel.tabItems.first;
    }
  }

  bool hasSubTabPage() {
    return widget.iTabModel.tabItems
            .any((element) => element.tabItems.isNotEmpty) ||
        !equalsContent();
  }

  bool hasIcon() {
    return widget.iTabModel.tabItems.any((element) => null != element.icon);
  }

  bool equalsContent() {
    Widget? content;
    return widget.iTabModel.tabItems.every((element) {
      if (null == content) {
        content = element.content;
        return true;
      }
      LogUtil.d(
          '>>>>>>======${element.content.runtimeType} ${content.runtimeType} ${element.content.runtimeType == content.runtimeType}');
      return element.content.runtimeType == content.runtimeType;
    });
  }

  bool _hasSubTabPage(TabItemsModel item) {
    return item.tabItems.isNotEmpty;
  }

  changeTab(int index) {
    activeTab = widget.iTabModel.tabItems[index];
    widget.iTabModel.activeTabTitle = activeTab.title;
  }

  bool isActiveTab(TabItemsModel tab) {
    return activeTab == tab;
  }

  @override
  Widget build(BuildContext context) {
    final ancestorState = context.findAncestorStateOfType<InfoListPageState>();
    LogUtil.d('>>>>>>======$ancestorState');

    return _tabPage();
  }

  int getDefaultTabIndex() {
    int index = widget.iTabModel.tabItems.indexWhere(
        (element) => element.title == widget.iTabModel.activeTabTitle);
    if (index < 0) {
      index = 0;
    }
    return index;
  }

  ///页签
  Widget _tabPage() {
    return DefaultTabController(
      length: widget.iTabModel.tabItems.length,
      initialIndex: getDefaultTabIndex(),
      child: Scaffold(
        // backgroundColor: Colors.white,
        appBar: _tabBar(widget.iTabModel.tabItems),
        body: ExtendedTabBarView(
            children:
                widget.iTabModel.tabItems.map((tab) => _content(tab)).toList()),
      ),
    );
  }

  PreferredSizeWidget _tabBar(List<TabItemsModel> tabItems) {
    LogUtil.d('>>>>>>======${tabItems.first.title} ${tabItems.length}');
    return hasIcon() ? _tabItems(tabItems) : _subTabBar(tabItems);
  }

  PreferredSizeWidget _tabItems(List<TabItemsModel> tabItems) {
    bool hasIcon = tabItems.first.icon != null;
    return PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
                )),
            child: ExpandTabBar(
              // bgColor: Colors.white,
              isScrollable: false,
              labelColor: XColors.themeColor,
              unselectedLabelColor: XColors.black666,
              labelPadding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              labelStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              unselectedLabelStyle: TextStyle(fontSize: 18.sp),
              indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(width: 2.0, color: XColors.themeColor),
                  insets: EdgeInsets.symmetric(horizontal: 50)),
              tabNames: tabItems.map((TabItemsModel tab) {
                return tab.title;
              }).toList(),
              buildTabItem: (BuildContext context,
                  String tabName,
                  Color? color,
                  Color? bgColor,
                  Color? borderColor,
                  TextStyle? labelStyle,
                  int index,
                  bool selected) {
                return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasIcon)
                          XImage.localImage(tabItems[index].icon!,
                              color: color, width: 32.w),
                        Text(tabName),
                      ],
                    ) ??
                    Tab(
                      text: tabName,
                      iconMargin: const EdgeInsets.only(bottom: 0.0),
                      icon: hasIcon
                          ? XImage.localImage(tabItems[index].icon!,
                              color: color)
                          : null,
                    );
              },
              // tabs: tabItems.map((TabItemsModel tab) {
              //   return Tab(
              //       text: null == tab.icon ? tab.title : null,
              //       icon: null != tab.icon ? XImage.localImage(tab.icon!) : null);
              // }).toList(),
            )));
  }

  PreferredSizeWidget _subTabBar(List<TabItemsModel> tabItems) {
    return PreferredSize(
        preferredSize: Size.fromHeight(42.w),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
          )),
          child: Container(
            padding: EdgeInsets.only(bottom: 10.h, left: 5.w),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(child: _subTabItems(tabItems)),
                // IconButton(
                //   onPressed: () {
                //     // _showSubTabSettings(infoListPageController.getActiveSubTab());
                //   },
                //   alignment: Alignment.center,
                //   icon: const Icon(
                //     Icons.menu,
                //     color: Colors.black,
                //   ),
                //   iconSize: 24.w,
                //   padding: EdgeInsets.zero,
                // )
              ],
            ),
          ),
        ));
  }

  Widget _subTabItems(List<TabItemsModel> tabItems) {
    return Theme(
        data: ThemeData(
          highlightColor: Colors.red,
          splashColor: Colors.red,
        ),
        child: ExpandTabBar(
          onTap: changeTab,
          isScrollable: true,
          // automaticIndicatorColorAdjustment: true,
          indicatorWeight: 0,
          // padding: const EdgeInsets.all(5),
          // indicatorPadding: const EdgeInsets.all(5),
          labelPadding: const EdgeInsets.only(left: 10, right: 10),
          // indicatorColor: Colors.red,
          labelColor: XColors.themeColor,
          unselectedLabelColor: XColors.black,
          bgColor: Colors.grey[200],
          unselectedBgColor: Colors.white,
          borderColor: Colors.grey[200],
          unselectedBorderColor: Colors.grey[200],
          // dividerColor: Colors.red,
          // splashBorderRadius: BorderRadius.circular(10.w),
          // splashFactory: NoSplash.splashFactory,
          // overlayColor: MaterialStateProperty.resolveWith<Color?>(
          //   (Set<MaterialState> states) {
          //     LogUtil.d('>>>>>>======>$states');
          //     return states.contains(MaterialState.pressed)
          //         ? Colors.red
          //         : Colors.blue;
          //   },
          // ),
          labelStyle: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: 20.sp),
          indicator: const UnderlineTabIndicator(),
          // indicator: UnderlineTabIndicator(
          //   borderRadius: BorderRadius.circular(10.w),
          //   borderSide: const BorderSide(width: 2.0, color: Colors.black),
          //   insets: const EdgeInsets.all(5),
          // ),
          tabs: tabItems.map((TabItemsModel tab) {
            return Tab(text: tab.title);
          }).toList(),
        ));
  }

  ///页签内容
  Widget _content(TabItemsModel item) {
    return _hasSubTabPage(item) ? _subTabContent(item) : _tabContent(item);
  }

  Widget _subTabContent(TabItemsModel item) {
    return TabPage(item);
  }

  Widget _tabContent(TabItemsModel item) {
    return __tabContent(item) ?? _tabDefContent(item);
  }

  Widget? __tabContent(TabItemsModel item) {
    return null != item.content
        ? Container(
            child: Column(
              children: [const NetworkTip(), Expanded(child: item.content!)],
            ),
          )
        : null;
  }

  Widget _tabDefContent(TabItemsModel item) {
    return Center(child: Text(item.title));
  }
}
