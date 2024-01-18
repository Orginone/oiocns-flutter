import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/group_nav_list/index.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/pages/home/home/logic.dart';

abstract class BaseGroupNavListController<S extends BaseGroupNavListState>
    extends BaseController<S> with GetTickerProviderStateMixin {
  BaseGroupNavListController();

  BaseGroupNavListController? previous;
  HomeController homeController = Get.find();
  @override
  void onInit() {
    // TODO: implement onInit

    initSubGroup();
    super.onInit();
    state.tabController.addListener(() {
      changeGroupIndex(state.tabController.index);
    });
    previous = BaseGroupNavListInstance().previous();
    state.bcNav.add(
        BaseBreadcrumbNavInfo(title: state.title, data: state.model.value));
    if (previous != null) {
      for (int i = previous!.state.bcNav.length - 1; i >= 0; i--) {
        state.bcNav.insert(0, previous!.state.bcNav[i]);
      }
    }
  }

  //刷新上一页数据
  void updateNav() {
    state.bcNav.last.title = state.model.value!.name;
    state.bcNav.refresh();
    try {
      previous?.state.model.refresh();
    } catch (e) {}
  }

  @override
  void onReady() {
    super.onReady();
    BaseGroupNavListInstance().put(this, tag: tag);

    var maxPosition = state.navBarController.position.maxScrollExtent;

    state.navBarController.animateTo(maxPosition,
        duration: const Duration(microseconds: 300), curve: Curves.linear);
  }

  @override
  void onClose() {
    BaseGroupNavListInstance().pop();
    state.tabController.dispose();
    super.onClose();
  }

  void pop(int index) {
    String routerName = state.bcNav[index].route;

    Get.until(
      (route) {
        if (route.settings.arguments == null) {
          return Get.currentRoute == routerName;
        }
        var args = route.settings.arguments;
        var name = args is Map ? args['data']?.name ?? '' : "";
        var id = args is Map ? args['data']?.id ?? '' : "";
        if (name == '') {
          return Get.currentRoute == routerName;
        }
        return Get.currentRoute == routerName &&
            state.bcNav[index].data?.name == name &&
            state.bcNav[index].data?.id == id;
      },
    );
  }

  void back() {
    Get.back();
  }

  void popAll() {
    pop(0);
    Get.back();
  }

  void onTopPopupMenuSelected(PopupMenuKey key) {}

  void search(str) {
    state.keyword.value = str;
  }

  void changeSearchState() {
    state.showSearch.value = !state.showSearch.value;
    if (!state.showSearch.value) {
      state.keyword.value = '';
    }
  }

  ///分组
  void initSubGroup() {
    // TODO: implement initGroup
  }

  int getTabIndex(String code) {
    // TODO: implement initGroup
    return -1;
  }

  void setTabIndex(String code) {
    int tabIndex = getTabIndex(code);
    changeGroupIndex(tabIndex);
    state.tabController.index = tabIndex;
  }

  Future<int?> showGrouping() {
    return showModalBottomSheet<int?>(
        context: context,
        backgroundColor: Colors.grey,
        constraints: BoxConstraints(maxHeight: 800.h, minHeight: 800.h),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w))),
        builder: (context) {
          return GyScaffold(
            backgroundColor: Colors.grey.shade200,
            titleName: "${state.tag}分组",
            actions: [
              TextButton(
                onPressed: () {
                  Get.toNamed(Routers.editSubGroup, arguments: {
                    "subGroup": SubGroup.fromJson(state.subGroup.value.toJson())
                  })?.then((value) {
                    if (value != null) {
                      state.subGroup.value = value;
                      state.subGroup.refresh();
                      resetTab();
                    }
                  });
                },
                child: Text(
                  "分组",
                  style: TextStyle(fontSize: 24.sp, color: Colors.black),
                ),
              )
            ],
            body: Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.w)),
              child: Obx(() {
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = state.subGroup.value.groups![index];
                    return Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade200, width: 0.5))),
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context, index);
                        },
                        title: Text(item.label!),
                      ),
                    );
                  },
                  itemCount: state.subGroup.value.groups!.length,
                );
              }),
            ),
          );
        }).then((value) {
      if (value != null) {
        changeGroupIndex(value);
      }
      return null;
    });
  }

  void changeGroupIndex(int index) {
    if (state.groupIndex.value != index) {
      state.groupIndex.value = index;
      state.tabController.index = index;
    }
  }

  void resetTab() {
    state.tabController.dispose();
    state.tabController =
        TabController(length: state.subGroup.value.groups!.length, vsync: this);
    state.tabController.index = 0;
    state.groupIndex.value = 0;
    state.tabController.addListener(() {
      changeGroupIndex(state.tabController.index);
    });
  }
}
