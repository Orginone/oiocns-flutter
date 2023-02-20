import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_list_page_view.dart';
import 'package:orginone/pages/other/assets_config.dart';

import 'item.dart';
import 'logic.dart';
import 'state.dart';

class ApprovalListPage
    extends BaseGetListPageView<ApprovalListController, ApprovalListState> {
  late int index;

  ApprovalListPage(this.index);

  @override
  Widget headWidget() {
    List<Widget> actions = [billType()];
    if (index == 1) {
      actions = [
        billType(),
        SizedBox(
          width: 4.w,
        ),
        approvalStatus()
      ];
    }
    return Container(
      color: XColors.themeColor,
      child: searchBar(leading: searchContent(), actions: actions),
    );
  }

  @override
  Widget buildView() {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Item();
      },
      itemCount: state.dataList.length,
    );
  }

  @override
  ApprovalListController getController() {
    return ApprovalListController();
  }

  Widget searchBar({Widget? leading, List<Widget>? actions}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Row(
        children: [
          leading ?? Container(),
          SizedBox(
            width: leading != null ? 4.w : 0,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.w)),
              child: Obx(() {
                return TextField(
                  textInputAction: TextInputAction.done,
                  onSubmitted: (str) {
                    controller.search(str);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText:
                    "请输入${SearchContent[state.searchContentIndex.value]}",
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                      size: 24.w,
                    ),
                  ),
                );
              }),
            ),
          ),
          SizedBox(
            width: actions != null ? 4.w : 0,
          ),
          ...actions ?? [Container()],
        ],
      ),
    );
  }

  Widget searchContent() {
    return GestureDetector(
      onTap: () {
        controller.changeSearchContent();
      },
      child: Container(
        width: 100.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: Colors.white,
        ),
        child: Obx(() {
          return Text.rich(TextSpan(
            children: [
              TextSpan(
                  text: SearchContent[state.searchContentIndex.value],
                  style: TextStyle(color: Colors.black, fontSize: 16.sp)),
              WidgetSpan(
                  child: Icon(
                    Icons.chevron_right,
                    size: 14.w,
                  ),
                  alignment: PlaceholderAlignment.middle)
            ],
          ));
        }),
      ),
    );
  }

  Widget billType() {
    return GestureDetector(
      onTap: () {
        controller.changeBillType();
      },
      child: Container(
        width: 100.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: Colors.white,
        ),
        child: Obx(() {
          return Text.rich(TextSpan(
            children: [
              TextSpan(
                  text: BillType[state.billTypeIndex.value],
                  style: TextStyle(color: Colors.black, fontSize: 16.sp)),
              WidgetSpan(
                  child: Icon(
                    Icons.chevron_right,
                    size: 14.w,
                  ),
                  alignment: PlaceholderAlignment.middle)
            ],
          ));
        }),
      ),
    );
  }

  Widget approvalStatus() {
    return GestureDetector(
      onTap: () {
        controller.changeApprovalStatus();
      },
      child: Container(
        width: 100.w,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.w),
          color: Colors.white,
        ),
        child: Obx(() {
          return Text.rich(TextSpan(
            children: [
              TextSpan(
                  text: ApprovalStatus[state.approvalStatusIndex.value],
                  style: TextStyle(color: Colors.black, fontSize: 16.sp)),
              WidgetSpan(
                  child: Icon(
                    Icons.chevron_right,
                    size: 14.w,
                  ),
                  alignment: PlaceholderAlignment.middle)
            ],
          ));
        }),
      ),
    );
  }

  @override
  String tag() {
    // TODO: implement tag
    return "$toString()$index";
  }
}
