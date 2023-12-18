import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/pages/home/home/logic.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'base_submenu_state.dart';

class BaseSubmenuController<S extends BaseSubmenuState>
    extends BaseController<S> with GetTickerProviderStateMixin {
  HomeController homeController = Get.find();

  @override
  void onInit() {
    // TODO: implement onInit
    initSubGroup();
    super.onInit();
    state.tabController.addListener(() {
      changeSubmenuIndex(state.tabController.index);
    });
  }

  void initSubGroup() {
    // TODO: implement initSubmenu
  }

  int getTabIndex(String code) {
    // TODO: implement initSubmenu
    return -1;
  }

  void setTabIndex(String code) {
    int tabIndex = getTabIndex(code);
    changeSubmenuIndex(tabIndex);
    state.tabController.index = tabIndex;
  }

  Future<int?> showGrouping() {
    return showModalBottomSheet<int?>(
        context: context,
        backgroundColor: Colors.grey,
        constraints: BoxConstraints(maxHeight: 800.h, minHeight: 800.h),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w))),
        builder: (context) {
          return GyScaffold(
            backgroundColor: Colors.grey.shade200,
            titleName: "${state.tag}分组",
            actions: [
              TextButton(
                onPressed: () {
                  Get.toNamed(Routers.editSubGroup, arguments: {
                    "subGroup": SubGroup.fromJson(state.subGroup.value.toJson())
                  })?.then((value) {
                    if (value != null) {
                      state.subGroup.value = value;
                      state.subGroup.refresh();
                      resetTab();
                    }
                  });
                },
                child: Text(
                  "分组",
                  style: TextStyle(fontSize: 24.sp, color: Colors.black),
                ),
              )
            ],
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.w)),
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = state.subGroup.value.groups![index];
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade200, width: 0.5))),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, index);
                        },
                        title: Text(item.label!),
                      ),
                    );
                  },
                  itemCount: state.subGroup.value.groups!.length,
                );
              }),
            ),
          );
        }).then((value) {
      if (value != null) {
        changeSubmenuIndex(value);
      }
      return null;
    });
  }

  void changeSubmenuIndex(int index) {
    if (state.submenuIndex.value != index) {
      state.submenuIndex.value = index;
      state.tabController.index = index;
    }
  }

  void resetTab() {
    state.tabController.dispose();
    state.tabController =
        TabController(length: state.subGroup.value.groups!.length, vsync: this);
    state.tabController.index = 0;
    state.submenuIndex.value = 0;
    state.tabController.addListener(() {
      changeSubmenuIndex(state.tabController.index);
    });
  }

  @override
  void onClose() {
    state.tabController.dispose();
    super.onClose();
  }
}
