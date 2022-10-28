import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import '../../../../component/unified_colors.dart';
import '../../../../component/unified_text_style.dart';
import '../base/affairs_base_list.dart';
import 'instance_controller.dart';

class AffairsInstanceWidget extends AffairsBaseList<InstanceController> {
  @override
  final controller = Get.put(InstanceController());

  AffairsInstanceWidget({Key? key}) : super(key: key);

  @override
  Widget listWidget() {
    return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          return itemInit(context, index, controller.dataList[index]);
        });
  }

  Widget itemInit(BuildContext context, int index, dataList) {
    return Slidable(
      enabled: false,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: _doNothing,
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: _doNothing,
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 10.h),
        margin: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 0),
        decoration: BoxDecoration(
            color: UnifiedColors.white,
            border: Border.all(color: UnifiedColors.cardBorder, width: 0.1.w),
            borderRadius: const BorderRadius.all(Radius.circular(0)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x297F7F7F),
                offset: Offset(8, 8),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ]),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text("“张三”想成为你的好友",
                  style: TextStyle(
                      color: UnifiedColors.black3,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500)),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text("你好，我是谢谢谢谢谢谢谢谢谢谢公司的张三，想成为你的好友", style: text12Grey),
            ),
            SizedBox(
              height: 30.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(10.w, 3.h, 10.w, 3.h),
                  decoration: BoxDecoration(
                      color: UnifiedColors.white,
                      border: Border.all(
                          color: UnifiedColors.cardBorder, width: 0.1.w),
                      borderRadius: const BorderRadius.all(Radius.circular(0))),
                  child: Text(
                    "时间：2022-02-23",
                    style: text14Grey,
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 70.w,
                      height: 30.h,
                      child: GFButton(
                        onPressed: () {},
                        color: UnifiedColors.backColor,
                        text: "退回",
                        textColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    SizedBox(
                      width: 70.w,
                      height: 30.h,
                      child: GFButton(
                        onPressed: () {},
                        color: UnifiedColors.agreeColor,
                        text: "通过",
                        textStyle: text14White,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _doNothing(BuildContext context) {}
}
