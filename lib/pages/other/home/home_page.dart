import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/pages/chat/message_page.dart';
import 'package:orginone/pages/other/assets_config.dart';
import 'package:orginone/pages/other/home/components/user_bar.dart';
import 'package:orginone/pages/other/work/view.dart';
import 'package:orginone/pages/setting/set_home_page.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/util/department_management.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/load_image.dart';
import 'package:orginone/util/sys_util.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import '../home/ware_house/ware_house.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SysUtil.setStatusBarBright();
    return OrginoneScaffold(
      resizeToAvoidBottomInset: false,
      appBarElevation: 0,
      appBarHeight: 0,
      body: Tabs(
        tabCtrl: controller.tabController,
        top: const UserBar(),
        views: controller.tabs.map((e) => e.toTabView()).toList(),
        bottom: TabBar(
          controller: controller.tabController,
          tabs: controller.tabs.map((item) => item.toTab()).toList(),
        ),
      ),
    );
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}

class HomeController extends TabsController {
  var chatCtrl = Get.find<ChatController>();

  @override
  initTabs() {
    var size = Size(32.w, 32.w);
    registerTab(XTab(
      body: Text("沟通", style: XFonts.size14Black3),
      view: const MessagePage(),
      icon: XImage.localImage("chat", size: Size(38.w, 32.w)),
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Obx(() {
            var chatCtrl = Get.find<ChatController>();
            return chatCtrl.hasNoRead()
                ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
                : Container();
          }),
        )
      ],
    ));
    registerTab(XTab(
      body: Text('办事', style: XFonts.size14Black3),
      view: WorkPage(),
      icon: XImage.localImage("work", size: size),
    ));
    var center = XTab(
      body: XImage.localImage("logo_not_bg", size: Size(36.w, 36.w)),
      // view: IndexPage(),
      // view: LineChartSample(),
      // view: BarChartWidget(),
      // view: PieChartSample(),
      // view: PieChartWidget(),
      view: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        crossAxisCount: 5,
        childAspectRatio: 80 / 100,
        children: items.map((item) {

          return GestureDetector(
            onTap: () {
              Get.toNamed(Routers.centerFunction, arguments: {"info": item});
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 80.w,
                  height: 80.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40.w)),
                    color: Colors.white,
                  ),
                  child: Image.network(item.iconUrl,),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6.5.w),
                  child: Text(item.name, style: XFonts.size22Black3),
                ),
              ],
            ),
          );
        }).toList(),
      ),
      iconMargin: EdgeInsets.zero,
    );
    registerTab(center);
    registerTab(XTab(
      body: Text('仓库', style: XFonts.size14Black3),
      view: const WareHouse(),
      icon: XImage.localImage("warehouse", size: size),
    ));
    registerTab(XTab(
      body: Text('设置', style: XFonts.size14Black3),
      view: SetHomePage(),
      icon: XImage.localImage("setting", size: size),
    ));
    setIndex(tabs.indexOf(center));
  }

  Future<void> loadData() async {
    try {
      if (KernelApi.getInstance().anystore.isOnline) {
        log('连接成功---------${KernelApi.getInstance().anystore.isOnline}');
        ToastUtils.showMsg(msg: "连接成功 开始加载数据");
        await Future.wait([
          AssetManagement().initAssets(),
          DepartmentManagement().initDepartment(),
          CommonTreeManagement().initTree(),
        ]);
        log('数据加载完成');
        ToastUtils.showMsg(msg: "加载数据成功");
      } else {
        await Future.delayed(Duration(milliseconds: 200), () async {
          log('尝试重新连接---------${KernelApi.getInstance().anystore.isOnline}');
          await initData();
        });
      }
    } catch (e) {
      ToastUtils.showMsg(msg: e.toString());
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    EventBusHelper.register(this, (event) async {
      if (event is InitHomeData) {
        await initData();
      }
    });
  }

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    await initData();
  }

  Future<void> initData() async {
    LoadingDialog.showLoading(Get.context!, msg: "加载数据中");
    await loadData();
    LoadingDialog.dismiss(Get.context!);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    EventBusHelper.unregister(this);
  }
}

class CenterItem {
  final String name;
  final String iconUrl;
  final AssetsType type;

  CenterItem(this.name, this.iconUrl, this.type);
}

final List<CenterItem> items = [
  CenterItem(
      "我的资产",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-approve.png",
      AssetsType.myAssets),
  CenterItem(
      "资产申领",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-claim.png",
      AssetsType.claim),
  CenterItem(
      "资产盘点",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-check.png",
      AssetsType.check),
  CenterItem(
      "资产处置",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-dispose.png",
      AssetsType.dispose),
  CenterItem(
      "资产移交",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-transfer.png",
      AssetsType.transfer),
  CenterItem(
      "资产交回",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-transfer.png",
      AssetsType.handOver),
  CenterItem(
      "资产归还",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-dispose.png",
      AssetsType.revert),
  CenterItem(
      "资产借用",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-check.png",
      AssetsType.borrow),
  CenterItem(
      "资产申购",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-subscribe.png",
      AssetsType.subscribe),
  CenterItem(
      "审批中心",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/home-approve.png",
      AssetsType.approve),
  CenterItem(
      "巡检任务",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/inspection-icon.png",
      AssetsType.more),
  CenterItem(
      "维修上报",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/report-icon.png",
      AssetsType.more),
  CenterItem(
      "工单处理",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/work-order-icon.png",
      AssetsType.more),
  CenterItem(
      "物品领用",
      "https://gysz-nk.oss-cn-hangzhou.aliyuncs.com/assetControl/app/collect.png",
      AssetsType.more),
];
