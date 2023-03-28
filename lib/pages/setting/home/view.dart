import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/choose_item.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/routers.dart';

import 'logic.dart';

import 'state.dart';

class SettingCenterPage
    extends BaseGetPageView<SettingCenterController, SettingCenterState> {
  @override
  Widget buildView() {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [tabBar(), searchBar(), list()],
        ));
  }

  Widget searchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: "关系",
        suffixIcon: IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: () {},
        ),
      ),
    );
  }

  Widget _header(IconData icon) {
    return AdvancedAvatar(
      size: 60.w,
      decoration: BoxDecoration(
        color: XColors.themeColor,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  Widget list() {
    return Column(
      children: [
        ChooseItem(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          header: _header(Icons.location_city),
          body: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text("杭州共裕数字技术科技有限公司", style: XFonts.size22Black3W700),
          ),
          func: () {
            Get.toNamed(Routers.companyInfo);
          },
        ),
        ChooseItem(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          header: _header(Icons.account_balance_outlined),
          body: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text("内设机构", style: XFonts.size22Black3W700),
          ),
          func: () {
            Get.toNamed(Routers.mineUnit);
          },
        ),
        ChooseItem(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          header: _header(Icons.account_tree_outlined),
          body: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text("外部机构", style: XFonts.size22Black3W700),
          ),
          func: () {
            Get.toNamed(Routers.mineUnit);
          },
        ),
        ChooseItem(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          header: _header(Icons.location_history_rounded),
          body: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text("岗位设置", style: XFonts.size22Black3W700),
          ),
          func: () {
            Get.toNamed(Routers.mineUnit);
          },
        ),
        ChooseItem(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          header: _header(Icons.chat_rounded),
          body: Container(
            margin: EdgeInsets.only(left: 15.w),
            child: Text("单位群组", style: XFonts.size22Black3W700),
          ),
          func: () {
            Get.toNamed(Routers.mineUnit);
          },
        )
      ],
    );
  }

  Widget tabBar() {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: TabBar(
        controller: state.tabController,
        tabs: tabTitle.map((e) {
          return Tab(
            text: e,
            height: 60.h,
          );
        }).toList(),
        indicatorColor: XColors.themeColor,
        unselectedLabelColor: Colors.grey,
        unselectedLabelStyle: TextStyle(fontSize: 21.sp),
        labelColor: XColors.themeColor,
        labelStyle: TextStyle(fontSize: 23.sp),
      ),
    );
  }

  @override
  SettingCenterController getController() {
    return SettingCenterController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return this.toString();
  }
}
