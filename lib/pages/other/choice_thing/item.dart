import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:orginone/dart/core/target/targetMap.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/widget/common_widget.dart';

class Item extends StatelessWidget {
  final ThingModel item;
  final ValueChanged? changed;
  final bool showSelectButton;
  final bool showDelete;
  final VoidCallback? delete;

  const Item(
      {Key? key,
      required this.item,
      this.changed,
      this.showSelectButton = true,
      this.showDelete = false, this.delete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = item.status == "正常" ? Colors.green : Colors.red;

    Widget statusWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4.w),
        border: Border.all(color: textColor, width: 0.5),
      ),
      child: Text(
        item.status ?? "",
        style: TextStyle(color: textColor, fontSize: 14.sp),
      ),
    );

    return GestureDetector(
      onTap: () {
        if (changed != null) {
          changed!(!item.isSelected);
        }
      },
      child: Container(
          margin: EdgeInsets.only(top: 10.h, right: 16.w, left: 16.w),
          child: LayoutBuilder(
            builder: (context, constraints) {
              Widget child = Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4.w),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        showSelectButton
                            ? CommonWidget.commonMultipleChoiceButtonWidget(
                          isSelected: item.isSelected,
                          changed: changed,
                        )
                            : Container(),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          item.id ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 21.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "创建人:${findTargetShare(item.creater ?? "").name}",
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        statusWidget,
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "创建时间:${DateTime.tryParse(item.createTime ?? "")?.format(format: "yyyy-MM-dd HH:mm")}",
                          style: TextStyle(
                              color: Colors.black54, fontSize: 16.sp),
                        ),
                        Text(
                          "更新时间:${DateTime.tryParse(item.modifiedTime ?? "")?.format(format: "yyyy-MM-dd HH:mm")}",
                          style: TextStyle(
                              color: Colors.black54, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              );
              if (showDelete) {
                child = Slidable(
                  key: ValueKey(item.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        label: "删除",
                        onPressed: (BuildContext context) {
                          if(delete!=null){
                            delete!();
                          }
                        },
                      ),
                    ],
                  ),
                  child: child,
                );
              }
              return child;
            },
          )),
    );
  }
}
