import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart' as model;
import 'package:orginone/utils/date_utils.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/target_text.dart';

class Item extends StatelessWidget {
  final model.AnyThingModel item;
  final PopupMenuItemSelected? onSelected;

  const Item({
    Key? key,
    required this.item,
    this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: _body(),
    );
  }

  Container _body() {
    var thing =
        item.id == null ? model.AnyThingModel.fromJson(item.otherInfo) : item;
    return Container(
        margin: EdgeInsets.only(top: 10.h, right: 16.w, left: 16.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            Widget child = Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.w),
              ),
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          thing.id ?? "",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 21.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text.rich(
                          TextSpan(children: [
                            TextSpan(
                              text: "创建人:",
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            WidgetSpan(
                                child: TargetText(
                                  userId: thing.creater ?? "",
                                  style: TextStyle(fontSize: 18.sp),
                                ),
                                alignment: PlaceholderAlignment.middle)
                          ]),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "创建时间:${DateTime.tryParse(thing.createTime ?? '')?.format(format: "yyyy-MM-dd HH:mm")}",
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                  // popupMenuButton(),
                ],
              ),
            );
            return child;
          },
        ));
  }

  Widget popupMenuButton() {
    return Obx(() {
      List<PopupMenuItem> items = [
        const PopupMenuItem(
          value: "details",
          child: Text("详情"),
        ),
        const PopupMenuItem(
          value: "NTF",
          child: Text("生成NFT"),
        ),
      ];

//TODO:isMostUsed方法不存在 使用时要梳理逻辑
      // if (settingCtrl.store.isMostUsed(item.id!)) {
      //   items.add(
      //     const PopupMenuItem(
      //       value: "delete",
      //       child: Text("移除常用"),
      //     ),
      //   );
      // } else {
      //   items.add(
      //     const PopupMenuItem(
      //       value: "set",
      //       child: Text("设为常用"),
      //     ),
      //   );
      // }

      return CommonWidget.commonPopupMenuButton(
        onSelected: onSelected,
        items: items,
      );
    });
  }
}
