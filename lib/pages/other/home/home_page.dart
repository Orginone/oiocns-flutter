import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_treeview/flutter_treeview.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:signalr_core/signalr_core.dart';

const String globalBreadCrumb = "globalBreadCrumb";

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return OrginoneScaffold(
      resizeToAvoidBottomInset: false,
      appBarElevation: 0,
      appBarHeight: 0,
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return Column(children: [
      _title(context),
      _view(),
      _navigator(),
    ]);
  }

  initPermission(BuildContext context) async {
    await [Permission.storage, Permission.notification].request();
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
              Routers.maintain,
              arguments: CreateCohort((value) {
                if (Get.isRegistered<TargetController>()) {
                  var targetCtrl = Get.find<TargetController>();
                  targetCtrl.createCohort(value).then((value) => Get.back());
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
              Routers.maintain,
              arguments: CreateCompany((value) {
                if (Get.isRegistered<TargetController>()) {
                  var targetCtrl = Get.find<TargetController>();
                  targetCtrl.createCompany(value).then((value) => Get.back());
                }
              }),
            );
          },
        ),
      ),
    ];
  }

  Widget _title(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          TabCombine tab = controller.tabs[controller.tabIndex.value];
          if (controller.center == tab) {
            return Column(
              children: [
                Container(
                  color: UnifiedColors.navigatorBgColor,
                  height: 74.h,
                  child: _workSpace,
                ),
                Divider(height: 1.h, color: Colors.white),
              ],
            );
          }
          return Container();
        }),
        _operation(context),
      ],
    );
  }

  Widget _operation(BuildContext context) {
    double x = 0, y = 0;
    return Container(
      color: XColors.navigatorBgColor,
      height: 62.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.only(left: 25.w)),
          GestureDetector(
            onTap: () {
              controller.routerOpened.value = !controller.routerOpened.value;
            },
            child: Obx(() {
              if (controller.routerOpened.value) {
                return const Icon(Icons.close, color: Colors.black);
              } else {
                return const Icon(
                  Icons.read_more_outlined,
                  color: Colors.black,
                );
              }
            }),
          ),
          Expanded(child: _globalBreadcrumbs),
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

  Widget _conn(HubConnectionState status, String name) {
    Color color;
    switch (status) {
      case HubConnectionState.connecting:
      case HubConnectionState.disconnecting:
      case HubConnectionState.reconnecting:
        color = Colors.yellow;
        break;
      case HubConnectionState.connected:
        color = Colors.greenAccent;
        break;
      case HubConnectionState.disconnected:
        color = Colors.redAccent;
        break;
    }
    return Row(
      children: [
        Icon(Icons.circle, size: 10, color: color),
        Container(margin: EdgeInsets.only(left: 5.w)),
        Text(name, style: text10Bold),
      ],
    );
  }

  get _globalBreadcrumbs => Row(
        children: [
          Padding(padding: EdgeInsets.only(left: 25.w)),
          Expanded(
            child: Hero(
              tag: globalBreadCrumb,
              child: BreadCrumb(
                stackBottomStyle: TextStyle(
                  fontSize: 18.sp,
                  color: UnifiedColors.themeColor,
                ),
                stackTopStyle: TextStyle(fontSize: 18.sp),
                controller: controller.breadCrumbController,
                splitWidget: Container(
                  margin: EdgeInsets.only(left: 6.w, right: 6.w),
                  child: Icon(Icons.circle, size: 6.w),
                ),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(right: 25.w))
        ],
      );

  Widget _view() {
    return Obx(() {
      if (controller.routerOpened.value) {
        return _router();
      } else {
        return Expanded(
          child: GFTabBarView(
            controller: controller.tabController,
            children: controller.tabs.map((e) => e.tabView).toList(),
          ),
        );
      }
    });
  }

  Widget _navigator() {
    return Obx(() {
      if (controller.routerOpened.value) {
        return Container();
      } else {
        return _bottomNavigatorBar;
      }
    });
  }

  Widget _router() {
    return TreeView(
      controller: controller.treeViewController,
      shrinkWrap: true,
    );
  }

  get _bottomNavigatorBar => Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(width: 0.5, color: Colors.black12)),
          boxShadow: [
            BoxShadow(
              color: Color(0xFFE8E8E8),
              offset: Offset(8, 8),
              blurRadius: 10,
              spreadRadius: 1,
            )
          ],
        ),
        child: GFTabBar(
          tabBarHeight: 84.h,
          indicatorColor: Colors.blueAccent,
          tabBarColor: UnifiedColors.easyGrey,
          labelColor: Colors.black,
          labelStyle: const TextStyle(fontSize: 12),
          length: controller.tabController.length,
          controller: controller.tabController,
          tabs: controller.tabs.map((item) => item.toTab()).toList(),
        ),
      );
}

class HomeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var messageCtrl = Get.find<MessageController>();
  var organizationCtrl = Get.find<OrganizationController>();
  var fileCtrl = Get.find<FileController>();

  /// 全局面包屑
  var breadCrumbController = BreadCrumbController<String>(topNode: topPoint);

  /// Tab 控制器
  late List<TabCombine> tabs;
  late TabController tabController;
  late RxInt tabIndex;
  late TabCombine message, relation, center, work, my;

  /// 路由切换
  late RxBool routerOpened;
  late TreeViewController treeViewController;

  @override
  void onInit() {
    super.onInit();
    _initTabs();
    _initRouter();
  }

  _initRouter() {
    routerOpened = false.obs;

    Queue<Item<String>> queue = Queue.of(topPoint.children);
    Map<String, tree_view.Node<Item<String>>> map = {};
    List<tree_view.Node<Item<String>>> ans = [];
    while (queue.isNotEmpty) {
      var point = queue.removeFirst();
      var node = tree_view.Node(
        key: point.id,
        label: point.label,
        data: point,
        children: [],
      );
      map[point.id] = node;
      if (point.parent == topPoint) {
        ans.add(node);
      } else {
        var parentNode = map[point.parent!.id];
        parentNode!.children.add(node);
      }
      queue.addAll(point.children);
    }

    treeViewController = TreeViewController(children: ans);
  }

  @override
  void onReady() async {
    super.onReady();

    // 获取当前 apk 版本
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    // 获取当前上传的 apk 版本
    Map<String, dynamic> apkDetail = await fileCtrl.apkDetail();

    // 弹出更新框
    if (apkDetail["version"] != version) {
      var versionEntry = await fileCtrl.versionList();
      if (versionEntry != null && (versionEntry.versionMes ?? []).isNotEmpty) {
        //筛选出当前最新版本
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        String appName = packageInfo.appName;
        int versionCode = int.parse(packageInfo.buildNumber);
        debugPrint("appName:$appName versionCode:$versionCode");
        for (VersionVersionMes element in (versionEntry.versionMes ?? [])) {
          if (appName == element.appName) {
            if (element.version! > versionCode) {
              //有新版本弹框提示
              showAnimatedDialog(
                context: navigatorKey.currentContext!,
                barrierDismissible: true,
                animationType: DialogTransitionType.fadeScale,
                builder: (BuildContext context) {
                  return UpdaterDialog(
                    icon: element.uploadName?.shareLink ?? '',
                    version: "${element.version}",
                    path: element.shareLink ?? '',
                    content: element.remark ?? '',
                  );
                },
              );
            }
          }
        }
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
    Kernel.getInstance.stop();
    breadCrumbController.dispose();
    tabController.dispose();
  }

  void _initTabs() {
    var size = Size(32.w, 32.w);
    message = TabCombine(
      customTab: _buildTabTick(
          AImage.localImage(
            "chat",
            size: Size(38.w, 32.w),
          ),
          "沟通"),
      tabView: const MessagePage(),
      breadCrumbItem: chatPoint,
    );
    relation = TabCombine(
      body: Text('办事', style: text14),
      tabView: const AffairsPage(),
      icon: AImage.localImage("work", size: size),
      breadCrumbItem: workPoint,
    );
    center = TabCombine(
      iconMargin: EdgeInsets.zero,
      body: AImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      tabView: const CenterPage(),
      breadCrumbItem: centerPoint,
    );
    work = TabCombine(
      body: Text('仓库', style: text14),
      tabView: const ApplicationPage(),
      icon: AImage.localImage("warehouse", size: size),
      breadCrumbItem: warehousePoint,
    );
    my = TabCombine(
      body: Text('设置', style: text14),
      tabView: SetHomePage(),
      icon: AImage.localImage("setting", size: size),
      breadCrumbItem: settingPoint,
    );

    tabs = <TabCombine>[message, relation, center, work, my];
    tabIndex = tabs.indexOf(center).obs;
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: tabIndex.value,
    );
    breadCrumbController.redirect(centerPoint);
    int preIndex = tabController.index;
    tabController.addListener(() {
      if (preIndex == tabController.index) {
        return;
      }
      tabIndex.value = tabController.index;
      breadCrumbController.redirect(tabs[tabIndex.value].breadCrumbItem!);
      preIndex = tabController.index;
    });
  }

  Widget _buildTabTick(Widget icon, String label) {
    return Obx(() => SizedBox(
          width: 200.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Tab(
                  iconMargin: const EdgeInsets.all(4),
                  icon: icon,
                  child: Text(label, style: text14),
                ),
              ),
              Positioned(
                right: 0,
                child: messageCtrl.hasNoRead()
                    ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
                    : Container(),
              ),
            ],
          ),
        ));
  }
}
