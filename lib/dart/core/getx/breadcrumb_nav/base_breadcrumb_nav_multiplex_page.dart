import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/config/unified.dart';

import 'base_breadcrumb_nav_controller.dart';
import 'base_get_breadcrumb_nav_state.dart';

abstract class BaseBreadcrumbNavMultiplexPage<
    T extends BaseBreadcrumbNavController,
    S extends BaseBreadcrumbNavState> extends BaseGetPageView<T, S> {
  BaseBreadcrumbNavMultiplexPage({super.key});

  TextStyle get _selectedTextStyle =>
      TextStyle(fontSize: 24.sp, color: XColors.themeColor);

  TextStyle get _unSelectedTextStyle =>
      TextStyle(fontSize: 24.sp, color: Colors.black);

  @override
  Widget buildView() {
    return GyScaffold(
      titleSpacing: 0,
      leading: BackButton(
        color: Colors.black,
        onPressed: () {
          controller.popAll();
        },
      ),
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
      body: body(),
    );
  }

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

  Widget body();

  @override
  String tag() {
    // TODO: implement tag
    return hashCode.toString();
  }

  List<PopupMenuItem<PopupMenuKey>> popupMenuItems() {
    return [];
  }
}
