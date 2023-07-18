import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/controller/setting/user_controller.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/home/home/logic.dart';
import 'package:orginone/pages/store/state.dart';
import 'package:orginone/util/icons.dart';
import 'package:orginone/widget/image_widget.dart';

import 'search_bar.dart';

class UserBar extends GetView<UserController> {
  UserBar({super.key});

  final CustomPopupMenuController _menuController = CustomPopupMenuController();

  final CustomPopupMenuController _settingController = CustomPopupMenuController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(color: Colors.grey.shade400, width: 0.4),
        )),
        child: _userBar,
      );
    });
  }

  Widget get _userBar {
    List<Widget> action = [];
    action.add(IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        SearchBar? search;
        switch (controller.homeEnum.value) {
          case HomeEnum.chat:
            search = SearchBar<IMsgChat>(
                homeEnum: HomeEnum.chat, data: controller.chat.allChats);
            break;
          case HomeEnum.work:
            search = SearchBar<IWorkTask>(
                homeEnum: HomeEnum.work, data: controller.work.todos);
            break;
          case HomeEnum.door:
            // TODO: Handle this case.
            break;
          case HomeEnum.store:
            search = SearchBar<RecentlyUseModel>(homeEnum: HomeEnum.store, data: controller.store.recent);
            break;
          case HomeEnum.setting:
            search = SearchBar<int>(homeEnum: HomeEnum.setting, data: []);
            break;
        }
        if (search != null) {
          showSearch(context: Get.context!, delegate: search);
        }
      },
      constraints: BoxConstraints(maxWidth: 50.w),
    ));
    action.add(IconButton(
      icon: const Icon(Ionicons.qr_code_sharp),
      onPressed: () {
        controller.qrScan();
      },
    ));
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
                          _menuController.hideMenu();
                          controller.showAddFeatures(item);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                item.shortcut.icon,
                                size: 24.w,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    item.shortcut.label,
                                    style: TextStyle(
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
        controller: _settingController,
        pressType: PressType.singleClick,
        child: const Icon(Icons.add),
      ),
    );
    action.add(
      CustomPopupMenu(
        menuBuilder: () => ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            color: const Color(0xFF4C4C4C),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: SettingEnum.values
                    .map(
                      (item) => GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          _menuController.hideMenu();
                          controller.jumpSetting(item);
                        },
                        child: Container(
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
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
        child: const Icon(Icons.more_vert),
      ),
    );

    return SizedBox(
      height: 74.h,
      child: Row(children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: GestureDetector(
                child: _imgAvatar(EdgeInsets.only(left: 10.w)),
                onTap: () {
                  if(controller.homeEnum.value == HomeEnum.door){
                    var home = Get.find<HomeController>();
                    home.jumpTab(HomeEnum.setting);
                  }else{
                    controller.jumpInitiate();
                  }
                },
              ),
            ),
            SizedBox(width: 10.w,),
            Text(
              controller.homeEnum.value.label,
              style: TextStyle(fontSize: 24.sp),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        ...action,
      ]),
    );
  }

  Widget _imgAvatar(EdgeInsets insets) {
    return Obx(() {
      dynamic avatar;
      var share = controller.provider.user?.share;
      avatar = share?.avatar?.thumbnailUint8List ??
          AIcons.icons['x']?['defalutAvatar'];

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
