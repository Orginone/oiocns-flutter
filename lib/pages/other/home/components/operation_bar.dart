import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/forms.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';

class OperationBar extends StatelessWidget {
  const OperationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double x = 0, y = 0;
    return Container(
      color: XColors.navigatorBgColor,
      height: 62.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: 25.w)),
          Container(
            margin: EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              child: const Icon(Icons.search, color: Colors.black),
              onTap: () {
                Get.toNamed(Routers.search);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              child: const Icon(Icons.add, color: Colors.black),
              onPanDown: (position) {
                x = position.globalPosition.dx;
                y = position.globalPosition.dy;
              },
              onTap: () {
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(
                    x - 20.w,
                    y + 20.h,
                    x + 20.w,
                    y + 40.h,
                  ),
                  items: _popupMenus(context),
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10.w, right: 20.w),
            child: const Icon(Icons.more_horiz, color: Colors.black),
          ),
        ],
      ),
    );
  }

  List<PopupMenuEntry> _popupMenus(BuildContext context) {
    return [
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.qr_code_scanner,
          "扫一扫",
          () async {
            Get.toNamed(Routers.scanning);
          },
        ),
      ),
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.group_add_outlined,
          "创建群组",
          () {
            Get.toNamed(
              Routers.form,
              arguments: CreateCohort((value) {
                if (Get.isRegistered<SettingController>()) {
                  Get.find<SettingController>()
                      .user
                      ?.create(TargetModel.fromJson(value))
                      .then((value) => Get.back());
                }
              }),
            );
          },
        ),
      ),
      PopupMenuItem(
        child: _popMenuItem(
          context,
          Icons.groups_outlined,
          "创建单位",
          () {
            Get.toNamed(
              Routers.form,
              arguments: CreateCompany((value) {
                if (Get.isRegistered<SettingController>()) {
                  Get.find<SettingController>()
                      .user
                      ?.create(TargetModel.fromJson(value))
                      .then((value) => Get.back());
                }
              }),
            );
          },
        ),
      ),
    ];
  }

  Widget _popMenuItem(
    BuildContext context,
    IconData icon,
    String text,
    Function func,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.pop(context);
        func();
      },
      child: SizedBox(
        height: 40.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            Container(
              margin: EdgeInsets.only(left: 20.w),
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
