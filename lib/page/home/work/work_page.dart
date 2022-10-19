import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:orginone/component/unified_text_style.dart';

import '../../../component/unified_colors.dart';
import 'work_controller.dart';

class WorkPage extends GetView<WorkController> {
  const WorkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: UnifiedColors.easyGrey,
      child: Column(
        children: [_approval()],
      ),
    );
  }

  _box({
    required Widget text,
    required Widget body,
  }) {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(10.w),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          text,
          body,
        ],
      ),
    );
  }

  Widget _approval() {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "${controller.applyCount.value} 审核",
                style: text16Bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "${controller.approvalCount.value} 申请",
                style: text16Bold,
              ),
            ),
          )
        ],
      ),
    );
  }
}
