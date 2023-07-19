import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'base_submenu_state.dart';

class BaseSubmenuController<S extends BaseSubmenuState>
    extends BaseController<S> {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initSubGroup();
  }

  void initSubGroup() {
    // TODO: implement initSubmenu
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
                  Get.toNamed(Routers.editSubGroup,
                      arguments: {
                        "subGroup": SubGroup.fromJson(
                            state.subGroup.value.toJson())
                      })?.then((value) {
                        if(value!=null){
                          state.subGroup.value = value;
                          state.subGroup.refresh();
                        }
                  });
                },
                child: Text(
                  "分组",
                  style: TextStyle(fontSize: 21.sp, color: Colors.black),
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
    });
  }

  void changeSubmenuIndex(int index) {
    if (state.submenuIndex.value != index) {
      state.submenuIndex.value = index;
      state.pageController.jumpToPage(index);
    }
  }
}