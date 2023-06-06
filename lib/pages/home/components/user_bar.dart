import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/icons.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/text_avatar.dart';


class UserBar extends GetView<SettingController> {
  UserBar({super.key});

  final CustomPopupMenuController _menuController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      Widget child;
      if (controller.homeEnum.value != HomeEnum.door) {
        child = _other;
      } else {
        child = _door;
      }

      return Container(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey.shade400,width: 0.4),)
        ),
        child: child,
      );
    });
  }


  Widget get _other {

    List<Widget> action = [];
    action.add( IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {},
      constraints: BoxConstraints(maxWidth: 50.w),
    ));
    if (controller.homeEnum.value == HomeEnum.chat) {
      action.add(
        CustomPopupMenu(
          menuBuilder: () => ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              color: const Color(0xFF4C4C4C),
              child: IntrinsicWidth(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: controller.menuItems
                      .map(
                        (item) => GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            controller.showAddFeatures(controller.menuItems.indexOf(item),item.targetType,item.title,item.hint);
                            _menuController.hideMenu();
                          },
                          child: Container(
                            height: 50.h,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  item.icon,
                                  size: 24.w,
                                  color: Colors.white,
                                ),
                                Expanded(
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      item.name,
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
          verticalMargin: -5.h,
          controller: _menuController,
          pressType: PressType.singleClick,
          child: const Icon(Icons.add),
        ),
      );
      action.add(
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {},
          constraints: BoxConstraints(maxWidth: 40.w),
        ),
      );
    }

    return SizedBox(
      height: 74.h,
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            controller.jumpInitiate();
          },
          constraints: BoxConstraints(maxWidth: 48.w),
        ),
        Text(
          controller.homeEnum.value.label,
          style: TextStyle(fontSize: 26.sp),
        ),
        const Expanded(child: SizedBox()),
        ...action,
      ]),
    );
  }

  Widget get _door {
    return SizedBox(
      height: 74.h,
      child: Row(children: [
        Expanded(
          child: Row(
            children: [
              Container(
                child: ImageWidget(
                  AIcons.icons['x']!['logo_not_bg'],
                  size: 30.w,
                ),
                margin: EdgeInsets.only(left: 15.w),
              ),
              Container(
                margin: EdgeInsets.only(left: 10.w),
                child: Text(
                  "资产共享云",
                  style: TextStyle(fontSize: 26.sp),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 10.w),
          child: GestureDetector(
            child: _imgAvatar(EdgeInsets.only(right: 10.w)),
            onTap: () {
              Get.toNamed(Routers.settingCenter);
            },
          ),
        ),
      ]),
    );
  }

  Widget _imgAvatar(EdgeInsets insets) {
    return Obx(() {
      dynamic avatar;
      var share = controller.provider.user?.share;
      avatar = share?.avatar?.thumbnailUint8List??AIcons.icons['x']?['defalutAvatar'];

      return Container(
          margin: insets,
          child: ImageWidget(
            avatar,
            fit: BoxFit.cover,
            size: 45.w,
            circular: true,
          ));
    });
  }
}
