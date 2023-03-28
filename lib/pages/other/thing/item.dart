import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:orginone/model/thing_model.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/date_utils.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/widget/common_widget.dart';

class Item extends StatelessWidget {
  final ThingModel item;

  const Item(
      {Key? key,
      required this.item,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                child:  Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.id ?? "",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 21.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "创建人:${DepartmentManagement().findXTargetByIdOrName(id: item.creater ?? "")?.name ?? ""}",
                            style: TextStyle(fontSize: 18.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "创建时间:${DateTime.tryParse(item.createTime ?? "")?.format(format: "yyyy-MM-dd HH:mm")}",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 16.sp),
                          ),
                        ],
                      ),
                    ),
                    popupMenuButton(),
                  ],
                ),
              );
              return child;
            },
          )),
    );
  }

  Widget popupMenuButton(){
    return PopupMenuButton(
      icon:Icon(
        Icons.more_vert_outlined,
        size: 32.w,
      ),
      itemBuilder: (BuildContext context){
        return [
          const PopupMenuItem(value: "details",child: Text("详情"),),
          const PopupMenuItem(value: "NTF",child: Text("生成NFT"),),
          const PopupMenuItem(value: "setCommon",child: Text("设为常用"),),
        ];
      },
      onSelected: (str){
        if(str == "details"){
          Get.toNamed(Routers.thingDetails,arguments: {"thing":item});
        }
      },
    );
  }
}
