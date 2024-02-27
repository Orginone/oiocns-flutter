import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/controller/index.dart';

import 'package:orginone/utils/load_image.dart';

class UserBar extends GetView<IndexController> {
  ///实体/对象
  dynamic data;

  ///标题
  String title;

  ///操作按钮
  List<Widget>? actions;

  UserBar({super.key, this.title = "", this.data, this.actions});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        child: _userBar,
      );
    });
  }

  ///AppBar
  Widget get _userBar {
    return SizedBox(
      height: 74.h,
      child: <Widget>[
        _userAvatarWidget(),
        _actionsWidge(),
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    );
  }

  ///用户头像
  Row _userAvatarWidget() {
    return Row(
      children: [
        _createCustomPopupMenu(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: _createImgAvatar(EdgeInsets.only(left: 10.w),
                  size: 44, circular: false, radius: 8.w),
            ),
            children: [
              settingMenuHeaderWidget(),
              ...SettingEnum.values
                  .map(
                    (item) => settingMenuItemWidget(item),
                  )
                  .toList()
            ],
            controller: controller.functionMenuController),
        Text(
          controller.homeEnum.value.label,
          style: AppTextStyles
              .titleLarge, //?.copyWith(fontWeight: FontWeight.w900)
        ).paddingLeft(AppSpace.listRow),
      ],
    );
  }

  ///设置菜单头部 用户信息
  settingMenuHeaderWidget() {
    return GestureDetector(
      onTap: () {
        controller.functionMenuController.hideMenu();
        Get.toNamed(Routers.userInfo);
      },
      child: Row(
        children: [
          _createImgAvatar(
              EdgeInsets.only(left: 15.h, right: 5.w, top: 10.w, bottom: 10.w),
              size: 44,
              circular: false,
              radius: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 240.w,
                child: Row(
                  children: [
                    TextWidget(
                      text: controller.provider.user?.metadata.name ?? "",
                      style: AppTextStyles.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w900),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10.w),
                        alignment: Alignment.centerRight,
                        child: IconButton(
                          onPressed: () {
                            controller.functionMenuController.hideMenu();
                            Get.toNamed(
                              Routers.shareQrCode,
                              arguments: {"entity": controller.user?.metadata},
                            );
                          },
                          icon: Icon(
                            Ionicons.qr_code_outline,
                            size: 24.w,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(maxHeight: 24.w),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 240.w,
                child: Text(
                  controller.provider.user?.metadata.remark ?? "",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            ],
          )
        ],
      ).paddingTop(AppSpace.listItem).paddingRight(AppSpace.listItem),
    );
  }

  ///设置弹框的item
  settingMenuItemWidget(SettingEnum item) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.functionMenuController.hideMenu();
        controller.jumpSetting(item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              item.icon,
              size: 24.w,
              color: Colors.black,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10.w),
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Text(
                  item.label,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.sp,
                  ),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
            )
          ],
        ),
      ),
    );
  }

  ///右侧++++++++++++++++++++++++++++++++++++++++++++++++
  ///右侧事件
  _actionsWidge() {
    return <Widget>[
      ...actions ??
          XImage.operationIcons([
            XImage.search,
            XImage.scan,
            XImage.add,
          ]), //[searchWidget, qrScanWidget, moreWidget],
      const SizedBox(
        width: 10,
      ),
    ].toRow();
  }

  ///公用构建方法
  ///弹出菜单构建
  Widget _createCustomPopupMenu({
    CustomPopupMenuController? controller,
    required Widget child,
    required List<Widget> children,
  }) {
    return CustomPopupMenu(
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ).paddingAll(AppSpace.listView),
      ),
      controller: controller,
      pressType: PressType.singleClick,
      showArrow: false,
      child: child.clipRRect(all: AppSpace.button),
    );
  }

  ///头像
  Widget _createImgAvatar(EdgeInsets insets,
      {BoxFit fit = BoxFit.cover,
      bool circular = true,
      double size = 44,
      double? radius}) {
    return Obx(() {
      dynamic avatar = XImage.entityIcon(
        controller.provider.user,
        width: size.w,
        circular: circular,
        radius: radius,
        fit: fit,
      );

      return Container(margin: insets, child: avatar);
    });
  }
}
