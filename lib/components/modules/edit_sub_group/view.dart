import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class EditSubGroupPage
    extends BaseGetView<EditSubGroupController, EditSubGroupState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "管理分组",
      leading: BackButton(
        onPressed: () {
          controller.back();
        },
        color: Colors.black,
      ),
      actions: [
        TextButton(
          onPressed: () {
            controller.save();
          },
          child: Text(
            "保存",
            style: TextStyle(fontSize: 21.sp),
          ),
        ),
      ],
      body: ListView(
        children: [
          CommonWidget.commonHeadInfoWidget("首页展示"),
          Obx(() {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.w)),
              child: ReorderableListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = state.subGroup.value.groups![index];
                  return Container(
                    key: ValueKey(item.value!),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade200, width: 0.5))),
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {
                          controller.removeGroup(item);
                        },
                        icon: Icon(
                          Ionicons.remove_circle,
                          color: (item.allowEdit ?? true)
                              ? Colors.red
                              : Colors.grey,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(maxWidth: 30.w),
                      ),
                      trailing: const Icon(
                        Ionicons.menu,
                      ),
                      title: Text(item.label!),
                      minLeadingWidth: 0,
                    ),
                  );
                },
                itemCount: state.subGroup.value.groups!.length,
                onReorder: (int oldIndex, int newIndex) {
                  controller.changeGroupIndex(oldIndex, newIndex);
                },
              ),
            );
          }),
          CommonWidget.commonHeadInfoWidget("可添加的"),
          Obx(() {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.w)),
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var item = state.subGroup.value.hidden![index];
                  return Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Colors.grey.shade200, width: 0.5))),
                    child: ListTile(
                      leading: IconButton(
                        onPressed: () {
                          controller.addGroup(item);
                        },
                        icon: const Icon(
                          Ionicons.add_circle,
                          color: Colors.blue,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(maxWidth: 30.w),
                      ),
                      title: Text(item.label!),
                      minLeadingWidth: 0,
                    ),
                  );
                },
                itemCount: state.subGroup.value.hidden!.length,
              ),
            );
          }),
        ],
      ),
    );
  }
}
