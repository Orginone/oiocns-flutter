import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_ticket_provider_mixin.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';

class InfoListPageController extends GetxController
    with GetTickerProviderStateMixin {
  InfoListPageState state;

  InfoListPageController(this.state) {
    state.tabController = TabController(
        length: state.widget.infoListPageModel.tabItems.length, vsync: this);
  }

  /// 有子页签
  bool hasSubTabPage() {
    // return getActiveTab().tabItems.isNotEmpty;
    return state.widget.infoListPageModel.tabItems
        .any((element) => element.tabItems.isNotEmpty);
  }

  ///获得当前活跃页签
  TabItemsModel getActiveTab() {
    return state.activeTab ??= state.widget.infoListPageModel.tabItems.first;
  }

  ///判断是否活跃页签
  bool isActiveTab(TabItemsModel e) {
    bool isActive = false;
    state.widget.infoListPageModel.activeTabTitle ??= getActiveTab().title;
    isActive = state.widget.infoListPageModel.activeTabTitle == e.title;

    print('>>>>>>======$isActive');

    if (isActive) {
      state.activeTab = e;
    }

    return isActive;
  }

  ///获得页签数据
  List<TabItemsModel> getTabItems() {
    return state.widget.infoListPageModel.tabItems.toList();
  }

  ///切换页签
  void _changeTab() {
    state.activeTab = state
        .widget.infoListPageModel.tabItems[state.tabController?.index ?? 0];
    print('>>>>>>======${state.tabController?.index} ${state.activeTab}');
  }

  ///页签切换
  void changeTab(int index) {
    state.setState(() {
      state.activeTab = state
          .widget.infoListPageModel.tabItems[state.tabController?.index ?? 0];
      print('>>>>>>======${state.tabController?.index} ${state.activeTab}');
    });
  }

  ///是否显示子页签
  bool isShowSubTabPage() {
    return getActiveTab().tabItems.length > 1;
  }

  @override
  void onClose() {
    super.onClose();
    state.tabController?.dispose();
    // state.subTabController?.dispose();
  }
}
