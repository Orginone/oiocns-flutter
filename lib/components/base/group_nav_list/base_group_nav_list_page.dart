import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/utils/log/log_util.dart';

import 'base_group_nav_list_controller.dart';
import 'base_group_nav_list_state.dart';

abstract class BaseGroupNavListPage<T extends BaseGroupNavListController,
    S extends BaseGroupNavListState> extends BaseGetPageView<T, S> {
  BaseGroupNavListPage({super.key});

  TextStyle get _selectedTextStyle =>
      TextStyle(fontSize: 24.sp, color: XColors.themeColor);

  TextStyle get _unSelectedTextStyle =>
      TextStyle(fontSize: 24.sp, color: Colors.black);

  @override
  Widget buildView() {
    return GyScaffold(
      titleSpacing: 0,
      leadingWidth: 80,
      leading: <Widget>[
        BackButton(
          color: Colors.black,
          onPressed: () {
            controller.back();
          },
        ).width(34),
        ButtonWidget.text(
          '关闭',
          textSize: 17,
          width: 40,
          textColor: Colors.black,
          onTap: () {
            controller.popAll();
          },
        ),
      ].toRow(),
      centerTitle: false,
      appBarColor: Colors.white,
      titleWidget: Obx(() {
        if (state.showSearch.value) {
          return CommonWidget.commonSearchBarWidget(
              hint: "请输入",
              onChanged: (str) {
                controller.search(str);
              });
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: state.navBarController,
          child: Obx(() {
            List<Widget> nextStep = [];
            if (state.bcNav.isNotEmpty) {
              for (var value in state.bcNav) {
                nextStep.add(_level(value));
              }
            }
            return Row(
              children: nextStep,
            );
          }),
        );
      }),
      actions: [
        state.showSearchButton
            ? Obx(() {
                return IconButton(
                  onPressed: () {
                    controller.changeSearchState();
                  },
                  icon: Icon(
                    state.showSearch.value ? Icons.close : Icons.search,
                    color: Colors.black,
                  ),
                );
              })
            : const SizedBox(),
        popupMenuItems().isEmpty
            ? const SizedBox()
            : CommonWidget.commonPopupMenuButton<PopupMenuKey>(
                items: popupMenuItems(),
                iconColor: Colors.black,
                onSelected: (key) {
                  controller.onTopPopupMenuSelected(key);
                }),
      ],
      body: _buildMainView(),
    );
  }

  Column _buildMainView() {
    return Column(
      children: [
        headWidget(),
        Obx(
          () => Offstage(
            offstage: relationCtrl.isConnected.value,
            child: Container(
              alignment: Alignment.center,
              color: XColors.bgErrorColor,
              padding: EdgeInsets.all(8.w),
              child: const Row(
                children: [
                  Icon(Icons.error, size: 18, color: XColors.fontErrorColor),
                  SizedBox(width: 18),
                  Text("当前无法连接网络，可检查网络设置是否正常。",
                      style: TextStyle(color: XColors.black666))
                ],
              ),
            ),
          ),
        ),
        Expanded(child: main()),
      ],
    );
  }

  Widget headWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
      )),
      child: Container(
        color: Colors.white,
        child: Row(
          children: [
            Expanded(
              child: Obx(() {
                return buildExtendedTabBar();
              }),
            ),
            IconButton(
              onPressed: () {
                controller.showGrouping();
              },
              alignment: Alignment.center,
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
              iconSize: 24.w,
              padding: EdgeInsets.zero,
            )
          ],
        ),
      ),
    );
  }

//创建ExtendedTabBar
  buildExtendedTabBar() {
    LogUtil.e('buildExtendedTabBar');
    LogUtil.d(
        '>>>==========${state.subGroup.value} ${state.subGroup.value.groups?.length} ${state.subGroup.value.groups?.first.label}');

    return ExtendedTabBar(
      controller: state.tabController,
      tabs: state.subGroup.value.groups!.map((e) {
            var index = state.subGroup.value.groups!.indexOf(e);
            return ExtendedTab(
              scrollDirection: Axis.horizontal,
              height: 40.h,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: state.groupIndex.value == index
                      ? XColors.themeColor
                      : Colors.grey[200],
                ),
                child: Text(
                  e.label!,
                  style: TextStyle(
                      color: state.groupIndex.value != index
                          ? XColors.themeColor
                          : Colors.white,
                      fontSize: 18.sp),
                ),
              ),
            );
          }).toList() ??
          [],
      indicatorColor: XColors.themeColor,
      unselectedLabelColor: Colors.grey,
      labelColor: XColors.themeColor,
      isScrollable: true,
      labelPadding: EdgeInsets.symmetric(horizontal: 5.w),
      indicator: const UnderlineTabIndicator(),
    );
  }

  Widget main() {
    return Obx(() {
      var groups = state.subGroup.value.groups ?? [];

      return ExtendedTabBarView(
        controller: state.tabController,
        children: groups.map((e) {
          return buildPageView(e.value!, e.label!);
        }).toList(),
      );
    });
  }

  Widget buildPageView(String type, String label);
  Widget _level(BaseBreadcrumbNavInfo info) {
    int index = state.bcNav.indexOf(info);
    List<InlineSpan> children = [
      TextSpan(
          text: info.title,
          style: index == state.bcNav.length - 1
              ? _selectedTextStyle
              : _unSelectedTextStyle),
    ];
    if ((index + 1) != state.bcNav.length) {
      children.add(TextSpan(text: " • ", style: _unSelectedTextStyle));
    }
    return GestureDetector(
      onTap: () {
        controller.pop(index);
      },
      child: Text.rich(
        TextSpan(
          children: children,
        ),
      ),
    );
  }

  @override
  String tag() {
    return hashCode.toString();
  }

  List<PopupMenuItem<PopupMenuKey>> popupMenuItems() {
    return [];
  }
}
