import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'base_submenu_state.dart';

class BaseSubmenuController<S extends BaseSubmenuState>
    extends BaseListController<S> {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initSubmenu();
  }

  void initSubmenu() {
    // TODO: implement initSubmenu
  }

  Future<int?> showGrouping() {
    return showModalBottomSheet<int?>(
        context: context,
        backgroundColor: Colors.grey,
        constraints: BoxConstraints(maxHeight: 800.h,minHeight: 800.h),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w))),
        builder: (context) {
          return GyScaffold(
            backgroundColor: Colors.grey.shade200,
            titleName: "分组",
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w,vertical: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.w)),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = state.submenu[index];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade200, width: 0.5))),
                    child: ListTile(
                      onTap: () {
                        Navigator.pop(context, index);
                      },
                      title: Text(item.text),
                    ),
                  );
                },
                itemCount: state.submenu.length,
              ),
            ),
          );
        }).then((value) {
        if(value!=null){
          changeSubmenuIndex(value);
        }
    });
  }

  void changeSubmenuIndex(int index) {
     if( state.submenuIndex.value != index){
       state.submenuIndex.value = index;
       state.pageController.jumpToPage(index);
     }
  }
}