import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/common/others/badge_widget.dart';
import 'package:orginone/components/widgets/common/others/keep_alive_widget.dart';
import 'package:orginone/components/widgets/tab_bar/expand_tab_bar.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/chat/chat_page.dart';
import 'package:orginone/pages/home/portal_page.dart';
import 'package:orginone/pages/relation/relation_page.dart';
import 'package:orginone/pages/store/store_page.dart';
import 'package:orginone/pages/work/work_page.dart';
import 'package:orginone/utils/load_image.dart';
import 'package:orginone/utils/log/log_util.dart';
import 'package:orginone/utils/system/update_utils.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/config/unified.dart';

/// 首页
class HomePage extends OrginoneStatefulWidget {
  @override
  HomePage({super.key, super.data});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends OrginoneStatefulState<HomePage> {
  var currentIndex = 0.obs;
  DateTime? lastCloseApp;
  @override
  void initState() {
    super.initState();
    AppUpdate.instance.update();
  }

  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    // LogUtil.d(">>>>>>>=======home");
    return WillPopScope(
        onWillPop: () async {
          if (null == data &&
              (lastCloseApp == null ||
                  DateTime.now().difference(lastCloseApp!) >
                      const Duration(seconds: 1))) {
            lastCloseApp = DateTime.now();
            ToastUtils.showMsg(msg: '再按一次退出');
            return false;
          }
          return true;
        },
        child: DefaultTabController(
            length: 5,
            initialIndex: _getTabCurrentIndex(),
            animationDuration: Duration.zero,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // if (null == data)
                      //   Container(
                      //     color: Colors.white,
                      //     child: const UserBar(),
                      //   ),
                      Expanded(
                        child: ExtendedTabBarView(
                          // shouldIgnorePointerWhenScrolling: false,
                          children: [
                            KeepAliveWidget(child: ChatPage()),
                            KeepAliveWidget(child: WorkPage()),
                            KeepAliveWidget(child: PortalPage()),
                            const KeepAliveWidget(child: StorePage()),
                            const KeepAliveWidget(child: RelationPage()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // InfoListPage(relationCtrl.relationModel),
                bottomButton(),
              ],
            )));
  }

  Widget bottomButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade400, width: 0.4),
        ),
      ),
      child: ExpandTabBar(
        tabs: [
          ExtendedTab(child: button(homeEnum: HomeEnum.chat, path: 'chat')),
          ExtendedTab(child: button(homeEnum: HomeEnum.work, path: 'work')),
          ExtendedTab(child: button(homeEnum: HomeEnum.door, path: 'home')),
          ExtendedTab(child: button(homeEnum: HomeEnum.store, path: 'store')),
          ExtendedTab(
            child: button(homeEnum: HomeEnum.relation, path: 'relation'),
          ),
        ],
        onTap: (index) {
          LogUtil.d(">>>>====ModelTabs.onTap");
          jumpTab(HomeEnum.values[index]);
        },
        indicator: const BoxDecoration(),
      ),
    );
  }

  Widget button({
    required HomeEnum homeEnum,
    required String path,
  }) {
    return Obx(() {
      var isSelected = relationCtrl.homeEnum == homeEnum;
      // LogUtil.d('>>>>>>>======$isSelected ${relationCtrl.homeEnum} $homeEnum');
      var mgsCount = 0;
      if (homeEnum == HomeEnum.work) {
        mgsCount = relationCtrl.provider.work?.todos.length ?? 0;
      } else if (homeEnum == HomeEnum.chat) {
        mgsCount = relationCtrl.noReadMgsCount.value;
      }
      return BadgeTabWidget(
        imgPath: path,
        foreColor: isSelected ? XColors.selectedColor : XColors.doorDesGrey,
        body: Text(homeEnum.label),
        mgsCount: mgsCount,
      );
    });
  }

  void jumpTab(HomeEnum relation) {
    relationCtrl.homeEnum.value = relation;
    RoutePages.clearRoute();
    setState(() {});
    // RoutePages.jumpHome(home: relation, preventDuplicates: true);
  }

  int _getTabCurrentIndex() {
    return HomeEnum.values
        .indexWhere((element) => element == relationCtrl.homeEnum.value);
  }

  @override
  List<Widget>? buildButtons(BuildContext context, dynamic data) {
    if (relationCtrl.homeEnum == HomeEnum.work) {
      return XImage.operationIcons([
        XImage.search,
        XImage.scan,
        XImage.startWork,
      ]);
    } else if (relationCtrl.homeEnum == HomeEnum.store) {
      return XImage.operationIcons([
        XImage.addStorage,
        XImage.search,
      ]);
    } else if (relationCtrl.homeEnum == HomeEnum.relation) {
      return XImage.operationIcons([
        XImage.joinGroup,
        XImage.search,
      ]);
    }
    return null;
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   state.tabController = TabController(
  //       length: 5,
  //       vsync: this,
  //       initialIndex: 2,
  //       animationDuration: Duration.zero);
  //   state.tabController.addListener(() {
  //     LogUtil.d('>>>>====${state.tabController.index}');
  //     if (relationCtrl.homeEnum.value.index != state.tabController.index) {
  //       relationCtrl.homeEnum.value =
  //           HomeEnum.values[state.tabController.index];
  //     }
  //   });
  //   if (Get.arguments ?? false) {
  //     EventBusUtil.instance.fire(UserLoaded());
  //   }
  // }

  // @override
  // void onReady() {
  //   // TODO: implement onReady
  //   super.onReady();
  //   AppUpdate.instance.update();
  // }

  // @override
  // void onReceivedEvent(event) {
  //   if (event is ShowLoading) {
  //     if (event.isShow) {
  //       // LoadingDialog.showLoading(Get.context!, msg: "加载数据中");
  //     } else {
  //       LoadingDialog.dismiss(Get.context!);
  //     }
  //   }
  //   if (event is StartLoad) {
  //     EventBusUtil.instance.fire(UserLoaded());
  //   }
  // }

  // @override
  // void onClose() {
  //   state.tabController.dispose();
  //   super.onClose();
  // }
}
