import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/api_resp/friends_entity.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/components/dialog_confirm.dart';
import 'package:orginone/components/base_list_view.dart';

import '../../../../../components/a_font.dart';
import '../../../../../components/unified_colors.dart';
import '../../../../../util/date_util.dart';
import 'new_friends_controller.dart';

class NewFriendsPage extends BaseListView<NewFriendsController> {
  const NewFriendsPage({Key? key}) : super(key: key);

  @override
  String getTitle() {
    return "新朋友";
  }

  @override
  ListView listWidget() {
    return ListView.builder(
        itemCount: controller.dataList.length,
        itemBuilder: (context, index) {
          return itemInit(context, index, controller.dataList[index]);
        });
  }

  Widget itemInit(BuildContext context, int index, FriendsEntity item) {
    return Slidable(
      enabled: false,
      key: const ValueKey(0),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            // An action can be bigger than the others.
            flex: 2,
            onPressed: (context) {},
            backgroundColor: const Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.archive,
            label: 'Archive',
          ),
          SlidableAction(
            onPressed: (context) {},
            backgroundColor: const Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.save,
            label: 'Save',
          ),
        ],
      ),

      // The child of the Slidable is what the user sees when the
      // components is not dragged.
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
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
                    child: Text(item.target?.name ?? "",
                        style: AFont.instance.size22Black3W500),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                        "${controller.getName(item.createUser)}申请加入${(item.team?.name) ?? ""}",
                        style: AFont.instance.size18Black9),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
                        decoration: BoxDecoration(
                            color: UnifiedColors.white,
                            border: Border.all(
                                color: UnifiedColors.cardBorder, width: 0.1.w),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(0))),
                        child: Text(
                          item.createTime.toString(),
                          style: AFont.instance.size14Black9,
                        ),
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 106.w,
                            height: 42.h,
                            child: GFButton(
                              onPressed: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  animationType: DialogTransitionType.fadeScale,
                                  builder: (BuildContext context) {
                                    return DialogConfirm(
                                      title: "提示",
                                      content: "确定拒绝吗？",
                                      confirmFun: () {
                                        controller.joinRefuse(item.id);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              color: UnifiedColors.backColor,
                              text: "拒绝",
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 106.w,
                            height: 42.h,
                            child: GFButton(
                              onPressed: () {
                                showAnimatedDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  animationType: DialogTransitionType.fadeScale,
                                  builder: (BuildContext context) {
                                    return DialogConfirm(
                                      title: "提示",
                                      content: "确定通过吗？",
                                      confirmFun: () {
                                        controller.joinSuccess(item);
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                );
                              },
                              color: UnifiedColors.themeColor,
                              text: "通过",
                              textStyle: AFont.instance.size18White,
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
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              color: UnifiedColors.yellow,
              padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 4.h),
              margin: EdgeInsets.only(top: 14.h,right: 14.h),
              child: Text(controller.getStatus(item.status),softWrap: false,style:AFont.instance.size18White),
            ),
          ),
        ],
      ),
    );
  }
}
