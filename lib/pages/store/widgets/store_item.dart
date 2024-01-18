import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/config/unified.dart';

class StoreItem extends StatelessWidget {
  final RecentlyUseModel item;

  const StoreItem({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 11.h),
      child: Row(
        children: [
          item.avatar == null
              ? Container(
                  height: 80.w,
                  width: 80.w,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFF17BC84),
                    borderRadius: BorderRadius.circular(16.w),
                  ),
                  child: Icon(
                    Icons.other_houses,
                    color: Colors.white,
                    size: 48.w,
                  ),
                )
              : ImageWidget(
                  item.avatar,
                  size: 80.w,
                ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.file?.name ?? item.thing?.id ?? "",
                  style: XFonts.size24Black0,
                ),
                // Text(
                //   "存储占用",
                //   style: XFonts.size18Black9,
                // )
              ],
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.w),
                border: Border.all(color: Colors.grey.shade400, width: 0.5),
              ),
              child: Text(
                "打开",
                style: XFonts.size20Black0,
              ),
            ),
            onTap: () async {
              if (item.type == 'file') {
                RoutePages.jumpFile(file: item.file!, type: 'store');
              } else {
                // var thing = item.thing;
                // IForm? form = await settingCtrl.store
                //     .findForm(thing!.species.keys.first.substring(1));
                // if (form != null) {
                //   Get.toNamed(Routers.thingDetails,
                //       arguments: {"thing": thing, 'form': form});
                // } else {
                //   ToastUtils.showMsg(msg: "未找到表单");
                // }
              }
            },
          ),
          // Obx(() {
          //   //TODO：无此方法 用到需要看逻辑
          //   PopupMenuItem popupMenuItem;
          //   if (settingCtrl.store.isMostUsed(item.id)) {
          //     popupMenuItem = PopupMenuItem(
          //       value: PopupMenuKey.removeCommon,
          //       child: Text(PopupMenuKey.removeCommon.label),
          //     );
          //   } else {
          //     popupMenuItem = PopupMenuItem(
          //       value: PopupMenuKey.setCommon,
          //       child: Text(PopupMenuKey.setCommon.label),
          //     );
          //   }
          //   return CommonWidget.commonPopupMenuButton(
          //       items: [
          //         popupMenuItem,
          //       ],
          //       onSelected: (key) {
          //         switch (key) {
          //           case PopupMenuKey.removeCommon:
          //             settingCtrl.store.removeMostUsed(item.id);
          //             break;
          //           case PopupMenuKey.setCommon:
          //             settingCtrl.store.setMostUsed(
          //                 thing: item.thing,
          //                 file: item.file,
          //                 storeEnum: item.type == "thing"
          //                     ? StoreEnum.thing
          //                     : StoreEnum.file);
          //             break;
          //         }
          //       });
          // })
        ],
      ),
    );
  }
}
